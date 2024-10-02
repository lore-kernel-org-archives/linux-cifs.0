Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3A8DDD2;
	Wed,  2 Oct 2024 02:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727837722; cv=none; b=TekQONz/RCfjIhACMvAqI8xXbnMOyEKpNml8ak8p+0Zi7UUJ0OHXephBhsXpLGLZyfvMKseFPTBYUANAhzP4TDRopP/62+aCqrS+MEodqR/b9VhVencPTvKeehE+p7Mn9Fl7jluNLBsRT5xyV3kvs8+PVL7TPTAlov4aWjtzcio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727837722; c=relaxed/simple;
	bh=aIl433q0UXMgmf6MDUtGyzUH+yKFVkBrqL3c5twYh4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGIN7VntqB86Pq7endP6QFq4XYrFOF0wXPFGnEFkJBGmm1JEvBrDexlPFcp4KbMODBVK+TH6naeOOiDAQIqiYlxmUc7crQk2XIrmu4elPchCnuxI0cMSpzj1zD/YvBiHuSEBjgTgarp9/RM81TuHXaVNPVufyg7o5ey1cd5iYQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZcIO3lwL; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZcIO3lwL"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5398e58ceebso383506e87.0;
        Tue, 01 Oct 2024 19:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727837719; x=1728442519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBtfLT5n5Bak6dzvoaIlQiioBlabZ6tHJXqAKEWWupA=;
        b=ZcIO3lwLXZaqLA1Ly7ib33dCv+49QDEwxYXlbUTpWNTLXVnF1n7hmoorJK8KrInuni
         LHLTsMhUqklr6grwdWV4iybAPaeA1TLkJpr0HLuL2jToW0Llk9xyJBdqa2rQU9fCvyvB
         1QMEbYx8gIXQtvL26GUDubvcAF6sR2iFbG874srDK0Lf9evAJf8Zr3QcIvJitXeqZeCK
         HoiN2V0tITWD3CkN4kEYw5+DNRynZ79C1hoRUDHpYJehlwGEgzNOm9kprPo54UiCo1iD
         RpVqv2g+sAEH9box2u+skSEbYaHveU1HvRs7VfJ1zgR8WDT9I4XYBxLaelk6zzZ1bYLY
         qSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727837719; x=1728442519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HBtfLT5n5Bak6dzvoaIlQiioBlabZ6tHJXqAKEWWupA=;
        b=MlmJP+9ky1gT1oIOlswJpUnaOyNuTXC6SfxyZusaRZaQwplj9msosoBc0LZZz1cVFy
         EBmwmVUAo5EjpE3IkpFyQZnVEaJK84mjK7BBRMHWWBclge1bcjwOHj5jWMbE2oFgITPq
         epOcJJG+gttCR1847+elccTsT6JbOnmNP4/B3ssJ6z+8wMHHHxIuXtM3g6Bl/hmphGmV
         rZvu7G7FQEFjMgwm5YeyuS95NauRHBjBGPTF8yxV6lWmSbg2r7vbysgPx4wjXTvGfO/c
         8jLGQQhM0oVEd9TtnWUiwenADe5qMagsGIMKsTHaDG4Nhl2xPyMzk9SeZ2iS/fdu5ouh
         F9jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHXT+VRO9zpi8Y9DEFwrzc7vf3Jg0vS/W8kbmiF37b+ejSH5H+b5QQeEENc5iufgNEe45m7ksW9ym0j5i2@vger.kernel.org, AJvYcCXJDVyELygWWpBYvmKh16uhyNLLV7ra8o14kwSNO6nWDtbiaQzTqB25aVsHV4fvxiCmTP+pZJ/2B5pX@vger.kernel.org
X-Gm-Message-State: AOJu0YwLk4fd8ZEDzTvFFNdQ9o7sVZamAk9RW2IpCC9z8TatYiMC0ujT
	uTPbXbTz4j4XjHhp/pxbH3jVJIZll52Dn2dS+A/FvMKLkTi2s/9ZLuw5FZT2hCHX70BSAkyZc4T
	VS4zrx0tuUvZ82eTyH/+/EJZ3sqA=
X-Google-Smtp-Source: AGHT+IHssEqv0unBInb7m7EItT105TTfXc09hELEcUF1hMnepLQhaifGSa/TVocR+krv64hJQLxxX3BUS26zCCjKc0g=
X-Received: by 2002:a05:6512:230e:b0:539:933c:51c6 with SMTP id
 2adb3069b0e04-539a0176bf7mr423546e87.29.1727837718605; Tue, 01 Oct 2024
 19:55:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620083729.28623-1-wangrong@uniontech.com> <CAH2r5msOQ=OWAgRoYG5kO7fndMWt=_7ZBET-M3mkXMfgnLCM1A@mail.gmail.com>
In-Reply-To: <CAH2r5msOQ=OWAgRoYG5kO7fndMWt=_7ZBET-M3mkXMfgnLCM1A@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 1 Oct 2024 21:55:07 -0500
Message-ID: <CAH2r5mv0fZTiczADy2Ym65unER3kQoXTSaA_Q_9Jd72YQhusbw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use actual path when queryfs
To: wangrong <wangrong@uniontech.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next tentatively but want to do some more
testing on this (and any additional review comments would be welcome)

On Tue, Oct 1, 2024 at 9:33=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> Paulo just found this potentially important fix in email (it had gotten m=
issed).
>
> The one suspicious thing about this though ... we should have some
> code paths where we would use the cached root handle for statfs
> (which is preferable to doing an open of a new handle, since it is
> already open we don't risk an error coming back on open).
>
> Any ideas whether we also need additional changes to use the cached
> root handle better in statfs (since in most cases to
> Windows we would expect to have that)?
>
>
> On Thu, Jun 20, 2024 at 3:54=E2=80=AFAM wangrong <wangrong@uniontech.com>=
 wrote:
> >
> > Due to server permission control, the client does not have access to
> > the shared root directory, but can access subdirectories normally, so
> > users usually mount the shared subdirectories directly. In this case,
> > queryfs should use the actual path instead of the root directory to
> > avoid the call returning an error (EACCES).
> >
> > Signed-off-by: wangrong <wangrong@uniontech.com>
> > ---
> >  fs/smb/client/cifsfs.c   | 13 ++++++++++++-
> >  fs/smb/client/cifsglob.h |  2 +-
> >  fs/smb/client/smb1ops.c  |  2 +-
> >  fs/smb/client/smb2ops.c  | 19 ++++++++++++-------
> >  4 files changed, 26 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index bb86fc064..a4d59f0f5 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -313,8 +313,17 @@ cifs_statfs(struct dentry *dentry, struct kstatfs =
*buf)
> >         struct TCP_Server_Info *server =3D tcon->ses->server;
> >         unsigned int xid;
> >         int rc =3D 0;
> > +       const char *full_path;
> > +       void *page;
> >
> >         xid =3D get_xid();
> > +       page =3D alloc_dentry_path();
> > +
> > +       full_path =3D build_path_from_dentry(dentry, page);
> > +       if (IS_ERR(full_path)) {
> > +               rc =3D PTR_ERR(full_path);
> > +               goto statfs_out;
> > +       }
> >
> >         if (le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength) > =
0)
> >                 buf->f_namelen =3D
> > @@ -330,8 +339,10 @@ cifs_statfs(struct dentry *dentry, struct kstatfs =
*buf)
> >         buf->f_ffree =3D 0;       /* unlimited */
> >
> >         if (server->ops->queryfs)
> > -               rc =3D server->ops->queryfs(xid, tcon, cifs_sb, buf);
> > +               rc =3D server->ops->queryfs(xid, tcon, full_path, cifs_=
sb, buf);
> >
> > +statfs_out:
> > +       free_dentry_path(page);
> >         free_xid(xid);
> >         return rc;
> >  }
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 73482734a..d3118d748 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -483,7 +483,7 @@ struct smb_version_operations {
> >                         __u16 net_fid, struct cifsInodeInfo *cifs_inode=
);
> >         /* query remote filesystem */
> >         int (*queryfs)(const unsigned int, struct cifs_tcon *,
> > -                      struct cifs_sb_info *, struct kstatfs *);
> > +                      const char *, struct cifs_sb_info *, struct ksta=
tfs *);
> >         /* send mandatory brlock to the server */
> >         int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u=
64,
> >                          __u64, __u32, int, int, bool);
> > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > index 212ec6f66..e3a195824 100644
> > --- a/fs/smb/client/smb1ops.c
> > +++ b/fs/smb/client/smb1ops.c
> > @@ -909,7 +909,7 @@ cifs_oplock_response(struct cifs_tcon *tcon, __u64 =
persistent_fid,
> >
> >  static int
> >  cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> > -            struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
> > +            const char *path, struct cifs_sb_info *cifs_sb, struct kst=
atfs *buf)
> >  {
> >         int rc =3D -EOPNOTSUPP;
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index c8e536540..bb7194386 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -2784,7 +2784,7 @@ smb2_query_info_compound(const unsigned int xid, =
struct cifs_tcon *tcon,
> >
> >  static int
> >  smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> > -            struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
> > +            const char *path, struct cifs_sb_info *cifs_sb, struct kst=
atfs *buf)
> >  {
> >         struct smb2_query_info_rsp *rsp;
> >         struct smb2_fs_full_size_info *info =3D NULL;
> > @@ -2793,7 +2793,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_=
tcon *tcon,
> >         int rc;
> >
> >
> > -       rc =3D smb2_query_info_compound(xid, tcon, "",
> > +       rc =3D smb2_query_info_compound(xid, tcon, path,
> >                                       FILE_READ_ATTRIBUTES,
> >                                       FS_FULL_SIZE_INFORMATION,
> >                                       SMB2_O_INFO_FILESYSTEM,
> > @@ -2821,28 +2821,33 @@ smb2_queryfs(const unsigned int xid, struct cif=
s_tcon *tcon,
> >
> >  static int
> >  smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> > -              struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
> > +              const char *path, struct cifs_sb_info *cifs_sb, struct k=
statfs *buf)
> >  {
> >         int rc;
> > -       __le16 srch_path =3D 0; /* Null - open root of share */
> > +       __le16 *utf16_path =3D NULL;
> >         u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >         struct cifs_open_parms oparms;
> >         struct cifs_fid fid;
> >
> >         if (!tcon->posix_extensions)
> > -               return smb2_queryfs(xid, tcon, cifs_sb, buf);
> > +               return smb2_queryfs(xid, tcon, path, cifs_sb, buf);
> >
> >         oparms =3D (struct cifs_open_parms) {
> >                 .tcon =3D tcon,
> > -               .path =3D "",
> > +               .path =3D path,
> >                 .desired_access =3D FILE_READ_ATTRIBUTES,
> >                 .disposition =3D FILE_OPEN,
> >                 .create_options =3D cifs_create_options(cifs_sb, 0),
> >                 .fid =3D &fid,
> >         };
> >
> > -       rc =3D SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
> > +       utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> > +       if (utf16_path =3D=3D NULL)
> > +               return -ENOMEM;
> > +
> > +       rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
> >                        NULL, NULL);
> > +       kfree(utf16_path);
> >         if (rc)
> >                 return rc;
> >
> > --
> > 2.20.1
> >
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
