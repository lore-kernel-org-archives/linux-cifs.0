Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC51DF265
	for <linux-cifs@vger.kernel.org>; Mon,  6 Oct 2025 17:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759770452; cv=none; b=QQEni53LZhwKLo5F51mdYoVJRey0opNzgh3hTHwPBOeehg2jXwY/yD+DyYAmlkNSMnHOISXFb30DoUEg8Ja+Elpz8vNw9Ei5NK/OZtmg0iO0GVdxsvlQldazYRDWShOs9X+o8swoKD5KaIg8yA4/0DcHg7j8bXPgltD5OAiDHvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759770452; c=relaxed/simple;
	bh=rlFixZbJvnpPw6lVlYW5Kt3QbvdLM3zAzGBrPPHtZ1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DnqivnPY5l56nWn8+UIIwR4znj0775iHctKWJLOtC6PTss67rVJOAzrVzKTsC8i3gaUHFjqL848Wo+qNfGlhKdchlAh4YW4OR/OySrXionMg6xl9AZSKYgODOD7ZIH0OB1davY4L4yfL7sldjNTMuNFPNnmDDdeN+76fjttVOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LM2ba2ZQ; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LM2ba2ZQ"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87745ca6cc5so51829176d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Oct 2025 10:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759770450; x=1760375250; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKKNkmcBQxnFeZkKNYdKplHNGJ08onMcowwhJIAvhnQ=;
        b=LM2ba2ZQs/uZ2xGopms6MOc8QJQ6lP48Wc7WS393kjHNQR5SPLGB27f/xBrdAzi4GU
         Mp7TMTcLynLGdanXOorYaBQS/lvuP44tuTkd8JFZizHJ1hfMIuswz8eqCO1blWh/fNe+
         1VI/Aq35OhvEK/9knf5qPUQ9DXwdG4aYxbh9chGJ42NH5WGyZ6Pa4+NFmm5VHGhZzR72
         tueeYbJN4vHOhMXN9s+ddvw0kTL8HOkNq7Ojk6tuL4GXPgTVXvopBgH5nOq8WzU4getL
         skrgIm6Zykhianx3zDQi55vfEomsVX7Qrxgcmn++7UWLwSo2/tIYw/LuGSH1LTc921qx
         tR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759770450; x=1760375250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKKNkmcBQxnFeZkKNYdKplHNGJ08onMcowwhJIAvhnQ=;
        b=muIMKz/tGmZGQ5KNXVxBGPc1g4aEhZf7MPQq9i23J6XxePMWSAY1IxPsX7H3AZuXYo
         8n1QynsFHxXmBRxc5O3bHpR07GtVMX5kNipcpQpfVRf/g3QGhDP4GbczvmeyUfstAiVc
         3WpTXxtVQJI3aoToY6x0GKTIxIzgH8jNimYya4R+CN1tqmygYblK8sV4Ay1JFXZ7EkUn
         R96Pufwzf3v1pUTwUU6L+zkUm42MSnsyyIoj2Ldqjm5lJW7C9t5ydz3NIMBQoHS2tASH
         7DcYqfC27BzBg/g9DcdZ+dIFRUsnBaPWpC2WgeU1mb+LF6WyixmhBo/F/zZcNC9rfgj1
         6mIg==
X-Forwarded-Encrypted: i=1; AJvYcCVMbo4vx5BtkxyzzpIpUdHquUoU4nm/1oeudX0I/6VPEB2lB37l+8tRX/HCj4URTxabF2CXQxwTCuIZ@vger.kernel.org
X-Gm-Message-State: AOJu0YxmTky60pC/ebuTs6wC8J/KDlb/rRLhvAen7uovXhSrQQoumaPy
	eg0SPwoze+OO9UZMTz5BVzUbHuttlcq1IsnQATa/4DJOTDElzs63l3XRjtYAVkrxEfg/uZgjKYs
	6OVlsdfbL5TZxgdjN+CAswpAevastWk8=
X-Gm-Gg: ASbGncub9beKvA2DDlKj3JdlxdKbgW7QWg2txCX4KF3KtA1P/+1lNoWxM+MVqU3HcQg
	qXlDXCnzcv6ITQsTnQUqWhaTK+dzF8Y0UqiasRadwMN+OhoyKcrkVbng853fbO9PV4EeKEmZQkq
	6xzMDx4mLloIxPD5nChq/P003DvSbwZ5QWrJ2lPKw4x62Umw7W32g1CAOd+ovCI9EAR5wE+uJc4
	9HnAsHh/Ew1U7XC61lSaSWlxRgP2CrtcUTw9X2GxeffUTxHtpFaelZdci2DOFprhSXUCJgkNYyj
	9XwxQAlAoMBrYOXrcFX94CLNYoHwrv+eLVi2Rh4rLVcw7huIWDu1VB2TXdfvadAYCaL26u9MH0T
	g0ytdckf+uLluI1KDGuSa3p1ae86IMIzD96DMZcstonqRoA==
X-Google-Smtp-Source: AGHT+IEPISwSCtFAAyFwofIFOPnmbMbF4JyOJ066gMSsxLm13Rxv+HKDa92QBeQD2yMdtcQya1taGWfxC/jbAWm/jgE=
X-Received: by 2002:a05:6214:d02:b0:875:2636:4bd5 with SMTP id
 6a1803df08f44-87a052412damr4657666d6.20.1759770450151; Mon, 06 Oct 2025
 10:07:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <468cf96a-5dd9-4aa5-a8ce-930cf16952b3@web.de> <8e79516d-ad82-46bd-af00-3a8594a0baee@suse.com>
In-Reply-To: <8e79516d-ad82-46bd-af00-3a8594a0baee@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Oct 2025 12:07:18 -0500
X-Gm-Features: AS18NWCiMwnwOYL0R_azJWeM_ATvaFnKnhpK_Wr3r0REf2iO_ANzlxxIqrNli6g
Message-ID: <CAH2r5mvNM+z6re5toyNOJXewE0=9u2f+xxPXO5xTsMCj5nUWTw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Reduce the scopes for a few variables in two functions
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org, 
	Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Oct 6, 2025 at 9:11=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> On 10/5/25 2:10 PM, Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Sun, 5 Oct 2025 19:01:48 +0200
> >
> > * cifs_lookup():
> >   Move the definition for the local variable =E2=80=9Ccfid=E2=80=9D int=
o an else branch
> >   so that the corresponding setting will only be performed if a NULL in=
ode
> >   was detected during lookup by this function.
> >
> > * cifs_d_revalidate():
> >   Move the definition for the local variables =E2=80=9Cinode=E2=80=9D a=
nd =E2=80=9Crc=E2=80=9D into
> >   an if branch so that the corresponding setting will only be performed
> >   after a d_really_is_positive() call.
> >
> >   Move the definition for the local variable =E2=80=9Ccfid=E2=80=9D int=
o an else branch
> >   so that the corresponding setting will only be performed if further d=
ata
> >   processing will be needed for an open_cached_dir_by_dentry() call.
> >
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  fs/smb/client/dir.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> > index fc67a6441c96..7472fddadd4f 100644
> > --- a/fs/smb/client/dir.c
> > +++ b/fs/smb/client/dir.c
> > @@ -678,7 +678,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct =
dentry *direntry,
> >       const char *full_path;
> >       void *page;
> >       int retry_count =3D 0;
> > -     struct cached_fid *cfid =3D NULL;
> >
> >       xid =3D get_xid();
> >
> > @@ -717,6 +716,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct =
dentry *direntry,
> >       if (d_really_is_positive(direntry)) {
> >               cifs_dbg(FYI, "non-NULL inode in lookup\n");
> >       } else {
> > +             struct cached_fid *cfid =3D NULL;
> > +
> >               cifs_dbg(FYI, "NULL inode in lookup\n");
> >
> >               /*
> > @@ -785,15 +786,13 @@ static int
> >  cifs_d_revalidate(struct inode *dir, const struct qstr *name,
> >                 struct dentry *direntry, unsigned int flags)
> >  {
> > -     struct inode *inode =3D NULL;
> > -     struct cached_fid *cfid;
> > -     int rc;
> > -
> >       if (flags & LOOKUP_RCU)
> >               return -ECHILD;
> >
> >       if (d_really_is_positive(direntry)) {
> > -             inode =3D d_inode(direntry);
> > +             int rc;
> > +             struct inode *inode =3D d_inode(direntry);
> > +
> >               if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(ino=
de)))
> >                       CIFS_I(inode)->time =3D 0; /* force reval */
> >
> > @@ -836,6 +835,7 @@ cifs_d_revalidate(struct inode *dir, const struct q=
str *name,
> >       } else {
> >               struct cifs_sb_info *cifs_sb =3D CIFS_SB(dir->i_sb);
> >               struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> > +             struct cached_fid *cfid;
> >
> >               if (!open_cached_dir_by_dentry(tcon, direntry->d_parent, =
&cfid)) {
> >                       /*
>
> --
> Henrique
> SUSE Labs
>


--=20
Thanks,

Steve
