Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CD4C04AA7
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 01:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 023182085A
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 01:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="NrrAzZjm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfENBcI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 May 2019 21:32:08 -0400
Received: from mail-eopbgr680099.outbound.protection.outlook.com ([40.107.68.99]:27462
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726327AbfENBcI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 May 2019 21:32:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=t539LgsTQpdZ/dEe7TVj8PxG7F9cqxLh1s49nD/D7254/nmCqAkjqzxBMJfAmWXGi+Tt184CFi3QrEcJP54PSusnyfkVpeWsH66zUfxgCQWz+11PB+ZG3+50VGf3nrJan6Lllio5jnbyLRgJuFIdvTcuLFX9UPO6yrhw99Utof4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+xj7JmeLiReJWJMuvdZcLPs46sffDkGYGeDkKX/hvI=;
 b=vNUbRtlYfRh8b+65hrXH1BujcKTml60uGxJY71ahSYQMqr+5MhifJUSgO89b2e9YIaFkalSDkz+AnquyxWTV9X8vLv7rJrCIW7ShJqSmSyTHnFjidzXGxvYcwNyQAjrS8XRIzkvw/uZbT2AjiH3BaKS4rlaiQ4Dh9JEOUwc9/t4=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+xj7JmeLiReJWJMuvdZcLPs46sffDkGYGeDkKX/hvI=;
 b=NrrAzZjm3HPsrZibZe2PTKiylN199cJTY88D085MeqyAs7+K5cwvYFHKcTSxPvCxnmIjFMbdTjuEkI6/c/w7c/YODe1A3odyvczZW7/6H4yr7Yb2Mcz/EVsRZ/fK3xUbcC7JjhHepwwPUA9OZsn3ztzoWcSpvVydBlkdKGfKr24=
Received: from DM5PR21MB0635.namprd21.prod.outlook.com (2603:10b6:3:127::14)
 by DM5PR21MB0282.namprd21.prod.outlook.com (2603:10b6:3:a7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.4; Tue, 14 May
 2019 01:32:03 +0000
Received: from DM5PR21MB0635.namprd21.prod.outlook.com
 ([fe80::1804:a5c2:575c:6d0f]) by DM5PR21MB0635.namprd21.prod.outlook.com
 ([fe80::1804:a5c2:575c:6d0f%8]) with mapi id 15.20.1922.002; Tue, 14 May 2019
 01:32:03 +0000
From:   Long Li <longli@microsoft.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
CC:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [Patch (resend) 5/5] cifs: Call MID callback before destroying
 transport
Thread-Topic: [Patch (resend) 5/5] cifs: Call MID callback before destroying
 transport
Thread-Index: AQHU6/fbhkcbU4Goeke/Kb6Wlx7ElKZjSj+AgAbHCSA=
Date:   Tue, 14 May 2019 01:32:03 +0000
Message-ID: <DM5PR21MB0635F7EBA2DEF3437F57A653CE080@DM5PR21MB0635.namprd21.prod.outlook.com>
References: <20190405213635.24383-1-longli@linuxonhyperv.com>
 <20190405213635.24383-5-longli@linuxonhyperv.com>
 <CAKywueTBsHuBOchj7ysL8S+pU=nL6dfF65YT9YZrVk74HUoRVQ@mail.gmail.com>
In-Reply-To: <CAKywueTBsHuBOchj7ysL8S+pU=nL6dfF65YT9YZrVk74HUoRVQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:edea:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0f16c6d-a4d5-4226-1e4e-08d6d80bf7df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR21MB0282;
x-ms-traffictypediagnostic: DM5PR21MB0282:
x-microsoft-antispam-prvs: <DM5PR21MB028275E6C60ADF455751B23ACE080@DM5PR21MB0282.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:72;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(13464003)(10090500001)(10290500003)(1411001)(86612001)(68736007)(478600001)(54906003)(186003)(55016002)(14454004)(316002)(6436002)(46003)(11346002)(33656002)(229853002)(476003)(486006)(446003)(22452003)(9686003)(52396003)(8676002)(7696005)(81156014)(81166006)(76176011)(8990500004)(8936002)(99286004)(256004)(6506007)(7736002)(102836004)(4326008)(53936002)(64756008)(14444005)(66446008)(66476007)(66556008)(25786009)(66946007)(6246003)(73956011)(6116002)(76116006)(86362001)(6916009)(71190400001)(5660300002)(2906002)(71200400001)(74316002)(305945005)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0282;H:DM5PR21MB0635.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IAw3OKPkNBnyF8TFPryfDRjeGS7yOKns7Z1+RaM1/hFeWWx3Gtx0V9Kqmj6hsFCZ3KcoP5kAz5jZk80eJjqDBVrvW9c5kcyz1AsY6k0Dgmh8UiF/aEmTVX3tU4mHMDKmJK9jYxUdw2iC69u7JG8yoNEvNx87lJWoyhdzCPbggHYCJPofAS7eLP7tRFrAhWhgJVmorA7H2s9GagMHihTVj+kRktkQPeanPBf1oAupSd2DagI5kAu084WBEObSApRRn/+feffZLFOLoQMK/5bxYmJtDaHW1zOpr+426dKK3k8VtWb75NnKzlH+hG5WRw+tAouEQAdj4BSrg9NjiwJvTyHgIzlfxyJyFccLWSPUTgucfC3WaNhAutCduxfVU4MLz7+5WVLjOg+LzDkSrxpeqL6jAn+m9kDHSgEotHxnIHY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f16c6d-a4d5-4226-1e4e-08d6d80bf7df
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 01:32:03.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: longli@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0282
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pj4+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+PkZyb206IFBhdmVsIFNoaWxvdnNreSA8
cGlhc3RyeXl5QGdtYWlsLmNvbT4NCj4+PlNlbnQ6IFRodXJzZGF5LCBNYXkgOSwgMjAxOSAxMTow
MSBBTQ0KPj4+VG86IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQuY29tPg0KPj4+Q2M6IFN0ZXZl
IEZyZW5jaCA8c2ZyZW5jaEBzYW1iYS5vcmc+OyBsaW51eC1jaWZzIDxsaW51eC0NCj4+PmNpZnNA
dmdlci5rZXJuZWwub3JnPjsgc2FtYmEtdGVjaG5pY2FsIDxzYW1iYS10ZWNobmljYWxAbGlzdHMu
c2FtYmEub3JnPjsNCj4+Pktlcm5lbCBNYWlsaW5nIExpc3QgPGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc+DQo+Pj5TdWJqZWN0OiBSZTogW1BhdGNoIChyZXNlbmQpIDUvNV0gY2lmczogQ2Fs
bCBNSUQgY2FsbGJhY2sgYmVmb3JlIGRlc3Ryb3lpbmcNCj4+PnRyYW5zcG9ydA0KPj4+DQo+Pj7Q
v9GCLCA1INCw0L/RgC4gMjAxOSDQsy4g0LIgMTQ6MzksIExvbmcgTGkgPGxvbmdsaUBsaW51eG9u
aHlwZXJ2LmNvbT46DQo+Pj4+DQo+Pj4+IEZyb206IExvbmcgTGkgPGxvbmdsaUBtaWNyb3NvZnQu
Y29tPg0KPj4+Pg0KPj4+PiBXaGVuIHRyYW5zcG9ydCBpcyBiZWluZyBkZXN0cm95ZWQsIGl0J3Mg
cG9zc2libGUgdGhhdCBzb21lIHByb2Nlc3Nlcw0KPj4+PiBtYXkgaG9sZCBtZW1vcnkgcmVnaXN0
cmF0aW9ucyB0aGF0IG5lZWQgdG8gYmUgZGVyZWdpc3RyZWQuDQo+Pj4+DQo+Pj4+IENhbGwgdGhl
bSBmaXJzdCBzbyBub2JvZHkgaXMgdXNpbmcgdHJhbnNwb3J0IHJlc291cmNlcywgYW5kIGl0IGNh
biBiZQ0KPj4+PiBkZXN0cm95ZWQuDQo+Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IExvbmcgTGkg
PGxvbmdsaUBtaWNyb3NvZnQuY29tPg0KPj4+PiAtLS0NCj4+Pj4gIGZzL2NpZnMvY29ubmVjdC5j
IHwgMzYgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4+ICAxIGZpbGUg
Y2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pDQo+Pj4+DQo+Pj4+IGRp
ZmYgLS1naXQgYS9mcy9jaWZzL2Nvbm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jIGluZGV4DQo+
Pj4+IDMzZTRkOTguLjA4NDc1NmNmIDEwMDY0NA0KPj4+PiAtLS0gYS9mcy9jaWZzL2Nvbm5lY3Qu
Yw0KPj4+PiArKysgYi9mcy9jaWZzL2Nvbm5lY3QuYw0KPj4+PiBAQCAtNTI4LDIyICs1MjgsNiBA
QCBjaWZzX3JlY29ubmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpDQo+Pj4+ICAg
ICAgICAgLyogZG8gbm90IHdhbnQgdG8gYmUgc2VuZGluZyBkYXRhIG9uIGEgc29ja2V0IHdlIGFy
ZSBmcmVlaW5nICovDQo+Pj4+ICAgICAgICAgY2lmc19kYmcoRllJLCAiJXM6IHRlYXJpbmcgZG93
biBzb2NrZXRcbiIsIF9fZnVuY19fKTsNCj4+Pj4gICAgICAgICBtdXRleF9sb2NrKCZzZXJ2ZXIt
PnNydl9tdXRleCk7DQo+Pj4+IC0gICAgICAgaWYgKHNlcnZlci0+c3NvY2tldCkgew0KPj4+PiAt
ICAgICAgICAgICAgICAgY2lmc19kYmcoRllJLCAiU3RhdGU6IDB4JXggRmxhZ3M6IDB4JWx4XG4i
LA0KPj4+PiAtICAgICAgICAgICAgICAgICAgICAgICAgc2VydmVyLT5zc29ja2V0LT5zdGF0ZSwg
c2VydmVyLT5zc29ja2V0LT5mbGFncyk7DQo+Pj4+IC0gICAgICAgICAgICAgICBrZXJuZWxfc29j
a19zaHV0ZG93bihzZXJ2ZXItPnNzb2NrZXQsIFNIVVRfV1IpOw0KPj4+PiAtICAgICAgICAgICAg
ICAgY2lmc19kYmcoRllJLCAiUG9zdCBzaHV0ZG93biBzdGF0ZTogMHgleCBGbGFnczogMHglbHhc
biIsDQo+Pj4+IC0gICAgICAgICAgICAgICAgICAgICAgICBzZXJ2ZXItPnNzb2NrZXQtPnN0YXRl
LCBzZXJ2ZXItPnNzb2NrZXQtPmZsYWdzKTsNCj4+Pj4gLSAgICAgICAgICAgICAgIHNvY2tfcmVs
ZWFzZShzZXJ2ZXItPnNzb2NrZXQpOw0KPj4+PiAtICAgICAgICAgICAgICAgc2VydmVyLT5zc29j
a2V0ID0gTlVMTDsNCj4+Pj4gLSAgICAgICB9IGVsc2UgaWYgKGNpZnNfcmRtYV9lbmFibGVkKHNl
cnZlcikpDQo+Pj4+IC0gICAgICAgICAgICAgICBzbWJkX2Rlc3Ryb3koc2VydmVyKTsNCj4+Pj4g
LSAgICAgICBzZXJ2ZXItPnNlcXVlbmNlX251bWJlciA9IDA7DQo+Pj4+IC0gICAgICAgc2VydmVy
LT5zZXNzaW9uX2VzdGFiID0gZmFsc2U7DQo+Pj4+IC0gICAgICAga2ZyZWUoc2VydmVyLT5zZXNz
aW9uX2tleS5yZXNwb25zZSk7DQo+Pj4+IC0gICAgICAgc2VydmVyLT5zZXNzaW9uX2tleS5yZXNw
b25zZSA9IE5VTEw7DQo+Pj4+IC0gICAgICAgc2VydmVyLT5zZXNzaW9uX2tleS5sZW4gPSAwOw0K
Pj4+PiAtICAgICAgIHNlcnZlci0+bHN0cnAgPSBqaWZmaWVzOw0KPj4+Pg0KPj4+PiAgICAgICAg
IC8qIG1hcmsgc3VibWl0dGVkIE1JRHMgZm9yIHJldHJ5IGFuZCBpc3N1ZSBjYWxsYmFjayAqLw0K
Pj4+PiAgICAgICAgIElOSVRfTElTVF9IRUFEKCZyZXRyeV9saXN0KTsNCj4+Pj4gQEAgLTU1Niw3
ICs1NDAsNiBAQCBjaWZzX3JlY29ubmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIp
DQo+Pj4+ICAgICAgICAgICAgICAgICBsaXN0X21vdmUoJm1pZF9lbnRyeS0+cWhlYWQsICZyZXRy
eV9saXN0KTsNCj4+Pj4gICAgICAgICB9DQo+Pj4+ICAgICAgICAgc3Bpbl91bmxvY2soJkdsb2Jh
bE1pZF9Mb2NrKTsNCj4+Pj4gLSAgICAgICBtdXRleF91bmxvY2soJnNlcnZlci0+c3J2X211dGV4
KTsNCj4+Pj4NCj4+Pj4gICAgICAgICBjaWZzX2RiZyhGWUksICIlczogaXNzdWluZyBtaWQgY2Fs
bGJhY2tzXG4iLCBfX2Z1bmNfXyk7DQo+Pj4+ICAgICAgICAgbGlzdF9mb3JfZWFjaF9zYWZlKHRt
cCwgdG1wMiwgJnJldHJ5X2xpc3QpIHsgQEAgLTU2NSw2ICs1NDgsMjUNCj4+Pj4gQEAgY2lmc19y
ZWNvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQ0KPj4+PiAgICAgICAgICAg
ICAgICAgbWlkX2VudHJ5LT5jYWxsYmFjayhtaWRfZW50cnkpOw0KPj4+PiAgICAgICAgIH0NCj4+
Pg0KPj4+VGhlIG9yaWdpbmFsIGNhbGwgd2FzIGlzc3VpbmcgY2FsbGJhY2tzIHdpdGhvdXQgaG9s
ZGluZyBzcnZfbXV0ZXggLSBjYWxsYmFja3MNCj4+Pm1heSB0YWtlIHRoaXMgbXV0ZXggZm9yIGl0
cyBpbnRlcm5hbCBuZWVkcy4gV2l0aCB0aGUgcHJvcG9zZWQgcGF0Y2ggdGhlDQo+Pj5jb2RlIHdp
bGwgZGVhZGxvY2suDQo+Pj4NCj4+PkFsc28gdGhlIGlkZWEgb2YgZGVzdHJveWluZyB0aGUgc29j
a2V0IGZpcnN0IGlzIHRvIGFsbG93IHBvc3NpYmxlIHJldHJpZXMgKGZyb20NCj4+PmNhbGxiYWNr
cykgdG8gcmV0dXJuIGEgcHJvcGVyIGVycm9yIGluc3RlYWQgb2YgdHJ5aW5nIHRvIHNlbmQgYW55
dGhpbmcgdGhyb3VnaA0KPj4+dGhlIHJlY29ubmVjdGluZyBzb2NrZXQuDQoNCkkgd2lsbCBzZW5k
IGEgcGF0Y2ggdG8gcmV2ZXJ0IHRoaXMgYW5kIGZvbGxvdyB5b3VyIHN1Z2dlc3Rpb24gb24gcHV0
dGluZyBzbWJkX2Rlc3Ryb3koKSB0byBhZnRlciBhbGwgTUlEcyBoYXZlIGJlZW4gY2FsbGVkLiBZ
b3VyIHN1Z2dlc3Rpb24gdGVzdGVkIHdlbGwuDQoNClRoYW5rcw0KDQpMb25nDQoNCj4+Pg0KPj4+
Pg0KPj4+PiArICAgICAgIGlmIChzZXJ2ZXItPnNzb2NrZXQpIHsNCj4+Pj4gKyAgICAgICAgICAg
ICAgIGNpZnNfZGJnKEZZSSwgIlN0YXRlOiAweCV4IEZsYWdzOiAweCVseFxuIiwNCj4+Pj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgIHNlcnZlci0+c3NvY2tldC0+c3RhdGUsIHNlcnZlci0+c3Nv
Y2tldC0+ZmxhZ3MpOw0KPj4+PiArICAgICAgICAgICAgICAga2VybmVsX3NvY2tfc2h1dGRvd24o
c2VydmVyLT5zc29ja2V0LCBTSFVUX1dSKTsNCj4+Pj4gKyAgICAgICAgICAgICAgIGNpZnNfZGJn
KEZZSSwgIlBvc3Qgc2h1dGRvd24gc3RhdGU6IDB4JXggRmxhZ3M6IDB4JWx4XG4iLA0KPj4+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgc2VydmVyLT5zc29ja2V0LT5zdGF0ZSwgc2VydmVyLT5z
c29ja2V0LT5mbGFncyk7DQo+Pj4+ICsgICAgICAgICAgICAgICBzb2NrX3JlbGVhc2Uoc2VydmVy
LT5zc29ja2V0KTsNCj4+Pj4gKyAgICAgICAgICAgICAgIHNlcnZlci0+c3NvY2tldCA9IE5VTEw7
DQo+Pj4+ICsgICAgICAgfSBlbHNlIGlmIChjaWZzX3JkbWFfZW5hYmxlZChzZXJ2ZXIpKQ0KPj4+
PiArICAgICAgICAgICAgICAgc21iZF9kZXN0cm95KHNlcnZlcik7DQo+Pj4NCj4+PklmIHdlIG5l
ZWQgdG8gY2FsbCBzbWJkX2Rlc3Ryb3koKSAqYWZ0ZXIqIGNhbGxiYWNrcywgbGV0J3MganVzdCBt
b3ZlIGl0IGFsb25lDQo+Pj53aXRob3V0IHRoZSByZXN0IG9mIHRoZSBjb2RlLg0KPj4+DQo+Pj4N
Cj4+Pj4gKyAgICAgICBzZXJ2ZXItPnNlcXVlbmNlX251bWJlciA9IDA7DQo+Pj4+ICsgICAgICAg
c2VydmVyLT5zZXNzaW9uX2VzdGFiID0gZmFsc2U7DQo+Pj4+ICsgICAgICAga2ZyZWUoc2VydmVy
LT5zZXNzaW9uX2tleS5yZXNwb25zZSk7DQo+Pj4+ICsgICAgICAgc2VydmVyLT5zZXNzaW9uX2tl
eS5yZXNwb25zZSA9IE5VTEw7DQo+Pj4+ICsgICAgICAgc2VydmVyLT5zZXNzaW9uX2tleS5sZW4g
PSAwOw0KPj4+PiArICAgICAgIHNlcnZlci0+bHN0cnAgPSBqaWZmaWVzOw0KPj4+PiArDQo+Pj4+
ICsgICAgICAgbXV0ZXhfdW5sb2NrKCZzZXJ2ZXItPnNydl9tdXRleCk7DQo+Pj4+ICsNCj4+Pj4g
ICAgICAgICBkbyB7DQo+Pj4+ICAgICAgICAgICAgICAgICB0cnlfdG9fZnJlZXplKCk7DQo+Pj4+
DQo+Pj4+IC0tDQo+Pj4+IDIuNy40DQo+Pj4+DQo+Pj4NCj4+Pg0KPj4+LS0NCj4+PkJlc3QgcmVn
YXJkcywNCj4+PlBhdmVsIFNoaWxvdnNreQ0K
