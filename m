Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54BD4C433DB
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 11:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B8C164DE8
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 11:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhBCLZT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Feb 2021 06:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbhBCLX3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Feb 2021 06:23:29 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0452EC0613ED
        for <linux-cifs@vger.kernel.org>; Wed,  3 Feb 2021 03:22:49 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id w204so20786319ybg.2
        for <linux-cifs@vger.kernel.org>; Wed, 03 Feb 2021 03:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tu/+mTirw/K7owTpOJg7K1Mo5BLblRxTxQu8JK3/gac=;
        b=QM9WFeEzEbMAP4HX5AqPMsNIyZyYjdnRHKPXqjYIN5Gd6eamJWmG6yT60m5RK2zIV7
         CbYNXhbH9z/v8496FbOARTHv/nlX549WfJW3aqbaOwW5yPJQfSn4sFbFj2Vmwuxj1A7o
         +MQgpYPWEorux5bg8fu2Ef7AuXVLSX3XXpJJOqca9d4S/XpbbKrN3qwQDM38M7pHBpIF
         kuJwTH7VkiQz1DH8rlBaOMqUPqcVKBoJekDe3ujjuaEinka7z1hA6ZmgInUCgU/WfIhz
         cqaTUPurTepjooyHC/QbcD3MTh8RJCufXw6PVpWIAmo03rRmoO/AoMbwsKbsO977Kg07
         14wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tu/+mTirw/K7owTpOJg7K1Mo5BLblRxTxQu8JK3/gac=;
        b=PTv3OKsSInLTy/0a0R87yRJGXZTEDWzQIlNoBYTgLsUgGq/JdM1HpZ+Ph5TqTFJfLS
         dJwfc7XFlDO9i2W5LoXvFJ8XtKOAYcUN0ooi8U0JhpyrpYKIgZNSKPxh1Xk7BYJYGpL9
         FYgni6UJGkcISLd54KxCYIXM7lYLgjRkgCRIapHX3QpmwGVJ8uok/uoEC74VWYGjFwFO
         81RsUIDc5g0LlK7TvAMdt4pJllBjyHUg2hitcIcBWw3jHkIOoH0YbowYCEeCT/SRDxwX
         i0ClZ/iumkz9Yl8pK8/QGKxds5XsFWj0MEwyap6SCe9FsW4bp6D7Nd9SU6bj7ysunhRp
         JGGA==
X-Gm-Message-State: AOAM532B8GHs3TGX9KEAt69b5l2UScMes1xq+bvtJgApbI7SIT64Rj9d
        S1RxDTyWp7SkycS0DQYVZ053Ty/akfnnEjOCuL8=
X-Google-Smtp-Source: ABdhPJzksX8ExPMQjFfGcQgIs7J+2TtyxKUpIKuKJWG0o5ZSnYZ13keUCepotp6AJW4CaA2JQYMU5XFANJoJCvO4kAk=
X-Received: by 2002:a25:ce92:: with SMTP id x140mr3757458ybe.327.1612351368107;
 Wed, 03 Feb 2021 03:22:48 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt7Z2wJTLFp1T0qtsrJb95FPKoffBN9WBM=JAi=HcyiOg@mail.gmail.com>
 <CAKywueTvFL7GA3he21XjX8fig73iT5OCAd=JjBq6OOwOavcehA@mail.gmail.com> <CAH2r5mv82FGWtU4PuojFuhYfYS61VX8trtihj8Zk1N5aG3Driw@mail.gmail.com>
In-Reply-To: <CAH2r5mv82FGWtU4PuojFuhYfYS61VX8trtihj8Zk1N5aG3Driw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 3 Feb 2021 03:22:37 -0800
Message-ID: <CANT5p=ryavNegdVqJRua6BMHsXcD7brdaPdQJ24BTX44rZ0cxQ@mail.gmail.com>
Subject: Re: PATCH] smb3: include current dialect (SMB3.1.1) when version 3 or
 greater requested on mount
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed the patch in for-next.
Looks good to me.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

Regards,
Shyam

On Tue, Feb 2, 2021 at 8:23 PM Steve French <smfrench@gmail.com> wrote:
>
> updated as suggested (see attached) and merged into cifs-2.6.git for-next
>
> On Tue, Feb 2, 2021 at 11:58 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=BF=D0=BD, 1 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 22:15, St=
eve French <smfrench@gmail.com>:
> > >
> > > SMB3.1.1 is the newest, and preferred dialect, and is included in
> > > the requested dialect list by default (ie if no vers=3D is specified
> > > on mount) but it should also be requested if SMB3 or later is request=
ed
> > > (vers=3D3 instead of a specific dialect: vers=3D2.1, vers=3D3.02 or v=
ers=3D3.0).
> > >
> > > Currently specifying "vers=3D3" only requests smb3.0 and smb3.02 but =
this
> > > patch fixes it to also request smb3.1.1 dialect, as it is the newest
> > > and most secure dialect and is a "version 3 or later" dialect (the in=
tent
> > > of "vers=3D3").
> > >
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > ---
> > >  fs/cifs/fs_context.c |  2 +-
> > >  fs/cifs/smb2pdu.c    | 19 +++++++++++++------
> > >  2 files changed, 14 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > > index 5111aadfdb6b..479c24695281 100644
> > > --- a/fs/cifs/fs_context.c
> > > +++ b/fs/cifs/fs_context.c
> > > @@ -391,7 +391,7 @@ cifs_parse_smb_version(char *value, struct
> > > smb3_fs_context *ctx, bool is_smb3)
> > >   ctx->vals =3D &smb3any_values;
> > >   break;
> > >   case Smb_default:
> > > - ctx->ops =3D &smb30_operations; /* currently identical with 3.0 */
> > > + ctx->ops =3D &smb30_operations;
> > >   ctx->vals =3D &smbdefault_values;
> > >   break;
> > >   default:
> > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > index 794fc3b68b4f..52625549c3b5 100644
> > > --- a/fs/cifs/smb2pdu.c
> > > +++ b/fs/cifs/smb2pdu.c
> > > @@ -814,8 +814,9 @@ SMB2_negotiate(const unsigned int xid, struct cif=
s_ses *ses)
> > >      SMB3ANY_VERSION_STRING) =3D=3D 0) {
> > >   req->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
> > >   req->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> > > - req->DialectCount =3D cpu_to_le16(2);
> > > - total_len +=3D 4;
> > > + req->Dialects[2] =3D cpu_to_le16(SMB311_PROT_ID);
> > > + req->DialectCount =3D cpu_to_le16(3);
> > > + total_len +=3D 6;
> > >   } else if (strcmp(server->vals->version_string,
> > >      SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > >   req->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> > > @@ -848,6 +849,8 @@ SMB2_negotiate(const unsigned int xid, struct cif=
s_ses *ses)
> > >   memcpy(req->ClientGUID, server->client_guid,
> > >   SMB2_CLIENT_GUID_SIZE);
> > >   if ((server->vals->protocol_id =3D=3D SMB311_PROT_ID) ||
> > > +     (strcmp(server->vals->version_string,
> > > +      SMB3ANY_VERSION_STRING) =3D=3D 0) ||
> > >       (strcmp(server->vals->version_string,
> > >        SMBDEFAULT_VERSION_STRING) =3D=3D 0))
> > >   assemble_neg_contexts(req, server, &total_len);
> > > @@ -883,6 +886,9 @@ SMB2_negotiate(const unsigned int xid, struct cif=
s_ses *ses)
> > >   cifs_server_dbg(VFS,
> > >   "SMB2.1 dialect returned but not requested\n");
> > >   return -EIO;
> > > + } else if (rsp->DialectRevision =3D=3D cpu_to_le16(SMB311_PROT_ID))=
 {
> >
> > I think we should include comment "/* ops set to 3.0 by default for
> > default so update */" as in smbdefault case to improve readability.
> >
> > > + server->ops =3D &smb311_operations;
> > > + server->vals =3D &smb311_values;
> > >   }
> > >   } else if (strcmp(server->vals->version_string,
> > >      SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > > @@ -1042,10 +1048,11 @@ int smb3_validate_negotiate(const unsigned in=
t
> > > xid, struct cifs_tcon *tcon)
> > >   SMB3ANY_VERSION_STRING) =3D=3D 0) {
> > >   pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
> > >   pneg_inbuf->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> > > - pneg_inbuf->DialectCount =3D cpu_to_le16(2);
> > > - /* structure is big enough for 3 dialects, sending only 2 */
> > > + pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB311_PROT_ID);
> > > + pneg_inbuf->DialectCount =3D cpu_to_le16(3);
> > > + /* SMB 2.1 not included so subtract one dialect from len */
> > >   inbuflen =3D sizeof(*pneg_inbuf) -
> > > - (2 * sizeof(pneg_inbuf->Dialects[0]));
> > > + (sizeof(pneg_inbuf->Dialects[0]));
> > >   } else if (strcmp(server->vals->version_string,
> > >   SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > >   pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> > > @@ -1053,7 +1060,7 @@ int smb3_validate_negotiate(const unsigned int
> > > xid, struct cifs_tcon *tcon)
> > >   pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB302_PROT_ID);
> > >   pneg_inbuf->Dialects[3] =3D cpu_to_le16(SMB311_PROT_ID);
> > >   pneg_inbuf->DialectCount =3D cpu_to_le16(4);
> > > - /* structure is big enough for 3 dialects */
> > > + /* structure is big enough for 4 dialects */
> > >   inbuflen =3D sizeof(*pneg_inbuf);
> > >   } else {
> > >   /* otherwise specific dialect was requested */
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > Looks good overall.
> >
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > --
> > Best regards,
> > Pavel Shilovsky
>
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
