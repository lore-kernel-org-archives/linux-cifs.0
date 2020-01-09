Return-Path: <SRS0=5TF8=26=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D6BC32771
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 12:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65CE92072A
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 12:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=prodrive-technologies.com header.i=@prodrive-technologies.com header.b="LiMKuiIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgAIM1v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:27:51 -0500
Received: from mail-eopbgr10131.outbound.protection.outlook.com ([40.107.1.131]:9267
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730392AbgAIM1u (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Jan 2020 07:27:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLWiH2OvPLaLyEVaKxcG834Js3I25mxwpLeL5n2iFIe/i7byPJrDPsiwWRXbzhTxE/3jn9VDy8RFpbMYV9SwFyhBaRwulXtncXr1vA46n9ZDtSRuTSO46UQO6wtCPAVT5HYmwNROxKnFprBEmwsZnGoGflJuF/5/VIcpM36ThX960xvRA8xIMeV9Z09b1yyxnAVgsnzGc3DkF4BdP4w/oxF87vDPRwQXE9+7bv6HSivpWgleZO8pJwherEH9YXdzvPo1G4RUKFVshmt0LehO70JfMqLGbObch65rUyaZr1LsRuhSrbPs9iQ8c51MZnV6RKhtTZeNDKlQuYkZpm6SNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouEQT825ID0HoZS7t7OU9ZQdEU6XZK0v3kwPYstNwfg=;
 b=TfLC7DovhKT8LXl9rCJonfSlvxR5eVNdlNkh05/3/KQ/poG1jsQM4N1y8qRHiwa/+9ihtXQMFaKVr4DcxEPzgEZP7u/JeJHbTqjPelxeaNyFJ+gF6Iao5S4AVcu33c8g1kUkv4bAAYDg/zUuD923iOAbSB92kID3l2P7YqjQRxKN250TBE/CdN8/2G0CNZlvKJsqXl+sI4LvxVdM+7yzP/PgO1IgN45Aks1OK6O9dnuPBck4e3GjEz+vSJ0t+mdz2BXABLvLK7VmH/sCmV6ofk0hYdl5Z2jaHZCiXTyQ9BoC1Pe/ovUwTS+JtjDAHX11MSNPWjGHgWLqQ9mG9VkCbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouEQT825ID0HoZS7t7OU9ZQdEU6XZK0v3kwPYstNwfg=;
 b=LiMKuiIj5254UtWT1AkVOUDUKUzCD6/kvVF6C/9yu9oz32sV0stuS2XGFRLXmg4xKbHP/mJ070lMVmP8fh218wSa8z3JzZ0L5QNSlWwqB9y1FIYoU60v8YoRXSAQw96gA8wV1f7yrj2vJBTKO6psITW8qst3wIuW4UQViJyUr7Y=
Received: from VE1PR02MB5550.eurprd02.prod.outlook.com (20.179.30.11) by
 VE1PR02MB5646.eurprd02.prod.outlook.com (10.255.159.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Thu, 9 Jan 2020 12:27:46 +0000
Received: from VE1PR02MB5550.eurprd02.prod.outlook.com
 ([fe80::d01e:58a8:3b2d:c74b]) by VE1PR02MB5550.eurprd02.prod.outlook.com
 ([fe80::d01e:58a8:3b2d:c74b%7]) with mapi id 15.20.2623.008; Thu, 9 Jan 2020
 12:27:46 +0000
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
To:     Paulo Alcantara <pc@cjr.nz>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
Thread-Topic: cifs.upcall requests ticket for wrong host when using dfs
Thread-Index: AQHVwj+tztbeRMwVFU+OqRHcECQz4afZAQIAgAAgxYCAAD6eAIAEXhHAgACPjQCAARab3oABrgaAgAE5QIA=
Date:   Thu, 9 Jan 2020 12:27:46 +0000
Message-ID: <3ddf0683-0213-1c43-bcc7-cfc3cb8bc28b@prodrive-technologies.com>
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz>
 <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz>
 <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87k16417ud.fsf@cjr.nz>
 <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87y2uh264k.fsf@cjr.nz>
In-Reply-To: <87y2uh264k.fsf@cjr.nz>
Accept-Language: en-NL, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=martijn.de.gouw@prodrive-technologies.com; 
x-originating-ip: [212.61.153.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fe20abf-b2d7-4604-fd38-08d794ff5528
x-ms-traffictypediagnostic: VE1PR02MB5646:
x-microsoft-antispam-prvs: <VE1PR02MB564677C59D0B597B9E55913EF5390@VE1PR02MB5646.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39850400004)(366004)(396003)(376002)(346002)(189003)(199004)(36756003)(86362001)(478600001)(31696002)(110136005)(31686004)(26005)(316002)(66446008)(66556008)(66476007)(66946007)(8936002)(8676002)(81156014)(81166006)(64756008)(53546011)(6506007)(6512007)(76116006)(2616005)(6486002)(5660300002)(2906002)(186003)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:VE1PR02MB5646;H:VE1PR02MB5550.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prodrive-technologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ghon/5SulrOhU95gpQLr/nthUPx6VX9fLTfOpEnrts/n+mztq0aPcMQ5WUGEE3uBTLHLMMWjbHHHIMUpKNhcD1PxBOp3J1lxp0prkd3IrsmEOPisx3rec9oELzY/lfW6iHSC3zux9Pug3NBkrGfpIxWuR5lEP299VfaZocLGWi7/Ji44bn4e+CFjoPgvZu0UGIohB1wFFXrmJLE1MWTX0T/sCXM5ShmaBD1UqQjsV26l8I1eIxO2o9Ye/70OURhna2nIqvyEkGN0EKTvmWh60NzwWbP6DXCDn9pZ3y0JjE1iBMBtvP06VHJIoX4FmlReJzUsVtoMuYKLyFjZNsIBA7f9VLlXg3sOlJFlAxTuz+iVRYU4Ho5J5sdsrefsPnENa8Xf+GCL8+UN1uFrZMnYT9+jKh9qHkkks9plWSK57w0XVPLHsakNOzn1uZSUEr4B
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DFE12D729AAE14081B395CEE07B55A8@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe20abf-b2d7-4604-fd38-08d794ff5528
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 12:27:46.1476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sM3ZNlOxUagbcvsLLyQVco91UF8fpiMzuqOeoO1c6Migl4F6enQ9sMp+ZjUz10AtxzK9HJfhL+x3Tepx9HkTEHLePQPgVXq12OtJTYZyvErcpQyZ0bASKLoSDe+vwv/RtAk1RVGDGqakvzxkaoCs2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR02MB5646
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGkgUGF1bG8NCg0KT24gMDgtMDEtMjAyMCAxODo0NiwgUGF1bG8gQWxjYW50YXJhIHdyb3RlOg0K
PiBIaSBNYXJ0aWpuLA0KPiANCj4gTWFydGlqbiBkZSBHb3V3IDxtYXJ0aWpuLmRlLmdvdXdAcHJv
ZHJpdmUtdGVjaG5vbG9naWVzLmNvbT4gd3JpdGVzOg0KPiANCj4+IEkgYXBwbGllZCB5b3VyIHBh
dGNoIHRvIDUuNC42IGFuZCBpdCBzZWVtcyB0byB3b3JrLiBJIGF0dGFjaGVkDQo+PiB0aGUgbG9n
cy4NCj4+DQo+PiBSZWdhcmRzLCBNYXJ0aWpuDQoNClsuLmxvdHMgb2YgbG9nZ2luZy4uXQ0KDQo+
PiBbICAxMzcuMDk0MjExXSBmcy9jaWZzL2NpZnNfZGZzX3JlZi5jOiBjaWZzX2Rmc19kb19hdXRv
bW91bnQ6IGNpZnNfZGZzX2RvX21vdW50OlxEQzAzLlByb2RyaXZlLm5sXHByb2R1Y3RcS0FFUzYz
MDkgLCBtbnQ6MDAwMDAwMDAxYmJlZjQ0Nw0KPj4gWyAgMTM3LjA5NDIxMV0gZnMvY2lmcy9jaWZz
X2Rmc19yZWYuYzogbGVhdmluZyBjaWZzX2Rmc19kb19hdXRvbW91bnQNCj4+IFsgIDEzNy4wOTQy
MTJdIGZzL2NpZnMvY2lmc19kZnNfcmVmLmM6IGxlYXZpbmcgY2lmc19kZnNfZF9hdXRvbW91bnQg
W29rXQ0KPiANCj4gVGhhbmtzIGZvciB0ZXN0aW5nIGl0IQ0KPiANCj4gU28gZmFyIHNvIGdvb2Q/
DQo+IA0KPiBMZXQgbWUga25vdyBzbyBJIGNhbiBwcmVwYXJlIGEgcGF0Y2ggZm9yIHVwc3RyZWFt
Lg0KDQpZZXMsIHNvIGZhciBzbyBnb29kLiBUaGFua3MgYSBsb3QgZm9yIHRoZSBxdWljayByZXNw
b25zZSEgTm90IGEgdHJpdmlhbCANCnBhdGNoIGFzIGZhciBJIGFzIGkgY2FuIGp1ZGdlLg0KDQpB
bHNvIHRoZSBtYWNoaW5lIHdlIGhhdmUgcnVubmluZyB3aXRoIHlvdXIgb3RoZXIgREZTIHBhdGNo
ZXMgaXMgcnVubmluZyANCmZvciA4IHdlZWtzIG5vdyBhbmQgc3Vydml2ZWQgc2V2ZXJhbCByZWxv
Y2F0aW9ucyBvZiBvdXIgZGZzIHNoYXJlcyBhbmQgDQphZGRpbmcvcmVtb3ZhbCBvZiBEQ3MhDQoN
CklzIHRoZXJlIGFueSBuZXdzIG9uIHRoZSBhY2NlcHRhbmNlIG9mIHlvdXIgW1BBVENIIHY0IDAv
Nl0gREZTIGZpeGVzPw0KDQpSZWdhcmRzLCBNYXJ0aWpuDQoNCi0tIA0KTWFydGlqbiBkZSBHb3V3
DQpEZXNpZ25lcg0KUHJvZHJpdmUgVGVjaG5vbG9naWVzDQpNb2JpbGU6ICszMSA2MyAxNyA3NiAx
NjENClBob25lOiAgKzMxIDQwIDI2IDc2IDIwMA0K
