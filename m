Return-Path: <SRS0=IbS0=V6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC26C32750
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Aug 2019 06:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 452862087E
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Aug 2019 06:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wallix.onmicrosoft.com header.i=@wallix.onmicrosoft.com header.b="WBKoaJH+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389249AbfHBG72 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Aug 2019 02:59:28 -0400
Received: from mail-eopbgr10045.outbound.protection.outlook.com ([40.107.1.45]:14466
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733135AbfHBG71 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 2 Aug 2019 02:59:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1IA8rlJOIC8gj7xeq67YV2pReCy7NalLIUXhiWE1q9+KBheiN2M+j5mROku3TaT/QpOopp10Ypz+FNstZnDZvhxc765h0/NjgUeUhstayPdjnGV2dwZnw/PR4oZHx+//TCcOg/HMLrVluCM1/RybdbYHaGQFxnGvee/mBQ2FoU2I2hDcySxcwtFEiLEjajm3LdykNUR6Da8Vbwj9L9GVSRSOq1iVH/iN1wBTuJmIc1jZmLCFF3JZZCTQFNNH6wWGjvjwR+Tb4eIGT+L87SgstiGRUxascz1pGwOxnCdm255N8DaCkCpzO4PRUq/4J6zaekYRdA/fi3P4bXPqcN03A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1sBj8eVWfmYtq61mrC0Etl/alJwheg8nfae/xJr2X0=;
 b=HYakVBbrjvYfFZ+FyNdf06GwUN6fC1A5TKcF9+Xh5RadqKzXrRooVcawlU5h42srZwAxMJoZMuYNVgg+kPL4W0+4TxgeXtIECgGrM2I2JQKlPU7Q+A51nr3zhUprBr57hDGA6Ky1hUr4rTodzqQ+Y4PpRcz+oYOo/Kj4j5hicB5eliC2muOeDFSlgazYbflG7Etsu7dQC8QMwy8sW0uVAhWM4Y6SrIc5jfT/KIOJuwkntS2YjzPFL4s4JkHOQpKHcjgUCMJWtA8jBx2vBVqgWLcRUG6rOQ8g/YW4buheL5oSbY8gT4q3F95Gq2C2IQYoyY7AzIxjAUuUINHu5jbQVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wallix.com;dmarc=pass action=none
 header.from=wallix.com;dkim=pass header.d=wallix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wallix.onmicrosoft.com; s=selector2-wallix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1sBj8eVWfmYtq61mrC0Etl/alJwheg8nfae/xJr2X0=;
 b=WBKoaJH+fTXxUq96LZ1VpHnywOqvMVJVHHatmm22J9UnEXFJZc1+sQOxb/fPS5mkO2Do2r2TVJEjYPhzTzpnvNtBXH82dK5b0h2ca/56vuQQ7KOaU4hC2TvWcqZnQlh6J8Fm96DMhHE2O4Vai8KP0STLBPyBu31RTjWJxpd7QCU=
Received: from VI1PR03MB6190.eurprd03.prod.outlook.com (10.141.128.75) by
 VI1PR03MB6158.eurprd03.prod.outlook.com (10.141.128.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 06:58:38 +0000
Received: from VI1PR03MB6190.eurprd03.prod.outlook.com
 ([fe80::4d7c:17b1:9d63:4403]) by VI1PR03MB6190.eurprd03.prod.outlook.com
 ([fe80::4d7c:17b1:9d63:4403%2]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 06:58:38 +0000
From:   Cyrille Mucchietto <cmucchietto@wallix.com>
To:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pavel.shilovsky@gmail.com>
CC:     Sebastien Tisserant <stisserant@wallix.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Cristian Popi <cpopi@wallix.com>
Subject: Re: PROBLEM: Kernel oops when mounting a encryptData CIFS share with
 CONFIG_DEBUG_VIRTUAL
Thread-Topic: PROBLEM: Kernel oops when mounting a encryptData CIFS share with
 CONFIG_DEBUG_VIRTUAL
Thread-Index: AQHVQwVbrMDmWO2VoUeqR7dMvDyd06bbyvGAgArH3YCAAOaQAA==
Date:   Fri, 2 Aug 2019 06:58:38 +0000
Message-ID: <35ee3dd4-19dd-4a27-6160-4080bdeaea48@wallix.com>
References: <380e1b86-1911-b8a5-6b02-276b6d4be4fe@wallix.com>
 <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com>
 <CAH2r5ms1qgpPrB+oOHWF7TVoZ36g3iska1PQ3dBGMrscq2K51g@mail.gmail.com>
In-Reply-To: <CAH2r5ms1qgpPrB+oOHWF7TVoZ36g3iska1PQ3dBGMrscq2K51g@mail.gmail.com>
Accept-Language: en-150, fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0042.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::30) To VI1PR03MB6190.eurprd03.prod.outlook.com
 (2603:10a6:800:142::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=cmucchietto@wallix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.87.189.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 037bf5ac-b34e-4e7c-ee5c-08d71716d858
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR03MB6158;
x-ms-traffictypediagnostic: VI1PR03MB6158:
x-microsoft-antispam-prvs: <VI1PR03MB61581DB981AD20E5EF951750C2D90@VI1PR03MB6158.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39840400004)(189003)(199004)(25786009)(71190400001)(71200400001)(54906003)(110136005)(6512007)(81156014)(81166006)(68736007)(53546011)(6506007)(386003)(76176011)(102836004)(186003)(31686004)(26005)(4326008)(486006)(36756003)(66066001)(6246003)(476003)(107886003)(8676002)(446003)(52116002)(6436002)(2616005)(99286004)(6486002)(11346002)(5660300002)(256004)(14444005)(3846002)(86362001)(6116002)(14454004)(305945005)(229853002)(7736002)(2906002)(8936002)(53936002)(66946007)(66476007)(66556008)(64756008)(66446008)(316002)(31696002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB6158;H:VI1PR03MB6190.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wallix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NxCXPojoloFVVufq1OtsY45LaTsABbQ0JN4caHlONFuW92LR1EbLIQUCgXzh1exTxpqWrC1Ri6ZGFJxUZan3lpd1jqUk+JfAvbBDmmkZsXv/0Cth/pPYKG8js38aOg9jd6QFD6EctbB6pBCAbJOZKTvAIgo0qVC/0jsYMuFFTZc1a41+/47vhWXQVLbCbYeMSXgj+3ZiOp7SN1ao3IIZj5iILGQTV9aiCZxLfsUZaUUi99lzf+ANcp5flSaR2EOY303Nl9sJLBN2lkxK/71rUphzIg/t2fZH/HCVYTOIxvIu7IeOtKMiUve3iPgeR8E5VQFitPQP/hZakdGGyWGcHz9JPjlFMxow6dYIAuxAwiLmU5Xv0hAL8W0LM3fk2/fljYGpqGe65EgIrRPUcD138YOaXPu1eav5/J69z5lTuAo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEDA740230A54C4DA0AB0EEACF33A3DB@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wallix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037bf5ac-b34e-4e7c-ee5c-08d71716d858
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 06:58:38.4852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f6bb2bd8-b6f1-4c26-8e2b-61c79722df19
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmucchietto@wallix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6158
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

T24gOC8xLzE5IDc6MTMgUE0sIFN0ZXZlIEZyZW5jaCB3cm90ZToNCj4gU2ViYXN0aWVuLA0KPiBJ
IGNsZWFuZWQgdXAgdGhlIHBhdGNoIGFuZCBtZXJnZWQgaW50byBjaWZzLTIuNi5naXQgLSBjYW4g
eW91DQo+IGRvdWJsZWNoZWNrIGl0IGlzIGNvcnJlY3Q/DQoNClNlYmFzdGllbiBpcyBub3QgYXZh
bGFpYmxlLCBidXQgd2UgY29uZmlybSB0aGF0IHRoaXMgcGF0Y2ggaXMgY29ycmVjdA0KDQpSZWdh
cmRzLA0KDQpDeXJpbGxlIE11Y2NoaWV0dG8NCg0KDQo+IE9uIFRodSwgSnVsIDI1LCAyMDE5IGF0
IDM6MzUgUE0gUGF2ZWwgU2hpbG92c2t5DQo+IDxwYXZlbC5zaGlsb3Zza3lAZ21haWwuY29tPiB3
cm90ZToNCj4+INGH0YIsIDI1INC40Y7Quy4gMjAxOSDQsy4g0LIgMDk6NTcsIFNlYmFzdGllbiBU
aXNzZXJhbnQgdmlhIHNhbWJhLXRlY2huaWNhbA0KPj4gPHNhbWJhLXRlY2huaWNhbEBsaXN0cy5z
YW1iYS5vcmc+Og0KPj4gLi4uDQo+Pj4gbW91bnQgd29ya3Mgd2l0aG91dCBDT05GSUdfREVCVUdf
VklSVFVBTA0KPj4+DQo+Pj4gSWYgd2UgZG9uJ3Qgc2V0IENPTkZJR19WTUFQX1NUQUNLIG1vdW50
IHdvcmtzIHdpdGggQ09ORklHX0RFQlVHX1ZJUlRVQUwNCj4+Pg0KPj4+DQo+Pj4gV2UgaGF2ZSB0
aGUgZm9sbG93aW5nICh2ZXJ5IHF1aWNrIGFuZCBkaXJ0eSkgcGF0Y2ggOg0KPj4+DQo+Pj4gSW5k
ZXg6IGxpbnV4LTQuMTkuNjAvZnMvY2lmcy9zbWIyb3BzLmMNCj4+PiA9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+Pj4g
LS0tIGxpbnV4LTQuMTkuNjAub3JpZy9mcy9jaWZzL3NtYjJvcHMuYw0KPj4+ICsrKyBsaW51eC00
LjE5LjYwL2ZzL2NpZnMvc21iMm9wcy5jDQo+Pj4gQEAgLTI1NDUsNyArMjU0NSwxNSBAQCBmaWxs
X3RyYW5zZm9ybV9oZHIoc3RydWN0IHNtYjJfdHJhbnNmb3JtDQo+Pj4gIHN0YXRpYyBpbmxpbmUg
dm9pZCBzbWIyX3NnX3NldF9idWYoc3RydWN0IHNjYXR0ZXJsaXN0ICpzZywgY29uc3Qgdm9pZCAq
YnVmLA0KPj4+ICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IGJ1ZmxlbikNCj4+PiAg
ew0KPj4+IC0gICAgc2dfc2V0X3BhZ2Uoc2csIHZpcnRfdG9fcGFnZShidWYpLCBidWZsZW4sIG9m
ZnNldF9pbl9wYWdlKGJ1ZikpOw0KPj4+ICsgICAgICB2b2lkICphZGRyOw0KPj4+ICsgICAgICAv
Kg0KPj4+ICsgICAgICAgKiBWTUFQX1NUQUNLIChhdCBsZWFzdCkgcHV0cyBzdGFjayBpbnRvIHRo
ZSB2bWFsbG9jIGFkZHJlc3Mgc3BhY2UNCj4+PiArICAgICAgKi8NCj4+PiArICAgICAgaWYgKGlz
X3ZtYWxsb2NfYWRkcihidWYpKQ0KPj4+ICsgICAgICAgICAgICAgIGFkZHIgPSB2bWFsbG9jX3Rv
X3BhZ2UoYnVmKTsNCj4+PiArICAgICAgZWxzZQ0KPj4+ICsgICAgICAgICAgICAgIGFkZHIgPSB2
aXJ0X3RvX3BhZ2UoYnVmKTsNCj4+PiArICAgICAgc2dfc2V0X3BhZ2Uoc2csIGFkZHIsIGJ1Zmxl
biwgb2Zmc2V0X2luX3BhZ2UoYnVmKSk7DQo+Pj4gIH0NCj4+Pg0KPj4+ICAvKiBBc3N1bWVzIHRo
ZSBmaXJzdCBycXN0IGhhcyBhIHRyYW5zZm9ybSBoZWFkZXIgYXMgdGhlIGZpcnN0IGlvdi4NCj4+
Pg0KPj4+DQo+PiBUaGFua3MgZm9yIHJlcG9ydGluZyB0aGlzLiBUaGUgcGF0Y2ggbG9va3MgZ29v
ZCB0byBtZS4gRGlkIHlvdSB0ZXN0DQo+PiB5b3VyIHNjZW5hcmlvIGFsbCB0b2dldGhlciB3aXRo
IGl0IChub3Qgb25seSBtb3VudGluZyk/DQo+Pg0KPj4NCj4+IEJlc3QgcmVnYXJkcywNCj4+IFBh
dmVsIFNoaWxvdnNraXkNCj4+DQo+Pg0K
