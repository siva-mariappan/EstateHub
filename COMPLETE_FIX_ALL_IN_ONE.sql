-- ============================================
-- COMPLETE REAL ESTATE DATABASE SETUP
-- ============================================
-- All-in-one SQL script for Supabase
-- 
-- This script includes:
-- ✅ Complete database schema (tables, indexes)
-- ✅ Row Level Security (RLS) policies
-- ✅ Storage bucket policies
-- ✅ Functions and triggers
-- ✅ Data fixes (property names, prices, amenities)
-- ✅ Verification queries
--
-- HOW TO USE:
-- 1. Go to Supabase Dashboard → SQL Editor
-- 2. Copy this ENTIRE file
-- 3. Paste and click "Run"
-- 4. Check verification results at the bottom
-- 5. Create storage buckets manually (see instructions below)
-- 6. Refresh your Flutter app
-- ============================================

-- ============================================
-- PART 1: DROP EXISTING OBJECTS (OPTIONAL)
-- ============================================
-- ⚠️ WARNING: Uncomment this section ONLY if you want to start fresh
-- This will DELETE ALL existing data!

/*
DROP TABLE IF EXISTS saved_properties CASCADE;
DROP TABLE IF EXISTS property_views CASCADE;
DROP TABLE IF EXISTS property_images CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP FUNCTION IF EXISTS increment_property_views() CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
*/

-- ============================================
-- PART 2: CREATE MAIN PROPERTIES TABLE
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
  nearby_amenities JSONB, -- Store as JSON object: {"school": "Nearby School", "hospital": "Nearby Hospital"}

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

  listed_by TEXT CHECK (listed_by IN ('owner', 'agent', 'builder')),

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
-- PART 3: CREATE PROPERTY IMAGES TABLE
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
-- PART 4: CREATE PROPERTY VIEWS TABLE
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
-- PART 5: CREATE SAVED PROPERTIES TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS saved_properties (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  property_id UUID REFERENCES properties(id) ON DELETE CASCADE,
  saved_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, property_id)
);

-- ============================================
-- PART 6: CREATE INDEXES FOR PERFORMANCE
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
-- PART 7: FIX LISTED_BY CONSTRAINT
-- ============================================

ALTER TABLE properties
DROP CONSTRAINT IF EXISTS properties_listed_by_check;

ALTER TABLE properties
ADD CONSTRAINT properties_listed_by_check
CHECK (listed_by IN ('owner', 'agent', 'builder'));

-- ============================================
-- PART 8: ENABLE ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE property_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE property_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_properties ENABLE ROW LEVEL SECURITY;

-- ============================================
-- PART 9: CREATE RLS POLICIES FOR PROPERTIES
-- ============================================

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Anyone can view active properties" ON properties;
DROP POLICY IF EXISTS "Users can insert own properties" ON properties;
DROP POLICY IF EXISTS "Users can update own properties" ON properties;
DROP POLICY IF EXISTS "Users can delete own properties" ON properties;

-- Anyone can view active properties
CREATE POLICY "Anyone can view active properties"
  ON properties FOR SELECT
  USING (status = 'active');

-- Users can insert their own properties
CREATE POLICY "Users can insert own properties"
  ON properties FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own properties
CREATE POLICY "Users can update own properties"
  ON properties FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own properties
CREATE POLICY "Users can delete own properties"
  ON properties FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- PART 10: CREATE RLS POLICIES FOR PROPERTY IMAGES
-- ============================================

DROP POLICY IF EXISTS "Anyone can view property images" ON property_images;
DROP POLICY IF EXISTS "Users can insert images for own properties" ON property_images;
DROP POLICY IF EXISTS "Users can delete own property images" ON property_images;

-- Anyone can view images of active properties
CREATE POLICY "Anyone can view property images"
  ON property_images FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM properties
      WHERE properties.id = property_images.property_id
      AND properties.status = 'active'
    )
  );

-- Users can insert images for their own properties
CREATE POLICY "Users can insert images for own properties"
  ON property_images FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM properties
      WHERE properties.id = property_images.property_id
      AND properties.user_id = auth.uid()
    )
  );

-- Users can delete images of their own properties
CREATE POLICY "Users can delete own property images"
  ON property_images FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM properties
      WHERE properties.id = property_images.property_id
      AND properties.user_id = auth.uid()
    )
  );

-- ============================================
-- PART 11: CREATE RLS POLICIES FOR PROPERTY VIEWS
-- ============================================

DROP POLICY IF EXISTS "Anyone can view property views" ON property_views;
DROP POLICY IF EXISTS "Anyone can insert property views" ON property_views;

-- Anyone can view property views
CREATE POLICY "Anyone can view property views"
  ON property_views FOR SELECT
  USING (true);

-- Anyone can insert property views
CREATE POLICY "Anyone can insert property views"
  ON property_views FOR INSERT
  WITH CHECK (true);

-- ============================================
-- PART 12: CREATE RLS POLICIES FOR SAVED PROPERTIES
-- ============================================

DROP POLICY IF EXISTS "Users can view own saved properties" ON saved_properties;
DROP POLICY IF EXISTS "Users can insert own saved properties" ON saved_properties;
DROP POLICY IF EXISTS "Users can delete own saved properties" ON saved_properties;

-- Users can view their own saved properties
CREATE POLICY "Users can view own saved properties"
  ON saved_properties FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own saved properties
CREATE POLICY "Users can insert own saved properties"
  ON saved_properties FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own saved properties
CREATE POLICY "Users can delete own saved properties"
  ON saved_properties FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- PART 13: CREATE STORAGE POLICIES - PROPERTY IMAGES
-- ============================================

DROP POLICY IF EXISTS "Authenticated users can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view images" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own images" ON storage.objects;

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'property-images');

-- Allow everyone to view images (public bucket)
CREATE POLICY "Anyone can view images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'property-images');

-- Allow users to update their own images
CREATE POLICY "Users can update their own images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'property-images' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow users to delete their own images
CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'property-images' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ============================================
-- PART 14: CREATE STORAGE POLICIES - PROPERTY VIDEOS
-- ============================================

DROP POLICY IF EXISTS "Authenticated users can upload videos" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view videos" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own videos" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own videos" ON storage.objects;

-- Allow authenticated users to upload videos
CREATE POLICY "Authenticated users can upload videos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'property-videos');

-- Allow everyone to view videos (public bucket)
CREATE POLICY "Anyone can view videos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'property-videos');

-- Allow users to update their own videos
CREATE POLICY "Users can update their own videos"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'property-videos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow users to delete their own videos
CREATE POLICY "Users can delete their own videos"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'property-videos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ============================================
-- PART 15: CREATE STORAGE POLICIES - AR/VR CONTENT
-- ============================================

DROP POLICY IF EXISTS "Authenticated users can upload AR/VR content" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view AR/VR content" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own AR/VR content" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own AR/VR content" ON storage.objects;

-- Allow authenticated users to upload AR/VR content
CREATE POLICY "Authenticated users can upload AR/VR content"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'property-ar-vr');

-- Allow everyone to view AR/VR content (public bucket)
CREATE POLICY "Anyone can view AR/VR content"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'property-ar-vr');

-- Allow users to update their own AR/VR content
CREATE POLICY "Users can update their own AR/VR content"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'property-ar-vr' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow users to delete their own AR/VR content
CREATE POLICY "Users can delete their own AR/VR content"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'property-ar-vr' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ============================================
-- PART 16: CREATE FUNCTIONS
-- ============================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

-- ============================================
-- PART 17: CREATE TRIGGERS
-- ============================================

-- Drop existing triggers to avoid conflicts
DROP TRIGGER IF EXISTS update_properties_updated_at ON properties;
DROP TRIGGER IF EXISTS increment_views_on_insert ON property_views;

-- Trigger to auto-update updated_at on properties table
CREATE TRIGGER update_properties_updated_at
  BEFORE UPDATE ON properties
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger to increment views when a new view is recorded
CREATE TRIGGER increment_views_on_insert
  AFTER INSERT ON property_views
  FOR EACH ROW
  EXECUTE FUNCTION increment_property_views();

-- ============================================
-- PART 18: FIX EMPTY PROPERTY NAMES
-- ============================================
-- ⚠️ IMPORTANT: This ONLY updates properties with NULL, empty (''), or "EMPTY" values
-- Properties with user-entered names are PRESERVED ✅

UPDATE properties
SET property_name =
  CASE
    -- =====================================
    -- FOR SELL PROPERTIES
    -- =====================================
    WHEN property_type_sell = 'Individual Villa' THEN
      COALESCE(bedrooms || ' ', '') || 'Villa in ' || city

    WHEN property_type_sell = 'Individual House' THEN
      COALESCE(bedrooms || ' ', '') || 'House in ' || city

    WHEN property_type_sell = 'Flat' THEN
      COALESCE(bedrooms || ' ', '') || 'Flat in ' || city

    WHEN property_type_sell = 'Plot' THEN
      'Plot in ' || city

    WHEN property_type_sell = 'Commercial Land' THEN
      'Commercial Land in ' || city

    WHEN property_type_sell = 'Commercial Building' THEN
      'Commercial Building in ' || city

    WHEN property_type_sell = 'Complex' THEN
      'Residential Complex in ' || city

    -- =====================================
    -- FOR RENT PROPERTIES
    -- =====================================
    WHEN property_type_rent = 'Flat' THEN
      COALESCE(bedrooms || ' ', '') || 'Flat for Rent in ' || city

    WHEN property_type_rent = 'Individual House' THEN
      COALESCE(bedrooms || ' ', '') || 'House for Rent in ' || city

    WHEN property_type_rent = 'Individual Villa' THEN
      COALESCE(bedrooms || ' ', '') || 'Villa for Rent in ' || city

    WHEN property_type_rent = 'PG / Hostel' THEN
      'PG/Hostel in ' || city

    WHEN property_type_rent = 'Shared Room' THEN
      'Shared Room in ' || city

    WHEN property_type_rent = 'Independent Floor' THEN
      'Independent Floor in ' || city

    WHEN property_type_rent = 'Commercial Building' THEN
      'Commercial Space in ' || city

    WHEN property_type_rent = 'Office Space' THEN
      'Office Space in ' || city

    WHEN property_type_rent = 'Shop / Showroom' THEN
      'Shop/Showroom in ' || city

    WHEN property_type_rent = 'Warehouse / Godown' THEN
      'Warehouse in ' || city

    -- =====================================
    -- FALLBACK (If no type matches)
    -- =====================================
    ELSE 'Property in ' || city
  END
WHERE property_name IS NULL
   OR property_name = ''
   OR property_name = 'EMPTY';

-- ============================================
-- PART 19: FIX MISSING SALE PRICES
-- ============================================
-- Calculates price based on area (₹3000/sqft) or sets default by property type

UPDATE properties
SET price =
  CASE
    -- =====================================
    -- CALCULATE FROM AREA (PREFERRED)
    -- =====================================
    WHEN built_up_area IS NOT NULL AND built_up_area > 0 THEN
      built_up_area * 3000  -- ₹3000 per sqft

    WHEN land_extent IS NOT NULL AND land_extent > 0 THEN
      land_extent * 2000  -- ₹2000 per sqft for plots

    -- =====================================
    -- DEFAULT PRICES BY PROPERTY TYPE
    -- =====================================
    WHEN property_type_sell = 'Individual Villa' THEN 8000000    -- ₹80 Lakh
    WHEN property_type_sell = 'Individual House' THEN 5000000    -- ₹50 Lakh
    WHEN property_type_sell = 'Flat' THEN 3500000                -- ₹35 Lakh
    WHEN property_type_sell = 'Plot' THEN 2000000                -- ₹20 Lakh
    WHEN property_type_sell = 'Commercial Land' THEN 5000000     -- ₹50 Lakh
    WHEN property_type_sell = 'Commercial Building' THEN 10000000 -- ₹1 Crore
    WHEN property_type_sell = 'Complex' THEN 15000000            -- ₹1.5 Crore

    -- =====================================
    -- FALLBACK DEFAULT
    -- =====================================
    ELSE 1000000  -- ₹10 Lakh default
  END
WHERE property_for = 'sell'
  AND (price IS NULL OR price < 1000);

-- ============================================
-- PART 20: FIX MISSING RENT PRICES
-- ============================================
-- Calculates rent based on area (₹10/sqft/month) or sets default by property type

UPDATE properties
SET monthly_rent =
  CASE
    -- =====================================
    -- CALCULATE FROM AREA (PREFERRED)
    -- =====================================
    WHEN built_up_area IS NOT NULL AND built_up_area > 0 THEN
      built_up_area * 10  -- ₹10 per sqft per month

    -- =====================================
    -- DEFAULT RENT BY PROPERTY TYPE
    -- =====================================
    WHEN property_type_rent = 'Flat' THEN 15000                  -- ₹15,000/month
    WHEN property_type_rent = 'Individual House' THEN 20000      -- ₹20,000/month
    WHEN property_type_rent = 'Individual Villa' THEN 30000      -- ₹30,000/month
    WHEN property_type_rent = 'PG / Hostel' THEN 5000            -- ₹5,000/month
    WHEN property_type_rent = 'Shared Room' THEN 3000            -- ₹3,000/month
    WHEN property_type_rent = 'Independent Floor' THEN 18000     -- ₹18,000/month
    WHEN property_type_rent = 'Commercial Building' THEN 50000   -- ₹50,000/month
    WHEN property_type_rent = 'Office Space' THEN 25000          -- ₹25,000/month
    WHEN property_type_rent = 'Shop / Showroom' THEN 20000       -- ₹20,000/month
    WHEN property_type_rent = 'Warehouse / Godown' THEN 30000    -- ₹30,000/month

    -- =====================================
    -- FALLBACK DEFAULT
    -- =====================================
    ELSE 10000  -- ₹10,000/month default
  END
WHERE property_for = 'rent'
  AND (monthly_rent IS NULL OR monthly_rent < 100);

-- ============================================
-- PART 21: FIX AMENITIES FORMAT
-- ============================================
-- Convert amenities from array format ["School", "Hospital"]
-- To object format {"school": "Nearby School", "hospital": "Nearby Hospital"}

UPDATE properties
SET nearby_amenities = (
  SELECT jsonb_object_agg(
    LOWER(REPLACE(value::text, '"', '')),
    'Nearby ' || REPLACE(value::text, '"', '')
  )
  FROM jsonb_array_elements(nearby_amenities)
)
WHERE nearby_amenities IS NOT NULL 
  AND jsonb_typeof(nearby_amenities) = 'array';

-- ============================================
-- PART 22: VERIFICATION QUERIES
-- ============================================

-- Report 1: Tables Created
-- ========================================
SELECT 
  '✅ TABLES CREATED' as report_title;

SELECT 
  table_name,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
AND table_name IN ('properties', 'property_images', 'property_views', 'saved_properties')
ORDER BY table_name;

-- Report 2: RLS Status
-- ========================================
SELECT 
  '✅ ROW LEVEL SECURITY STATUS' as report_title;

SELECT 
  tablename,
  rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('properties', 'property_images', 'property_views', 'saved_properties')
ORDER BY tablename;

-- Report 3: RLS Policies Count
-- ========================================
SELECT 
  '✅ RLS POLICIES CREATED' as report_title;

SELECT 
  tablename,
  COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename IN ('properties', 'property_images', 'property_views', 'saved_properties')
GROUP BY tablename
ORDER BY tablename;

-- Report 4: Storage Policies
-- ========================================
SELECT 
  '✅ STORAGE POLICIES' as report_title;

SELECT 
  policyname,
  CASE 
    WHEN policyname LIKE '%property-images%' THEN 'property-images'
    WHEN policyname LIKE '%property-videos%' THEN 'property-videos'
    WHEN policyname LIKE '%ar-vr%' OR policyname LIKE '%AR/VR%' THEN 'property-ar-vr'
    ELSE 'unknown'
  END as bucket_name
FROM pg_policies 
WHERE tablename = 'objects'
  AND schemaname = 'storage'
ORDER BY policyname;

-- Report 5: Data Quality Check
-- ========================================
SELECT 
  '🔍 DATA QUALITY CHECK' as report_title;

SELECT
  COUNT(*) as total_properties,
  COUNT(CASE WHEN property_name IS NULL OR property_name = '' OR property_name = 'EMPTY' THEN 1 END) as empty_names,
  COUNT(CASE WHEN property_for = 'sell' AND (price IS NULL OR price < 1000) THEN 1 END) as missing_sale_prices,
  COUNT(CASE WHEN property_for = 'rent' AND (monthly_rent IS NULL OR monthly_rent < 100) THEN 1 END) as missing_rent_prices,
  COUNT(CASE WHEN nearby_amenities IS NOT NULL AND jsonb_typeof(nearby_amenities) = 'object' THEN 1 END) as amenities_in_correct_format,
  COUNT(CASE WHEN nearby_amenities IS NOT NULL AND jsonb_typeof(nearby_amenities) = 'array' THEN 1 END) as amenities_still_in_array_format
FROM properties;

-- Report 6: Property Statistics
-- ========================================
SELECT 
  '📈 PROPERTY STATISTICS' as report_title;

SELECT
  property_for,
  COUNT(*) as total_count,
  COUNT(CASE WHEN property_name IS NOT NULL AND property_name != '' THEN 1 END) as with_names,
  COUNT(CASE WHEN price > 0 THEN 1 END) as with_sale_price,
  COUNT(CASE WHEN monthly_rent > 0 THEN 1 END) as with_rent_price,
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active_listings
FROM properties
GROUP BY property_for;

-- Report 7: Sample Properties
-- ========================================
SELECT 
  '✨ SAMPLE PROPERTIES (First 5)' as report_title;

SELECT
  property_name,
  CASE
    WHEN property_for = 'sell' THEN
      CASE
        WHEN price >= 10000000 THEN CONCAT('₹', ROUND(price/10000000, 2), ' Cr')
        WHEN price >= 100000 THEN CONCAT('₹', ROUND(price/100000, 2), ' L')
        ELSE CONCAT('₹', price)
      END
    WHEN property_for = 'rent' THEN CONCAT('₹', monthly_rent, '/month')
  END as price_display,
  city,
  bedrooms,
  COALESCE(property_type_sell, property_type_rent, 'N/A') as property_type,
  nearby_amenities,
  status,
  created_at
FROM properties
ORDER BY created_at DESC
LIMIT 5;

-- Report 8: Indexes Created
-- ========================================
SELECT 
  '✅ INDEXES CREATED' as report_title;

SELECT 
  indexname,
  tablename
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('properties', 'property_images', 'property_views', 'saved_properties')
ORDER BY tablename, indexname;

-- ============================================
-- FINAL SUCCESS MESSAGE
-- ============================================

SELECT '

🎉🎉🎉 DATABASE SETUP COMPLETE! 🎉🎉🎉

✅ All tables created successfully
✅ All indexes created for optimal performance
✅ Row Level Security (RLS) enabled on all tables
✅ RLS policies configured for data security
✅ Storage policies set for images, videos, and AR/VR content
✅ Functions and triggers created
✅ Existing data fixed (names, prices, amenities)
✅ Ready to use!

📋 NEXT STEPS:

1. CREATE STORAGE BUCKETS (Manual Step Required):
   Go to Supabase Dashboard → Storage → Create these buckets:
   - Bucket name: "property-images" (public)
   - Bucket name: "property-videos" (public)  
   - Bucket name: "property-ar-vr" (public)

2. VERIFY YOUR SETUP:
   - Check the verification reports above
   - All counts should show 0 errors
   - Sample properties should display correctly

3. TEST YOUR APP:
   - Refresh your Flutter app
   - Try creating a new property listing
   - Verify it appears in the database correctly

4. TROUBLESHOOTING:
   - If you see errors, scroll up to see which part failed
   - Check that all verification queries returned expected results
   - Make sure storage buckets are created manually

💡 TIP: Save this SQL file for future reference!

' as completion_message;

-- ============================================
-- END OF SCRIPT
-- ============================================