Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E893EEB64DA
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jul 2023 03:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjGFDO5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jul 2023 23:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGFDO4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jul 2023 23:14:56 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2102.outbound.protection.outlook.com [40.107.255.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C25119B2;
        Wed,  5 Jul 2023 20:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBU164usivaLdmlYyYH3OycYkVbSOM5/Xnuk6pwb0nH409a9a6Qk/iyliGqaH07WG7ds1KRAobTIvI8ZfIioiWd1oGP50tYM4391nKu4YkPVlIO7fv3qbCEsfXLV7h0h3hA0rm3yl33qypwsxM7DmqS14MbymtXc6QhTveZsLZ8HeP92RMKaC57Y4/oYvRFv+F6K7u7sDp8nJ5Oxin8KKm1aXkZtyDwDYMKhuCobR3dY6kgJetmDG7Hy9M9Kig2unFXy4I/TjTBcG00uy3WM/z5rzwvuqWaucmPpVhQvUxh0YYrH5Je43+QVk8+FeYvWwUGzfBvi2cu4S9qsgmnBrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfS/ATkTvqbfwzEopg/eIO/513tQmQ8ekrogvNj+C5U=;
 b=nKflT3ZynpGX3x9NUeGEyxUwd76iGAF+8TwiqqlNZdQ2BqSoWpPQkQdYInG7HUqPanvm/A/W37JqIySLH2DjAIM0WGAjb1A5NTCZ2Ph3x0eq9grF4do3M14nXHuDFp4q+G2GHMGMrnhZpjGa4bfYaeNy4keTzItRwAyTlTHNMpX6tXDaqjofzz2qraIwHyoQBFyNPLJzudBwtgbNhhOEkd1ZcGbM0EUHJrfkglTwmYurpUnrN+/hMvpBbzqIBTYaIu7CM43aa6AbQqQ1fc7fxhtJHnPd4MARgCtO6sxT9nbvsSw1xSJvlvk16EAN/kXuf6NWyoeXdyI/73cwMxCQ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfS/ATkTvqbfwzEopg/eIO/513tQmQ8ekrogvNj+C5U=;
 b=ZOKW4fxBjjc4ofIEp3wgs+ZNOIfymYKuvbd/a/Lf9KnlPG46QK99vTr4ejM+THJU1fSHgYLlb433zArSXzrbpF9GABGZ9oqTfIYYQeYLCvsegHBGCdLCSeFGB8Kol1eY8ZCxV2nrToeACyAtvRkniVEm5rTMtCWpQ3uCCyBEy5P2ug+JGQ545lugiHjGv3ENnndPpqUtuprpzPJdeQ0jennsOvBiMJRwbwUfn/BVqbZfN/pIkdtd6JTlnA7918fb7MfEaUVQbSYfhNZ8AQZoER23lZEk6lMDk4dBmnSdB8J6Z3xnIBv50Q/jAqtbgd1jfw4XJn45err2l4reYbSIqQ==
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 TYZPR06MB6638.apcprd06.prod.outlook.com (2603:1096:400:463::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Thu, 6 Jul
 2023 03:14:50 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::2a86:a42:b60a:470c]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::2a86:a42:b60a:470c%4]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 03:14:50 +0000
From:   =?utf-8?B?546L5piOLei9r+S7tuW6leWxguaKgOacr+mDqA==?= 
        <machel@vivo.com>
To:     Markus Elfring <Markus.Elfring@web.de>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Subject: =?utf-8?B?5Zue5aSNOiBbUEFUQ0hdIGZzOiBzbWI6IEZpeCB1bnNpZ25lZCBleHByZXNz?=
 =?utf-8?B?aW9uIGNvbXBhcmVkIHdpdGggemVybyBpbiBrc21iZF92ZnNfc3RyZWFtX3dy?=
 =?utf-8?Q?ite()?=
Thread-Topic: [PATCH] fs: smb: Fix unsigned expression compared with zero in
 ksmbd_vfs_stream_write()
Thread-Index: AQHZr3G1DBZTmDC5c0S4NmhPGriTd6+sEJqw
Date:   Thu, 6 Jul 2023 03:14:50 +0000
Message-ID: <SG2PR06MB37433E34BA3AE623D2B22FA0BD2CA@SG2PR06MB3743.apcprd06.prod.outlook.com>
References: <20230701055556.23632-1-machel@vivo.com>
 <374f7745-537c-27d6-09c4-3b77c9eac373@web.de>
In-Reply-To: <374f7745-537c-27d6-09c4-3b77c9eac373@web.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SG2PR06MB3743:EE_|TYZPR06MB6638:EE_
x-ms-office365-filtering-correlation-id: 3815c676-8b9a-4503-925f-08db7dcf291c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O7HEQ7t8NCkRb4r7SAF3jjjV41tESi4T+KHfzoByY8VDrZkdwe3wrRopZrMxdRu+Pq8S21lpVyrw9NzFDJJpGthj1r0Oro35DiaFZPgBIcJd09Uf5PzUzY2YeHy+ly/eB/qDjm/2yZAZLvB/OubMr6BWXS+yKyszrwxWmWO8Jd6qV3R2JU0qDvzH8H9KuAmb22wWuNYxwBAU1hlAgpdY4g+zBKtjn8w5b1MBy5W5v+q7Baaxw8y6UMEHeRp4Hk9jJpQbcSbvmsuQlBGqD1iFFFsl+ueXLFZ8/M/Snn3usSRwDeIF/GZLl2EwUrbJ1sR8gKqj5qYgEwuojMYRIfv0eFcFobfZPTpwcsXbimZGL7+p9evCALBcUuZ2Myr/4apl7FnrB9ni10jjJyH7jLv61uZijAhpJtVL06hDH++h2T68z/V6TnUpstRwtVSP6DpNEsLg1RELJ2yC2ZULpteAwBM0NNVnhfgZb/cDtmphDKPEwOpUtQ+MhT4W6HFPAEaUCTwlBcMi6B8CekClQZhyXUv4E1UsdAC5XCHLkiBKDiZvVCDV6dp++/K6bvhCIQn142OjtpuBDck3vzwMLyPbEIkW5wCeBpiXX+dVxrGUSwo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199021)(85182001)(224303003)(38070700005)(86362001)(33656002)(2906002)(4744005)(5660300002)(52536014)(4326008)(55016003)(186003)(9686003)(6506007)(26005)(54906003)(122000001)(7696005)(66946007)(478600001)(64756008)(316002)(66476007)(66446008)(38100700002)(66556008)(6916009)(71200400001)(76116006)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGhmT0lEN3VBVWs3ZFlUS1hpblpCd1ZUT28xZEFURHRVTGNROHFQZmRmQmlh?=
 =?utf-8?B?ejJkK25vNEFxOVpDZzNZdzJSbGdpSC9kUzMxQ1UyMnozaEluL0NaOWMxVUFu?=
 =?utf-8?B?VUpPbDRMNXhpZEcwYjVzdWcwdGpDTGptdVNvRHY4Nld6QVRxWm5IU2tTWDc2?=
 =?utf-8?B?QkdLdENib1JGbkxOYkZMeUZacFJjSi9GSkFtanFyNjNmbm1YRHl2MlpwS3VM?=
 =?utf-8?B?eUlLU1cwS28xcjVKZWV0Q2tnTG0yMnJkMURiZFBnR3dWaDRjcDBKbFlkdkJO?=
 =?utf-8?B?UysrdEhOOFM0ZlFMV3dDbU1OTXVlUm05ek9kZkFiLzhzOHFXY003bWx1MGdJ?=
 =?utf-8?B?dUUxd2Y4Vlo0a3N2eERWSi8wWUpMQmIyeTZEVFlUS29xRkJTTk5sSSs5dFdZ?=
 =?utf-8?B?cUZoQ0lobDZIWnA2SHBzYzd1WGdOQ3Y4WERQMGM2MmdsUlg1TWJDQWRhMVlk?=
 =?utf-8?B?VWxETlRid0lLUWExVHJ6REV4aDlRbFFsNEt5Kzh5dEZQL0xrMTBkRVArZkls?=
 =?utf-8?B?WU1zemFKUFpTSC93TlhGMWx5eStvRXRWVTZBajdHU2I2Qk16NzBaYmlvRkR0?=
 =?utf-8?B?Tkc2STVrSEpUNStxTndTbS9uSWFzbmR6SFFGVE5sUVZiK3Z6M0hidzN5Mkxm?=
 =?utf-8?B?Sk42VnE5OVhURjJyNlEyT2dXb0dpRGlNYzRKeTJPNnZtak4xeDZCOXNsd0h4?=
 =?utf-8?B?TTBnTlJDdndFNWRaTGt0OWVFaTY3ZFF4bURwd0VGMzFOcDUxVGUraEdidytJ?=
 =?utf-8?B?aEZ6bDV2NE5ndUNZc2lzdFhreGphbWRjbmZ1MWFvTkZ4TkRVd1llTklXWXpB?=
 =?utf-8?B?N1VYSDVOZGlUUjZjcEIrM01HdzRnang2ajVqQVlXdWV3L1cyaWhYdEVVenhM?=
 =?utf-8?B?UTlYb1ptVnN5NE5zZkVKTlo5WXh6UmFpODBieTZEb0wrZExWQ1gybUNVRFFq?=
 =?utf-8?B?TGFRRVQzRHI4OEM0WGJXM3JXaUZLY043NzlvMnUrdTU3cTZIWkdBUTdOQkdX?=
 =?utf-8?B?VFcvc2FaUHQ2aWt6OGJXNXFobnV2RUVzcHplUUV6bTl1eTh0K0lWbkc1SW5u?=
 =?utf-8?B?Vy94VkNja0ljcWt5L1FaQ053TmJUaGxQNVBDZnE4OS9NWFlLbENyeUs2aUxN?=
 =?utf-8?B?cVdPQmpnbFhpZTJScTdNUUpVQkZvSE1ZdU4yRTZEL2JYeGpPbFhNY2VSYXQr?=
 =?utf-8?B?NDdxdTUwdVhnVWNEcWk0TXhNTGVQeE1FSVFHdC9Hb2Y5TmF5NUhCUFN0RXhU?=
 =?utf-8?B?eHVVeHhISTFFRVVyZUR2dmtEbkl5QmNxTUVhbE9KS1ZmN21oQ05uSkJKYTZa?=
 =?utf-8?B?VUxzTWdBc0FpTzh2S0Y1bUs5WERod0hVZTJXeTdhdWQxUjhsSlFvbzU4d3FQ?=
 =?utf-8?B?a3crY0NIVDBMdmttV00yQUwzSzBVWDRuTzBnWnJ2MVJJUWpac3E5djhseWlj?=
 =?utf-8?B?cGd2MkZNdnlLRUMrQ1h5ZnV0Q1N1bnlHK2FrVFkvT0tEVTN0TXpkN2lWSmlj?=
 =?utf-8?B?a2FRZitFYW0wemdwUTNaS0ppaFo3R0x2dy81b0g5UkJEMC9COVVyYkcrVlFF?=
 =?utf-8?B?ZGhibml1ZUdpQUVYKzJHWjZIanFnZ1NUaENtOS9sL0NQODFHTEtieW1UWWt6?=
 =?utf-8?B?a3FyVDJ1VkdrNnVpc244N3NPblkvbU4wcHJ5S1J4RCtGTTBqenJpTzVGcTJw?=
 =?utf-8?B?ejJ4dHBZeC9KQ1ZOMkllN1pFSG1oKzFTK1BOUFZFUnNvdkFQNTlwZE9YQ0kw?=
 =?utf-8?B?L3JzTndiSld5ZFJBUm1nSndqaG9sWk9NQlBZeUgyL2Jvak5wdElDNi9VdTla?=
 =?utf-8?B?TU5SYkpOQjRlcktaT2dVbTErTzZQVWpOQWxlQjM2R0N5SHQ0eVpXTFh0eTdL?=
 =?utf-8?B?VzAyYVcrMTROa1ZuZDdaOWJLYWNGeFYzZjBybUtHOFpNT3NrSVB2VGkzY1ZP?=
 =?utf-8?B?ZGlJMi9CVEI3TDBYZHNISzVIczNnTXFxL2NPSWhPYVdXZElvQzR1MnZDczZ1?=
 =?utf-8?B?d2VudDBBU3ZlZUIvc3pWZFJpNW94VVRMRDRLem1qOTJ4SnhnOThKMnM0ZE12?=
 =?utf-8?B?cTFKdHQvT1JyVzkySmk0alllbUxKeHpoWk9XZGhiSmtoRjljSnowd1ptblUw?=
 =?utf-8?Q?9+qw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3815c676-8b9a-4503-925f-08db7dcf291c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2023 03:14:50.4263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L0mHHWxQNdGbhEaK0Ri7tVitTvSuEXZCKtMxdiFWcdtB2GUEKvn9LoH5q8c1XNSmVSonbB4NPWvn99JWeS/stA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6638
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

VGhhbmsgeW91LiBJIHdpbGwgTW9kaWZ5IGl0DQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hk
u7bkuro6IE1hcmt1cyBFbGZyaW5nIDxNYXJrdXMuRWxmcmluZ0B3ZWIuZGU+IA0K5Y+R6YCB5pe2
6Ze0OiAyMDIz5bm0N+aciDbml6UgMjo1MQ0K5pS25Lu25Lq6OiDnjovmmI4t6L2v5Lu25bqV5bGC
5oqA5pyv6YOoIDxtYWNoZWxAdml2by5jb20+OyBsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZzsg
a2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsgTmFtamFlIEplb24gPGxpbmtpbmplb25A
a2VybmVsLm9yZz47IFNlcmdleSBTZW5vemhhdHNreSA8c2Vub3poYXRza3lAY2hyb21pdW0ub3Jn
PjsgU3RldmUgRnJlbmNoIDxzZnJlbmNoQHNhbWJhLm9yZz47IFRvbSBUYWxwZXkgPHRvbUB0YWxw
ZXkuY29tPg0K5oqE6YCBOiBvcGVuc291cmNlLmtlcm5lbCA8b3BlbnNvdXJjZS5rZXJuZWxAdml2
by5jb20+OyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPg0K5Li76aKYOiBSZTog
W1BBVENIXSBmczogc21iOiBGaXggdW5zaWduZWQgZXhwcmVzc2lvbiBjb21wYXJlZCB3aXRoIHpl
cm8gaW4ga3NtYmRfdmZzX3N0cmVhbV93cml0ZSgpDQoNCj4gVGhlIHJldHVybiB2YWx1ZSBvZiB0
aGUga3NtYmRfdmZzX2dldGNhc2V4YXR0cigpIGlzIGxvbmcuDQoNClRoZSBmdW5jdGlvbiDigJxr
c21iZF92ZnNfZ2V0Y2FzZXhhdHRy4oCdIGlzIGRlZmluZWQgd2l0aCB0aGUgcmV0dXJuIHR5cGUg
4oCcbG9uZ+KAnS4NCg0KDQo+IEhvd2V2ZXIsIHRoZSByZXR1cm4gdmFsdWUgaXMgYmVpbmcgYXNz
aWduZWQgdG8gYW4gdW5zaWduZWYgbG9uZyANCj4gdmFyaWFibGUgJ3ZfbGVuJyxzbyBtYWtpbmcg
J3ZfbGVuJyB0byBsb25nLiDigKYNCg0KUGxlYXNlIGF2b2lkIGZ1cnRoZXIgdHlwb3MgZm9yIGFu
IGltcHJvdmVkIGNoYW5nZSBkZXNjcmlwdGlvbi4NCg0KUmVnYXJkcywNCk1hcmt1cw0K
