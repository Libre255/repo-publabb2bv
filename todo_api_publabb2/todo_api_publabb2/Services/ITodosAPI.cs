namespace todo_api_publabb2.Services
{
    public interface ITodosAPI
    {
        Task<List<Todo>> GetAllTodos();
        Task<Todo?> GetSingleTodo(int id);
        Task<List<Todo>> AddTodo(Todo hero);
        Task<List<Todo>?> UpdateTodo(int id, Todo request);
        Task<List<Todo>?> DeleteTodo(int id);
    }
}
