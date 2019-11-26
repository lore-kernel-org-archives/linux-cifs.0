Return-Path: <SRS0=b7Yi=ZS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F86C432C0
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 18:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EACE42080F
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 18:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="RrgKQD5M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfKZSiu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 13:38:50 -0500
Received: from mail-eopbgr730116.outbound.protection.outlook.com ([40.107.73.116]:33179
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725895AbfKZSiu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 13:38:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSXkuF7o6YjFr3u/5LqD39BI6j/ALJ0BBJV8fSdKJFvsrMbHQWdl41oYoELJNuDm/6szsCcvD/PAymfyNWH2lSlXp26bpBjfQpx4tOiDRgj7e70focIVZQQHj2b/ObeCRbdVEOyUFEe2wkGMNp5TB9vbqmU4qWqvTwiWY9LG07x180YKFDWdKZ4Wva+Ckl75xzAKIYvrHs1dCL5WFOOKMQYkkIEbftCMEjPcRVpdmc54DFle9/JTtJquug80lWJukjRjn+ppGotT03qUYkII8dqGP88F3iDfaomRRJCnPYlqMdXVDrMEV6VntAhZXsUwphjvKWkaQOzlc3GGeliS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XYxDVdnRooA65ZUZTJWEKoaPz8ux2esQds3E2n32SI=;
 b=lzHzjDTZifHmh3QaLJXYGdc+2tn9j3TS7ru/g7Mm9rZgt+Qevh2kC8iiLKIZHiNiB+pkiG7uYaI+JxVDjmAS3n3eFmQBZ3WTkeMMcVPmcTL2USTIK9XMEagLCaoELNdBvtpp84ovPh569k1qG7DDsBeHduK+UT+Dn6dsHOQ7RmUjU3z0XHt+n9/lmvh4tjx5QsExGv4mMz7Rb25MlkNieK8xB/W5pfogA2Z2ik8pl9dSwpKMILcasuXf7khsEnPtNGBH3lR0GRA6DTpsom1LvbJPtBA4PdSuMrh1S/gNhtzczSYyj6+rkwEhpja0JMspozwjDe+MCyA0+dEOAJTtVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XYxDVdnRooA65ZUZTJWEKoaPz8ux2esQds3E2n32SI=;
 b=RrgKQD5Mxs10Fg5QiPpDkkFupz1pl8iOOqDY/+f0F24pZuwKTMo0E1a/ftmRnbL6QxPz+65jqQsj0SfOWcvQufNTKlt8rJx9G0uuD5jFArDSE0352/gMIC8cmgG5nPasuRTYitrUON7emlTWfYpJX70zfPKRah9mYoEY9SyCfU8=
Received: from DM6PR21MB1433.namprd21.prod.outlook.com (20.180.20.78) by
 DM6PR21MB1162.namprd21.prod.outlook.com (20.179.51.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.0; Tue, 26 Nov 2019 18:38:46 +0000
Received: from DM6PR21MB1433.namprd21.prod.outlook.com
 ([fe80::61e3:a64:c175:1d85]) by DM6PR21MB1433.namprd21.prod.outlook.com
 ([fe80::61e3:a64:c175:1d85%3]) with mapi id 15.20.2516.003; Tue, 26 Nov 2019
 18:38:46 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     =?utf-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: RE: [EXTERNAL] Re: [PATCH v4 1/6] cifs: sort interface list by speed
Thread-Topic: [EXTERNAL] Re: [PATCH v4 1/6] cifs: sort interface list by speed
Thread-Index: AQHVkeUGXO5kI45L1kirBBlxN+y+z6eciwgAgAExhKCAABPzgIAAGwVQ
Date:   Tue, 26 Nov 2019 18:38:46 +0000
Message-ID: <DM6PR21MB1433CA9F4D4904C7794D96FDA0450@DM6PR21MB1433.namprd21.prod.outlook.com>
References: <20191103012112.12212-1-aaptel@suse.com>
 <20191103012112.12212-2-aaptel@suse.com>
 <CAKywueS3DpPkpeNprSUwrXw=ErZZsn3vRF6uVE646oCWC_8-4w@mail.gmail.com>
 <DM6PR21MB1433DA86898BCD2C9687956EA0450@DM6PR21MB1433.namprd21.prod.outlook.com>
 <87lfs2varo.fsf@suse.com>
In-Reply-To: <87lfs2varo.fsf@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-26T18:38:44.7740420Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cfd3f0d3-c70d-4a2d-ba32-cd5303554525;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 420267e6-d9ee-4cab-50cf-08d7729fdefc
x-ms-traffictypediagnostic: DM6PR21MB1162:
x-microsoft-antispam-prvs: <DM6PR21MB116221376701266C1066220FA0450@DM6PR21MB1162.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(13464003)(6306002)(26005)(8936002)(81166006)(33656002)(52536014)(478600001)(14454004)(9686003)(110136005)(99286004)(66574012)(10290500003)(966005)(25786009)(14444005)(2906002)(66446008)(66066001)(66946007)(256004)(5660300002)(76116006)(64756008)(66556008)(7736002)(4326008)(66476007)(305945005)(186003)(6436002)(8676002)(81156014)(102836004)(446003)(55016002)(11346002)(6246003)(316002)(8990500004)(10090500001)(86362001)(22452003)(71190400001)(71200400001)(6506007)(53546011)(7696005)(76176011)(54906003)(3846002)(6116002)(229853002)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1162;H:DM6PR21MB1433.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H+/IDJpLSpCYIcwE0FgbR9+BhrtQkifE2gwq1oVUGFDRuxLf1slKPfDSDVhtWFt8UD9g1dT1ftG9463W1aF58/EjcLZ1iyiG/yZjk6uRTawdnOjAP85MRSyatREgPQaybjShvmCV+RdoQGi3CK2cguHGvzZoVeQMvv9y3EWMAe8NaUI2qeUFIjRxAY+bVmiyA/EgpwVLQA/q3yBSBgkkZC2azV25rRXhH2AefJsqDNvs8mrKkXBgXLezIYAr8JWBmNsgDLbeCkXhO+25TjFNu7kYyYtcbh1rnkQzP3QltQbNIxzSAPku5Ohi/35ccU3OLn2yEHljpjAunpTdR2INB7oLFK7WgCwW3qtAloXmTiRmnaAfNsF17YdGIg8fpeHoVqNMIjS6XVLh9r/md+xGWj/2xzchh7Di2MBdtOBL/gZzwiyBUuZqdGzrwN+dmMIgCx9D0u7+HNdfNRxPdzZvFzSiiCoAao8xjLoE0x8oUDs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 420267e6-d9ee-4cab-50cf-08d7729fdefc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 18:38:46.1464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HhO8d7eKNoG7ZRopL48aSi5exPsNzG8RyKa+oz3vHDb2ZR+wAOwTvqKM0umINEFJbGQwq+R5l+wgXonKLvWdgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1162
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBdXLDqWxpZW4gQXB0ZWwgPGFh
cHRlbEBzdXNlLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTm92ZW1iZXIgMjYsIDIwMTkgMTE6NTQg
QU0NCj4gVG86IFRvbSBUYWxwZXkgPHR0YWxwZXlAbWljcm9zb2Z0LmNvbT47IFBhdmVsIFNoaWxv
dnNreQ0KPiA8cGlhc3RyeXl5QGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4LWNpZnMgPGxpbnV4LWNp
ZnNAdmdlci5rZXJuZWwub3JnPjsgU3RldmUgRnJlbmNoDQo+IDxzbWZyZW5jaEBnbWFpbC5jb20+
DQo+IFN1YmplY3Q6IFJFOiBbRVhURVJOQUxdIFJlOiBbUEFUQ0ggdjQgMS82XSBjaWZzOiBzb3J0
IGludGVyZmFjZSBsaXN0IGJ5IHNwZWVkDQo+IA0KPiBIaSwNCj4gDQo+IFRvbSBUYWxwZXkgPHR0
YWxwZXlAbWljcm9zb2Z0LmNvbT4gd3JpdGVzOg0KPiA+IFNvcnRpbmcgYnkgc3BlZWQgaXMgZGVm
aW5pdGVseSBhcHByb3ByaWF0ZSwgYnV0IHNvcnRpbmcgdGhlIG90aGVyDQo+ID4gbXVsdGljaGFu
bmVsIGF0dHJpYnV0ZXMgaXMganVzdCBhcyBpbXBvcnRhbnQuIEZvciBleGFtcGxlLCBpZiB0aGUN
Cj4gPiBSRE1BIGF0dHJpYnV0ZSBpcyBzZXQsIHRoZSBhZGRyZXNzIHNob3VsZCBhY3R1YWxseSBi
ZSBleGNsdWRlZA0KPiA+IGZvciBub24tUkRNQSBjb25uZWN0aW9ucyAoYSBzZWNvbmQsIG5vbi1S
RE1BIGVudHJ5IGlzIGluY2x1ZGVkLA0KPiA+IGlmIHRoZSBpbnRlcmZhY2Ugc3VwcG9ydHMgYm90
aCkuIEFuZCwgdGhlIFJTUyBhdHRyaWJ1dGUgaW5kaWNhdGVzIGENCj4gPiAiYmV0dGVyIiBkZXN0
aW5hdGlvbiB0aGFuIG5vbi1SU1MgZm9yIGEgZ2l2ZW4gc3BlZWQsIGJlY2F1c2UgaXQgaXMNCj4g
PiBtb3JlIGVmZmljaWVudCBhdCBsb2NhbCB0cmFmZmljIG1hbmFnZW1lbnQuDQo+IA0KPiBOb3Rl
IHRoYXQgdGhlIHdheSB0aGUgbGlzdCBpcyB1c2VkIGhhcyBiZWVuIGFsdGVyZWQgaW4gYSBsYXRl
ciBwYXRjaA0KDQpIbW0sIHRoYXQgcGF0Y2ggZG9lcyBoZWxwIGJ5IHRha2luZyBSU1MgaW50byBh
Y2NvdW50LCBidXQgaXQNCmRvZXMgbm90IHRha2UgUkRNQSBpbnRvIGNvbnNpZGVyYXRpb24uIFRo
ZSBsb2dpYyBmb3IgdGhhdCBtYXkNCmJlIG1vcmUgY29tcGxleCwgYXMgaXQgd291bGQgbmVlZCB0
byBkZXRlcm1pbmUgd2hldGhlciBhbg0KUkRNQSBtb3VudCB3YXMgZGVzaXJlZCwgYW5kIGFuIGFk
YXB0ZXIgYXZhaWxhYmxlLiBBbmQgaXQNCmxvb2tzIGxpa2UgdGhlIGNvZGUgd2lsbCB0cnkgdGhl
IFJETUEgYWRkcmVzc2VzIGZyb20gb3RoZXINCnRyYW5zcG9ydCBwcm90b2NvbHMuDQoNCkkgYWxz
byB0aGluayBpdCBpcyBtb3JlIHRoYW4gYSBsaXR0bGUgdG9vICJoZXJvaWMiLiBSZXRyeWluZyBz
ZWVtcw0KdW5uZWNlc3NhcnksIGRvZXNuJ3QgdGhlIGNvZGUgcmVmcmVzaCB0aGUgbGlzdCBmcm9t
IHRpbWUgdG8gdGltZQ0KYW5kIHJlYXR0ZW1wdCBjb25uZWN0aW9ucz8gVGhhdCdzIHdoYXQgdGhl
IFdpbmRvd3MgY2xpZW50IGRvZXMsDQphbnl3YXkuIEkgd291bGQgc3VnZ2VzdCBhdm9pZGluZyBh
bnkga2luZCBvZiByZXRyeSBleGNlcHQgb24gdGhlDQp2ZXJ5IGZpcnN0IGNvbm5lY3Rpb24sIGFu
ZCBldmVuIHRoZW4sIG1hbnkgYWRtaW5zIHdpbGwgd2FudCBhDQpmYXN0LWZhaWwuIFRocmVlIFRD
UCByZXRyaWVzIGNhbiB0YWtlIGEgbG9uZyB0aW1lIQ0KDQpUb20uDQoNCj4gaGVyZToNCj4gDQo+
IGh0dHBzOi8vbmFtMDYuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRw
cyUzQSUyRiUyRmxvcmUua2VyDQo+IG5lbC5vcmclMkZsaW51eC1jaWZzJTJGMjAxOTExMjAxNjE1
NTkuMzAyOTUtMi0NCj4gYWFwdGVsJTQwc3VzZS5jb20lMkZUJTJGJTIzdSZhbXA7ZGF0YT0wMiU3
QzAxJTdDdHRhbHBleSU0MG1pY3Jvcw0KPiBvZnQuY29tJTdDZjc2YTk5YmQ1MGVhNGZiZjRmNzkw
OGQ3NzI5MTQ5NDYlN0M3MmY5ODhiZjg2ZjE0MWFmOTFhYjINCj4gZDdjZDAxMWRiNDclN0MxJTdD
MCU3QzYzNzEwMzg0MDYzMjk4MjEyOCZhbXA7c2RhdGE9T0p4cXdEb1Y4Qw0KPiBDWU5vNjljZ1I5
bndtYzF4R1IyMnM4SjlZOUdEaVY3NE0lM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IENoZWVycywN
Cj4gLS0NCj4gQXVyw6lsaWVuIEFwdGVsIC8gU1VTRSBMYWJzIFNhbWJhIFRlYW0NCj4gR1BHOiAx
ODM5IENCNUYgOUY1QiBGQjlCIEFBOTcgIDhDOTkgMDNDOCBBNDlCIDUyMUIgRDVEMw0KPiBTVVNF
IFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7D
vHJuYmVyZywgREUNCj4gR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgTWFyeSBIaWdnaW5zLCBTcmkg
UmFzaWFoIEhSQiAyNDcxNjUgKEFHIE3DvG5jaGVuKQ0K
