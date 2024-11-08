Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1D41E5016
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 12:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731068253; cv=none; b=iiRGCBkLUtU1JHi0/LGWLTJ6KPzVTHkRwcvI2/QaNhUoHsl38ilpjpQcsWrWACvvnBYHUz7be63DRd4aPldyqEl8296pqO/+aP4NfdOc5p6sPSZy6ccFeTK0ulyHZ0sI9zWohIH8Xm2o92KVTddb7u4zK/GV/inmorJx9kjVcIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731068253; c=relaxed/simple;
	bh=dl8ObVPi5DnTXRQ2gPCNWhaCBFhFRt76KbPPt58cyhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DW/rzp0InjoqvA7xc1yge4zkYRTXGb7aM2auBBkxYd2jjU0WZwMF5X94hQgfQmh5IS6DfYzwLVUpy3kE0FjnqPBfVjo+ygn5+4NpKpzyCaMMS/y+a2koiTWr5BClsVxFAHWAQoOxXAo5Yu0Nwk5OSXwG97QHot/T9NGVG29uy+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kddScB6H; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kddScB6H"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c9693dc739so2937660a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 08 Nov 2024 04:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731068249; x=1731673049; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqGG7YG4rleM3pQRyMmhQPikbkYky0hYmjZ+FZ67EQA=;
        b=kddScB6HLBSU4Hfw83SR4jb1njhzbreDgKLrT8jRZKqz6xOFGQV9Vf8XToT9tqMZ/S
         YNJHLq2SJkkEZcYSI+iy76j33KsUrtiaezbBp1OUywejKeiR+EyUzXwWmfIkLVHctv2Z
         AmKrtb6xbJMEZG3XuTmjCwa5Q/2EDIP/QEGcJ+NkcA8nize4C5qBxqO7I5w3cqQMdFtS
         uRU8ptzG1tKbQY230um3/+uHbOqqgoeYXJ/Y2ifVMlFCXIefIycNqbbbowSaYOPzdlAY
         yJTyZkzwU+gxyRl4APNjIxVqFwE3B3O0jP7EBXo4pSKAK71CKr4/Pg60QkV/zzD5lqqM
         wGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731068249; x=1731673049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yqGG7YG4rleM3pQRyMmhQPikbkYky0hYmjZ+FZ67EQA=;
        b=Vfn93Tr3o2xYjWMoJSaiBcyFZBwylFqYrNoDsEfe5Td20SfplSNIxXqGuzrZThyXaP
         gJie4nBmIWDEXaiVyIAwHPzOsLuHajrOeie+QEYNzVBCJ0YUM0PX13P/3WQ2GT0IVyqq
         PSOrrE2t5rsQ5Q6KaK/TNxALYI/GNhoVS+OItBP71fzgjCHdr0+yUgAAJHdGpRXWWN2d
         yIFkJSNlAtQAPG7Xp44dF00LkBhcxeM+ciQrZvpgOXDNfnUFURQsSmLVY5DNZt7WBlmf
         Wy5wOlcr/LlyT0znvaJyfthuWBcmU+loULw1zN8e/YGzqCG/AIYW4hp41Dlyj1cBlJwl
         Gg/A==
X-Forwarded-Encrypted: i=1; AJvYcCUakxFRW9c+K/H4NVus6Z97Dr7aVMTa7Vk1opZrjXAwIq59pAL3RcVYSyh2ZTbfW4V5T2WTifWHmmSr@vger.kernel.org
X-Gm-Message-State: AOJu0YymyIvDuHTmauf2J+vTdvm/BdOrlxMOybs6RsW/55Id4Ulkmo+e
	kqcN3wKLN7EYJu75/w0VcRHu1J0zcqyZvBudbvPOF0/d+QrEt3WSxLk1FjUFM4GGB8EzzhZX5re
	Gulmk8VSQL3ZHwuDR+rXZ5rX8HfI=
X-Google-Smtp-Source: AGHT+IHQ1pS4VDL7JDy2aKhtAozr7nT1Qdtpaqug8UK7BWSjxtk7oyyNINt9pRc7RmTnNj59qOXzrgWudhE8ccDkkSQ=
X-Received: by 2002:a17:907:a4b:b0:a9a:dfa5:47d2 with SMTP id
 a640c23a62f3a-a9ef0019726mr204568366b.59.1731068247575; Fri, 08 Nov 2024
 04:17:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com> <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com>
In-Reply-To: <1f8a225b0d16fdfa05c417e0f6602489@manguebit.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 8 Nov 2024 17:47:15 +0530
Message-ID: <CANT5p=rm90eHDeA669yRNdKvT=GL+NE1PVTJVS-htQ8pbfiwUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
To: Paulo Alcantara <pc@manguebit.com>
Cc: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org, 
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paulo,

Thanks for the review.

On Fri, Nov 8, 2024 at 12:01=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> meetakshisetiyaoss@gmail.com writes:
>
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > We recently introduced a password2 field in both ses and ctx structs.
> > This was done so as to allow the client to rotate passwords for a mount
> > without any downtime. However, when the client transparently handles
> > password rotation, it can swap the values of the two password fields
> > in the ses struct, but not in smb3_fs_context struct that hangs off
> > cifs_sb. This can lead to a situation where a remount unintentionally
> > overwrites a working password in the ses struct.
>
> I don't see password rotation being handled for SMB1.  I mounted a share
> with 'vers=3D1.0,password=3Dfoo,password2=3Dbar' and didn't get any warni=
ngs
> or errors about it being usupported.  I think users would like to have
> that.

Good point. We could add support for SMB1 or document clearly that
this is only for SMB2+.

>
> What about SMB sessions from cifs_tcon::dfs_ses_list?  I don't see their
> password getting updated over remount.

This is in our to-do list as well.

>
> If you don't plan to support any of the above, then don't allow users to
> mount/remount when password rotation can't be handled.
>
> > In order to fix this, we first get the passwords in ctx struct
> > in-sync with ses struct, before replacing them with what the passwords
> > that could be passed as a part of remount.
> >
> > Also, in order to avoid race condition between smb2_reconnect and
> > smb3_reconfigure, we make sure to lock session_mutex before changing
> > password and password2 fields of the ses structure.
> >
> > Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing=
 on the server by allowing password rotation")
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> > ---
> >  fs/smb/client/fs_context.c | 69 +++++++++++++++++++++++++++++++++-----
> >  1 file changed, 60 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 5c5a52019efa..73610e66c8d9 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -896,6 +896,7 @@ static int smb3_reconfigure(struct fs_context *fc)
> >       struct dentry *root =3D fc->root;
> >       struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
> >       struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> > +     char *new_password =3D NULL, *new_password2 =3D NULL;
> >       bool need_recon =3D false;
> >       int rc;
> >
> > @@ -915,21 +916,71 @@ static int smb3_reconfigure(struct fs_context *fc=
)
> >       STEAL_STRING(cifs_sb, ctx, UNC);
> >       STEAL_STRING(cifs_sb, ctx, source);
> >       STEAL_STRING(cifs_sb, ctx, username);
> > +
> >       if (need_recon =3D=3D false)
> >               STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> >       else  {
> > -             kfree_sensitive(ses->password);
> > -             ses->password =3D kstrdup(ctx->password, GFP_KERNEL);
> > -             if (!ses->password)
> > -                     return -ENOMEM;
> > -             kfree_sensitive(ses->password2);
> > -             ses->password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> > -             if (!ses->password2) {
> > -                     kfree_sensitive(ses->password);
> > -                     ses->password =3D NULL;
> > +             if (ctx->password) {
> > +                     new_password =3D kstrdup(ctx->password, GFP_KERNE=
L);
> > +                     if (!new_password)
> > +                             return -ENOMEM;
> > +             } else
> > +                     STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> > +     }
> > +
> > +     /*
> > +      * if a new password2 has been specified, then reset it's value
> > +      * inside the ses struct
> > +      */
> > +     if (ctx->password2) {
> > +             new_password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> > +             if (!new_password2) {
> > +                     if (new_password)
>
> Useless non-NULL check as kfree_sensitive() already handles it.
>
> > +                             kfree_sensitive(new_password);
> >                       return -ENOMEM;
> >               }
> > +     } else
> > +             STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
> > +
> > +     /*
> > +      * we may update the passwords in the ses struct below. Make sure=
 we do
> > +      * not race with smb2_reconnect
> > +      */
> > +     mutex_lock(&ses->session_mutex);
> > +
> > +     /*
> > +      * smb2_reconnect may swap password and password2 in case session=
 setup
> > +      * failed. First get ctx passwords in sync with ses passwords. It=
 should
> > +      * be okay to do this even if this function were to return an err=
or at a
> > +      * later stage
> > +      */
> > +     if (ses->password &&
> > +         cifs_sb->ctx->password &&
> > +         strcmp(ses->password, cifs_sb->ctx->password)) {
> > +             kfree_sensitive(cifs_sb->ctx->password);
> > +             cifs_sb->ctx->password =3D kstrdup(ses->password, GFP_KER=
NEL);
>
> Missing allocation failure check.
>
> > +     }
> > +     if (ses->password2 &&
> > +         cifs_sb->ctx->password2 &&
> > +         strcmp(ses->password2, cifs_sb->ctx->password2)) {
> > +             kfree_sensitive(cifs_sb->ctx->password2);
> > +             cifs_sb->ctx->password2 =3D kstrdup(ses->password2, GFP_K=
ERNEL);
>
> Ditto.
>
> > +     }
> > +
> > +     /*
> > +      * now that allocations for passwords are done, commit them
> > +      */
> > +     if (new_password) {
> > +             kfree_sensitive(ses->password);
> > +             ses->password =3D new_password;
> > +     }
> > +     if (new_password2) {
> > +             kfree_sensitive(ses->password2);
> > +             ses->password2 =3D new_password2;
> >       }
> > +
> > +     mutex_unlock(&ses->session_mutex);
> > +
> >       STEAL_STRING(cifs_sb, ctx, domainname);
> >       STEAL_STRING(cifs_sb, ctx, nodename);
> >       STEAL_STRING(cifs_sb, ctx, iocharset);
> > --
> > 2.46.0.46.g406f326d27



--=20
Regards,
Shyam
