//
//  NBU.swift
//  Basic
//
//  Created by developer on 27.12.2024.
//

import Foundation

actor NBU: API {
    let baseCurrency: Currency = "980"

    func exchangeInfo(for currency: Currency) async -> ExchangeRecord? {
        await exchangeRecord(for: currency)
    }

    func updateExchangeInfo(for currency: Currency? = nil) async {
        if let currency, let record = records[currency] {
            await updateRecords(for: record.currencySign)
        } else {
            await updateRecords()
        }
    }

    private var records: [Currency: ExchangeRecord] = [:]
}

extension NBU {
    struct CurrencyExchange: Codable {
        var exchangeDate: Date
        var currencyCode: Int
        var currencySign: String
        var ukrName: String
        var engName: String
        var rate: Double
        var units: Int
        var ratePerUnit: Double
        var group: String
        var calculationDate: Date
    }
}

extension NBU.CurrencyExchange {
    enum CodingKeys: String, CodingKey {
        case exchangeDate = "exchangedate"
        case currencyCode = "r030"
        case currencySign = "cc"
        case ukrName = "txt"
        case engName = "enname"
        case rate
        case units
        case ratePerUnit = "rate_per_unit"
        case group
        case calculationDate = "calcdate"
    }
}

private extension NBU {
    enum Constants {
        static let apiURL = "https://bank.gov.ua/NBU_Exchange/exchange_site"
        static let startDate = "start"
        static let endDate = "end"
        static let currencyCode = "valcode"
        static let jsonFormat = "json"
    }

    static let queryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()

    static let decoderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static func requestURL(startDate: Date? = nil, endDate: Date? = nil, currencyCode: String? = nil) -> URL? {
        guard var components = URLComponents(string: Constants.apiURL) else { return nil }

        var queryItems = [URLQueryItem]()
        if let startDate {
            queryItems.append(URLQueryItem(name: Constants.startDate, value: Self.queryDateFormatter.string(from: startDate)))
        }
        if let endDate {
            queryItems.append(URLQueryItem(name: Constants.endDate, value: Self.queryDateFormatter.string(from: endDate)))
        }
        if let currencyCode {
            queryItems.append(URLQueryItem(name: Constants.currencyCode, value: currencyCode))
        }
        queryItems.append(URLQueryItem(name: Constants.jsonFormat, value: nil))

        components.queryItems = queryItems
        return components.url
    }

    static func exchange(for requestURL: URL) async -> [CurrencyExchange]? {
        guard let (data, response) = try? await URLSession.shared.data(from: requestURL) else { return nil }

        if let httpResponse = response as? HTTPURLResponse {
            guard 200 == httpResponse.statusCode else { return nil }
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Self.decoderDateFormatter)
        return try? decoder.decode([CurrencyExchange].self, from: data)
    }

    func exchangeRecord(for currency: Currency) async -> ExchangeRecord? {
        guard records.isEmpty else { return records[currency] }

        await updateRecords()
        return records[currency]
    }

    func updateRecords(for currencyCode: String? = nil) async {
        let nowDate = Date.now
        guard let requestURL = Self.requestURL(startDate: nowDate, endDate: nowDate, currencyCode: currencyCode) else { return }
        guard let exchange = await Self.exchange(for: requestURL) else { return }

        exchange.forEach {
            let currency = "\($0.currencyCode)"
            records[currency] = ExchangeRecord(
                currencyCode: currency,
                currencySign: $0.currencySign,
                units: $0.units,
                amount: $0.rate
            )
        }
    }
}
