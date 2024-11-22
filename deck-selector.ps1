#The purpose of this is to grab random Star Wars Unlimited decklists, and copy the JSON output to the users clipboard for easy pasting to TTS


#Grabbing a random leader from the leader dropdown on the search page....
$url= "https://swudb.com/decks/search"
$response = Invoke-WebRequest $url
$dropdown = $response.ParsedHtml.getElementById("SearchLeaderID").GetElementsByTagName("option") | select-object
$modifiedDropdown = $dropdown[1..($dropdown.Length-1)]
$randomSelection = Get-Random -InputObject $modifiedDropdown
$leaderID= $randomSelection.value

#GOOGLE CHROME POST REQUEST MAGIC SPELLCASTING

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
$session.Cookies.Add((New-Object System.Net.Cookie("Deck_CardsInDeckSortOrder", "Type", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("Deck_UseCollection", "False", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("Deck_UseSearchSyntax", "False", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie("Deck_AddCardsToDeckSortOrder", "Cost", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie(".AspNetCore.Antiforgery.8r203cMLInQ", "CfDJ8AKb2wlZar5Au9vM7cKQkNFTxCD2SAm_anJRo-vRSdsWIPIIPDp4FVPTaY3adF-UOB7fAkEoP59rZjJjPZiUhA87bYQUYZu2tSce7MsXFy3ctMdf44uoZvn9ShMgbREFYABC0trX8vylm7IK1FyKkGo", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie(".AspNetCore.Identity.Application", "CfDJ8AKb2wlZar5Au9vM7cKQkNFipIJv2o1S_mGmOwKT-5KW6kHH482pim0p_D2t7D7xr4jbjh0E-L3jXi1lGoFHUt6HD91aXlOKD7-u8pE-YhUR-ShRABOGBG9S7t2DyUNjVxvAJiywY8TfH3w1egwoBzuG7BnwOVyWLlJIgVxlUAMNuxadcqeMwDfX9rX14DnfxcezI1yXqg5gGXB_LxehWQsZT1KCial0uk8f8C1HDH8HzxPUORj8aC1LoYy35A37VmtVsny71gGKh7i6kMwxpPZ8au0oY_YkJIYZl7bbkZUgjBtKa0jxN4xkx03XGdLUVE8FSLT8I5Yil_ra-D5sfycGn0Wmfo0wHQn0VVe3oyyMsRfhldQLVtJhsbO9Bs7FNB6xzCIGp4TX3DEPlMK5OCTU0hj4yM8SVjrRRGJxsoEhYp7_r26EkWn_-gk4LVg9D0DvasfruIGG2X2XgvaxpczyDDiT0tzSc4lDDidFfC2mJK1PJLk68HlIS-LnJsyt3DHfDxT6ol62eKOXjjBOryJwLjkGxyJ_PPBHlHtcaXujQCkiS_6mLzj3z-A5NRyAS3AHMM91RbQ1xNgY2D8CLRdzOS-gdJDjSttIFzP52JYznnrAVBNcqOUymAlqgHEu10pQSIHh5O5nKDcgDF3-LzSIFDGJ7GF5ToOM_bOrZKHjM_P-XI7rSt0gIyBSvsxiTWoCV_LI3Z_SArICy9MaJVHzLDNd60_1XWnxY-bFAMpSkJVDyZ-4KyNmQcO8LVmzVSm5NL0Wb9Mb0YSVA0nfwnqZagWZ-TjYyd4VdADFqXlRZh6AvYqRdYW3nU-wML-jbMEVH6HMxyibdaGT1jFhJE8", "/", "www.swudb.com")))
$decksPage = Invoke-WebRequest -UseBasicParsing -Uri "https://www.swudb.com/decks/search" `
-Method "POST" `
-WebSession $session `
-Headers @{
"Accept"="*/*"
  "Accept-Encoding"="gzip, deflate, br, zstd"
  "Accept-Language"="en-US,en;q=0.9"
  "HX-Boosted"="true"
  "HX-Current-URL"="https://www.swudb.com/decks/search"
  "HX-Request"="true"
  "Origin"="https://www.swudb.com"
  "Referer"="https://www.swudb.com/decks/search"
  "Sec-Fetch-Dest"="empty"
  "Sec-Fetch-Mode"="cors"
  "Sec-Fetch-Site"="same-origin"
  "sec-ch-ua"="`"Google Chrome`";v=`"131`", `"Chromium`";v=`"131`", `"Not_A Brand`";v=`"24`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
} `
-ContentType "application/x-www-form-urlencoded" `
-Body "SearchLeaderId=$leaderID&SearchBaseId=&SearchAspect=&SearchFormat=&SearchSortOrder=Hot&__RequestVerificationToken=CfDJ8AKb2wlZar5Au9vM7cKQkNErIvjh8YYZqZkVI6BCsaXNfbpdVm1bzAS1kc0g5JLrRHDvRZtiYHCivGo5HSKOf1WxdLj0gwXcAwt0bSUlTPqkYyf3c4u6aenOxFuBSQ0oTgqMReVvS_eKeIXhLrs6WkkpJ68TyFoTZQLt14O6nuIHRXoLJRnrEnGGtHSPAn3A7w&SearchHasDescription=false"

#END GLORIOUS SPELLCASTING

#Find all links that are decklists, and select a random deck link

$deckLinks = $decksPage.Links | Where-Object href -like "*deck/view*"
$randomDeck = Get-Random -InputObject $deckLinks
$deckUrl = $randomDeck.href

#Append url and make the final call for the decklist
$fullDeckUrl = "https://swudb.com$($deckUrl)?handler=JSONfile"
$finalResponse = Invoke-WebRequest $fullDeckUrl
$data = $finalResponse.Content
$data | clip
Write-Output $data