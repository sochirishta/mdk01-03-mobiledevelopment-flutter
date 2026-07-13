using System.Text.Json;
using System.Text.Json.Nodes;
using flutter_web_api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Microsoft.AspNetCore.Identity;

namespace MyApp.Namespace
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly FlutterApiDbContext _context;
        private readonly IPasswordHasher<User> _passwordHasher;

        public UsersController(FlutterApiDbContext context, IPasswordHasher<User> passwordHasher)
        {
            _context = context;
            _passwordHasher = passwordHasher;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users.OrderBy(u=>u.IdUser).ToListAsync();
        }

        [HttpPost("login")]
        public async Task<ActionResult<User>> Login(User user)
        {
            if (user.UserName == "" || user.UserPwd == "")
            {
                return BadRequest(new { message = "Вы не ввели данные" });
            }
            
            var getUser =
                await _context.Users.FirstOrDefaultAsync(
                    (u => u.UserName == user.UserName));
            
            var verificationResult = _passwordHasher.VerifyHashedPassword(
                getUser, getUser.UserPwd, user.UserPwd
            );

            if (verificationResult == PasswordVerificationResult.Failed)
            {
                return Unauthorized(new { message = "Неверное имя или пароль пользователя." });
            }

            return Ok(getUser);
        }

        [HttpPost("register")]
        public async Task<ActionResult<User>> PostUser(User user)
        {
            if (user.UserName == "" || user.UserPwd == "")
            {
                return BadRequest(new { message = "Вы не ввели данные" });
            }
            
            try
            {
                var newUser = new User
                {
                    UserName = user.UserName,
                };
                
                newUser.UserPwd = _passwordHasher.HashPassword(newUser, user.UserPwd);
                _context.Users.Add(newUser);
                await _context.SaveChangesAsync();
                return Ok(user);
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, new { message = "Пользователь с таким именем уже существует" });
            }
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<User>> UpdateUser(int id, User user)
        {
            var existingUser = await _context.Users.FindAsync(id);
            
            if (existingUser == null)
                return NotFound();

            try
            {
                existingUser.UserName = user.UserName;
                existingUser.UserPwd = _passwordHasher.HashPassword(existingUser, user.UserPwd);
                
                await _context.SaveChangesAsync();
                return Ok(existingUser);
            }
            catch (DbUpdateException)
            {
                return StatusCode(500, new { message = "Не удалось обновить даннные пользователя" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();
            
            var cartItems = await _context.Cartitems
                .Include(c => c.Product)
                .Where(c => c.UserId == id)
                .ToListAsync();
            
            foreach (var item in cartItems)
            {
                if (item.Product != null)
                {
                    item.Product.Quantity += item.Addedquantity;
                }
            }

            _context.Cartitems.RemoveRange(cartItems);
            _context.Users.Remove(user);
            
            await _context.SaveChangesAsync();
            return NoContent();
        }
        
        // GET: api/users/1
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }
    }
}