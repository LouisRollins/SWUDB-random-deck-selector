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
$session.Cookies.Add((New-Object System.Net.Cookie("Deck_AddCardsToDeckSortOrder", "Name", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie(".AspNetCore.Identity.Application", "CfDJ8AKb2wlZar5Au9vM7cKQkNGpCyh8_vDk_IcVrfxOsEPZiR_3vwRJdXYGfaCmZsG5aOYua-KglQITUKBS19fSyab0j54pul1Q54NgoHLGGeOzjz0ZVANYl1ZCxGRf16QV2NJ4F-IrdRKearArg6JOlo6Th4OgCkuTBp9w1vTGlBc4EjJxB853AIJypafS5fxLrx3_RgPT34MhxUMpv5by0YghKBnMcW9-kc0i3ircWTVYBpSziRxvM-vbaYDCUaLzSs7vo5Ll8Y7bhgjDn0fB8J16UbtRkRgVZeJ8XXsVJpWu8uYVlZBRBUHEbgL3GfLtCPtv0LXWF4Qm2waW8Vftf71C8UYBCf121cwHUbXviJY9iLHsKa9bdQtTSiX2Drx_zU7m0cyN4d7th7a_uWZn1J8WCjqMTs_U9O3cnkKNxBxWSn0Ovz34c65xVpNHnj2hSfY_ozHKa1KB1hRsMvI47azYPaoyjXPWF4Geh7a00ZYgeQ3kklDwQp0VoUX9qAbe0u5bYPLAG8P364DV6hH9iJ8tdvD4D_5Sy2qN53XSr5yw1JK_MglGkWmupJ2r0Z0Mz8sRLITAmJaFJ_QayJZsqKmbG6x2ZQjHMSTvONpeSKtrMGyyPAou05VQW7aLQzS8wS3ye8PtYQUwWry49o_puQf0sINOzXdR8lybvyOYIml1bd--CKAgyOOz4cqZ9HGkC4t3KnvF2ZVzQJ_bi_YDsxNmE-a1wFXE-ph9tZhNXSqL54xHJiT5AY2W6oZFzDKxPLXfLgUI2DhsHhpBffULT7ITIAHLFWG9j1OX61F_T7lqlmLQjtV1Fa0Q3Hu9AhvyIhsHBVVgi6En07qE5NSvkzk", "/", "www.swudb.com")))
$session.Cookies.Add((New-Object System.Net.Cookie(".AspNetCore.Antiforgery.8r203cMLInQ", "CfDJ8Ockwgt4SAdPq6deywMH5CuKIIS_dxnrBSScptGFU9GBVTB1n3PWh_WAXtlum1N1cwQpeQrZqcR_mpwnDVQAuwEpcTgQParpTIky91Nb_0bgGlytnZE8fllGr2njRPoY66xuMuX7QTHEDd6iQi3NwXo", "/", "www.swudb.com")))
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
-Body "SearchLeaderId=$leaderID&SearchBaseId=&SearchAspect=&SearchFormat=&SearchSortOrder=Hot&__RequestVerificationToken=CfDJ8Ockwgt4SAdPq6deywMH5Cuy_3bsksu4AxqmmT8i4OXHWAELMf_6hdhHNIjK7LO4Na7oPIMqWg0O2k6Zz94LpoCRek6xGf1OCiIFPigfNgXI5sRtodOuhu9ibU7noutevHPhBsD0lES81wTzgs1ZwH0&SearchHasDescription=false"
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