"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.API_ROUTES = exports.APP_CONFIG = void 0;
exports.APP_CONFIG = {
    APP_NAME: "ফ্রেশ কর্নার",
    APP_NAME_EN: "Fresh Corner",
    DEFAULT_DELIVERY_CHARGE: 30,
    MIN_ORDER_AMOUNT: 200,
    CLOUDINARY_FOLDER: "fresh-corner",
    CLOUDINARY_PRODUCTS_FOLDER: "fresh-corner/products",
    CLOUDINARY_CATEGORIES_FOLDER: "fresh-corner/categories",
};
exports.API_ROUTES = {
    AUTH: "/api/auth",
    PRODUCTS: "/api/products",
    CATEGORIES: "/api/categories",
    ORDERS: "/api/orders",
    PAYMENT: "/api/payment",
    UPLOAD: "/api/upload",
    DELIVERY: "/api/delivery",
    USERS: "/api/users",
    SETTINGS: "/api/settings",
};
