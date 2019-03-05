Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1767C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 15:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9518620657
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 15:49:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="VKBKgv5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfCEPtL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 10:49:11 -0500
Received: from mail-eopbgr820118.outbound.protection.outlook.com ([40.107.82.118]:23872
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728415AbfCEPtK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 10:49:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHr7dVUQ/a0JoLosmg3m1AT3w6Ki6+5jiXqdIPCa/B8=;
 b=VKBKgv5kqosnQ9e5DjR3aLlJlq4lTTjOZLSOpQeNAs9shJH7VfueHXw21i9op0fbPz4GRCmjO7qQG8QG2EiUJ25aMaWmq0fzOYuj4ScnhgNfYJJX+WmTg60BJtIwMEDGtLOQGq4oLF2/oY0zZFbnXxnSuswcUSQiR6cVHsk95hk=
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com (10.167.151.155) by
 SN4PR2101MB0736.namprd21.prod.outlook.com (10.167.151.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.5; Tue, 5 Mar 2019 15:49:06 +0000
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::bdda:b065:93f4:1f21]) by SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::bdda:b065:93f4:1f21%3]) with mapi id 15.20.1709.005; Tue, 5 Mar 2019
 15:49:06 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     =?utf-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: RE: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
Thread-Topic: [PATCH] CIFS: fix FSCTL_SET_REPARSE_POINT SMB2_ioctl() call
Thread-Index: AQHU0xq9XyKFsslMSEicH2eqt3gs6KX87EoAgAA1/ICAAAssAIAAAGAA
Date:   Tue, 5 Mar 2019 15:49:05 +0000
Message-ID: <SN4PR2101MB07366E71DC73195C78008628A0720@SN4PR2101MB0736.namprd21.prod.outlook.com>
References: <CAH2r5msqeMuatKpE2Kg6A+935zJ+yeocVHQTipQechbbgNrEXw@mail.gmail.com>
 <87woldmtjx.fsf@suse.com> <87r2blmklw.fsf@suse.com> <87o96pmir9.fsf@suse.com>
In-Reply-To: <87o96pmir9.fsf@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-03-05T15:49:04.1928908Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cef06c16-1624-4cc7-b6e4-6dd9f0843d3b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c01166e9-0179-4041-552d-08d6a1821942
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN4PR2101MB0736;
x-ms-traffictypediagnostic: SN4PR2101MB0736:
x-microsoft-antispam-prvs: <SN4PR2101MB0736C10CAD5195CFE6EF03C8A0720@SN4PR2101MB0736.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0967749BC1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(366004)(396003)(346002)(13464003)(189003)(199004)(5660300002)(105586002)(14454004)(106356001)(68736007)(66574012)(74316002)(486006)(476003)(86612001)(81166006)(478600001)(305945005)(8936002)(97736004)(53546011)(52536013)(8676002)(22452003)(86362001)(10290500003)(7736002)(81156014)(9686003)(6436002)(229853002)(7696005)(33656002)(53936002)(6246003)(76176011)(11346002)(6506007)(2906002)(102836004)(99286004)(446003)(55016002)(10090500001)(71200400001)(71190400001)(8990500004)(110136005)(186003)(93886005)(6346003)(6116002)(14444005)(66066001)(256004)(3846002)(26005)(25786009)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0736;H:SN4PR2101MB0736.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VNfaPUe5BNK3MhhqsK1TVVt2AsUsU84/mnVPKcdNk7FWEMPIg9ZtY5Yo4t2+YcqNAp/4DTNg9TibpyMOMGvU0jm82B6tzB6tjupeMzHqEh7skfnj/i0qO4ebdOwgNCAe6g/mQbQOz20SS4bMLtjVruBJ9jQDVe2xvGFl1Ds8nJEhvWZSnNdNoUMMnipkkcqT7xPz8NxM9MsY0Me09doN9t2xDJi+wkckS/Z91z7EqU+w4pPWScxrobzrCAsA/pwkVn0etL4bgc7d2keqkqt4+9RS09ONdlzboa+DdRETb0VZzDtp6Oy01wSctQGktosEOsfMYCupfsp4cKxB6DpacZA8H3EK8UO0eiqdjbXwS95TWk11RTROvVqyst6Etn4mmgbPBXhVDeV3Lx73dg1dcuW4fK2tRYaZQYGH1/a1lqI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01166e9-0179-4041-552d-08d6a1821942
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2019 15:49:05.9492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0736
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBBdXLDqWxpZW4gQXB0ZWwNCj4gU2VudDogVHVlc2RheSwgTWFyY2ggNSwgMjAxOSAx
MDo0MSBBTQ0KPiBUbzogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+OyBDSUZTIDxs
aW51eC1jaWZzQHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gQ0lGUzog
Zml4IEZTQ1RMX1NFVF9SRVBBUlNFX1BPSU5UIFNNQjJfaW9jdGwoKSBjYWxsDQo+IA0KPiBBdXLD
qWxpZW4gQXB0ZWwgPGFhcHRlbEBzdXNlLmNvbT4gd3JpdGVzOg0KPiA+IEkndmUgdHJpZWQgc2V0
dGluZyBNYXhPdXRwdXRSZXNwb25zZSB0byBzZXJ2ZXItPm1heEJ1ZiBvcg0KPiA+IENvbm5lY3Rp
b24uTWF4VHJhbnNhY3RTaXplIGJ1dCBpdCBhbHdheXMgZmFpbHMgdGhlIHNhbWUgd2F5Li4uIHNv
IEkNCj4gPiBkb24ndCBrbm93LiBJIGd1ZXNzIGl0IG11c3Qgc2F5IHNvbWV3aGVyZSB0aGF0IGlv
Y3RsKCkgd2l0aCBubyBvdXRwdXQNCj4gPiBzaG91bGQgc2V0IE1heE91dHB1dFJlc3BvbnNlIHRv
IHplcm8/DQo+IA0KPiBJJ3ZlIGp1c3QgY2hlY2tlZCB3aGF0IFdpbmRvd3MgZG9lcyBhbmQgaXQg
c2VlbXMgdG8gYmUgdGhhdCBhcw0KPiB3ZWxsLiBDcmVhdGluZyBhIHN5bWxpbmsgKG1rbGluayBs
aW5rIHRhcmdldCkgbWFrZXMgYW4NCj4gaW9jdGwoU0VUX1JFUEFSU0VfUE9JTlQpIHdpdGggTWF4
T3V0cHV0UmVzcG9uc2Ugc2V0IHRvIDAuDQo+IA0KPiBTbyBJIHdvdWxkIGtlZXAgdGhpcyBwYXRj
aCBhcyBpcy4NCg0KUmVtZW1iZXIgdGhhdCBpbiBhZGRpdGlvbiB0byB0aGUgU01CIHNlcnZlciB2
YWxpZGF0aW9uLCB0aGUgcmVxdWVzdCBnb2VzDQp0byB0aGUgZmlsZXN5c3RlbSwgd2hpY2ggaGFz
IGl0cyBvd24gdmFsaWRhdGlvbiBhbmQgZXJyb3Igc3RhdHVzIHJldHVybnMuIFRoZQ0KU1RBVFVT
X0lOVkFMSURfUEFSQU1FVEVSIGNhbiBjb21lIGJhY2sgZnJvbSBhbnkgbGF5ZXIuDQoNCklmIHRo
ZSBNYXhPdXRwdXRSZXNwb25zZSAhPSAwIHNldF9yZXBhcnNlX3BvaW50IGJlaGF2aW9yIGlzbid0
IGNvdmVyZWQNCmluIGVpdGhlciBNUy1TTUIyIG9yIE1TLUZTQSwgSSdtIGhhcHB5IHRvIHRha2Ug
YSBkb2MgYnVnLg0KDQpUb20uDQo=
