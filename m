Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5D4C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 14:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A37F218FF
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 14:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="BvBJxmHi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfCUO0w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:26:52 -0400
Received: from mail-eopbgr820112.outbound.protection.outlook.com ([40.107.82.112]:53461
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfCUO0v (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Mar 2019 10:26:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TYe0qCc7ge6PKbI/sCeyasz9uEuSbZHMUIfAir8vco=;
 b=BvBJxmHi6xtZzJAURujECn89oT5E/8SVS/sQ9cyorPi/SPJN6RTV+CVoWx3VF5ZmSQ9RTYuU4NNZMPCUKpyrigpIEwU7DoFFt9G4FO9IU8b3RjsYiCgkMvbLT3kVrJ9R4YR7fojt+J4+wRslZXS8jw4RFPVl7wdthH+49oQc4VU=
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com (10.167.151.155) by
 SN4PR2101MB0877.namprd21.prod.outlook.com (10.167.133.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1730.0; Thu, 21 Mar 2019 14:26:50 +0000
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::804d:6cd0:c000:791c]) by SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::804d:6cd0:c000:791c%3]) with mapi id 15.20.1750.005; Thu, 21 Mar 2019
 14:26:50 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        Andreas Hasenack <andreas@canonical.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <palcantara@suse.de>
Subject: RE: "Bad SMB2 signature for message" with kernel 5.0.0, works with
 4.19.0
Thread-Topic: "Bad SMB2 signature for message" with kernel 5.0.0, works with
 4.19.0
Thread-Index: AQHU30xYJzZUNmeNdUG3Lh4Kn7ftzaYVFDeAgAEPy/A=
Date:   Thu, 21 Mar 2019 14:26:49 +0000
Message-ID: <SN4PR2101MB07362B23C8469E355E955B27A0420@SN4PR2101MB0736.namprd21.prod.outlook.com>
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
 <CAH2r5msqKdOwDwTsfeXGKg2wQ0tHfNGp+Lh=EchMKO+a5k6NNA@mail.gmail.com>
In-Reply-To: <CAH2r5msqKdOwDwTsfeXGKg2wQ0tHfNGp+Lh=EchMKO+a5k6NNA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-03-21T14:26:47.7271355Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f97721f-6b95-490c-86e9-e55d20a39e73;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
x-originating-ip: [198.214.84.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f91d392-e067-4f11-82e2-08d6ae0941c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN4PR2101MB0877;
x-ms-traffictypediagnostic: SN4PR2101MB0877:
x-microsoft-antispam-prvs: <SN4PR2101MB087713EB6348C2789C0AAAFFA0420@SN4PR2101MB0877.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0983EAD6B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(376002)(396003)(346002)(199004)(189003)(13464003)(3846002)(4326008)(52536014)(305945005)(81156014)(186003)(6346003)(14444005)(316002)(256004)(11346002)(8936002)(446003)(22452003)(7736002)(25786009)(8676002)(476003)(6116002)(68736007)(6246003)(97736004)(110136005)(74316002)(53546011)(71200400001)(54906003)(8990500004)(6506007)(71190400001)(102836004)(10090500001)(99286004)(106356001)(15650500001)(7696005)(2906002)(76176011)(6436002)(26005)(229853002)(81166006)(86362001)(5660300002)(55016002)(9686003)(14454004)(486006)(86612001)(10290500003)(53936002)(33656002)(66066001)(105586002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0877;H:SN4PR2101MB0736.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RLqSzVw364gU3mRKuKSYRv6AD9xAvZqh0CVK9wOUAE5nxFa67WWM72MSyfdThJt2iHY9GqIi2HJsQOopUv5q+oBHicRsc7HqYfxBBuenbIDvhWxXdewFd0cOufxZjSmgFPQRzT0f2V7hcn1sPct/Y19M2G46jpt0uQ5hBJnPJyricxNjwmtm0EJsnBDk3E3vBoaR+gITg7JymMR85xFgn9M7+untunIcG3dIbb0E3w4CkGdZ362c+Wk/NnFlDVhf6D0BOz3CcWXiVnkLhstvRyFBxonQsMinXcUhHANYJ+I8kV46z8jKhx0j1fbOnhNxJFDzoSzuSdyUdw5Xj/vmbCFeiERig2eb5tYwFEshw1YeFS3wRwOGSEhL/AbzyIL4FqBKG1RFd6xhg9i8xhQ8MYCuPkdm8PMdNG2QnI0ypeY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f91d392-e067-4f11-82e2-08d6ae0941c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2019 14:26:49.9771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0877
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBTdGV2ZSBGcmVuY2gNCj4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyMCwgMjAxOSA1
OjA4IFBNDQo+IFRvOiBBbmRyZWFzIEhhc2VuYWNrIDxhbmRyZWFzQGNhbm9uaWNhbC5jb20+DQo+
IENjOiBDSUZTIDxsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZz47IFBhdWxvIEFsY2FudGFyYSA8
cGFsY2FudGFyYUBzdXNlLmRlPg0KPiBTdWJqZWN0OiBSZTogIkJhZCBTTUIyIHNpZ25hdHVyZSBm
b3IgbWVzc2FnZSIgd2l0aCBrZXJuZWwgNS4wLjAsIHdvcmtzIHdpdGgNCj4gNC4xOS4wDQo+IA0K
PiBJIGFtIG5vdCBzdXJlIGl0IGlzIGxlZ2FsIHRvIHJlcXVpcmUgc2lnbmluZyBhbmQgdG8gY29u
bmVjdCBhcyBndWVzdC4NCj4gIFNlZSBxdW90ZSBmcm9tIHByb3RvY29sIHNwZWNpZmljYXRpb24g
KE1TLVNNQjIpOg0KPiANCj4gSWYgdGhlIFNNQjJfU0VTU0lPTl9GTEFHX0lTX0dVRVNUIGJpdCBp
cyBzZXQgaW4gdGhlIFNlc3Npb25GbGFncyBmaWVsZA0KPiBvZiB0aGUgU01CMg0KPiBTRVNTSU9O
X1NFVFVQIFJlc3BvbnNlIGFuZCBpZiBTZXNzaW9uLlNpZ25pbmdSZXF1aXJlZCBpcyBUUlVFLCB0
aGlzIGluZGljYXRlcw0KPiBhDQo+IFNFU1NJT05fU0VUVVAgZmFpbHVyZSBhbmQgdGhlIGNvbm5l
Y3Rpb24gTVVTVCBiZSB0ZXJtaW5hdGVkLiBJZiB0aGUNCj4gU01CMl9TRVNTSU9OX0ZMQUdfSVNf
R1VFU1QgYml0IGlzIHNldCBpbiB0aGUgU2Vzc2lvbkZsYWdzIGZpZWxkIG9mIHRoZSBTTUIyDQo+
IFNFU1NJT05fU0VUVVAgUmVzcG9uc2UgYW5kIGlmIFJlcXVpcmVNZXNzYWdlU2lnbmluZyBpcyBG
QUxTRSwNCj4gU2Vzc2lvbi5TaWduaW5nUmVxdWlyZWQNCj4gTVVTVCBiZSBzZXQgdG8gRkFMU0Uu
DQoNCkl0J3MgZXZlbiBtb3JlIGZ1bmRhbWVudGFsLiBBIGd1ZXN0IGxvZ2luIGhhcyBubyBzZWNy
ZXQsIGFuZCB3aXRob3V0IGEgc2VjcmV0DQp0aGVyZSBpcyBub3RoaW5nIHRvIGRyaXZlIHRoZSBz
aWduaW5nIGFsZ29yaXRobS4gVGhlcmVmb3JlLCBhIGd1ZXN0IHNlc3Npb24gY2Fubm90DQp2YWxp
ZGx5IHNpZ24uDQoNCklmIHRoZSBjbGllbnQgaXMgYXR0ZW1wdGluZyB0byBzaWduIGFzIGd1ZXN0
LCB0aGF0J3MgYSBidWcuIElmIHRoZSBzZXJ2ZXIgaXMgYWNjZXB0aW5nDQphIHJlcXVlc3Qgd2l0
aCBhbiBpbnZhbGlkIHNpZ25hdHVyZSwgdGhhdCdzIGFub3RoZXIgYnVnLg0KDQpUb20uDQo=
