/// Table: analytics events

// Table name constants for Supabase tables
class SupabaseTables {
  static const String analyticsEvents = 'analytics events';
  static const String passwordResetCodes = 'password_reset_codes';
  static const String productFlags = 'product flags';
  static const String productRating = 'product rating';
  static const String productStats = 'product stats';
  static const String productVisibilityCooldowns = 'product visibility cooldowns';
  static const String products = 'products';
  static const String profiles = 'profiles';
  static const String storeFlags = 'store flags';
  static const String storeRatings = 'store ratings';
  static const String storeStats = 'store stats';
  static const String stores = 'stores';
  static const String userProductHistory = 'user product history';
  static const String userSavedProducts = 'user saved products';
  static const String userSavedStores = 'user saved stores';
  static const String userStoreHistory = 'user store history';
  static const String orders = 'orders';
  static const String userPhotos = 'user_photos';
  static const String invoices = 'invoices';
  static const String receipts = 'receipts';
}
/// Table: receipts
///
/// CREATE TABLE public.receipts (
///   id uuid not null default gen_random_uuid (),
///   user_id uuid not null,
///   stripe_invoice_id text not null,
///   receipt_number text null,
///   amount bigint not null,
///   currency text not null,
///   status text not null,
///   receipt_pdf text null,
///   created_at timestamp with time zone null default now(),
///   constraint receipts_pkey primary key (id),
///   constraint receipts_stripe_invoice_id_key unique (stripe_invoice_id),
///   constraint receipts_user_id_fkey foreign KEY (user_id) references auth.users (id) on delete CASCADE
/// ) TABLESPACE pg_default;
class Receipt {
  final String id;
  final String userId;
  final String stripeInvoiceId;
  final String? receiptNumber;
  final int amount;
  final String currency;
  final String status;
  final String? receiptPdf;
  final DateTime? createdAt;

  Receipt({
    required this.id,
    required this.userId,
    required this.stripeInvoiceId,
    this.receiptNumber,
    required this.amount,
    required this.currency,
    required this.status,
    this.receiptPdf,
    this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        stripeInvoiceId: json['stripe_invoice_id'] as String,
        receiptNumber: json['receipt_number'] as String?,
        amount: json['amount'] is int ? json['amount'] as int : int.parse(json['amount'].toString()),
        currency: json['currency'] as String,
        status: json['status'] as String,
        receiptPdf: json['receipt_pdf'] as String?,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'stripe_invoice_id': stripeInvoiceId,
        'receipt_number': receiptNumber,
        'amount': amount,
        'currency': currency,
        'status': status,
        'receipt_pdf': receiptPdf,
        'created_at': createdAt?.toIso8601String(),
      };
}
/// Table: invoices
///
/// CREATE TABLE public.invoices (
///   id uuid not null default gen_random_uuid (),
///   user_id uuid not null,
///   stripe_invoice_id text not null,
///   invoice_number text null,
///   amount_due bigint not null,
///   currency text not null,
///   status text not null,
///   invoice_pdf text null,
///   created_at timestamp with time zone null default now(),
///   constraint invoices_pkey primary key (id),
///   constraint invoices_stripe_invoice_id_key unique (stripe_invoice_id),
///   constraint invoices_user_id_fkey foreign KEY (user_id) references auth.users (id) on delete CASCADE
/// ) TABLESPACE pg_default;
class Invoice {
  final String id;
  final String userId;
  final String stripeInvoiceId;
  final String? invoiceNumber;
  final int amountDue;
  final String currency;
  final String status;
  final String? invoicePdf;
  final DateTime? createdAt;

  Invoice({
    required this.id,
    required this.userId,
    required this.stripeInvoiceId,
    this.invoiceNumber,
    required this.amountDue,
    required this.currency,
    required this.status,
    this.invoicePdf,
    this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        stripeInvoiceId: json['stripe_invoice_id'] as String,
        invoiceNumber: json['invoice_number'] as String?,
        amountDue: json['amount_due'] is int ? json['amount_due'] as int : int.parse(json['amount_due'].toString()),
        currency: json['currency'] as String,
        status: json['status'] as String,
        invoicePdf: json['invoice_pdf'] as String?,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'stripe_invoice_id': stripeInvoiceId,
        'invoice_number': invoiceNumber,
        'amount_due': amountDue,
        'currency': currency,
        'status': status,
        'invoice_pdf': invoicePdf,
        'created_at': createdAt?.toIso8601String(),
      };
}
///
/// CREATE TABLE public."analytics events" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   user_id uuid NOT NULL,
///   product_id uuid NULL,
///   store_id uuid NULL,
///   entity_type text NOT NULL,
///   event_type text NOT NULL,
///   created_at timestamp without time zone NOT NULL DEFAULT now(),
///   PRIMARY KEY (id),
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class AnalyticsEvent {
  final String id;
  final String userId;
  final String? productId;
  final String? storeId;
  final String entityType;
  final String eventType;
  final DateTime createdAt;

  AnalyticsEvent({
    required this.id,
    required this.userId,
    this.productId,
    this.storeId,
    required this.entityType,
    required this.eventType,
    required this.createdAt,
  });

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) => AnalyticsEvent(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        productId: json['product_id'] as String?,
        storeId: json['store_id'] as String?,
        entityType: json['entity_type'] as String,
        eventType: json['event_type'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'store_id': storeId,
        'entity_type': entityType,
        'event_type': eventType,
        'created_at': createdAt.toIso8601String(),
      };
}

/// Table: password_reset_codes
///
/// CREATE TABLE public.password_reset_codes (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   email text NOT NULL,
///   code text NOT NULL,
///   expires_at timestamp with time zone NOT NULL,
///   created_at timestamp with time zone NULL DEFAULT now(),
///   PRIMARY KEY (id)
/// )
///
/// Indexes:
///   password_reset_codes_email_idx (email)
///   password_reset_codes_code_idx (code)
class PasswordResetCode {
  final String id;
  final String email;
  final String code;
  final DateTime expiresAt;
  final DateTime? createdAt;

  PasswordResetCode({
    required this.id,
    required this.email,
    required this.code,
    required this.expiresAt,
    this.createdAt,
  });

  factory PasswordResetCode.fromJson(Map<String, dynamic> json) => PasswordResetCode(
        id: json['id'] as String,
        email: json['email'] as String,
        code: json['code'] as String,
        expiresAt: DateTime.parse(json['expires_at'] as String),
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'code': code,
        'expires_at': expiresAt.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
      };
}

/// Table: product flags
///
/// CREATE TABLE public."product flags" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   product_id uuid NOT NULL,
///   user_id uuid NOT NULL,
///   reason text NOT NULL,
///   status text NOT NULL DEFAULT 'pending',
///   created_at timestamp without time zone NOT NULL DEFAULT now(),
///   moderator_id uuid NULL,
///   PRIMARY KEY (id),
///   FOREIGN KEY (moderator_id) REFERENCES profiles (id) ON DELETE SET NULL,
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class ProductFlag {
  final String id;
  final String productId;
  final String userId;
  final String reason;
  final String status;
  final DateTime createdAt;
  final String? moderatorId;

  ProductFlag({
    required this.id,
    required this.productId,
    required this.userId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.moderatorId,
  });

  factory ProductFlag.fromJson(Map<String, dynamic> json) => ProductFlag(
        id: json['id'] as String,
        productId: json['product_id'] as String,
        userId: json['user_id'] as String,
        reason: json['reason'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        moderatorId: json['moderator_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'user_id': userId,
        'reason': reason,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'moderator_id': moderatorId,
      };
}

/// Table: product rating
///
/// CREATE TABLE public."product rating" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   product_id uuid NOT NULL,
///   user_id uuid NOT NULL,
///   rating integer NOT NULL,
///   review_text text NULL DEFAULT '',
///   created_at timestamp without time zone NOT NULL DEFAULT now(),
///   updated_at timestamp without time zone NULL,
///   PRIMARY KEY (id),
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class ProductRating {
  final String id;
  final String productId;
  final String userId;
  final int rating;
  final String? reviewText;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductRating({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.reviewText,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) => ProductRating(
        id: json['id'] as String,
        productId: json['product_id'] as String,
        userId: json['user_id'] as String,
        rating: json['rating'] as int,
        reviewText: json['review_text'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'user_id': userId,
        'rating': rating,
        'review_text': reviewText,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

/// Table: product stats
///
/// CREATE TABLE public."product stats" (
///   product_id uuid NOT NULL,
///   impressions integer NOT NULL DEFAULT 0,
///   clicks integer NOT NULL DEFAULT 0,
///   days_listed integer NOT NULL DEFAULT 0,
///   rating_avg numeric NULL,
///   rating_count integer NULL,
///   PRIMARY KEY (product_id),
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class ProductStats {
  final String productId;
  final int impressions;
  final int clicks;
  final int daysListed;
  final num? ratingAvg;
  final int? ratingCount;

  ProductStats({
    required this.productId,
    required this.impressions,
    required this.clicks,
    required this.daysListed,
    this.ratingAvg,
    this.ratingCount,
  });

  factory ProductStats.fromJson(Map<String, dynamic> json) => ProductStats(
        productId: json['product_id'] as String,
        impressions: json['impressions'] as int,
        clicks: json['clicks'] as int,
        daysListed: json['days_listed'] as int,
        ratingAvg: json['rating_avg'] != null ? num.parse(json['rating_avg'].toString()) : null,
        ratingCount: json['rating_count'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'impressions': impressions,
        'clicks': clicks,
        'days_listed': daysListed,
        'rating_avg': ratingAvg,
        'rating_count': ratingCount,
      };
}

/// Table: product visibility cooldowns
///
/// CREATE TABLE public."product visibility cooldowns" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   user_id uuid NOT NULL,
///   product_id uuid NOT NULL,
///   last_shown_at timestamp without time zone NOT NULL DEFAULT now(),
///   PRIMARY KEY (id),
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class ProductVisibilityCooldown {
  final String id;
  final String userId;
  final String productId;
  final DateTime lastShownAt;

  ProductVisibilityCooldown({
    required this.id,
    required this.userId,
    required this.productId,
    required this.lastShownAt,
  });

  factory ProductVisibilityCooldown.fromJson(Map<String, dynamic> json) => ProductVisibilityCooldown(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        productId: json['product_id'] as String,
        lastShownAt: DateTime.parse(json['last_shown_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'last_shown_at': lastShownAt.toIso8601String(),
      };
}

/// Table: products
///
/// CREATE TABLE public.products (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   store_id uuid NOT NULL,
///   name text NOT NULL,
///   price numeric NOT NULL,
///   product_url text NULL,
///   image_url text NULL,
///   created_at timestamp with time zone NOT NULL DEFAULT now(),
///   updated_at timestamp with time zone NULL,
///   public_id text NULL,
///   PRIMARY KEY (id),
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
///
/// Indexes:
///   products_store_id_idx (store_id)
class Product {
  final String id;
  final String storeId;
  final String name;
  final num price;
  final String? productUrl;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? publicId;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.price,
    this.productUrl,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    this.publicId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        storeId: json['store_id'] as String,
        name: json['name'] as String,
        price: num.parse(json['price'].toString()),
        productUrl: json['product_url'] as String?,
        imageUrl: json['image_url'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
        publicId: json['public_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_id': storeId,
        'name': name,
        'price': price,
        'product_url': productUrl,
        'image_url': imageUrl,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'public_id': publicId,
      };
}

/// Table: profiles
///
/// CREATE TABLE public.profiles (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   created_at timestamp with time zone NOT NULL DEFAULT now(),
///   email text NOT NULL,
///   name text NOT NULL,
///   is_paying boolean NOT NULL DEFAULT false,
///   updated_at timestamp with time zone NULL,
///   PRIMARY KEY (id)
/// )
class Profile {
  final String id;
  final DateTime createdAt;
  final String email;
  final String name;
  final bool isPaying;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.name,
    required this.isPaying,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        email: json['email'] as String,
        name: json['name'] as String,
        isPaying: json['is_paying'] as bool,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'email': email,
        'name': name,
        'is_paying': isPaying,
        'updated_at': updatedAt?.toIso8601String(),
      };
}

/// Table: store flags
///
/// CREATE TABLE public."store flags" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   store_id uuid NOT NULL,
///   user_id uuid NOT NULL,
///   reason text NOT NULL,
///   status text NOT NULL DEFAULT 'pending',
///   created_at timestamp without time zone NOT NULL DEFAULT now(),
///   moderator_id uuid NULL,
///   PRIMARY KEY (id),
///   FOREIGN KEY (moderator_id) REFERENCES profiles (id) ON DELETE SET NULL,
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class StoreFlag {
  final String id;
  final String storeId;
  final String userId;
  final String reason;
  final String status;
  final DateTime createdAt;
  final String? moderatorId;

  StoreFlag({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.moderatorId,
  });

  factory StoreFlag.fromJson(Map<String, dynamic> json) => StoreFlag(
        id: json['id'] as String,
        storeId: json['store_id'] as String,
        userId: json['user_id'] as String,
        reason: json['reason'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        moderatorId: json['moderator_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_id': storeId,
        'user_id': userId,
        'reason': reason,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'moderator_id': moderatorId,
      };
}

/// Table: store ratings
///
/// CREATE TABLE public."store ratings" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   store_id uuid NOT NULL,
///   user_id uuid NOT NULL,
///   rating integer NOT NULL,
///   review_text text NULL,
///   created_at timestamp without time zone NOT NULL DEFAULT now(),
///   updated_at timestamp without time zone NULL,
///   PRIMARY KEY (id),
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class StoreRating {
  final String id;
  final String storeId;
  final String userId;
  final int rating;
  final String? reviewText;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StoreRating({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.rating,
    this.reviewText,
    required this.createdAt,
    this.updatedAt,
  });

  factory StoreRating.fromJson(Map<String, dynamic> json) => StoreRating(
        id: json['id'] as String,
        storeId: json['store_id'] as String,
        userId: json['user_id'] as String,
        rating: json['rating'] as int,
        reviewText: json['review_text'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_id': storeId,
        'user_id': userId,
        'rating': rating,
        'review_text': reviewText,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

/// Table: store stats
///
/// CREATE TABLE public."store stats" (
///   store_id uuid NOT NULL,
///   impressions integer NOT NULL DEFAULT 0,
///   clicks integer NOT NULL DEFAULT 0,
///   visits integer NOT NULL DEFAULT 0,
///   days_listed integer NOT NULL DEFAULT 0,
///   PRIMARY KEY (store_id),
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class StoreStats {
  final String storeId;
  final int impressions;
  final int clicks;
  final int visits;
  final int daysListed;

  StoreStats({
    required this.storeId,
    required this.impressions,
    required this.clicks,
    required this.visits,
    required this.daysListed,
  });

  factory StoreStats.fromJson(Map<String, dynamic> json) => StoreStats(
        storeId: json['store_id'] as String,
        impressions: json['impressions'] as int,
        clicks: json['clicks'] as int,
        visits: json['visits'] as int,
        daysListed: json['days_listed'] as int,
      );

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'impressions': impressions,
        'clicks': clicks,
        'visits': visits,
        'days_listed': daysListed,
      };
}

/// Table: stores
///
/// CREATE TABLE public.stores (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   created_at timestamp with time zone NOT NULL DEFAULT now(),
///   owner_id uuid NOT NULL,
///   name text NOT NULL,
///   store_url text NULL,
///   updated_at timestamp with time zone NULL,
///   PRIMARY KEY (id),
///   FOREIGN KEY (owner_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
///
/// Indexes:
///   stores_owner_id_idx (owner_id)
class Store {
  final String id;
  final DateTime createdAt;
  final String ownerId;
  final String name;
  final String? storeUrl;
  final DateTime? updatedAt;

  Store({
    required this.id,
    required this.createdAt,
    required this.ownerId,
    required this.name,
    this.storeUrl,
    this.updatedAt,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        ownerId: json['owner_id'] as String,
        name: json['name'] as String,
        storeUrl: json['store_url'] as String?,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'owner_id': ownerId,
        'name': name,
        'store_url': storeUrl,
        'updated_at': updatedAt?.toIso8601String(),
      };
}

/// Table: user product history
///
/// CREATE TABLE public."user product history" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   user_id uuid NOT NULL,
///   product_id uuid NOT NULL,
///   viewed_at timestamp without time zone NOT NULL DEFAULT now(),
///   PRIMARY KEY (id),
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class UserProductHistory {
  final String id;
  final String userId;
  final String productId;
  final DateTime viewedAt;

  UserProductHistory({
    required this.id,
    required this.userId,
    required this.productId,
    required this.viewedAt,
  });

  factory UserProductHistory.fromJson(Map<String, dynamic> json) => UserProductHistory(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        productId: json['product_id'] as String,
        viewedAt: DateTime.parse(json['viewed_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'viewed_at': viewedAt.toIso8601String(),
      };
}

/// Table: user saved products
///
/// CREATE TABLE public."user saved products" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   user_id uuid NOT NULL,
///   product_id uuid NOT NULL,
///   saved_at timestamp without time zone NOT NULL DEFAULT now(),
///   PRIMARY KEY (id),
///   FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class UserSavedProduct {
  final String id;
  final String userId;
  final String productId;
  final DateTime savedAt;

  UserSavedProduct({
    required this.id,
    required this.userId,
    required this.productId,
    required this.savedAt,
  });

  factory UserSavedProduct.fromJson(Map<String, dynamic> json) => UserSavedProduct(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        productId: json['product_id'] as String,
        savedAt: DateTime.parse(json['saved_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'product_id': productId,
        'saved_at': savedAt.toIso8601String(),
      };
}

/// Table: user saved stores
///
/// CREATE TABLE public."user saved stores" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   user_id uuid NOT NULL,
///   store_id uuid NOT NULL,
///   saved_at timestamp without time zone NOT NULL DEFAULT now(),
///   PRIMARY KEY (id),
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class UserSavedStore {
  final String id;
  final String userId;
  final String storeId;
  final DateTime savedAt;

  UserSavedStore({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.savedAt,
  });

  factory UserSavedStore.fromJson(Map<String, dynamic> json) => UserSavedStore(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        storeId: json['store_id'] as String,
        savedAt: DateTime.parse(json['saved_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'store_id': storeId,
        'saved_at': savedAt.toIso8601String(),
      };
}

/// Table: orders
///
/// CREATE TABLE public.orders (
///   id uuid not null default gen_random_uuid (),
///   user_id uuid null,
///   stripe_session_id text null,
///   stripe_payment_intent_id text null,
///   amount integer not null default 0,
///   currency text not null default 'usd'::text,
///   status text not null default 'pending'::text,
///   created_at timestamp with time zone null default now(),
///   stripe_subscription_id text null,
///   stripe_customer_id text null,
///   constraint orders_pkey primary key (id),
///   constraint orders_stripe_session_id_key unique (stripe_session_id),
///   constraint orders_user_id_fkey foreign KEY (user_id) references profiles (id) on delete set null
/// ) TABLESPACE pg_default;
///
/// create index IF not exists orders_user_id_idx on public.orders using btree (user_id) TABLESPACE pg_default;
/// create index IF not exists orders_stripe_session_id_idx on public.orders using btree (stripe_session_id) TABLESPACE pg_default;
/// create index IF not exists orders_stripe_customer_id_idx on public.orders using btree (stripe_customer_id) TABLESPACE pg_default;
class Orders {
  final String id;
  final String? userId;
  final String? stripeSessionId;
  final String? stripePaymentIntentId;
  final String? stripeSubscriptionId;
  final String? stripeCustomerId;
  final int amount;
  final String currency;
  final String status;
  final DateTime? createdAt;

  Orders({
    required this.id,
    this.userId,
    this.stripeSessionId,
    this.stripePaymentIntentId,
    this.stripeSubscriptionId,
    this.stripeCustomerId,
    this.amount = 0,
    this.currency = 'usd',
    this.status = 'pending',
    this.createdAt,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        id: json['id'] as String,
        userId: json['user_id'] as String?,
        stripeSessionId: json['stripe_session_id'] as String?,
        stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
        stripeSubscriptionId: json['stripe_subscription_id'] as String?,
        stripeCustomerId: json['stripe_customer_id'] as String?,
        amount: json['amount'] is int ? json['amount'] as int : int.parse(json['amount'].toString()),
        currency: json['currency'] as String? ?? 'usd',
        status: json['status'] as String? ?? 'pending',
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'stripe_session_id': stripeSessionId,
        'stripe_payment_intent_id': stripePaymentIntentId,
        'stripe_subscription_id': stripeSubscriptionId,
        'stripe_customer_id': stripeCustomerId,
        'amount': amount,
        'currency': currency,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
      };
}

/// Table: user store history
///
/// CREATE TABLE public."user store history" (
///   id uuid NOT NULL DEFAULT gen_random_uuid(),
///   user_id uuid NOT NULL,
///   store_id uuid NOT NULL,
///   visited_at timestamp without time zone NOT NULL DEFAULT now(),
///   PRIMARY KEY (id),
///   FOREIGN KEY (store_id) REFERENCES stores (id) ON UPDATE CASCADE ON DELETE CASCADE,
///   FOREIGN KEY (user_id) REFERENCES profiles (id) ON UPDATE CASCADE ON DELETE CASCADE
/// )
class UserStoreHistory {
  final String id;
  final String userId;
  final String storeId;
  final DateTime visitedAt;

  UserStoreHistory({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.visitedAt,
  });

  factory UserStoreHistory.fromJson(Map<String, dynamic> json) => UserStoreHistory(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        storeId: json['store_id'] as String,
        visitedAt: DateTime.parse(json['visited_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'store_id': storeId,
        'visited_at': visitedAt.toIso8601String(),
      };
}

/// Table: user_photos
///
/// CREATE TABLE public.user_photos (
///   id uuid not null default gen_random_uuid (),
///   user_id uuid not null,
///   file_path text not null,
///   description text null,
///   is_public boolean null default false,
///   created_at timestamp with time zone null default now(),
///   constraint user_photos_pkey primary key (id),
///   constraint user_photos_user_id_fkey foreign KEY (user_id) references auth.users (id) on delete CASCADE
/// ) TABLESPACE pg_default;
class UserPhotos {
  final String id;
  final String userId;
  final String filePath;
  final String? description;
  final bool? isPublic;
  final DateTime? createdAt;

  UserPhotos({
    required this.id,
    required this.userId,
    required this.filePath,
    this.description,
    this.isPublic,
    this.createdAt,
  });

  factory UserPhotos.fromJson(Map<String, dynamic> json) => UserPhotos(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        filePath: json['file_path'] as String,
        description: json['description'] as String?,
        isPublic: json['is_public'] as bool?,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'file_path': filePath,
        'description': description,
        'is_public': isPublic,
        'created_at': createdAt?.toIso8601String(),
      };
}