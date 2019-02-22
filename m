Return-Path: <SRS0=FePp=Q5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3ADC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 23:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D91A92075A
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 23:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="bR+reK0k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfBVXZL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Feb 2019 18:25:11 -0500
Received: from mail-eopbgr770137.outbound.protection.outlook.com ([40.107.77.137]:17568
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725774AbfBVXZL (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Feb 2019 18:25:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3Vc3S7wHjSaZqr2hAGwsdy+qpmQccafiLY3PWZcByM=;
 b=bR+reK0kOalGdVPrAUGYH7OsvMtMaqX635QEhekAoXuIJmOWWyVvXIJekeNBJt4dTlrhankFhw1r7NC0fJaTqLUGMwh6fjyGzvYi2Smlm57HON24ROvmhaR6ZB0eNBZYoPjX+nRYjz1t8Y+0EFdRka3jpKvM2w2T+NwFYYNQOTs=
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com (10.167.151.155) by
 SN4PR2101MB0878.namprd21.prod.outlook.com (10.167.151.159) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.0; Fri, 22 Feb 2019 23:25:08 +0000
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::bdda:b065:93f4:1f21]) by SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::bdda:b065:93f4:1f21%4]) with mapi id 15.20.1665.008; Fri, 22 Feb 2019
 23:25:08 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>
Subject: RE: Failure to reconnect after cluster failvoer
Thread-Topic: Failure to reconnect after cluster failvoer
Thread-Index: AQHUygaXWPirxP5U10SRwmEzoXVUbaXqe52AgAAM1GCAAYg/AIAAYqyg
Date:   Fri, 22 Feb 2019 23:25:07 +0000
Message-ID: <SN4PR2101MB0736EDA079C01725CBB1A339A07F0@SN4PR2101MB0736.namprd21.prod.outlook.com>
References: <70e91b0b-4bca-60ea-19cf-3df0f49d4e5a@citrix.com>
 <CAH2r5mvDFFMhwyKdEGhgb+5-+v2PyuAWpWN9drofXVvj3mQxYQ@mail.gmail.com>
 <SN4PR2101MB073663B8E9E7AC98A4D0C992A07E0@SN4PR2101MB0736.namprd21.prod.outlook.com>
 <07c8e090-afed-6219-7d24-addfa660d8dd@citrix.com>
In-Reply-To: <07c8e090-afed-6219-7d24-addfa660d8dd@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-02-22T23:25:06.0452889Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b51e1da5-cfe7-4a55-9c88-fbb534e71a8a;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
x-originating-ip: [131.107.160.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76b90b37-83b0-4c17-031a-08d6991cfbae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN4PR2101MB0878;
x-ms-traffictypediagnostic: SN4PR2101MB0878:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtTTjRQUjIxMDFNQjA4Nzg7MjM6T0FGKzI3QWJZZ1lWeUJOYmd6WXBPRHBq?=
 =?utf-8?B?K3M4OTVmNzZDeXFybm1JOWdZQmFaMkRLa25ZSEdWNHM3ZDdvaUJJTGtOdkZD?=
 =?utf-8?B?UGIrOTJvMm1PMkVmVXJDc1RIL0lreTJLam9sM0F5UzFwTllhOXJnV2RTbDd5?=
 =?utf-8?B?QmM0djY2TGhmdjBUaUhRWW1acXFaa3VZWUFoV2ZsSEdlOXJoNGI5SldBRzFR?=
 =?utf-8?B?TlpNdWx6ZDJEby9yeUtmenNPM01WZm9NMnZIOHRpZWFhY3M3bXZiY0Q4c3pr?=
 =?utf-8?B?MytTUDNjemw2UjJTRHJsRm05a2Q5OFZ0bVNwTUJiN1E2NHZGT0NpOTFUVnA1?=
 =?utf-8?B?aE9rR210eG1SNUhyczVvbHhyVFEycmdQUGhUZGtEQklwdC9PdUppV1dqemYz?=
 =?utf-8?B?RFdBS04zdUV4WDc4V0MyOGJLdDM3SysydUdkYmJQeTE1eWI4Y1c3TlZsZTZw?=
 =?utf-8?B?M0p2Mlp1VTZSNDJUNVBEUitqVzc3OWs2YTV0QlpOVk53OEtmcHJnL2p1bGd1?=
 =?utf-8?B?S0JuOERLWEtVR25yY2o3ZE5KZDY0RTdDblhNd0hzN01EOU1NbzA1NHMycTkx?=
 =?utf-8?B?dTFPWlBUbnBkZW1RR09CWm9ZTDlEdDlDdFRaSVliRE5lMTFLWmhXdXBoWis3?=
 =?utf-8?B?MU9WRTl6S245VVNMTW9mWW5zckxPUGF5UjhpbGtNMlcwLzN0VCtFNWNjS1F4?=
 =?utf-8?B?bmkvZXJMeVZHenFkeVk0V2Z2VEI5ZzFhUWVjUm9kZWQxQlpHK0pHdmtSN2pT?=
 =?utf-8?B?WXVFam5YSjRFVHVDYUhBakZ1YTJDenFjN25tY0s5K3VyVGFLY3pCS05Ccmlw?=
 =?utf-8?B?ZmJGRFB4dU95RXpmcUdWa3N6REN3b2ptSFZ0UmtNbTcwVGt1QnNHaE8wQjNS?=
 =?utf-8?B?cHQ3V0R1VDJuTk1MaDdncmxrVWV2N3FiVzIvdDViNWFHb2pkN0ZxcUl5YTU1?=
 =?utf-8?B?MEdvUm1SS01uTi9ka2FpMGdWMEtMZ3FOWEc5RW8yUzZuRmY1bVZuWE95WmJ2?=
 =?utf-8?B?WmZCNTZkVmlML2RBSDVWQ1R1N29ubW9jSzA1c0lUMTBzQlFzWXE4Z3Bkeklp?=
 =?utf-8?B?enQzTVdOdnpyMER5eVJ2a0hIK1pOamxKM2tadTZZNHZoNnpPbUhmVEdPQXRx?=
 =?utf-8?B?ZXE5MUk0Y3dVeTlJZHM3bHBpWGZuVmxyaDMzK1lZSlR2cnBPVVRPbkN0S2ls?=
 =?utf-8?B?dGdqNDVDTi9VekdHK1R5ZFFRVko1U2NPaThkejNib3BpRmxJazlNTWdIMklR?=
 =?utf-8?B?WFYzc0hJT2d6TCtVa1RlZGswbndrNEZYZThzejhXMkpMMzhUUzJYUXNCcTF4?=
 =?utf-8?B?eTlRdXFUSzNJZTlCbXljU2gwTVdCT0VsN1VLVTEreEpsR3pJdjl0VHF4K0s1?=
 =?utf-8?B?c2thN2l6cmN5azRPYzdnSmQ3cFFneGRMTHNZNlIyQmlTeG81V2kzNHRCVkl2?=
 =?utf-8?B?YjVzZ0ZJeEZBd2RIeWM1L1MxOFFUdFVrbFN4dnhzZHFaQTBkMG4zUmZPMzZG?=
 =?utf-8?B?aGkxWXFENlhFNnJJekdKUit3SVFmcmdRQmJqOERLTXRwMEZYc0ZYZEFXLzdC?=
 =?utf-8?B?K3grS0FDRGh4UFBneldmZnNJaDZhdllkQVJhUmhXOS9pRjhGQkUvWFk4aFU2?=
 =?utf-8?B?RFBFbFIxOXRVVHZ6SHRLMkd5UU5Ma0hURVRBdnhURnJ5dCsxTW5RSWNVOEV1?=
 =?utf-8?B?QkxUTGI0eHJXVmMzUkl6VGVDaDVTVndITWxhWHdMelMwY3RaV0IwWWMxTkVO?=
 =?utf-8?B?Z0RpcElpSDBPdklnbm9Md0tGNSsrS3lrNjE2ak1LL0FKMVhQMXloU2swUnd3?=
 =?utf-8?B?NUErayswZ3NhMkxZMWhMS1ZsSzJXZlkyUHVYTlQ4VUoyUVU3bUlMa0VCMkJm?=
 =?utf-8?B?cGVQMUltd0NtaW5oK3ExbVFQd3hSd0V6Z0U3UzBicGM5L3d2S3FPK2dybE1U?=
 =?utf-8?Q?OemT8rFK1G9cTT4kUESdGkO7Dk3VlA+k=3D?=
x-microsoft-antispam-prvs: <SN4PR2101MB0878696ECFD2A20DCC1665D3A07F0@SN4PR2101MB0878.namprd21.prod.outlook.com>
x-forefront-prvs: 09565527D6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39860400002)(396003)(136003)(13464003)(51914003)(189003)(199004)(6346003)(26005)(305945005)(22452003)(68736007)(76176011)(229853002)(99286004)(486006)(74316002)(7696005)(10090500001)(11346002)(8936002)(55016002)(102836004)(316002)(9686003)(105586002)(106356001)(110136005)(53546011)(6436002)(6506007)(8676002)(446003)(81166006)(3846002)(81156014)(6116002)(10290500003)(7736002)(476003)(2906002)(86612001)(478600001)(14454004)(8990500004)(186003)(71200400001)(14444005)(256004)(86362001)(66066001)(25786009)(6246003)(71190400001)(93886005)(33656002)(5660300002)(4326008)(53936002)(97736004)(52536013);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0878;H:SN4PR2101MB0736.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3LMgipb8db5VBRkcxyvlZJ6cgeAdMGgF+7xOvEmWfqk79aYmT6Tx4w+Qai6DK5iBtapnPkTszG1YYcDHXsuuXnvmzH1CdLyabPpYNb2WFsMQgERNrMBBerlana4erZ8wbzuuxRXNsRltYeYxOzS76PZf4Wip1AiggduXajigS9/q2V0al7X/RhAktLiW/gf3Cw+M2cXUc8Xh5+1V+kNcULHBRhR/jurVTE2pkZOk7yvC3ELOqKmftwd+E3jOMTk5+j9gHA8RC5JSISV4PTKSaPArz1SlLzU2vHVXg2/Wtu03aOvbDgcDle1FN4ZxRsbHNmCwASTWeXTeRpbhFotbmEJIymPzTVvbRQGdIZ2a+Awj9/d+Q5CD94Gb2GuPlIcRLraNSYXxw6a19GtGxTMiVPg99CwqBynSz88/Lo3izuo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b90b37-83b0-4c17-031a-08d6991cfbae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2019 23:25:07.8544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0878
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb3NzIExhZ2Vyd2FsbCA8cm9z
cy5sYWdlcndhbGxAY2l0cml4LmNvbT4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyMiwgMjAx
OSA5OjE3IEFNDQo+IFRvOiBUb20gVGFscGV5IDx0dGFscGV5QG1pY3Jvc29mdC5jb20+OyBTdGV2
ZSBGcmVuY2gNCj4gPHNtZnJlbmNoQGdtYWlsLmNvbT4NCj4gQ2M6IENJRlMgPGxpbnV4LWNpZnNA
dmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogRmFpbHVyZSB0byByZWNvbm5lY3QgYWZ0
ZXIgY2x1c3RlciBmYWlsdm9lcg0KPiANCj4gT24gMi8yMS8xOSA1OjU5IFBNLCBUb20gVGFscGV5
IHdyb3RlOg0KPiA+IFRoZSByZWNvbm5lY3QgaXMgYXBwYXJlbnRseSB1c2luZyBhIGRvdHRlZC1x
dWFkIGFzIHRoZSBzZXJ2ZXJuYW1lLCBhbmQgeW91DQo+IGNhbiBzZWUgdGhlIGF1dGggaXMgZm9y
Y2VkIHRvIE5UTE0gYXMgYSBjb25zZXF1ZW5jZS4gSXMgdGhhdCB0aGUgd2F5IHlvdQ0KPiBpbml0
aWFsbHkgbW91bnRlZCB0aGUgc2hhcmUgKGkuZS4gbW91bnQgMTAuNzEuMjE3LjUwOi9zbWJzaGFy
ZSAvbW50KT8NCj4gPg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTog
bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNpZnMtb3duZXJAdmdlci5r
ZXJuZWwub3JnPg0KPiBPbiBCZWhhbGYgT2YgU3RldmUgRnJlbmNoDQo+ID4gU2VudDogVGh1cnNk
YXksIEZlYnJ1YXJ5IDIxLCAyMDE5IDk6MDcgQU0NCj4gPiBUbzogUm9zcyBMYWdlcndhbGwgPHJv
c3MubGFnZXJ3YWxsQGNpdHJpeC5jb20+DQo+ID4gQ2M6IENJRlMgPGxpbnV4LWNpZnNAdmdlci5r
ZXJuZWwub3JnPg0KPiA+IFN1YmplY3Q6IFJlOiBGYWlsdXJlIHRvIHJlY29ubmVjdCBhZnRlciBj
bHVzdGVyIGZhaWx2b2VyDQo+ID4NCj4gPiBDb3VwbGUgcXVpY2sgdGhvdWdodHMuDQo+ID4NCj4g
PiBEb2VzIHRoaXMgd29yayBvbiBjdXJyZW50IGtlcm5lbHMgKDUuMCBmb3IgZXhhbXBsZSkuDQo+
ID4NCj4gPiBXYXMgdGhpbmtpbmcgYWJvdXQgcGF0Y2hlcyB0aGF0IG1pZ2h0IGFmZmVjdCB0aGlz
IGxpa2U6DQo+ID4gLSAiY2lmczogY29ubmVjdCB0byBzZXJ2ZXJuYW1lIGluc3RlYWQgb2YgSVAg
Zm9yIElQQyQgc2hhcmUiDQo+ID4gLSAic21iMzogb24gcmVjb25uZWN0IHNldCBQcmV2aW91c1Nl
c3Npb25JZCBmaWVsZCINCj4gPiAtIFBhdWxvJ3MgcGF0Y2hlcyAoaGFzIGNpZnMtdXRpbHMgY29y
ZXEpIHRvIHJlY29ubmVjdCB0byBuZXcgSVANCj4gPiBhZGRyZXNzIGlmIGhvc3RuYW1lJ3MgSVAg
YWRkcmVzcyBjaGFuZ2VkIGFuZCBoaXMgYWRkIHN1cHBvcnQgZm9yDQo+ID4gZmFpbG92ZXINCj4g
PiAtIFBhdWxvJ3MgcGF0Y2ggdG8gcmVtb3ZlIHRyYWlsaW5nIHNsYXNoZXMgZnJvbSBzZXJ2ZXIg
VU5DIG5hbWUNCj4gPg0KPiBJJ3ZlIHJlcHJvZHVjZWQgdGhpcyB3aXRoIDUuMC1yYzcgYW5kIHRo
ZSBsYXRlc3QgY2lmcy11dGlscyBmcm9tIGdpdC4NCj4gVGhlIHNoYXJlIHdhcyBtb3VudGVkIGFz
IGZvbGxvd3MgKHllcywgYnkgSVApOg0KPiANCj4gbW91bnQuY2lmcyAtbw0KPiB2ZXJzPTMuMCxj
YWNoZT1sb29zZSxhY3RpbWVvPTAsdXNlcm5hbWU9eCxkb21haW49eSxwYXNzd29yZD16DQo+ICcv
LzEwLjcxLjIxNy4zMS9zbWJzaGFyZScgL21udA0KPiANCj4gSGVyZSBpcyB0aGUgdGNwZHVtcCB3
aGVuIGl0IGZhaWxzIHRvIHJlY29ubmVjdCBwcm9wZXJseToNCi4uLg0KPiANCj4gVGhlIGluaXRp
YWwgY29ubmVjdGlvbiBpcyBhdCB0aW1lc3RhbXAgMHMsIHJlY29ubmVjdGlvbiBhdCAxM3MsDQo+
IFNUQVRVU19ORVRXT1JLX05BTUVfREVMRVRFRCBhdCA2MHMuDQo+IA0KPiBGb3IgY29tcGFyaXNv
biwgaGVyZSBpcyBhIHRjcGR1bXAgdXNpbmcgdGhlICJmaXgiIGZyb20gbXkgcHJldmlvdXMgbWFp
bDoNCi4uLg0KPiANCj4gVGhlIGluaXRpYWwgY29ubmVjdGlvbiBpcyBhdCB0aW1lc3RhbXAgMHMs
IHJlY29ubmVjdGlvbiBhdCAzNHMsDQo+IHN1Y2Nlc3NmdWwgcmVhZCByZXF1ZXN0IGF0IDIxNXMu
DQo+IA0KPiBOb3RlIHRoYXQgdGhlIHRyZWUgY29ubmVjdCBmb3IgSVBDJCBvbmx5IGhhcHBlbnMg
X2FmdGVyXyB0aGUgdHJlZQ0KPiBjb25uZWN0IGZvciB0aGUgc2hhcmUgc3VjY2VlZHMuDQoNClRo
YW5rcyBmb3IgdGhlIGZ1bGwgdHJhY2VzLCB0aGV5IGNsYXJpZnkgdGhlIHNpdHVhdGlvbi4gQnV0
LCBJIGRvbuKAmXQgc2VlIGFueQ0KbWVhbmluZ2Z1bCBkaWZmZXJlbmNlIGluIHRoZSBjbGllbnQg
YmVoYXZpb3IuIFRoZSBvcmRlcmluZyBvZiB0aGUgdHdvDQp0cmVlY29ubmVjdHMgaXMgdGhlIHNh
bWUgYmV0d2VlbiB0aGUgdHdvIC0gaW5pdGlhbGx5LCAiSVBDJCIgdGhlbg0KInNtYnNoYXJlIiwg
YW5kIG9uIHJlY29ubmVjdCwgdGhlIG90aGVyIHdheSBhcm91bmQuIFNvLCBJJ20gdW5jbGVhcg0K
d2hldGhlciB5b3VyIHBhdGNoIGRpZCBhbnl0aGluZy4NCg0KVGhlIFNUQVRVU19ORVRXT1JLX05B
TUVfREVMRVRFRCBpcyBhIGNvbnNlcXVlbmNlIG9mIHRoZSBmYWlsZWQNCnJlLWVzdGFibGlzaG1l
bnQgb2YgdGhlIHRyZWUgY29ubmVjdCwgYW5kIGlzIG5vdCBpdHNlbGYgdGhlIHByb2JsZW0uIFRo
ZQ0Kc2VydmVyIGlzIHNpbXBseSB0aW1pbmcgb3V0IHRoZSB0cmVlaWQsIHNpbmNlIHRoZSBjbGll
bnQgZGlkIG5vdCBzdWNjZXNzZnVsbHkNCnJlY2xhaW0gaXQuIFRoZSByZXBlYXRlZCBTVEFUVVNf
QkFEX05FVFdPUktfTkFNRSBpcyB0aGUgaXNzdWUuDQoNCkFyZSB5b3Ugc3VyZSB0aGUgY2x1c3Rl
cmVkIHNlcnZlciBpcyByZWNvdmVyaW5nIHByb3Blcmx5IHdoZW4geW91IGFyZQ0KZm9yY2luZyB0
aGUgZmFpbG92ZXI/IEZvciBleGFtcGxlLCBpZiBpdCdzIGEgdHdvLW5vZGUgY2x1c3RlciwgbWF5
YmUgbm9kZSBBDQpjYW4gdGFrZSBvdmVyIG5vZGUgQiwgYnV0IG5vZGUgQiBoYXMgaXNzdWVzIHRh
a2luZyBvdmVyIG5vZGUgQS4gSXMgdGhlcmUNCmFueXRoaW5nIHJlbGV2YW50IGluIHRoZSBzZXJ2
ZXIgbG9ncz8NCg0KVG9tLg0K
