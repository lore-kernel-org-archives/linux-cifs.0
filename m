Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3040CEB64DA
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jul 2023 03:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbjGFDYu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jul 2023 23:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGFDYs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jul 2023 23:24:48 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2098.outbound.protection.outlook.com [40.107.215.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AAC1BC3;
        Wed,  5 Jul 2023 20:24:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYMFvmApMSv3bO0Ym7VtePHJ3h9yHEDKA5k6KCMPHHHRkKvhaqQh7WlU/BntAO1RCOZrToR3PIU3nitOI2sWQSiYLdqn3Ft4Wfu9oAjBnhxkF4EDPI0LzwBkxTOYIHwYCUEMFk56kG2D2nK31aFFFmuFKe548BSHOnNr2nlDLa3SHIETiiqdrsKcC2iGnN3hYP5UjgMMe6+lji2F8RHiMgCRfBofQOj2YutOMgpXPWuB2Osb/zM6UHBQbjg+GVO2XExAMc9xlRmboMe0lGyDZIMiEHQ4PwR/4p0X/LLb/0Ty3gG2qzqEl/+jkzrRA7N0tN2fsPFGF1Sp6ybGc+P1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vu0CC5kzjecOkDIXP8QQIK2XxJEbDQMQq8blfLk7T3w=;
 b=ZLgPnvotJESx8YyndUslx2G8GhwfMCfY0gOAm2jVWfAHe4DMXM2wCQvukOmMd8pQm8M/uwjsbp06O5+7qjAp1ZytyiGpkSH1mBhppOkxH7tWnvddOTYtN0aPELQoGXeftAa43gMpMDUDG7W77a6unw7SoB6VFvNk2JzkJe63O/wvPNaHW5ryaudxVfhIWsZTCaG1ArGcyBRyojRqGnqfwulGSSPsFdZJFEVkMp9fhtepR/Sz7fbfNQtunyWTlpeOZ+nRQvclvI5HKj3MIGCWdBdi115trEPlQ2u3Wd7v+oNqhdZ9qP/Y1HzOD5+lhNLZwFTEg6cxR2+VvUp3ktuvOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vu0CC5kzjecOkDIXP8QQIK2XxJEbDQMQq8blfLk7T3w=;
 b=jJ8cgEROHYCP/VDgh22wWRMzAgr/FAbBkCCsY3XUz6LadO33nP8czDeTl9f7HMPWJn1VmbBLRXhvepZ10H4eAXtBU+q44yTapeZr6vUc1khpwEAJfvc2OENPPlP704KZyoVLu+91EMkxUcivV2otD2fRvpyV6Wlwg+HCMYcAAZvU4NeBFyK2OKCunLqe1JtMXT1C3UYBgucSraPGiOxiKJNBEQjgSJRafC62I/p6J3CWQsFWb3YzhPXjZopAWAnuY1B6w+t4LXCw2Fi6PkhAkdl10cPELcNjRpnOuYSlnSFHlA9sSs4a9Si3EBrsLRvCgotjgRchsFnSxkrgACtnoQ==
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 SG2PR06MB5408.apcprd06.prod.outlook.com (2603:1096:4:1dc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.17; Thu, 6 Jul 2023 03:24:42 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::2a86:a42:b60a:470c]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::2a86:a42:b60a:470c%4]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 03:24:42 +0000
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
Thread-Index: AQHZr3G1DBZTmDC5c0S4NmhPGriTd6+sEtJA
Date:   Thu, 6 Jul 2023 03:24:42 +0000
Message-ID: <SG2PR06MB374370ED43D5CAB3BAC83436BD2CA@SG2PR06MB3743.apcprd06.prod.outlook.com>
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
x-ms-traffictypediagnostic: SG2PR06MB3743:EE_|SG2PR06MB5408:EE_
x-ms-office365-filtering-correlation-id: 54805f76-8e1b-4732-9fca-08db7dd08a13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xy5vk+OMUEkdGWtTM5kdhgofRc58/RW989vHD+NnCAKZ7nJKBFmsM1oSnkihkIh8kthXYZL+lFGZYohhHpNuu23nQmY+VHXc/ZB35JZAyiQCQdzn5yJy39GyicD9IgvB2CDrPtz4cPJiLfhF97xtQq/pbk8N0ZFlzWYGYE0hkbfSpHZlIafvXUdR8Ka5uFTIhjQeeYX/buQY93EHwXMEkR04OzJlp+6Mn8yMLZVa7JABDcClRva2aZou3fYpqQL7srKHXtHJKw5e8hOM/P56mvJDZBz8NBsNWwnAlvaTFGhKFKAnvqvk0p+5jNtsVBL6x2p7a9tgc/q9/nSIPCXZgw3fyq1sdtiFoSFOJwjq0PoRvic+92iXvtkW/6ftFpwEsAt+HtZxVVI60OwnqpiHnsRsNY4wywqyF6lgsgP1vDPOfQD0ZASRcWLaChHX28ZhwWU6A8I0t4zVAn/51PNSegBQghkacmWQtU7O7tkBiCMYJmuuJ++jSX7LSfohYK8wV8S4U0eX9i98c+W5VpYEVjD6pmobpVtP0eKwAzMr7GJ972u5NjWGb0kywOGkkDusrsZrimeFhbyQG+X1ualNiyc5O/d9jyPEC/cbcpebfZQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(66946007)(8936002)(66556008)(5660300002)(55016003)(86362001)(38070700005)(41300700001)(316002)(85182001)(66446008)(76116006)(64756008)(66476007)(4326008)(224303003)(6916009)(9686003)(33656002)(966005)(186003)(26005)(6506007)(54906003)(7696005)(71200400001)(478600001)(38100700002)(122000001)(4744005)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vy9QQWdtK2VmUjcyVXpYQ1BGNDM4SzJxTzE5S1lXK0ppeFYzOFlvdWVFVGJa?=
 =?utf-8?B?S3VNcmJLS3BmMUpDZ1N5VWhHd0pDNm1CUEVqLzQzYk53ZldNMHBIaGNNQmIw?=
 =?utf-8?B?YjZWak54aHhncUJPSXluRnVPSzlFbVpLQjE2cHJIUFpDMGtNbXpWajV3TXdD?=
 =?utf-8?B?TmFHMnNzclRxN0hCK3R6czdKSTNrK3FodmR3VEVEV1BoWHU2REVxcGY2OUNt?=
 =?utf-8?B?UmZoRzNvcEh5eG9wNTFOUmw4d1BNbGRlczhNbzdOOUdQellVVjQrN2Z5MUJp?=
 =?utf-8?B?K2RvOWphWWpVR2FFRDJjMmFCYjNOdHl4ZE9UL1RmbGhPcC9WU3NhcmF1SGVp?=
 =?utf-8?B?Y0lpU2pqUUxFYlZjaUFERDBpSEF5SDR1RnRtaWtwRHVNaGtVaFNTRkJqTlNW?=
 =?utf-8?B?RjlYTzRUd1d0Wk5pWFVTdDRDcURTRDhxK2pIZFNLVWhzbUZkSklobFdINXVa?=
 =?utf-8?B?czhWRVE3c3RyNS8wMGhvcUhEeFVyK2VjT2FndHdZMUQ2aEpjZGd0RUFTNXl6?=
 =?utf-8?B?YnJTSlJ6UEExMERtWXF4QjU5bnk4L2ttUzJneEpzd0JDamJuWmJoR3RGbEFl?=
 =?utf-8?B?Z0xWbWQ3OUtuWUk3bFlnU0hJSkJId1h5Y2ovUWpuZGdVRXU4UVFJMFowbmJw?=
 =?utf-8?B?N3Q0ZlEvdDNPUi90TFNNK09iWUlFdTErY2xkVGc0ZjA5bXo3bXRTZStrS0pH?=
 =?utf-8?B?YjRIa1h6VkRUY3JsUXhYV2RZUjNPaisvUFUxNDlpYnZsT1kzcGE3cDl1d3R5?=
 =?utf-8?B?ZDlHMUJjSklKNjFaSjhwaTJwWXh1aURPTERBQmRhalVKRS9GdE1QQ3liVkRj?=
 =?utf-8?B?LzhTdWxBZ3dvODlDY3J3bjZJNThDd1o4R2tyZVM2cUdQRk4rNWcrOWhNSUJ2?=
 =?utf-8?B?SmJsTU4vaUJsWThub0RzcFI1TFkxTTMzMXluajFtN1AyTzZOSHZPbThuYTZW?=
 =?utf-8?B?SER0ZEdjVGhHYW9wWlhUMkVxOCtVYlNjaGpDNWJ3TFY2bU81Szg0UzBDYk9U?=
 =?utf-8?B?WGp2QUQzcm04WGFoZlZEaVE2VlNSb2szWTlMc1NQR1huR3hlSUplcGFtUlA5?=
 =?utf-8?B?dm94Qlh6OFVENytLNk5oYjhHNmFpdW1CTlJuSUVmeE80NkNPOEZkOElVNFJp?=
 =?utf-8?B?ZGI4OHNzVGh4czczaFNlOWlpRzR2ZmpzdXVqTkJVQWlwcEtmdjE4QkdvNlFm?=
 =?utf-8?B?K3E4dmxuS0NaMHdTV3FBZzkveDJKSUF2STlSRGhnMTFyWkIwR3pXZDh4c2ZQ?=
 =?utf-8?B?SGF1c2pKOVBtQTQ2ZGgwaHFIK0g5WGpCQXFQWEdxcUw5RXYyYVBqUDlRK2U3?=
 =?utf-8?B?b0V0Zm96ekh2di9MeThnWHhPM0x1TVc1NHRKOXRwbnFiWTZnRmZ4TXBmdGhv?=
 =?utf-8?B?a3Jad2ZSOGxhTlF6WmpkTzJiVExzdVc1cVpMc3pvclR3cy9pVE1Oako3YkJD?=
 =?utf-8?B?VlhJeStObVZkSFNJeFdqZy9rU2ZpN2ZrTGdqcjhYVGYwWGYrUFJPTVBNdm1R?=
 =?utf-8?B?M3Fha0IzN2gvM0JtSGdvUzdhNXpqK1JqY05nancxdXJqYVoxdEhqZWpqQlBw?=
 =?utf-8?B?UEg3dXBWRUFtR3NDTC9KRUhMaHBmSFRQdnNDNE9makNYSFdEM0V1R081QUNZ?=
 =?utf-8?B?MWNvTjM4am9hd2VxS0RVdG5pQVhSRmF3aStXQjltUmpkT014TjBQQzQyNER3?=
 =?utf-8?B?NjJXM3hObENRd3YzeXVrdXR3Mk5LM3hBNi90VTcxK09OQUdQcnZYTmZ1MEp2?=
 =?utf-8?B?SHZVQklzOE01VXA3NnNkb1FDblcwaHM0TkZvM0ZUTlo4d2FPYWJkb2RuaHM1?=
 =?utf-8?B?V2tYcEZCVXVZSFlLTXE4N0x3a3dUbkZET2ZTdVQ0NW4yYS9SS1ZJVHJDUDRn?=
 =?utf-8?B?YmhRYm0vZ0gza1VFdmc2NW5IRVY2a05YZ3ZIQTI4b1Y4ZzNjZnhRZndwRHc5?=
 =?utf-8?B?T3FobDNPRTFOQTZYWG1WNEZSODIwQXpJTWFHWHYraldYRUk1MmFEU2xrNDNp?=
 =?utf-8?B?OVhmMzR3VDloVytiZGpUSE54VVlqYllmSzVtOG01ZzVKUmNaai96QmYzaXND?=
 =?utf-8?B?TWFBN0ROcnVaekhNNE1YM2NDTnYrOFZ3L3l3VmRncDZidHNkN2VsMWg0Q0pN?=
 =?utf-8?Q?8Amc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54805f76-8e1b-4732-9fca-08db7dd08a13
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2023 03:24:42.6246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cQIDtGCs8HclprFtz9q9AX8N5PqEnOlmflek6+YOnsqtN5kbEM04U0T5b/FmXW5C/RCuLEgfR8VhArhjlT2UvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB5408
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGksIE1hcmt1cw0KSSBhbHJlYWR5IHN1Ym1pdHRlZCB0aGUgbmV3IHZlcnNpb24uIEl0IGhhcyBi
ZWVuIHJldmlld2VkIGJ5IE5hbWphZSBKZW9uLg0KVGhhbmsgeW91LiA6KQ0KaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYWxsLzIwMjMwNzA0MDc0MDU3LjExNjItMS1tYWNoZWxAdml2by5jb20vDQoN
Ci0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogTWFya3VzIEVsZnJpbmcgPE1hcmt1
cy5FbGZyaW5nQHdlYi5kZT4gDQrlj5HpgIHml7bpl7Q6IDIwMjPlubQ35pyINuaXpSAyOjUxDQrm
lLbku7bkuro6IOeOi+aYji3ova/ku7blupXlsYLmioDmnK/pg6ggPG1hY2hlbEB2aXZvLmNvbT47
IGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnOyBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwu
b3JnOyBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPjsgU2VyZ2V5IFNlbm96aGF0
c2t5IDxzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc+OyBTdGV2ZSBGcmVuY2ggPHNmcmVuY2hAc2Ft
YmEub3JnPjsgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+DQrmioTpgIE6IG9wZW5zb3VyY2Uu
a2VybmVsIDxvcGVuc291cmNlLmtlcm5lbEB2aXZvLmNvbT47IExLTUwgPGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc+DQrkuLvpopg6IFJlOiBbUEFUQ0hdIGZzOiBzbWI6IEZpeCB1bnNpZ25l
ZCBleHByZXNzaW9uIGNvbXBhcmVkIHdpdGggemVybyBpbiBrc21iZF92ZnNfc3RyZWFtX3dyaXRl
KCkNCg0KPiBUaGUgcmV0dXJuIHZhbHVlIG9mIHRoZSBrc21iZF92ZnNfZ2V0Y2FzZXhhdHRyKCkg
aXMgbG9uZy4NCg0KVGhlIGZ1bmN0aW9uIOKAnGtzbWJkX3Zmc19nZXRjYXNleGF0dHLigJ0gaXMg
ZGVmaW5lZCB3aXRoIHRoZSByZXR1cm4gdHlwZSDigJxsb25n4oCdLg0KDQoNCj4gSG93ZXZlciwg
dGhlIHJldHVybiB2YWx1ZSBpcyBiZWluZyBhc3NpZ25lZCB0byBhbiB1bnNpZ25lZiBsb25nIA0K
PiB2YXJpYWJsZSAndl9sZW4nLHNvIG1ha2luZyAndl9sZW4nIHRvIGxvbmcuIOKApg0KDQpQbGVh
c2UgYXZvaWQgZnVydGhlciB0eXBvcyBmb3IgYW4gaW1wcm92ZWQgY2hhbmdlIGRlc2NyaXB0aW9u
Lg0KDQpSZWdhcmRzLA0KTWFya3VzDQo=
