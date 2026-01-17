-- ============================================
-- REAL ESTATE APP - SUPABASE DATABASE SCHEMA
-- ============================================
-- This SQL script creates all necessary tables for your property listing app
-- Copy and paste this into your Supabase SQL Editor

-- ============================================
-- 1. PROPERTIES TABLE (Main table)
-- ============================================
CREATE TABLE IF NOT EXISTS properties (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- User Information (link to Supabase Auth)
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,

  -- STEP 1: Basic Property Details
  property_name TEXT NOT NULL,
  property_for TEXT NOT NULL CHECK (property_for IN ('sell', 'rent')),
  property_type_sell TEXT CHECK (property_type_sell IN ('Plot', 'Commercial Land', 'Flat', 'Individual House', 'Individual Villa', 'Complex', 'Commercial Building')),
  property_type_rent TEXT CHECK (property_type_rent IN ('Flat', 'Individual House', 'Individual Villa', 'PG / Hostel', 'Shared Room', 'Independent Floor', 'Commercial Building', 'Office Space', 'Shop / Showroom', 'Warehouse / Godown')),

  land_extent NUMERIC(10, 2), -- in sqft
  built_up_area NUMERIC(10, 2), -- in sqft
  size_range TEXT,
  bedrooms TEXT,
  bathrooms TEXT,
  floor_no INTEGER,
  total_floors INTEGER,

  facing_direction TEXT CHECK (facing_direction IN ('North', 'South', 'East', 'West', 'North-East', 'North-West', 'South-East', 'South-West')),
  furnishing_status TEXT CHECK (furnishing_status IN ('Unfurnished', 'Semi Furnished', 'Fully Furnished')),
  furnishing_items JSONB, -- Store as JSON array: ["Beds", "Wardrobe", "AC"]
  nearby_amenities JSONB, -- Store as JSON array: ["School", "Hospital", "Park"]

  -- STEP 2: Location Details
  state TEXT NOT NULL,
  city TEXT NOT NULL,
  locality TEXT,
  landmark TEXT,
  pincode TEXT,
  google_maps_link TEXT,

  -- STEP 3: Pricing & Details
  price NUMERIC(15, 2),
  price_per_sqft NUMERIC(10, 2),
  uds_sqft NUMERIC(10, 2),
  maintenance_monthly NUMERIC(10, 2),
  monthly_rent NUMERIC(10, 2),
  security_deposit NUMERIC(10, 2),

  -- Additional Property Details
  age_of_property TEXT,
  possession_status TEXT,
  transaction_type TEXT,
  ownership_type TEXT,
  approval_status TEXT,
  property_description TEXT,

  -- Commercial Property Fields
  monthly_rental_income NUMERIC(12, 2),
  annual_yield NUMERIC(5, 2),

  -- PG/Hostel Fields
  max_occupancy INTEGER,

  -- Warehouse Fields
  ceiling_height NUMERIC(5, 2),

  -- LEASE FIELDS (for eligible rent properties)
  is_lease_property BOOLEAN DEFAULT FALSE,
  lease_duration TEXT,
  lock_in_period TEXT,
  notice_period TEXT,
  lease_rent_monthly NUMERIC(12, 2),
  lease_security_deposit NUMERIC(12, 2),
  rent_escalation_percent NUMERIC(5, 2),
  occupancy_status TEXT,
  lease_start_date DATE,
  lease_type TEXT CHECK (lease_type IN ('Gross Lease', 'Net Lease', 'Semi-Gross Lease')),
  registration_required BOOLEAN DEFAULT FALSE,

  -- STEP 4: Media URLs (stored in Supabase Storage)
  cover_image_url TEXT, -- First uploaded image
  image_urls JSONB, -- Array of image URLs
  video_url TEXT,
  virtual_tour_url TEXT,
  ar_content_url TEXT,
  vr_content_url TEXT,

  -- STEP 5: Contact & Agent Details
  contact_name TEXT NOT NULL,
  contact_mobile TEXT NOT NULL,
  contact_email TEXT,
  whatsapp_available BOOLEAN DEFAULT FALSE,

  listed_by TEXT CHECK (listed_by IN ('Owner', 'Agent', 'Builder')),

  -- Agent/Agency Details
  agency_name TEXT,
  rera_number TEXT,
  broker_fee_percent NUMERIC(5, 2),
  office_address TEXT,

  -- Builder Details
  company_name TEXT,
  gst_number TEXT,
  company_address TEXT,

  -- Metadata
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'sold', 'rented')),
  views_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_property_type CHECK (
    (property_for = 'sell' AND property_type_sell IS NOT NULL) OR
    (property_for = 'rent' AND property_type_rent IS NOT NULL)
  )
);

-- ============================================
-- 2. PROPERTY IMAGES TABLE (for better media management)
-- ============================================
CREATE TABLE IF NOT EXISTS property_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  is_cover BOOLEAN DEFAULT FALSE,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 3. PROPERTY VIEWS TABLE (track property views)
-- ============================================
CREATE TABLE IF NOT EXISTS property_views (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT
);

-- ============================================
-- 4. SAVED PROPERTIES TABLE (user favorites)
-- ============================================
CREATE TABLE IF NOT EXISTS saved_properties (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
  saved_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, property_id)
);

-- ============================================
-- 5. INDEXES FOR BETTER PERFORMANCE
-- ============================================
CREATE INDEX IF NOT EXISTS idx_properties_user_id ON properties(user_id);
CREATE INDEX IF NOT EXISTS idx_properties_property_for ON properties(property_for);
CREATE INDEX IF NOT EXISTS idx_properties_state_city ON properties(state, city);
CREATE INDEX IF NOT EXISTS idx_properties_price ON properties(price);
CREATE INDEX IF NOT EXISTS idx_properties_created_at ON properties(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_properties_status ON properties(status);
CREATE INDEX IF NOT EXISTS idx_property_images_property_id ON property_images(property_id);
CREATE INDEX IF NOT EXISTS idx_property_views_property_id ON property_views(property_id);
CREATE INDEX IF NOT EXISTS idx_saved_properties_user_id ON saved_properties(user_id);

-- ============================================
-- 6. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE property_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE property_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_properties ENABLE ROW LEVEL SECURITY;

-- Properties: Users can read all active properties
CREATE POLICY "Anyone can view active properties"
  ON properties FOR SELECT
  USING (status = 'active');

-- Properties: Users can insert their own properties
CREATE POLICY "Users can insert own properties"
  ON properties FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Properties: Users can update their own properties
CREATE POLICY "Users can update own properties"
  ON properties FOR UPDATE
  USING (auth.uid() = user_id);

-- Properties: Users can delete their own properties
CREATE POLICY "Users can delete own properties"
  ON properties FOR DELETE
  USING (auth.uid() = user_id);

-- Property Images: Anyone can view images of active properties
CREATE POLICY "Anyone can view property images"
  ON property_images FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM properties
      WHERE properties.id = property_images.property_id
      AND properties.status = 'active'
    )
  );

-- Property Images: Users can insert images for their own properties
CREATE POLICY "Users can insert images for own properties"
  ON property_images FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM properties
      WHERE properties.id = property_images.property_id
      AND properties.user_id = auth.uid()
    )
  );

-- Property Images: Users can delete images of their own properties
CREATE POLICY "Users can delete own property images"
  ON property_images FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM properties
      WHERE properties.id = property_images.property_id
      AND properties.user_id = auth.uid()
    )
  );

-- Property Views: Anyone can view property views
CREATE POLICY "Anyone can view property views"
  ON property_views FOR SELECT
  USING (true);

-- Property Views: Anyone can insert property views
CREATE POLICY "Anyone can insert property views"
  ON property_views FOR INSERT
  WITH CHECK (true);

-- Saved Properties: Users can view their own saved properties
CREATE POLICY "Users can view own saved properties"
  ON saved_properties FOR SELECT
  USING (auth.uid() = user_id);

-- Saved Properties: Users can insert their own saved properties
CREATE POLICY "Users can insert own saved properties"
  ON saved_properties FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Saved Properties: Users can delete their own saved properties
CREATE POLICY "Users can delete own saved properties"
  ON saved_properties FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 7. FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at on properties table
CREATE TRIGGER update_properties_updated_at
  BEFORE UPDATE ON properties
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function to increment views count
CREATE OR REPLACE FUNCTION increment_property_views()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE properties
  SET views_count = views_count + 1
  WHERE id = NEW.property_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to increment views when a new view is recorded
CREATE TRIGGER increment_views_on_insert
  AFTER INSERT ON property_views
  FOR EACH ROW
  EXECUTE FUNCTION increment_property_views();

-- ============================================
-- 8. STORAGE BUCKETS (Run in Supabase Dashboard)
-- ============================================
-- You need to create these storage buckets manually in Supabase Dashboard:
-- 1. Bucket name: "property-images" (public)
-- 2. Bucket name: "property-videos" (public)
-- 3. Bucket name: "property-ar-vr" (public)

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- Your database schema is now ready.
-- Next steps:
-- 1. Create storage buckets in Supabase Dashboard
-- 2. Update your Flutter app to use these tables
-- 3. Test by submitting a property
