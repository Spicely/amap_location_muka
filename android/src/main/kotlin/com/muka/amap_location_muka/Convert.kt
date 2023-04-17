package com.muka.amap_location_muka

import com.amap.api.location.AMapLocation


class Convert {
    companion object {
        fun toJson(location: AMapLocation): HashMap<String, Any> {
            val data = HashMap<String, Any>()
            data["latitude"] = location.latitude
            data["longitude"] = location.longitude
            data["accuracy"] = location.accuracy
            data["speed"] = location.speed
            data["time"] = location.time
            // 以下是定位sdk返回的逆地理信息
            data["coordType"] = location.coordType
            data["country"] = location.country
            data["city"] = location.city
            data["district"] = location.district
            data["street"] = location.street
            data["address"] = location.address
            data["province"] = location.province
            data["cityCode"] = location.cityCode
            data["adCode"] = location.adCode
            return data
        }
    }
}