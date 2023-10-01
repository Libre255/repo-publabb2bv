global using Microsoft.EntityFrameworkCore;

namespace todo_api_publabb2.Data
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base(options)
        {

        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            optionsBuilder.UseSqlServer("Server=(localdb)\\MSSQLLocalDB;Database=tododb;Trusted_Connection=true;TrustServerCertificate=true;");
        }

        public DbSet<Todo> Todos { get; set; }
    }
}
