using Domain.Entities;
using Domain.Interfaces;
using Domain.Specifications;

namespace Application.Features.Donations;

public class DonationService : IDonationService
{
    private readonly IUnitOfWork _unitOfWork;
    public DonationService(IUnitOfWork unitOfWork){
        _unitOfWork = unitOfWork;
    }

    public async Task<IReadOnlyList<VisitResponse>> GetUserVisitsAsync(Guid userId, CancellationToken ct)
    {
        var user = await _unitOfWork.Users.GetByIdAsync(userId);

        if (user == null)
            throw new KeyNotFoundException($"User with ID '{userId}' was not found.");

        var donationsSpec = new DonationsByDonorSpec(userId);
        donationsSpec.Includes.Add(entity => entity.Hospital!);
        donationsSpec.Includes.Add(entity => entity.BloodBank!);

        var appointmentsSpec = new AppointmentsByUserSpec(userId);
        appointmentsSpec.Includes.Add(entity => entity.BloodBank);

        var donations = await _unitOfWork.Donations.ListAsync(donationsSpec, ct);
        var appointments = await _unitOfWork.DonationAppointments.ListAsync(appointmentsSpec, ct);

        var visits = donations.Select(donation => new VisitResponse(
            donation.Id,
            donation.DonationDate,
            "Blood Donation",
            donation.Hospital?.Name ?? donation.BloodBank?.Name ?? string.Empty,
            "Completed"
        )).Concat(appointments.Select(appointment => new VisitResponse(
            appointment.Id,
            appointment.ScheduledDate,
            "Blood Donation",
            appointment.BloodBank.Name,
            appointment.Status.ToString()
        )));

        return visits.OrderByDescending(visit => visit.VisitDate).ToList();
    }

    public async Task<bool> BookDonationAsync(Guid userId, BookDonationAppointmentDto dto, CancellationToken ct)
    {
        var donor = await _unitOfWork.Users.GetByIdAsync(userId);

        if(donor == null || donor.IsDeleted)
            return false;

        if(dto == null || dto.BloodBankId == Guid.Empty || dto.AppointmentDate <= DateTime.UtcNow)
            return false;

        var donatedUnits = await _unitOfWork.BloodUnits.ListAsync(new BloodUnitsByDonorSpec(userId), ct);
        donor.DonatedUnits = donatedUnits.ToList();

        if(!donor.IsEligibleToDonate())
            return false;

        var bloodBank = await _unitOfWork.BloodBanks.GetByIdAsync(dto.BloodBankId);

        // An existing blood bank record is considered verified.
        if(bloodBank == null)
            return false;

        var appointment = new DonationAppointment
        {
            UserId = donor.Id,
            BloodBankId = bloodBank.Id,
            ScheduledDate = dto.AppointmentDate
        };

        await _unitOfWork.DonationAppointments.AddAsync(appointment, ct);
        await _unitOfWork.SaveChangesAsync();

        return true;
    }
}
