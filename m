Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8682EC433E7
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 17:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B0E722254
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 17:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hf1fo7OK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgJORll (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 13:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgJORll (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 13:41:41 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9FBC061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 10:41:39 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id m20so4023286ljj.5
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 10:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ldOolQJUb+PKoTbiPWuWXO+TWoZN81+yEaHYx6erLw8=;
        b=hf1fo7OKSmo4YYbVlruVQqiXMuUDuOjrRy8AY6QzLk35+TvZPxZ9BYVl9CIuy2UUwE
         u+Yini5gT1spAV319T0zZYM7RUMSDk9WjcLXQRPfZWQQTt2xsjlspK3d1kSmLN54MbBa
         mF1kxJN3UvmIJQv8NAsxH8UhzgutPtCN+YS+QGyUPI2QfWH3JVvoEN8eSS2WxpqzUUjA
         nVqUGjkbmxi39V3sDitiuJ7IY5QZBY367nRPZN67pNnxvbFRx/yDsZhQAxq63vp7ufSI
         69X/3BnzHed1xxqRklgVA/MYRFnEkwFjjb8oKDetod1HIBg2sMJCmHy0OA/lCVhJsI0d
         ODCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ldOolQJUb+PKoTbiPWuWXO+TWoZN81+yEaHYx6erLw8=;
        b=R8VEYEWZi2052g+jTsoIXb+QKDCxKnkDnv7vMZX5F95kR8jnE3Ic8DjyRipUpgpvEs
         ssuKM8NpHj2VTWrTDUPbgKEDmfQJiQ83wm7TmNZPC9XevMhr9s+bmk2s1F4k2K72gqpm
         t4/I5D2GG0e+8ElQM4bGcOPkvCZKPekWW/k0omde+L+N1ZWE3K0AHztfeb1RzmHIvFYO
         rE1/mMb8ynz3YQk0ZF+Sbobgp6FViNJLgzfwTySV63WLhdZo2DsPw0RJ95e1TJL1JdLP
         hUIrCVfSVApc2yXzIQpHTKLN5Hsgvez/HKTvHyk/ZRNgdIwQM5CTz3rjKh0xOz2XlM0L
         /UHw==
X-Gm-Message-State: AOAM530qRMYWgb5/CAeujCSdyhmEbNwYd+9iVm1rKPqYa5/r9R/1u4t2
        i6kDhXDAnRb8hz5FCGcUbNEC2LYWgBjqIPHpewU=
X-Google-Smtp-Source: ABdhPJz1zukrX9+gQT66awvSWVXQisUvimXxiFya96fMA3CufvUprzstkgmMqdYBAW4mkMAYDpDlEIfyGQBxyuZ/oLI=
X-Received: by 2002:a2e:b009:: with SMTP id y9mr1602547ljk.372.1602783698144;
 Thu, 15 Oct 2020 10:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtAOxF=PCndMTXxj_dZVLc-NQJfoawOvMeS3FbxiCU6xw@mail.gmail.com>
 <87eelzho1b.fsf@suse.com> <CAH2r5mvdOBeLJsPZRqj1O8UU24aUxhc-cWEWO+8RAW9fPzYSJg@mail.gmail.com>
In-Reply-To: <CAH2r5mvdOBeLJsPZRqj1O8UU24aUxhc-cWEWO+8RAW9fPzYSJg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 15 Oct 2020 12:41:27 -0500
Message-ID: <CAH2r5msGP-=qow2A3eJPiHg-CaNCM+6cvfbP9=_z3ZJSeU9UKw@mail.gmail.com>
Subject: Re: Add support for GCM256 encryption
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

found another typo in patch 5 ccm instead of gcm - fixing it now

On Thu, Oct 15, 2020 at 11:33 AM Steve French <smfrench@gmail.com> wrote:
>
> Good point.  Updated patches attached.  Also added a one line comment
> to smb2pdu.h mentioning why we don't request AES_256_CCM
>
>
> On Thu, Oct 15, 2020 at 3:49 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Hi Steve,
> >
> > Patch 2:
> >
> > > From 3897b440fd14dfc7b2ad2b0a922302ea7705b5d9 Mon Sep 17 00:00:00 200=
1
> > > From: Steve French <stfrench@microsoft.com>
> > > Date: Wed, 14 Oct 2020 20:24:09 -0500
> > > Subject: [PATCH 2/5] smb3.1.1: add new module load parm enable_gcm_25=
6
> > > --- a/fs/cifs/smb2pdu.h
> > > +++ b/fs/cifs/smb2pdu.h
> > > @@ -361,8 +361,9 @@ struct smb2_encryption_neg_context {
> > >       __le16  ContextType; /* 2 */
> > >       __le16  DataLength;
> > >       __le32  Reserved;
> > > -     __le16  CipherCount; /* AES-128-GCM and AES-128-CCM */
> > > -     __le16  Ciphers[2];
> > > +     /* CipherCount usally 2, but can be 3 when AES256-GCM enabled *=
/
> > > +     __le16  CipherCount; /* AES128-GCM and AES128-CCM by defalt */
> >
> > Typo defalt =3D> default
> >
> > > +     __le16  Ciphers[3];
> > >  } __packed;
> > >
> > >  /* See MS-SMB2 2.2.3.1.3 */
> > > --
> > > 2.25.1
> > >
> >
> > Patch 5:
> >
> > > From 314d7476e404c37acb77c3f9ecc142122e7afbfd Mon Sep 17 00:00:00 200=
1
> > > From: Steve French <stfrench@microsoft.com>
> > > Date: Fri, 11 Sep 2020 16:47:09 -0500
> > > Subject: [PATCH 5/5] smb3.1.1: set gcm256 when requested
> > >
> > > update code to set 32 byte key length and to set gcm256 when requeste=
d
> > > on mount.
> > >
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/cifs/smb2glob.h      |  1 +
> > >  fs/cifs/smb2ops.c       | 20 ++++++++++++--------
> > >  fs/cifs/smb2transport.c | 16 ++++++++--------
> > >  3 files changed, 21 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index dd1edabec328..d8e74954d101 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -3954,7 +3954,12 @@ crypt_message(struct TCP_Server_Info *server, =
int num_rqst,
> > >
> > >       tfm =3D enc ? server->secmech.ccmaesencrypt :
> > >                                               server->secmech.ccmaesd=
ecrypt;
> > > -     rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> > > +
> > > +     if (require_gcm_256)
> > > +             rc =3D crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKE=
Y_SIZE);
> >
> > Shouldn't the check be on server->cipher_type?
> >
> > > +     else
> > > +             rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE)=
;
> > > +
> > >       if (rc) {
> > >               cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n",=
 __func__, rc);
> > >               return rc;
> >
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
