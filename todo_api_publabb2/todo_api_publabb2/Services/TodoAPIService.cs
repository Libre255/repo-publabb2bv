using todo_api_publabb2.Data;

namespace todo_api_publabb2.Services
{
    public class TodoAPIService :ITodosAPI
    {
        private readonly DataContext _context;

        public TodoAPIService(DataContext context)
        {
            _context = context;
        }

        public async Task<List<Todo>> AddTodo(Todo _todo)
        {
            _context.Todos.Add(_todo);
            await _context.SaveChangesAsync();
            return await _context.Todos.ToListAsync();
        }

        public async Task<List<Todo>?> DeleteTodo(int id)
        {
            var _Todo = await _context.Todos.FindAsync(id);
            if (_Todo is null)
                return null;

            _context.Todos.Remove(_Todo);
            await _context.SaveChangesAsync();

            return await _context.Todos.ToListAsync();
        }

        public async Task<List<Todo>> GetAllTodos()
        {
            var Todos = await _context.Todos.ToListAsync();
            return Todos;
        }

        public async Task<Todo?> GetSingleTodo(int id)
        {
            var Todos = await _context.Todos.FindAsync(id);
            if (Todos is null)
                return null;

            return Todos;
        }

        public async Task<List<Todo>?> UpdateTodo(int id, Todo request)
        {
            var _todos = await _context.Todos.FindAsync(id);
            if (_todos is null)
                return null;

            _todos.title = request.title;
            _todos.content = request.content;
            _todos.done = request.done;

            await _context.SaveChangesAsync();

            return await _context.Todos.ToListAsync();
        }
    }
}

