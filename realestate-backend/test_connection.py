from database import get_supabase_client

supabase = get_supabase_client()

try:
    response = supabase.table("properties").select("*").execute()
    print("✅ Connection successful!")
    print(f"Found {len(response.data)} properties")
    for prop in response.data:
        print(f"  - {prop['title']}: {prop['price']}")
except Exception as e:
    print(f"❌ Error: {e}")