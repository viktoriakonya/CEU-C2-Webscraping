

rm(list=ls())

# https://fiokesatmkereso.mnb.hu/
# xml format - it is like a JSOn just have a different structure, uses tages like HTML
# Request payload

# Copy curl -> convert to R
require(httr)

cookies = c(
  'LBSESSSION' = '!Xyn+tIDcjFE9IdGe4wkoIwUKkdNmO4WLnobWVQCP6+2VO5CRu3phiSVOffHXsWiEpqpXJauuMOdjLg==',
  'TS01db72bd' = '012f7c1fffd356bcdf62221ff6337e5a411b111680cf1e44e36a9c873121ef18d9e857e65349a42394cdd0ecf2353999d476a42474a154b148d40a0a1540404387fc938af9',
  '_ga' = 'GA1.2.1393335253.1638809379',
  '_gid' = 'GA1.2.1931156573.1638809379'
)

headers = c(
  `Connection` = 'keep-alive',
  `sec-ch-ua` = '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
  `sec-ch-ua-mobile` = '?0',
  `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36',
  `Content-Type` = 'text/xml; charset="UTF-8"',
  `Accept` = 'application/xml, text/xml, */*; q=0.01',
  `X-Requested-With` = 'XMLHttpRequest',
  `SOAPAction` = 'http://tempuri.org/IAtmService/GetAtmsAndBranches',
  `sec-ch-ua-platform` = '"Windows"',
  `Origin` = 'https://fiokesatmkereso.mnb.hu',
  `Sec-Fetch-Site` = 'same-origin',
  `Sec-Fetch-Mode` = 'cors',
  `Sec-Fetch-Dest` = 'empty',
  `Referer` = 'https://fiokesatmkereso.mnb.hu/web/index.html',
  `Accept-Language` = 'en-US,en;q=0.9'
)

data = list(
  `<s:Envelope xmlns:s` = '"http://schemas.xmlsoap.org/soap/envelope/">\n<s:Body>\n<GetAtmsAndBranches xmlns="http://tempuri.org/">\n<value>\n<entity_map_request>\n  <attributes>\n    <fiok>1</fiok>\n    <atm>1</atm>\n    <am_megk>0</am_megk>\n    <am_haszn>0</am_haszn>\n    <postak>0</postak>\n  </attributes>\n  <coordinates>\n    <lefttop>\n      <lat>47.860698956995556</lat>\n      <lon>19.02997666015623</lon>\n    </lefttop>\n    <rightbottom>\n      <lat>47.44998711193677</lat>\n      <lon>19.24421005859373</lon>\n    </rightbottom>\n  </coordinates>\n  <intezmenyek>\n  </intezmenyek>\n</entity_map_request>\n</value>\n</GetAtmsAndBranches>\n</s:Body>\n</s:Envelope>'
)

res <- httr::POST(url = 'https://fiokesatmkereso.mnb.hu/WcfPublicInterfaceForAtm/AtmService/AtmService.svc/GetAtmsAndBranches', httr::add_headers(.headers=headers), httr::set_cookies(.cookies = cookies), body = data)

content(res, 'text') # Request rejected


library(XML)
library(data.table)
t <- xmlToList("mnb_data.txt")




