Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F27C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 01:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71A082070B
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 01:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vvu5lImE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfC1BWf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 21:22:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38076 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfC1BWf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Mar 2019 21:22:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id g1so11174450qki.5
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2019 18:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NP11AuW+IaKYekBQhY+MLxY9b/rmRlsu2eQB1HtQBt8=;
        b=Vvu5lImEJJv9x6/9c+rmQDIkwvec3bFypvewuRyjcUx4qNrTYun4XkVI3+E4n1v+aO
         ALMwr+QEO3KvE0o8UYpqUGriW4FbWSBmDZwkjwgagjnGXt/23qxr3Kam34mzWW2DXsmq
         SIuBaVddvqD0KtQe1QEITfZBP9NJY+w/JrXPbsJl19s427vas4Jz9Xv8NzXhoTRkeYCg
         hGRyckhnlQzAaDfv18lYI9b/su6cAYKg9wSkgR32EEq+oFta+cg5JegZFaC1hY5WGLdc
         geFvF82gWDBfM6gcF0s5qvflsD2c7QIjxWgSzReZaq+HwxQnlxcj9ILVF4NrlfCozUhO
         viCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NP11AuW+IaKYekBQhY+MLxY9b/rmRlsu2eQB1HtQBt8=;
        b=kNrF1fFbQn7ovevYu0mhxmNpQa+zv/rfNukQGpNCVyDXqwsE/r+9/qzUHoo5NZ/Saa
         1nt1EWCmRt2/5x00X1Hgm7hE6NIAALoQKKlI16eU5V9gWCrp5H6Jbq2wNn47ejpK2gmF
         VzwUR8qsIskmOivkMPoZ+GvuLUpzUyCrSLVkMfx+dy/WVVMWZWWaLPKEdFlq+Lg9erAd
         TQr+iySf10Ba3TyzCqLTBmC7gy9tqo52aY1y/wZW3A3O+Kfg/oIVucLem0hn0eYrBNRV
         T3axb5WV6PP3cnJ74xa+rNnPfgtMU99EE995uThNEMMFNgTNQiDAopL97HwvqUZ6qeB6
         eYuw==
X-Gm-Message-State: APjAAAWwVmCf2oKAkFq8DIUsKuHBNx35j1kr5YNnV2hyszvYGeNA0C4Q
        TplH7m3r1CTMPeTJ6b0M1E61k+9Lztm06wp1x1o=
X-Google-Smtp-Source: APXvYqz3hNjhjXnUo1PgCQRJaghi9FExSduyOH+E+uZAtIFUtIl1qGc6vzvhzuFOSmlJ6eGxN4Ro2AQGphZEDaAgkr0=
X-Received: by 2002:a37:5156:: with SMTP id f83mr31203228qkb.126.1553736154119;
 Wed, 27 Mar 2019 18:22:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190327235742.6236-1-lsahlber@redhat.com> <CAKywueSYWYzG9tz0Batwu5OSCM+9wvHd0ggRzpQXQqncyZK+Bg@mail.gmail.com>
In-Reply-To: <CAKywueSYWYzG9tz0Batwu5OSCM+9wvHd0ggRzpQXQqncyZK+Bg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 28 Mar 2019 11:22:22 +1000
Message-ID: <CAN05THTP+Z3nNVA17pUC+aiZ-zueuaRotX13m4v0xRgg-LNJgA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix kref underflow in close_shroot()
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 28, 2019 at 10:17 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> =D1=81=D1=80, 27 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 16:58, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Fix a bug where we used to not initialize the cached fid structure at a=
ll
> > in open_shroot() if the open was successful but we did not get a lease.
> > This would leave the structure uninitialized and later when we close th=
e handle
> > we would in close_shroot() try to kref_put() an uninitialized refcount.
> >
> > Fix this by always initializing this structure when we are about to ret=
urn
> > 0/success but make the extra kref_get() on the refcount conditional to
> > whether we got a lease or not.
> > This extra get() is only used to hold the structure until we get a leas=
e
> > break from the server at which point we will kref_put() it during lease
> > processing.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c | 22 ++++++++++++++--------
> >  1 file changed, 14 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 1022a3771e14..4f0fb53cd0de 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -724,14 +724,6 @@ int open_shroot(unsigned int xid, struct cifs_tcon=
 *tcon, struct cifs_fid *pfid)
> >         else
> >                 goto oshr_exit;
> >
> > -
> > -       memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
> > -       tcon->crfid.tcon =3D tcon;
> > -       tcon->crfid.is_valid =3D true;
> > -       kref_init(&tcon->crfid.refcount);
> > -       kref_get(&tcon->crfid.refcount);
> > -
> > -
> >         qi_rsp =3D (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
> >         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb=
2_file_all_info))
> >                 goto oshr_exit;
> > @@ -745,6 +737,20 @@ int open_shroot(unsigned int xid, struct cifs_tcon=
 *tcon, struct cifs_fid *pfid)
> >         tcon->crfid.file_all_info_is_valid =3D 1;
> >
> >   oshr_exit:
> > +       /*
> > +        * If we return 0/success then we must also initialize this str=
uct.
> > +        * If we got a lease we need to take out an extra get() to keep
> > +        * the structure around until we receive the actual lease break=
.
> > +        */
> > +       if (rc =3D=3D 0) {
>             ^^^
> This will still leak a handle if smb2_validate_and_copy_iov failed above.

Right. I will resend.
>
> --
> Best regards,
> Pavel Shilovsky
