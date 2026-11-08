Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794154433;
	b=faern8DfzQpC59R7PSohaUJ/QRTObTSOn8bZ55btvO8OR7RLMCSlQ4aOcdIGbHCaiOnf
	 RB89amvT0EzApeCB0coUCux1EHY4TkcEnaB/hl1hEDj9VpSmjHnnA6MGwFVrDTy7fedmK
	 ZKfT593R4YO/MkenS2oCrLQHsXwPCTRtjRfM8L4hZ6TUIPtlhFC0A8OWyqAyEdtZHJuyl
	 oPUXQDsJKJpWb16l+AkrJPflS9yl5Ay/wkIkehhPw5apk9DAEBEJf20rGPmv8O5ZiohcJ
	 EH42bQQ3t5kfFjyYEBrqD9Ytm0bj29UZFQFX2hUpYouUsx6jFTb3vUx6t3DQ6WuH+DQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794154433;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=hvHCEldxhDro/NPwmC30xrnnAoLNsESHOYD0dqg2b9A=;
	b=MGAba1f+JRhluya9pH2myMPfrZPpDBZKkv4xGUlUXroHig/8aqrBWwicyDwBHOHbMViI
	 5u8oIVDUcAdTaA0TTQ+74xmn8TJbfgykO3HdQ5IjoKoJM9TJ17Ss7p0jYEXoYpVSec+3D
	 7zMDw651g+PvJhauPaXh+0tY445aUwU59c5ErbhMmt0l5mGh842a8j8e4kRxYEljggPC9
	 e2yh1dPQ4H1V29QvZE0H/EZ/p0OjwYJqtgRCmF3OK/gq8hx1ED62anlu9rtRPKfL0TlnW
	 wIRC6aYgYXOBb2W7vNetIf68eneYdGEzEDV/O1LCNH8H7ZkfSCTg10Ytydjw/3zzA4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RBIMJCdx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.0
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010000.outbound.protection.outlook.com [52.103.33.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79126606A31C
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 16:13:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79126606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=RBIMJCdx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MyqUcSgDbM3O/nZt258jy2aprzpzTg3fMqmQM1H3+KcsB8nFM1A/c5PuHbJncqFRoEXP9eaRIl74wDlHDNXtHcCjox+hc4wp9AuNmanWTNShKR92bfivyRc/xGZlP8QaOz/ofCu80NogUr5IWecUlan5QjaH40oFIssxjbtpkLvfkR6rFIPQEr0kGeo9OYozxMOzLvuWHFeyvEEJqVpUC8ZVXuXosSjvVcCHbDWFrURtlSWNphhcU1zOjLEuQOTckPVXe9B9LO8FRIz74uxyONAyE1wypm51rAGzBEuajMmG8jKj1NLJqn3a8k0TFnUPybvkrOTENNgirTzj6Gle7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvHCEldxhDro/NPwmC30xrnnAoLNsESHOYD0dqg2b9A=;
 b=XUeh+hxgy72g6Ii1mKmDZCBW9wdkqHRFUm6sZiJKR7vu6xwxX77TutaHTSwkm8e4CN+OyPEO7ChEKyzFRyMW2fgP8JB9p12wF3ny8jGeDqD5VTc7Ghzh6tU2eaUstj7aAqseAYYJouxFHgJUF7j9GwDwR1O33rn5GZUZe+IAHgHR99DHYvF8HaQegDBhHXAfEM7dZgkWDELpC9+RaHW77VzD2N3xpErp7ND+Luaucst91NUt3YYaW2DWDzd5ibfXk//s3T3t06SbV/x4675t9SjpHNRZLRwGnBKFGiNY4kIqCZ+5ZtPXjYOxIncNeUvRGwhGp5RkrYjRT5CfA2Fq2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hvHCEldxhDro/NPwmC30xrnnAoLNsESHOYD0dqg2b9A=;
 b=RBIMJCdxTh2N6FwCYGwKbNd3mOPzG4FwOHwvwgdxf0VtvnEP4f3Fq5amGnhjhmJJk9naAIcHPO/5f4Hftz/RkIEJNei26ter6B0mZK8v2LASqP2ZjErdKwVdnUNwOSoXw/0G0JUR2EhAwRSwer10vtRVrPDhKyDSUbE8EPnPWEopTwzRheQe1G9gC84T0cyMZIjcEzujs/lVarZhnoFqpwN09ryDegok8uv/gYMd6XGIP43DKEA9xTNKOsrckEjFIFzAPbldGAzdoxoo+OvIz+500N7fq8LZRCiJtCOkkuIUHUH3aNvJQ4vyvC7qJlOe1oMkjWiXd6JVnGT+bhjUkA==
Received: from PA1P189MB3532.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:506::19)
 by DB9P189MB2050.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:392::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sun, 8 Nov 2026
 16:13:49 +0000
Received: from PA1P189MB3532.EURP189.PROD.OUTLOOK.COM
 ([fe80::e54b:8f7f:cd27:1e32]) by PA1P189MB3532.EURP189.PROD.OUTLOOK.COM
 ([fe80::e54b:8f7f:cd27:1e32%4]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 16:13:49 +0000
From: Iulian Costache <iuli.costache@outlook.com>
To: Marc <1marc1@gmail.com>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>
CC: "smfrench@gmail.com" <smfrench@gmail.com>, "pc@manguebit.com"
	<pc@manguebit.com>
Subject: RE: Follow up on: Issue with kernel 6.8.0-40-generic?
Thread-Topic: Follow up on: Issue with kernel 6.8.0-40-generic?
Thread-Index: AQGi8km5l+jjtL9VEIHJ9ejp57CeELeZUXmw
Date: Sun, 8 Nov 2026 16:13:49 +0000
Message-ID:
 <PA1P189MB35328A18CC3BCA87F9346B69EF742@PA1P189MB3532.EURP189.PROD.OUTLOOK.COM>
References:
 <CAMHwNVuy2+EjMNFJAvMKACwpuSQ5kry25q5y5c1j4u2=Rc29ng@mail.gmail.com>
In-Reply-To:
 <CAMHwNVuy2+EjMNFJAvMKACwpuSQ5kry25q5y5c1j4u2=Rc29ng@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA1P189MB3532:EE_|DB9P189MB2050:EE_
x-ms-office365-filtering-correlation-id: eee25ef2-91af-4d38-cc70-08df3db34609
x-microsoft-antispam:
 BCL:0;ARA:14566002|22141099003|39105399006|15080799012|37011999003|19110799012|8060799015|31061999003|8062599012|12121999013|24021099003|13091999003|25010399006|4140399003|4302099013|3412199025|440099028|102099032|10035399007|1602099012|40105399003|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?ak9hQ2xyQmZJZGhZM0gwZUlvZWtPQjVkR215bWpEaUtYM0sxSG9aNkJzZWd5?=
 =?utf-8?B?WkJpOVlEZWRFUmJKUVV6cldOSEhyaVRzUVMvN3lwNENVeGVvRE9YUUREZUFF?=
 =?utf-8?B?RHZxNlExalNuQzNTZHdlODQyMFdKK25ReE56NVo4YWlXZVpvNW9JQkZEMWhO?=
 =?utf-8?B?Slk3T3ZMN2taMGhydndoRWRxVXljTTk2a2t0bU5UNDIxMFJLQ0t1eVcxUTBi?=
 =?utf-8?B?M3AvOExIeDlUd3d2aHdwMkJUN3FKUTdvazFQb3ZhYjVYNHhmUUordnJobDNp?=
 =?utf-8?B?MWZGUmh1VjQ2Y2NqcW8xTkIwYWVLeDdxeDlFb2FLdVFWV1hHejR1NmtGRitu?=
 =?utf-8?B?VVkxcGFMM29KK0I1TnJzYmsxNjhPazlEQVZNMjVxTXBWemFOUXkzTG4zODlx?=
 =?utf-8?B?Rk1ZTlJTa05mRG02eEc0WFJpd29uTmVPQWZ3cWxtTzZGZFRpR0syRndPQ1dD?=
 =?utf-8?B?SkhlWFJ2NXlJangzWmc1WGJ1ay9Fb3lVYk4ybXJFVFVKUjM2Lzh1NCtRTkd6?=
 =?utf-8?B?L2NPbGZ2YlA3M1ZGZVAxRmV4Mi9TTnMxbkVpYlJZcTJlZnlQZnRSR0hETFZu?=
 =?utf-8?B?WWxhNkZEejNOQ21zazZ3SGU3YlRVNE5VeUFVZVB1bEE1dHpsUVlKc0JUMW1U?=
 =?utf-8?B?QURleHV5VmVNZmhOUy95MmMxWCtWd1FkWkZiSlhUUHZGQ0kwejh3UFlsMGtP?=
 =?utf-8?B?WWkxcWpWd0o5TVdlSHlKN0h1N2I1a1E3M2dKUHRYT0VvNXY5Nnovb21COTZO?=
 =?utf-8?B?UWxucFR6WkFoRUhvSE9LT29meGZYK1JwQkxGOWFUN2dWbUVIbnhnT0NMZytu?=
 =?utf-8?B?NVliU1I4TXRQcVRIaDRyRkVjdFQ3NFRGY21pdWp1MUFFZ1RLVy9LWjcreE8x?=
 =?utf-8?B?Z1VpQzVyNmQydDhBUmYveFdXb1VDT2ZzRUd5a3NLMHlEVGhyVHBPbFBVQnBl?=
 =?utf-8?B?TEViUkl4dGVicUFHMzVRaU9EQWFVODg1bVB5M0JMM2FYTUZuZDF1VFQ2Qjdo?=
 =?utf-8?B?a3VhUUQwTmpPQkZtbC82Q3VscWxTa1lTWUFtTEl3cVdoZEtmUURqWm5GSXdT?=
 =?utf-8?B?VFV0THh3M25IbXdCeTU1ZkM4UmthYi9DZ1VyQ2VoNUVBL2JhQWxPOElFRXJ0?=
 =?utf-8?B?blRWQ1ZVOHF4T0RLb0kzZEx6ZXRmaUJQSzdMNzZCYjNDOHpFWFJ4cnlaTGto?=
 =?utf-8?B?Y2lKSHpSNFM2UXppVnNXS0ZiUmZ1MUwyQnF4MzJxekpzaWcrSlZsdUMxNkhN?=
 =?utf-8?B?eGZGWHRJVkJoU2Z1Zk1RSGRpUklvZ2hSNHo3a0RIdDhTR2NiejFpT3JkMjJS?=
 =?utf-8?B?RXhra1JHQi8rbURUN0x3S3M4cDdZeVlKL3gya28wMnp1Qk9vZGxqWDRoY3E1?=
 =?utf-8?B?TUorbUdYa2JXN2NTZk5YT1RIWUxJVWNWSjVVbnNNUjRSRUxiUlNpNjRQeUlQ?=
 =?utf-8?B?amg1MnlFWHdPdFY5U21hTEFuWVFiZlJSWEgzcUpSbmtJaE03cWpzU0s0U2pG?=
 =?utf-8?Q?PJKtOkGodI2qzJEnLmAXRbQGSVW?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YnJSL3RLT09MckRITkFWMmsrOEkrUzZHMDRMTHY2aER3T28va0d0cWVhMXZq?=
 =?utf-8?B?YVphdTVlZEgvcjhYMFBLZFZZTGpWL3MzRnhkckZjUlBLRkRMYXdqd0xMMVVO?=
 =?utf-8?B?eUVMQWU0YzMvTXY2VUI3dmR5c1FoYk40SnJJeHF1WmdIeXV0SFp1Wkw5MTJl?=
 =?utf-8?B?elZZSENiUlFDWnpWcUo4eHNIaWREZmNQeWFQWkZ2Y25GSGR0bXlra1o2bElx?=
 =?utf-8?B?Y08yYTZvMmJDb2ZEcXlrYU1wNnV4WDFnQ2txN1pTQjljcitoOWxCQ3VVMVY2?=
 =?utf-8?B?MTBGem5wOUozd2RKb3ZsZm1HSFpjOW91NEZyVEs4MUdzSUdIUG9ybDFGNC9O?=
 =?utf-8?B?NmpDRjhCMi9USnlTeGJwMTB4bnNaeGxFaTFYdE5pRHMwVTFnSUJyMXh6NzNQ?=
 =?utf-8?B?QzdEUVZvaXZhOVNEV2xLM3Q4ZlRkWVJiM2c0L1pyTlBnTWplSEcrdXFtVm9B?=
 =?utf-8?B?Z01JMkRiL0N4SHhJbWJuOGdKRWx1M0NORFVWaWFJaVJDeUZWNHIyQUU0cnhB?=
 =?utf-8?B?bGdxdkFpK08wa0V2azl2NFR5R2hyVUtjdUgzZEszRjR6Z21jMUNsVWt2bGIr?=
 =?utf-8?B?TXNHUXFrWXUxNks3RXdUQiswMVpNVzNKaGpxYVFwbzh2ZjZSUVlTaDVMR2dy?=
 =?utf-8?B?TUtIaXJsZ0VndEwwc3hMMGhGWnNDOERsanlZZUR0RTkwOXU5ejlQYnBCODVQ?=
 =?utf-8?B?aTNETzJnWGdBaVhhNDhUSDl2Z21ZVGU2QTZtMEpMV2hxR3hwK1U2RW5pcksv?=
 =?utf-8?B?enozKy93bW5BUkNpeWtLTmxIVCs5MGMxZzJvM0pJZDlLZ0dIaS84aWhEMEtJ?=
 =?utf-8?B?Tkg0OW5PZ2Y1aDdVT2xqZUZEdzZtdUNCT1NUeWNFbVhiV0RNSGhXbWNiNlFO?=
 =?utf-8?B?Q0VRMmh2eTdZcEI5ZGdrS0hBYzhQem4rYWNrUEdmNXFrQUZDMEFKQmVIcXpX?=
 =?utf-8?B?T3dpOE1aTG5vMVBCeW54Y0txR0Q4Ulo1UDdNTk9BbzRnRjRBL0VTN0hheWs4?=
 =?utf-8?B?WTVpMGprYjRSZlpSeEhwTkdtL3BNbncraUs3ZjEzOHpuTmR0Y1h1NEIxRU5W?=
 =?utf-8?B?SlNBd3R1cWJBWHk5d05sMmhBQkFEUzZPaVprSHkyQ1gxV3hhbmVvaW5wR3VG?=
 =?utf-8?B?UjlTWDF2eVBoZXE3SzFGY3ZYOWNYV0dHc2JGZGgzZUNrUThuMlJSNmo4ZVhB?=
 =?utf-8?B?L1hFd2FoQU1pY3prZlMwK1djRWZLVlkzVDJiM1RseEdLQWQ4UlFWRHhPeEdZ?=
 =?utf-8?B?T3J6dGdzdEY4L0FyWnlkbWdtK1haS1pTSVh5YXY1WWJtZWFpbUdRN0tWQVE1?=
 =?utf-8?B?dWtFOWFyK2ZRSk5aSlVOaDVGQnh3RjZMbVNGTFpFQzJ1TXo3OFlqSXpUYnpj?=
 =?utf-8?B?NmpuS0k4STRrTWYzTmNKeUsrR2VDVVdpS2swZkRvSDd3T3ZvTjR1bGRUK2Ev?=
 =?utf-8?B?Y3RKWGNIdldpVjJOZ050bTVIY2w4bnRGaUtaei9jRnVDcmJ1VzdYdVVHMXBK?=
 =?utf-8?B?c1F1cER1RWhRTXpyY2RRdlo0L3BIVmV6akxrM2JRTERxV25HZkQwcFhRRTlK?=
 =?utf-8?B?VURuRDMrcVBTajNDSm5xMUMzVzB0U3lvQ2Y4MVJKc1gyUnZjOFNZa3hyVnRk?=
 =?utf-8?B?SGFVaDJMZUY5REI3SGhMYk9NTktJdER0U0xxZElJTUYyZTBhY0ZDV3U3TllZ?=
 =?utf-8?B?ejNHV0VWem8yRGl6RkQ1OFJSYURBaVhoaGZZczROREpaRTBvUFcyUmp2NkEy?=
 =?utf-8?B?SkdNSHJUVGdjcE1OUE02TjNHMThQdVRUNEkyTlNBTWtNdHVYVmpndGNBZnhS?=
 =?utf-8?B?K2t3STBoQTN1dVpBQVluMDRRK2NzN1dVbDVjMU5IampQaDhqd1hRV1l0Y1hk?=
 =?utf-8?Q?w3fSHiB+C8fxH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA1P189MB3532.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: eee25ef2-91af-4d38-cc70-08df3db34609
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2026 16:13:49.3279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P189MB2050

SGVsbG8sDQoNCk9uIGEgV2luZG93cyAxMSBTTUIgc2hhcmUsIGV2ZXJ5IGZpbGUgbWFuYWdlZCBi
eSBPbmVEcml2ZSAoY2xvdWQtZmlsZXMNCnJlcGFyc2UgdGFnIDB4OTAwMDYwMWEsIElPX1JFUEFS
U0VfVEFHX0NMT1VEXzYpIGZhaWxzIHdpdGggRVNUQUxFIGFzDQpzb29uIGFzIHRoZSBjbGllbnQg
cmV2YWxpZGF0ZXMgaXQuIFNlcXVlbnRpYWwgcmVhZHMgKGNwLCBjYXQpIHdvcmssIGJ1dA0KbHNl
ZWsoZmQsIDAsIFNFRUtfRU5EKSBmYWlscy4gQXMgYSByZXN1bHQsIGFwcGxpY2F0aW9ucyB0aGF0
IGNoZWNrIHRoZQ0KZmlsZSBzaXplIHRoaXMgd2F5IChmb3IgZXhhbXBsZSBPa3VsYXIpIGNhbm5v
dCBvcGVuIHRoZXNlIGZpbGVzLiBQbGFpbg0KZmlsZXMgb24gdGhlIHNhbWUgc2VydmVyLCBpbiBh
IHNoYXJlIHdpdGhvdXQgT25lRHJpdmUsIHdvcmsgbm9ybWFsbHkuDQoNClRoaXMgbG9va3MgbGlr
ZSB0aGUgcHJvYmxlbSBpbiBNYXJjJ3MgcmVwb3J0IGFib3ZlIChKdW5lIGFuZCBKdWx5IDIwMjUs
DQpubyByZXBseSBzbyBmYXIpOiBzaW5jZSBrZXJuZWwgNi44LCBQREZzIG9uIGEgT25lRHJpdmUg
c2hhcmUgZmFpbCB0bw0Kb3Blbiwgd2hpbGUgdGV4dCBmaWxlcyBhbmQgc3ByZWFkc2hlZXRzIHdv
cmsuDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jaWZzL0NBTUh3TlZ1K05LPVhpeEN3
b1NWSzZRT3EzSD1tPU1MNGtfYVhZczJtRENHd05NUmVHUUBtYWlsLmdtYWlsLmNvbS8NCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNpZnMvQ0FNSHdOVnV5MitFak1ORkpBdk1LQUN3cHVT
UTVrcnkyNXE1eTVjMWo0dTI9UmMyOW5nQG1haWwuZ21haWwuY29tLw0KUERGIHJlYWRlcnMgc2Vl
ayB0byB0aGUgZW5kIG9mIHRoZSBmaWxlIGZpcnN0LCB3aGljaCB3b3VsZCBleHBsYWluIHdoeQ0K
b25seSBQREZzIGFyZSBhZmZlY3RlZCBpbiBoaXMgY2FzZS4NCg0KRW52aXJvbm1lbnQNCi0gQ2xp
ZW50OiBGZWRvcmEgNDQsIGtlcm5lbCA3LjIuMTEtMjAwLmZjNDQueDg2XzY0DQotIFNlcnZlcjog
V2luZG93cyAxMSBQcm8sIGJ1aWxkIDI2MzAwLCBidWlsdC1pbiBTTUIgc2VydmVyOyBlbmNyeXB0
aW9uDQogIGFuZCBzaWduaW5nIHJlcXVpcmVkDQotIEZpbGVzOiBPbmVEcml2ZSBmaWxlcyBzZXQg
dG8gIkFsd2F5cyBrZWVwIG9uIHRoaXMgZGV2aWNlIiAoYXR0cmlidXRlcw0KICAweDgwNDIwOiBh
cmNoaXZlLCByZXBhcnNlIHBvaW50LCBwaW5uZWQpLCBmdWxseSBzeW5jZWQsIHNvIG5vDQogIGh5
ZHJhdGlvbiBpcyBpbnZvbHZlZA0KDQpNb3VudCBvcHRpb25zIChhcyByZXBvcnRlZCBieSBmaW5k
bW50KQ0KcncscmVsYXRpbWUsdmVycz0zLjEuMSxjYWNoZT1zdHJpY3QsdXBjYWxsX3RhcmdldD1h
cHAsdWlkPTEwMDAsDQpmb3JjZXVpZCxnaWQ9MTAwMCxmb3JjZWdpZCxmaWxlX21vZGU9MDc1NSxk
aXJfbW9kZT0wNzU1LHNlYWwsc29mdCwNCm5vdW5peCxzZXJ2ZXJpbm8sbWFwcG9zaXgsbm9wZXJt
LHJlcGFyc2U9bmZzLG5hdGl2ZXNvY2tldCwNCnN5bWxpbms9bmF0aXZlLHJzaXplPTQxOTQzMDQs
d3NpemU9NDE5NDMwNA0KDQpSZXByb2R1Y2VyDQpweXRob24zIC1jICdpbXBvcnQgc3lzDQpmPW9w
ZW4oc3lzLmFyZ3ZbMV0sInJiIikNCmYuc2VlaygwLDIpJyAvbW50L3NoYXJlL0Rlc2t0b3AvZmls
ZS5wZGYNCg0KUmVzdWx0OiBPU0Vycm9yOiBbRXJybm8gMTE2XSBTdGFsZSBmaWxlIGhhbmRsZQ0K
DQpzdHJhY2Ugb2YgT2t1bGFyIG9uIHRoZSBzYW1lIGZpbGU6DQpvcGVuYXQoQVRfRkRDV0QsICIu
Li4vZmlsZS5wZGYiLCBPX1JET05MWXxPX0NMT0VYRUMpID0gMzINCmZzdGF0KDMyLCB7c3RfbW9k
ZT1TX0lGUkVHfDA3NTUsIHN0X3NpemU9MTM5NzczLCAuLi59KSA9IDANCmxzZWVrKDMyLCAwLCBT
RUVLX0VORCkgPSAtMSBFU1RBTEUgKFN0YWxlIGZpbGUgaGFuZGxlKQ0KDQpXaGF0IEkgY2hlY2tl
ZA0KLSBTYW1lIHJlc3VsdCBvbiBhIGZyZXNoIG1vdW50LCBpbW1lZGlhdGVseSBhZnRlciBtb3Vu
dGluZywgc28gaXQgaXMNCiAgbm90IGNhY2hlIGFnaW5nLg0KLSBObyBjaGFuZ2Ugd2l0aCBub3Nl
cnZlcmlubywgY2FjaGU9bm9uZSwgYWN0aW1lbz0wLCBub2hhbmRsZWNhY2hlLA0KICB2ZXJzPTMu
MCBvciByZXBhcnNlPW5vbmUuDQotIEEgZmlsZSBuZXdseSB3cml0dGVuIHRvIHRoZSBzaGFyZSBm
cm9tIExpbnV4IG9wZW5zIGF0IGZpcnN0LCB0aGVuDQogIGZhaWxzIHRoZSBzYW1lIHdheSBvbmNl
IE9uZURyaXZlIGhhcyBjb252ZXJ0ZWQgaXQgdG8gYSBjbG91ZCBmaWxlDQogIChzYW1lIDB4OTAw
MDYwMWEgdGFnKS4NCi0gRmlsZXMgd2l0aG91dCBhIHJlcGFyc2UgcG9pbnQgb24gdGhlIHNhbWUg
c2VydmVyIHBhc3MgdGhlIHNhbWUgdGVzdC4NCi0gc3RhdCBhbmQgdGhlIGRpcmVjdG9yeSBsaXN0
aW5nIHJlcG9ydCB0aGUgc2FtZSBpbm9kZSBudW1iZXIsIGFuZCB0aGUNCiAgZmlsZSB0eXBlIGlz
IFNfSUZSRUcuDQotIE5vIFNFTGludXggZGVuaWFscywgYW5kIG5vdGhpbmcgbG9nZ2VkIGJ5IHRo
ZSBrZXJuZWwuDQoNClBvc3NpYmx5IHJlbGF0ZWQNCkluIEFwcmlsIDIwMjUgYSByZWdyZXNzaW9u
IHdpdGggT25lRHJpdmUgdGFnIDB4OTAwMDcwMWEgd2FzIGRpc2N1c3NlZA0Kb24gc2FtYmEtdGVj
aG5pY2FsICgiSXNzdWUgd2l0aCBrZXJuZWwgNi44LjAtNDAtZ2VuZXJpYz8iKToNCmh0dHBzOi8v
bGlzdHMuc2FtYmEub3JnL2FyY2hpdmUvc2FtYmEtdGVjaG5pY2FsLzIwMjUtQXByaWwvMTM5Mzc3
Lmh0bWwNClRoYXQgb25lIHByZXZlbnRlZCBtb3VudGluZyBhbHRvZ2V0aGVyLCB3aGlsZSBoZXJl
IHRoZSBtb3VudCB3b3JrcyBhbmQNCm9ubHkgcmV2YWxpZGF0aW9uIGZhaWxzLiBPbmUgZ3Vlc3Ms
IG5vdCB2ZXJpZmllZDogdGhlIGNsb3VkIHRhZ3MgaGF2ZQ0KdGhlICJkaXJlY3RvcnkiIGJpdCBz
ZXQgKDB4MTAwMDAwMDApLCBhbmQgcmV2YWxpZGF0aW9uIG1heSBjb25jbHVkZQ0KdGhhdCB0aGUg
aW5vZGUgdHlwZSBoYXMgY2hhbmdlZC4NCg0KSSBoYXZlbid0IHRlc3RlZCBhbiBvbGRlciBrZXJu
ZWwuIEknbSBoYXBweSB0byBydW4gZnVydGhlciB0ZXN0cyBvcg0KY29sbGVjdCBkZWJ1ZyBvdXRw
dXQgaWYgeW91IHRlbGwgbWUgd2hhdCBpcyB1c2VmdWwuDQoNCktpbmQgcmVnYXJkcywNCg0KSXVs
aWFuIENvc3RhY2hlDQo=
