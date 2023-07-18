Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC494EB64DA
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jul 2023 07:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjGRHOF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jul 2023 03:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjGRHOE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jul 2023 03:14:04 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818B110B
        for <linux-cifs@vger.kernel.org>; Tue, 18 Jul 2023 00:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1689664443;
  x=1721200443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4fH2X3E2opHtHnPK6sCj56lP5gsUaLZMyy6uCJIB2S0=;
  b=EpVeZVHxyf9ODeGV7dPcdHKPmKm5UScV1/rFiFegJlF5ltywz+0PSmEH
   cF5M1nH1iZl8MseY9tUPf39Y4DB+9sEd9ARAWl12Krv2rUQQESuEXO0tH
   eIxZI3uvvuplaik4UmimpriynIPmhjIpQKMBGhnKDjF7651zuwPAtUV2J
   Y5p7+8yItCUXGkHcE3h+HR6IX82nZw2BDowToMCs3QBEsE0nsJ4kczXSC
   qsKzG19Z7+K1iEZ+zLI3qRMJeuuIT8P+gg5p3SCOVjtPPtTVSje008brz
   hNtYyWa6CYVIUfmZFqS1F4hGNSRzTRKFzRUDDdlGrQFtTbiJ12CU22ntp
   A==;
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUg5pXSHQjVYyToUqu7Z+scy/tKgQgWRxs1BomCnH45MapTJeJrQuAmLG0oGp2U3GdKsGEdD3kWSYnteVVe65/HlJw/4ujvhX3SWN7vrvxUmDJ8DNkvIjp7k+mEiYmOFVvVZsMbhMgTV+5Pg2SA72N1H/ULwfIHO2GubifL54ATge2f9R4rF94Kfrd/FrwSpmcVNV5itWiaqUpBpyUT2SSPE6zNQrCHku1N4EjxLPu1q1luQuR2KeR3GajSkzxl/tOEaw2QzsUijizveResjagVdg8u7giVrvXNBtTMNzhdvSJkoWosjVV/tWVIZoO61dX17gKPoScqEF9RTtjyBpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fH2X3E2opHtHnPK6sCj56lP5gsUaLZMyy6uCJIB2S0=;
 b=fwCByAGvouNui1xyXTvkmnpFq/ePXxHjPIxI1txwCjzcRTCP+a3+K93vPazUcE7ys28zgOSJ7rSDzgLkdd2JUo1wb36MflVZdBPygaOUwRJJdOSAJm6RvvdP0dZafUMZO/Voqw55H/hdfY2CVhL0iqLVR7Xa90Af8rfEdXZli77DeuMXgZTYulJzJyKTg1WYfSkqAlSJHtWeifaZ5qIjsw+NhaIXBNeYCcKT3cs3VNHEW94AjUQ2dz/OZ69i6gTaMO2Sl7m9AMDMNANahjhsiyrtCdLX1BvPCamddn2FdIhK+r0TTn7/NYDIZA0otTJILjcWDLRBWMqfQhBArETbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axis.com; dmarc=pass action=none header.from=axis.com;
 dkim=pass header.d=axis.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=axis365.onmicrosoft.com; s=selector2-axis365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fH2X3E2opHtHnPK6sCj56lP5gsUaLZMyy6uCJIB2S0=;
 b=CBa+rqSTcBFzz49Syhr7Z7dEhUd3fmMPKj7vcEaoLXzqsI4ICJIUn5JQLG7yMEmVfhJPnHpbMVM0Mz69QvELxBY2gU0tgFSKorYIxivRDYHMY1RDY5jbJcmn1XclJO2jJGbujQk27YbXNPBndlxs+1ncdJvQJdrXvvZUZt9j7dE=
From:   Vincent Whitchurch <Vincent.Whitchurch@axis.com>
To:     "smfrench@gmail.com" <smfrench@gmail.com>,
        "nspmangalore@gmail.com" <nspmangalore@gmail.com>,
        "ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>,
        "pc@cjr.nz" <pc@cjr.nz>
CC:     "chenxiaosong2@huawei.com" <chenxiaosong2@huawei.com>,
        "zhangxiaoxu5@huawei.com" <zhangxiaoxu5@huawei.com>,
        "bharathsm.hsk@gmail.com" <bharathsm.hsk@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: KASAN use after free warning
Thread-Topic: KASAN use after free warning
Thread-Index: Adm5R2tqQibGEpnVLUq5cf3RCkQPGg==
Date:   Tue, 18 Jul 2023 07:13:58 +0000
Message-ID: <6eca1d34c32a368fff4f52b4d8a3bb1c5ea2445e.camel@axis.com>
References: <CANT5p=p31khjC08_bvZqsMdqDi1g8G1F_7CZGXH0YU2FC6+GKA@mail.gmail.com>
In-Reply-To: <CANT5p=p31khjC08_bvZqsMdqDi1g8G1F_7CZGXH0YU2FC6+GKA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1+deb11u1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axis.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAWPR02MB10280:EE_|AS8PR02MB6693:EE_
x-ms-office365-filtering-correlation-id: 89312f0e-b899-4e02-0836-08db875e8de8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4xnG7FWrdas/roWhiRA2iTnqG2ekMDufSKq3O9XLIkzuDxNNPKc45caxg1moM1EhAHcL2/pTZikNVC6vFfh8BuNPXLWHsch3112zjmcwfqabWOFYIizzMW5i+bdnTv0/gqv+rzrGWNaNfM4BYNDXY94t0bKLREcbaIKyV1jY0rAoyVi43ML76upR0uyN/tDNytbkjcAUs2vmIcAnRKTcgeLPD0aMBoXfADQcD00VCfU5fG28/0aLvecT0c+zrZkGYjNbvt7nertew0/YwPsJPT7DvlamM1/b7EwIzDoIoeCz9V1Py7QkonJsTMkjbfn3fHRP0FMGiXi81Crs/uftLACfL9MrsOiBoW6xorHehlK7sHwQyoAGwy2xvnUZIip/XRwSIwPlK8aChwflC2STioK8ewfAoEHOoieS7CcXGkIlZ8XQI3cylpSIbZoVmAdKaTWe1B2QFItFgSOV64ECEHY9A5KaLcsemaNYAg+F7OZUeXmZ1bpJMae/SRxgXkqDKmdBl1J90EFeVdAUUURn5ngR2zEhQ4e/mIUac9wlK8EpMMVoOBoHmafMDE1MKkNZjeAviU1tCtRXBQ69nOJMabsX/tcAUIuURVvas/F57ys=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR02MB10280.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199021)(83380400001)(66556008)(64756008)(66446008)(66946007)(2616005)(41300700001)(5660300002)(36756003)(86362001)(38070700005)(122000001)(8676002)(8936002)(38100700002)(6512007)(966005)(76116006)(316002)(6486002)(110136005)(54906003)(66476007)(71200400001)(4326008)(2906002)(478600001)(91956017)(45080400002)(186003)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aG9GOEY3N2lxOEpZYU5WTEJjQVF3eXNSK3lyNFVXSlNoaGc3YWRGanQzOTB0?=
 =?utf-8?B?cFdEOXZyeXl0OTc3K2YwTmtJbXpadTBrQmpiNENROEFFUW92VDNaTHVaZ1hz?=
 =?utf-8?B?ZlQzSDQrUzhZc0VlOStvTWNqVnU4MVA3THlFbCs0RU81ekhqQWswNGJ4dDV1?=
 =?utf-8?B?T3E0WGVFTmJXOUs1NGsyZ1hFUVlnVUQxcThKdno3TlJ3ZkMyV3ZHZ29hc0Fl?=
 =?utf-8?B?dEZkQ3ArM0lHREEzOXVZN2pwMUp0MXYwaGtONDUrcWJTSzFvM1h3b0d1ZVAr?=
 =?utf-8?B?c25kQWVVd2t5ZDY5NVdLZG1LZ3RNaDl5eTEwa3I3OFkvN3dUZkY2aHlWTG9M?=
 =?utf-8?B?OHJYTVFSZW83V1luT2dBVXdpZ29nRzl4czRFZUxhSERFNzRkN1ltTnhzdXN1?=
 =?utf-8?B?M0ZSc0xjK1ZsakZwUlhGR0RoS1lKWFFJSGlWdmtBZWlPMFNlZnVPaWhXQXdt?=
 =?utf-8?B?d0NxbjZZYklUVnAxbzFoSTRyVDVRZktjQU9OTUxLUTI3UlBEZFlSRXBWSVU4?=
 =?utf-8?B?aEV1aEp0ellMTjhIWEZvTUc2cVRKY2h4MzAxcVU3bS9BS2FPNkdHNWxWREpT?=
 =?utf-8?B?dTNhdW9ENFQ3S2MzemZCOW9FNG5RNVA5Z3QvMmpPY1ZsZlNhWit0ZjcxeHRH?=
 =?utf-8?B?OWJ4dlBMVzI3S25EVVZkaDA5ejhrT1pUT0tDSGJJWTlCb0pnR2VsQ0o2Q0dG?=
 =?utf-8?B?YVdmd2JQNW1xaHBhc2hNZmIrTVRMbjdEMjJyZzJxdEFGTFJLMzBNc2t2eGli?=
 =?utf-8?B?RHQrNkszUTlIN3h6NnU4Y1B6d1cwOGU2Q09COVhzVEFwVVdmWElKb3R3bjdF?=
 =?utf-8?B?R0JBOEQ2TkNLRm5FdlZoM01IMzN2aG9zOEZnaHF4elMxRWpwanc2UFNPY01C?=
 =?utf-8?B?NDh1ZDExZUZ0U3N0bzJPM1p6Ums5dHJod08xcEVjMDBaa1E5NUo2SVVkZjNQ?=
 =?utf-8?B?QTkrVk55YjloejZSdk1BVGdsNGhrb0FXNzR3c285U21iRlBwS3Npd2JYSURh?=
 =?utf-8?B?ampBRGkwRC9hOVQ0dHphS0REM2hEUTB5dTlnMWh6aFBVQ1k1QU52N3I2bWg4?=
 =?utf-8?B?SlBmaW1aUnRVVTRIZ3FxNG1HL252cEhJRG9FeXJPMjUvc0dxNGsyWUxIbkxF?=
 =?utf-8?B?QkhYVlhGK2NoMUlxS09adFJyZW5LNy9kRHdmemtka2JKc3hrU1lDOWh6UTBY?=
 =?utf-8?B?QjNpTmNvT2JnblAwUlFSUnlzNXpnTEJpV1RLUDcvREZlNE1MUjQrMno1RWZk?=
 =?utf-8?B?MVllVURxdXo0L1hCSk5jc09RaVVlMzNkUVhXanFyaXJ1VTFYMTRGckFOUWtY?=
 =?utf-8?B?MTZ6c0IydlI2d1BnZTFndE5LT0hHdFVQYnZmaUVYMjFLQ2hwWmhLVU13QU55?=
 =?utf-8?B?ZEFZcjdINzVGTTViRzFSOWNoUDBwSkpkNkM2ZUVKSStRcTVJN0tmdWZSYUYw?=
 =?utf-8?B?QVBONTVjVGFyWHlJOVJ4dzdNV0gyT2ZBUk9MNkw3dVdKRGZrZHEreWpxeS9Y?=
 =?utf-8?B?bng5Vkt4YWVsRkRxSnkyaHErUzNHc3dsVGZzRkhnRW9EUHhhN21SSzhMRk14?=
 =?utf-8?B?cFREd3JJQlBWK1ZRQk9BM0RHRzVIL1o3RU1PRzNDcEdnbWpUNm95MmsvWXlO?=
 =?utf-8?B?YUdpS3ZDb0dPSFVwbGlkbnFHSWx4M1R6T1dtVmw0bEd5U0JpWi91K3VxSjZ0?=
 =?utf-8?B?L3hPeWdUMkFJdGk0eDUya08vMEpLOGc0bGRCalliaUJzZkdwK3hXdk9DNlkx?=
 =?utf-8?B?aG1BKzFwZjdVWXlKVGx2alc5WnlocTFGZ1lnNmFkSzBZUUhjK3ZUZ3AxN004?=
 =?utf-8?B?Njhmb0RpQ1lrTi8xL2kvelhDVGpoRWQvRGlnSE5MSUlHaDYvRVJuQjh1bHNY?=
 =?utf-8?B?KzU5T2ZFQ0dUTExvcHRZc3RmL2w1QnRJQXo5VU9qaHdVd0YvSGlwVSsrd1ZE?=
 =?utf-8?B?RFBLTC94OHBIQ3NXbjg2NkhHM2tyQ1Y3SVgvZE1Oc3lsb284S2J2aWxRSngr?=
 =?utf-8?B?d3BuRFpkTjVhRUZpcWFFWjBKZm5tN3hCQnJCelovVEZKUHJiT1FYT0pWVFVa?=
 =?utf-8?B?R1VKeHVzSGRTZXlTb2hFMjgxV0J3MHZRQURsWEF6VjJWRUs2RVNML3NQUk9o?=
 =?utf-8?Q?BgL6WMQ4Fxabtwu7Mja4qfKEg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9D93465380D2E4EA007556E21A99686@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAWPR02MB10280.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89312f0e-b899-4e02-0836-08db875e8de8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2023 07:13:58.0330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 78703d3c-b907-432f-b066-88f7af9ca3af
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tUZRAK38cfu6i4No6GLIRcSoLPq3AIb/glb6apyd7VsqM2Ebpc/WVLG/L+zXP3/6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR02MB6693
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTI0IGF0IDE3OjAzICswNTMwLCBTaHlhbSBQcmFzYWQgTiB3cm90ZToN
Cj4gSSdtIHNlZWluZyB0aGlzIHVzZS1hZnRlci1mcmVlIGluIHRoZSBsYXRlc3QgbWFpbmxpbmUg
a2VybmVsLg0KPiBCdXQgSSBjYW5ub3QgbWFrZSBtdWNoIHNlbnNlIG91dCBvZiBpdC4NCj4gSXQg
Y29tcGxhaW5zIHRoYXQgdGhlIGJ1ZmZlciB3YXMgZnJlZWQgYmVmb3JlIGNpZnNkIGNvdWxkIGZp
bmlzaC4gSQ0KPiBjYW5ub3Qgc2VlIGhvdyB0aGF0IGNhbiBoYXBwZW4uDQo+IA0KPiBXb3JyaWVk
IGFib3V0IHRoaXMgYXMgd2UndmUgYmVlbiBzZWVpbmcgc29tZSBwb3NzaWJsZSBjb3JydXB0aW9u
cw0KPiBkdXJpbmcgc29tZSBpbnRlcm5hbCBzdHJlc3MgdGVzdGluZyBpbiBNaWNyb3NvZnQuIFRo
YXQncyB0aGUgcmVhc29uIEkNCj4gd2FzIHJ1bm5pbmcgYSBLQVNBTiBlbmFibGVkIGtlcm5lbC4N
Cj4gDQo+IEFueSBjbHVlcz8NCj4gDQo+IEJVRzogS0FTQU46IHNsYWItdXNlLWFmdGVyLWZyZWUg
aW4gc21iMl9pc19uZXR3b3JrX25hbWVfZGVsZXRlZCsweDJhLzB4MTgwIFtjaWZzXQ0KPiBSZWFk
IG9mIHNpemUgNCBhdCBhZGRyIGZmZmY4ODgxMTE2MzgwMDggYnkgdGFzayBjaWZzZC81NjM4MzMN
Cj4gDQo+IENQVTogMCBQSUQ6IDU2MzgzMyBDb21tOiBjaWZzZCBOb3QgdGFpbnRlZCA2LjQuMC1y
YzMtd2thc2FuICM1DQo+IEhhcmR3YXJlIG5hbWU6IE1pY3Jvc29mdCBDb3Jwb3JhdGlvbiBWaXJ0
dWFsIE1hY2hpbmUvVmlydHVhbCBNYWNoaW5lLCBCSU9TIDA5MDAwOCAxMi8wNy8yMDE4DQo+IENh
bGwgVHJhY2U6DQo+ICA8VEFTSz4NCj4gc21iMl9pc19uZXR3b3JrX25hbWVfZGVsZXRlZCsweDJh
LzB4MTgwIFtjaWZzXQ0KPiBjaWZzX2RlbXVsdGlwbGV4X3RocmVhZCsweGNmYy8weDE3YTAgW2Np
ZnNdDQoNClRoaXMgc3RhY2sgdHJhY2UgbG9va3MgdmVyeSBzaW1pbGFyIHRvIHRoZSBLQVNBTiBz
cGxhdCBhZGRyZXNzZWQgYnkgdGhpcw0KcGF0Y2ggc2V0IGZyb20gWmhhbmcgWGlhb3h1Og0KDQog
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY2lmcy8yMDIyMTExNjAzMTEzNi4zOTY3NTc5
LTItemhhbmd4aWFveHU1QGh1YXdlaS5jb20vDQoNClRoYXQgcGF0Y2ggc2V0IHJlY2VpdmVkIGEg
UmV2aWV3ZWQtYnkgZnJvbSBQYXVsbyBidXQgQUZBSUNTIGl0IHdhcyBuZXZlcg0KbWVyZ2VkPyAg
SXQgdW5mb3J0dW5hdGVseSBubyBsb25nZXIgYXBwbGllcyB0byBjdXJyZW50IG1haW5saW5lIHNp
bmNlDQp0aGUgZmlsZXMgaGF2ZSBtb3ZlZC4NCg==
