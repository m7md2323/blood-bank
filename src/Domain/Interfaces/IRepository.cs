using Domain.Entites;
using Domain.Enums;

namespace Domain.Interfaces;


public interface IRepository<T> where T : class{

    Task<T?> GetByIdAsync(Guid id);
    Task<IReadOnlyList<T>> GetAllAsync();

    Task<IReadOnlyList<T>> ListAsync(ISpecification<T> spec, CancellationToken ct = default);
    Task<T?> GetBySpecAsync(ISpecification<T> spec, CancellationToken ct = default);
    Task<int> CountAsync(ISpecification<T> spec, CancellationToken ct = default);
    
    Task AddAsync(T Entity,CancellationToken ct = default);
    void Update(T Entity);
    void Delete(T Entity); 

}

