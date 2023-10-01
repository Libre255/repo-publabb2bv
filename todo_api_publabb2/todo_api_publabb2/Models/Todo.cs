using System.ComponentModel.DataAnnotations;

namespace todo_api_publabb2.Models
{
    public class Todo {
        [Key]
        public string id { get; set; } = Guid.NewGuid().ToString();
        public string title { get; set; }
        public string content { get; set; }
        public bool done { get; set; }
    }
}
