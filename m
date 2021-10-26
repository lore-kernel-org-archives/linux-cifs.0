Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D77C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Oct 2021 10:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8930A60F9D
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Oct 2021 10:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhJZKLR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Oct 2021 06:11:17 -0400
Received: from smtppost.atos.net ([193.56.114.176]:6313 "EHLO
        smarthost3.atos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232378AbhJZKLQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Oct 2021 06:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=atos.net; i=@atos.net; q=dns/txt; s=mail;
  t=1635242933; x=1666778933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9pZL2DvrIQZ6+T1iv0UePDwDGIyY3a6E4Gt97LRMt7Y=;
  b=ax9hQQAsf6LhXARkvyDE/tJvn6qf0qOJHbqtHq2vtX9eXM5TbS6ZBOYQ
   QVH5NYp+SqXp6HcPgl81hiyvxLNVnxuR1q6WOYKerd2ClEevTG7pZfpJ9
   8WgZqCirI/5IrYWVKWY2WGajLXAQprIlpjKsm1yOvXWepEEPbhaTMYNgB
   Y=;
X-IronPort-AV: E=Sophos;i="5.87,182,1631570400"; 
   d="scan'208";a="274668658"
X-MGA-submission: =?us-ascii?q?MDHPxeUOmlYwzju6H2ZKZcbwzIHtb7WUm4ykLY?=
 =?us-ascii?q?1u3+vAZeqMpirA42/r3xeYCBL6Af278RWJjQeH316dHS/QXZ61wDav+r?=
 =?us-ascii?q?VXWnMb4zfp4FVD1SxS3dTdrz0dM7bg78vVzS8C/TSI2eSlgqUQ8AUJ1c?=
 =?us-ascii?q?mN?=
Received: from mail.sis.atos.net (HELO GITEXCPRDMB13.ww931.my-it-solutions.net) ([10.89.28.143])
  by smarthost3.atos.net with ESMTP/TLS/AES256-GCM-SHA384; 26 Oct 2021 12:08:48 +0200
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net (10.89.28.144) by
 GITEXCPRDMB13.ww931.my-it-solutions.net (10.89.28.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 12:08:48 +0200
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net
 ([fe80::4817:dcd:3f05:31dd]) by GITEXCPRDMB14.ww931.my-it-solutions.net
 ([fe80::4817:dcd:3f05:31dd%8]) with mapi id 15.01.2308.015; Tue, 26 Oct 2021
 12:08:48 +0200
From:   "Weiser, Michael" <michael.weiser@atos.net>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Jacob Shivers <jshivers@redhat.com>
CC:     Leif Sahlberg <lsahlber@redhat.com>, Simo Sorce <simo@redhat.com>,
        "Shyam Prasad N" <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        "The GSS-Proxy developers and users mailing list" 
        <gss-proxy@lists.fedorahosted.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
Thread-Topic: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
Thread-Index: AQHXCgvMbLbyZ+7iUU2CMDV0Fo+sRau0mFWAgAQpC56ABauzgIAhAp2AgAAGO4CAAbxQAIAEZ6AAgADeGco=
Date:   Tue, 26 Oct 2021 10:08:48 +0000
Message-ID: <4edcf2fc7ee94b1a8898149bc997ea20@atos.net>
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net>
 <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
 <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com>
 <c49c0a18c228e6aa43dbb2cbab7e0a266d1c0371.camel@redhat.com>
 <CANT5p=p_G+jMMVMkYDL=fXZi_OO7eY2Foz8VkyQuT+1h5Xgifw@mail.gmail.com>
 <facbd0542074a5b8ef2f6f3d5649010503d8d84d.camel@redhat.com>
 <CALe0_75RLR=gcwitnxvACh1mt3jnOGHFx7baO0YRhwEfKwFoGg@mail.gmail.com>
 <CAKywueTUqhathrJmPc7eyNojv1F=199mNcFCENzoQjntK+CAzw@mail.gmail.com>
 <10598d01fe09433ea57a38142b7fb854@atos.net>
 <CALe0_74J8h5F4k2aH2Vh5RvtEtfBZ0nrvE614uM87AuVnWZ+gw@mail.gmail.com>
 <CAKywueSC6azd68E7MHQKtebGL7B=v4Z4O+5tGU3vf3WJbSZgnw@mail.gmail.com>
 <CAGvGhF5rVU1WzLk=aE36n47P357UBOPbsjXE=B8J+feO3bVSSQ@mail.gmail.com>
 <CALe0_77Bv_+v9cdNd_AL5DgA2+EaXMtF_0+rUw6y46fhHq0M4A@mail.gmail.com>,<CAKywueQU8P-XQsiy4x6B=0YjuwUmTzPVg--SY0sWzGuq6Oy_-w@mail.gmail.com>
In-Reply-To: <CAKywueQU8P-XQsiy4x6B=0YjuwUmTzPVg--SY0sWzGuq6Oy_-w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [160.92.209.239]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Pavel,

I've now also had a chance to look at this in more detail. I've done a quic=
k test and
everything still seems to work with the next branch.

> The only concern that I have is the compile warning below. Would
> appreciate it if you provide a fix for that.

FWIW: I do not get that warning either on Fedora 33 with gcc 10.3 and krb5-=
1.18.2-29.fc33
nor on Debian testing as of today with gcc 10.3 and krb5-1.18.3-7 nor on Ge=
ntoo
with gcc-11.2.0 and mit-krb5-1.19.2. But I do see that gssproxy has run int=
o this as well and
solved it the same way. Looking at gssapi docs and source I do not see that=
 we're doing
anything wrong here.

There's one minor additional change I found in my local branch switching fr=
om
(gss_OID)gss_nt_service_name to the more modern GSS_C_NT_HOSTBASED_SERVICE
in gss_import_name(). I've opened a PR on github. (Below as well but the gr=
oupware will
likely corrupt it.)

The old style bled over from an MIT krb5 example I based my initial trials =
on. The removed
cast might require another discard_const() now. Since I can't reproduce it,=
 I'd leave that up
to you.

Author: Michael Weiser <michael.weiser@atos.net>
Date:   Tue Oct 26 11:11:48 2021 +0200

    cifs.upcall: switch to RFC principal type naming

    Switch from old-style MIT krb5 gss_nt_service_name principal type
    constant name to the now preferred GSS_C_NT_HOSTBASED_SERVICE.

    Signed-off-by: Michael Weiser <michael.weiser@atos.net>

diff --git a/cifs.upcall.c b/cifs.upcall.c
index e9c7f5f..f11bfa6 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -794,7 +794,7 @@ cifs_gss_get_req(const char *host, DATA_BLOB *mechtoken=
, DATA_BLOB *sess_key)
        target_name_buf.length =3D service_name_len;

        maj_stat =3D gss_import_name(&min_stat, &target_name_buf,
-                       (gss_OID)gss_nt_service_name, &target_name);
+                       GSS_C_NT_HOSTBASED_SERVICE, &target_name);
        free(service_name);
        if (GSS_ERROR(maj_stat)) {
                cifs_gss_display_status("gss_import_name", maj_stat, min_st=
at);
--=20
Thanks
Michael
