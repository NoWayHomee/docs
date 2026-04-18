DROP DATABASE IF EXISTS agoda_clone;
CREATE DATABASE agoda_clone DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE agoda_clone;

CREATE TABLE users (
  id                    BIGINT UNSIGNED    NOT NULL AUTO_INCREMENT,
  uuid                  CHAR(36)           NOT NULL,
  email                 VARCHAR(255)       NOT NULL,
  phone                 VARCHAR(20)        DEFAULT NULL,
  password_hash         VARCHAR(255)       DEFAULT NULL,
  full_name             VARCHAR(255)       NOT NULL,
  avatar_url            VARCHAR(500)       DEFAULT NULL,
  user_type             ENUM('customer','partner','staff') NOT NULL,
  status                ENUM('active','suspended','pending') NOT NULL DEFAULT 'pending',
  email_verified_at     DATETIME           DEFAULT NULL,
  last_login_at         DATETIME           DEFAULT NULL,
  preferred_language    CHAR(5)            NOT NULL DEFAULT 'vi',
  created_at            DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_uuid  (uuid),
  UNIQUE KEY uq_users_email (email),
  UNIQUE KEY uq_users_phone (phone),
  KEY idx_users_type_status (user_type, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE social_accounts (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id       BIGINT UNSIGNED NOT NULL,
  provider      ENUM('google','facebook','apple','zalo') NOT NULL,
  provider_id   VARCHAR(255)    NOT NULL,
  access_token  TEXT            DEFAULT NULL,
  refresh_token TEXT            DEFAULT NULL,
  token_expires_at DATETIME     DEFAULT NULL,
  created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_social_provider (provider, provider_id),
  CONSTRAINT fk_social_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE partner_profiles (
  id                   BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  user_id              BIGINT UNSIGNED  NOT NULL,
  business_name        VARCHAR(255)     NOT NULL,
  business_type        ENUM('individual','company') NOT NULL,
  tax_code             VARCHAR(50)      DEFAULT NULL,
  id_card_number       VARCHAR(50)      DEFAULT NULL,
  contract_url         VARCHAR(500)     DEFAULT NULL,
  kyc_status           ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  kyc_reviewed_by      BIGINT UNSIGNED  DEFAULT NULL,
  kyc_reviewed_at      DATETIME         DEFAULT NULL,
  bank_account_name    VARCHAR(255)     DEFAULT NULL,
  bank_account_number  VARCHAR(100)     DEFAULT NULL,
  bank_name            VARCHAR(100)     DEFAULT NULL,
  commission_tier      VARCHAR(50)      NOT NULL DEFAULT 'standard',
  created_at           DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_partner_user (user_id),
  CONSTRAINT fk_partner_user     FOREIGN KEY (user_id)         REFERENCES users (id),
  CONSTRAINT fk_partner_reviewer FOREIGN KEY (kyc_reviewed_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE customer_profiles (
  id                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id            BIGINT UNSIGNED NOT NULL,
  date_of_birth      DATE            DEFAULT NULL,
  gender             ENUM('male','female','other') DEFAULT NULL,
  nationality        CHAR(2)         DEFAULT NULL,
  id_card_number     VARCHAR(50)     DEFAULT NULL,
  loyalty_tier       ENUM('member','silver','gold','platinum') NOT NULL DEFAULT 'member',
  loyalty_points_balance INT UNSIGNED NOT NULL DEFAULT 0,
  total_bookings     INT UNSIGNED    NOT NULL DEFAULT 0,
  created_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_customer_user (user_id),
  CONSTRAINT fk_customer_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE properties (
  id             BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  partner_id     BIGINT UNSIGNED  NOT NULL,
  slug           VARCHAR(300)     NOT NULL,
  name           VARCHAR(500)     NOT NULL,
  property_type  ENUM('hotel','homestay','resort','apartment','villa','hostel') NOT NULL,
  description    TEXT             DEFAULT NULL,
  address        TEXT             NOT NULL,
  city           VARCHAR(100)     NOT NULL,
  district       VARCHAR(100)     DEFAULT NULL,
  country_code   CHAR(2)          NOT NULL DEFAULT 'VN',
  latitude       DECIMAL(10,8)    NOT NULL,
  longitude      DECIMAL(11,8)    NOT NULL,
  star_rating    TINYINT UNSIGNED DEFAULT NULL,
  avg_rating     DECIMAL(3,2)     NOT NULL DEFAULT 0.00,
  total_reviews  INT UNSIGNED     NOT NULL DEFAULT 0,
  check_in_time  TIME             NOT NULL DEFAULT '14:00:00',
  check_out_time TIME             NOT NULL DEFAULT '12:00:00',
  status         ENUM('draft','pending_review','active','suspended') NOT NULL DEFAULT 'draft',
  reviewed_by    BIGINT UNSIGNED  DEFAULT NULL,
  reviewed_at    DATETIME         DEFAULT NULL,
  created_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_property_slug (slug),
  KEY idx_property_partner (partner_id),
  KEY idx_property_city_status (city, status),
  KEY idx_property_latlon (latitude, longitude),
  CONSTRAINT fk_property_partner  FOREIGN KEY (partner_id)  REFERENCES partner_profiles (id),
  CONSTRAINT fk_property_reviewer FOREIGN KEY (reviewed_by) REFERENCES users (id) ON DELETE SET NULL,
  CONSTRAINT chk_star_rating CHECK (star_rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE room_types (
  id               BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  property_id      BIGINT UNSIGNED  NOT NULL,
  name             VARCHAR(255)     NOT NULL,
  description      TEXT             DEFAULT NULL,
  area_sqm         DECIMAL(6,2)     DEFAULT NULL,
  bed_configuration VARCHAR(200)    DEFAULT NULL,
  max_occupancy    TINYINT UNSIGNED NOT NULL DEFAULT 2,
  view_type        VARCHAR(100)     DEFAULT NULL,
  total_rooms      SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  base_price       DECIMAL(12,2)    NOT NULL,
  is_active        TINYINT(1)       NOT NULL DEFAULT 1,
  created_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_rt_property (property_id),
  CONSTRAINT fk_rt_property FOREIGN KEY (property_id) REFERENCES properties (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rooms (
  id             BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  room_type_id   BIGINT UNSIGNED  NOT NULL,
  property_id    BIGINT UNSIGNED  NOT NULL,
  room_number    VARCHAR(20)      NOT NULL,
  floor          SMALLINT         DEFAULT NULL,
  status         ENUM('available','occupied','blocked','maintenance') NOT NULL DEFAULT 'available',
  notes          TEXT             DEFAULT NULL,
  created_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_room_number_property (property_id, room_number),
  CONSTRAINT fk_room_type     FOREIGN KEY (room_type_id) REFERENCES room_types  (id),
  CONSTRAINT fk_room_property FOREIGN KEY (property_id)  REFERENCES properties  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE amenities (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name        VARCHAR(100)    NOT NULL,
  category    VARCHAR(50)     NOT NULL, -- 'facility','service','entertainment'
  icon_code   VARCHAR(50)     DEFAULT NULL,
  is_active   TINYINT(1)      NOT NULL DEFAULT 1,
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_amenity_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE property_amenities (
  property_id  BIGINT UNSIGNED NOT NULL,
  amenity_id   BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (property_id, amenity_id),
  CONSTRAINT fk_pa_property FOREIGN KEY (property_id) REFERENCES properties (id) ON DELETE CASCADE,
  CONSTRAINT fk_pa_amenity  FOREIGN KEY (amenity_id)  REFERENCES amenities  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE room_type_amenities (
  room_type_id BIGINT UNSIGNED NOT NULL,
  amenity_id   BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (room_type_id, amenity_id),
  CONSTRAINT fk_rta_rt      FOREIGN KEY (room_type_id) REFERENCES room_types (id) ON DELETE CASCADE,
  CONSTRAINT fk_rta_amenity FOREIGN KEY (amenity_id)   REFERENCES amenities  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE rate_plans (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  room_type_id    BIGINT UNSIGNED NOT NULL,
  name            VARCHAR(200)    NOT NULL,
  meal_plan       ENUM('room_only','breakfast','half_board','full_board','all_inclusive') NOT NULL DEFAULT 'room_only',
  refundable      TINYINT(1)      NOT NULL DEFAULT 1,
  base_price      DECIMAL(12,2)   NOT NULL,
  is_active       TINYINT(1)      NOT NULL DEFAULT 1,
  created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_rp_rt FOREIGN KEY (room_type_id) REFERENCES room_types (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE daily_rates (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  rate_plan_id BIGINT UNSIGNED NOT NULL,
  date         DATE            NOT NULL,
  price        DECIMAL(12,2)   NOT NULL,
  available_qty SMALLINT UNSIGNED NOT NULL,
  min_stay     TINYINT UNSIGNED NOT NULL DEFAULT 1,
  created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_daily_rate (rate_plan_id, date),
  KEY idx_daily_date (date),
  CONSTRAINT fk_dr_rp FOREIGN KEY (rate_plan_id) REFERENCES rate_plans (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE promotions (
  id              BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  partner_id      BIGINT UNSIGNED  DEFAULT NULL, -- NULL = system-wide
  name            VARCHAR(255)     NOT NULL,
  promo_type      ENUM('early_bird','last_minute','long_stay','flash_sale','loyalty','custom') NOT NULL,
  discount_type   ENUM('percent','fixed') NOT NULL,
  discount_value  DECIMAL(10,2)    NOT NULL,
  max_discount    DECIMAL(12,2)    DEFAULT NULL,
  min_order_amount DECIMAL(12,2)  NOT NULL DEFAULT 0,
  start_date      DATE             NOT NULL,
  end_date        DATE             NOT NULL,
  max_uses        INT UNSIGNED     DEFAULT NULL,
  total_used      INT UNSIGNED     NOT NULL DEFAULT 0,
  is_active       TINYINT(1)       NOT NULL DEFAULT 1,
  created_by      BIGINT UNSIGNED  NOT NULL,
  created_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_promo_partner FOREIGN KEY (partner_id) REFERENCES partner_profiles (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vouchers (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  promotion_id   BIGINT UNSIGNED NOT NULL,
  code           VARCHAR(50)     NOT NULL,
  max_uses_per_user TINYINT UNSIGNED NOT NULL DEFAULT 1,
  total_used     INT UNSIGNED    NOT NULL DEFAULT 0,
  is_active      TINYINT(1)      NOT NULL DEFAULT 1,
  created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_voucher_code (code),
  CONSTRAINT fk_voucher_promo FOREIGN KEY (promotion_id) REFERENCES promotions (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE bookings (
  id                  BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT,
  booking_code        VARCHAR(30)       NOT NULL,
  customer_id         BIGINT UNSIGNED   NOT NULL,
  property_id         BIGINT UNSIGNED   NOT NULL,
  check_in_date       DATE              NOT NULL,
  check_out_date      DATE              NOT NULL,
  num_nights          TINYINT UNSIGNED  NOT NULL,
  num_adults          TINYINT UNSIGNED  NOT NULL DEFAULT 1,
  num_children        TINYINT UNSIGNED  NOT NULL DEFAULT 0,
  subtotal_amount     DECIMAL(12,2)     NOT NULL,
  discount_amount     DECIMAL(12,2)     NOT NULL DEFAULT 0.00,
  tax_amount          DECIMAL(12,2)     NOT NULL DEFAULT 0.00,
  total_amount        DECIMAL(12,2)     NOT NULL,
  currency            CHAR(3)           NOT NULL DEFAULT 'VND',
  voucher_id          BIGINT UNSIGNED   DEFAULT NULL,
  loyalty_points_used INT UNSIGNED      NOT NULL DEFAULT 0,
  status              ENUM('pending','confirmed','checked_in','checked_out','cancelled','no_show') NOT NULL DEFAULT 'pending',
  payment_status      ENUM('unpaid','partial','paid','refunded') NOT NULL DEFAULT 'unpaid',
  source_channel      ENUM('web','mobile','ota','direct') NOT NULL DEFAULT 'web',
  special_requests    TEXT              DEFAULT NULL,
  cancellation_reason TEXT              DEFAULT NULL,
  cancelled_by        BIGINT UNSIGNED   DEFAULT NULL,
  cancelled_at        DATETIME          DEFAULT NULL,
  created_at          DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_booking_code (booking_code),
  KEY idx_booking_customer (customer_id),
  KEY idx_booking_property (property_id),
  KEY idx_booking_dates    (check_in_date, check_out_date),
  KEY idx_booking_status   (status, payment_status),
  CONSTRAINT fk_booking_customer  FOREIGN KEY (customer_id)  REFERENCES users       (id),
  CONSTRAINT fk_booking_property  FOREIGN KEY (property_id)  REFERENCES properties  (id),
  CONSTRAINT fk_booking_voucher   FOREIGN KEY (voucher_id)   REFERENCES vouchers    (id) ON DELETE SET NULL,
  CONSTRAINT fk_booking_cancelled FOREIGN KEY (cancelled_by) REFERENCES users       (id) ON DELETE SET NULL,
  CONSTRAINT chk_booking_dates    CHECK (check_out_date > check_in_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE booking_rooms (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  booking_id    BIGINT UNSIGNED NOT NULL,
  room_id       BIGINT UNSIGNED NOT NULL,
  rate_plan_id  BIGINT UNSIGNED NOT NULL,
  room_price    DECIMAL(12,2)   NOT NULL,
  created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_br_booking_room (booking_id, room_id),
  CONSTRAINT fk_br_booking   FOREIGN KEY (booking_id)   REFERENCES bookings    (id) ON DELETE CASCADE,
  CONSTRAINT fk_br_room      FOREIGN KEY (room_id)      REFERENCES rooms       (id),
  CONSTRAINT fk_br_rate_plan FOREIGN KEY (rate_plan_id) REFERENCES rate_plans  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE payments (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  booking_id       BIGINT UNSIGNED NOT NULL,
  transaction_ref  VARCHAR(100)    NOT NULL,
  amount           DECIMAL(12,2)   NOT NULL,
  currency         CHAR(3)         NOT NULL DEFAULT 'VND',
  payment_method   ENUM('credit_card','debit_card','ewallet','bank_transfer','pay_later','loyalty_cash') NOT NULL,
  gateway          VARCHAR(50)     NOT NULL,
  gateway_response JSON            DEFAULT NULL,
  status           ENUM('pending','success','failed','cancelled') NOT NULL DEFAULT 'pending',
  paid_at          DATETIME        DEFAULT NULL,
  created_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_payment_ref (transaction_ref),
  KEY idx_payment_booking (booking_id),
  CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES bookings (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE refunds (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  payment_id     BIGINT UNSIGNED NOT NULL,
  booking_id     BIGINT UNSIGNED NOT NULL,
  amount         DECIMAL(12,2)   NOT NULL,
  reason         TEXT            NOT NULL,
  status         ENUM('pending','processing','completed','failed') NOT NULL DEFAULT 'pending',
  processed_by   BIGINT UNSIGNED DEFAULT NULL,
  processed_at   DATETIME        DEFAULT NULL,
  gateway_ref    VARCHAR(100)    DEFAULT NULL,
  created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_refund_payment   FOREIGN KEY (payment_id)   REFERENCES payments (id),
  CONSTRAINT fk_refund_booking   FOREIGN KEY (booking_id)   REFERENCES bookings (id),
  CONSTRAINT fk_refund_processor FOREIGN KEY (processed_by) REFERENCES users    (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE reviews (
  id                  BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  booking_id          BIGINT UNSIGNED  NOT NULL,
  property_id         BIGINT UNSIGNED  NOT NULL,
  customer_id         BIGINT UNSIGNED  NOT NULL,
  overall_rating      DECIMAL(3,1)     NOT NULL,
  cleanliness_rating  DECIMAL(3,1)     DEFAULT NULL,
  service_rating      DECIMAL(3,1)     DEFAULT NULL,
  location_rating     DECIMAL(3,1)     DEFAULT NULL,
  value_rating        DECIMAL(3,1)     DEFAULT NULL,
  title               VARCHAR(255)     DEFAULT NULL,
  content             TEXT             DEFAULT NULL,
  moderation_status   ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  moderated_by        BIGINT UNSIGNED  DEFAULT NULL,
  moderated_at        DATETIME         DEFAULT NULL,
  created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_review_booking    (booking_id),
  KEY idx_review_property_status  (property_id, moderation_status),
  CONSTRAINT fk_review_booking   FOREIGN KEY (booking_id)   REFERENCES bookings   (id),
  CONSTRAINT fk_review_property  FOREIGN KEY (property_id)  REFERENCES properties (id),
  CONSTRAINT fk_review_customer  FOREIGN KEY (customer_id)  REFERENCES users      (id),
  CONSTRAINT fk_review_moderator FOREIGN KEY (moderated_by) REFERENCES users      (id) ON DELETE SET NULL,
  CONSTRAINT chk_overall_rating  CHECK (overall_rating BETWEEN 1 AND 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE review_responses (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  review_id    BIGINT UNSIGNED NOT NULL,
  responder_id BIGINT UNSIGNED NOT NULL,
  content      TEXT            NOT NULL,
  created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_review_response (review_id),
  CONSTRAINT fk_rr_review     FOREIGN KEY (review_id)    REFERENCES reviews (id) ON DELETE CASCADE,
  CONSTRAINT fk_rr_responder  FOREIGN KEY (responder_id) REFERENCES users   (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payout_wallets (
  id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  partner_id        BIGINT UNSIGNED NOT NULL,
  available_balance DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
  pending_balance   DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
  total_earned      DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
  total_withdrawn   DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
  currency          CHAR(3)         NOT NULL DEFAULT 'VND',
  created_at        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_wallet_partner (partner_id),
  CONSTRAINT fk_wallet_partner FOREIGN KEY (partner_id) REFERENCES partner_profiles (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wallet_transactions (
  id             BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  wallet_id      BIGINT UNSIGNED  NOT NULL,
  type           ENUM('credit','debit') NOT NULL,
  amount         DECIMAL(12,2)    NOT NULL,
  balance_after  DECIMAL(15,2)    NOT NULL,
  description    VARCHAR(500)     NOT NULL,
  ref_type       VARCHAR(50)      DEFAULT NULL, -- 'booking','payout_request'
  ref_id         BIGINT UNSIGNED  DEFAULT NULL,
  created_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_wt_wallet (wallet_id),
  CONSTRAINT fk_wt_wallet FOREIGN KEY (wallet_id) REFERENCES payout_wallets (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payout_requests (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  wallet_id     BIGINT UNSIGNED NOT NULL,
  amount        DECIMAL(12,2)   NOT NULL,
  status        ENUM('pending','approved','rejected','processing','completed') NOT NULL DEFAULT 'pending',
  reviewed_by   BIGINT UNSIGNED DEFAULT NULL,
  reviewed_at   DATETIME        DEFAULT NULL,
  note          TEXT            DEFAULT NULL,
  created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_pr_wallet   FOREIGN KEY (wallet_id)   REFERENCES payout_wallets (id),
  CONSTRAINT fk_pr_reviewer FOREIGN KEY (reviewed_by) REFERENCES users          (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE support_tickets (
  id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_code   VARCHAR(30)     NOT NULL,
  requester_id  BIGINT UNSIGNED NOT NULL,
  booking_id    BIGINT UNSIGNED DEFAULT NULL,
  category      ENUM('booking_issue','payment','property','account','other') NOT NULL,
  subject       VARCHAR(500)    NOT NULL,
  status        ENUM('open','in_progress','pending_customer','resolved','closed') NOT NULL DEFAULT 'open',
  priority      ENUM('low','medium','high','urgent') NOT NULL DEFAULT 'medium',
  assigned_to   BIGINT UNSIGNED DEFAULT NULL,
  resolved_at   DATETIME        DEFAULT NULL,
  created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_ticket_code (ticket_code),
  CONSTRAINT fk_ticket_requester FOREIGN KEY (requester_id) REFERENCES users     (id),
  CONSTRAINT fk_ticket_booking   FOREIGN KEY (booking_id)   REFERENCES bookings  (id) ON DELETE SET NULL,
  CONSTRAINT fk_ticket_agent     FOREIGN KEY (assigned_to)  REFERENCES users     (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ticket_messages (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  ticket_id   BIGINT UNSIGNED NOT NULL,
  sender_id   BIGINT UNSIGNED NOT NULL,
  content     TEXT            NOT NULL,
  is_internal TINYINT(1)      NOT NULL DEFAULT 0,
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT fk_tm_ticket FOREIGN KEY (ticket_id) REFERENCES support_tickets (id) ON DELETE CASCADE,
  CONSTRAINT fk_tm_sender FOREIGN KEY (sender_id) REFERENCES users           (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE roles (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name        VARCHAR(100)    NOT NULL,
  slug        VARCHAR(100)    NOT NULL,
  description TEXT            DEFAULT NULL,
  is_system   TINYINT(1)      NOT NULL DEFAULT 0,
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_role_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permissions (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  action      VARCHAR(100)    NOT NULL, -- e.g. 'booking:cancel', 'user:suspend'
  resource    VARCHAR(100)    NOT NULL,
  description TEXT            DEFAULT NULL,
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_perm_action_resource (action, resource)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE role_permissions (
  role_id       BIGINT UNSIGNED NOT NULL,
  permission_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  CONSTRAINT fk_rp_role FOREIGN KEY (role_id)       REFERENCES roles       (id) ON DELETE CASCADE,
  CONSTRAINT fk_rp_perm FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE user_roles (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     BIGINT UNSIGNED NOT NULL,
  role_id     BIGINT UNSIGNED NOT NULL,
  scope_type  VARCHAR(50)     DEFAULT NULL, -- 'city','region','global'
  scope_value VARCHAR(100)    DEFAULT NULL,
  granted_by  BIGINT UNSIGNED DEFAULT NULL,
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_user_role_scope (user_id, role_id, scope_type, scope_value),
  CONSTRAINT fk_ur_user    FOREIGN KEY (user_id)    REFERENCES users (id) ON DELETE CASCADE,
  CONSTRAINT fk_ur_role    FOREIGN KEY (role_id)    REFERENCES roles (id) ON DELETE CASCADE,
  CONSTRAINT fk_ur_granter FOREIGN KEY (granted_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE audit_logs (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  actor_id     BIGINT UNSIGNED NOT NULL,
  action       VARCHAR(100)    NOT NULL,
  entity_type  VARCHAR(50)     NOT NULL,
  entity_id    BIGINT UNSIGNED NOT NULL,
  old_values   JSON            DEFAULT NULL,
  new_values   JSON            DEFAULT NULL,
  ip_address   VARCHAR(45)     DEFAULT NULL,
  user_agent   TEXT            DEFAULT NULL,
  created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_al_actor      (actor_id),
  KEY idx_al_entity     (entity_type, entity_id),
  KEY idx_al_action_ts  (action, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE system_configs (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  config_key  VARCHAR(200)    NOT NULL,
  config_value TEXT           NOT NULL,
  value_type  ENUM('string','integer','decimal','boolean','json') NOT NULL DEFAULT 'string',
  group_name  VARCHAR(100)    NOT NULL,
  description TEXT            DEFAULT NULL,
  is_public   TINYINT(1)      NOT NULL DEFAULT 0,
  updated_by  BIGINT UNSIGNED DEFAULT NULL,
  created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id      BIGINT UNSIGNED NOT NULL,
  type         VARCHAR(100)    NOT NULL,
  title        VARCHAR(500)    NOT NULL,
  body         TEXT            NOT NULL,
  data         JSON            DEFAULT NULL,
  is_read      TINYINT(1)      NOT NULL DEFAULT 0,
  read_at      DATETIME        DEFAULT NULL,
  created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_notif_user_read (user_id, is_read),
  CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE loyalty_points (
  id            BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
  user_id       BIGINT UNSIGNED  NOT NULL,
  type          ENUM('earn','redeem','expire','adjust') NOT NULL,
  points        INT              NOT NULL,
  balance_after INT UNSIGNED     NOT NULL,
  ref_type      VARCHAR(50)      DEFAULT NULL,
  ref_id        BIGINT UNSIGNED  DEFAULT NULL,
  description   VARCHAR(500)     DEFAULT NULL,
  expires_at    DATE             DEFAULT NULL,
  created_at    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_lp_user (user_id),
  CONSTRAINT fk_lp_user FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE voucher_usages (
  id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  voucher_id       BIGINT UNSIGNED NOT NULL,
  user_id          BIGINT UNSIGNED NOT NULL,
  booking_id       BIGINT UNSIGNED NOT NULL,
  discount_applied DECIMAL(12,2)   NOT NULL,
  used_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_vu_voucher_booking (voucher_id, booking_id),
  KEY idx_vu_user    (user_id),
  KEY idx_vu_voucher (voucher_id, user_id), -- enforce max_uses_per_user check
  CONSTRAINT fk_vu_voucher FOREIGN KEY (voucher_id) REFERENCES vouchers  (id),
  CONSTRAINT fk_vu_user    FOREIGN KEY (user_id)    REFERENCES users     (id),
  CONSTRAINT fk_vu_booking FOREIGN KEY (booking_id) REFERENCES bookings  (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE platform_fee_configs (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name           VARCHAR(200)    NOT NULL,
  fee_type       ENUM('percent','fixed') NOT NULL,
  fee_value      DECIMAL(8,4)    NOT NULL,
  applies_to     ENUM('all','property_type','partner_tier','country') NOT NULL DEFAULT 'all',
  applies_value  VARCHAR(100)    DEFAULT NULL, -- 'hotel', 'gold', 'VN'
  min_fee        DECIMAL(12,2)   DEFAULT NULL,
  max_fee        DECIMAL(12,2)   DEFAULT NULL,
  effective_from DATE            NOT NULL,
  effective_to   DATE            DEFAULT NULL,
  is_active      TINYINT(1)      NOT NULL DEFAULT 1,
  created_by     BIGINT UNSIGNED NOT NULL,
  created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pfc_active_date (is_active, effective_from, effective_to),
  KEY idx_pfc_applies     (applies_to, applies_value),
  CONSTRAINT fk_pfc_creator FOREIGN KEY (created_by) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE booking_fees (
  id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  booking_id     BIGINT UNSIGNED NOT NULL,
  fee_config_id  BIGINT UNSIGNED DEFAULT NULL,
  fee_name       VARCHAR(200)    NOT NULL, -- snapshot tên lúc tạo booking
  fee_type       ENUM('platform','vat','service','other') NOT NULL,
  rate_snapshot  DECIMAL(8,4)    DEFAULT NULL, -- % lưu lại tại thời điểm booking
  base_amount    DECIMAL(12,2)   NOT NULL,
  fee_amount     DECIMAL(12,2)   NOT NULL,
  charged_to     ENUM('customer','partner') NOT NULL,
  created_at     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_bf_booking      (booking_id),
  KEY idx_bf_type_charged (fee_type, charged_to),
  CONSTRAINT fk_bf_booking     FOREIGN KEY (booking_id)    REFERENCES bookings             (id) ON DELETE CASCADE,
  CONSTRAINT fk_bf_fee_config  FOREIGN KEY (fee_config_id) REFERENCES platform_fee_configs (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci

-- Bổ sung 2 cột tổng hợp fee (denormalized) vào bookings
-- Tránh phải JOIN booking_fees mỗi lần query
ALTER TABLE bookings
  ADD COLUMN platform_fee_amount   DECIMAL(12,2) NOT NULL DEFAULT 0.00
    COMMENT 'Tổng phí nền tảng, denorm từ booking_fees'
    AFTER tax_amount,
  ADD COLUMN partner_payout_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00
    COMMENT 'Số đối tác nhận = total - platform_fee - tax'
    AFTER platform_fee_amount;
    
    -- 1. Bảng lưu trữ các cấu hình luật đánh giá rủi ro (Nên có để dễ dàng bật/tắt/thay đổi trọng số)
CREATE TABLE risk_rules (
  id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  rule_code    VARCHAR(100)    NOT NULL, -- VD: 'MULTIPLE_FAILED_PAYMENTS', 'IP_BLACKLISTED'
  name         VARCHAR(255)    NOT NULL,
  description  TEXT            DEFAULT NULL,
  risk_weight  DECIMAL(5,2)    NOT NULL DEFAULT 10.00, -- Điểm rủi ro cộng thêm nếu vi phạm
  is_active    TINYINT(1)      NOT NULL DEFAULT 1,
  created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_risk_rule_code (rule_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng lưu trữ lịch sử đánh giá rủi ro trên từng giao dịch
CREATE TABLE risk_assessments (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  payment_id      BIGINT UNSIGNED NOT NULL, -- Map với transaction_id của bạn
  booking_id      BIGINT UNSIGNED NOT NULL, -- Lưu thêm context của booking
  user_id         BIGINT UNSIGNED NOT NULL, -- Người thực hiện giao dịch
  risk_score      DECIMAL(5,2)    NOT NULL DEFAULT 0.00,
  decision        ENUM('approve', 'review', 'reject') NOT NULL DEFAULT 'review',
  triggered_rules JSON            DEFAULT NULL, -- Lưu snapshot mảng các rule_code đã vi phạm
  reviewed_by     BIGINT UNSIGNED DEFAULT NULL, -- Admin/Nhân viên duyệt thủ công nếu rơi vào trạng thái 'review'
  reviewed_at     DATETIME        DEFAULT NULL,
  notes           TEXT            DEFAULT NULL, -- Ghi chú của admin khi duyệt
  created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_risk_payment (payment_id),
  KEY idx_risk_decision (decision, risk_score),
  KEY idx_risk_user (user_id),
  CONSTRAINT fk_risk_payment  FOREIGN KEY (payment_id)  REFERENCES payments (id) ON DELETE CASCADE,
  CONSTRAINT fk_risk_booking  FOREIGN KEY (booking_id)  REFERENCES bookings (id) ON DELETE CASCADE,
  CONSTRAINT fk_risk_user     FOREIGN KEY (user_id)     REFERENCES users (id),
  CONSTRAINT fk_risk_reviewer FOREIGN KEY (reviewed_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;