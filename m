Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F016C4332B
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 15:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38EFB60241
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 15:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhBXPLM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 10:11:12 -0500
Received: from mail-eopbgr1320108.outbound.protection.outlook.com ([40.107.132.108]:34213
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238133AbhBXOlW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 09:41:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5ZLxX9Iz7FFeuybohmIinwWlChmekDwvrFGz9quMw+PkKNVMaP+LlzPQPhm3IZCZIrpc+XvLqXZvQKGGZs1oHS8SqGcBeFK7+2hG6rrWR5HjIs7qxV/uUwb2JPLZuD52LxlhB/VijEigEXaYiy3wNxjCVP9WUEB3MlBwKaq1DbmdaatHqtEbpzkbjKLceEkZ8cThaty/Byh6LoOE41MXGjWsD8QT6OrLfWOuAp2c1RnhQiogwaaxJP9uZg80U9gZadW1zf8EgyXPt6L3stFl/SjQ/U96D77qylhdVKsYXBPELExLjpvsVAWRH+IXZB2QZhZhKJ+e/5Kr0nEt+CNUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib+n3nDui+eVVFoX20SX4f4vIrBJPdHWHEzS3IOnEiI=;
 b=c5iGNdcj3J0YKin8TA2M7rZjvrsrryee4RxE8b7RgByOuAV+4CJbRi0q9ASk/vYqvkW//dut9cVNjxX9Wjus5xw5ahqJpxgE8YUjeO5uGuyT//0B+cwHhaOCYBzxsV1Q03SQuALDMWXyEEpEHfT97KC+qE7TBUSdHNk3Qn9y3pzZCa99eWsd9fr1o9JZeR1GK70HBsSrnwNiNpSnpjRZbjuo1BAx3bXljmoOxBnq/cKpXCiDWWTzGna8VeuakTvLJ+qS0cjj9dyBEdHZiEpxt3yw8zW9WbSFEpYizOZh5P13x46bxOA2LM5J+0pNP++XhmL+rXa+eYKNS6DzF4usJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib+n3nDui+eVVFoX20SX4f4vIrBJPdHWHEzS3IOnEiI=;
 b=HVlcWtBAjW8Gb8KuunQnAMWJiVOGm7Om3G0xbLybNI8gdDWnK3Ocm3mYP/ULx8JXj/LiJ1+piYTFm3RaRgM8IhiPjKHgaz7gcgmDh6d6HrwkRg3R7DZH1nS+hXze/Owp2ej9vIgW7ZBfZp621mzO4MEKA3+oLzh74WCS72ALcwI=
Received: from SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM (2603:1096:3:10::19)
 by SG2P153MB0271.APCP153.PROD.OUTLOOK.COM (2603:1096:4:ad::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.4; Wed, 24 Feb 2021 14:39:49 +0000
Received: from SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM
 ([fe80::5d0e:cc2a:fa6d:fa05]) by SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM
 ([fe80::5d0e:cc2a:fa6d:fa05%6]) with mapi id 15.20.3912.009; Wed, 24 Feb 2021
 14:39:49 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Colin Ian King <colin.king@canonical.com>
CC:     Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] re: cifs: Retain old ACEs when converting between mode
 bits and ACL.
Thread-Topic: [EXTERNAL] re: cifs: Retain old ACEs when converting between
 mode bits and ACL.
Thread-Index: AQHXCqrIw9zDZtQZXUOLyaxc7/KTFqpnYEZA
Date:   Wed, 24 Feb 2021 14:39:49 +0000
Message-ID: <SG2P15301MB00639032FD6F37360A458E2D949F9@SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM>
References: <1ca0f87e-83b3-b4dd-4448-b44f2a9d1698@canonical.com>
In-Reply-To: <1ca0f87e-83b3-b4dd-4448-b44f2a9d1698@canonical.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=91c84b95-1c93-4685-afa3-63f144f4b2d5;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-02-24T14:39:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:3:60f4:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c9aa288-99da-4e23-84c0-08d8d8d20a18
x-ms-traffictypediagnostic: SG2P153MB0271:
x-microsoft-antispam-prvs: <SG2P153MB0271F21B31DED7440CC9E318949F9@SG2P153MB0271.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k05JOo1msoBzmhjefV8aFR/YoostyGt2UZTjfuGfCcYr00R7b4fbgpWqoaLuwmcRv9F1agAPu7PMoBG1o9YDpmTK2/PW646dURZWiuB1ipLZWzm9b/ykKGydNqcrPDdn7VKySmD6zvp0Bo0CZMG7IV5MCRDKnZlPPfKD8LmvAIZAYwhWALqbTE1fAJfB28aca93AgXFrTYRvDmYdQWhpbT5mQg9zp0VXL0ymyZiE38vdHhwXn2G5t0EnWFyewEyeheTUvSs0FEcwPSIRvI3yjIDIvpsAKVokAdWBReMuZ3BsYc2MXZskPfMCkbnlA61V75UXljD0UshzRkHVTfw5tsP4TGoRK4vr13ycS5zXQgd5eQp4R20rJMMyp1luXmAszUId/P+GihJt0lARdkon+fq4IKQhqwtcG3nM6lO2itVuAPGlbLvYFR+rEExx1fA++/71ecnUgfbizgbW4qa3cLiqu8U7HLHyNXL3b3E95p8rKC5O1hkk+sSOgSf6p5ZvVKg6FnNyM1mY/jbkHAu/pA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(186003)(6916009)(7696005)(4326008)(8990500004)(8936002)(55016002)(316002)(71200400001)(6506007)(53546011)(8676002)(54906003)(5660300002)(82950400001)(2906002)(9686003)(82960400001)(52536014)(86362001)(478600001)(83380400001)(76116006)(33656002)(66476007)(66446008)(10290500003)(64756008)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QXZhMUFYVjRXWVFCMzNsY0Z5d3QvU1BNYlNFTVU3K0lOeHhQL29MdEJIazcv?=
 =?utf-8?B?aEZvSGFsSXM0Q2NyWkRrbTZ0S253Yis3WXRJQW9FdVlWVFdyTkliS3hJVy8r?=
 =?utf-8?B?S0s1RWtaZkkwaU8rL1JrUE9kaldCMm85Mk9Qb0tsMWxuU0ZnYUJiYlN4ZlBl?=
 =?utf-8?B?N1o1aTBDRTdYOUFtUDVHNklzNzRDbWRYNk1CLzBWRnRrY09SVE11VWNPb0J0?=
 =?utf-8?B?OHpRbWR5MnAvS0VVdHdOSThhdnovc0hXa2ZaWnRBQUZNNXliM21wbW1yQlhO?=
 =?utf-8?B?clloR2Vxc09lUmZ1YW4wbU1mM3d0OTM2WHMyNXRXMERRRzZKbUd1U3VvQ3ZG?=
 =?utf-8?B?YzV1RktIUzJ3UUdlYTlXRHhBdVI0eXFYZ2lzRC9OWmFBYjlrS3VmK1NodVNH?=
 =?utf-8?B?V0ZCZ1lwdjZOZkxVOVdYRFkzbmUvdUFxOWZkV1lhemw3anhiQlJnRVFvYUtT?=
 =?utf-8?B?SzFmaHZTMjAxb3lnM1ZERkNkcGJoZCtWdCtHaWxVNXB4Q1lvQUxyNS9ld2N4?=
 =?utf-8?B?MkFvSkgvemR3SlBxaGZUUU9Ga0ZtcWdBWFNmK3ZPSUhBTWQyTzJYaU8yc2Qz?=
 =?utf-8?B?dGdqb0ZIby9Ra1A3VkZ4TzlxOGMwVDMvRjNicllSZVVNRHpKclJORjlyeFNz?=
 =?utf-8?B?RnFSVytUN3orMDhENjFBNEx3WDcvWkF6MDNkT3FIOEp3a3UzaDJXUURhRDk4?=
 =?utf-8?B?eENjVXNBcXp5T0dNOW5aQnYxcXFNamRHMU5sUE9uZ1ZhMXkzQmdnam9yREJU?=
 =?utf-8?B?UEt6QW5Hc09yNkF0SkRCZ3UzTkViMTV4aWJETnNYR1RqTmkyekdnSUpjVHk1?=
 =?utf-8?B?dGNuL1BSVWZBbCt4WThMRnlCa2M2T0wwaEpERUIzVGJyTjJ1OFVkY0pDRjRw?=
 =?utf-8?B?TjF0eHRiUUp6OEJpei82ODB5b1czL0cwMHZocFZlUWg4SkZNZXRMYnQ1eDAz?=
 =?utf-8?B?VjlRL2R0K0VGKzhRNTV1dWJNVVh4ajhrOVJwa3NPT1V5ZE45QTdQanlvS29l?=
 =?utf-8?B?a2ZuNFlxY21Mak9WOHRSRmh4dlBzTlNUMXRQdExTZDdRNmFXZytSd1ZxaFJu?=
 =?utf-8?B?V0lGTXJENVdsS1p4YTZNclR4RmFQOVZ2Q05iczQwbExaV2R5czJvVGNwZ1p3?=
 =?utf-8?B?RnE0UDJNWDB0ZHFnTXl3TW4vZ3hEL2dnM1htTjBQUk1vMVVKWW9yc2hoUmc0?=
 =?utf-8?B?eWxSSmd4ai93RFN1UnR5VEYwamNCczhybWk2V2lxSEVJbWY2QnNBcURMVUNP?=
 =?utf-8?B?T2ZWMGxmazZpNTV4RWcwY3RITFJUcGZDMDBwd1N4MnlhZzRoNmVxcGZWN3pE?=
 =?utf-8?B?UDFTZW40ek1vTG12S2RSRzhFaGUzUllJQURYVEVrbEo3VlIwMk5hbDFQb1hQ?=
 =?utf-8?B?UGJwUVB1WG9oZHlJdUExUi9rWnFHK1RqVTNiQk9wcVpScFVaV2lrUlJUck83?=
 =?utf-8?B?Nm5nbDZ3UjgzTllreXdaTzJUb1JJbjY2TjVRVk13SFpJYVR3RnRUbzNnejZv?=
 =?utf-8?B?R1QrN3VaNHIrM1VIWFVCYURLWkRFS1NuSklHYVhnNG1nd29mUlJQSXBuYjZu?=
 =?utf-8?B?TzBYZWRPcHRUbWk0Y3huc3hDWGVsUUZoZ0g0VUYrS2dqaG9QdCtHRTdkOGJT?=
 =?utf-8?B?eWZYeEtnWlhyNlp4bER6eEdya0tWdllFU3BhVTJIL05COGFBT2pweVM3aW1s?=
 =?utf-8?B?M0lDKzBtaTdTSXJtTzlRa2R0SFdSRGtrM0RROEpFYzNUVm5EeEMxVVgxdzd0?=
 =?utf-8?B?TjI3R2ozbFhkVnNYb3FWTmFmTjc5cWtSTEJIT1RYZ2p0SktTejRtczlUMmI4?=
 =?utf-8?Q?oRI30mFLIoDG7k/F9HR3HCMTPbg0NL/nLlytQ=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2P15301MB0063.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c9aa288-99da-4e23-84c0-08d8d8d20a18
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 14:39:49.4357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ga3dhjW/iNryqii41SZVEY01L6Ul2cgp3dVh9bPvnCMXswr9dfebuRInmIPgELCp9a1SjeFgeVmAb4aQA0j8Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2P153MB0271
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGkgQ29saW4sDQoNClRoYW5rcyBmb3IgcmVwb3J0aW5nIHRoaXMuIEknbGwgc3VibWl0IGEgZml4
Lg0KDQpSZWdhcmRzLA0KU2h5YW0NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206
IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+IA0KU2VudDogV2VkbmVz
ZGF5LCBGZWJydWFyeSAyNCwgMjAyMSA2OjE0IFBNDQpUbzogU2h5YW0gUHJhc2FkIDxTaHlhbS5Q
cmFzYWRAbWljcm9zb2Z0LmNvbT4NCkNjOiBTdGV2ZSBGcmVuY2ggPHNmcmVuY2hAc2FtYmEub3Jn
PjsgbGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc7IHNhbWJhLXRlY2huaWNhbEBsaXN0cy5zYW1i
YS5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFtFWFRFUk5BTF0g
cmU6IGNpZnM6IFJldGFpbiBvbGQgQUNFcyB3aGVuIGNvbnZlcnRpbmcgYmV0d2VlbiBtb2RlIGJp
dHMgYW5kIEFDTC4NCg0KSGksDQoNClN0YXRpYyBhbmFseXNpcyBvbiBsaW51eC1uZXh0IHdpdGgg
Q292ZXJpdHkgaGFkIGRldGVjdGVkIGEgcG90ZW50aWFsIG51bGwgcG9pbnRlciBkZXJlZmVyZW5j
ZSB3aXRoIHRoZSBmb2xsb3dpbmcgY29tbWl0Og0KDQpjb21taXQgZjUwNjU1MDg4OTdhOTIyMzI3
ZjMyMjIzMDgyMzI1ZDEwYjA2OWViYw0KQXV0aG9yOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBt
aWNyb3NvZnQuY29tPg0KRGF0ZTogICBGcmkgRmViIDEyIDA0OjM4OjQzIDIwMjEgLTA4MDANCg0K
ICAgIGNpZnM6IFJldGFpbiBvbGQgQUNFcyB3aGVuIGNvbnZlcnRpbmcgYmV0d2VlbiBtb2RlIGJp
dHMgYW5kIEFDTC4NCg0KVGhlIGFuYWx5c2lzIGlzIGFzIGZvbGxvd3M6DQoNCjEyNTggLyogQ29u
dmVydCBwZXJtaXNzaW9uIGJpdHMgZnJvbSBtb2RlIHRvIGVxdWl2YWxlbnQgQ0lGUyBBQ0wgKi8N
CjEyNTkgc3RhdGljIGludCBidWlsZF9zZWNfZGVzYyhzdHJ1Y3QgY2lmc19udHNkICpwbnRzZCwg
c3RydWN0IGNpZnNfbnRzZCAqcG5udHNkLA0KMTI2MCAgICAgICAgX191MzIgc2VjZGVzY2xlbiwg
X191MzIgKnBuc2VjZGVzY2xlbiwgX191NjQgKnBubW9kZSwga3VpZF90DQp1aWQsIGtnaWRfdCBn
aWQsDQoxMjYxICAgICAgICBib29sIG1vZGVfZnJvbV9zaWQsIGJvb2wgaWRfZnJvbV9zaWQsIGlu
dCAqYWNsZmxhZykNCjEyNjIgew0KMTI2MyAgICAgICAgaW50IHJjID0gMDsNCjEyNjQgICAgICAg
IF9fdTMyIGRhY2xvZmZzZXQ7DQoxMjY1ICAgICAgICBfX3UzMiBuZGFjbG9mZnNldDsNCjEyNjYg
ICAgICAgIF9fdTMyIHNpZHNvZmZzZXQ7DQoxMjY3ICAgICAgICBzdHJ1Y3QgY2lmc19zaWQgKm93
bmVyX3NpZF9wdHIsICpncm91cF9zaWRfcHRyOw0KMTI2OCAgICAgICAgc3RydWN0IGNpZnNfc2lk
ICpub3duZXJfc2lkX3B0ciA9IE5VTEwsICpuZ3JvdXBfc2lkX3B0ciA9IE5VTEw7DQoNCiAgICAx
LiBhc3NpZ25femVybzogQXNzaWduaW5nOiBkYWNsX3B0ciA9IE5VTEwuDQoNCjEyNjkgICAgICAg
IHN0cnVjdCBjaWZzX2FjbCAqZGFjbF9wdHIgPSBOVUxMOyAgLyogbm8gbmVlZCBmb3IgU0FDTCBw
dHIgKi8NCjEyNzAgICAgICAgIHN0cnVjdCBjaWZzX2FjbCAqbmRhY2xfcHRyID0gTlVMTDsgLyog
bm8gbmVlZCBmb3IgU0FDTCBwdHIgKi8NCjEyNzEgICAgICAgIGNoYXIgKmVuZF9vZl9hY2wgPSAo
KGNoYXIgKilwbnRzZCkgKyBzZWNkZXNjbGVuOw0KMTI3MiAgICAgICAgdTE2IHNpemUgPSAwOw0K
MTI3Mw0KMTI3NCAgICAgICAgZGFjbG9mZnNldCA9IGxlMzJfdG9fY3B1KHBudHNkLT5kYWNsb2Zm
c2V0KTsNCg0KICAgIDIuIENvbmRpdGlvbiBkYWNsb2Zmc2V0LCB0YWtpbmcgZmFsc2UgYnJhbmNo
Lg0KDQoxMjc1ICAgICAgICBpZiAoZGFjbG9mZnNldCkgew0KMTI3NiAgICAgICAgICAgICAgICBk
YWNsX3B0ciA9IChzdHJ1Y3QgY2lmc19hY2wgKikoKGNoYXIgKilwbnRzZCArDQpkYWNsb2Zmc2V0
KTsNCjEyNzcgICAgICAgICAgICAgICAgaWYgKGVuZF9vZl9hY2wgPCAoY2hhciAqKWRhY2xfcHRy
ICsNCmxlMTZfdG9fY3B1KGRhY2xfcHRyLT5zaXplKSkgew0KMTI3OCAgICAgICAgICAgICAgICAg
ICAgICAgIGNpZnNfZGJnKFZGUywgIkV4aXN0aW5nIEFDTCBzaXplIGlzIHdyb25nLg0KRGlzY2Fy
ZGluZyBvbGQgQUNMXG4iKTsNCjEyNzkgICAgICAgICAgICAgICAgICAgICAgICBkYWNsX3B0ciA9
IE5VTEw7DQoNCk5PVEU6IGRhY2xfcHRyIGlzIHNldCB0byBOVUxMIGFuZCBkYWNsb2Zmc2V0IGlz
IHRydWUNCg0KMTI4MCAgICAgICAgICAgICAgICB9DQoxMjgxICAgICAgICB9DQoxMjgyDQoxMjgz
ICAgICAgICBvd25lcl9zaWRfcHRyID0gKHN0cnVjdCBjaWZzX3NpZCAqKSgoY2hhciAqKXBudHNk
ICsNCjEyODQgICAgICAgICAgICAgICAgICAgICAgICBsZTMyX3RvX2NwdShwbnRzZC0+b3NpZG9m
ZnNldCkpOw0KMTI4NSAgICAgICAgZ3JvdXBfc2lkX3B0ciA9IChzdHJ1Y3QgY2lmc19zaWQgKiko
KGNoYXIgKilwbnRzZCArDQoxMjg2ICAgICAgICAgICAgICAgICAgICAgICAgbGUzMl90b19jcHUo
cG50c2QtPmdzaWRvZmZzZXQpKTsNCjEyODcNCg0KICAgIDMuIENvbmRpdGlvbiBwbm1vZGUsIHRh
a2luZyB0cnVlIGJyYW5jaC4NCiAgICA0LiBDb25kaXRpb24gKnBubW9kZSAhPSAxODQ0Njc0NDA3
MzcwOTU1MTYxNVVMTCwgdGFraW5nIGZhbHNlIGJyYW5jaC4NCg0KMTI4OCAgICAgICAgaWYgKHBu
bW9kZSAmJiAqcG5tb2RlICE9IE5PX0NIQU5HRV82NCkgeyAvKiBjaG1vZCAqLw0KMTI4OSAgICAg
ICAgICAgICAgICBuZGFjbG9mZnNldCA9IHNpemVvZihzdHJ1Y3QgY2lmc19udHNkKTsNCjEyOTAg
ICAgICAgICAgICAgICAgbmRhY2xfcHRyID0gKHN0cnVjdCBjaWZzX2FjbCAqKSgoY2hhciAqKXBu
bnRzZCArDQpuZGFjbG9mZnNldCk7DQoxMjkxICAgICAgICAgICAgICAgIG5kYWNsX3B0ci0+cmV2
aXNpb24gPQ0KMTI5MiAgICAgICAgICAgICAgICAgICAgICAgIGRhY2xvZmZzZXQgPyBkYWNsX3B0
ci0+cmV2aXNpb24gOg0KY3B1X3RvX2xlMTYoQUNMX1JFVklTSU9OKTsNCjEyOTMNCjEyOTQgICAg
ICAgICAgICAgICAgbmRhY2xfcHRyLT5zaXplID0gY3B1X3RvX2xlMTYoMCk7DQoxMjk1ICAgICAg
ICAgICAgICAgIG5kYWNsX3B0ci0+bnVtX2FjZXMgPSBjcHVfdG9fbGUzMigwKTsNCjEyOTYNCjEy
OTcgICAgICAgICAgICAgICAgcmMgPSBzZXRfY2htb2RfZGFjbChkYWNsX3B0ciwgbmRhY2xfcHRy
LA0Kb3duZXJfc2lkX3B0ciwgZ3JvdXBfc2lkX3B0ciwNCjEyOTggICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBwbm1vZGUsIG1vZGVfZnJvbV9zaWQpOw0KMTI5OQ0KMTMwMCAgICAg
ICAgICAgICAgICBzaWRzb2Zmc2V0ID0gbmRhY2xvZmZzZXQgKyBsZTE2X3RvX2NwdShuZGFjbF9w
dHItPnNpemUpOw0KMTMwMSAgICAgICAgICAgICAgICAvKiBjb3B5IHRoZSBub24tZGFjbCBwb3J0
aW9uIG9mIHNlY2Rlc2MgKi8NCjEzMDIgICAgICAgICAgICAgICAgKnBuc2VjZGVzY2xlbiA9IGNv
cHlfc2VjX2Rlc2MocG50c2QsIHBubnRzZCwgc2lkc29mZnNldCwNCjEzMDMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIE5VTEwsIE5VTEwpOw0KMTMwNA0KMTMwNSAgICAgICAgICAgICAg
ICAqYWNsZmxhZyB8PSBDSUZTX0FDTF9EQUNMOw0KMTMwNiAgICAgICAgfSBlbHNlIHsNCjEzMDcg
ICAgICAgICAgICAgICAgbmRhY2xvZmZzZXQgPSBzaXplb2Yoc3RydWN0IGNpZnNfbnRzZCk7DQox
MzA4ICAgICAgICAgICAgICAgIG5kYWNsX3B0ciA9IChzdHJ1Y3QgY2lmc19hY2wgKikoKGNoYXIg
Kilwbm50c2QgKw0KbmRhY2xvZmZzZXQpOw0KDQogICAgNS4gQ29uZGl0aW9uIGRhY2xvZmZzZXQs
IHRha2luZyBmYWxzZSBicmFuY2guDQoNCjEzMDkgICAgICAgICAgICAgICAgbmRhY2xfcHRyLT5y
ZXZpc2lvbiA9DQoxMzEwICAgICAgICAgICAgICAgICAgICAgICAgZGFjbG9mZnNldCA/IGRhY2xf
cHRyLT5yZXZpc2lvbiA6DQpjcHVfdG9fbGUxNihBQ0xfUkVWSVNJT04pOw0KDQogICAgRXhwbGlj
aXQgbnVsbCBkZXJlZmVyZW5jZWQgKEZPUldBUkRfTlVMTCkNCg0KICAgIDYuIHZhcl9kZXJlZl9v
cDogRGVyZWZlcmVuY2luZyBudWxsIHBvaW50ZXIgZGFjbF9wdHIuDQoNCjEzMTEgICAgICAgICAg
ICAgICAgbmRhY2xfcHRyLT5udW1fYWNlcyA9IGRhY2xfcHRyLT5udW1fYWNlczsNCg0KDQpMaW5l
IDEzMDkuLjEzMTEsIHdoZW4gZGFjbG9mZnNldCBhbmQgZGFjbF9wdHIgaXMgbnVsbCB3ZSBoaXQg
YSBudWxsIHB0ciBkZXJlZmVyZW5jZSBvbiBkYWNsX3B0ci4NCg0K
