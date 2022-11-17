class PopulateRestaurants
  attr_accessor :everyone

  def initialize
    @everyone = []
    call_first
  end

  private

  def call_first
    response = client.post("v1/page/16d7f283-cfff-49b6-9616-921fd7af4d8a?latitude=-16.7017636&longitude=-49.2870146&channel=IFOOD", {"supported-headers":["OPERATION_HEADER"],"supported-cards":["MERCHANT_LIST","CATALOG_ITEM_LIST","CATALOG_ITEM_LIST_V2","CATALOG_ITEM_LIST_V3","FEATURED_MERCHANT_LIST","CATALOG_ITEM_CAROUSEL","CATALOG_ITEM_CAROUSEL_V2","CATALOG_ITEM_CAROUSEL_V3","BIG_BANNER_CAROUSEL","IMAGE_BANNER","MERCHANT_LIST_WITH_ITEMS_CAROUSEL","SMALL_BANNER_CAROUSEL","NEXT_CONTENT","MERCHANT_CAROUSEL","MERCHANT_TILE_CAROUSEL","SIMPLE_MERCHANT_CAROUSEL","INFO_CARD","MERCHANT_LIST_V2","ROUND_IMAGE_CAROUSEL","BANNER_GRID","MEDIUM_IMAGE_BANNER","MEDIUM_BANNER_CAROUSEL","RELATED_SEARCH_CAROUSEL"],"supported-actions":["catalog-item","merchant","page","card-content","last-restaurants","webmiddleware","reorder","search","groceries","home-tab"],"feed-feature-name":"","faster-overrides":""})

    # response = Faraday.post() do |req|
    #   f.response :json
    #   req.body = {"supported-headers":["OPERATION_HEADER"],"supported-cards":["MERCHANT_LIST","CATALOG_ITEM_LIST","CATALOG_ITEM_LIST_V2","CATALOG_ITEM_LIST_V3","FEATURED_MERCHANT_LIST","CATALOG_ITEM_CAROUSEL","CATALOG_ITEM_CAROUSEL_V2","CATALOG_ITEM_CAROUSEL_V3","BIG_BANNER_CAROUSEL","IMAGE_BANNER","MERCHANT_LIST_WITH_ITEMS_CAROUSEL","SMALL_BANNER_CAROUSEL","NEXT_CONTENT","MERCHANT_CAROUSEL","MERCHANT_TILE_CAROUSEL","SIMPLE_MERCHANT_CAROUSEL","INFO_CARD","MERCHANT_LIST_V2","ROUND_IMAGE_CAROUSEL","BANNER_GRID","MEDIUM_IMAGE_BANNER","MEDIUM_BANNER_CAROUSEL","RELATED_SEARCH_CAROUSEL"],"supported-actions":["catalog-item","merchant","page","card-content","last-restaurants","webmiddleware","reorder","search","groceries","home-tab"],"feed-feature-name":"","faster-overrides":""}.to_json
    # end
    response_body = response.body

    @everyone.concat(response_body["sections"][0]["cards"][0]["data"]["contents"])

    call_next(response_body["sections"][0]["cards"][1]["data"]["action"])
  end

  def call_next(next_content)
    set_cursor = next_content.split("?").last

    response = client.post("https://marketplace.ifood.com.br/v1/page/16d7f283-cfff-49b6-9616-921fd7af4d8a/section/fa134384-c528-48ed-870a-8608fbae1924?latitude=-16.7017636&longitude=-49.2870146&channel=IFOOD&section=fa134384-c528-48ed-870a-8608fbae1924&#{set_cursor}", {"supported-headers":["OPERATION_HEADER"],"supported-cards":["MERCHANT_LIST","CATALOG_ITEM_LIST","CATALOG_ITEM_LIST_V2","CATALOG_ITEM_LIST_V3","FEATURED_MERCHANT_LIST","CATALOG_ITEM_CAROUSEL","CATALOG_ITEM_CAROUSEL_V2","CATALOG_ITEM_CAROUSEL_V3","BIG_BANNER_CAROUSEL","IMAGE_BANNER","MERCHANT_LIST_WITH_ITEMS_CAROUSEL","SMALL_BANNER_CAROUSEL","NEXT_CONTENT","MERCHANT_CAROUSEL","MERCHANT_TILE_CAROUSEL","SIMPLE_MERCHANT_CAROUSEL","INFO_CARD","MERCHANT_LIST_V2","ROUND_IMAGE_CAROUSEL","BANNER_GRID","MEDIUM_IMAGE_BANNER","MEDIUM_BANNER_CAROUSEL","RELATED_SEARCH_CAROUSEL"],"supported-actions":["catalog-item","merchant","page","card-content","last-restaurants","webmiddleware","reorder","search","groceries","home-tab"],"feed-feature-name":"","faster-overrides":""})

    response_body = response.body

    @everyone.concat(response_body["cards"][0]["data"]["contents"])

    call_next(response_body["cards"][1]["data"]["action"]) if !response_body["cards"][1].nil?

  end

  def client
    Faraday.new("https://marketplace.ifood.com.br/") do |f|
      f.request :json # encode req bodies as JSON and automatically set the Content-Type header
      f.response :json # decode response bodies as JSON
    end
  end


end