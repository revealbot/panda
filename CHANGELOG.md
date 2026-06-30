## 0.5.0

* Add `token_info` [method](https://business-api.tiktok.com/portal/docs?id=1765927978092545) to validate TikTok profiles

## 0.5.1

* Use POST method for `token_info` request

## 0.5.2

* Use GET `user_info` to check tokens

## 0.6.0

* Switch to Faraday 2 [changelog](https://github.com/lostisland/faraday/blob/main/CHANGELOG.md) to support other updates

## 0.7.0

* Add 'app_list' [method](https://business-api.tiktok.com/portal/docs?id=1740859313270786) to list apps of an advertiser

## 0.8.0

* Add `smart_plus_ad_groups` [method](https://business-api.tiktok.com/portal/docs?id=1843314879617026) to list Upgraded Smart+ ad groups
* Add `smart_plus_ads` [method](https://business-api.tiktok.com/portal/docs/get-upgraded-smart-ads/v1.3) to list Upgraded Smart+ ads

## 0.8.1

* JSON-encode Hash params (e.g. `filtering`) in GET requests so callers no longer have to call `.to_json` themselves

## 0.9.0

* Auto-paginate collection requests: methods like `campaigns`, `ad_groups`, `ads`, etc. now collect every page and return all items, unless a specific `page` is requested
