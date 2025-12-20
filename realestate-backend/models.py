from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class Property(BaseModel):
    title: str
    type: str  # 'plot', 'flat', 'apartment'
    purpose: str  # 'rent', 'buy', 'flat'
    area: float
    price: float
    location: str
    locality: str
    bedrooms: Optional[int] = None
    bathrooms: Optional[int] = None
    furnishing: Optional[str] = None  # 'furnished', 'semi-furnished', 'unfurnished'
    description: str
    amenities: List[str]
    images: List[str]
    verified: bool = False
    featured: bool = False
    agent_name: str
    agent_phone: str
    nearby_schools: Optional[List[str]] = None
    nearby_hospitals: Optional[List[str]] = None
    nearby_metro: Optional[List[str]] = None

class PropertyUpdate(BaseModel):
    title: Optional[str] = None
    type: Optional[str] = None
    purpose: Optional[str] = None
    area: Optional[float] = None
    price: Optional[float] = None
    location: Optional[str] = None
    locality: Optional[str] = None
    bedrooms: Optional[int] = None
    bathrooms: Optional[int] = None
    furnishing: Optional[str] = None
    description: Optional[str] = None
    amenities: Optional[List[str]] = None
    images: Optional[List[str]] = None
    verified: Optional[bool] = None
    featured: Optional[bool] = None
    agent_name: Optional[str] = None
    agent_phone: Optional[str] = None
    nearby_schools: Optional[List[str]] = None
    nearby_hospitals: Optional[List[str]] = None
    nearby_metro: Optional[List[str]] = None