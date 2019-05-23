Return-Path: <SRS0=I8HW=TX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1071FC282DD
	for <linux-cifs@archiver.kernel.org>; Thu, 23 May 2019 18:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67D12075E
	for <linux-cifs@archiver.kernel.org>; Thu, 23 May 2019 18:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="iyEsm2Pq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbfEWSYU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 May 2019 14:24:20 -0400
Received: from mail-eopbgr740115.outbound.protection.outlook.com ([40.107.74.115]:22720
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731237AbfEWSYU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 May 2019 14:24:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=j+/x+WVt2O153UMw0lA0BQsY0jsk6FUumg1kXSkFnVjvvqCwxlQVppsLzrXGbOCryMvU04Cs8pP8bTMWOkCM7ZClLib4vXTZEf75wDiwdBsRXUhqqRrOw3UIhkZumqZVrBNtoYrVmvS3QI5IVMi7edEdRPyiwtDJgl1zn3mAdac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnHj7F1NHJztX+S8H2Omosk3H6PcgtvQj8Ur51XQ7XE=;
 b=WnUpY5iJTWKFhZw6aHJ8BIBxFio8S3Ph4uLHp9r2nWauAzEU729VnURowxCkPWC2JaevibBCw4MBNs3V0V91qzwJ5H+Zkx4XTbVufjfYsENnQfvjsFw21h29uUOyKoRN0w8Cb3n0w+ELqH0dLooT7QdhDx7SoCVZn+YZ0Oirc7M=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnHj7F1NHJztX+S8H2Omosk3H6PcgtvQj8Ur51XQ7XE=;
 b=iyEsm2Pq2lQfoRIC/0a/i4zaV0DwHv8tKYWlkGtX4LT73IM8UzYmfEI2pIlkkgppPPGPbvBuEKxlmjFFwRbaIKM8ULknS5HEPg+v0i2DiB90Dhsm91j/vT5kfBK/1VtZx8tmHrYJG5cdr+ti0pJbMqlFgfIdBEchlkRBclT0ASE=
Received: from CY4PR21MB0149.namprd21.prod.outlook.com (2603:10b6:903:b2::19)
 by CY4PR21MB0632.namprd21.prod.outlook.com (2603:10b6:903:12e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1943.3; Thu, 23 May
 2019 18:24:16 +0000
Received: from CY4PR21MB0149.namprd21.prod.outlook.com
 ([fe80::557b:1240:94cb:8f77]) by CY4PR21MB0149.namprd21.prod.outlook.com
 ([fe80::557b:1240:94cb:8f77%9]) with mapi id 15.20.1943.007; Thu, 23 May 2019
 18:24:16 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Jeremy Allison <jra@samba.org>,
        Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: RE: [PATCH][SMB3] Add missing defines for new negotiate contexts
Thread-Topic: [PATCH][SMB3] Add missing defines for new negotiate contexts
Thread-Index: AQHU9gDJf2vMizjMXkSZLohRVXfnP6ZCKvuAgAYumJCAEUrw8IAfTKaAgABIIdA=
Date:   Thu, 23 May 2019 18:24:16 +0000
Message-ID: <CY4PR21MB014907F825DED7F5057E69E2A0010@CY4PR21MB0149.namprd21.prod.outlook.com>
References: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
 <20190418172353.GB236057@jra4>
 <BN8PR21MB11863B736AA5D284CC213118A0220@BN8PR21MB1186.namprd21.prod.outlook.com>
 <CY4PR21MB0149DC81B079BCD36D580AC5A0350@CY4PR21MB0149.namprd21.prod.outlook.com>
 <4591362b-cb4e-7e22-00a6-bf7239584957@samba.org>
In-Reply-To: <4591362b-cb4e-7e22-00a6-bf7239584957@samba.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-23T18:24:14.8917842Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=60cc6b91-783b-435d-92ad-2f59cbef9eee;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [2601:18f:902:71e2::1001]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36021535-165d-4d80-26e9-08d6dfabdd48
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:CY4PR21MB0632;
x-ms-traffictypediagnostic: CY4PR21MB0632:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CY4PR21MB0632FB69B671554C5EE806CFA0010@CY4PR21MB0632.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(136003)(39860400002)(376002)(189003)(199004)(13464003)(76176011)(7696005)(186003)(229853002)(102836004)(71190400001)(71200400001)(2906002)(33656002)(6506007)(53546011)(52396003)(53936002)(8990500004)(10090500001)(68736007)(14454004)(10290500003)(478600001)(74316002)(966005)(446003)(22452003)(55016002)(6306002)(9686003)(316002)(46003)(6436002)(476003)(99286004)(11346002)(256004)(14444005)(54906003)(486006)(66476007)(66556008)(86612001)(64756008)(66446008)(8676002)(110136005)(25786009)(4326008)(66946007)(6116002)(86362001)(52536014)(6246003)(7736002)(73956011)(5660300002)(305945005)(81166006)(76116006)(8936002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0632;H:CY4PR21MB0149.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aUPucgYIwoHhaTFxxyQqt5hRnWghDavgmvDuxSic4Fy+Z570sOhf1D06pKO7Nf71/lgFlrpvADOzYIkhaGi3JiBBp+h7AjnPxtAv6eisTB8BjMrJo225BgZwHlkofbXYJ26rYuiuDZ5VsE6ldt9nq53qIy3wFn224weMuR/s/kWsYezlLOadQu2OPNn4C4aNKTKY8+19kplExUx5xHGKjEKMVmtfisMpO4AgmR7cBUFwKPGG91P2fP/q2App+M/DKk+PZfUlRG1B62ONp7MOU2b1BZIuaHqkZLD2r2jlA3Fd/jgC6cUruf8zv2rJB7JFFTbr76kvCAgECxQPfCPVWwlqflbT6YEPusqQsL5Ph2uJuLgA3M+2/ip9pugg9XP7aYAHKHavoT5SgQ6eofbmdnk8oc8RhakiCfVd+ntLGx4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36021535-165d-4d80-26e9-08d6dfabdd48
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 18:24:16.3177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ttalpey@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0632
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTdGVmYW4gTWV0em1hY2hlciA8
bWV0emVAc2FtYmEub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDIzLCAyMDE5IDk6NTEgQU0N
Cj4gVG86IFRvbSBUYWxwZXkgPHR0YWxwZXlAbWljcm9zb2Z0LmNvbT47IEplcmVteSBBbGxpc29u
IDxqcmFAc2FtYmEub3JnPjsNCj4gU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+DQo+
IENjOiBDSUZTIDxsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZz47IHNhbWJhLXRlY2huaWNhbCA8
c2FtYmEtDQo+IHRlY2huaWNhbEBsaXN0cy5zYW1iYS5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0hdW1NNQjNdIEFkZCBtaXNzaW5nIGRlZmluZXMgZm9yIG5ldyBuZWdvdGlhdGUgY29udGV4dHMN
Cj4gDQo+IEhpIFRvbSwNCj4gDQo+ID4+IFRoZSBXaW5kb3dzIHByb3RvY29sIGRvY3VtZW50cyB3
ZXJlIHVwZGF0ZWQgb24gTWFyY2ggMTMgZm9yIHRoZQ0KPiA+PiB1cGNvbWluZyAiMTlIMSIgdXBk
YXRlIGN5Y2xlLg0KPiA+Pg0KPiA+PiBNUy1TTUIyIHZlcnNpb24gcGFnZSwgd2l0aCBsYXRlc3Qs
IGRpZmZzLCBldGM6DQo+ID4+DQo+ID4+IGh0dHBzOi8vZG9jcy5taWNyb3NvZnQuY29tL2VuLXVz
L29wZW5zcGVjcy93aW5kb3dzX3Byb3RvY29scy9tcy0NCj4gc21iMi81NjA2YWQ0Ny01ZWUwLTQz
N2EtODE3ZS03MGMzNjYwNTI5NjINCj4gPg0KPiA+IFNvLCB0aGVyZSB3YXMgYSBkZWZlY3QgaW4g
dGhlIHB1Ymxpc2hlZCBzcGVjIHdoaWNoIHdlIGp1c3QgY29ycmVjdGVkLCB0aGVyZSdzIGENCj4g
bmV3DQo+ID4gdXBkYXRlIG9ubGluZSBhdCB0aGUgYWJvdmUgcGFnZS4NCj4gPg0KPiA+IFRoZSB2
YWx1ZSBvZiB0aGUgbmV3IGNvbXByZXNzaW9uIGNvbnRleHRpZCBpcyBhY3R1YWxseSAiMyIsIGJ1
dCB0aGUgZWFybGllcg0KPiBkb2N1bWVudA0KPiA+IGluY29ycmVjdGx5IHNhaWQgIjQiLiBUaGVy
ZSB3ZXJlIHNldmVyYWwgb3RoZXIgZml4ZXMgYW5kIGNsYXJpZmljYXRpb25zIGluIHRoZQ0KPiBw
aXBlbGluZQ0KPiA+IHdoaWNoIGhhdmUgYWxzbyBiZWVuIGluY2x1ZGVkLg0KPiA+DQo+ID4gUmVk
bGluZSBkaWZmcyBhcyB3ZWxsIGFzIHRoZSB1c3VhbCBzdGFuZGFyZCBwdWJsaWNhdGlvbiBmb3Jt
YXRzIGFyZSBhdmFpbGFibGUuDQo+IA0KPiBUaGVyZSdzIG5vIHNlcnZlciBiZWhhdmlvciBkZWZp
bmVkIGZvcg0KPiBTTUIyX05FVE5BTUVfTkVHT1RJQVRFX0NPTlRFWFRfSUQuIElmIHRoZXJlJ3Mg
bm9uZSwgd2h5IHdhcyBpdCBhZGRlZA0KPiBhdCBhbGw/DQoNCkl0J3MgYW4gYWR2aXNvcnkgcGF5
bG9hZCwgYW5kIGNhbiBiZSB1c2VkIHRvIGRpcmVjdCB0aGUgY29ubmVjdGlvbiBhcHByb3ByaWF0
ZWx5DQpieSBsb2FkIGJhbGFuY2Vycywgc2VydmVycyBob3N0aW5nIG11bHRpcGxlIG5hbWVzLCBh
bmQgdGhlIGxpa2UuIEl0J3MgYmFzaWNhbGx5IHRoZQ0Kc2FtZSBzZXJ2ZXJuYW1lIHRoYXQgd2ls
bCBiZSBwcmVzZW50ZWQgbGF0ZXIgaW4gU01CMl9UUkVFX0NPTk5FQ1QsIG9ubHkgaXQncw0KYXZh
aWxhYmxlIGVhcmx5LCBwcmlvciB0byBhbnkgU01CMyBwcm9jZXNzaW5nLiBPdGhlciBwb3NzaWJs
ZSB1c2VzIGFyZSBmb3IgbG9nZ2luZw0KYW5kIGRpYWdub3Npcy4NCg0KSXQgaGFzIG5vIGFjdHVh
bCBmdW5jdGlvbiBpbiB0aGUgU01CMyBwcm90b2NvbCwgc28gYXBhcnQgZnJvbSBkZWZpbmluZyB0
aGUgcGF5bG9hZA0KaXQncyBub3QgYSBtYXR0ZXIgZm9yIHRoZSBNUy1TTUIyIGRvY3VtZW50LiBX
ZSB3b3VsZCBob3BlLCBob3dldmVyLCB0aGF0IGNsaWVudHMNCndpbGwgaW5jbHVkZSB0aGUgY29u
dGV4dCB3aGVuIHNlbmRpbmcgU01CMl9ORUdPVElBVEUuDQoNClRvbS4NCg==
