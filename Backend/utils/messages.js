export const PRODUCT_NOT_FOUND = "Product not found";

export const CATEGORY_NOT_FOUND = "Category not found";

export const CART_NOT_FOUND = "There is no cart for this user";
export const ITEM_NOT_IN_CART = "This item doesn't exist in your cart";
export const stockExceeded = (stock) =>
  `Sorry, only ${stock} items left in stock`;

export const ITEM_ADDED_TO_CART = "Item added to cart";
export const ITEM_REMOVED = "Item removed";
export const ITEM_REMOVED_FROM_CART =
  "This item is no longer available and was removed from your cart";
export const CART_UPDATED = "Cart updated";
export const CART_CLEARED = "Cart cleared";

export const WISHLIST_ADDED = "Added to wishlist";
export const WISHLIST_REMOVED = "Removed from wishlist";

export const USER_NOT_FOUND = "User not found";
export const INCORRECT_CREDENTIALS = "Incorrect email or password";

export const ORDER_CREATED = "Order created";
export const ORDER_NOT_FOUND = "No order found with this ID";
export const ORDER_NOT_AUTHORIZED =
  "You don't have permission to view this order";
export const ORDER_ITEMS_UNAVAILABLE =
  "One or more items in your cart became unavailable";
export const ORDER_MARKED_DELIVERED = "Order marked as delivered";
export const ORDER_ALREADY_DELIVERED = "This order is already delivered";
export const ORDER_CANNOT_DELIVER = "This order can't be delivered";
export const ORDER_SHIPPED = "Order shipped";
export const ORDER_ALREADY_SHIPPED = "This order is already shipped";
export const ORDER_INVALID_TRANSITION = "Invalid order status transition";
export const ORDER_CANCELLED = "Order canceled";
export const ORDER_CANNOT_CANCEL = "This order can't be canceled";
export const ORDER_ALREADY_CANCELLED = "This order is already canceled";
export const ORDER_CART_NOT_FOUND = "There is no such cart with this ID";
export const ORDER_CART_NOT_AUTHORIZED =
  "You are not authorized to create an order for this cart";

export const PROFILE_UPDATED = "Profile updated";
export const INCORRECT_CURRENT_PASSWORD =
  "The current password you entered is incorrect";
export const PASSWORD_UPDATED = "Password updated";
export const ACCOUNT_DELETE_PERMISSION =
  "You don't have permission to delete this account";
export const ACCOUNT_DELETED = "Account deleted";
export const JWT_EXPIRED = "jwt expired";
export const INVALID_TOKEN = "Invalid token. Please log in again";
export const INVALID_EXPIRED_REFRESH_TOKEN = "Invalid or expired refresh token. Please log in again";
export const INVALID_REFRESH_TOKEN = "Invalid refresh token";
export const ADDRESS_ADDED = "Address added";
export const ADDRESS_NOT_FOUND = "No address found with that ID";
export const ADDRESS_UPDATED = "Address updated";
export const ADDRESS_DELETED = "Address deleted";
