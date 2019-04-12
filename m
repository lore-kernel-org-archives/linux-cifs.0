Return-Path: <SRS0=lstS=SO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D11C10F0E
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 13:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2382084D
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 13:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="jPYsG5aG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfDLNxQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:53:16 -0400
Received: from mail-eopbgr730117.outbound.protection.outlook.com ([40.107.73.117]:35296
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbfDLNxP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 12 Apr 2019 09:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vk73s5mf/z6pOjPaYfZ5TFyJzPUvevl8D43e66Or2hk=;
 b=jPYsG5aG6CK2Oext4SVq0g0jJTN0rdRzuS9coyA51vaIMrVX2CACK1Gv3EUUZzcO2Cn79atSB5rAIhI/BU/KxvPRYUqyBunPF8tN1FXvB7mLYk6WmnEezIcrATadXTfXWdVPeCtwgyJ9BDSGS+WaHph9SrhFPxcI6kDQewCEil0=
Received: from DM5PR2101MB0727.namprd21.prod.outlook.com (10.167.110.39) by
 DM5PR2101MB0934.namprd21.prod.outlook.com (52.132.131.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.8; Fri, 12 Apr 2019 13:53:12 +0000
Received: from DM5PR2101MB0727.namprd21.prod.outlook.com
 ([fe80::a5f2:8ec:f7d7:d0a5]) by DM5PR2101MB0727.namprd21.prod.outlook.com
 ([fe80::a5f2:8ec:f7d7:d0a5%7]) with mapi id 15.20.1813.005; Fri, 12 Apr 2019
 13:53:12 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
CC:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: RE: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Thread-Topic: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Thread-Index: AQHU8NyhHtEYGOraGE2RM0+eOP48VqY4emQwgAANt4CAAAHJEA==
Date:   Fri, 12 Apr 2019 13:53:12 +0000
Message-ID: <DM5PR2101MB0727DC31A50C8818952F0A67A0280@DM5PR2101MB0727.namprd21.prod.outlook.com>
References: <20190412030534.23402-1-lsahlber@redhat.com>
 <DM5PR2101MB0727698C9899BE431CFB1D6CA0280@DM5PR2101MB0727.namprd21.prod.outlook.com>
 <CAN05THQBUrimNWbBqVWsKL18eMDiWSyYryYS1PaMJ9P2R6AjGg@mail.gmail.com>
In-Reply-To: <CAN05THQBUrimNWbBqVWsKL18eMDiWSyYryYS1PaMJ9P2R6AjGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-04-12T13:53:10.7118464Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c994983c-d377-4260-ac13-05c93c47cfd6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [2601:18f:901:8a17::1003]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27c97230-bf1d-4b72-dfbc-08d6bf4e348a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600139)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR2101MB0934;
x-ms-traffictypediagnostic: DM5PR2101MB0934:
x-microsoft-antispam-prvs: <DM5PR2101MB0934A7A1EC4DA5289A3F5005A0280@DM5PR2101MB0934.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0005B05917
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(366004)(136003)(376002)(13464003)(189003)(199004)(186003)(305945005)(54906003)(86362001)(74316002)(7736002)(102836004)(97736004)(316002)(53546011)(6506007)(8936002)(6916009)(5660300002)(1411001)(8676002)(81156014)(81166006)(6116002)(76176011)(4326008)(10090500001)(25786009)(22452003)(7696005)(99286004)(71190400001)(71200400001)(86612001)(55016002)(46003)(6246003)(53936002)(476003)(8990500004)(11346002)(446003)(9686003)(2906002)(68736007)(14444005)(486006)(256004)(105586002)(478600001)(106356001)(52536014)(33656002)(6436002)(229853002)(10290500003)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0934;H:DM5PR2101MB0727.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nX9jgO5bscYJzIhqdpH0qZ6gtvbpldbhfuCHGQZLTwdbZVVzsJttXdn8RLkSfzQ9gIZOTchptxWpe3LtN/7lCIwZip71NkGP2b1P5KkzmxlmnEGEVsSLnbNlvjUMbXCtoKYYglwG2hIfPggBX9vt0XVLoSIgENjAG15hJ6w5ukqInIAMpH1lgwNzGFXWrBRwHZysBYjGdkU5ISMMZp2B0CwGeKWQWVbFQ9HJXGoc4Xc7Gi/ENhF03dacCyo/4jGyo1GSTDGk324kjdC4dvTKTiCYfDX+htyD4y84T1OnPT8CFOX4zCKt3ggtwRcZcBQSdEuMm5aBLbGRDwB/iB6PZlkCPAmkEWwnMSn9aMvrxsIcFvcFMZ+kzPyKXydp7kvsljkRapxRx8xLp0wtZ5xFRP6R6lwIko+sf9r/QPqo/z8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c97230-bf1d-4b72-dfbc-08d6bf4e348a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2019 13:53:12.7915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0934
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiByb25uaWUgc2FobGJlcmcgPHJv
bm5pZXNhaGxiZXJnQGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBBcHJpbCAxMiwgMjAxOSA5
OjM4IEFNDQo+IFRvOiBUb20gVGFscGV5IDx0dGFscGV5QG1pY3Jvc29mdC5jb20+DQo+IENjOiBS
b25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+OyBsaW51eC1jaWZzIDxsaW51eC0N
Cj4gY2lmc0B2Z2VyLmtlcm5lbC5vcmc+OyBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY2lmczogZml4IGJpLWRpcmVjdGlvbmFsIGZzY3Rs
IHBhc3N0aHJvdWdoIGNhbGxzDQo+IA0KPiBPbiBGcmksIEFwciAxMiwgMjAxOSBhdCAxMDo1MSBQ
TSBUb20gVGFscGV5IDx0dGFscGV5QG1pY3Jvc29mdC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogbGludXgtY2lmcy1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNpZnMtb3duZXJAdmdlci5rZXJuZWwub3JnPg0KPiBPbg0K
PiA+ID4gQmVoYWxmIE9mIFJvbm5pZSBTYWhsYmVyZw0KPiA+ID4gU2VudDogVGh1cnNkYXksIEFw
cmlsIDExLCAyMDE5IDExOjA2IFBNDQo+ID4gPiBUbzogbGludXgtY2lmcyA8bGludXgtY2lmc0B2
Z2VyLmtlcm5lbC5vcmc+DQo+ID4gPiBDYzogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5j
b20+OyBSb25uaWUgU2FobGJlcmcNCj4gPiA+IDxsc2FobGJlckByZWRoYXQuY29tPg0KPiA+ID4g
U3ViamVjdDogW1BBVENIXSBjaWZzOiBmaXggYmktZGlyZWN0aW9uYWwgZnNjdGwgcGFzc3Rocm91
Z2ggY2FsbHMNCj4gPiA+DQo+ID4gPiBTTUIyIElvY3RsIHJlc3BvbnNlcyBmcm9tIHNlcnZlcnMg
bWF5IHJlc3BvbmQgd2l0aCBib3RoIHRoZSByZXF1ZXN0IGJsb2INCj4gPiA+IGZyb20NCj4gPiA+
IHRoZSBjbGllbnQgZm9sbG93ZWQgYnkgdGhlIGFjdHVhbCByZXBseSBibG9iIGZvciBpb2N0bHMg
dGhhdCBhcmUgYmktZGlyZWN0aW9uYWwuDQo+ID4gPg0KPiA+ID4gSW4gdGhhdCBjYXNlIHdlIGNh
biBub3QgYXNzdW1lIHRoYXQgdGhlIHJlcGx5IGJsb2IgY29tZXMgaW1tZWRpYXRlbHkgYWZ0ZXIN
Cj4gPiA+IHRoZQ0KPiA+ID4gaW9jdGwgcmVzcG9uc2Ugc3RydWN0dXJlLg0KPiA+ID4NCj4gPiA+
IFRoaXMgZml4ZXMgRlNDVExzIHN1Y2ggYXMgU01CMjpGU0NUTF9RVUVSWV9BTExPQ0FURURfUkFO
R0VTDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogUm9ubmllIFNhaGxiZXJnIDxsc2FobGJl
ckByZWRoYXQuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZnMvY2lmcy9zbWIyb3BzLmMgfCA0ICsr
Ky0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9z
bWIyb3BzLmMNCj4gPiA+IGluZGV4IDBiN2UyYmUyYTc4MS4uNzY4ZjM1ZWE2M2NmIDEwMDY0NA0K
PiA+ID4gLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMNCj4gPiA+ICsrKyBiL2ZzL2NpZnMvc21iMm9w
cy5jDQo+ID4gPiBAQCAtMTQ2Nyw3ICsxNDY3LDkgQEAgc21iMl9pb2N0bF9xdWVyeV9pbmZvKGNv
bnN0IHVuc2lnbmVkIGludCB4aWQsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgcmMgPSAt
RUZBVUxUOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGdvdG8gaXFpbmZfZXhpdDsNCj4g
PiA+ICAgICAgICAgICAgICAgfQ0KPiA+ID4gLSAgICAgICAgICAgICBpZiAoY29weV90b191c2Vy
KHBxaSArIDEsICZpb19yc3BbMV0sIHFpLmlucHV0X2J1ZmZlcl9sZW5ndGgpKSB7DQo+ID4gPiAr
ICAgICAgICAgICAgIGlmIChjb3B5X3RvX3VzZXIoKGNoYXIgKilwcWkgKyBzaXplb2Yoc3RydWN0
IHNtYl9xdWVyeV9pbmZvKSwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAo
Y2hhciAqKWlvX3JzcCArIGxlMzJfdG9fY3B1KGlvX3JzcC0NCj4gPiA+ID5PdXRwdXRPZmZzZXQp
LA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHFpLmlucHV0X2J1ZmZlcl9s
ZW5ndGgpKSB7DQo+ID4NCj4gPiBTaG91bGRuJ3QgdGhpcyB2YWxpZGF0ZSB0aGF0IE91dHB1dE9m
ZnNldCwgZm9yIGEgbGVuZ3RoIG9mIGlucHV0X2J1ZmZlcl9sZW5ndGgsDQo+IGZhbGxzIGNvbXBs
ZXRlbHkgd2l0aGluIHRoZSBib3VuZHMgb2YgdGhlIHJlc3BvbnNlLCBiZWZvcmUgY29weWluZz8N
Cj4gDQo+IEkgdGhpbmsgY29weV90b191c2VyIGhhbmRsZXMgdGhhdA0KDQpBYnNvbHV0ZWx5IG5v
dCAtIGNvcHlfdG9fdXNlciBjYW5ub3QgdmFsaWRhdGUgU01CMiBtZXNzYWdlcywgYW5kIG9ubHkg
aGFuZGxlcw0KdXNlciBmYXVsdHMgKGRlc3RpbmF0aW9uIGJ1ZmZlciBub3Qgc291cmNlKS4NCg0K
SWYgdGhlIHNlcnZlciBpcyBidWdneSBvciBldmlsLCBPdXRwdXRPZmZzZXQgbWlnaHQgbGllIG91
dHNpZGUgdGhlIHJlc3BvbnNlLg0KDQpJZiB0aGUgcmVzcG9uc2UgcGF5bG9hZCBpcyBzaG9ydGVy
IHRoYW4gcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCwgdGhpcyBjb2RlIHdpbGwNCmNvcHkga2VybmVs
IG1lbW9yeSwgb3IgbWF5IHdhbGsgb2ZmIHRoZSBlbmQgb2YgYSBrZXJuZWwgcGFnZS4NCg0KQm90
aCB2ZXJ5IGJhZCB0aGluZ3M/DQoNCg0KPiANCj4gPg0KPiA+DQo+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgcmMgPSAtRUZBVUxUOw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGdvdG8g
aXFpbmZfZXhpdDsNCj4gPiA+ICAgICAgICAgICAgICAgfQ0KPiA+ID4gLS0NCj4gPiA+IDIuMTMu
Ng0KPiA+DQo=
