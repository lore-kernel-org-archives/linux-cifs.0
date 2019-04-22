Return-Path: <SRS0=FjIb=SY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474B2C10F11
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Apr 2019 15:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41312077C
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Apr 2019 15:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Ih39Dpkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfDVPue (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Apr 2019 11:50:34 -0400
Received: from mail-eopbgr770093.outbound.protection.outlook.com ([40.107.77.93]:25411
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727343AbfDVPue (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Apr 2019 11:50:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=oGkrJHPTu47keRaqTbb7IVpQmLTlZnxwCJIMzRWgvpa853AK8Po7F2hC/MD7ngIUOY8Kle4IAUVZv54ynHiNu5hUGMtRFGFNJubbZ10jB1B+YFmglFbW2VMpHYYEDd235L0xiYta0WZUWSHJaSsQwUiC+2TOEGLjleKALkq2KUA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51KDNgJghqIyHO75tljqAPs+nx4yMpYhxTGLnwAxuwI=;
 b=eex1PY7GXxob81nTiZusiJLXrMcLzCP1PkhYxWtJsMkRlPyJw010E8oDF8sZfcjw3WlAqFIQfnU79NMyCGPEyWpze1szeYeXwTTCwc9t+ZB+Uv6VkFyhnT4QxBemaLm9gDYGy5GuqTxdJyK6JGGkUxoFD5CZEBnNIlCpiCq9BsQ=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51KDNgJghqIyHO75tljqAPs+nx4yMpYhxTGLnwAxuwI=;
 b=Ih39DpkmOBMitEIapT2kETQ64LDAN4c5YsjnCd4Eya6YPyGUZONi45V7PussyKAEFAevOKsTkAbjP7Ie7bkhJNqm69YzTcH56nQKc27YQxevgAyFvtZbHLYkjH7mI4XBlRVdB1T09Bizn2cWY2sZDuSg7CVU76Pg4bcqFT36ldc=
Received: from BN8PR21MB1186.namprd21.prod.outlook.com (20.179.73.78) by
 BN8PR21MB1297.namprd21.prod.outlook.com (20.179.74.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.4; Mon, 22 Apr 2019 15:50:32 +0000
Received: from BN8PR21MB1186.namprd21.prod.outlook.com
 ([fe80::fd3b:ec19:62af:45a2]) by BN8PR21MB1186.namprd21.prod.outlook.com
 ([fe80::fd3b:ec19:62af:45a2%9]) with mapi id 15.20.1835.000; Mon, 22 Apr 2019
 15:50:32 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>
CC:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: RE: [PATCH][SMB3] Add missing defines for new negotiate contexts
Thread-Topic: [PATCH][SMB3] Add missing defines for new negotiate contexts
Thread-Index: AQHU9gDJf2vMizjMXkSZLohRVXfnP6ZCKvuAgAYumJA=
Date:   Mon, 22 Apr 2019 15:50:31 +0000
Message-ID: <BN8PR21MB11863B736AA5D284CC213118A0220@BN8PR21MB1186.namprd21.prod.outlook.com>
References: <CAH2r5mvEYMEUjz8BDRUumn0yGq__VntNKx-8AzWcZgCDOJQv-Q@mail.gmail.com>
 <20190418172353.GB236057@jra4>
In-Reply-To: <20190418172353.GB236057@jra4>
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
x-originating-ip: [2601:18f:901:8a17::1004]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a5d6068-f783-40a5-35a6-08d6c73a4053
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN8PR21MB1297;
x-ms-traffictypediagnostic: BN8PR21MB1297:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BN8PR21MB1297F93C3BFC0EC53281DD5EA0220@BN8PR21MB1297.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 00159D1518
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(366004)(39860400002)(136003)(376002)(346002)(13464003)(189003)(199004)(9686003)(97736004)(86612001)(6246003)(6306002)(86362001)(53936002)(74316002)(68736007)(25786009)(7736002)(4326008)(305945005)(10090500001)(486006)(55016002)(10290500003)(8990500004)(66446008)(66476007)(66556008)(64756008)(66946007)(76116006)(73956011)(14454004)(478600001)(8936002)(33656002)(76176011)(54906003)(8676002)(52536014)(99286004)(7696005)(81166006)(81156014)(6116002)(316002)(110136005)(22452003)(102836004)(966005)(6436002)(229853002)(46003)(11346002)(446003)(476003)(71190400001)(71200400001)(5660300002)(6506007)(2906002)(186003)(53546011)(256004)(14444005)(4744005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR21MB1297;H:BN8PR21MB1186.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uM+SBAZ6jrMV6xezAmlhhkhQDEWfgLCXVgMTICOaUvw3hy6ygCJcbJFL4rNO5HyGFWrWqLrH2UMkHQH0qz1JDSjoFu544LxKWhYtbwNcczdvv7igWb7+jZ78Rl8vDOJfqw/JuypnE5PsU+fQNGc3lVq5CCAtRUlJ2K6IWJpluu9Mc2rB9qDE/SU0Bxxy+EMHCPVe+k2rQ2dTUpxDhbgxiQXq3cSRKflqAq81IpJ0TKYOdeNbfw0FuC/Nj6A+hs7RAZ0QfM9bn/3tBlWDsXjyvRPnBponHnFCioUQr1mewfImdHWIH21lwMl5eEhvsAyl7HxW+ppA3y/5Ai64e8QvlLi1Yr6343W23b8M0jRwbTX2GP1lSTMDQFGWz3+XzigX4pWtL8VB41DkbMMaW2ATXdiJsCTivmXvq7zI8pa8xm0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5d6068-f783-40a5-35a6-08d6c73a4053
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2019 15:50:31.8938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1297
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>=
 On
> Behalf Of Jeremy Allison
> Sent: Thursday, April 18, 2019 1:24 PM
> To: Steve French <smfrench@gmail.com>
> Cc: CIFS <linux-cifs@vger.kernel.org>; samba-technical <samba-
> technical@lists.samba.org>
> Subject: Re: [PATCH][SMB3] Add missing defines for new negotiate contexts
>=20
> On Thu, Apr 18, 2019 at 11:06:57AM -0500, Steve French via samba-technica=
l
> wrote:
> > See updated MS-SMB2 - two new negotiate contexts
>=20
> Link to latest update ? Is this a draft update
> or a full new version ?

The Windows protocol documents were updated on March 13 for the upcoming "1=
9H1" update cycle.

MS-SMB2 version page, with latest, diffs, etc:

https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/5606ad=
47-5ee0-437a-817e-70c366052962

Tom.
