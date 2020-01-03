Return-Path: <SRS0=alM3=2Y=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071A5C2D0C2
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jan 2020 16:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928F622522
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jan 2020 16:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=prodrive-technologies.com header.i=@prodrive-technologies.com header.b="cwJUlC/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgACQas (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jan 2020 11:30:48 -0500
Received: from mail-eopbgr10104.outbound.protection.outlook.com ([40.107.1.104]:23943
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbgACQar (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 Jan 2020 11:30:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsKnG35PXwK+wy+5W4MSVtlzebkbYAX90ilx4zk8poTmJcsk/9t1TBvP1391+yPRcgXVtdQ07Wkqc6iiCvXrEe7LU7cwAgNjXimEQvWpUsYXhOBWDTmbO4LueI+VrdJ3T7hZAedmPtw/DefcJgaQL0rjngXDdrG4gvEy3uPLqQ9qFwMl/ErWTACRRhm/rJTlJxF3B3zb8f7wMzfSF08ehtHaJs3uSTC36MhPaErcyJqN2/N4iFDCaqUB7l/3gtM10cA9yIfUVJpgqEGBEOtk51EbOy5Uzg2AFv1Rm9eT2Dx9Lrey5aooMZw86WVIwpByxiI32OKK2+87KqrTVtHQxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiNHxXcfN8sGWS5Gumds4SaL7B8l5D0iymAW1INqA7I=;
 b=baed/beRhsQTykIcLrlspgjQ981MKD6ThO18hhVfvYiZVv7ps2PB/z0ZBKkSb/V6e/3dZBMKrsgHS9Gxq4OROhznLHIfGATveGb4RtUOVWUYNQtuIDeWVrPqrUNWrwIWPGtD6FiEzLY75nLbA9A9VrSJoFVuoSJ94mI2c1niI4tGVvHlG+UM3L3JU20ToOvdM3vfoaMZT0b00cVXXuSt5UKHWzXxn0OnGwDl2dvig4LgVD4jsK8AWDEBD1R69I1MBGJDMFhu5NAFH+LSc/Je3yqTDJfADo4ZdqQeCnSHXaMgpH6898QNlQiL2Kj+NCth1vJlO5D/rfqdj5+6YdJR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LiNHxXcfN8sGWS5Gumds4SaL7B8l5D0iymAW1INqA7I=;
 b=cwJUlC/rfqjKP+qKrL4ykQaT8js/QdBhuU4243J+6idR9gxAwUUQQEdQ1EF8snVSYDpj3dmTO8B9zq/IFr7QQpzCjlCm7PKzt40kWbwbtewm4+PNzSGr9J0wRrgR0ldplx0rHbKsbF0wkHvoB44SfV57daEtameKu1IPgL8d68A=
Received: from VE1PR02MB5550.eurprd02.prod.outlook.com (20.179.30.11) by
 VE1PR02MB5485.eurprd02.prod.outlook.com (20.179.31.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Fri, 3 Jan 2020 16:30:42 +0000
Received: from VE1PR02MB5550.eurprd02.prod.outlook.com
 ([fe80::d01e:58a8:3b2d:c74b]) by VE1PR02MB5550.eurprd02.prod.outlook.com
 ([fe80::d01e:58a8:3b2d:c74b%7]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 16:30:41 +0000
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
To:     Paulo Alcantara <pc@cjr.nz>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
Thread-Topic: cifs.upcall requests ticket for wrong host when using dfs
Thread-Index: AQHVwj+tztbeRMwVFU+OqRHcECQz4afZAQIAgAAgxYA=
Date:   Fri, 3 Jan 2020 16:30:41 +0000
Message-ID: <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz>
In-Reply-To: <87png0boej.fsf@cjr.nz>
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
x-ms-office365-filtering-correlation-id: f1a9dd8f-5c12-4176-caa9-08d7906a4666
x-ms-traffictypediagnostic: VE1PR02MB5485:
x-microsoft-antispam-prvs: <VE1PR02MB5485A7B10885E7B1C9FBD6C2F5230@VE1PR02MB5485.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39840400004)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(316002)(76116006)(66446008)(64756008)(19627235002)(31686004)(110136005)(6512007)(36756003)(478600001)(26005)(66556008)(2616005)(66946007)(186003)(66476007)(8936002)(71200400001)(81156014)(6506007)(31696002)(5660300002)(8676002)(81166006)(2906002)(53546011)(6486002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:VE1PR02MB5485;H:VE1PR02MB5550.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prodrive-technologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DPZf2tAn9JaRig/FImW21POTWmQiEyJWxOhOjp7xXAr0OwRC+wQZFADao5N9zfifUETwqPg6hCHbwL6ZQRND3JnDoD0ktAUf11uVm1+UEyMbItj3XT+9SaABKGsjuZYDuXI6NRABJSzs364I2KpFZIi/t9juOi4OSzQekNJ/uIXFpfqnSz2yijUe59vwEhLgkwJuAwvVTcJITcUZAyBEYoyBboRJCIQda14SCUjVqi1DXSI3bzAg2aX/OMeu9TFfbqOIrzG+5S9+j02mFF66NZWeLDk4sbknJ3ldCCnOm7DwANn4Mt67A3z5tyv8p4Icu0US1Wk5AFkb/IGsW61EzIo69z1l6TIEyRMn0KBO0nel3/T9+DaSBwktGsknMUaqhCErM551kGcYIawia9LmnbRPU0k6iJKVzEgISOPfVKPB04bpojpzXasbogkT3H8l
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5EB4BB2AA9AB8428EEC77B300394D9A@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a9dd8f-5c12-4176-caa9-08d7906a4666
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 16:30:41.7219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GNmIFfIZNrT8I9j06v7jszWwjh3NQxh59JiSLIg5N6AhCAljuHj37PLv5GVijr5fKx5h+ORXG7LbFOPR3Z5NrXgueacn3a75+eh72dvRU+4I8ftOpygkrch4y6W2QniwM6Ilv2KTgzOMfQICcZpGbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR02MB5485
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGkgUGF1bG8sDQoNCk9uIDAzLTAxLTIwMjAgMTU6MzMsIFBhdWxvIEFsY2FudGFyYSB3cm90ZToN
Cj4gSGkgTWFydGluaiwNCj4gDQo+IE1hcnRpam4gZGUgR291dyA8bWFydGlqbi5kZS5nb3V3QHBy
b2RyaXZlLXRlY2hub2xvZ2llcy5jb20+IHdyaXRlczoNCj4gDQo+PiBJJ20gdHJ5aW5nIHRvIHN3
aXRjaCBmcm9tIG50bHBzc3AgdG8ga2VyYmVib3MgZm9yIG1vdW50aW5nIG91ciBkZnMNCj4+IHNo
YXJlcy4gSXQgc2VlbXMgdG8gd29yaywgYnV0IG9ubHkgZm9yICdvbGRlcicga2VybmVsIHZlcnNp
b25zLiBTaW5jZSB3ZQ0KPj4gYXJlIHJ1bm5pbmcgZGViaWFuIDkgYW5kIDEwLCBJJ20gdGVzdGlu
ZyB0aGlzIGZvciBib3RoIHZlcnNpb24uIFRoZQ0KPj4gdGhpbmcgaXMgdGhhdCBpcyBzZWVtcyB0
byB3b3JrIHdoZW4gSSBydW4ga2VybmVsIDQuMTkuNjcsIGJ1dCBub3Qgd2hlbg0KPj4gSSdtIHJ1
bm5pbmcga2VybmVsIDUuMy45Lg0KPj4NCj4+IFdoYXQgSSdtIHRyeWluZyB0byBkbzoNCj4+IG1v
dW50IC10IGNpZnMgLy9kb21haW4uY29tL2NvbW1vbiAvbW50L2NvbW1vbiAtbw0KPj4gcncsdmVy
cz0zLjAsc2VjPWtyYjUsY3J1aWQ9MTAwMDMsdXNlcm5hbWU9bWRnLHVpZD0xMDAwMyxnaWQ9MTAy
NzYsYWRkcj0xMC4xLjEuMTQsZmlsZV9tb2RlPTA2MDAsZGlyX21vZGU9MDcwMCxub2JybCxub2hh
bmRsZWNhY2hlLHVzZXI9bWRnDQo+Pg0KPj4gU28gZmFyIGl0IHdvcmtzIGZpbmUgb24gNC4xOSwg
YnV0IG5vdCBvbiA1LjMuIEJlY2F1c2Ugd2hlbiBJIHRyeSB0bw0KPj4gdHJhdmVsIGludG8gdGhl
IGRpcmVjdG9yaWVzICh3aGljaCBhcmUgYWN0dWFsbHkgZGZzIHBvaW50ZXJzIHRvIHRoZSBOQVMN
Cj4+IHNoYXJlcykgSSBnZXQgcGVybWlzc2lvbiBkZW5pZWQuDQo+Pg0KPj4gU28gZmFyLCBJIHdh
cyBhYmxlIHRvIHRyYWNrIHRoaXMgZG93biB0byBjaWZzLnVwY2FsbCwgYmVjYXVzZSBvbiBrZXJu
ZWwNCj4+IDQuMTkgSSBzZWUgaXQgdHJpZXMgdG8gZ2V0IGEgc2VydmljZSB0aWNrZXQgZm9yIHRo
ZSBuYXMgKGNpZnMudXBjYWxsOg0KPj4gaGFuZGxlX2tyYjVfbWVjaDogZ2V0dGluZyBzZXJ2aWNl
IHRpY2tldCBmb3IgbmFzMDEuZG9tYWluLmNvbSkuIEJ1dCBvbg0KPj4ga2VybmVsIDUuMyBpdCB0
cmllcyB0byBnZXQgYSB0aWNrZXQgZm9yIHRoZSBkYyBhZ2FpbjogY2lmcy51cGNhbGw6DQo+PiBo
YW5kbGVfa3JiNV9tZWNoOiBnZXR0aW5nIHNlcnZpY2UgdGlja2V0IGZvciBkYzAxLmRvbWFpbi5j
b20uDQo+Pg0KPj4gV2hhdCBjb3VsZCBiZSB3cm9uZyBoZXJlPw0KPiANCj4gQ291bGQgeW91IHBs
ZWFzZSB0cnkgaXQgYWdhaW4gd2l0aCBiZWxvdyBjb21taXQ6DQo+IA0KPiAgICAgICAgNWJiMzBh
NGRkNjBlICgiY2lmczogRml4IHJldHJpZXZhbCBvZiBERlMgcmVmZXJyYWxzIGluIGNpZnNfbW91
bnQoKSIpDQoNCkkgdHJpZWQga2VybmVsIDUuNC42LCBpbmNsdWRpbmcgdGhpcyBmaXgsIGJ1dCBz
dGlsbCBubyBsdWNrOg0KWyAgIDI1LjgyNTA3NV0gQ0lGUzogQXR0ZW1wdGluZyB0byBtb3VudCAv
L2RvbWFpbi5jb20vY29tbW9uDQpbICAgMjcuMTI3OTI1XSBDSUZTIFZGUzogIEJBRF9ORVRXT1JL
X05BTUU6IFxcZG9tYWluLmNvbVxjb21tb24NClsgICAzMS40MDY2OTddIENJRlM6IEF0dGVtcHRp
bmcgdG8gbW91bnQgLy9EQzAxLmRvbWFpbi5jb20vY29tbW9uL1BkX1N0ZA0KWyAgIDMxLjQxNDUy
N10gc3J2IHJzcCBwYWRkZWQgbW9yZSB0aGFuIGV4cGVjdGVkLiBMZW5ndGggOTggbm90IDczIGZv
ciBjbWQ6MSBtaWQ6MQ0KWyAgIDMxLjQxNDUzM10gU3RhdHVzIGNvZGUgcmV0dXJuZWQgMHhjMDAw
MDA2ZCBTVEFUVVNfTE9HT05fRkFJTFVSRQ0KWyAgIDMxLjQxNDUzN10gQ0lGUyBWRlM6IFxcREMw
MS5kb21haW4uY29tIFNlbmQgZXJyb3IgaW4gU2Vzc1NldHVwID0gLTEzDQpbICAgMzEuNDE0NTQ0
XSBDSUZTIFZGUzogY2lmc19tb3VudCBmYWlsZWQgdy9yZXR1cm4gY29kZSA9IC0xMw0KWyAgIDMx
LjQxNDU5MF0gQ0lGUzogQXR0ZW1wdGluZyB0byBtb3VudCAvL0RDMDEuZG9tYWluLmNvbS9jb21t
b24vUGRfU3RkDQpbICAgMzEuNDIyNDEwXSBTdGF0dXMgY29kZSByZXR1cm5lZCAweGMwMDAwMDZk
IFNUQVRVU19MT0dPTl9GQUlMVVJFDQpbICAgMzEuNDIyNDE2XSBDSUZTIFZGUzogXFxEQzAxLmRv
bWFpbi5jb20gU2VuZCBlcnJvciBpbiBTZXNzU2V0dXAgPSAtMTMNClsgICAzMS40MjI0MjNdIENJ
RlMgVkZTOiBjaWZzX21vdW50IGZhaWxlZCB3L3JldHVybiBjb2RlID0gLTEzDQoNCldoZXJlIDQu
MTkgcHJpbnRzOg0KWyAgMTMyLjAxMjQ5OF0gQ0lGUzogQXR0ZW1wdGluZyB0byBtb3VudCAvL2Rv
bWFpbi5jb20vY29tbW9uDQpbICAxMzIuMTgzMDM4XSBDSUZTIFZGUzogZXJyb3IgLTIgb24gaW9j
dGwgdG8gZ2V0IGludGVyZmFjZSBsaXN0DQpbICAxMzIuMzQ0MzQzXSBDSUZTOiBBdHRlbXB0aW5n
IHRvIG1vdW50IC8vbmFzMDEvY29tbW9uJC9wZF9zdGQNCg0KPiANCj4gVGhhbmtzLA0KPiBQYXVs
bw0KPiANCg0KUmVnYXJkcywgTWFydGlqbg0KDQotLSANCk1hcnRpam4gZGUgR291dw0KRGVzaWdu
ZXINClByb2RyaXZlIFRlY2hub2xvZ2llcw0KTW9iaWxlOiArMzEgNjMgMTcgNzYgMTYxDQpQaG9u
ZTogICszMSA0MCAyNiA3NiAyMDANCg==
