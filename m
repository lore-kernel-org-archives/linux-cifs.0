Return-Path: <SRS0=KlGx=TD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0CAC43219
	for <linux-cifs@archiver.kernel.org>; Fri,  3 May 2019 15:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B133C2075C
	for <linux-cifs@archiver.kernel.org>; Fri,  3 May 2019 15:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="b2iSp5Ev"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfECP5Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 May 2019 11:57:24 -0400
Received: from mail-eopbgr700101.outbound.protection.outlook.com ([40.107.70.101]:49825
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfECP5Y (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 May 2019 11:57:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=WDcppC4TXLE4sjl6q7IiuI4fG6leXuByWs6Lj/K+50CzsiJneYiEhMNWv2mMeacW/jV6UsebqoJN7+rxzXHD5baKZ5+BzGmDbGfX1Ue3IqBO3gLLDP0kvhwFictyMqwsdIHSxZZKC4XZgROa1cug5SSGEZU/8sAxx1yScQQq79E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaF2xGmMKEo5FJDdTrOyQaKRcbKSqw2PgK7WBJg3wyw=;
 b=sRawLMgMn4A13045qrQfXRPZzSJln6ZhDya9XINM6klfC57KybGa7V9VcGEUwnSTYJIVBYljb9PhvV49En2Rmya6X+X2I1+KkqgzGBd0RW6H1Hr6ua/N3XrxqBWJT8S58AkcXpmfsCq9T5jDS0k3YVGsGmQ51KUp+MFlANwRHss=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AaF2xGmMKEo5FJDdTrOyQaKRcbKSqw2PgK7WBJg3wyw=;
 b=b2iSp5EvdYdmd3jxvXUcoe/VAsj+lyGhshBW9U0HBdZF9P8OH9SqDPzJwX0od2tWOks5318h84zF9o8dshzpFO68HDFxS/Mmy4Bt1tU+RYhInZ6sEmJDllZ3+om+vxiCFFMskeGZf05zvTx9mqp20497/0UNPKpN/ZUSBCBIM2o=
Received: from CY4PR21MB0149.namprd21.prod.outlook.com (10.173.189.19) by
 CY4PR21MB0760.namprd21.prod.outlook.com (10.173.195.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id
 15.20.1856.6; Fri, 3 May 2019 15:57:21 +0000
Received: from CY4PR21MB0149.namprd21.prod.outlook.com
 ([fe80::557b:1240:94cb:8f77]) by CY4PR21MB0149.namprd21.prod.outlook.com
 ([fe80::557b:1240:94cb:8f77%9]) with mapi id 15.20.1878.004; Fri, 3 May 2019
 15:57:21 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: RE: [PATCH][SMB3] Add missing defines for new negotiate contexts
Thread-Topic: [PATCH][SMB3] Add missing defines for new negotiate contexts
Thread-Index: AQHU9gDJf2vMizjMXkSZLohRVXfnP6ZCKvuAgAYumJCAEUrw8A==
Date:   Fri, 3 May 2019 15:57:20 +0000
Message-ID: <CY4PR21MB0149DC81B079BCD36D580AC5A0350@CY4PR21MB0149.namprd21.prod.outlook.com>
References: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
 <20190418172353.GB236057@jra4>
 <BN8PR21MB11863B736AA5D284CC213118A0220@BN8PR21MB1186.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB11863B736AA5D284CC213118A0220@BN8PR21MB1186.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-04-22T15:50:30.4876102Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f0abb4e3-ff34-476d-93c6-1b868e8a85b8;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [2001:4898:80e8:b:d82a:7b3b:e387:5826]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ab1b744-8453-44b0-6145-08d6cfe006ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:CY4PR21MB0760;
x-ms-traffictypediagnostic: CY4PR21MB0760:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CY4PR21MB0760ACF01958C57D5D11A14EA0350@CY4PR21MB0760.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(366004)(39860400002)(376002)(13464003)(189003)(199004)(7696005)(6246003)(55016002)(14444005)(8676002)(71200400001)(54906003)(256004)(6436002)(11346002)(53936002)(6116002)(2906002)(25786009)(4326008)(229853002)(966005)(52536014)(110136005)(9686003)(10290500003)(14454004)(6306002)(478600001)(316002)(305945005)(66476007)(7736002)(8990500004)(99286004)(74316002)(66446008)(76176011)(66556008)(71190400001)(76116006)(5660300002)(486006)(66946007)(73956011)(64756008)(102836004)(10090500001)(6506007)(33656002)(186003)(68736007)(476003)(22452003)(81156014)(81166006)(86612001)(46003)(86362001)(53546011)(446003)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR21MB0760;H:CY4PR21MB0149.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E3YIVP21+EhWmadAJaKUmCGw3xk5tbYpIuN4vCGa4ju0TQKLeYslmgQrZPRQPBKc8tcgLjDU5tu/HGO3oyRUc1dHEijdDzzyS22Mjb0o/U6fUQiIdgjpJ6mb+a2nRZDkRGPJ5bsaiiqs9acOqNA1AMbdGu/FtH5/fqonufbkIyPt1XZ1ttm7qNXws8MkemC3PWAjiG+Rtkrqt4CAEJpYO4SxmWVmVkqvo53NPqETxgP26vIjAR7MwUp0PrOmex/dN9uSX7xt1ul7LzxesshxHjR+TTQscyJqBuA4XbzGWP3/033uOUEzJbREBG5UD1NbUO59JbBsMduozyehEFxUDoubROZtN0d6evqWmA5zAy2/IfEQBpH47RywL713KrLQyqQ7QDD62FXf6LTPOk2aKLgxpv+H/zHx6hyVr15PwgU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab1b744-8453-44b0-6145-08d6cfe006ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 15:57:21.0287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0760
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>=
 On
> Behalf Of Tom Talpey
> Sent: Monday, April 22, 2019 8:51 AM
> To: Jeremy Allison <jra@samba.org>; Steve French <smfrench@gmail.com>
> Cc: CIFS <linux-cifs@vger.kernel.org>; samba-technical <samba-
> technical@lists.samba.org>
> Subject: RE: [PATCH][SMB3] Add missing defines for new negotiate contexts
>=20
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.or=
g>
> On
> > Behalf Of Jeremy Allison
> > Sent: Thursday, April 18, 2019 1:24 PM
> > To: Steve French <smfrench@gmail.com>
> > Cc: CIFS <linux-cifs@vger.kernel.org>; samba-technical <samba-
> > technical@lists.samba.org>
> > Subject: Re: [PATCH][SMB3] Add missing defines for new negotiate contex=
ts
> >
> > On Thu, Apr 18, 2019 at 11:06:57AM -0500, Steve French via samba-techni=
cal
> > wrote:
> > > See updated MS-SMB2 - two new negotiate contexts
> >
> > Link to latest update ? Is this a draft update
> > or a full new version ?
>=20
> The Windows protocol documents were updated on March 13 for the
> upcoming "19H1" update cycle.
>=20
> MS-SMB2 version page, with latest, diffs, etc:
>=20
> https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/5606=
ad47-5ee0-437a-817e-70c366052962

So, there was a defect in the published spec which we just corrected, there=
's a new
update online at the above page.

The value of the new compression contextid is actually "3", but the earlier=
 document
incorrectly said "4". There were several other fixes and clarifications in =
the pipeline
which have also been included.

Redline diffs as well as the usual standard publication formats are availab=
le.

Tom.
