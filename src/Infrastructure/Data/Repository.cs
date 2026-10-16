using Domain.Interfaces;
using Domain.Specifications;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data;

public class Repository<T> : IRepository<T> where T : class {

    protected readonly ApplicationDbContext _context;

    public Repository(ApplicationDbContext context){
        _context = context;
    }

    // Private helper method for simplifing the calling of SepcificationEvaluator
    private IQueryable<T> ApplySpecification(ISpecification<T> spec){
            
        return SpecificationEvaluator.GetQuery(_context.Set<T>().AsQueryable(),spec);  
    }

    public async Task<T?> GetByIdAsync(Guid id){
        return await _context.Set<T>().FindAsync(id);
    }

    public async Task<IReadOnlyList<T>> GetAllAsync(){
        return await _context.Set<T>().ToListAsync();
    }

    public async Task<IReadOnlyList<T>> ListAsync(ISpecification<T> spec, CancellationToken ct = default){
        return await ApplySpecification(spec).ToListAsync(ct);
    }

    public async Task<T?> GetBySpecAsync(ISpecification<T> spec, CancellationToken ct = default){
        return await ApplySpecification(spec).FirstOrDefaultAsync(ct);
    }

    public async Task<int> CountAsync(ISpecification<T> spec, CancellationToken ct = default){
        return await ApplySpecification(spec).CountAsync(ct);
    }


    public async Task AddAsync(T entity,CancellationToken ct = default){
        await _context.Set<T>().AddAsync(entity,ct);
    }

    public void Update(T entity){
        _context.Set<T>().Update(entity);
    }

    public void Delete(T entity){
        _context.Set<T>().Remove(entity);
    }

}