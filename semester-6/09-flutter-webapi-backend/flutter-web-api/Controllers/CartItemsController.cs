using flutter_web_api.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MyApp.Namespace
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartItemsController : ControllerBase
    {
        private readonly FlutterApiDbContext _context;

        public CartItemsController(FlutterApiDbContext context)
        {
            _context = context;
        }

        // DELETE: api/cartitems/1
        [HttpDelete("{id}")]
        public async Task<IActionResult> RemoveCartItem(int id, int quantity)
        {
            var cartItem = await _context.Cartitems.FindAsync(id);

            if (cartItem == null)
                return NotFound();

            if (quantity > cartItem.Addedquantity || quantity <= 0)
            {
                return BadRequest("Товар не найден");
            }

            var product = await _context.Products.FirstOrDefaultAsync(c => c.IdProduct == cartItem.ProductId);

            if (product == null)
                return NotFound();

            product.Quantity += quantity;
            cartItem.Addedquantity -= quantity;

            if (cartItem.Addedquantity > 0)
            {
                _context.Cartitems.Update(cartItem);
            }
            else
            {
                _context.Cartitems.Remove(cartItem);
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserCart(int userId)
        {
            var cart = await _context.Cartitems
                .Where(c => c.UserId == userId)
                .Select(c => new
                {
                    c.IdCartitem,
                    c.Addedquantity,
                    c.ProductId,
                    // Вытаскиваем только нужные Flutter данные о продукте, игнорируя связи
                    Product = new
                    {
                        c.Product.IdProduct,
                        c.Product.NameProduct,
                        c.Product.Price,
                        c.Product.Imageurl
                    }
                }).OrderBy(c=>c.IdCartitem)
                .ToListAsync();

            return Ok(cart);
        }


        // POST: api/cartitems/1
        [HttpPost("add/{productId}")]
        public async Task<ActionResult<Cartitem>> AddToCart(
            [FromRoute] int productId,
            [FromQuery] int userId,
            [FromQuery] int quantity
        )
        {
            var product = await _context.Products.FindAsync(productId);

            if (product == null)
                return NotFound("Товар не найден");

            if (quantity <= 0)
                return BadRequest("Товары не выбраны");

            if (product.Quantity < quantity)
                return BadRequest("Товар закончился");

            var cartItem =
                await _context.Cartitems.FirstOrDefaultAsync(c => c.UserId == userId && c.ProductId == productId);

            if (cartItem != null)
            {
                cartItem.Addedquantity += quantity;
                _context.Cartitems.Update(cartItem);
            }
            else
            {
                cartItem = new Cartitem
                {
                    ProductId = productId,
                    UserId = userId,
                    Addedquantity = quantity
                };
                _context.Cartitems.Add(cartItem);
            }

            product.Quantity -= quantity;

            await _context.SaveChangesAsync();
            return Ok(cartItem);
        }
    }
}