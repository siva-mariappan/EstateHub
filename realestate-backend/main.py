from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from models import Property, PropertyUpdate
from database import get_supabase_client
from typing import Optional, List

app = FastAPI(title="Real Estate API")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

supabase = get_supabase_client()

@app.get("/")
def read_root():
    return {"message": "Welcome to Real Estate API"}

# Get all properties with filters
@app.get("/properties")
def get_properties(
    purpose: Optional[str] = None,
    type: Optional[str] = None,
    locality: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    bedrooms: Optional[int] = None,
    verified: Optional[bool] = None,
    featured: Optional[bool] = None
):
    try:
        query = supabase.table("properties").select("*")
        
        if purpose:
            query = query.eq("purpose", purpose)
        if type:
            query = query.eq("type", type)
        if locality:
            query = query.ilike("locality", f"%{locality}%")
        if min_price:
            query = query.gte("price", min_price)
        if max_price:
            query = query.lte("price", max_price)
        if bedrooms:
            query = query.eq("bedrooms", bedrooms)
        if verified is not None:
            query = query.eq("verified", verified)
        if featured is not None:
            query = query.eq("featured", featured)
            
        response = query.order("created_at", desc=True).execute()
        return {"properties": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Get featured properties
@app.get("/properties/featured")
def get_featured_properties():
    try:
        response = supabase.table("properties").select("*").eq("featured", True).limit(6).execute()
        return {"properties": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Get single property by ID
@app.get("/properties/{property_id}")
def get_property(property_id: int):
    try:
        response = supabase.table("properties").select("*").eq("id", property_id).execute()
        if len(response.data) == 0:
            raise HTTPException(status_code=404, detail="Property not found")
        return response.data[0]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Create new property
@app.post("/properties")
def create_property(property: Property):
    try:
        property_dict = property.dict()
        response = supabase.table("properties").insert(property_dict).execute()
        return {"message": "Property created successfully", "data": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Update property
@app.put("/properties/{property_id}")
def update_property(property_id: int, property: PropertyUpdate):
    try:
        update_data = {k: v for k, v in property.dict().items() if v is not None}
        response = supabase.table("properties").update(update_data).eq("id", property_id).execute()
        return {"message": "Property updated successfully", "data": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Delete property
@app.delete("/properties/{property_id}")
def delete_property(property_id: int):
    try:
        response = supabase.table("properties").delete().eq("id", property_id).execute()
        return {"message": "Property deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Search properties
@app.get("/properties/search")
def search_properties(q: str):
    try:
        response = supabase.table("properties").select("*").or_(
            f"title.ilike.%{q}%,location.ilike.%{q}%,locality.ilike.%{q}%,description.ilike.%{q}%"
        ).execute()
        return {"properties": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)