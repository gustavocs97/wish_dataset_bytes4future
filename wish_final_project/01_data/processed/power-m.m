let
  Source = Csv.Document(File.Contents("/Users/gustavocarvalho/Developer/Bytes4Future-Bootcamp/wish/Datasets/Summer_Products.csv"), [Delimiter = ",", Columns = 43, Encoding = 65001]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"price", type number}, {"title", type text}, {"title_orig", type text}, {"retail_price", Int64.Type}, {"currency_buyer", type text}, {"units_sold", Int64.Type}, {"uses_ad_boosts", Int64.Type}, {"rating", type number}, {"rating_count", Int64.Type}, {"rating_five_count", Int64.Type}, {"rating_four_count", Int64.Type}, {"rating_three_count", Int64.Type}, {"rating_two_count", Int64.Type}, {"rating_one_count", Int64.Type}, {"badges_count", Int64.Type}, {"badge_local_product", Int64.Type}, {"badge_product_quality", Int64.Type}, {"badge_fast_shipping", Int64.Type}, {"tags", type text}, {"product_color", type text}, {"product_variation_size_id", type text}, {"product_variation_inventory", Int64.Type}, {"shipping_option_name", type text}, {"shipping_option_price", Int64.Type}, {"shipping_is_express", Int64.Type}, {"countries_shipped_to", Int64.Type}, {"inventory_total", Int64.Type}, {"has_urgency_banner", Int64.Type}, {"urgency_text", type text}, {"origin_country", type text}, {"merchant_title", type text}, {"merchant_name", type text}, {"merchant_info_subtitle", type text}, {"merchant_rating_count", Int64.Type}, {"merchant_rating", type number}, {"merchant_id", type text}, {"merchant_has_profile_picture", Int64.Type}, {"merchant_profile_picture", type text}, {"product_url", type text}, {"product_picture", type text}, {"product_id", type text}, {"theme", type text}, {"crawl_month", type date}}),
  #"Added custom" = Table.AddColumn(#"Changed column type", "priceIntFix", each [price] * 1, type number),
  #"Added index" = Table.AddIndexColumn(#"Added custom", "Index", 1, 1, Int64.Type),
  #"Added custom 1" = Table.AddColumn(#"Added index", "units_sold_EscalaFix", each if [units_sold] <= 10 then "1. Micro(10)"
else if [units_sold] <= 100 then "2. Baixo(100)"
else if [units_sold] <= 1000 then "3. Médio(1000)"
else if [units_sold] <= 10000 then "4. Alto(10000)"
else if [units_sold] <= 20000 then "5. Muito Alto(20000)"
else "6. Crítico(>20000)"),
  #"Added custom 3" = Table.AddColumn(#"Added custom 1", "rating_Base1000Fix", each (([rating]*100)*2)),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Added custom 3", {{"priceIntFix", Int64.Type}}),
  #"Renamed columns" = Table.RenameColumns(#"Changed column type 1", {{"Index", "Index_novo"}}),
  #"Added custom 2" = Table.AddColumn(#"Renamed columns", "product_color_GroupedColour", each let
    // Remove espaços nas pontas e ignora se é maiúscula ou minúscula
    cor = Text.Trim(Text.Lower([product_color])),

    // O nosso Switch Case para mapear e traduzir para a cor padrão
    CorPadronizada = 
        if cor = "" or cor = null 
            then "Não Informado"
        
        // CASE: Estampados e Multicores
        else if Text.Contains(cor, "&") 
             or Text.Contains(cor, "stripe") 
             or Text.Contains(cor, "print") 
             or Text.Contains(cor, "multicolor") 
             or Text.Contains(cor, "floral") 
             or Text.Contains(cor, "camouflage") 
             or Text.Contains(cor, "rainbow") 
             or Text.Contains(cor, "star") 
             or cor = "blackwhite"
            then "Multicor/Estampado"
        
        // CASE: Pretos e variações
        else if Text.Contains(cor, "black") 
            then "Preto"
        
        // CASE: Brancos e variações
        else if Text.Contains(cor, "white") 
             or cor = "ivory"
            then "Branco"
        
        // CASE: Cinzentos
        else if Text.Contains(cor, "gray") 
             or Text.Contains(cor, "grey") 
             or cor = "silver"
            then "Cinzento"
        
        // CASE: Vermelhos e variações (Mata o "RED", "red", "wine red", "winered", etc)
        else if Text.Contains(cor, "red") 
             or Text.Contains(cor, "wine") 
             or cor = "claret" 
             or cor = "burgundy"
            then "Vermelho"
        
        // CASE: Azuis e variações (Escuros e Claros juntos para o Dicionário)
        else if Text.Contains(cor, "blue") 
             or Text.Contains(cor, "navy")
            then "Azul"
        
        // CASE: Verdes e variações
        else if Text.Contains(cor, "green") 
             or Text.Contains(cor, "army") 
             or cor = "jasper"
            then "Verde"
        
        // CASE: Rosas
        else if Text.Contains(cor, "pink") 
             or Text.Contains(cor, "rose") 
             or cor = "rosegold"
            then "Rosa"
        
        // CASE: Roxos
        else if Text.Contains(cor, "purple") 
             or cor = "violet"
            then "Roxo"
        
        // CASE: Laranjas e Amarelos
        else if Text.Contains(cor, "orange") 
             or Text.Contains(cor, "yellow") 
             or cor = "gold"
            then "Laranja/Amarelo"
        
        // CASE: Tons de Terra / Neutros
        else if cor = "beige" 
             or cor = "khaki" 
             or cor = "lightkhaki" 
             or cor = "brown" 
             or cor = "coffee" 
             or cor = "camel" 
             or cor = "tan" 
             or cor = "apricot" 
             or cor = "nude"
            then "Tons Neutros"
        
        // DEFAULT: Se escapar algo
        else "Outros"
in
    CorPadronizada),
  #"Added custom 4" = Table.AddColumn(#"Added custom 2", "product_color_GroupedByImpactFix", each let
    // Remove espaços nas pontas e força tudo para minúsculo
    cor = Text.Trim(Text.Lower([product_color])),

    // O Switch Case completo mapeando todos os termos da sua lista
    CorPadronizada = 
        if cor = "" or cor = null 
            then "Não Informado" // Cobre o vazio (Count: 41)
        
        // CASE: Estampados, Listrados, Multicores e Combinações (&)
        else if Text.Contains(cor, "&") // Cobre: black & blue, black & green, black & stripe, black & white, black & yellow, blue & pink, brown & yellow, navyblue & white, pink & black, pink & blue, pink & grey, pink & white, red & blue, white & black, white & green, white & red
             or Text.Contains(cor, "stripe") // Cobre: whitestripe
             or Text.Contains(cor, "print") // Cobre: greysnakeskinprint, leopardprint
             or Text.Contains(cor, "multicolor") // Cobre: multicolor
             or Text.Contains(cor, "floral") // Cobre: floral, whitefloral
             or Text.Contains(cor, "camouflage") // Cobre: camouflage, orange & camouflage
             or Text.Contains(cor, "rainbow") // Cobre: rainbow
             or Text.Contains(cor, "star") // Cobre: star
             or Text.Contains(cor, "leopard") // Cobre: leopard
             or cor = "blackwhite" // Cobre: blackwhite
            then "Multicor/Estampado"
        
        // CASE: Pretos e variações
        else if Text.Contains(cor, "black") // Cobre: Black, black, coolblack, offblack
            then "Preto"
        
        // CASE: Brancos e variações
        else if Text.Contains(cor, "white") // Cobre: White, white, offwhite
             or cor = "ivory" // Cobre: ivory
            then "Branco"
        
        // CASE: Cinzentos e Prata
        else if Text.Contains(cor, "gray") // Cobre: gray, lightgray
             or Text.Contains(cor, "grey") // Cobre: grey, lightgrey
             or cor = "silver" // Cobre: silver
            then "Cinzento"
        
        // CASE: Vermelhos e variações
        else if Text.Contains(cor, "red") // Cobre: RED, red, lightred, orange-red, rose red, rosered, coralred, watermelonred, wine red
             or Text.Contains(cor, "wine") // Cobre: wine, winered
             or cor = "claret" // Cobre: claret
             or cor = "burgundy" // Cobre: burgundy
            then "Vermelho"
        
        // CASE: Azuis e variações
        else if Text.Contains(cor, "blue") // Cobre: Blue, blue, darkblue, denimblue, lakeblue, lightblue, navy blue, navyblue, skyblue
             or Text.Contains(cor, "navy") // Cobre: navy
             or cor = "prussianblue" // Cobre: prussianblue
            then "Azul"
        
        // CASE: Verdes e variações
        else if Text.Contains(cor, "green") // Cobre: Army green, army green, armygreen, green, darkgreen, light green, lightgreen, applegreen, mintgreen, fluorescentgreen
             or Text.Contains(cor, "army") // Cobre: army
             or cor = "jasper" // Cobre: jasper
            then "Verde"
        
        // CASE: Rosas
        else if Text.Contains(cor, "pink") // Cobre: Pink, pink, lightpink, dustypink
             or Text.Contains(cor, "rose") // Cobre: rose
             or cor = "rosegold" // Cobre: rosegold
            then "Rosa"
        
        // CASE: Roxos e Violetas
        else if Text.Contains(cor, "purple") // Cobre: purple, lightpurple
             or cor = "violet" // Cobre: violet
            then "Roxo"
        
        // CASE: Laranjas e Amarelos
        else if Text.Contains(cor, "orange") // Cobre: orange
             or Text.Contains(cor, "yellow") // Cobre: lightyellow
             or cor = "gold" // Cobre: gold
            then "Laranja/Amarelo"
        
        // CASE: Tons de Terra / Neutros
        else if cor = "beige" // Cobre: beige
             or cor = "khaki" // Cobre: khaki
             or cor = "lightkhaki" // Cobre: lightkhaki
             or cor = "brown" // Cobre: brown
             or cor = "coffee" // Cobre: coffee
             or cor = "camel" // Cobre: camel
             or cor = "tan" // Cobre: tan
             or cor = "apricot" // Cobre: apricot
             or cor = "nude" // Cobre: nude
            then "Tons Neutros"
        
        // DEFAULT: Caso apareça algo totalmente novo
        else "Outros"
in
    CorPadronizada),
  #"Added custom 5" = Table.AddColumn(#"Added custom 4", "urgency_textTierFix", each let
    // Remove espaços nas pontas para garantir o casamento exato do texto
    texto = Text.Trim([urgency_text])
in
    // Se for a frase de quantidade limitada
    if texto = "Quantité limitée !" 
        then "Scarcity"
    
    // Se for a frase de desconto em lote/gros
    else if texto = "Réduction sur les achats en gros" 
        then "Bulk_Purchase"
    
    // Se o campo estiver em branco ou nulo na base bruta
    else if texto = "" or texto = null 
        then "None"
    
    // Se aparecer qualquer outro texto diferente na base
    else "Others"),
  #"Replaced value 1" = Table.ReplaceValue(#"Added custom 5", "", "no_color_specified", Replacer.ReplaceValue, {"product_color"}),
  #"Replaced value 2" = Table.ReplaceValue(#"Replaced value 1", null, 0, Replacer.ReplaceValue, {"rating_one_count", "rating_two_count", "rating_three_count", "rating_four_count", "rating_five_count"}),
  #"Renamed columns 1" = Table.RenameColumns(#"Replaced value 2", {{"priceIntFix", "priceFix"}}),
  #"Added custom 6" = Table.AddColumn(#"Renamed columns 1", "badges_countFix", each [badges_count]),
  #"Changed column type 2" = Table.TransformColumnTypes(#"Added custom 6", {{"badges_countFix", type logical}}),
  #"Added custom 7" = Table.AddColumn(#"Changed column type 2", "badge_local_productFix", each [badge_local_product]),
  #"Changed column type 4" = Table.TransformColumnTypes(#"Added custom 7", {{"badge_local_productFix", type logical}}),
  #"Added custom 8" = Table.AddColumn(#"Changed column type 4", "badge_product_qualityFix", each [badge_product_quality]),
  #"Changed column type 5" = Table.TransformColumnTypes(#"Added custom 8", {{"badge_product_qualityFix", type logical}}),
  #"Added custom 9" = Table.AddColumn(#"Changed column type 5", "badge_fast_shippingFix", each [badge_fast_shipping]),
  #"Changed column type 6" = Table.TransformColumnTypes(#"Added custom 9", {{"badge_fast_shippingFix", type logical}}),
  #"Added custom 10" = Table.AddColumn(#"Changed column type 6", "uses_ad_boostsFix", each [uses_ad_boosts]),
  #"Changed column type 7" = Table.TransformColumnTypes(#"Added custom 10", {{"uses_ad_boostsFix", type logical}}),
  #"Added custom 11" = Table.AddColumn(#"Changed column type 7", "shipping_option_nameFix", each let
    texto = Text.Trim(Text.Lower([shipping_option_name]))
in
    if texto = "" or texto = null then "Não Informado"
    else if texto = "livraison express"   then "Express Delivery"
    else if texto = "ekspresowa wysyłka"  then "Express Shipping"
    else if texto = "livraison standard"   then "Standard Delivery"
    else if texto = "стандартная доставка" then "Standard Delivery"
    else if texto = "الشحن القياسي"        then "Standard Shipping"
    else if texto = "standard shipping"    then "Standard Shipping"
    else if texto = "spedizione standard"  then "Standard Shipping"
    else if texto = "envio padrão"         then "Standard Shipping"
    else if texto = "expediere standard"   then "Standard Shipping"
    else if texto = "standardversand"      then "Standard Shipping"
    else if texto = "envío normal"         then "Standard Shipping"
    else if texto = "การส่งสินค้ามาตรฐาน"    then "Standard Shipping"
    else if texto = "standart gönderi"     then "Standard Shipping"
    else if texto = "standardowa wysyłka"  then "Standard Shipping"
    else if texto = "ការដឹកជញ្ជូនតាមស្តង់ដារ"  then "Standard Shipping"
    else [shipping_option_name]),
  #"Added custom 12" = Table.AddColumn(#"Added custom 11", "shipping_option_priceFix", each let
    preco = if [shipping_option_price] = null then 0 else [shipping_option_price],

    EscalaPreco = 
        if preco = 0         then "1. Grátis"
        else if preco <= 5   then "2. Barato"
        else if preco <= 15  then "3. Médio"
        else                      "4. Caro"
in
    EscalaPreco),
  #"Added custom 13" = Table.AddColumn(#"Added custom 12", "shipping_is_expressFix", each let
    // Garante o tratamento caso o valor venha como número, texto ou nulo
    isExpress = [shipping_is_express],

    Resultado = 
        if isExpress = 1 or isExpress = "1" or isExpress = true 
            then "1. Express"
        else 
            "2. Normal"
in
    Resultado),
  #"Added custom 14" = Table.AddColumn(#"Added custom 13", "product_variation_size_idFix", each let
    // Remove espaços, força minúsculo e limpa pontos finais comuns na sua lista (ex: "m." vira "m")
    tam = Text.Trim(Text.Lower(Text.Replace([product_variation_size_id], ".", ""))),

    // O Switch Case para categorizar e ordenar o espectro de tamanhos
    TamanhoPadronizado = 
        if tam = "" or tam = null or tam = "choose a size" 
            then "00. Não Informado" // Cobre os vazios e "choose a size"
        
        // ----------------------------------------------------
        // CASOS ESPECÍFICOS / INFANTIL / ACESSÓRIOS
        // ----------------------------------------------------
        else if Text.Contains(tam, "child") or Text.Contains(tam, "baby") or Text.Contains(tam, "years") or tam = "daughter 24m" 
            then "01. Infantil" // Cobre: s/m(child), baby float boat, 4-5 years, daughter 24m
            
        else if tam = "one size" 
            then "02. Tamanho Único" // Cobre: One Size
        
        // ----------------------------------------------------
        // GRADE PADRÃO DE ROUPAS (Do PP ao Plus Size)
        // ----------------------------------------------------
        else if tam = "xxxs" 
            then "03. PP (XXXS)" // Cobre: XXXS
            
        else if tam = "xxs" or Text.Contains(tam, "-xxs") or Text.Contains(tam, " xxs") 
            then "04. PP (XXS)" // Cobre: XXS, Size XXS, SIZE XXS, SIZE-XXS, Size -XXS, Size-XXS
            
        else if tam = "xs" or Text.Contains(tam, "-xs") or Text.Contains(tam, " xs") 
            then "05. P (XS)" // Cobre: XS, Size-XS, XS, SIZE XS
            
        else if tam = "s" or Text.Contains(tam, "-s") or Text.Contains(tam, " s") or Text.Contains(tam, "s ") or Text.Contains(tam, "s(") or tam = "suit-s" or tam = "pants-s" or tam = "us-s" or tam = "25-s" or tam = "size/s"
            then "06. P (S)" // Cobre: S, s, Suit-S, Size S, Size S., S.., S(bust 88cm), S (waist58-62cm), S(Pink & Black), US-S, Size-S, 25-S, Size/S, S Pink, pants-S, Size--S, SIZE S
            
        else if tam = "m" or Text.Contains(tam, " m") 
            then "07. M" // Cobre: M, M, Size M
            
        else if tam = "l" or Text.Contains(tam, " l") or tam = "sizel" or tam = "32/l" 
            then "08. G (L)" // Cobre: L, 32/L, SizeL, Size-L
            
        else if tam = "xl" or tam = "x  l" or tam = "1 pc - xl" 
            then "09. GG (XL)" // Cobre: XL, X  L, 1 PC - XL
            
        else if tam = "xxl" or tam = "2xl" 
            then "10. XG (2XL)" // Cobre: XXL, 2XL
            
        else if tam = "xxxl" or tam = "3xl" or tam = "04-3xl" 
            then "11. Plus Size (3XL)" // Cobre: 3XL, XXXL, 04-3xl
            
        else if tam = "xxxxl" or tam = "4xl" or tam = "size4xl" or tam = "size-4xl" 
            then "12. Plus Size (4XL)" // Cobre: SIZE-4XL, 4XL, XXXXL, Size4XL
            
        else if tam = "xxxxxl" or tam = "5xl" or tam = "size-5xl" 
            then "13. Plus Size (5XL)" // Cobre: XXXXXL, 5XL, Size-5XL
            
        else if tam = "6xl" 
            then "14. Plus Size (6XL)" // Cobre: 6XL

        // ----------------------------------------------------
        // CALÇADOS / NUMERAÇÕES (EU, US e Numéricos de Calça/Sapato)
        // ----------------------------------------------------
        else if Text.Contains(tam, "eu") or Text.Contains(tam, "us") or Text.Contains(tam, "women size") 
             or tam = "25" or tam = "26(waist 72cm 28inch)" or tam = "29" or tam = "33" or tam = "34" or tam = "35" or tam = "36" or tam = "1" or tam = "2" or tam = "4" or tam = "5" or tam = "17" or tam = "60"
            then "15. Calçados / Numerações" // Cobre: EU 35, Women Size 36, US 6.5 (EU 37), 26(Waist 72cm 28inch), 29, 35, 34, 25, US5.5-EU35, Women Size 37, EU39(US8), 36, 1, 2, 4, 5, 17, 60
            
        // ----------------------------------------------------
        // OUTROS PRODUTOS (Não são roupas: Centímetros, Quantidades, Objetos)
        // ----------------------------------------------------
        else if Text.Contains(tam, "cm") or Text.Contains(tam, "inch") or Text.Contains(tam, "pc") or Text.Contains(tam, "pair") or Text.Contains(tam, "coat") or Text.Contains(tam, "plug") or Text.Contains(tam, "ml") or tam = "white" or tam = "round" or tam = "3 layered anklet" or tam = "floating chair for kid" or tam = "first  generation" or tam = "b" or tam = "h01"
            then "16. Outros Itens (Dimensões/Kits/Objetos)" // Cobre: 1m by 3m, 1pc, 100 cm, 2pcs, 30 cm, 100 x 100cm(39.3 x 39.3inch), 100pcs, Base & Top & Matte Top Coat, 20pcs, White, Round, Pack of 1, 1 pc., S Diameter 30cm, AU plug Low quality, 5PAIRS, 10 ml, 3 layered anklet, first generation, Floating Chair for Kid, 20PCS-10PAIRS, B, H01, 40 cm, Base Coat
            
        // DEFAULT: Se aparecer algo totalmente novo no futuro
        else "17. Outros"
in
    TamanhoPadronizado),
  #"Added custom 15" = Table.AddColumn(#"Added custom 14", "tagsTypesFix", each let
    // Dicionário estrito para o Tipo/Peça de Roupa
    DicionarioTipo = {
        [Tag = "backless top", Cat = "Top"],
        [Tag = "beach dress", Cat = "Vestido"],
        [Tag = "beach wear", Cat = "Moda Praia"],
        [Tag = "beachblouse", Cat = "Blusa"],
        [Tag = "beachvest", Cat = "Colete"],
        [Tag = "bikini", Cat = "Biquíni"],
        [Tag = "bikinibeachcoverup", Cat = "Saída de Praia"],
        [Tag = "blouse", Cat = "Blusa"],
        [Tag = "bodycon dress", Cat = "Vestido"],
        [Tag = "boho dress", Cat = "Vestido"],
        [Tag = "bottom", Cat = "Parte de Baixo"],
        [Tag = "bras", Cat = "Sutiã"],
        [Tag = "budsilkblouse", Cat = "Blusa"],
        [Tag = "buttontop", Cat = "Top"],
        [Tag = "cami", Cat = "Camisete"],
        [Tag = "camisole", Cat = "Camisete"],
        [Tag = "camouflagevest", Cat = "Colete"],
        [Tag = "cardigan", Cat = "Cardigan"],
        [Tag = "casual dress", Cat = "Vestido"],
        [Tag = "casual dresses", Cat = "Vestido"],
        [Tag = "casual pants", Cat = "Calça"],
        [Tag = "casual t-shirt", Cat = "Camiseta"],
        [Tag = "casual tops", Cat = "Top"],
        [Tag = "casualsleepwear", Cat = "Roupa de Dormir"],
        [Tag = "coat", Cat = "Casaco"],
        [Tag = "cool t-shirts", Cat = "Camiseta"],
        [Tag = "cool tees", Cat = "Camiseta"],
        [Tag = "cotton dress", Cat = "Vestido"],
        [Tag = "cotton shirt", Cat = "Camisa"],
        [Tag = "cotton t shirt", Cat = "Camiseta"],
        [Tag = "cotton vest", Cat = "Colete"],
        [Tag = "cuteshirt", Cat = "Camisa"],
        [Tag = "denimjeansdres", Cat = "Vestido"],
        [Tag = "dress", Cat = "Vestido"],
        [Tag = "dresses", Cat = "Vestido"],
        [Tag = "fashion dress", Cat = "Vestido"],
        [Tag = "fashiontee", Cat = "Camiseta"],
        [Tag = "flamingotshirt", Cat = "Camiseta"],
        [Tag = "girl bra", Cat = "Sutiã"],
        [Tag = "jeans", Cat = "Jeans"],
        [Tag = "jumpsuit", Cat = "Macacão"],
        [Tag = "kimono", Cat = "Quimono"],
        [Tag = "lace shirts", Cat = "Camisa"],
        [Tag = "lace t shirt", Cat = "Camiseta"],
        [Tag = "lace top", Cat = "Top"],
        [Tag = "lace vest", Cat = "Colete"],
        [Tag = "long dress", Cat = "Vestido"],
        [Tag = "long sleeve t shirt", Cat = "Camiseta"],
        [Tag = "longcardigan", Cat = "Cardigan"],
        [Tag = "loose dress", Cat = "Vestido"],
        [Tag = "loose shirt", Cat = "Camisa"],
        [Tag = "loose t-shirt", Cat = "Camiseta"],
        [Tag = "looseblouse", Cat = "Blusa"],
        [Tag = "loungewearset", Cat = "Roupa de Ficar em Casa"],
        [Tag = "maxi dress", Cat = "Vestido"],
        [Tag = "mididre", Cat = "Vestido"],
        [Tag = "midsleevebeachblouse", Cat = "Blusa"],
        [Tag = "mini dress", Cat = "Vestido"],
        [Tag = "minishirtdres", Cat = "Vestido"],
        [Tag = "outweartop", Cat = "Top"],
        [Tag = "overalls", Cat = "Jardineira/Macacão"],
        [Tag = "pajamas", Cat = "Pijama"],
        [Tag = "pants", Cat = "Calça"],
        [Tag = "party dress", Cat = "Vestido"],
        [Tag = "plus size dress", Cat = "Vestido"],
        [Tag = "print dress", Cat = "Vestido"],
        [Tag = "printedpajamasset", Cat = "Pijama"],
        [Tag = "pullovers", Cat = "Pulôver"],
        [Tag = "robes", Cat = "Robe"],
        [Tag = "scallopedtrimtop", Cat = "Top"],
        [Tag = "sexy bikini", Cat = "Biquíni"],
        [Tag = "sexy crop top", Cat = "Cropped"],
        [Tag = "sexy dress", Cat = "Vestido"],
        [Tag = "sexyblouse", Cat = "Blusa"],
        [Tag = "sexyvest", Cat = "Colete"],
        [Tag = "shirt", Cat = "Camisa"],
        [Tag = "short pants", Cat = "Shorts"],
        [Tag = "short sleeve blouses", Cat = "Blusa"],
        [Tag = "short sleeve t-shirt", Cat = "Camiseta"],
        [Tag = "short sleeves", Cat = "Camiseta"],
        [Tag = "shorts", Cat = "Shorts"],
        [Tag = "sleepwear", Cat = "Roupa de Dormir"],
        [Tag = "sleeveless dress", Cat = "Vestido"],
        [Tag = "sleeveless shirt", Cat = "Camisa"],
        [Tag = "sleeveless tops", Cat = "Top"],
        [Tag = "sleevelesstshirt", Cat = "Camiseta"],
        [Tag = "slim dress", Cat = "Vestido"],
        [Tag = "slim fit shirt", Cat = "Camisa"],
        [Tag = "slim t-shirt", Cat = "Camiseta"],
        [Tag = "slimfitdre", Cat = "Vestido"],
        [Tag = "solidcolorshirt", Cat = "Camisa"],
        [Tag = "straplesstanktop", Cat = "Top"],
        [Tag = "suits", Cat = "Conjunto/Terno"],
        [Tag = "summer dress", Cat = "Vestido"],
        [Tag = "summer dresses", Cat = "Vestido"],
        [Tag = "summer shirt", Cat = "Camisa"],
        [Tag = "summer t-shirts", Cat = "Camiseta"],
        [Tag = "summer tops", Cat = "Top"],
        [Tag = "summercardigan", Cat = "Cardigan"],
        [Tag = "summerswimsuit", Cat = "Moda Praia"],
        [Tag = "summervest", Cat = "Colete"],
        [Tag = "summerwomentop", Cat = "Top"],
        [Tag = "swimsuit", Cat = "Maiô/Biquíni"],
        [Tag = "swimwear", Cat = "Moda Praia"],
        [Tag = "t shirts", Cat = "Camiseta"],
        [Tag = "tank top", Cat = "Regata"],
        [Tag = "tank top women", Cat = "Regata"],
        [Tag = "topandblouse", Cat = "Blusa"],
        [Tag = "topbra", Cat = "Top"],
        [Tag = "tops", Cat = "Top"],
        [Tag = "topsampblouse", Cat = "Top"],
        [Tag = "topsamptee", Cat = "Top"],
        [Tag = "topsamptshirt", Cat = "Top"],
        [Tag = "tshirtandshortsset", Cat = "Conjunto"],
        [Tag = "tshirtforwomen", Cat = "Camiseta"],
        [Tag = "tunic", Cat = "Túnica"],
        [Tag = "tunic dress", Cat = "Vestido"],
        [Tag = "tunic top", Cat = "Túnica"],
        [Tag = "uniquedres", Cat = "Vestido"],
        [Tag = "women bathing suit", Cat = "Moda Praia"],
        [Tag = "women beachwear", Cat = "Moda Praia"],
        [Tag = "women blouse", Cat = "Blusa"],
        [Tag = "women dress", Cat = "Vestido"],
        [Tag = "women fashion dress", Cat = "Vestido"],
        [Tag = "women tank top", Cat = "Regata"],
        [Tag = "women top", Cat = "Top"],
        [Tag = "women vest", Cat = "Colete"],
        [Tag = "womenbeachblouse", Cat = "Blusa"],
        [Tag = "womencasualshort", Cat = "Shorts"],
        [Tag = "womennightwear", Cat = "Roupa de Dormir"],
        [Tag = "womenpajamasset", Cat = "Pijama"],
        [Tag = "womens blouse", Cat = "Blusa"],
        [Tag = "womens dresses", Cat = "Vestido"],
        [Tag = "womens shirt", Cat = "Camisa"],
        [Tag = "womens vest", Cat = "Colete"],
        [Tag = "womenshortsleevedre", Cat = "Vestido"],
        [Tag = "womensleepwearset", Cat = "Pijama"],
        [Tag = "womensummerswimwear", Cat = "Moda Praia"],
        [Tag = "womenunderwearsuit", Cat = "Lingerie"],
        [Tag = "yoga top", Cat = "Top"]
    },

    // Processamento das Tags
    texto_tag = Text.Trim(Text.Lower(if [tags] = null then "" else [tags])),
    Matches = List.Select(DicionarioTipo, each Text.Contains(texto_tag, _[Tag])),
    Resultados = List.Distinct(List.Transform(Matches, each _[Cat])),
    ResultadoFinal = Text.Combine(Resultados, ", ")
in
    if ResultadoFinal = "" then "Não Especificado" else ResultadoFinal),
  #"Added custom 16" = Table.AddColumn(#"Added custom 15", "tagsMaterialFix", each let
    // Dicionário completo associando cada termo de moda aos materiais mais prováveis
    DicionarioMaterial = {
        [Tag = "backless", Cat = "Poliéster/Elastano"],
        [Tag = "backless top", Cat = "Poliéster/Elastano"],
        [Tag = "bandages", Cat = "Poliéster/Elastano"],
        [Tag = "bat", Cat = "Algodão/Poliéster"],
        [Tag = "beach", Cat = "Algodão/Poliéster"],
        [Tag = "beach dress", Cat = "Algodão/Viscose"],
        [Tag = "beach wear", Cat = "Nilon/Elastano"],
        [Tag = "beachblouse", Cat = "Poliéster/Viscose"],
        [Tag = "beachvest", Cat = "Algodão/Poliéster"],
        [Tag = "beading", Cat = "Metal/Plástico"],
        [Tag = "bikini", Cat = "Nilon/Elastano"],
        [Tag = "bikinibeachcoverup", Cat = "Poliéster/Viscose"],
        [Tag = "black", Cat = "Algodão/Poliéster"],
        [Tag = "blackwhitepink", Cat = "Algodão/Poliéster"],
        [Tag = "blouse", Cat = "Poliéster/Viscose"],
        [Tag = "bodycon dress", Cat = "Poliéster/Elastano"],
        [Tag = "boho dress", Cat = "Viscose/Poliéster"],
        [Tag = "bottom", Cat = "Algodão/Poliéster"],
        [Tag = "bras", Cat = "Nilon/Elastano"],
        [Tag = "budsilkblouse", Cat = "Renda/Poliéster"],
        [Tag = "butterflyprint", Cat = "Poliéster"],
        [Tag = "button", Cat = "Plástico/Metal"],
        [Tag = "buttontop", Cat = "Algodão/Poliéster"],
        [Tag = "cami", Cat = "Algodão/Poliéster"],
        [Tag = "camisole", Cat = "Poliéster/Viscose"],
        [Tag = "camouflage", Cat = "Algodão/Poliéster"],
        [Tag = "camouflagevest", Cat = "Algodão/Poliéster"],
        [Tag = "cardigan", Cat = "Algodão/Poliéster"],
        [Tag = "casual", Cat = "Algodão/Poliéster"],
        [Tag = "casual dress", Cat = "Algodão/Viscose"],
        [Tag = "casual dresses", Cat = "Algodão/Viscose"],
        [Tag = "casual pants", Cat = "Algodão/Poliéster"],
        [Tag = "casual t-shirt", Cat = "Algodão"],
        [Tag = "casual tops", Cat = "Algodão/Poliéster"],
        [Tag = "casualsleepwear", Cat = "Algodão/Viscose"],
        [Tag = "causal", Cat = "Algodão/Poliéster"],
        [Tag = "chiffon", Cat = "Poliéster"],
        [Tag = "clothes for women", Cat = "Algodão/Poliéster"],
        [Tag = "clothing", Cat = "Algodão/Poliéster"],
        [Tag = "coat", Cat = "Poliéster/Algodão"],
        [Tag = "cool t-shirts", Cat = "Algodão"],
        [Tag = "cool tees", Cat = "Algodão"],
        [Tag = "cotton", Cat = "Algodão"],
        [Tag = "cotton dress", Cat = "Algodão"],
        [Tag = "cotton shirt", Cat = "Algodão"],
        [Tag = "cotton t shirt", Cat = "Algodão"],
        [Tag = "cotton vest", Cat = "Algodão"],
        [Tag = "cover", Cat = "Poliéster"],
        [Tag = "crochet", Cat = "5.Misto/Crochê"],
        [Tag = "cross", Cat = "Algodão/Poliéster"],
        [Tag = "cute", Cat = "Algodão/Poliéster"],
        [Tag = "cuteshirt", Cat = "Algodão"],
        [Tag = "deep v-neck", Cat = "Poliéster/Elastano"],
        [Tag = "deepneck", Cat = "Poliéster/Elastano"],
        [Tag = "denim", Cat = "Denim"],
        [Tag = "denimjeansdres", Cat = "Denim"],
        [Tag = "design", Cat = "Algodão/Poliéster"],
        [Tag = "doublelayer", Cat = "Poliéster"],
        [Tag = "drawstring", Cat = "Algodão/Poliéster"],
        [Tag = "dress", Cat = "Algodão/Poliéster"],
        [Tag = "dresses", Cat = "Algodão/Poliéster"],
        [Tag = "elastic", Cat = "Elastano"],
        [Tag = "fashion", Cat = "Algodão/Poliéster"],
        [Tag = "fashion dress", Cat = "Poliéster/Viscose"],
        [Tag = "fashion women", Cat = "Algodão/Poliéster"],
        [Tag = "fashiontee", Cat = "Algodão"],
        [Tag = "flamingo", Cat = "Poliéster"],
        [Tag = "flamingotshirt", Cat = "Algodão/Poliéster"],
        [Tag = "flare", Cat = "Algodão/Poliéster"],
        [Tag = "floral", Cat = "Poliéster/Viscose"],
        [Tag = "floral print", Cat = "Poliéster/Viscose"],
        [Tag = "girl bra", Cat = "Nilon/Elastano"],
        [Tag = "graffiti", Cat = "Algodão/Poliéster"],
        [Tag = "green", Cat = "Algodão/Poliéster"],
        [Tag = "holiday", Cat = "Algodão/Viscose"],
        [Tag = "jeans", Cat = "Denim"],
        [Tag = "jumpsuit", Cat = "Algodão/Poliéster"],
        [Tag = "kimono", Cat = "Viscose/Poliéster"],
        [Tag = "knitted", Cat = "Algodão/Poliéster"],
        [Tag = "lace", Cat = "Renda"],
        [Tag = "lace shirts", Cat = "Renda/Poliéster"],
        [Tag = "lace t shirt", Cat = "Renda/Algodão"],
        [Tag = "lace top", Cat = "Renda/Poliéster"],
        [Tag = "lace up", Cat = "Algodão/Poliéster"],
        [Tag = "lace vest", Cat = "Renda/Poliéster"],
        [Tag = "ladies", Cat = "Algodão/Poliéster"],
        [Tag = "ladies fashion", Cat = "Algodão/Poliéster"],
        [Tag = "leaf", Cat = "Poliéster"],
        [Tag = "lines", Cat = "Algodão/Poliéster"],
        [Tag = "long dress", Cat = "Viscose/Poliéster"],
        [Tag = "long sleeve", Cat = "Algodão/Poliéster"],
        [Tag = "long sleeve t shirt", Cat = "Algodão"],
        [Tag = "longcardigan", Cat = "Algodão/Poliéster"],
        [Tag = "loose", Cat = "Algodão/Poliéster"],
        [Tag = "loose dress", Cat = "Viscose/Algodão"],
        [Tag = "loose shirt", Cat = "Algodão/Viscose"],
        [Tag = "loose t-shirt", Cat = "Algodão"],
        [Tag = "looseblouse", Cat = "Viscose/Poliéster"],
        [Tag = "loungewearset", Cat = "Algodão/Viscose"],
        [Tag = "love", Cat = "Algodão/Poliéster"],
        [Tag = "low cut", Cat = "Poliéster/Elastano"],
        [Tag = "maxi dress", Cat = "Viscose/Poliéster"],
        [Tag = "mididre", Cat = "Algodão/Poliéster"],
        [Tag = "midsleevebeachblouse", Cat = "Poliéster/Viscose"],
        [Tag = "military", Cat = "Algodão"],
        [Tag = "mini", Cat = "Algodão/Poliéster"],
        [Tag = "mini dress", Cat = "Poliéster/Elastano"],
        [Tag = "minishirtdres", Cat = "Algodão/Poliéster"],
        [Tag = "necks", Cat = "Algodão/Poliéster"],
        [Tag = "off shoulder", Cat = "Poliéster/Elastano"],
        [Tag = "openfront", Cat = "Algodão/Poliéster"],
        [Tag = "outweartop", Cat = "Algodão/Poliéster"],
        [Tag = "overalls", Cat = "Denim"],
        [Tag = "padded", Cat = "Poliéster/Borracha"],
        [Tag = "pajamas", Cat = "Algodão/Viscose"],
        [Tag = "pants", Cat = "Algodão/Poliéster"],
        [Tag = "party", Cat = "Poliéster"],
        [Tag = "party dress", Cat = "Poliéster/Elastano"],
        [Tag = "patchwork", Cat = "Algodão/Poliéster"],
        [Tag = "pink", Cat = "Algodão/Poliéster"],
        [Tag = "plus size", Cat = "Algodão/Poliéster"],
        [Tag = "plus size dress", Cat = "Algodão/Viscose"],
        [Tag = "polka dot", Cat = "Poliéster"],
        [Tag = "polkas", Cat = "Poliéster"],
        [Tag = "print", Cat = "Poliéster"],
        [Tag = "print dress", Cat = "Poliéster/Viscose"],
        [Tag = "printed", Cat = "Poliéster"],
        [Tag = "printedletterstop", Cat = "Algodão/Poliéster"],
        [Tag = "printedpajamasset", Cat = "Algodão/Viscose"],
        [Tag = "pullovers", Cat = "Algodão/Poliéster"],
        [Tag = "pure color", Cat = "Algodão/Poliéster"],
        [Tag = "robes", Cat = "Poliéster/Algodão"],
        [Tag = "round neck", Cat = "Algodão/Poliéster"],
        [Tag = "ruffled", Cat = "Poliéster"],
        [Tag = "scallopedtrimtop", Cat = "Poliéster/Renda"],
        [Tag = "sexy", Cat = "Poliéster/Elastano"],
        [Tag = "sexy bikini", Cat = "Nilon/Elastano"],
        [Tag = "sexy crop top", Cat = "Poliéster/Elastano"],
        [Tag = "sexy dress", Cat = "Poliéster/Elastano"],
        [Tag = "sexy women", Cat = "Poliéster/Elastano"],
        [Tag = "sexyblouse", Cat = "Poliéster/Viscose"],
        [Tag = "sexyvest", Cat = "Poliéster/Elastano"],
        [Tag = "shirt", Cat = "Algodão/Poliéster"],
        [Tag = "short pants", Cat = "Algodão/Poliéster"],
        [Tag = "short sleeve blouses", Cat = "Poliéster/Viscose"],
        [Tag = "short sleeve t-shirt", Cat = "Algodão"],
        [Tag = "short sleeved", Cat = "Algodão/Poliéster"],
        [Tag = "short sleeves", Cat = "Algodão/Poliéster"],
        [Tag = "shorts", Cat = "Algodão/Poliéster"],
        [Tag = "sleepwear", Cat = "Algodão/Viscose"],
        [Tag = "sleeve", Cat = "Algodão/Poliéster"],
        [Tag = "sleeveless", Cat = "Algodão/Poliéster"],
        [Tag = "sleeveless dress", Cat = "Algodão/Viscose"],
        [Tag = "sleeveless shirt", Cat = "Algodão/Poliéster"],
        [Tag = "sleeveless tops", Cat = "Algodão/Poliéster"],
        [Tag = "sleevelesstshirt", Cat = "Algodão"],
        [Tag = "slim", Cat = "Algodão/Elastano"],
        [Tag = "slim dress", Cat = "Poliéster/Elastano"],
        [Tag = "slim fit", Cat = "Algodão/Elastano"],
        [Tag = "slim fit shirt", Cat = "Algodão/Poliéster"],
        [Tag = "slim t-shirt", Cat = "Algodão/Elastano"],
        [Tag = "slimfitdre", Cat = "Poliéster/Elastano"],
        [Tag = "soildcolor", Cat = "Algodão/Poliéster"],
        [Tag = "solid color", Cat = "Algodão/Poliéster"],
        [Tag = "solidcolorshirt", Cat = "Algodão/Poliéster"],
        [Tag = "spaghetti", Cat = "Poliéster/Elastano"],
        [Tag = "spaghetti strap", Cat = "Poliéster/Elastano"],
        [Tag = "sportwear", Cat = "Nilon/Elastano"],
        [Tag = "spring", Cat = "Algodão/Poliéster"],
        [Tag = "strapless", Cat = "Poliéster/Elastano"],
        [Tag = "straplesstanktop", Cat = "Poliéster/Elastano"],
        [Tag = "strappy", Cat = "Poliéster/Elastano"],
        [Tag = "suits", Cat = "Poliéster/Algodão"],
        [Tag = "summer", Cat = "Algodão/Poliéster"],
        [Tag = "summer dress", Cat = "Algodão/Viscose"],
        [Tag = "summer dresses", Cat = "Algodão/Viscose"],
        [Tag = "summer fashion", Cat = "Algodão/Poliéster"],
        [Tag = "summer shirt", Cat = "Algodão/Poliéster"],
        [Tag = "summer t-shirts", Cat = "Algodão"],
        [Tag = "summer tops", Cat = "Algodão/Poliéster"],
        [Tag = "summercardigan", Cat = "Algodão/Poliéster"],
        [Tag = "summerswimsuit", Cat = "Nilon/Elastano"],
        [Tag = "summervest", Cat = "Algodão/Poliéster"],
        [Tag = "summerwomentop", Cat = "Algodão/Poliéster"],
        [Tag = "sweets", Cat = "Algodão/Poliéster"],
        [Tag = "swimming", Cat = "Nilon/Elastano"],
        [Tag = "swimsuit", Cat = "Nilon/Elastano"],
        [Tag = "swimwear", Cat = "Nilon/Elastano"],
        [Tag = "t", Cat = "Algodão"],
        [Tag = "t shirts", Cat = "Algodão"],
        [Tag = "tank", Cat = "Algodão/Poliéster"],
        [Tag = "tank top", Cat = "Algodão/Poliéster"],
        [Tag = "tank top women", Cat = "Algodão/Poliéster"],
        [Tag = "tee", Cat = "Algodão"],
        [Tag = "topandblouse", Cat = "Poliéster/Viscose"],
        [Tag = "topbra", Cat = "Nilon/Elastano"],
        [Tag = "tops", Cat = "Algodão/Poliéster"],
        [Tag = "topsampblouse", Cat = "Poliéster/Viscose"],
        [Tag = "topsamptee", Cat = "Algodão"],
        [Tag = "topsamptshirt", Cat = "Algodão"],
        [Tag = "tshirtandshortsset", Cat = "Algodão/Poliéster"],
        [Tag = "tshirtforwomen", Cat = "Algodão"],
        [Tag = "tunic", Cat = "Algodão/Viscose"],
        [Tag = "tunic dress", Cat = "Algodão/Viscose"],
        [Tag = "tunic top", Cat = "Algodão/Viscose"],
        [Tag = "uniquedres", Cat = "Algodão/Poliéster"],
        [Tag = "v-neck", Cat = "Algodão/Poliéster"],
        [Tag = "vest", Cat = "Algodão/Poliéster"],
        [Tag = "vintage", Cat = "Algodão/Denim"],
        [Tag = "white", Cat = "Algodão/Poliéster"],
        [Tag = "women", Cat = "Algodão/Poliéster"],
        [Tag = "women bathing suit", Cat = "Nilon/Elastano"],
        [Tag = "women beachwear", Cat = "Nilon/Elastano"],
        [Tag = "women blouse", Cat = "Poliéster/Viscose"],
        [Tag = "women dress", Cat = "Algodão/Poliéster"],
        [Tag = "women fashion dress", Cat = "Poliéster/Viscose"],
        [Tag = "women s clothing", Cat = "Algodão/Poliéster"],
        [Tag = "women tank top", Cat = "Algodão/Poliéster"],
        [Tag = "women top", Cat = "Algodão/Poliéster"],
        [Tag = "women vest", Cat = "Algodão/Poliéster"],
        [Tag = "women's fashion", Cat = "Algodão/Poliéster"],
        [Tag = "womenbeachblouse", Cat = "Poliéster/Viscose"],
        [Tag = "womencasualshort", Cat = "Algodão/Poliéster"],
        [Tag = "womennightwear", Cat = "Algodão/Viscose"],
        [Tag = "womenpajamasset", Cat = "Algodão/Viscose"],
        [Tag = "womens blouse", Cat = "Poliéster/Viscose"],
        [Tag = "womens dresses", Cat = "Algodão/Poliéster"],
        [Tag = "womens shirt", Cat = "Algodão/Poliéster"],
        [Tag = "womens vest", Cat = "Algodão/Poliéster"],
        [Tag = "womenshortsleevedre", Cat = "Algodão/Poliéster"],
        [Tag = "womensleepwearset", Cat = "Algodão/Viscose"],
        [Tag = "womensummerswimwear", Cat = "Nilon/Elastano"],
        [Tag = "womenunderwearsuit", Cat = "Nilon/Elastano"],
        [Tag = "yoga", Cat = "Nilon/Elastano"],
        [Tag = "yoga top", Cat = "Nilon/Elastano"],
        [Tag = "zippers", Cat = "Metal/Plástico" ]
    },

    // Processamento
    texto_tag = Text.Trim(Text.Lower(if [tags] = null then "" else [tags])),
    Matches = List.Select(DicionarioMaterial, each Text.Contains(texto_tag, _[Tag])),
    
    // Filtra apenas os que têm valor mapeado
    MateriaisValidos = List.Select(Matches, each _[Cat] <> ""),
    
    Resultados = List.Distinct(List.Transform(MateriaisValidos, each _[Cat])),
    ResultadoFinal = Text.Combine(Resultados, ", ")
in
    if ResultadoFinal = "" then "Não Especificado" else ResultadoFinal),
  #"Removed columns" = Table.RemoveColumns(#"Added custom 16", {"priceFix"}),
  #"Removed duplicates" = Table.Distinct(#"Removed columns", {"product_id"}),
  #"Reordered columns" = Table.ReorderColumns(#"Removed duplicates", {"product_id", "title", "title_orig", "price", "retail_price", "currency_buyer", "units_sold", "uses_ad_boosts", "rating", "rating_count", "rating_five_count", "rating_four_count", "rating_three_count", "rating_two_count", "rating_one_count", "badges_count", "badge_local_product", "badge_product_quality", "badge_fast_shipping", "tags", "product_color", "product_variation_size_id", "product_variation_inventory", "shipping_option_name", "shipping_option_price", "shipping_is_express", "countries_shipped_to", "inventory_total", "has_urgency_banner", "urgency_text", "origin_country", "merchant_title", "merchant_name", "merchant_info_subtitle", "merchant_rating_count", "merchant_rating", "merchant_id", "merchant_has_profile_picture", "merchant_profile_picture", "product_url", "product_picture", "theme", "crawl_month", "Index_novo", "units_sold_EscalaFix", "rating_Base1000Fix", "product_color_GroupedColour", "product_color_GroupedByImpactFix", "urgency_textTierFix", "badges_countFix", "badge_local_productFix", "badge_product_qualityFix", "badge_fast_shippingFix", "uses_ad_boostsFix", "shipping_option_nameFix", "shipping_option_priceFix", "shipping_is_expressFix", "product_variation_size_idFix", "tagsTypesFix", "tagsMaterialFix"}),
  #"Added custom 17" = Table.AddColumn(#"Reordered columns", "has_urgency_bannerFix", each if [has_urgency_banner] = 1 then true else if [has_urgency_banner] = 0 then false else false),
  #"Changed column type 3" = Table.TransformColumnTypes(#"Added custom 17", {{"has_urgency_bannerFix", type logical}}),
  #"Removed columns 1" = Table.RemoveColumns(#"Changed column type 3", {"product_variation_size_id", "title", "currency_buyer", "has_urgency_banner", "urgency_text"}),
  #"Duplicated column" = Table.DuplicateColumn(#"Removed columns 1", "origin_country", "origin_country - Copy"),
  #"Renamed columns 2" = Table.RenameColumns(#"Duplicated column", {{"origin_country - Copy", "origin_countryFix"}}),
  #"Replaced value" = Table.ReplaceValue(#"Renamed columns 2", "", "nao_informado", Replacer.ReplaceValue, {"origin_countryFix"}),
  #"Removed columns 2" = Table.RemoveColumns(#"Replaced value", {"origin_country", "merchant_info_subtitle", "merchant_title", "merchant_name", "shipping_option_name", "badges_count", "badge_local_product", "badge_product_quality", "badge_fast_shipping", "shipping_option_price", "shipping_is_express", "merchant_id", "merchant_has_profile_picture", "merchant_profile_picture", "product_url", "product_picture", "theme", "crawl_month"}),
  #"Reordered columns 1" = Table.ReorderColumns(#"Removed columns 2", {"Index_novo", "product_id", "title_orig", "price", "retail_price", "units_sold", "uses_ad_boosts", "rating", "rating_count", "rating_five_count", "rating_four_count", "rating_three_count", "rating_two_count", "rating_one_count", "tags", "product_color", "product_variation_inventory", "countries_shipped_to", "inventory_total", "merchant_rating_count", "merchant_rating", "units_sold_EscalaFix", "rating_Base1000Fix", "product_color_GroupedColour", "product_color_GroupedByImpactFix", "urgency_textTierFix", "badges_countFix", "badge_local_productFix", "badge_product_qualityFix", "badge_fast_shippingFix", "uses_ad_boostsFix", "shipping_option_nameFix", "shipping_option_priceFix", "shipping_is_expressFix", "product_variation_size_idFix", "tagsTypesFix", "tagsMaterialFix", "has_urgency_bannerFix", "origin_countryFix"}),
  #"Added custom 18" = Table.AddColumn(#"Reordered columns 1", "retail_price_priceFix", each if [retail_price] > [price] then "retail_maior" 
else if [price] > [retail_price] then "price_maior" 
else "iguais")
in
  #"Added custom 18"