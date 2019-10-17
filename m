Return-Path: <SRS0=tZQk=YK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6EBFA372A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 19:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65E521835
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 19:58:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Gy7Ih0Rh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfJQT6T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:58:19 -0400
Received: from mail-eopbgr680132.outbound.protection.outlook.com ([40.107.68.132]:26182
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394533AbfJQT6T (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Oct 2019 15:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jc843Qe5qTOI4CiNT2abp13YDmXBsKm5vFpwK1SyQfaoqTRZupxtDPBfi2e5sgKRlARVI/VRADHFafD+wLjHklLCX5YvBIpx24peFCSHDDZdEwUiVIRT4Bb2uM5dFah8tQ5inVB+i+Wb83D7d+0dLLl0dJjgo2h4vbQ3Sf3AIZJVFdFCd7osVEtIB30p9J/sAsQwDsPLRIZJg5jsyReYqheE5xL+lmryRbG8HEq1Fein6gYOmnFpGVzXg+VKolS/w7dvDxFmLjm2xmiBMtWIn7Ac8bHDoiIOm7uCHGuzFC8ES+jD/KToHkEKSGW8wtrFG0LQBk1LFxpXtMoK1EAtSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezss1D+B61cZB2awrv2rlxH12e2ruxhHdRMBvKR6PoQ=;
 b=ixcV2aOfWndIIPOJ4BSRNQZtl0FYt+aiRC1cWn5K1OzinZxPGGAaaQP2lblE5R+qWiiUwt7bPz03l+dvPZJfVOkvt8fYHMjvK8iznbqpvkxgD/sflA3xqRRc0gAH/atpy0NAtAPyvZm+WBSeBD01p7ffd13JdkXDKKeov0EduNhYKOdz50IdjnQdJIjjEspsGugtHymdi5a+V6bc/3LLEWWNu897ytQpZDPvlMdoJLzdBbfqFbDLaGiofkeoqtKp9TkohW4CGDogN9pW8m7lbHC6QEZIXrkUbFd73X/SrTD1sb3t0qQ8ThEDEQkaihdxzwBt2atGkaw/wW6HJHH5Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezss1D+B61cZB2awrv2rlxH12e2ruxhHdRMBvKR6PoQ=;
 b=Gy7Ih0RhSYahIvxloBBY9xtK9F+9farYaRQHUzYF+H9WHCH3nydvBEfOsSYUI6zcnG5CbcmRu6sQi3zQkmm0IKmrc0gDA4hqRg+GpRHDgQ3Bt9Sz0IAUtpJdjeUzdBPM89ergqptHOihv2WA0+Ti9X6SK5wOb3NhhLBYWhjNUC0=
Received: from DM5PR21MB0185.namprd21.prod.outlook.com (10.173.173.136) by
 DM5PR21MB0761.namprd21.prod.outlook.com (10.173.172.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id
 15.20.2367.2; Thu, 17 Oct 2019 19:58:15 +0000
Received: from DM5PR21MB0185.namprd21.prod.outlook.com
 ([fe80::40b9:1196:e1ef:8fa4]) by DM5PR21MB0185.namprd21.prod.outlook.com
 ([fe80::40b9:1196:e1ef:8fa4%11]) with mapi id 15.20.2387.010; Thu, 17 Oct
 2019 19:58:15 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     David Wysochanski <dwysocha@redhat.com>
CC:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Subject: RE: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Topic: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Index: AQHVhFfJ9oP6OHPYNEeW5MnF2E27oqdd98kAgACTlgCAACvBAIAAKOAAgAAWtQCAADArYIAAEQ8AgAAJKVA=
Date:   Thu, 17 Oct 2019 19:58:15 +0000
Message-ID: <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <1206360169.6955748.1571271438699.JavaMail.zimbra@redhat.com>
 <1205168.6984242.1571303132895.JavaMail.zimbra@redhat.com>
 <CALF+zOkAEH5Zz9wBmTBM21wLcWU7mKnpFAktxdpNGyo4xET5zA@mail.gmail.com>
 <1383472639.7033868.1571321306723.JavaMail.zimbra@redhat.com>
 <CALF+zOnkhUYZpu_2xPVHaXx8CeX_kR+caVZj4YLmoYWR-aQaqg@mail.gmail.com>
 <DM5PR21MB018567FF1ED90591DC1D43D0B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
In-Reply-To: <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-17T19:58:13.7589590Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9f94681c-9dd9-41ad-b4bd-21ce2648b16c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:886b:711c:fc21:5d2a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c84aa77-4653-4b6e-1ea3-08d7533c5957
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0761:
x-microsoft-antispam-prvs: <DM5PR21MB0761F5EFD79AF54C4DA74420B66D0@DM5PR21MB0761.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(13464003)(189003)(199004)(64756008)(8936002)(66556008)(22452003)(54906003)(316002)(66446008)(86362001)(66476007)(81166006)(81156014)(8676002)(2906002)(76116006)(66946007)(10090500001)(33656002)(99286004)(6116002)(8990500004)(256004)(486006)(14444005)(476003)(5660300002)(11346002)(305945005)(446003)(52536014)(7736002)(478600001)(229853002)(6506007)(4326008)(74316002)(55016002)(9686003)(186003)(71200400001)(71190400001)(102836004)(6916009)(25786009)(10290500003)(6246003)(46003)(6436002)(53546011)(76176011)(7696005)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0761;H:DM5PR21MB0185.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ONN5Dopnxup0g2l7BJ5RWP0wuYRwDM1OPQa9yXVz5UrbItAuxi6zmNisQF3jkV42Cgv+Bq3gUlMCUgBGcD+KahO0PmP6W2TOHGWTq8FuAUKvpjFaroNoRMFVpLXxH65Xb54srucFTrFkAMeloFdo84IjDvoG/voEowiJ/td48NtDIwZiCoZQZV/LtpMPf1TZhQMcslZy52mn22dGVv3WTCFZ01G7BwcuQbZXM2+D4MTVsg3FRx6nzrszNL+Z8X8Jki4lb0PD3KjBUGxjxaP2hzqU8FhdMRb+wfQPRDlTkgLRhw5kB+a4+3vwRJEmbspe8yzjzR5CjvjiyNgbQnKW5wtYeuYcUVw5k1JM2rw60wG9zIM0mvwFOMoTTZeNjqAxQljofwBFkVfg6RJBi/0necrS5laDS8cjLA85R115c9E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c84aa77-4653-4b6e-1ea3-08d7533c5957
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 19:58:15.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DiIg3kAKtNAcMoXh4t/jw9qrY1tmv2KZ5Bykd9bSqPBHoPHaYPoRE/kMEuSYKpJYrxKug30IXEgsMTLETjTuOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0761
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DQpUaGUgcGF0Y2ggbG9va3MgZ29vZC4gTGV0J3Mgc2VlIGlmIGl0IGZpeGVzIHRoZSBpc3N1ZSBp
biB5b3VyIHNldHVwLg0KDQotLQ0KQmVzdCByZWdhcmRzLA0KUGF2ZWwgU2hpbG92c2t5DQoNCi0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBEYXZpZCBXeXNvY2hhbnNraSA8ZHd5c29j
aGFAcmVkaGF0LmNvbT4gDQpTZW50OiBUaHVyc2RheSwgT2N0b2JlciAxNywgMjAxOSAxMjoyMyBQ
TQ0KVG86IFBhdmVsIFNoaWxvdnNraXkgPHBzaGlsb3ZAbWljcm9zb2Z0LmNvbT4NCkNjOiBSb25u
aWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+OyBsaW51eC1jaWZzIDxsaW51eC1jaWZz
QHZnZXIua2VybmVsLm9yZz47IEZyYW5rIFNvcmVuc29uIDxzb3JlbnNvbkByZWRoYXQuY29tPg0K
U3ViamVjdDogUmU6IGxpc3RfZGVsIGNvcnJ1cHRpb24gd2hpbGUgaXRlcmF0aW5nIHJldHJ5X2xp
c3QgaW4gY2lmc19yZWNvbm5lY3Qgc3RpbGwgc2VlbiBvbiA1LjQtcmMzDQpPbiBUaHUsIE9jdCAx
NywgMjAxOSBhdCAyOjI5IFBNIFBhdmVsIFNoaWxvdnNraXkgPHBzaGlsb3ZAbWljcm9zb2Z0LmNv
bT4gd3JvdGU6DQo+DQo+IFRoZSBzaW1pbGFyIHNvbHV0aW9uIG9mIHRha2luZyBhbiBleHRyYSBy
ZWZlcmVuY2Ugc2hvdWxkIGFwcGx5IHRvIHRoZSBjYXNlIG9mIHJlY29ubmVjdCBhcyB3ZWxsLiBU
aGUgcmVmZXJlbmNlIHNob3VsZCBiZSB0YWtlbiBkdXJpbmcgdGhlIHByb2Nlc3Mgb2YgbW92aW5n
IG1pZCBlbnRyaWVzIHRvIHRoZSBwcml2YXRlIGxpc3QuIE9uY2UgYSBjYWxsYmFjayBjb21wbGV0
ZXMsIHN1Y2ggYSByZWZlcmVuY2Ugc2hvdWxkIGJlIHB1dCBiYWNrIHRodXMgZnJlZWluZyB0aGUg
bWlkLg0KPg0KDQpBaCBvayB2ZXJ5IGdvb2QuICBUaGUgYWJvdmUgc2VlbXMgY29uc2lzdGVudCB3
aXRoIHRoZSB0cmFjZXMgSSdtIHNlZWluZyBvZiB0aGUgcmFjZS4NCkkgYW0gZ29pbmcgdG8gdGVz
dCB0aGlzIHBhdGNoIGFzIGl0IHNvdW5kcyBsaWtlIHdoYXQgeW91J3JlIGRlc2NyaWJpbmcgYW5k
IHNpbWlsYXIgdG8gd2hhdCBSb25uaWUgc3VnZ2VzdGVkIGVhcmxpZXI6DQoNCi0tLSBhL2ZzL2Np
ZnMvY29ubmVjdC5jDQorKysgYi9mcy9jaWZzL2Nvbm5lY3QuYw0KQEAgLTU2NCw2ICs1NjQsNyBA
QCBjaWZzX3JlY29ubmVjdChzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpDQogICAgICAg
IHNwaW5fbG9jaygmR2xvYmFsTWlkX0xvY2spOw0KICAgICAgICBsaXN0X2Zvcl9lYWNoX3NhZmUo
dG1wLCB0bXAyLCAmc2VydmVyLT5wZW5kaW5nX21pZF9xKSB7DQogICAgICAgICAgICAgICAgbWlk
X2VudHJ5ID0gbGlzdF9lbnRyeSh0bXAsIHN0cnVjdCBtaWRfcV9lbnRyeSwgcWhlYWQpOw0KKyAg
ICAgICAgICAgICAgIGtyZWZfZ2V0KCZtaWRfZW50cnktPnJlZmNvdW50KTsNCiAgICAgICAgICAg
ICAgICBpZiAobWlkX2VudHJ5LT5taWRfc3RhdGUgPT0gTUlEX1JFUVVFU1RfU1VCTUlUVEVEKQ0K
ICAgICAgICAgICAgICAgICAgICAgICAgbWlkX2VudHJ5LT5taWRfc3RhdGUgPSBNSURfUkVUUllf
TkVFREVEOw0KICAgICAgICAgICAgICAgIGxpc3RfbW92ZSgmbWlkX2VudHJ5LT5xaGVhZCwgJnJl
dHJ5X2xpc3QpOyBAQCAtNTc2LDYgKzU3Nyw3IEBAIGNpZnNfcmVjb25uZWN0KHN0cnVjdCBUQ1Bf
U2VydmVyX0luZm8gKnNlcnZlcikNCiAgICAgICAgICAgICAgICBtaWRfZW50cnkgPSBsaXN0X2Vu
dHJ5KHRtcCwgc3RydWN0IG1pZF9xX2VudHJ5LCBxaGVhZCk7DQogICAgICAgICAgICAgICAgbGlz
dF9kZWxfaW5pdCgmbWlkX2VudHJ5LT5xaGVhZCk7DQogICAgICAgICAgICAgICAgbWlkX2VudHJ5
LT5jYWxsYmFjayhtaWRfZW50cnkpOw0KKyAgICAgICAgICAgICAgIGNpZnNfbWlkX3FfZW50cnlf
cmVsZWFzZShtaWRfZW50cnkpOw0KICAgICAgICB9DQoNCiAgICAgICAgaWYgKGNpZnNfcmRtYV9l
bmFibGVkKHNlcnZlcikpIHsNCg0K
