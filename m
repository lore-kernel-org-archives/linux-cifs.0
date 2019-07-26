Return-Path: <SRS0=vxna=VX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A18C7618B
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 06:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F93F217D4
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 06:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wallix.onmicrosoft.com header.i=@wallix.onmicrosoft.com header.b="YYftmnn1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfGZG20 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jul 2019 02:28:26 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:50158
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbfGZG20 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Jul 2019 02:28:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKyxntATrkWToXxiUb3hT7LtYdr2aH5G9XMPaDmI5h7DD1A8D2OIetjsBXtsXqfSXjzQRObiiRrrpQXiKiTrWz+sjQQbBy9PujdlSVZoXKZhcN64WyASE8bG4xyMBCvfXzxdWest3CqFeiDns5MpYuGgAWLJHFJE3bFakGQBQclu0m3MYCXe8GTsR1fDuTaVdSG5GhDkUytK+yPmSfH2N06VOzHkPFiTR0cT2v05Srg5I6eiuE5/phKd7dvIe81MfY5l0ogcogcuMWB9Him8EgOz1Cvd27G1ridIyIx0FJQLOgG4ECa+GvE2ow6ZfjJMUzcCP+J3MzzDrAkvcHGppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmZ2iDMx1sSEVcaRRyTfXCy8akOOiiMS5SdBfdtx/3Q=;
 b=NdC6Lrw5eufPsTyr9AKmfMFxneRKAUj+JMveLaVNdz4XtixWYk9pn+o5j7p36wJOTe02eVnfWWEX4Tqiz8FsVYgg4K75fOJDPFlV5zBcC9rzwUOSXaeT9aIv6r1n0iEEjsaD7EmjvhqUvx744WYVgq6EAiasr+Dvuuxh9EUBTJ1fHnXeonzXq3z5GJdCVJsRMt10WlDG7sDnWk00N8nVzUjDct2H6bo2vTYCQCyOh4uDHQhj6YLvvKNYcCkzw+mBD81vXsXNQVaCy8LM/RsF22lNUKNo0kmHWOVkIf7VGco8R5EVva+gRPYpynSNLC8xmn/1CHztoeNlqhDFynb9Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wallix.com;dmarc=pass action=none
 header.from=wallix.com;dkim=pass header.d=wallix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wallix.onmicrosoft.com; s=selector2-wallix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmZ2iDMx1sSEVcaRRyTfXCy8akOOiiMS5SdBfdtx/3Q=;
 b=YYftmnn1iBgbMCS9kVR0+OSfNuln0upJlDgo0t2nEKpb5bAFCXuOmuK849HYQ8o+Yu4OqcEPn1VKDTFQVoPqPZyAi5fmsnmDXh9HzEdHBo/XVANMUPsavz7EJjqmjiFOfagN/NXrCzH+ZawVME+DUvSro6/B7x/C8fzH/b/hDkQ=
Received: from VI1PR03MB6190.eurprd03.prod.outlook.com (10.141.128.75) by
 VI1PR03MB3823.eurprd03.prod.outlook.com (20.177.54.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 26 Jul 2019 06:28:21 +0000
Received: from VI1PR03MB6190.eurprd03.prod.outlook.com
 ([fe80::4d7c:17b1:9d63:4403]) by VI1PR03MB6190.eurprd03.prod.outlook.com
 ([fe80::4d7c:17b1:9d63:4403%2]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 06:28:21 +0000
From:   Cyrille Mucchietto <cmucchietto@wallix.com>
To:     Pavel Shilovsky <pavel.shilovsky@gmail.com>,
        Sebastien Tisserant <stisserant@wallix.com>
CC:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Cristian Popi <cpopi@wallix.com>
Subject: Re: PROBLEM: Kernel oops when mounting a encryptData CIFS share with
 CONFIG_DEBUG_VIRTUAL
Thread-Topic: PROBLEM: Kernel oops when mounting a encryptData CIFS share with
 CONFIG_DEBUG_VIRTUAL
Thread-Index: AQHVQwVbrMDmWO2VoUeqR7dMvDyd06bbyvGAgAClpYA=
Date:   Fri, 26 Jul 2019 06:28:21 +0000
Message-ID: <e6246145-8143-ea69-6471-6cc593c95324@wallix.com>
References: <380e1b86-1911-b8a5-6b02-276b6d4be4fe@wallix.com>
 <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com>
In-Reply-To: <CAKywueSO=choOsw6THnEnmN4UwhACHU1o1pJX8ypx0wjVTmiKQ@mail.gmail.com>
Accept-Language: en-150, fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0117.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::33) To VI1PR03MB6190.eurprd03.prod.outlook.com
 (2603:10a6:800:142::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=cmucchietto@wallix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.87.189.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53a96099-7341-45a7-12bc-08d711927448
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR03MB3823;
x-ms-traffictypediagnostic: VI1PR03MB3823:
x-microsoft-antispam-prvs: <VI1PR03MB382357DE1261D5937A8EECDAC2C00@VI1PR03MB3823.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39850400004)(366004)(189003)(199004)(81156014)(8676002)(81166006)(8936002)(6636002)(4744005)(5660300002)(31686004)(316002)(68736007)(66476007)(66946007)(66556008)(64756008)(66446008)(99286004)(52116002)(53546011)(386003)(76176011)(6506007)(102836004)(478600001)(14454004)(53936002)(71190400001)(6116002)(66066001)(31696002)(6512007)(486006)(14444005)(256004)(7736002)(107886003)(6246003)(3846002)(71200400001)(25786009)(4326008)(6486002)(110136005)(6436002)(54906003)(229853002)(36756003)(26005)(2906002)(186003)(2616005)(476003)(446003)(11346002)(305945005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB3823;H:VI1PR03MB6190.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wallix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JXlJBx+/SF+WnJS8TRWO3nAxkCwCnCRVa/4kLVtZUVQme0g3Uq+LPo6x2GeMUaNEdAu2r4IDZlmuwCpaiUU2AdUj6YpAnfbnNLpf+CZpxWfG9xADK4ISI1INVyT/+EhSE4+0swVDRDVJRzT+tKyuvWWDt/AtIoJDXhJKOE9yfGBoFLG0WrlWh4eG1bpMdpuFUJ7b8zuNmrL+EmuzDlbD8he4aI3T82cXEQ8nEw04eGQQoQlhSl7u55QFj5hkB9OgMcUZRqmNqfB7ZBFGdh6k7qZcbERCaiJmeF/cPy69YADCYk30fZ/hnM6sqSl9LHjrGzzRPVXvH0MTB2QcWucglsG6f9UE+HUhoU08BCKUR1UgyvT4aVIXd57yRJEckxk/9bdhm5Nn+NeCDD8NdB8HdXKZP0/2La4XZdHag/nqcrM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB9F9D29041B954A96F9E8CB936932E3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wallix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a96099-7341-45a7-12bc-08d711927448
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 06:28:21.1823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f6bb2bd8-b6f1-4c26-8e2b-61c79722df19
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmucchietto@wallix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3823
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

T24gNy8yNS8xOSAxMDozNSBQTSwgUGF2ZWwgU2hpbG92c2t5IHdyb3RlOg0KLi4uDQo+PiBtb3Vu
dCB3b3JrcyB3aXRob3V0IENPTkZJR19ERUJVR19WSVJUVUFMDQo+Pg0KPj4gSWYgd2UgZG9uJ3Qg
c2V0IENPTkZJR19WTUFQX1NUQUNLIG1vdW50IHdvcmtzIHdpdGggQ09ORklHX0RFQlVHX1ZJUlRV
QUwNCj4+IFdlIGhhdmUgdGhlIGZvbGxvd2luZyAodmVyeSBxdWljayBhbmQgZGlydHkpIHBhdGNo
IDoNCj4+IC4uLg0KPiBUaGFua3MgZm9yIHJlcG9ydGluZyB0aGlzLiBUaGUgcGF0Y2ggbG9va3Mg
Z29vZCB0byBtZS4gRGlkIHlvdSB0ZXN0DQo+IHlvdXIgc2NlbmFyaW8gYWxsIHRvZ2V0aGVyIHdp
dGggaXQgKG5vdCBvbmx5IG1vdW50aW5nKT8NCj4NCj4NCj4gQmVzdCByZWdhcmRzLA0KPiBQYXZl
bCBTaGlsb3Zza2l5DQoNCldlJ3ZlIGRvbmUgc29tZSB0ZXN0cyAobW91bnQvdW5tb3VudCwgY29w
eS9kZWxldGUvbW92ZSBmaWxlcykgYW5kIGl0IHNlZW1zDQp0byBiZSBPSy4NCg0KV2UgYXJlbid0
IHN1cmUgdGhhdCBvdXIgcGF0Y2ggY29ycmVjdHMgdGhlIHJvb3QgY2F1c2Ugb2YgdGhpcyBpc3N1
ZSwgYXMNCmZvciBvdXINCnVuZGVyc3RhbmRpbmcsIGtlcm5lbCBzdGFjayB3aXRoIFZNQVBfU1RB
Q0sgZW5hYmxlZCBtaWdodCBub3QgYmUgY29udGlndW91cy4NCklmIHRoZSBzdGFjayBpcyB0b28g
YmlnIHRvIGJlIG9uIG9uZSBwYWdlIGFuZCBkYXRhIGFyZSBzcGxpdHRlZCBhY2Nyb3NzIG5vbg0K
Y29udGlndW91cyBwYWdlcyBpdCBtaWdodCBub3Qgd29yay4NCg0KUmVnYXJkcw0KDQpDeXJpbGxl
IE11Y2NoaWV0dG8NCg0KDQo=
