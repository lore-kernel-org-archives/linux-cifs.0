Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C41423BB;
	Wed,  2 Oct 2024 02:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727836420; cv=none; b=BMOSGg02MfJro3wt5JM9JpLwbra4t0EOsBSHX8r9lEbB5Vg7vlIO+75T2VohANYoy5WzKWo5xQjNbFPMH6hIqrbF9LutWlKZThEV3uarvzNT9DAO7qGIIXIS0952rjbtFVGCspZ0ycQxknp6wv5fUZiMqBouvTCDuaW+DbiLMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727836420; c=relaxed/simple;
	bh=mdQWcf58lJeZiSFlScBfXC5xQP5OtqgZStfwGvhIYXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RbWw8RCOeZGlZjhCJJFP++iY22BeVLP0Pl7G5Gbh+Ho5cT/A55UggoIe2ed46Pnp+vfh4cttta4Q9YRiNHsYUOb8txEoal7dxET5MhkFJQ+7uTNxJ598S6uj6riqCAkC0wseYH32AebgfUJjZNTseP2eYpzkMreKrUHQR0wtIDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gKfuto/t; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gKfuto/t"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53991d05416so3899834e87.2;
        Tue, 01 Oct 2024 19:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727836417; x=1728441217; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbGTpMQuJ5BfTFEroRt3BJM4+qdJ7VcgSP8FvNCXjGk=;
        b=gKfuto/t5eLpQkgVP2FIJseKsU14cqvanWPwiGucTeKBeOZ1swJwXSVR+bVr46z3lR
         4EB5najxcixBAv4DfFqJQOW/I6GL7iXyI7hek/WG/LZAH7Zj563U37NlysQyPQSMYjos
         Xp46RnWEXl7EtBmeOUGFTmj586J+zD5wC6EAXovCP6iswYtgPIUS/ZNa3Fk2lZ8c9ZSM
         zd8Fa/6thU3WShGb3oXHctCskWiaryONTgM2kughzeiBNtcsVm0RtXdkHz3VIPpeGW6t
         /7NMxNF3VWOK84HMeaYNVOaPHHHAoDy3jogeJ+uFzy9NYNYBXUnoWCXrAs3/N2hkZvOF
         Vslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727836417; x=1728441217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RbGTpMQuJ5BfTFEroRt3BJM4+qdJ7VcgSP8FvNCXjGk=;
        b=JpbTOYyk0tjJcBUffDfkzqtV/7FtfQkeu1r5JejZFZeVe0eOZycDPx2nrrixKI/Etl
         7GvOvj2JDrMB+mYgy3PxTnYF2ZJoqhKrOqRgplbEjCNmptNZdlp2h/+nOzqP/CZ7fcwl
         MFf+aMWXOtQjIw1A3+9D1Hq9bk9TnCvlghW/zBLuMMoIIVQhVMN6bSFghaWfd1AnlgAg
         gHNa/qz4iwpTVZe2/UmMTtF6pY7INAv810B+4nDvEcc7DcviQ4SPqB0ORgbG3vJs9IzB
         auijXoDZiBOutJ7L21+fNIJSmRdVadZWt55jondXMkH1aRSnSkTMBrO0i9gHFwqeo6hT
         ddaA==
X-Forwarded-Encrypted: i=1; AJvYcCUWvYfNduEJLAtyMBXFOZG4HeDpOBXy6NlOzHbflpCBiK/M1g5Wm4fKjM2lz+MU/kdlypQun5IlPBccSWxQ@vger.kernel.org, AJvYcCV7/R7wdBYsPMLN2EPtAPWszfFaCSy9A1xUTs+GVztm5isuZ0zWZEZGbKVPxo7U0IWbxA4wQVy6RaHc@vger.kernel.org
X-Gm-Message-State: AOJu0YxSE/HcZcqWsvPWz/4xytueGSoeVuxgcp2JIC82wyuAc7EWDZPn
	ZA0ahWnuDzyE10v015GCicAzIKxbWsttcIxkdrLfA1nDXwzLpFfeFT7faqgSek8CJ7+0rTqj/rQ
	KTFK7gGUyxOeVS3tnJneJ9Q0VAipwxA==
X-Google-Smtp-Source: AGHT+IH3LoHtLB/YbfwZ+NoHPNRII1hWUdgKW0GkEUV/PegH3ScpacnSB6h1VPh+4EXg00/A4EikmSwqZ6TRpYKFx20=
X-Received: by 2002:a05:6512:12c8:b0:52c:d628:c77c with SMTP id
 2adb3069b0e04-539a0793c4emr1064906e87.43.1727836416184; Tue, 01 Oct 2024
 19:33:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620083729.28623-1-wangrong@uniontech.com>
In-Reply-To: <20240620083729.28623-1-wangrong@uniontech.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 1 Oct 2024 21:33:24 -0500
Message-ID: <CAH2r5msOQ=OWAgRoYG5kO7fndMWt=_7ZBET-M3mkXMfgnLCM1A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use actual path when queryfs
To: wangrong <wangrong@uniontech.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Paulo just found this potentially important fix in email (it had gotten mis=
sed).

The one suspicious thing about this though ... we should have some
code paths where we would use the cached root handle for statfs
(which is preferable to doing an open of a new handle, since it is
already open we don't risk an error coming back on open).

Any ideas whether we also need additional changes to use the cached
root handle better in statfs (since in most cases to
Windows we would expect to have that)?


On Thu, Jun 20, 2024 at 3:54=E2=80=AFAM wangrong <wangrong@uniontech.com> w=
rote:
>
> Due to server permission control, the client does not have access to
> the shared root directory, but can access subdirectories normally, so
> users usually mount the shared subdirectories directly. In this case,
> queryfs should use the actual path instead of the root directory to
> avoid the call returning an error (EACCES).
>
> Signed-off-by: wangrong <wangrong@uniontech.com>
> ---
>  fs/smb/client/cifsfs.c   | 13 ++++++++++++-
>  fs/smb/client/cifsglob.h |  2 +-
>  fs/smb/client/smb1ops.c  |  2 +-
>  fs/smb/client/smb2ops.c  | 19 ++++++++++++-------
>  4 files changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index bb86fc064..a4d59f0f5 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -313,8 +313,17 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *b=
uf)
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         unsigned int xid;
>         int rc =3D 0;
> +       const char *full_path;
> +       void *page;
>
>         xid =3D get_xid();
> +       page =3D alloc_dentry_path();
> +
> +       full_path =3D build_path_from_dentry(dentry, page);
> +       if (IS_ERR(full_path)) {
> +               rc =3D PTR_ERR(full_path);
> +               goto statfs_out;
> +       }
>
>         if (le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength) > 0)
>                 buf->f_namelen =3D
> @@ -330,8 +339,10 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *b=
uf)
>         buf->f_ffree =3D 0;       /* unlimited */
>
>         if (server->ops->queryfs)
> -               rc =3D server->ops->queryfs(xid, tcon, cifs_sb, buf);
> +               rc =3D server->ops->queryfs(xid, tcon, full_path, cifs_sb=
, buf);
>
> +statfs_out:
> +       free_dentry_path(page);
>         free_xid(xid);
>         return rc;
>  }
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 73482734a..d3118d748 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -483,7 +483,7 @@ struct smb_version_operations {
>                         __u16 net_fid, struct cifsInodeInfo *cifs_inode);
>         /* query remote filesystem */
>         int (*queryfs)(const unsigned int, struct cifs_tcon *,
> -                      struct cifs_sb_info *, struct kstatfs *);
> +                      const char *, struct cifs_sb_info *, struct kstatf=
s *);
>         /* send mandatory brlock to the server */
>         int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u64=
,
>                          __u64, __u32, int, int, bool);
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 212ec6f66..e3a195824 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -909,7 +909,7 @@ cifs_oplock_response(struct cifs_tcon *tcon, __u64 pe=
rsistent_fid,
>
>  static int
>  cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> -            struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
> +            const char *path, struct cifs_sb_info *cifs_sb, struct kstat=
fs *buf)
>  {
>         int rc =3D -EOPNOTSUPP;
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index c8e536540..bb7194386 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2784,7 +2784,7 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>
>  static int
>  smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> -            struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
> +            const char *path, struct cifs_sb_info *cifs_sb, struct kstat=
fs *buf)
>  {
>         struct smb2_query_info_rsp *rsp;
>         struct smb2_fs_full_size_info *info =3D NULL;
> @@ -2793,7 +2793,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tc=
on *tcon,
>         int rc;
>
>
> -       rc =3D smb2_query_info_compound(xid, tcon, "",
> +       rc =3D smb2_query_info_compound(xid, tcon, path,
>                                       FILE_READ_ATTRIBUTES,
>                                       FS_FULL_SIZE_INFORMATION,
>                                       SMB2_O_INFO_FILESYSTEM,
> @@ -2821,28 +2821,33 @@ smb2_queryfs(const unsigned int xid, struct cifs_=
tcon *tcon,
>
>  static int
>  smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> -              struct cifs_sb_info *cifs_sb, struct kstatfs *buf)
> +              const char *path, struct cifs_sb_info *cifs_sb, struct kst=
atfs *buf)
>  {
>         int rc;
> -       __le16 srch_path =3D 0; /* Null - open root of share */
> +       __le16 *utf16_path =3D NULL;
>         u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>         struct cifs_open_parms oparms;
>         struct cifs_fid fid;
>
>         if (!tcon->posix_extensions)
> -               return smb2_queryfs(xid, tcon, cifs_sb, buf);
> +               return smb2_queryfs(xid, tcon, path, cifs_sb, buf);
>
>         oparms =3D (struct cifs_open_parms) {
>                 .tcon =3D tcon,
> -               .path =3D "",
> +               .path =3D path,
>                 .desired_access =3D FILE_READ_ATTRIBUTES,
>                 .disposition =3D FILE_OPEN,
>                 .create_options =3D cifs_create_options(cifs_sb, 0),
>                 .fid =3D &fid,
>         };
>
> -       rc =3D SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
> +       utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
> +       if (utf16_path =3D=3D NULL)
> +               return -ENOMEM;
> +
> +       rc =3D SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
>                        NULL, NULL);
> +       kfree(utf16_path);
>         if (rc)
>                 return rc;
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
