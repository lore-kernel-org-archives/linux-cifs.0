Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazon11022141.outbound.protection.outlook.com [40.107.40.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BFB378D94;
	Tue, 17 Mar 2026 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.40.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740958; cv=fail; b=qk3uz9OPfHqdncdvFPHdsYy+/9Ce4ztV6rGPBGCbMwM2jCQeG+5ha2M8HpCrVn0wzSIqzANCn0xgeYGr96PG79+aFdgz6/4gIy4dG6lCrJJE6kl1alS3vkMe2ww1OLZESTMIJrWLMNXnYDBSJdF/hwtVo2S96BjD3dzDfuzuD0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740958; c=relaxed/simple;
	bh=HqMJjGHOuNLB6VqHzg1+Yi3GE9h7foO+q/ULsyHJCYs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bYdcYazVF1Hj4XrdWYeAJQvCMifzfCEHOcJs+MEnN/UV/YFMNesKRhNykAGmsH2w9sIGACrg+KLrhc6ya8+pcI2F834HZMaMNjnzSHDoRks3/rBw89FzgHMIicrsF1BLl8tRtaAYnzPPZt+3dfUaFV4sjzOlDlRkvjkXXim5m5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai; spf=pass smtp.mailfrom=verivus.ai; dkim=fail (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b=p6koKaOi reason="signature verification failed"; arc=fail smtp.client-ip=40.107.40.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=verivus.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=verivus.ai header.i=@verivus.ai header.b="p6koKaOi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxZ94bvUh8Kt24dtILGsxAX8/x0TW2hLhkrvCtHsTR+sW1dGjTVpj1EZpk63omcfoDzelJlttNeiINwgvN4JJQpL3O31pGKqeM0hN9nA+kNkmZskdldm9aZMh6lw9MKPi+UH3qrudUdGEsvVUszokI81xsqPrG2Njiz1XVEOk5KmdOKoQOol/Qx4j2x/7HYdZr1inbwi3FHQLaqnExZiQoLGauo0LDXHpHdIsspGvqD9vu+TZOLHmq1F2C6Ic8zREUwg7+IW47Rh+2ScVkK0NV7epTKlxoaXA0PMrYMq/YwKWgOyNqpGYpH9HHktPWD5Ne+YrMLQ285gGZvQ4mvdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqMJjGHOuNLB6VqHzg1+Yi3GE9h7foO+q/ULsyHJCYs=;
 b=vBFPzQwOhtuYhyRrlO3vLFx9lMA6sCDwWsPsD/IU2ESNGs2u+3/YLyslm6MNYsk4nr4egmSyhOUnDefYSXPmhbnJ+vsKH+uxHhyD14a9MBywX12UZfkYUOQ81nNCgtEsjhS97JtqIl9cIbv2GyuXwGOvDBxFrjG1xe3VT1Rf7YYsMN3rt3p6rUnNc5FuGHBTWQdyH27R/QhDQK5C9itpJjS9TUZlhyqFD6hNgCM1sVSNPqT64+aL/wTAL64+jmTQLrCd2bCgaJzOdK80OMIjqw3H8b7Sk+yqJv/pYGxNrVsCyENQj4Iddis2802DeQiyfcn22ckyicEOT2WIRogg1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.ai; dmarc=pass action=none header.from=verivus.ai;
 dkim=pass header.d=verivus.ai; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.ai;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqMJjGHOuNLB6VqHzg1+Yi3GE9h7foO+q/ULsyHJCYs=;
 b=p6koKaOiQK57hX6DRlX+6Is6zyfy/IkZB1E7aUtFGCflbX+dl93aM9LSZjqTTX+7Jn7qLwgx/J8xsIC5UfvfDoj4MgqCe+o1+fSdGyo/8wbBcQ8ioGNsFKafhXFIaz37E5zpi80D9n5ikKcOdGyQRRwmwDKKGjoRrioI8kBHOMIwDJky9LkCRqnP3FYVZdZBqKFv4F1oE7YiAU+lGQwmZuHuUzUijS9jq5+pbwU18RxMzUO3iX0eYPkfrpiw70cZzyc437PBOALaJ5dH83B4YUAvDFEaIzJRPkIWZHAnBdbQLluINHJRJ6pPVtzlKBFRi9JdLt4dcp+yIvhF3I84Xg==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY0P300MB0451.AUSP300.PROD.OUTLOOK.COM (2603:10c6:10:27e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 09:49:12 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 09:49:11 +0000
From: Werner Kasselman <werner@verivus.ai>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Namjae Jeon
	<linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
CC: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
	<tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Topic: [PATCH] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Index: AQHcteVCmLHUy6PFJkipVHvK9wCm3rWydWiAgAAFBHA=
Date: Tue, 17 Mar 2026 09:49:11 +0000
Message-ID:
 <ME0P300MB085357E95CAA7AA9355AB71FBD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
References: <20260317080835.1947664-1-werner@verivus.com>
 <9192ff4b-770a-411b-af5d-ab06d20248f8@chenxiaosong.com>
In-Reply-To: <9192ff4b-770a-411b-af5d-ab06d20248f8@chenxiaosong.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.ai;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY0P300MB0451:EE_
x-ms-office365-filtering-correlation-id: bc3e74d5-0dfc-4581-2d10-08de840a7156
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 vd8+sD133LK/1FYu8h7Q/uY2efxFCLzzNSVnNZVzVLYar5Y04NxflCPqm4ea7ZU+psZTTlLplOWsyP/Ekx1rib8xdYaZQiBk6Qbu/LKvpWGvi4DTzoTBdzBm389ah01dMzm/4oJ2b72sW5Dr3GQ2H3JTw2VyizpiP6c9oIWowKN4R09uWnHXkKxR+7jUQj1QZJMoNqSuJ652uvf0n3elsrKbZGkDUnpKzELdQSV08aJF+1mmpLGrdi9dI2x6nZlFOcbdvYYF5mAa4UDjjzx9ASbmAT1Hl/igc2kcVBeMX7K5yClHpthnFR31CjrnYNxEyN7FTMU0sJ9J4viH0pYd0R+VSxDYZg8P1sdMLR0YPceLxL01wK4sF4HC+NNGO7p5UcIEj/VaC9206iF2rg0A/TC9r8Ays8aV9hezLA3poTiHerPpsOPfHwTJi3mZMAuZgeBx4yQOfcC8jt7pefy+UgrIo+Xwcb8r+NqYoI1W9Pbq9ANlFBT/tdlkHsSSmLvMhuQ7NZuYRJirkNhsJ9gFmiMN9R7LlWudGiFseXtmXTG9Zun4pUDQd11UiinQekNyOqI6UDbXeRp5yciIpPLwPuuis+G9/4IgZsS9FjQ0Lz9jJ8La9U6aEM12wtEKch3DN+kP8kAJn+bqwH63E3OCyA21X+VdVOYQaFVqVitOi3MYc9y9hggxGHR18Hh0MS9ID2Gp7Gh7ZOBCA3mNpzwKtXm6W83TBD/scOzDplC9V6TXoOqUAKWe/rd4sftab1lok9YHL/4Fz7cCRqH1MYq9mdf4QfKyqo0sDHFx/SHsWnA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YzB6aXBUbkdiNlpkL3JGWWFXTzFBaGJWbmZ3STZoczdmVW8wUldlTEZsZi93?=
 =?utf-8?B?R2lHdFVSMlFUczgzM1hvcVdyTlE1aGhxVzBpdGJobExzU05sTWhpMXV1L01j?=
 =?utf-8?B?S1pkaGthOVQ5VUgvWmdRU3E0d0FPbnhubjU3bTh6U3I3NElybDlTOGtnanJj?=
 =?utf-8?B?LzVyMmZ2ZFpXWEhQUlI5ZlN2cHVJSmRXM0RmWXA3aWcwdnE1OXMwODM2c3Fo?=
 =?utf-8?B?M1IyZkR5N2tnNW9aRTdadVByQzRHQnZQMHZsYlR5RzlFSmtCTkR1bDBGdytl?=
 =?utf-8?B?K1ZEM294Z3FFUEt3Si9EWHBOK2VoYjdnMGZ6eDZaUWNRelB2QUNERnpkNnRF?=
 =?utf-8?B?K2trbUxReXVFdlplNnI0ak4wZmRRN1BsNGdFNjRTeTJJQXF3VjBHT3l4NVhl?=
 =?utf-8?B?dlpkRWxlT3VMSHVPOVlvdXQ0cDN1bmJlMHI1STBrL01ucjJLSUNQU3VJRTJS?=
 =?utf-8?B?UWFrZWU0MFphNzVMeWxpcGlDRmNUa2pjMVFEdWdBNVI3bEtlaGVYUVZZeHlU?=
 =?utf-8?B?Qk5QUVoyZVN3aTJaNWliNmNVbUhTUXNLYXRLalNmTkhZY3ZlcUxCVEN3QzFN?=
 =?utf-8?B?TFBibWNISDB1NWoydStxTSthNU1QbWJ6M01HYVloWGIyZmtxbWpXRHRkTnZp?=
 =?utf-8?B?KzF3ZlVpbXlNeSs1WjVpbk1Yb09LRkUrOHJIakROWC9iZzFST2RBUmVvTEor?=
 =?utf-8?B?Q2Rxb1UzMnlhaCtKaVhPbUhXUGVua0QwZ28rZkppL0xiSzNSODdXakoweVFX?=
 =?utf-8?B?eit2WjdrL1BuUm4yV1dHVkVvT2lzbjdDdlM3aFpTbExrZGZVaDBBdW5MbnZS?=
 =?utf-8?B?RlVaQUg1cW01S1hIeFl4MjNVUFB2MHpWVGk4WWRndmhXRGN4cDZVNUZPQW9D?=
 =?utf-8?B?L1pjZzdhNWVGb1dkYUFqOTZPaG9GY0JqbDJHZjhhcC90R3pUV25RU0NYakRZ?=
 =?utf-8?B?ZklveHhsRTRBN3Z4NlVLTmo5eU0zV05WdGtINWRERXdoWmNzMUxzTlNRMEJ3?=
 =?utf-8?B?Uk9DU3hyOWZnWHJUQ015ZU84MDc2YmxqZUg5NUJvUHNwTTd4UllXQVRuTnFW?=
 =?utf-8?B?bHBycjRPWE9seW9sMTI3MnRVa2htSElKbUNGclp3WWdwTWE2RmF2YmJvaERo?=
 =?utf-8?B?TW5FSkZWUkh4Sm1BVzYvN3NBNGhVZVQvMUVrbWRkOTg0c1EweC8wbWhIM085?=
 =?utf-8?B?MWYzR0o4ZXk5RUZUZ29rZUJZdXdqclJnOWZPdjdkbVlyZHp6eEptTXFzMW5Q?=
 =?utf-8?B?MjRMTjQrTGxZeWZLZDgza3ppWmx6ZWg2bnVYRHdkamJwRUtvQVBoOFIvK3RY?=
 =?utf-8?B?eTZLTXlINzBzd3JYTExERmVZMWJ1SmtrOEV5K3J2SEdXWEk2ZEc4NVp6SkFK?=
 =?utf-8?B?MXl6bkhtQWRWY2NuRVdQYmFWMTVoa1lFVGR1R3RkM29wa1hpRGdVSnQ2eGRm?=
 =?utf-8?B?a2pmWWZYQ01VeVQ3VVlpNitvUkIzaW5DeHZoSFNqc0dSTS90cmR4bEtFYjND?=
 =?utf-8?B?K0l2NlZBTWZveDJOSTQ1VXdkNUZaa1lsL2tLa21RTmNVbHF0cTJzOU9JRUJX?=
 =?utf-8?B?R0h6OEkxa2huUGdzeW1sVEh2K1NuWjRZd1d2aWdPZHh1WTRmZlBwWVptSG1S?=
 =?utf-8?B?aGVkNElaazVSdDZFU2NxT0pYYjg1bXRrbW5oSHdnYjJNaGg5NUJubGFVWXBr?=
 =?utf-8?B?NEhiaktYdFBFTHBxNEhtK3NqRTBWRWRpUXh5RU01WGVyOVphZU81aFdPRENi?=
 =?utf-8?B?bVhXU0U2akZEZzJtY3FPNjlhQnFEQnNhRGs5WFcwNmNtajFkVDFGMEZFL05r?=
 =?utf-8?B?bjlOVEZRcjhtdlc2QmtVN2VFSGtQRzd1dTZBbTViOHBJMzI2NVVOYXA0RVZX?=
 =?utf-8?B?SnFWQ2k0Z1dCdWFWSFAvMWdic0M0OVE1Umt5YUF1TElOVGhNd3FybCt0L2dE?=
 =?utf-8?B?Q1VDZ3dJaVU0VmdrNkhsZ2JITlAwcFQ5TnUwdnBDL2pxN2FMWXFIbktSUEdl?=
 =?utf-8?B?YVlCZWJjYlYyYUpCUWsrNW1EMFcrS2N1ZC9iMnpBTUp5dTk3N0JVakV5cGxQ?=
 =?utf-8?B?MDhGMzFBeTd5NGRGY1A0ejZEQjBtUDlYY1NGdjNTcFpxYXU3L3ZTTWJBZEtk?=
 =?utf-8?B?ZTVIOWRXU1FhYlBmNFB1Sjl5V0Y0SVoxaDM3Qi9tbHVEeUg2c0xmM2E0Mjd0?=
 =?utf-8?B?Zm9BVzhnd0VGOVhUcmpNaTJUZHFqTzliVkFkV2tQUS80OVdFNUV2NXo1NVow?=
 =?utf-8?B?NU1HOEoxeHVBaisxQ0szMzljU0FVcTJYc3B5Q0lQcHh1VVliZUZoVFZQNFFY?=
 =?utf-8?Q?m8eCFGktDXfJFHmEJC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.ai
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3e74d5-0dfc-4581-2d10-08de840a7156
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 09:49:11.8633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6U7aodZdfV761+l8ynvDN1fTobY4fF0VYaqk83cHegFqt46PYUlzPJOcHCmuwFU7iHxUG1k33tHlkkMZqUphgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY0P300MB0451

VGhhbmtzIENoZW5YaWFvU29uZywNCg0KQm90aCBzdWdnZXN0aW9ucyBpbmNvcnBvcmF0ZWQgaW4g
djI6DQoNCjEuIEhvaXN0ZWQgbG9ja3NfZnJlZV9sb2NrKCkva2ZyZWUoKSBiZWZvcmUgdGhlIGlm
KCFyYykgY2hlY2sgaW4gdGhlIFVOTE9DSyBicmFuY2gsIGFsbCBleGl0IHBhdGhzIG5vdyBzaGFy
ZSBvbmUgZnJlZSBzaXRlIGluc3RlYWQgb2YgZHVwbGljYXRpbmcgaXQgaW4gdGhlIC1FTk9FTlQg
YnJhbmNoLg0KMi4gUmVwbGFjZWQgdGhlIGR1cGxpY2F0ZWQgcm9sbGJhY2sgY2xlYW51cCB3aXRo
IGFuIGlmKHJsb2NrKSBndWFyZCBhcm91bmQgdGhlIFZGUyB1bmxvY2sgYW5kIGEgbWF0Y2hpbmcg
TlVMTCBjaGVjayBvbiBsb2Nrc19mcmVlX2xvY2socmxvY2spIGluIHRoZSBzaGFyZWQgY2xlYW51
cCB0YWlsLiAgVGhpcyBlbGltaW5hdGVzIHRoZSBjb2RlIGR1cGxpY2F0aW9uIHdlIGhhZCBpbiB2
MSB3aGVyZSB0aGUgIXJsb2NrIHBhdGggY29waWVkIHRoZSBlbnRpcmUgdGVhcmRvd24gc2VxdWVu
Y2UuDQoNCnYyIHNlbnQuDQoNCktpbmQgcmVnYXJkcywNCldlcm5lcg0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogQ2hlblhpYW9Tb25nIDxjaGVueGlhb3NvbmdAY2hlbnhpYW9z
b25nLmNvbT4gDQpTZW50OiBUdWVzZGF5LCAxNyBNYXJjaCAyMDI2IDc6MzAgUE0NClRvOiBXZXJu
ZXIgS2Fzc2VsbWFuIDx3ZXJuZXJAdmVyaXZ1cy5haT47IE5hbWphZSBKZW9uIDxsaW5raW5qZW9u
QGtlcm5lbC5vcmc+OyBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4NCkNjOiBTZXJn
ZXkgU2Vub3poYXRza3kgPHNlbm96aGF0c2t5QGNocm9taXVtLm9yZz47IFRvbSBUYWxwZXkgPHRv
bUB0YWxwZXkuY29tPjsgbGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBbUEFU
Q0hdIGtzbWJkOiBmaXggbWVtb3J5IGxlYWtzIGFuZCBOVUxMIGRlcmVmIGluIHNtYjJfbG9jaygp
DQoNCkFuZCBpdCBtaWdodCBiZSBiZXR0ZXIgdG8gY2hhbmdlIGl0IGFzIGZvbGxvd3MuDQoNCmBg
YA0KQEAgLTc2ODUsMTMgKzc2ODYsMTcgQEAgaW50IHNtYjJfbG9jayhzdHJ1Y3Qga3NtYmRfd29y
ayAqd29yaykNCiAgICAgICAgICAgICAgICAgc3RydWN0IGZpbGVfbG9jayAqcmxvY2sgPSBOVUxM
Ow0KDQogICAgICAgICAgICAgICAgIHJsb2NrID0gc21iX2Zsb2NrX2luaXQoZmlscCk7DQotICAg
ICAgICAgICAgICAgcmxvY2stPmMuZmxjX3R5cGUgPSBGX1VOTENLOw0KLSAgICAgICAgICAgICAg
IHJsb2NrLT5mbF9zdGFydCA9IHNtYl9sb2NrLT5zdGFydDsNCi0gICAgICAgICAgICAgICBybG9j
ay0+ZmxfZW5kID0gc21iX2xvY2stPmVuZDsNCisgICAgICAgICAgICAgICBpZiAocmxvY2spIHsN
CisgICAgICAgICAgICAgICAgICAgICAgIHJsb2NrLT5jLmZsY190eXBlID0gRl9VTkxDSzsNCisg
ICAgICAgICAgICAgICAgICAgICAgIHJsb2NrLT5mbF9zdGFydCA9IHNtYl9sb2NrLT5zdGFydDsN
CisgICAgICAgICAgICAgICAgICAgICAgIHJsb2NrLT5mbF9lbmQgPSBzbWJfbG9jay0+ZW5kOw0K
DQotICAgICAgICAgICAgICAgcmMgPSB2ZnNfbG9ja19maWxlKGZpbHAsIEZfU0VUTEssIHJsb2Nr
LCBOVUxMKTsNCi0gICAgICAgICAgICAgICBpZiAocmMpDQotICAgICAgICAgICAgICAgICAgICAg
ICBwcl9lcnIoInJvbGxiYWNrIHVubG9jayBmYWlsIDogJWRcbiIsIHJjKTsNCisgICAgICAgICAg
ICAgICAgICAgICAgIHJjID0gdmZzX2xvY2tfZmlsZShmaWxwLCBGX1NFVExLLCBybG9jaywgTlVM
TCk7DQorICAgICAgICAgICAgICAgICAgICAgICBpZiAocmMpDQorICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHByX2Vycigicm9sbGJhY2sgdW5sb2NrIGZhaWwgOiAlZFxuIiwgcmMpOw0K
KyAgICAgICAgICAgICAgIH0gZWxzZSB7DQorICAgICAgICAgICAgICAgICAgICAgICBwcl9lcnIo
InJvbGxiYWNrIHVubG9jayBhbGxvYyBmYWlsZWRcbiIpOw0KKyAgICAgICAgICAgICAgIH0NCg0K
ICAgICAgICAgICAgICAgICBsaXN0X2RlbCgmc21iX2xvY2stPmxsaXN0KTsNCiAgICAgICAgICAg
ICAgICAgc3Bpbl9sb2NrKCZ3b3JrLT5jb25uLT5sbGlzdF9sb2NrKTsNCkBAIC03NzAxLDcgKzc3
MDYsOCBAQCBpbnQgc21iMl9sb2NrKHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQ0KICAgICAgICAg
ICAgICAgICBzcGluX3VubG9jaygmd29yay0+Y29ubi0+bGxpc3RfbG9jayk7DQoNCiAgICAgICAg
ICAgICAgICAgbG9ja3NfZnJlZV9sb2NrKHNtYl9sb2NrLT5mbCk7DQotICAgICAgICAgICAgICAg
bG9ja3NfZnJlZV9sb2NrKHJsb2NrKTsNCisgICAgICAgICAgICAgICBpZiAocmxvY2spDQorICAg
ICAgICAgICAgICAgICAgICAgICBsb2Nrc19mcmVlX2xvY2socmxvY2spOw0KICAgICAgICAgICAg
ICAgICBrZnJlZShzbWJfbG9jayk7DQogICAgICAgICB9DQogIG91dDI6DQpgYGANCg0KVGhhbmtz
LA0KQ2hlblhpYW9Tb25nIDxjaGVueGlhb3NvbmdAa3lsaW5vcy5jbj4NCg0KT24gMy8xNy8yNiAx
NjowOCwgV2VybmVyIEthc3NlbG1hbiB3cm90ZToNCj4gQEAgLTc2ODUsNiArNzY5MSwxOSBAQCBp
bnQgc21iMl9sb2NrKHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQ0KPiAgIAkJc3RydWN0IGZpbGVf
bG9jayAqcmxvY2sgPSBOVUxMOw0KPiAgIA0KPiAgIAkJcmxvY2sgPSBzbWJfZmxvY2tfaW5pdChm
aWxwKTsNCj4gKwkJaWYgKCFybG9jaykgew0KPiArCQkJcHJfZXJyKCJyb2xsYmFjayB1bmxvY2sg
YWxsb2MgZmFpbGVkXG4iKTsNCj4gKwkJCWxpc3RfZGVsKCZzbWJfbG9jay0+bGxpc3QpOw0KPiAr
CQkJc3Bpbl9sb2NrKCZ3b3JrLT5jb25uLT5sbGlzdF9sb2NrKTsNCj4gKwkJCWlmICghbGlzdF9l
bXB0eSgmc21iX2xvY2stPmZsaXN0KSkNCj4gKwkJCQlsaXN0X2RlbCgmc21iX2xvY2stPmZsaXN0
KTsNCj4gKwkJCWxpc3RfZGVsKCZzbWJfbG9jay0+Y2xpc3QpOw0KPiArCQkJc3Bpbl91bmxvY2so
JndvcmstPmNvbm4tPmxsaXN0X2xvY2spOw0KPiArDQo+ICsJCQlsb2Nrc19mcmVlX2xvY2soc21i
X2xvY2stPmZsKTsNCj4gKwkJCWtmcmVlKHNtYl9sb2NrKTsNCj4gKwkJCWNvbnRpbnVlOw0KPiAr
CQl9DQo+ICAgCQlybG9jay0+Yy5mbGNfdHlwZSA9IEZfVU5MQ0s7DQo+ICAgCQlybG9jay0+Zmxf
c3RhcnQgPSBzbWJfbG9jay0+c3RhcnQ7DQo+ICAgCQlybG9jay0+ZmxfZW5kID0gc21iX2xvY2st
PmVuZDsNCg0K
