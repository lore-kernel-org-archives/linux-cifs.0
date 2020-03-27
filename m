Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B34BC43331
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 05:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0452F20714
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 05:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="QTtfVH6n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgC0Fly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:41:54 -0400
Received: from mail-bn8nam12on2116.outbound.protection.outlook.com ([40.107.237.116]:17735
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgC0Fly (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 27 Mar 2020 01:41:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z44uqVSccQvnDr4SEdHQGzndiOSyfPJdJody+6y+F+aQrIlHk7maprXUxLiVW8GUHEx5Lzg2DcRpq2gXIm9V6mb+cNOetyzf3spsxKb45CndNlhQBXFBvXG1bASCuneG85kOUfujFWTctvXU+eSSSj6/MGjQf5ElJRvZU+cXftbpbDv8kTH5zIgjXIVcXgvihlF+kEZXIiDvIvo6mpLvt2R7Nds2/1FJfmKv0JR2q5u7vf55XObbgQp+Bj9zBp3Ejy2wXk39obrNYp4glK0llVfmlhmO7OPx5gOEFCX/OrDjbMLk0u8CwR9ifAGEsH5X1Z0VQcYCPGkpQMgVZ19BSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=407qbvaXOwH4+VFCN4wAc2aTLnpq21I1BrERdNMs2lI=;
 b=NmI7udPVlW46ML/QOvNM5IANXawRo6zBQsvZopGOPJKRSIcGmH30moP4eug3kcJF7XLS/EkFJodX5JsOPKyv6TdXX+btZyrtNlB5TeIYEtqBU6jukGXZIoIfGIx/FRWewyaywsdEDMBqoYazCRBMG3S0sLujqDBFK5nXpk3N3tR8dGk861jw3BLw17MeytFzex/7rVN2FS72lmimtdpabmcf0wVIzLrpGwN80U3WOV9GNCwe1EOwliuifuKTEQkCpIl3GGeOPwl1zvOEsG9FBFJ0ok09kmf31JkU6t+1mcnScJjFvVKuaAI/AO10+jwhyX1VBBeCy1WeTJXKlkozcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=407qbvaXOwH4+VFCN4wAc2aTLnpq21I1BrERdNMs2lI=;
 b=QTtfVH6nKNRCRsd4JLmocuQgsqhM2NnkhnVw6FjDSMbDYUyhphc+x5PiSK2R93Zkf3AkzWM/w+wt0YDXpa2i/pm5fNYQoMtq9+ZuMCWvI2T4/VdzjuW/yLQ+lImyPuuKKFKPemwy4BodZN+JZCL+PvTS4MvYoeR69EvZgrOzD3M=
Received: from BN8PR21MB1155.namprd21.prod.outlook.com (2603:10b6:408:73::10)
 by BN8PR21MB1203.namprd21.prod.outlook.com (2603:10b6:408:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.2; Fri, 27 Mar
 2020 05:41:21 +0000
Received: from BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::d11:18b7:289c:ea17]) by BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::d11:18b7:289c:ea17%7]) with mapi id 15.20.2878.000; Fri, 27 Mar 2020
 05:41:21 +0000
From:   Long Li <longli@microsoft.com>
To:     =?utf-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@suse.com>,
        "longli@linuxonhyperv.com" <longli@linuxonhyperv.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] cifs: Remove locking in smb2_verify_signature() when
 calculating SMB2/SMB3 signature on receiving packets
Thread-Topic: [PATCH] cifs: Remove locking in smb2_verify_signature() when
 calculating SMB2/SMB3 signature on receiving packets
Thread-Index: AQHWAtFD/Rup8jtV9E+7q8K5j1eLM6hao/yAgAFKpPA=
Date:   Fri, 27 Mar 2020 05:41:21 +0000
Message-ID: <BN8PR21MB1155DCB17C62EDCE529922ABCECC0@BN8PR21MB1155.namprd21.prod.outlook.com>
References: <1585159997-115196-1-git-send-email-longli@linuxonhyperv.com>
 <87d08zzbg6.fsf@suse.com>
In-Reply-To: <87d08zzbg6.fsf@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:ede4:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad504827-4ce4-4ebe-7e70-08d7d2117ae9
x-ms-traffictypediagnostic: BN8PR21MB1203:
x-microsoft-antispam-prvs: <BN8PR21MB1203489C05E1B74E780E53F3CECC0@BN8PR21MB1203.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1155.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(66476007)(66556008)(5660300002)(66574012)(66446008)(64756008)(8990500004)(7696005)(186003)(82950400001)(316002)(82960400001)(76116006)(33656002)(9686003)(2906002)(86362001)(71200400001)(66946007)(110136005)(6506007)(8936002)(81166006)(81156014)(478600001)(55016002)(8676002)(10290500003)(52536014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xFMuafOfg2MpYCRW0J73xk2KyU92z9bBTq33fh3dW3k0v7Sl57vRRTLl6ZzewWDD+28DytyOpvo+5+JOlEtajK3pXsOVZ4OKyrphyp+0ycWbCqHhEpPtcl7jz8yqp8M6uCOazbnTKaavggh9CywS+mDoIPzLXFn5YGJB13Q8AetDTpf+jSq5tIKJ6gOTMmqCp4xPm0FTGkBTtSypch+Ti3UH0gjL838eZmZ5y022CDvBHmb6B9mrG+AqTGgnb78dkeCBfVV9q80ltJfXg+2+17Wl6DCDlGV/C3MwnekMVKkeY5sKGkxFySWFQD2Gpx9Ii6N3lUMUQcRzYfrX/wa4d6IzdqGuQXWXHN1Lumb+NkqvHt6roHaVKUWb05qtiutNIYM7uCnIsnQzkmSWzZqcqxzlB0SJiZC6GwYmocEbLlGbU3XJrOq7X6A6RgwaM7yY
x-ms-exchange-antispam-messagedata: 6g8bW7480c+UwuZH9UdUt741PkIhZZDYJ1waNUbQhZ7kVFExXNYhXMXUhfZJf/louplyQNADf0M3PssQYL0mxiMD3iL8ULDKYrDGOcho6C6XmnJjiga5uAD52SpLpcxKr92lFMN7Lla+k3V1kVgIAs1Ki31vq+F5/eC4qi1bHdeWr1rc4DQB3S3/AShoIkqKj9tN78ISZoUpI0SrpjbMqA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad504827-4ce4-4ebe-7e70-08d7d2117ae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 05:41:21.3614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2nJ3RyqF9OWpy+XBO4S1JDSrFM2nnpKcF+Z3r5g41ymIQha5BV6eEGFkKgmOtTSCluB5t7jppAarUmao6tEPlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1203
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PlN1YmplY3Q6IFJlOiBbUEFUQ0hdIGNpZnM6IFJlbW92ZSBsb2NraW5nIGluIHNtYjJfdmVyaWZ5
X3NpZ25hdHVyZSgpIHdoZW4NCj5jYWxjdWxhdGluZyBTTUIyL1NNQjMgc2lnbmF0dXJlIG9uIHJl
Y2VpdmluZyBwYWNrZXRzDQo+DQo+bG9uZ2xpQGxpbnV4b25oeXBlcnYuY29tIHdyaXRlczoNCj4+
IE9uIHRoZSBzZW5kaW5nIGFuZCByZWNlaXZpbmcgcGF0aHMsIENJRlMgdXNlcyB0aGUgc2FtZSBj
eXB0byBkYXRhDQo+PiBzdHJ1Y3R1cmVzIHRvIGNhbGN1bGF0ZSBTTUIyL1NNQjMgcGFja2V0IHNp
Z25hdHVyZXMuIEEgbG9jayBvbiB0aGUNCj4+IHJlY2VpdmluZyBwYXRoIGlzIG5lY2Vzc2FyeSB0
byBjb250cm9sIHNoYXJlZCBhY2Nlc3MgdG8gY3J5cHRvIGRhdGENCj4+IHN0cnVjdHVyZXMuIFRo
aXMgbG9jayBkZWdyYWRlcyBwZXJmb3JtYW5jZSBiZWNhdXNlIGl0IHJhY2VzIHdpdGggdGhlDQo+
c2VuZGluZyBwYXRoLg0KPj4NCj4+IERlZmluZSBzZXBhcmF0ZSBjcnlwdG8gZGF0YSBzdHJ1Y3R1
cmVzIGZvciBzZW5kaW5nIGFuZCByZWNlaXZpbmcgcGF0aHMNCj4+IGFuZCByZW1vdmUgdGhpcyBs
b2NrLg0KPg0KPlNvbWV0aGluZyBJJ3ZlIG9mdGVuIHdvbmRlcmVkOiB3aHkgZG8gd2Uga2VlcCBj
cnlwdG8gc3RhdGUgaW4gdGhlIHNlcnZlcg0KPnN0cnVjdHVyZSBpbnN0ZWFkIG9mIGNyZWF0aW5n
IGl0IGFzIG5lZWRlZCBpbiB0aGUgY2FsbGVyIHN0YWNrICh0aHVzIGF2b2lkaW5nIHRoZQ0KPm5l
ZWQgZm9yIGxvY2tzKS4gQUZBSUsgdGhlcmUncyBubyBzdGF0ZSB0aGF0IG5lZWQgdG8gYmUga2Vw
dCBiZXR3ZWVuDQo+c2lnbmluZy9lbmNyeXB0aW5nIGNhbGxzIGJlc2lkZSB0aGUgYWNjZXNzIHRv
IGtleXMuIElzIGl0IHRoYXQgZXhwZW5zaXZlIHRvDQo+Y3JlYXRlL3JlbGVhc2U/DQoNCk15IGd1
ZXNzIGlzIHRoYXQgY3J5cHRvX2FsbG9jX3NoYXNoKCkgaXMgYSBoZWF2eSBjYWxsPw0KDQo+DQo+
Q2hlZXJzLA0KPi0tDQo+QXVyw6lsaWVuIEFwdGVsIC8gU1VTRSBMYWJzIFNhbWJhIFRlYW0NCj5H
UEc6IDE4MzkgQ0I1RiA5RjVCIEZCOUIgQUE5NyAgOEM5OSAwM0M4IEE0OUIgNTIxQiBENUQzIFNV
U0UgU29mdHdhcmUNCj5Tb2x1dGlvbnMgR2VybWFueSBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQw
OSBOw7xybmJlcmcsIERFDQo+R0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgTWFyeSBIaWdnaW5zLCBT
cmkgUmFzaWFoIEhSQiAyNDcxNjUgKEFHIE3DvG5jaGVuKQ0K
