import 'dart:convert';
import 'package:http/http.dart' as http;

class EasonHttp {
  static Future<Map<String, dynamic>> fetchHomeFeed() async {
    const url = 'https://edith.xiaohongshu.com/api/sns/web/v1/homefeed';

    final headers = {
      'accept': 'application/json, text/plain, */*',
      'accept-language': 'zh-CN,zh;q=0.9',
      'content-type': 'application/json;charset=UTF-8',
      'dnt': '1',
      'origin': 'https://www.xiaohongshu.com',
      'referer': 'https://www.xiaohongshu.com/',
      'sec-ch-ua':
          '"Google Chrome";v="137", "Chromium";v="137", "Not/A)Brand";v="24"',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '"macOS"',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'same-site',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
      'x-b3-traceid': 'ba5b25b1fdef1ff0',
      "x-s":
          "XYS_2UQhPsHCH0c1PjhlHjIj2erjwjQhyoPTqBPT49pjHjIj2eHjwjQ+GnPW/MPjNsQhPUHCHfM1qAZlPebKL/Q9LrYFpbYe+p4d2BEwyDEx80pz+f+onoSbnSY8PASiL0SoNFYjJBQVzMbLprp9pbQO+FzIag4L+S4ka/QCJLk8aSmo4au7JLS8L/SdPSmDnfSrabz649Y0a08E+nTEtF+cyFq78fSFLeSIJUTtpeQizfF6t9k/LDYgLn8xpeQVwBSM4ozx8bkELflVPo4b8bQgL04OaFSOLnTwJASfJfbsNMHEn/zwLDujNsQh+sHCHfRjyfp04sQR",
      "x-s-common":
          "2UQAPsHCPUIjqArjwjHjNsQhPsHCH0rjNsQhPaHCH0c1PjhlHjIj2eHjwjQ+GnPW/MPjNsQhPUHCHdYiqUMIGUM78nHjNsQh+sHCH0c1+AH1PsHVHdWMH0ijP/D78n+0+A+jP0WM+dPA4/ZIqdZU49bC4/PU8AzSP/4iG7mIyoY749qAPeZIPerA+0G7PjHVHdW9H0ijHjIj2eqjwjHjNsQhwsHCHDDAwoQH8B4AyfRI8FS98g+Dpd4daLP3JFSb/BMsn0pSPM87nrldzSzQ2bPAGdb7zgQB8nph8emSy9E0cgk+zSS1qgzianYt8LcE/LzN4gzaa/+NqMS6qS4HLozoqfQnPbZEp98QyaRSp9P98pSl4oSzcgmca/P78nTTL08z/sVManD9q9z18np/8db8aob7JeQl4epsPrzsagW3Lr4ryaRApdz3agYDq7YM47HFqgzkanYMGLSbP9LA/bGIa/+nprSe+9LI4gzVPDbrJg+P4fprLFTALMm7+LSb4d+kpdzt/7b7wrQM498cqBzSpr8g/FSh+bzQygL9nSm7qSmM4epQ4flY/BQdqA+l4oYQ2BpAPp87arS34nMQyFSE8nkdqMD6pMzd8/4SL7bF8aRr+7+rG7mkqBpD8pSUzozQcA8Szb87PDSb/d+/qgzVJfl/4LExpdzQ4fRSy7bFP9+y+7+nJAzdaLp/2LSizLi3wLzpag8C2/zQwrRQynP7nSm7zDS9yLLFJURAzrlDqA8c4M8QcA4SL9c7q981LAzQzg8AP7my/gzn4MpQynzAP7P6q7Yy/fpkpdzjGMpS8pSn478Q4DM02DbD8nzM478Ic04Azob7JLShJozQ2bk/J7p7/94n47mAJMzHLbqM8nG7/fp34g40aLp6qM+dJ9Ll/op+anSw8p4PPo+h8BWManStq7Yc4ASQybHEaSm7aSmM4b4Q40+SPp8FPLSk/dPlqgqManW6qMSl4b+oqg4EJgb7zrS9anTQc7mF/9k+LAz1+7+8LoznanSa2DSiP7+gLo4N8FSCqf+1/d+8pnMManSi/obc4bmyLo4/agGA8/+M4B8FzjRSpoi9qA+PzgQQysRApfzSq9Tc4eY0Lo4YaL+tqM4c4ApQyLkSy9pl/rSea9px8sRA8SmFpLSh+7+h4g4r+rQ8GLSiLn4Q40pAPLF98/8d4d+kGLkSpob7pFS9/aRQzgbVadp7JDDALebQyFRSP9lVtFTDN9LIpd4dagYiz7kn4FSTqDRSpM4OqM4l4BQC4gzfa/+lzrSitFTF4gzccdp78LDAPo+g2d8SPgp7LnEl4BMQyezyaobFJDS3ynI3nD4ha/+9q7Y//7PlqBpSzob7Pg4n4rEQyFzPa/+mqM8l4b4QzLTSPBGhnLSeLfE6nnlPaL+/8FSeP9pk4g4h8M8F/rEM4emQ2BPIaLLAqMzScnp3pdqAa7moLDS94gQILo4TcdpFarShGdpQcAYza/+HLDSb+g+LnnpApomcnrYgO/FjNsQhwaHCP0qlweGA+0ZhNsQhP/Zjw0ZVHdWlPaHCHfE6qfMYJsQR",
      "x-t": "1752040008448",
      "x-xray-traceid": "cbf6dc757a1c2eedc778d60ea8af9f3f",
    };

    final cookies = {
      "abRequestId": "d56346ab-b128-53f8-90ae-02df68a79a68",
      "webBuild": "4.72.0",
      "a1": "197ecc73b2856s3u00rp2wazu32g4e17hcpphxwwg30000136672",
      "webId": "ad7987f65042c5036d4ff529eea08fdd",
      "gid":
          "yjWdSSW4YYxKyjWdSSWqDSCEJY2KMq788FUJUEkE0u7qJUq8k4dyWx888yqKKWJ84Ji0WY4q",
      "web_session": "040069b234715130a9c6f781583a4b924a0f4f",
      "customer-sso-sid": "68c517524892465105587085leya9gmbsqjsixiq",
      "x-user-id-creator.xiaohongshu.com": "63403219000000001802f990",
      "customerClientId": "783964759566655",
      "access-token-creator.xiaohongshu.com":
          "customer.creator.AT-68c517524892465105587086bht4muukufw7kuzn",
      "galaxy_creator_session_id": "nvs56xaFtWMTKOxgSoVOrMbbsa7fDCdqSwzQ",
      "galaxy.creator.beaker.session.id": "1752025556325091492911",
      "acw_tc":
          "0ad6fbc817520393971807749e42634b40a8f2a3d8ba03b424ce361e7bb10d",
      "xsecappid": "xhs-pc-web",
      "loadts": "1752039434627",
      "websectiga":
          "9730ffafd96f2d09dc024760e253af6ab1feb0002827740b95a255ddf6847fc8",
      "sec_poison_id": "12809a4b-b011-4fd3-a4b6-c68c8f40f56e",
      "unread":
          "{%22ub%22:%22686ce73700000000120300fa%22%2C%22ue%22:%2268668fed0000000017033a4c%22%2C%22uc%22:22}",
    };

    final body = {
      "cursor_score": "",
      "num": 39,
      "refresh_type": 1,
      "note_index": 30,
      "unread_begin_note_id": "",
      "unread_end_note_id": "",
      "unread_note_count": 0,
      "category": "homefeed.travel_v3",
      "search_key": "",
      "need_num": 14,
      "image_formats": ["jpg", "webp", "avif"],
      "need_filter_image": false,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {...headers, ...cookies},
      body: jsonEncode(body),
    );

    print(response.statusCode);
    print(response.body);
    return json.decode(response.body);
  }
}
