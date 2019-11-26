Return-Path: <SRS0=b7Yi=ZS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02218C43215
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 16:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24AB2073F
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Nov 2019 16:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="EkLvhsgd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKZQEv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 11:04:51 -0500
Received: from mail-eopbgr760114.outbound.protection.outlook.com ([40.107.76.114]:13948
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727418AbfKZQEu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 11:04:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZ1ZmTP2PUMCq9hDuXN+Fl2DBzBFr9Qt8fPRBZxZXfBs8gdki2uzTNXZ35rJJiuDAf+3MSvucCqZz8nN1gdEX/vudZPq+U+2gf0DvGE93Q/Af/Q9nFihAXU2S2UxIIPGkq4wT3/huD/h81dOJapcSnfRWCqMMoa+W8CXKbo/LRrk4uF5pM8AmjO6yA0klRxgUXOPyZYfIXvyTia2K6GQNl2yvoDBiqmXaQuikXmbiwf7I/duLo36u53V606foEYL2NKNB1nFqIrmK+k01M+l5A9p56CURHIKYJk8TtCoy9A17M3MReeTnXoJ4umDRcfUu+Ktvslz+YL/Lw5NeGRLLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UXSSm+jUNUfEDnCjSUmRrUcrZsGGJlSnOFLiAQ/wI8=;
 b=OzWTbWR13e+K8970DTqTICQVmh3tEOfkUys8yb/fHTOOSSInKWlQ20AampPp/VKOTPhCUGsGdMwrbdWRELUoKrTPA+bPk7RltDbUIO6F83xV/U9A6R0vGfcsElpebQlbBdun6kqdhtM9SbzTs7JLI4tyziB9Jnusv+glZ0C3YdtNaJ1dXtHa2FQWII2wcaMxc0VYNbjpNtkttHIfRasHtk8Ws03i79ho95L169YHBs/3gPnw+Y3WJVuezZS08f24fRN4FaPuyL8cdrlVZmGKGq0ZlnGFolQ+fTcKVfy7a51fWzkqhRuwLLlpMbZg1FA+Vb9kr3wYFgMp1E0vuCLx+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UXSSm+jUNUfEDnCjSUmRrUcrZsGGJlSnOFLiAQ/wI8=;
 b=EkLvhsgdqcMPjc2HUnH7C1u5EHdI+lC0IYyVXL45fv/vZcaNSjyygrhLYDmyYRP/6cX9Hf7j/6EBim/bSLlme+XF39cI/NE1nUgK02AUiqqYTkgJrGdrB6ddNF0iuKWqoWeYcg8wrYOqnsUu4IISjEdLyfl7TA/VL6E5B0geNGc=
Received: from DM6PR21MB1433.namprd21.prod.outlook.com (20.180.20.78) by
 DM6PR21MB1274.namprd21.prod.outlook.com (20.179.51.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.0; Tue, 26 Nov 2019 16:04:48 +0000
Received: from DM6PR21MB1433.namprd21.prod.outlook.com
 ([fe80::61e3:a64:c175:1d85]) by DM6PR21MB1433.namprd21.prod.outlook.com
 ([fe80::61e3:a64:c175:1d85%3]) with mapi id 15.20.2516.003; Tue, 26 Nov 2019
 16:04:48 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>
CC:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: RE: [EXTERNAL] Re: [PATCH v4 1/6] cifs: sort interface list by speed
Thread-Topic: [EXTERNAL] Re: [PATCH v4 1/6] cifs: sort interface list by speed
Thread-Index: AQHVkeUGXO5kI45L1kirBBlxN+y+z6eciwgAgAExhKA=
Date:   Tue, 26 Nov 2019 16:04:48 +0000
Message-ID: <DM6PR21MB1433DA86898BCD2C9687956EA0450@DM6PR21MB1433.namprd21.prod.outlook.com>
References: <20191103012112.12212-1-aaptel@suse.com>
 <20191103012112.12212-2-aaptel@suse.com>
 <CAKywueS3DpPkpeNprSUwrXw=ErZZsn3vRF6uVE646oCWC_8-4w@mail.gmail.com>
In-Reply-To: <CAKywueS3DpPkpeNprSUwrXw=ErZZsn3vRF6uVE646oCWC_8-4w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-11-26T16:04:46.7436917Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=482db2a3-e4de-49fd-9254-efc403ef6751;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5cacb98b-fdc4-47ea-0a1b-08d7728a5cda
x-ms-traffictypediagnostic: DM6PR21MB1274:
x-microsoft-antispam-prvs: <DM6PR21MB1274B68B2F48C881B15333F3A0450@DM6PR21MB1274.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(366004)(136003)(346002)(13464003)(199004)(189003)(76176011)(7696005)(6506007)(74316002)(229853002)(53546011)(8676002)(26005)(66066001)(4326008)(7736002)(305945005)(8990500004)(71190400001)(71200400001)(99286004)(102836004)(55016002)(6246003)(9686003)(33656002)(6436002)(54906003)(446003)(86362001)(5660300002)(2906002)(14454004)(8936002)(10090500001)(25786009)(66476007)(66556008)(64756008)(66446008)(10290500003)(66946007)(478600001)(110136005)(76116006)(22452003)(316002)(6116002)(3846002)(186003)(256004)(14444005)(81156014)(81166006)(52536014)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1274;H:DM6PR21MB1433.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJ51OocZCn4dHsqeKCQMwXPjhX2y1EZ2FnIKf5ygDQicY3Sz0l4T4CYAN5YDyNpnc71w5/cs9/FGHIIILqUpHt0HmWcvE9FGi7sHulX6vOAOt19SX1eg6wYnBO8qE+nA0WZAs3nZDG0C++BM+sTtKhveyv/9/S6m4yDZz2OCh9Zu9wMb20YDarrE01K0wz2OBBenD84iARN9gmN0RdxDRu7SgpiW8V91fyY+DW4ma2g66tPN+c6IQZrzDFHhRG6IJHhLLzR+irFz88gpsy5YDfl3Th5jd42Mreae4/E4KHFHDYtFGMbSJN4Sw/ypYnAYc23YSSYizEZAbYasK1gmzLtiMjERINpbh613N7OWhUrEFYnQXfVBpuTMcmRVogAyT54h641ECXcooVEPr4n5gFRBP0JoLXKiBwuz0P/2f6mdv+z/bZ7IPVjNrRalTq8A
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cacb98b-fdc4-47ea-0a1b-08d7728a5cda
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 16:04:48.4015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YZfavOwmOK4nKcVn8NujmYZ4yMg+wZETyzITeqbe3wZhf6M0US8NdwWAYTyu7OAIeIUwhSu2MT9X1wCjCZhpeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1274
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1jaWZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtY2lmcy1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+IEJl
aGFsZiBPZiBQYXZlbCBTaGlsb3Zza3kNCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAyNSwgMjAx
OSA0OjI5IFBNDQo+IFRvOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPg0KPiBDYzog
bGludXgtY2lmcyA8bGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc+OyBTdGV2ZSBGcmVuY2gNCj4g
PHNtZnJlbmNoQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1BBVENIIHY0
IDEvNl0gY2lmczogc29ydCBpbnRlcmZhY2UgbGlzdCBieSBzcGVlZA0KPiANCj4g0YHQsSwgMiDQ
vdC+0Y/QsS4gMjAxOSDQsy4g0LIgMTg6MjEsIEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3VzZS5j
b20+Og0KPiA+DQo+ID4gTmV3IGNoYW5uZWxzIGFyZSBnb2luZyB0byBiZSBvcGVuZWQgYnkgd2Fs
a2luZyB0aGUgbGlzdCBzZXF1ZW50aWFsbHksDQo+ID4gc28gYnkgc29ydGluZyBpdCB3ZSB3aWxs
IGNvbm5lY3QgdG8gdGhlIGZhc3Rlc3QgaW50ZXJmYWNlcyBmaXJzdC4NCg0KU29ydGluZyBieSBz
cGVlZCBpcyBkZWZpbml0ZWx5IGFwcHJvcHJpYXRlLCBidXQgc29ydGluZyB0aGUgb3RoZXINCm11
bHRpY2hhbm5lbCBhdHRyaWJ1dGVzIGlzIGp1c3QgYXMgaW1wb3J0YW50LiBGb3IgZXhhbXBsZSwg
aWYgdGhlDQpSRE1BIGF0dHJpYnV0ZSBpcyBzZXQsIHRoZSBhZGRyZXNzIHNob3VsZCBhY3R1YWxs
eSBiZSBleGNsdWRlZA0KZm9yIG5vbi1SRE1BIGNvbm5lY3Rpb25zIChhIHNlY29uZCwgbm9uLVJE
TUEgZW50cnkgaXMgaW5jbHVkZWQsDQppZiB0aGUgaW50ZXJmYWNlIHN1cHBvcnRzIGJvdGgpLiBB
bmQsIHRoZSBSU1MgYXR0cmlidXRlIGluZGljYXRlcyBhDQoiYmV0dGVyIiBkZXN0aW5hdGlvbiB0
aGFuIG5vbi1SU1MgZm9yIGEgZ2l2ZW4gc3BlZWQsIGJlY2F1c2UgaXQgaXMNCm1vcmUgZWZmaWNp
ZW50IGF0IGxvY2FsIHRyYWZmaWMgbWFuYWdlbWVudC4NCg0KU3VnZ2VzdCBhIGZvbGxvd29uIGVm
Zm9ydCB0byB0YWtlIGFkdmFudGFnZSBvZiB0aGVzZSwgYnkgZXhjbHVkaW5nDQppbmVsaWdpYmxl
IHBhdGhzLCBhbmQgcmFpc2luZyB0aGUgc29ydCBwcmlvcml0eSBvZiBvdGhlcnMuDQoNClRvbS4N
Cg0KPiA+IFNpZ25lZC1vZmYtYnk6IEF1cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3VzZS5jb20+DQo+
ID4gLS0tDQo+ID4gIGZzL2NpZnMvc21iMm9wcy5jIHwgMTEgKysrKysrKysrKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9mcy9j
aWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jDQo+ID4gaW5kZXggY2Q1NWFmOWI3Y2M1
Li5lYTYzNDU4MTc5MWEgMTAwNjQ0DQo+ID4gLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMNCj4gPiAr
KysgYi9mcy9jaWZzL3NtYjJvcHMuYw0KPiA+IEBAIC0xMCw2ICsxMCw3IEBADQo+ID4gICNpbmNs
dWRlIDxsaW51eC9mYWxsb2MuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3NjYXR0ZXJsaXN0Lmg+
DQo+ID4gICNpbmNsdWRlIDxsaW51eC91dWlkLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9zb3J0
Lmg+DQo+ID4gICNpbmNsdWRlIDxjcnlwdG8vYWVhZC5oPg0KPiA+ICAjaW5jbHVkZSAiY2lmc2ds
b2IuaCINCj4gPiAgI2luY2x1ZGUgInNtYjJwZHUuaCINCj4gPiBAQCAtNTU4LDYgKzU1OSwxMyBA
QCBwYXJzZV9zZXJ2ZXJfaW50ZXJmYWNlcyhzdHJ1Y3QNCj4gbmV0d29ya19pbnRlcmZhY2VfaW5m
b19pb2N0bF9yc3AgKmJ1ZiwNCj4gPiAgICAgICAgIHJldHVybiByYzsNCj4gPiAgfQ0KPiA+DQo+
ID4gK3N0YXRpYyBpbnQgY29tcGFyZV9pZmFjZShjb25zdCB2b2lkICppYSwgY29uc3Qgdm9pZCAq
aWIpDQo+ID4gK3sNCj4gPiArICAgICAgIGNvbnN0IHN0cnVjdCBjaWZzX3NlcnZlcl9pZmFjZSAq
YSA9IChzdHJ1Y3QgY2lmc19zZXJ2ZXJfaWZhY2UgKilpYTsNCj4gPiArICAgICAgIGNvbnN0IHN0
cnVjdCBjaWZzX3NlcnZlcl9pZmFjZSAqYiA9IChzdHJ1Y3QgY2lmc19zZXJ2ZXJfaWZhY2UgKilp
YjsNCj4gPiArDQo+ID4gKyAgICAgICByZXR1cm4gYS0+c3BlZWQgPT0gYi0+c3BlZWQgPyAwIDog
KGEtPnNwZWVkID4gYi0+c3BlZWQgPyAtMSA6IDEpOw0KPiA+ICt9DQo+ID4NCj4gPiAgc3RhdGlj
IGludA0KPiA+ICBTTUIzX3JlcXVlc3RfaW50ZXJmYWNlcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQ0KPiA+IEBAIC01ODcsNiArNTk1LDkgQEAgU01CM19y
ZXF1ZXN0X2ludGVyZmFjZXMoY29uc3QgdW5zaWduZWQgaW50IHhpZCwNCj4gc3RydWN0IGNpZnNf
dGNvbiAqdGNvbikNCj4gPiAgICAgICAgIGlmIChyYykNCj4gPiAgICAgICAgICAgICAgICAgZ290
byBvdXQ7DQo+ID4NCj4gPiArICAgICAgIC8qIHNvcnQgaW50ZXJmYWNlcyBmcm9tIGZhc3Rlc3Qg
dG8gc2xvd2VzdCAqLw0KPiA+ICsgICAgICAgc29ydChpZmFjZV9saXN0LCBpZmFjZV9jb3VudCwg
c2l6ZW9mKCppZmFjZV9saXN0KSwgY29tcGFyZV9pZmFjZSwgTlVMTCk7DQo+ID4gKw0KPiA+ICAg
ICAgICAgc3Bpbl9sb2NrKCZzZXMtPmlmYWNlX2xvY2spOw0KPiA+ICAgICAgICAga2ZyZWUoc2Vz
LT5pZmFjZV9saXN0KTsNCj4gPiAgICAgICAgIHNlcy0+aWZhY2VfbGlzdCA9IGlmYWNlX2xpc3Q7
DQo+ID4gLS0NCj4gPiAyLjE2LjQNCj4gPg0KPiANCj4gTG9va3MgZ29vZCBhdCB0aGUgZmlyc3Qg
Z2xhbmNlLCB0aGFua3MhDQo+IA0KPiBAU3RldmUsIHlvdSBtYXkgYWRkDQo+IA0KPiBBY2tlZC1i
eTogUGF2ZWwgU2hpbG92c2t5IDxwc2hpbG92QG1pY3Jvc29mdC5jb20+DQo+IA0KPiB0byB0aGlz
IGFuZCBvdGhlciBwYXRjaGVzIGluIHRoZSBzZXJpZXMuDQo+IA0KPiAtLQ0KPiBCZXN0IHJlZ2Fy
ZHMsDQo+IFBhdmVsIFNoaWxvdnNreQ0K
