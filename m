Return-Path: <SRS0=ZQfQ=2G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B814BC43603
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Dec 2019 17:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 789AE206EC
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Dec 2019 17:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="iZrKFM1k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfLPRL2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Dec 2019 12:11:28 -0500
Received: from mail-eopbgr750091.outbound.protection.outlook.com ([40.107.75.91]:33819
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbfLPRL1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 16 Dec 2019 12:11:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvSRf+lwhFDrJxgcQswkKcbEhrD3OE/I3+/1ei7z/253qrE34V8yVd/lZtBCRZFVPUCmQhF5n++1glBcqP8Uqak4qTzqxfk44OwL6gKwDLGgb078bpjAClvIKVtHOOL/Ae6o3Na+bmWfh01vN6HG2vdG2QY38t00YG4JWb7Q585dZ2xx/I/fgGQTgJWsRfKbI8BdqKpeQIaZ/3f4fJBmvQDj+tZ2llVaqEtpzMfUM0KvqqY7s7gAw8Y+EpJr0ZD84+L2RsG6CJMRGaUvRVxtu60vvLI4v6HqsJDQk1QLQzfHhCZ8qwSX3u0svRmr+l4F2+KxtU3jh8Veu9PUWrT0jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkJoZib06jzo4NMToqyClFlxY8bTbvt6/58eEDuUqVs=;
 b=eRwzInb4hsjomexh17qmyc7s62OhDRJo7gztDz/2dL2aV4oum2UUKBx+C3TBXcztd21UtRB+n4jUu0CWlN4bkI37a6RotLk1MMpdGZOmEnzJstFK1hxX/dvwO6EpQkxvZ/ofsRo3dCoZj4uGw2rdUmgm+CsqpzvAaTqNymEeTGy6kLsvJkGXeK43lArsFSqV9QFay+vu74UtdlYlKZ2bAFb6vVdkL5vqoSNHxCtvBCFjEcMArY94CuAov48KrHs2W2CbiB/vhpDbWNUHBBpv8WtmLG9T1b4mw2kxHoCYJhJY0hhuqzz7pkr7CpeM/In8DUr6P23k6uC/8nMo4vGj4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkJoZib06jzo4NMToqyClFlxY8bTbvt6/58eEDuUqVs=;
 b=iZrKFM1k86g4PdfUwJgRdjy+YGTCtmMg9Dt8mlNJwtO1Q6fqeZmpGKn27aavB9nld0epkkDH//+ge1h5t3V+YT0Bh39zU0YDHgFs/yCVRHOGCCtdsL0DJRpup/Xq2H8KV2GqShZ9rqYjpvRNs9Y3Rqhau6LGWYZ/cyWzUIrwXg8=
Received: from MN2PR21MB1439.namprd21.prod.outlook.com (20.180.26.143) by
 MN2PR21MB1168.namprd21.prod.outlook.com (20.178.255.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.4; Mon, 16 Dec 2019 17:11:24 +0000
Received: from MN2PR21MB1439.namprd21.prod.outlook.com
 ([fe80::6c23:c364:903f:4423]) by MN2PR21MB1439.namprd21.prod.outlook.com
 ([fe80::6c23:c364:903f:4423%8]) with mapi id 15.20.2559.012; Mon, 16 Dec 2019
 17:11:24 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Xiaoli Feng <xifeng@redhat.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: How to use SMB Direct
Thread-Topic: How to use SMB Direct
Thread-Index: UIMmQ9EQHszzT+199YRg7frRdlFZzaUb4A1g
Date:   Mon, 16 Dec 2019 17:11:24 +0000
Message-ID: <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
 <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
In-Reply-To: <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=05e10d4a-cbf0-4fd0-b253-0000aece17fc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-12-16T16:39:44Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c02ecd71-8cbb-4fd3-34b5-08d7824afaff
x-ms-traffictypediagnostic: MN2PR21MB1168:
x-microsoft-antispam-prvs: <MN2PR21MB116827790D9415CCAFE99D70A0510@MN2PR21MB1168.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(136003)(39860400002)(189003)(199004)(13464003)(2906002)(86362001)(186003)(66476007)(52536014)(33656002)(66946007)(76116006)(55016002)(9686003)(5660300002)(8990500004)(66556008)(66446008)(64756008)(6506007)(81166006)(8936002)(81156014)(8676002)(10290500003)(478600001)(316002)(7696005)(26005)(71200400001)(110136005)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR21MB1168;H:MN2PR21MB1439.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1OoKjwwFR6ITvLUp20RD6ryNatld8mZ2sL/eRM4YpAmbQPrC5HdSF24R7f17gEo5OErqmUFs27pVVxlRLK2oJvI6sWixoVkc3F34QWR1BehFHbpZPO1dnUp3K3Y89vu35WsWRzmi4FycrV1IMO4PPxrFF9C0KKRygJhz54t7gLQSwg+K60hJ8WXTvYazoZJMYqED5rOxW/qime0/u3HfdpnQ9+BAI3BEUj8chTEJK509+gy2pBBUwD/S/Z9Kxv3wxxqobCJAyXVp9w/Yr9KMdAKmwSJkkXuTmwgVXTa5XXyRDFfE1ykez3eQPjeG0y87YPunstPTEww0HKGMrmGcJzKAhDP1Nml6vzUCeKPAwWF/8qw3D/dcs3ZxkgehMDnpsIv5vheQBKsDwmbNbAxCXOLCQPpLsZ0yLI1P9Pc45iRrwQnGZONICuXpVaEU3bbFHjivjkrpMzNrPHXQ2hZrSywmjGKqrs9fVOiUZFfec9zCPd9vbXI1VZ7WysiuQzPE
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02ecd71-8cbb-4fd3-34b5-08d7824afaff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:11:24.5170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1N8ZHhl4fqKrEOd5SSFp+MPJ/L36pB6vELIoRAfArbFLiBbkfpRVEgVgA94szgHF4EH7pDoqyjvJoFyspN9qWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1168
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBYaWFvbGkgRmVuZw0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDE2LCAyMDE5IDEw
OjMwIEFNDQo+IFRvOiBsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbRVhU
RVJOQUxdIEhvdyB0byB1c2UgU01CIERpcmVjdA0KPiANCj4gSGVsbG8gZ3V5cywNCj4gDQo+IEkn
ZCBsaWtlIHRvIHRlc3QgU01CIERpcmVjdC4gQnV0IGl0J3MgZmFpbGVkLiBJJ20gbm90IHN1cmUg
aWYgaXQgd29ya3MgaW4gdXBzdHJlYW0uDQo+IEkgc2V0dXAgc2FtYmEgc2VydmVyIG9uIG9uZSBy
ZG1hIG1hY2hpbmUgd2l0aCA1LjUuMC1yYzErIGtlcm5lbC4gVGhlDQo+IHNtYi5jb25mIGlzOg0K
PiBbY2lmc10NCj4gcGF0aD0vbW50L2NpZnMNCj4gd3JpdGVhYmxlPXllcw0KPiANCj4gVGhlbiBJ
IHRyeSB0byBtb3VudCB0aGUgc2hhcmUgb24gYW5vdGhlciByZG1hIG1hY2hpbmUgd2l0aCA1LjUu
MC1yYzErIGtlcm5lbC4NCj4gICAgbW91bnQgLy8kUkRNQS9jaWZzIGNpZnMgLW8gdXNlcj1yb290
LHBhc3N3b3JkPSRwYXNzd29yZCxyZG1hDQo+IA0KPiBJdCdzIGZhaWxlZCBiZWNhdXNlIG9mICJD
SUZTIFZGUzogc21iZF9jcmVhdGVfaWQ6NjE0IHJkbWFfcmVzb2x2ZV9hZGRyKCkNCj4gY29tcGxl
dGVkIC0xMTMiDQoNCkVycm5vIDExMyBpcyAibm8gcm91dGUgdG8gaG9zdCIuIFNvdW5kcyBsaWtl
IGEgbmV0d29yayBvciBhZGRyZXNzIGlzc3VlLg0KDQpUb20uDQoNCj4gRG9lcyBTTUIgRGlyZWN0
IHdvcmsgZmluZSBpbiB1cHN0cmVhbT8NCj4gDQo+IFRoYW5rcy4NCj4gDQo+ICQgY2F0IC9ib290
L2NvbmZpZy01LjUuMC1yYzErIHxncmVwIFNNQl9ESVJFQ1QNCj4gQ09ORklHX0NJRlNfU01CX0RJ
UkVDVD15DQo+ICQgaWJzdGF0DQo+IENBICdtbHg0XzAnDQo+IAlDQSB0eXBlOiBNVDQwOTkNCj4g
CU51bWJlciBvZiBwb3J0czogMg0KPiAJRmlybXdhcmUgdmVyc2lvbjogMi40Mi41MDAwDQo+IAlI
YXJkd2FyZSB2ZXJzaW9uOiAxDQo+IAlOb2RlIEdVSUQ6IDB4ZjQ1MjE0MDMwMDdiZTBlMA0KPiAJ
U3lzdGVtIGltYWdlIEdVSUQ6IDB4ZjQ1MjE0MDMwMDdiZTBlMw0KPiAJUG9ydCAxOg0KPiAJCVN0
YXRlOiBBY3RpdmUNCj4gCQlQaHlzaWNhbCBzdGF0ZTogTGlua1VwDQo+IAkJUmF0ZTogNTYNCj4g
CQlCYXNlIGxpZDogMjkNCj4gCQlMTUM6IDANCj4gCQlTTSBsaWQ6IDENCj4gCQlDYXBhYmlsaXR5
IG1hc2s6IDB4MDI1OTQ4NmENCj4gCQlQb3J0IEdVSUQ6IDB4ZjQ1MjE0MDMwMDdiZTBlMQ0KPiAJ
CUxpbmsgbGF5ZXI6IEluZmluaUJhbmQNCj4gCVBvcnQgMjoNCj4gCQlTdGF0ZTogQWN0aXZlDQo+
IAkJUGh5c2ljYWwgc3RhdGU6IExpbmtVcA0KPiAJCVJhdGU6IDQwDQo+IAkJQmFzZSBsaWQ6IDQ0
DQo+IAkJTE1DOiAxDQo+IAkJU00gbGlkOiAzNg0KPiAJCUNhcGFiaWxpdHkgbWFzazogMHgwMjU5
NDg2OA0KPiAJCVBvcnQgR1VJRDogMHhmNDUyMTQwMzAwN2JlMGUyDQo+IAkJTGluayBsYXllcjog
SW5maW5pQmFuZA0KPiANCj4gDQo+IC0tDQo+IEJlc3QgcmVnYXJkcyENCj4gWGlhb0xpIEZlbmcg
5Yav5bCP5Li9DQo+IA0KPiBSZWQgSGF0IFNvZnR3YXJlIChCZWlqaW5nKSBDby4sTHRkDQo+IGZp
bGVzeXN0ZW0tcWUgVGVhbQ0KPiBJUkM6eGlmZW5n77yMI2NoYW5uZWw6IGZzLXFlDQo+IFRlbDor
ODYtMTAtODM4ODExMg0KPiA5L0YsIFJheWNvbQ0KDQo=
