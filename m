Return-Path: <SRS0=tjAs=R2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AEAC43381
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 00:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A0821925
	for <linux-cifs@archiver.kernel.org>; Sat, 23 Mar 2019 00:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b92rM2kW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfCWAmI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 20:42:08 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40525 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfCWAmH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Mar 2019 20:42:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id c207so2593362pfc.7;
        Fri, 22 Mar 2019 17:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EvANPA4cQu3tFGIrZH8K9g5xvSJnhOZO/zjy+8DcW0A=;
        b=b92rM2kWkAQnUSCT73Pw3MC1/w9IcAYfLsLQj59x0q1u1tOxYjR1Ep/PVi9OcbOuFa
         IJTyHDo74flY5M2FhG0b5gV6QEKIs+OXEzX7yHpdqITahsh34KhuTfROAM1EayFOkBqK
         1WC0fxfwBh+4F5UAIbfgQ3Sd+WLdgTqa6URPOV/iZC6IgnLNIpfi3/p7toLzNy5SF+hL
         QEdfqXPAkziYPpKD8RP5vj+cui3WmOAp4JwIoFoIZU5p5mTvnPE4YjTWqm1ay75vXgd0
         qKw4Nc1B2ycEosHtQ5kz7wE+j/6QRccp+0rzFvc3I5nWqW7Q+8WXRPtupEZmRpcv+HFK
         ga0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EvANPA4cQu3tFGIrZH8K9g5xvSJnhOZO/zjy+8DcW0A=;
        b=m02oMWy62jkuG0BgPyRM0Sn4wFQo//C4ry1PwqU7DvxmGZtThCD1qTPCiYmZOU2dg1
         tn1cSDMTzArhRH4X1m/ovWyuprwr/Q21+WDKPFNSNAcKHga9NWFyJHuT21XPWSVcuJv7
         xhL8zBARIFAtMx32WIdnsDN9nHIZoK+oRBJiGipBzzI901IwiDDLoCfMN3oYLv459hDN
         2Wpo7RgD+cZJCJ/J6preYLvY07GsqygpC5xAZOkBZsdLWWi5A3iMZ503gzbLIXI/qwuH
         9UWnNbwdemqTFfkVTvIfy6AQokOVJTL+D6fwx3RTHdOHWHpsBxLyXtF3Z9rsBKu2DUx4
         9OOw==
X-Gm-Message-State: APjAAAWZrVgl3ycXGidQ9ahob3igUAU4adr1nNtqGVkINoSqvkBNYWpf
        o2g/cWhnNgGAI+UunSgeQaMdtbznmwTVtDgxU4g=
X-Google-Smtp-Source: APXvYqw8/CqBBSFCK0VCySshEfwkJIMTcaENWx84q5wBYkeOo+FyX2CyXPfoldEVP4TPIbNiZ8g1iVz/g1m9fgavbOg=
X-Received: by 2002:a63:c06:: with SMTP id b6mr11765787pgl.440.1553301726617;
 Fri, 22 Mar 2019 17:42:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190321045902.14326-1-lsahlber@redhat.com> <CANYNYEHur0w8iNZBHUbc=NJopAH84gLb5k-Wv1ShU9--qREoCw@mail.gmail.com>
 <CAN05THSL-KCQ6QNm2fUERY1oHWC_jgfdWHuEO_0gnwLMM3TX1A@mail.gmail.com>
 <CAH2r5mua942M3C=8Mionj_JbjRm5LRm+=+f1SW3404a-k6naFQ@mail.gmail.com> <SN4PR2101MB07363664AD92F12AFB733698A05C0@SN4PR2101MB0736.namprd21.prod.outlook.com>
In-Reply-To: <SN4PR2101MB07363664AD92F12AFB733698A05C0@SN4PR2101MB0736.namprd21.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Mar 2019 19:41:54 -0500
Message-ID: <CAH2r5msRHNSkJy7D=C4gn3aVWSA_Ur1zkdM_c_2mhv+uKMG3zQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Andreas Hasenack <andreas@canonical.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The reason we didn't see this before SMB3.1.1 is that in
smb3_validate_negotiate we had this check:

        if (tcon->ses->user_name == NULL) {
                cifs_dbg(FYI, "Can't validate negotiate: null user mount\n");
                return 0; /* validation requires signing */
        }

Sounds like we should add the identical check in the smb3.1.1 tcon
check that Ronnie's earlier patch fixed (but only for Windows)



On Fri, Mar 22, 2019 at 7:20 PM Tom Talpey <ttalpey@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org> On
> > Behalf Of Steve French
> > Sent: Friday, March 22, 2019 7:30 PM
> > To: ronnie sahlberg <ronniesahlberg@gmail.com>
> > Cc: Andreas Hasenack <andreas@canonical.com>; Ronnie Sahlberg
> > <lsahlber@redhat.com>; linux-cifs <linux-cifs@vger.kernel.org>; Stable
> > <stable@vger.kernel.org>
> > Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
> >
> > I tried to Samba with guest mount and noted that Samba server did not
> > set the guest or null flags in the session setup response so we still
> > marked tcon as signed even with guest mount in my quick test (to Samba
> > 4.10)
>
> This gets to the point of my earlier comment. The flags and dialect etc
> are all fine to check, but the code is setting the SIGNED bit before it
> actually signs. Shouldn't it be verifying that it has a valid signing key
> before it does this?
>
> Another point to make here is that the SESSION_IS_GUEST is entirely
> the server's choice. Basically, what it means is the server arbitrarily
> authenticated the user as a guest, regardless of how the client attempted
> to log in. If it's set, then absolutely the client should forget that it ever
> attempted to authenticate as a given principal (and not sign, encrypt, etc).
> However, if it's clear, and the server made the user "guest", then:
>
>  a) the server is arguably buggy
>  b) the signing failure is by protocol design.
>
> Tom.
>
> > On Thu, Mar 21, 2019 at 2:54 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > On Fri, Mar 22, 2019 at 3:13 AM Andreas Hasenack
> > <andreas@canonical.com> wrote:
> > > >
> > > > Hello Ronnie,
> > > >
> > > > On Thu, Mar 21, 2019 at 1:59 AM Ronnie Sahlberg <lsahlber@redhat.com>
> > wrote:
> > > > >
> > > > > Fix Guest/Anonymous sessions so that they work with SMB 3.11.
> > > > >
> > > > > In git commit 6188f28 tightened the conditions and forced signing for
> > > > > the SMB2-TreeConnect commands as per MS-SMB2.
> > > > > However, this should only apply to normal user sessions and not for
> > > > > Guest/Anonumous sessions.
> > > > >
> > > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > > CC: Stable <stable@vger.kernel.org>
> > > > > ---
> > > > >  fs/cifs/smb2pdu.c | 8 ++++++--
> > > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > > > index c399e09b76e6..8e4a1da95418 100644
> > > > > --- a/fs/cifs/smb2pdu.c
> > > > > +++ b/fs/cifs/smb2pdu.c
> > > > > @@ -1628,9 +1628,13 @@ SMB2_tcon(const unsigned int xid, struct
> > cifs_ses *ses, const char *tree,
> > > > >         iov[1].iov_base = unc_path;
> > > > >         iov[1].iov_len = unc_path_len;
> > > > >
> > > > > -       /* 3.11 tcon req must be signed if not encrypted. See MS-SMB2
> > 3.2.4.1.1 */
> > > > > +       /*
> > > > > +        * 3.11 tcon req must be signed if not encrypted. See MS-SMB2
> > 3.2.4.1.1
> > > > > +        * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
> > > > > +        */
> > > > >         if ((ses->server->dialect == SMB311_PROT_ID) &&
> > > > > -           !smb3_encryption_required(tcon))
> > > > > +           !smb3_encryption_required(tcon) &&
> > > > > +           !(ses->session_flags &
> > (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)))
> > > > >                 req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
> > > > >
> > > > >         memset(&rqst, 0, sizeof(struct smb_rqst));
> > > > > --
> > > > > 2.13.6
> > > > >
> > > >
> > > >
> > > > I tried this patch with an ubuntu kernel
> > > >
> > (https://nam06.safelinks.protection.outlook.com/?url=https:%2F%2Fpeople.can
> > onical.com%2F~tyhicks%2Fdisco-
> > cifs.2%2F&amp;data=02%7C01%7Cttalpey%40microsoft.com%7C3cc97bf9482
> > 747afd16d08d6af1e62ff%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0
> > %7C636888942385347937&amp;sdata=i0kUZ4yinqjgvsDDc0N6LBTPlLt8DeNnt
> > WW1PhS0xVg%3D&amp;reserved=0 specifically) but
> > > > it didn't work, I'm still getting failures with smb3.11 and a guest
> > > > mount.
> > > >
> > > > Maybe I'm missing some other fix, or a more up-to-date kernel? Shall I
> > > > try with a self-compiled upstream one?
> > >
> > > Try with the current version of Steve's for-next branch plus this patch.
> > > I could reproduce the failure with 3.11 on for-next
> > > but when I added this patch then the mount was successful.
> > >
> > > At least that would verify that the current for-net works for you (or not).
> > > There may be other things missing in older kernels that broke 3.11 guest
> > mounts,
> > > but lets check if for-next works first.
> > >
> > > Regards
> > > Ronnie Sahlberg
> > >
> > > >
> > > > dmesg:
> > https://nam06.safelinks.protection.outlook.com/?url=http%3A%2F%2Fpaste.ub
> > untu.com%2Fp%2FJGhCsgBVcb%2F&amp;data=02%7C01%7Cttalpey%40micros
> > oft.com%7C3cc97bf9482747afd16d08d6af1e62ff%7C72f988bf86f141af91ab2d
> > 7cd011db47%7C1%7C0%7C636888942385347937&amp;sdata=r5eMhXks%2F
> > quoNzzhFahCKjMOE22fFlVCluwmRLWpmOc%3D&amp;reserved=0
> > > >
> > > > server logs (debug level 5, samba 4.10.0):
> > > > log.:
> > https://nam06.safelinks.protection.outlook.com/?url=http%3A%2F%2Fpaste.ub
> > untu.com%2Fp%2FjMDJ8DBfRM%2F&amp;data=02%7C01%7Cttalpey%40micr
> > osoft.com%7C3cc97bf9482747afd16d08d6af1e62ff%7C72f988bf86f141af91ab
> > 2d7cd011db47%7C1%7C0%7C636888942385347937&amp;sdata=4owqPDbgc
> > FOjQU%2BEt2aB1P77hFHbIuzoxOkdpX5X2eE%3D&amp;reserved=0
> > > > log.smbd:
> > https://nam06.safelinks.protection.outlook.com/?url=http%3A%2F%2Fpaste.ub
> > untu.com%2Fp%2FZ9W5z28BP9%2F&amp;data=02%7C01%7Cttalpey%40micr
> > osoft.com%7C3cc97bf9482747afd16d08d6af1e62ff%7C72f988bf86f141af91ab
> > 2d7cd011db47%7C1%7C0%7C636888942385357938&amp;sdata=66Ng0qrdbt
> > AwVirxqN3uWjEaFrRi1w6XGcX%2BZITmkOM%3D&amp;reserved=0
> > > > smb.conf:
> > https://nam06.safelinks.protection.outlook.com/?url=http%3A%2F%2Fpaste.ub
> > untu.com%2Fp%2F9HpSyFq8n8%2F&amp;data=02%7C01%7Cttalpey%40micro
> > soft.com%7C3cc97bf9482747afd16d08d6af1e62ff%7C72f988bf86f141af91ab2
> > d7cd011db47%7C1%7C0%7C636888942385357938&amp;sdata=U4dqv23dZN
> > KgaDAR2TbEmsrnkR6EnqejdVTPVLpIjKk%3D&amp;reserved=0
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
