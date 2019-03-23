Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6032C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 00:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878D92147A
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 00:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="ZZ7TVUR/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfCWAUX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:20:23 -0400
Received: from mail-eopbgr720131.outbound.protection.outlook.com ([40.107.72.131]:2432
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726910AbfCWAUW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 22 Mar 2019 20:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GuGnoO24PrmR8mzIsurqFdNXZJwIp/+RELKXyPwHl2g=;
 b=ZZ7TVUR/AEgETDOCsC3RZRvfSkAeOXc5QGNtaobLIl+kZxSnRKVW5iWuXhhM71NKNevAPG2opguojA58/8MyTwvTcUhBcNu5/PoxrUqHiUiKbFaLEOLvCl615eVDjnFSQ+wsdDaLSps58v2XIlKWNb+LOgF+XBbauyLVx+N12Go=
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com (10.167.151.155) by
 SN4PR2101MB0735.namprd21.prod.outlook.com (10.167.151.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.7; Sat, 23 Mar 2019 00:20:14 +0000
Received: from SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::804d:6cd0:c000:791c]) by SN4PR2101MB0736.namprd21.prod.outlook.com
 ([fe80::804d:6cd0:c000:791c%3]) with mapi id 15.20.1750.005; Sat, 23 Mar 2019
 00:20:14 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
CC:     Andreas Hasenack <andreas@canonical.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH] cifs: allow guest mounts to work for smb3.11
Thread-Topic: [PATCH] cifs: allow guest mounts to work for smb3.11
Thread-Index: AQHU36LexjTIewpeiEaigDRjL0W98aYWU3sAgAAs54CAAc7JgIAACyEg
Date:   Sat, 23 Mar 2019 00:20:14 +0000
Message-ID: <SN4PR2101MB07363664AD92F12AFB733698A05C0@SN4PR2101MB0736.namprd21.prod.outlook.com>
References: <20190321045902.14326-1-lsahlber@redhat.com>
 <CANYNYEHur0w8iNZBHUbc=NJopAH84gLb5k-Wv1ShU9--qREoCw@mail.gmail.com>
 <CAN05THSL-KCQ6QNm2fUERY1oHWC_jgfdWHuEO_0gnwLMM3TX1A@mail.gmail.com>
 <CAH2r5mua942M3C=8Mionj_JbjRm5LRm+=+f1SW3404a-k6naFQ@mail.gmail.com>
In-Reply-To: <CAH2r5mua942M3C=8Mionj_JbjRm5LRm+=+f1SW3404a-k6naFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-03-23T00:20:12.9553794Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=8c53d045-1ac8-4fd8-b8d8-4221eb856536;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 485b874b-fe22-4d7e-8a64-08d6af25522d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:SN4PR2101MB0735;
x-ms-traffictypediagnostic: SN4PR2101MB0735:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <SN4PR2101MB0735D6D7E9CF4585B5CB7E80A05C0@SN4PR2101MB0735.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0985DA2459
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(366004)(396003)(136003)(13464003)(199004)(189003)(7736002)(478600001)(186003)(52536014)(4326008)(25786009)(53936002)(68736007)(14444005)(26005)(305945005)(110136005)(6246003)(6306002)(256004)(6346003)(8936002)(6436002)(6506007)(76176011)(9686003)(229853002)(55016002)(53546011)(102836004)(8676002)(86362001)(2906002)(81166006)(81156014)(54906003)(14454004)(7696005)(11346002)(10290500003)(33656002)(71190400001)(105586002)(446003)(486006)(106356001)(22452003)(476003)(8990500004)(71200400001)(86612001)(93886005)(966005)(316002)(97736004)(5660300002)(74316002)(66066001)(6116002)(3846002)(10090500001)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0735;H:SN4PR2101MB0736.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qXtAHPKCqUosu9pCaLhuCoz7oOXyvyWfshUVo/+FPgr2SpojvcwSEg73+NxkLe3fNmSy2pru2m2Oqbe4R0bewYSfiwY+K/JCHv7gDg9cxqjndGjFxiGyFmbWuL/06NbH9MQi/qv4A1WV9P0lLQmVdcJUxhz7yworrh/F8oG9XnaoCg74A1rHZc62ghl7ms+3YRZ7fG3Gc4TkOusM+gINY2D5H1e88X4MX4/wLFvY3dIzWClOEnA1V+CWMFc/lAJ7g0YL6f68HzNctzS3m7AtqlZzIUdO+d/kp+u3ai7wsWs6eNZEE2M/Io2A6EV6yQsz0hr+iOnMwyjaYBNjsiBcFGl3NAlKai5QHEjNK7TDZOCUWRtpXzpWgpBcmuFc7QJtEkDvifUmLYtCGdwOrTPyMJEqU0IkMivs3IXyskHh3Bw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485b874b-fe22-4d7e-8a64-08d6af25522d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2019 00:20:14.5233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0735
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBTdGV2ZSBGcmVuY2gNCj4gU2VudDogRnJpZGF5LCBNYXJjaCAyMiwgMjAxOSA3OjMw
IFBNDQo+IFRvOiByb25uaWUgc2FobGJlcmcgPHJvbm5pZXNhaGxiZXJnQGdtYWlsLmNvbT4NCj4g
Q2M6IEFuZHJlYXMgSGFzZW5hY2sgPGFuZHJlYXNAY2Fub25pY2FsLmNvbT47IFJvbm5pZSBTYWhs
YmVyZw0KPiA8bHNhaGxiZXJAcmVkaGF0LmNvbT47IGxpbnV4LWNpZnMgPGxpbnV4LWNpZnNAdmdl
ci5rZXJuZWwub3JnPjsgU3RhYmxlDQo+IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIXSBjaWZzOiBhbGxvdyBndWVzdCBtb3VudHMgdG8gd29yayBmb3Igc21i
My4xMQ0KPiANCj4gSSB0cmllZCB0byBTYW1iYSB3aXRoIGd1ZXN0IG1vdW50IGFuZCBub3RlZCB0
aGF0IFNhbWJhIHNlcnZlciBkaWQgbm90DQo+IHNldCB0aGUgZ3Vlc3Qgb3IgbnVsbCBmbGFncyBp
biB0aGUgc2Vzc2lvbiBzZXR1cCByZXNwb25zZSBzbyB3ZSBzdGlsbA0KPiBtYXJrZWQgdGNvbiBh
cyBzaWduZWQgZXZlbiB3aXRoIGd1ZXN0IG1vdW50IGluIG15IHF1aWNrIHRlc3QgKHRvIFNhbWJh
DQo+IDQuMTApDQoNClRoaXMgZ2V0cyB0byB0aGUgcG9pbnQgb2YgbXkgZWFybGllciBjb21tZW50
LiBUaGUgZmxhZ3MgYW5kIGRpYWxlY3QgZXRjDQphcmUgYWxsIGZpbmUgdG8gY2hlY2ssIGJ1dCB0
aGUgY29kZSBpcyBzZXR0aW5nIHRoZSBTSUdORUQgYml0IGJlZm9yZSBpdA0KYWN0dWFsbHkgc2ln
bnMuIFNob3VsZG4ndCBpdCBiZSB2ZXJpZnlpbmcgdGhhdCBpdCBoYXMgYSB2YWxpZCBzaWduaW5n
IGtleQ0KYmVmb3JlIGl0IGRvZXMgdGhpcz8NCg0KQW5vdGhlciBwb2ludCB0byBtYWtlIGhlcmUg
aXMgdGhhdCB0aGUgU0VTU0lPTl9JU19HVUVTVCBpcyBlbnRpcmVseQ0KdGhlIHNlcnZlcidzIGNo
b2ljZS4gQmFzaWNhbGx5LCB3aGF0IGl0IG1lYW5zIGlzIHRoZSBzZXJ2ZXIgYXJiaXRyYXJpbHkN
CmF1dGhlbnRpY2F0ZWQgdGhlIHVzZXIgYXMgYSBndWVzdCwgcmVnYXJkbGVzcyBvZiBob3cgdGhl
IGNsaWVudCBhdHRlbXB0ZWQNCnRvIGxvZyBpbi4gSWYgaXQncyBzZXQsIHRoZW4gYWJzb2x1dGVs
eSB0aGUgY2xpZW50IHNob3VsZCBmb3JnZXQgdGhhdCBpdCBldmVyDQphdHRlbXB0ZWQgdG8gYXV0
aGVudGljYXRlIGFzIGEgZ2l2ZW4gcHJpbmNpcGFsIChhbmQgbm90IHNpZ24sIGVuY3J5cHQsIGV0
YykuDQpIb3dldmVyLCBpZiBpdCdzIGNsZWFyLCBhbmQgdGhlIHNlcnZlciBtYWRlIHRoZSB1c2Vy
ICJndWVzdCIsIHRoZW46DQoNCiBhKSB0aGUgc2VydmVyIGlzIGFyZ3VhYmx5IGJ1Z2d5DQogYikg
dGhlIHNpZ25pbmcgZmFpbHVyZSBpcyBieSBwcm90b2NvbCBkZXNpZ24uDQoNClRvbS4NCg0KPiBP
biBUaHUsIE1hciAyMSwgMjAxOSBhdCAyOjU0IFBNIHJvbm5pZSBzYWhsYmVyZw0KPiA8cm9ubmll
c2FobGJlcmdAZ21haWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgTWFyIDIyLCAyMDE5
IGF0IDM6MTMgQU0gQW5kcmVhcyBIYXNlbmFjaw0KPiA8YW5kcmVhc0BjYW5vbmljYWwuY29tPiB3
cm90ZToNCj4gPiA+DQo+ID4gPiBIZWxsbyBSb25uaWUsDQo+ID4gPg0KPiA+ID4gT24gVGh1LCBN
YXIgMjEsIDIwMTkgYXQgMTo1OSBBTSBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5j
b20+DQo+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBGaXggR3Vlc3QvQW5vbnltb3VzIHNlc3Np
b25zIHNvIHRoYXQgdGhleSB3b3JrIHdpdGggU01CIDMuMTEuDQo+ID4gPiA+DQo+ID4gPiA+IElu
IGdpdCBjb21taXQgNjE4OGYyOCB0aWdodGVuZWQgdGhlIGNvbmRpdGlvbnMgYW5kIGZvcmNlZCBz
aWduaW5nIGZvcg0KPiA+ID4gPiB0aGUgU01CMi1UcmVlQ29ubmVjdCBjb21tYW5kcyBhcyBwZXIg
TVMtU01CMi4NCj4gPiA+ID4gSG93ZXZlciwgdGhpcyBzaG91bGQgb25seSBhcHBseSB0byBub3Jt
YWwgdXNlciBzZXNzaW9ucyBhbmQgbm90IGZvcg0KPiA+ID4gPiBHdWVzdC9Bbm9udW1vdXMgc2Vz
c2lvbnMuDQo+ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFJvbm5pZSBTYWhsYmVyZyA8
bHNhaGxiZXJAcmVkaGF0LmNvbT4NCj4gPiA+ID4gQ0M6IFN0YWJsZSA8c3RhYmxlQHZnZXIua2Vy
bmVsLm9yZz4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBmcy9jaWZzL3NtYjJwZHUuYyB8IDggKysr
KysrLS0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBi
L2ZzL2NpZnMvc21iMnBkdS5jDQo+ID4gPiA+IGluZGV4IGMzOTllMDliNzZlNi4uOGU0YTFkYTk1
NDE4IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9mcy9jaWZzL3NtYjJwZHUuYw0KPiA+ID4gPiArKysg
Yi9mcy9jaWZzL3NtYjJwZHUuYw0KPiA+ID4gPiBAQCAtMTYyOCw5ICsxNjI4LDEzIEBAIFNNQjJf
dGNvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QNCj4gY2lmc19zZXMgKnNlcywgY29u
c3QgY2hhciAqdHJlZSwNCj4gPiA+ID4gICAgICAgICBpb3ZbMV0uaW92X2Jhc2UgPSB1bmNfcGF0
aDsNCj4gPiA+ID4gICAgICAgICBpb3ZbMV0uaW92X2xlbiA9IHVuY19wYXRoX2xlbjsNCj4gPiA+
ID4NCj4gPiA+ID4gLSAgICAgICAvKiAzLjExIHRjb24gcmVxIG11c3QgYmUgc2lnbmVkIGlmIG5v
dCBlbmNyeXB0ZWQuIFNlZSBNUy1TTUIyDQo+IDMuMi40LjEuMSAqLw0KPiA+ID4gPiArICAgICAg
IC8qDQo+ID4gPiA+ICsgICAgICAgICogMy4xMSB0Y29uIHJlcSBtdXN0IGJlIHNpZ25lZCBpZiBu
b3QgZW5jcnlwdGVkLiBTZWUgTVMtU01CMg0KPiAzLjIuNC4xLjENCj4gPiA+ID4gKyAgICAgICAg
KiB1bmxlc3MgaXQgaXMgZ3Vlc3Qgb3IgYW5vbnltb3VzIHVzZXIuIFNlZSBNUy1TTUIyIDMuMi41
LjMuMQ0KPiA+ID4gPiArICAgICAgICAqLw0KPiA+ID4gPiAgICAgICAgIGlmICgoc2VzLT5zZXJ2
ZXItPmRpYWxlY3QgPT0gU01CMzExX1BST1RfSUQpICYmDQo+ID4gPiA+IC0gICAgICAgICAgICFz
bWIzX2VuY3J5cHRpb25fcmVxdWlyZWQodGNvbikpDQo+ID4gPiA+ICsgICAgICAgICAgICFzbWIz
X2VuY3J5cHRpb25fcmVxdWlyZWQodGNvbikgJiYNCj4gPiA+ID4gKyAgICAgICAgICAgIShzZXMt
PnNlc3Npb25fZmxhZ3MgJg0KPiAoU01CMl9TRVNTSU9OX0ZMQUdfSVNfR1VFU1R8U01CMl9TRVNT
SU9OX0ZMQUdfSVNfTlVMTCkpKQ0KPiA+ID4gPiAgICAgICAgICAgICAgICAgcmVxLT5zeW5jX2hk
ci5GbGFncyB8PSBTTUIyX0ZMQUdTX1NJR05FRDsNCj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICBt
ZW1zZXQoJnJxc3QsIDAsIHNpemVvZihzdHJ1Y3Qgc21iX3Jxc3QpKTsNCj4gPiA+ID4gLS0NCj4g
PiA+ID4gMi4xMy42DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4NCj4gPiA+IEkgdHJpZWQgdGhpcyBw
YXRjaCB3aXRoIGFuIHVidW50dSBrZXJuZWwNCj4gPiA+DQo+IChodHRwczovL25hbTA2LnNhZmVs
aW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHM6JTJGJTJGcGVvcGxlLmNhbg0K
PiBvbmljYWwuY29tJTJGfnR5aGlja3MlMkZkaXNjby0NCj4gY2lmcy4yJTJGJmFtcDtkYXRhPTAy
JTdDMDElN0N0dGFscGV5JTQwbWljcm9zb2Z0LmNvbSU3QzNjYzk3YmY5NDgyDQo+IDc0N2FmZDE2
ZDA4ZDZhZjFlNjJmZiU3QzcyZjk4OGJmODZmMTQxYWY5MWFiMmQ3Y2QwMTFkYjQ3JTdDMSU3QzAN
Cj4gJTdDNjM2ODg4OTQyMzg1MzQ3OTM3JmFtcDtzZGF0YT1pMGtVWjR5aW5xamd2c0REYzBONkxC
VFBsTHQ4RGVObnQNCj4gV1cxUGhTMHhWZyUzRCZhbXA7cmVzZXJ2ZWQ9MCBzcGVjaWZpY2FsbHkp
IGJ1dA0KPiA+ID4gaXQgZGlkbid0IHdvcmssIEknbSBzdGlsbCBnZXR0aW5nIGZhaWx1cmVzIHdp
dGggc21iMy4xMSBhbmQgYSBndWVzdA0KPiA+ID4gbW91bnQuDQo+ID4gPg0KPiA+ID4gTWF5YmUg
SSdtIG1pc3Npbmcgc29tZSBvdGhlciBmaXgsIG9yIGEgbW9yZSB1cC10by1kYXRlIGtlcm5lbD8g
U2hhbGwgSQ0KPiA+ID4gdHJ5IHdpdGggYSBzZWxmLWNvbXBpbGVkIHVwc3RyZWFtIG9uZT8NCj4g
Pg0KPiA+IFRyeSB3aXRoIHRoZSBjdXJyZW50IHZlcnNpb24gb2YgU3RldmUncyBmb3ItbmV4dCBi
cmFuY2ggcGx1cyB0aGlzIHBhdGNoLg0KPiA+IEkgY291bGQgcmVwcm9kdWNlIHRoZSBmYWlsdXJl
IHdpdGggMy4xMSBvbiBmb3ItbmV4dA0KPiA+IGJ1dCB3aGVuIEkgYWRkZWQgdGhpcyBwYXRjaCB0
aGVuIHRoZSBtb3VudCB3YXMgc3VjY2Vzc2Z1bC4NCj4gPg0KPiA+IEF0IGxlYXN0IHRoYXQgd291
bGQgdmVyaWZ5IHRoYXQgdGhlIGN1cnJlbnQgZm9yLW5ldCB3b3JrcyBmb3IgeW91IChvciBub3Qp
Lg0KPiA+IFRoZXJlIG1heSBiZSBvdGhlciB0aGluZ3MgbWlzc2luZyBpbiBvbGRlciBrZXJuZWxz
IHRoYXQgYnJva2UgMy4xMSBndWVzdA0KPiBtb3VudHMsDQo+ID4gYnV0IGxldHMgY2hlY2sgaWYg
Zm9yLW5leHQgd29ya3MgZmlyc3QuDQo+ID4NCj4gPiBSZWdhcmRzDQo+ID4gUm9ubmllIFNhaGxi
ZXJnDQo+ID4NCj4gPiA+DQo+ID4gPiBkbWVzZzoNCj4gaHR0cHM6Ly9uYW0wNi5zYWZlbGlua3Mu
cHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHAlM0ElMkYlMkZwYXN0ZS51Yg0KPiB1bnR1
LmNvbSUyRnAlMkZKR2hDc2dCVmNiJTJGJmFtcDtkYXRhPTAyJTdDMDElN0N0dGFscGV5JTQwbWlj
cm9zDQo+IG9mdC5jb20lN0MzY2M5N2JmOTQ4Mjc0N2FmZDE2ZDA4ZDZhZjFlNjJmZiU3QzcyZjk4
OGJmODZmMTQxYWY5MWFiMmQNCj4gN2NkMDExZGI0NyU3QzElN0MwJTdDNjM2ODg4OTQyMzg1MzQ3
OTM3JmFtcDtzZGF0YT1yNWVNaFhrcyUyRg0KPiBxdW9OenpoRmFoQ0tqTU9FMjJmRmxWQ2x1d21S
TFdwbU9jJTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4gPg0KPiA+ID4gc2VydmVyIGxvZ3MgKGRlYnVn
IGxldmVsIDUsIHNhbWJhIDQuMTAuMCk6DQo+ID4gPiBsb2cuOg0KPiBodHRwczovL25hbTA2LnNh
ZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUyRiUyRnBhc3RlLnVi
DQo+IHVudHUuY29tJTJGcCUyRmpNREo4REJmUk0lMkYmYW1wO2RhdGE9MDIlN0MwMSU3Q3R0YWxw
ZXklNDBtaWNyDQo+IG9zb2Z0LmNvbSU3QzNjYzk3YmY5NDgyNzQ3YWZkMTZkMDhkNmFmMWU2MmZm
JTdDNzJmOTg4YmY4NmYxNDFhZjkxYWINCj4gMmQ3Y2QwMTFkYjQ3JTdDMSU3QzAlN0M2MzY4ODg5
NDIzODUzNDc5MzcmYW1wO3NkYXRhPTRvd3FQRGJnYw0KPiBGT2pRVSUyQkV0MmFCMVA3N2hGSGJJ
dXpveE9rZHBYNVgyZUUlM0QmYW1wO3Jlc2VydmVkPTANCj4gPiA+IGxvZy5zbWJkOg0KPiBodHRw
czovL25hbTA2LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUy
RiUyRnBhc3RlLnViDQo+IHVudHUuY29tJTJGcCUyRlo5VzV6MjhCUDklMkYmYW1wO2RhdGE9MDIl
N0MwMSU3Q3R0YWxwZXklNDBtaWNyDQo+IG9zb2Z0LmNvbSU3QzNjYzk3YmY5NDgyNzQ3YWZkMTZk
MDhkNmFmMWU2MmZmJTdDNzJmOTg4YmY4NmYxNDFhZjkxYWINCj4gMmQ3Y2QwMTFkYjQ3JTdDMSU3
QzAlN0M2MzY4ODg5NDIzODUzNTc5MzgmYW1wO3NkYXRhPTY2TmcwcXJkYnQNCj4gQXdWaXJ4cU4z
dVdqRWFGclJpMXc2WEdjWCUyQlpJVG1rT00lM0QmYW1wO3Jlc2VydmVkPTANCj4gPiA+IHNtYi5j
b25mOg0KPiBodHRwczovL25hbTA2LnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91
cmw9aHR0cCUzQSUyRiUyRnBhc3RlLnViDQo+IHVudHUuY29tJTJGcCUyRjlIcFN5RnE4bjglMkYm
YW1wO2RhdGE9MDIlN0MwMSU3Q3R0YWxwZXklNDBtaWNybw0KPiBzb2Z0LmNvbSU3QzNjYzk3YmY5
NDgyNzQ3YWZkMTZkMDhkNmFmMWU2MmZmJTdDNzJmOTg4YmY4NmYxNDFhZjkxYWIyDQo+IGQ3Y2Qw
MTFkYjQ3JTdDMSU3QzAlN0M2MzY4ODg5NDIzODUzNTc5MzgmYW1wO3NkYXRhPVU0ZHF2MjNkWk4N
Cj4gS2dhREFSMlRiRW1zcm5rUjZFbnFlamRWVFBWTHBJaktrJTNEJmFtcDtyZXNlcnZlZD0wDQo+
IA0KPiANCj4gDQo+IC0tDQo+IFRoYW5rcywNCj4gDQo+IFN0ZXZlDQo=
