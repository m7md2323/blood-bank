namespace Domain.Interfaces;

public interface IUnitOfWork: IDisposable {

    // All chenges will be commited as one transaction.
    Task<int> SaveChangesAsync();

}