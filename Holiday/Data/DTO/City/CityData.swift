//
//  City.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

struct CityData: Decodable {
    let cities: [City]
}

extension CityData {
    struct City: Decodable, Hashable {
        let koCityName: String
        let koCountryName: String
        let id: Int
    }
}

extension CityData {
    static let mock = CityData(cities: [
        CityData.City(koCityName: "리우데자네이루", koCountryName: "브라질", id: 3451190),
        CityData.City(koCityName: "소피아", koCountryName: "불가리아", id: 727011),
        CityData.City(koCityName: "와가두구", koCountryName: "부르키나파소", id: 2357048),
        CityData.City(koCityName: "프놈펜", koCountryName: "캄보디아", id: 1821306),
        CityData.City(koCityName: "야운데", koCountryName: "카메룬", id: 2220957),
        CityData.City(koCityName: "오타와", koCountryName: "캐나다", id: 6094817),
        CityData.City(koCityName: "토론토", koCountryName: "캐나다", id: 6167865),
        CityData.City(koCityName: "밴쿠버", koCountryName: "캐나다", id: 6173331),
        CityData.City(koCityName: "산티아고", koCountryName: "칠레", id: 3871336),
        CityData.City(koCityName: "베이징", koCountryName: "중국", id: 1816670),
        CityData.City(koCityName: "상하이", koCountryName: "중국", id: 1796236),
        CityData.City(koCityName: "광저우", koCountryName: "중국", id: 1809858),
        CityData.City(koCityName: "선전", koCountryName: "중국", id: 1795565),
        CityData.City(koCityName: "보고타", koCountryName: "콜롬비아", id: 3688689),
        CityData.City(koCityName: "킨샤사", koCountryName: "콩고민주공화국", id: 2314302),
        CityData.City(koCityName: "산호세", koCountryName: "코스타리카", id: 3621849),
        CityData.City(koCityName: "자그레브", koCountryName: "크로아티아", id: 3186886),
        CityData.City(koCityName: "아바나", koCountryName: "쿠바", id: 3553478),
        CityData.City(koCityName: "프라하", koCountryName: "체코", id: 3067696),
        CityData.City(koCityName: "코펜하겐", koCountryName: "덴마크", id: 2618425),
        CityData.City(koCityName: "카이로", koCountryName: "이집트", id: 360630),
        CityData.City(koCityName: "알렉산드리아", koCountryName: "이집트", id: 361058),
        CityData.City(koCityName: "아디스아바바", koCountryName: "에티오피아", id: 344979),
        CityData.City(koCityName: "헬싱키", koCountryName: "핀란드", id: 658225),
        CityData.City(koCityName: "파리", koCountryName: "프랑스", id: 2988507),
        CityData.City(koCityName: "마르세유", koCountryName: "프랑스", id: 2995469),
        CityData.City(koCityName: "리옹", koCountryName: "프랑스", id: 2996944),
        CityData.City(koCityName: "베를린", koCountryName: "독일", id: 2950159),
        CityData.City(koCityName: "함부르크", koCountryName: "독일", id: 2911298),
        CityData.City(koCityName: "뮌헨", koCountryName: "독일", id: 2867714),
        CityData.City(koCityName: "프랑크푸르트", koCountryName: "독일", id: 2925533),
        CityData.City(koCityName: "아크라", koCountryName: "가나", id: 2306104),
        CityData.City(koCityName: "아테네", koCountryName: "그리스", id: 264371),
        CityData.City(koCityName: "과테말라시티", koCountryName: "과테말라", id: 3598132),
        CityData.City(koCityName: "포르토프랭스", koCountryName: "아이티", id: 3718426),
        CityData.City(koCityName: "테구시갈파", koCountryName: "온두라스", id: 3600949),
        CityData.City(koCityName: "홍콩", koCountryName: "홍콩", id: 1819729),
        CityData.City(koCityName: "부다페스트", koCountryName: "헝가리", id: 3054643),
        CityData.City(koCityName: "레이캬비크", koCountryName: "아이슬란드", id: 3413829),
        CityData.City(koCityName: "뉴델리", koCountryName: "인도", id: 1261481),
        CityData.City(koCityName: "뭄바이", koCountryName: "인도", id: 1275339),
        CityData.City(koCityName: "방갈로르", koCountryName: "인도", id: 1277333),
        CityData.City(koCityName: "콜카타", koCountryName: "인도", id: 1275004),
        CityData.City(koCityName: "첸나이", koCountryName: "인도", id: 1264527),
        CityData.City(koCityName: "자카르타", koCountryName: "인도네시아", id: 1642911),
        CityData.City(koCityName: "수라바야", koCountryName: "인도네시아", id: 1625822),
        CityData.City(koCityName: "테헤란", koCountryName: "이란", id: 112931),
        CityData.City(koCityName: "바그다드", koCountryName: "이라크", id: 98182),
        CityData.City(koCityName: "더블린", koCountryName: "아일랜드", id: 2964574),
        CityData.City(koCityName: "텔아비브", koCountryName: "이스라엘", id: 293397),
        CityData.City(koCityName: "예루살렘", koCountryName: "이스라엘", id: 281184),
        CityData.City(koCityName: "로마", koCountryName: "이탈리아", id: 3169070),
        CityData.City(koCityName: "밀라노", koCountryName: "이탈리아", id: 3173435),
        CityData.City(koCityName: "도쿄", koCountryName: "일본", id: 1850147),
        CityData.City(koCityName: "오사카", koCountryName: "일본", id: 1853909),
        CityData.City(koCityName: "요코하마", koCountryName: "일본", id: 1848354),
        CityData.City(koCityName: "암만", koCountryName: "요르단", id: 250441),
        CityData.City(koCityName: "아스타나", koCountryName: "카자흐스탄", id: 1526384),
        CityData.City(koCityName: "나이로비", koCountryName: "케냐", id: 184745),
        CityData.City(koCityName: "쿠웨이트시티", koCountryName: "쿠웨이트", id: 285787),
        CityData.City(koCityName: "서울", koCountryName: "대한민국", id: 1835848),
        CityData.City(koCityName: "부산", koCountryName: "대한민국", id: 1838524),
        CityData.City(koCityName: "인천", koCountryName: "대한민국", id: 1843564),
        CityData.City(koCityName: "대구", koCountryName: "대한민국", id: 1835327),
        CityData.City(koCityName: "대전", koCountryName: "대한민국", id: 1835224),
        CityData.City(koCityName: "광주", koCountryName: "대한민국", id: 1841811),
        CityData.City(koCityName: "수원", koCountryName: "대한민국", id: 1835553),
        CityData.City(koCityName: "울산", koCountryName: "대한민국", id: 1833747),
        CityData.City(koCityName: "성남", koCountryName: "대한민국", id: 1835329),
        CityData.City(koCityName: "고양", koCountryName: "대한민국", id: 1842616),
        CityData.City(koCityName: "부천", koCountryName: "대한민국", id: 1838716),
        CityData.City(koCityName: "비엔티안", koCountryName: "라오스", id: 1651944),
        CityData.City(koCityName: "리가", koCountryName: "라트비아", id: 456172),
        CityData.City(koCityName: "베이루트", koCountryName: "레바논", id: 276781),
        CityData.City(koCityName: "빌뉴스", koCountryName: "리투아니아", id: 593116),
        CityData.City(koCityName: "룩셈부르크", koCountryName: "룩셈부르크", id: 2960316),
        CityData.City(koCityName: "스코페", koCountryName: "북마케도니아", id: 785842),
        CityData.City(koCityName: "쿠알라룸푸르", koCountryName: "말레이시아", id: 1735161),
        CityData.City(koCityName: "말레", koCountryName: "몰디브", id: 1282027),
        CityData.City(koCityName: "멕시코시티", koCountryName: "멕시코", id: 3530597),
        CityData.City(koCityName: "과달라하라", koCountryName: "멕시코", id: 4005539),
        CityData.City(koCityName: "울란바토르", koCountryName: "몽골", id: 2028462),
        CityData.City(koCityName: "라바트", koCountryName: "모로코", id: 2538475),
        CityData.City(koCityName: "양곤", koCountryName: "미얀마", id: 1298824),
        CityData.City(koCityName: "카트만두", koCountryName: "네팔", id: 1283240),
        CityData.City(koCityName: "암스테르담", koCountryName: "네덜란드", id: 2759794),
        CityData.City(koCityName: "웰링턴", koCountryName: "뉴질랜드", id: 2179537),
        CityData.City(koCityName: "오클랜드", koCountryName: "뉴질랜드", id: 2193733),
        CityData.City(koCityName: "오슬로", koCountryName: "노르웨이", id: 3143244)
    ])
}
