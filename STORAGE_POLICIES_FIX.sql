-- ========================================
-- STORAGE POLICIES FIX
-- ========================================
-- This SQL creates the necessary Row Level Security (RLS) policies
-- to allow authenticated users to upload images, videos, and AR/VR content
-- to your storage buckets.
--
-- RUN THIS IN YOUR SUPABASE SQL EDITOR
-- ========================================

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Anyone can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view images" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own images" ON storage.objects;

DROP POLICY IF EXISTS "Anyone can upload videos" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view videos" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own videos" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own videos" ON storage.objects;

DROP POLICY IF EXISTS "Anyone can upload AR/VR content" ON storage.objects;
DROP POLICY IF EXISTS "Anyone can view AR/VR content" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own AR/VR content" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own AR/VR content" ON storage.objects;

-- ========================================
-- PROPERTY IMAGES BUCKET POLICIES
-- ========================================

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

-- ========================================
-- PROPERTY VIDEOS BUCKET POLICIES
-- ========================================

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

-- ========================================
-- PROPERTY AR/VR BUCKET POLICIES
-- ========================================

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

-- ========================================
-- VERIFICATION QUERY
-- ========================================
-- Run this to verify all policies were created successfully

SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual
FROM pg_policies
WHERE tablename = 'objects'
  AND schemaname = 'storage'
ORDER BY policyname;
