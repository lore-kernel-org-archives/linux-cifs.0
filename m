Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3B280A50;
	Wed, 11 Jun 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652746; cv=none; b=OM8A2HqdveRAZNpC/xQXal3+y86fF6BKH9fR8Npi7EORSaAb2HcQZmiTtst9oKEjf4xu0sfDeLNfER4cvij6gpjx3/Wp4WMTZFB1KAkZ8eR8Uf9wHWoXlCbvGKoqEvgk5dEwLctouixTTy0OsdVZvTuxoMudiCHJs1MFFhN9d9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652746; c=relaxed/simple;
	bh=8oCMLf8vPQ9jTs7p9oEliirq63nIEIfu1FyXFrSQWBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a85L7M1m7E3MojGnfgFDGOw1+DzeV85p6+6Tuhj6N4gKtgnYaf6Z3FWMFdAl15eM2I5RzRkQMfLpOMo063BVIT0OYD1AJWzbu2YEitks554cJsDYn0DfuwHvMXP3J+S6IelsP1y2ARjW/7YO5UF2Cpl2DWJLuYvIeQ65d6v6rl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBY+BK8a; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBY+BK8a"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-551ed563740so8377344e87.2;
        Wed, 11 Jun 2025 07:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749652743; x=1750257543; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CclSnTqBjqm8tfGuUrNC2L8kD9q5HXkHtfqBuTijO/U=;
        b=mBY+BK8aIja8MYYWo+PQ0mHjgPNba7Plme4kyzFIocztTQyDeAkXRtuC0ksU2AfEgh
         JNW1ypYKPdt3HfEQk9WyxuviShsTQ4dpV9p+Lz9nMIsguhtRKkW7GLulyGYlWHEuwiKq
         scmwW2ltKfvaUwm0DvyqTSMgAJPWgC0zForIUa7eQYpGZDAPWbdgYijip6fhT5wweSdG
         Sz3rM52J8C27TkbH6y8o2FH7g1PXRkBSeulPPQy6f/8VyWnqW6VAd7U4TYLiSGck8gWu
         wBc48xi18iwB+2npA/pfzUBYOePQGqJM39GzM8AZuw47wptnGpSpTlOZnQZq9QT47TCn
         xP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749652743; x=1750257543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CclSnTqBjqm8tfGuUrNC2L8kD9q5HXkHtfqBuTijO/U=;
        b=i1Xmm+yHg00ObKh4952S6kP6Nh7+AIiexeneILLxD3QL3NpXjjT+tCIOLWm9dZudhN
         6JzguWV6wcmL+8SYPxE3bgLDkuRoEyhWJhbBYWgHKQaJ56KGc+dWCxx9qZFXnllLdwWj
         dP6VvG/s1sOwcPaxDi7c5wWMWA2AVt2CHMqe1Peq7LQ2wvpqnHhe2iv6tEvhu55OLqUO
         R1KtsG5sg6MiIX4mTv7Y0U29CWDE/mTEs8PpzI9S8hdltrp7+L12opOja9w75vG3a4Cb
         MNMmjHCvUriiv5QZil8KBrGwLc+TjKIoDMJUof22hCvhE0/HU0knEqT8Po7DiHYxbUwj
         0diw==
X-Forwarded-Encrypted: i=1; AJvYcCWP4LCJ+rrRaA6Md3Y9X8D+g+2p7RpDvcNbr2OK+p+neFEa5BfnyzCTuuSVkGLgOGHw3oLXBIM7jqte5jkm@vger.kernel.org, AJvYcCWz910JlNEOJX+fxJM6xTdXxp1VZ9JNtq47gmVcdwO6EEs7XHdTMz9emAHsBJqTbPiFOVJ/jEHAYCrp@vger.kernel.org
X-Gm-Message-State: AOJu0YxiMPb2Z/HtDrxNDtE3LC6S8oygaavMoJcq8UH4FOIzwUXP9kAv
	xLik4m6CJdWUua67GU+qUT+bxEQ9NqRm25/YpXgcoqjimC1o1cADRLgAv36iVK8ayn/v85XwJO+
	ANA3xmtE6hEmQPI8TCvwjzmpRNG+4rgU=
X-Gm-Gg: ASbGncuk1Cxsjyd7cRa4KMiTQg5b97gJVzkdzdkQw2Xo2PZstqZzf5IYNz10uTTS7Xw
	JdRGnzjhQU81j32ZOWTwgMyT6ATetisMyaN3bwZZVZp2PcXwH42n5TSbwyGiqj2A0Rx9xATI0Pi
	uih6SJkoR/8wzkF16BGhhajZ5h9l90OCaSj8qE1cpb2n7kEIj+bWSc0N4y8q6FshExSYtgoaNFh
	9GwamjxEoVbwbeH
X-Google-Smtp-Source: AGHT+IEy9p5w7O5iRdcvOWYEntEibZDp1AXm2McwI5MFASJnq8E3nwPc0/O2DywYL/Ae3PLUAXcuwa1MjpxzPPRH/ho=
X-Received: by 2002:a05:651c:325c:b0:32b:2e45:c403 with SMTP id
 38308e7fff4ca-32b2e45c763mr1034921fa.39.1749652742354; Wed, 11 Jun 2025
 07:39:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250610213404.16288-1-pali@kernel.org>
In-Reply-To: <20250610213404.16288-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Jun 2025 09:38:50 -0500
X-Gm-Features: AX0GCFs5FqnKXTgdqtmLG8f6KS9Suoat-eppkt6HYJJXnDkCJGPgyQ8bu0n_8q8
Message-ID: <CAH2r5mspnw=BsE-dkzAPC3Q7vMu-pBHYk8k5jcJ1RhwFi=UG5g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix lstat() and AT_SYMLINK_NOFOLLOW to work on
 broken symlink nodes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, Remy Monsen <monsen@monsen.cc>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more testing.

Also added Acked-by from Meetakshi

On Tue, Jun 10, 2025 at 4:34=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Currently Linux SMB client returns EIO for lstat() and AT_SYMLINK_NOFOLLO=
W
> calls on symlink node when the symlink target location is broken or canno=
t
> be read or parsed.
>
> Fix this problem by relaxing the errors from various locations which pars=
es
> information about symlink file node (UNIX SMB1, native SMB2+, NFS-style,
> WSL-style) and let readlink() syscall to return EIO when the symlink targ=
et
> location is not available.
>
> Note that SFU symlinks and MF symlinks are not affected by this issue,
> their parser has already relaxed code.
>
> This change fixes the 'ls -l -a' call on directory which has symlink node=
s
> with broken target locations.
>
> Reported-by: Remy Monsen <monsen@monsen.cc>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifsfs.c   |  3 +-
>  fs/smb/client/inode.c    | 24 ++++++++++++++++
>  fs/smb/client/reparse.c  | 61 ++++++++++++++++++++++++++++++++--------
>  fs/smb/client/smb2file.c | 10 ++++---
>  4 files changed, 81 insertions(+), 17 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index a08c42363ffc..f4b923f73dca 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -1180,7 +1180,8 @@ const char *cifs_get_link(struct dentry *dentry, st=
ruct inode *inode,
>                 strscpy(target_path, CIFS_I(inode)->symlink_target, PATH_=
MAX);
>         } else {
>                 kfree(target_path);
> -               target_path =3D ERR_PTR(-EOPNOTSUPP);
> +               /* If symlink_target is not filled for symlink then it is=
 an IO error. */
> +               target_path =3D ERR_PTR(-EIO);
>         }
>         spin_unlock(&inode->i_lock);
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index b1c6e3986278..762cd194946a 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -480,6 +480,12 @@ static int cifs_get_unix_fattr(const unsigned char *=
full_path,
>                                                 cifs_sb, full_path,
>                                                 &fattr->cf_symlink_target=
);
>                 cifs_dbg(FYI, "%s: query_symlink: %d\n", __func__, rc);
> +               /*
> +                * Convert -EIO to 0. This let lstat() success and
> +                * empty data->cf_symlink_target triggers readlink() to f=
ail with -EIO.
> +                */
> +               if (rc =3D=3D -EIO)
> +                       rc =3D 0;
>         }
>         return rc;
>  }
> @@ -1133,6 +1139,12 @@ static int reparse_info_to_fattr(struct cifs_open_=
info_data *data,
>                         rc =3D server->ops->query_symlink(xid, tcon,
>                                                         cifs_sb, full_pat=
h,
>                                                         &data->symlink_ta=
rget);
> +                       /*
> +                        * Convert -EIO to 0. This let lstat() success an=
d
> +                        * empty data->symlink_target triggers readlink()=
 to fail with -EIO.
> +                        */
> +                       if (rc =3D=3D -EIO)
> +                               rc =3D 0;
>                 }
>                 if (rc =3D=3D -EOPNOTSUPP)
>                         data->reparse.tag =3D IO_REPARSE_TAG_INTERNAL;
> @@ -1182,6 +1194,18 @@ static int reparse_info_to_fattr(struct cifs_open_=
info_data *data,
>                          */
>                         if (rc =3D=3D -EOPNOTSUPP)
>                                 rc =3D 0;
> +               } else if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLIN=
K) {
> +                       /*
> +                        * data->reparse.tag can be set to IO_REPARSE_TAG=
_SYMLINK
> +                        * by STATUS_STOPPED_ON_SYMLINK error code. In th=
is case
> +                        * we do not have a real reparse point iov buffer=
 so
> +                        * data->reparse.buf and data->reparse.io.iov.iov=
_base
> +                        * are not set. And in the case symlink target lo=
cation
> +                        * in the struct smb2_symlink_err_rsp is parsable=
 then we
> +                        * even do not have data->symlink_target. So set =
rc to 0
> +                        * which let lstat() success and readlink() to fa=
il.
> +                        */
> +                       rc =3D 0;
>                 }
>
>                 if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLINK && !r=
c) {
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index d1d25f5f72ca..c70affb7b7f7 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -739,7 +739,11 @@ static int parse_reparse_nfs(struct reparse_nfs_data=
_buffer *buf,
>         case NFS_SPECFILE_LNK:
>                 if (len =3D=3D 0 || (len % 2)) {
>                         cifs_dbg(VFS, "srv returned malformed nfs symlink=
 buffer\n");
> -                       return -EIO;
> +                       /*
> +                        * This is an -EIO error. Convert it to 0. This l=
et lstat() success and
> +                        * empty data->symlink_target triggers readlink()=
 to fail with -EIO.
> +                        */
> +                       return 0;
>                 }
>                 /*
>                  * Check that buffer does not contain UTF-16 null codepoi=
nt
> @@ -747,7 +751,11 @@ static int parse_reparse_nfs(struct reparse_nfs_data=
_buffer *buf,
>                  */
>                 if (UniStrnlen((wchar_t *)buf->DataBuffer, len/2) !=3D le=
n/2) {
>                         cifs_dbg(VFS, "srv returned null byte in nfs syml=
ink target location\n");
> -                       return -EIO;
> +                       /*
> +                        * This is an -EIO error. Convert it to 0. This l=
et lstat() success and
> +                        * empty data->symlink_target triggers readlink()=
 to fail with -EIO.
> +                        */
> +                       return 0;
>                 }
>                 data->symlink_target =3D cifs_strndup_from_utf16(buf->Dat=
aBuffer,
>                                                                len, true,
> @@ -986,6 +994,14 @@ int smb2_parse_native_symlink(char **target, const c=
har *buf, unsigned int len,
>         if (rc !=3D 0)
>                 kfree(linux_target);
>         kfree(smb_target);
> +
> +       /*
> +       * Convert -EIO to 0. This let lstat() success and
> +       * empty *target triggers readlink() to fail with -EIO.
> +       */
> +       if (rc =3D=3D -EIO)
> +               rc =3D 0;
> +
>         return rc;
>  }
>
> @@ -1004,7 +1020,11 @@ static int parse_reparse_native_symlink(struct rep=
arse_symlink_data_buffer *sym,
>         len =3D le16_to_cpu(sym->SubstituteNameLength);
>         if (offs + 20 > plen || offs + len + 20 > plen) {
>                 cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
> -               return -EIO;
> +               /*
> +                * This is an -EIO error. Convert it to 0. This let lstat=
() success and
> +                * empty data->symlink_target triggers readlink() to fail=
 with -EIO.
> +                */
> +               return 0;
>         }
>
>         return smb2_parse_native_symlink(&data->symlink_target,
> @@ -1024,16 +1044,19 @@ static int parse_reparse_wsl_symlink(struct repar=
se_wsl_symlink_data_buffer *buf
>         int symname_utf8_len;
>         __le16 *symname_utf16;
>         int symname_utf16_len;
> +       int rc =3D 0;
>
>         if (len <=3D data_offset) {
>                 cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\=
n");
> -               return -EIO;
> +               rc =3D -EIO;
> +               goto out;
>         }
>
>         /* MS-FSCC 2.1.2.7 defines layout of the Target field only for Ve=
rsion 2. */
>         if (le32_to_cpu(buf->Version) !=3D 2) {
>                 cifs_dbg(VFS, "srv returned unsupported wsl symlink versi=
on %u\n", le32_to_cpu(buf->Version));
> -               return -EIO;
> +               rc =3D -EIO;
> +               goto out;
>         }
>
>         /* Target for Version 2 is in UTF-8 but without trailing null-ter=
m byte */
> @@ -1044,17 +1067,21 @@ static int parse_reparse_wsl_symlink(struct repar=
se_wsl_symlink_data_buffer *buf
>          */
>         if (strnlen(buf->Target, symname_utf8_len) !=3D symname_utf8_len)=
 {
>                 cifs_dbg(VFS, "srv returned null byte in wsl symlink targ=
et location\n");
> -               return -EIO;
> +               rc =3D -EIO;
> +               goto out;
>         }
>         symname_utf16 =3D kzalloc(symname_utf8_len * 2, GFP_KERNEL);
> -       if (!symname_utf16)
> -               return -ENOMEM;
> +       if (!symname_utf16) {
> +               rc =3D -ENOMEM;
> +               goto out;
> +       }
>         symname_utf16_len =3D utf8s_to_utf16s(buf->Target, symname_utf8_l=
en,
>                                             UTF16_LITTLE_ENDIAN,
>                                             (wchar_t *) symname_utf16, sy=
mname_utf8_len * 2);
>         if (symname_utf16_len < 0) {
>                 kfree(symname_utf16);
> -               return symname_utf16_len;
> +               rc =3D symname_utf16_len;
> +               goto out;
>         }
>         symname_utf16_len *=3D 2; /* utf8s_to_utf16s() returns number of =
u16 items, not byte length */
>
> @@ -1062,10 +1089,20 @@ static int parse_reparse_wsl_symlink(struct repar=
se_wsl_symlink_data_buffer *buf
>                                                        symname_utf16_len,=
 true,
>                                                        cifs_sb->local_nls=
);
>         kfree(symname_utf16);
> -       if (!data->symlink_target)
> -               return -ENOMEM;
> +       if (!data->symlink_target) {
> +               rc =3D -ENOMEM;
> +               goto out;
> +       }
>
> -       return 0;
> +out:
> +       /*
> +       * Convert -EIO to 0. This let lstat() success and
> +       * empty data->symlink_target triggers readlink() to fail with -EI=
O.
> +       */
> +       if (rc =3D=3D -EIO)
> +               rc =3D 0;
> +
> +       return rc;
>  }
>
>  int parse_reparse_point(struct reparse_data_buffer *buf,
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index a7f629238830..9ac359f7be43 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -76,11 +76,11 @@ int smb2_fix_symlink_target_type(char **target, bool =
directory, struct cifs_sb_i
>                 return 0;
>
>         if (!*target)
> -               return -EIO;
> +               return 0;
>
>         len =3D strlen(*target);
>         if (!len)
> -               return -EIO;
> +               return 0;
>
>         /*
>          * If this is directory symlink and it does not have trailing sla=
sh then
> @@ -103,8 +103,10 @@ int smb2_fix_symlink_target_type(char **target, bool=
 directory, struct cifs_sb_i
>          * cannot contain slash character. File name with slash is invali=
d on
>          * both Windows and Linux systems. So return an error for such sy=
mlink.
>          */
> -       if (!directory && (*target)[len-1] =3D=3D '/')
> -               return -EIO;
> +       if (!directory && (*target)[len-1] =3D=3D '/') {
> +               kfree(*target);
> +               *target =3D NULL;
> +       }
>
>         return 0;
>  }
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
