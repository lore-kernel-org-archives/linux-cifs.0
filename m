Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D847244661
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602281; cv=pass; b=TT0iB1Mf1DBuuTT0il9Wo/LPAw/5LW1NSUsgIjCt4t52uQZFu+WZ1bgUCqIVchfpkdM1vmMbnfSwDYzSMdDByK63OKE5vLgN+CbI3lqLqRmK3nu/dLc+bnMuDnZGOTAF1ZLtLI3ehPSYviOBeJFixjuv4rh7CR/RWO4l3DqJ0Ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602281; c=relaxed/simple;
	bh=XFTQinFBXxVB8xLgGYUTOcRgA8wSnnOUKdGuDP4dIKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SFiU1jcDQiHrC56ILis+GzV/w5l3Yr66BtimKCMAMA7B8TUkmtEX7YCDBiwKQUhTQPLYlHWObavK87NarHkryLCXckRsrRARFwxDNKjqyq33WJ1kx1DZeiPsMviwhN5BZqM3TuJjfbAfUWV+KKrK7W0Xm4Yf1LdLW4jiYz4t5V4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWH3lYuB; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWH3lYuB"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-6611669cd16so2236025d50.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 06:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783602278; cv=none;
        d=google.com; s=arc-20260327;
        b=SIWedtBAKiXhlYi7gkjVQDX4sq1xqfDHzTuIgNRaEnbqMnHBHPUPTjXzL3LkQqNOSJ
         io/MmjsvvsXy26nUEE/WxfwQ6NYvWttC4aPx0g6yjf/zj68cUpGNW5JMtT1kf8TkNpUE
         YtwmZKLv1fTWREMtaeFFp/Fq3N8oz6BDvNMTOqCN4sIQ/bBDM8NUYu0SD7Zhe39gn2Up
         r8Ir9wW7/qPzRnJFs91SAGxj+n8oshvvYKoCH88XrKh2xP36B+UUiKDGuSFnPVyonKGM
         tuvFQ7K7ydSE1zgpv46rGqJh/4piVkqJz+j3wNKYrK7XpMYqmVLQVK2A/y2dr/Ri3DCX
         mOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rHRUhLV9H4buT/j0yw3aRJSZT0sqIFWKcf3OiYJu03E=;
        fh=2zNLWgFl9zg+/cipcGmknOnuhJ3qe50mTrIa/DcLLbY=;
        b=KuG5JuTeZI5R6mDU6owDltHOwhyo47vpydjiyK8LMQ9uHoBksNNI5sjj8lXTB/8FXo
         t4HxZKObx79CdxAgbktueissf5Ofs+WPwLwbnDi+5mVakz+sCEMYJdWnd/sDX4Bb3yJp
         Z0pCcZ7ZSCrsFso7Xa6VGOgRGSY22Gs5xs3ug3o5O29UpEm0kXHigEUfP5O7JkQNFG3l
         3pXQUFGC2vHbAyUKJYRFwJ450//Qmaod1KHulMWUC6/P2Pv4adkVnFWo7/NgpgnEFoij
         4PQiaX/5UoItutAN4j43I8dhZH4VdoX2KJON1aAe71R1qaOc0Xwl+g/OGgrXIv9JI+Bc
         Obkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783602278; x=1784207078; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rHRUhLV9H4buT/j0yw3aRJSZT0sqIFWKcf3OiYJu03E=;
        b=KWH3lYuBfJutXaXFLzLXSQ1faqDcwH51YIHgtlXWjBOntB2lfwnxXDriz2O4PVyZ1i
         P/N5hOkRNW1vwIKgV+h6fbym7nbLve6hQytJ9FJSGT6O4BPXWS0iFDkKW+8DdWpORKBH
         h2+lFRu697/wplZUk3Zx6JHdDFCnCpUH2kYmy4tcu6jQQgmGSJvPRMWrEzKrIYiETv1h
         0AQbqssLXs2+dr4kNY2ZpiwUUoFcdG8VHMBzv6Mz+gapwoaQfNypYRVUMsao/EYTjd+k
         X0MXfLuc+WLfylQQCNYfPK7CJklp/CdHHwNEi5Am2ycc6rXWpl8zxcV9YFzlS4GnuHoe
         ClQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783602278; x=1784207078;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rHRUhLV9H4buT/j0yw3aRJSZT0sqIFWKcf3OiYJu03E=;
        b=F1JVAlis8P1lOfKIG2jwWt9QTIUaE20ZXYuzuFYyzfxoGW1z83Cy4135ra7ULOjjL3
         loir7K6lB7lxVa13KK/WxM3Du4FQZazVSxcW3IhESwqDpEij5m1famt8eM3J/+QEWL+C
         fUQxfdDG7e8D2+hmISkcQiZCfgNXTDJOme9PmgAUlosC3/4OCw4vBieiZAAxfQIrFV88
         V56RxJSySSgeREXRi0EcLwglB4xDHznZbWl5HsvuusnFSaxTQ5v4u6Yl7ECEcF6Wyt3R
         ndERHb39Q/iXuMZZf4LDPK9k2TKjQxCbiddi+td5Gkq6nDVQhcDmYcS8TZh6nbCTyIFx
         OFCQ==
X-Forwarded-Encrypted: i=1; AHgh+RoEF562eZjB/SYomlt2riSI6m7fweZe22ZlJcj3Bgt6lFN0RV9UJj/jSoRV3T38HM/H7Nk1yiIUfYjE@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlm7zlX9hv+GdnOKQUe6kNHgYEz76mdTWHKRqNCA2sBcmp9J5j
	PKFFmb9oIKdcg+A7db8Xl0LxKX6Kjhdb+kfHXB9nSq91sVzX7WEPddARk8uvnySdOEVfS2l5D8f
	4Opycv62I/AftDB3105mc9axgbmcWodI=
X-Gm-Gg: AfdE7clpYywXhlOHZIj0TVU5ZWwEFEBORg00uIflKbTqX5OWH7NtR+dj55XITXYuAfM
	tYV4Qte7yfmYjvIufDzlawuJaJlRu9GrUAofADx9kgCRo1G0FOdCoVjy3YbDaBUjTRlw142fXvW
	QBRQosWO5hWuOHFU95P3jEOjQMWwqdebP3CQqQJnY7fyY7KmMNK4s5jAKGozdEqawILqurtx9NQ
	vXupO9I5SM1TPYfuuHQM2Aq/Zd+OjwU4esQBdJoxyKiio+fhAK3Wo08JJK16NBcaLOGY3UAG6Ev
	LU482Dc1WFeZZ13/bkFAJdCVMTreXbZ5KlVbxHa7u518nURd9P1EqIDBXuDYeQJriwGbrPtZKCG
	Ua2jussty+ogETMB4pgzt938BeRBY2/i3p7unXIyAhGrbfU6+y0s8hk+xgVGU1FuFCrJRYV38mZ
	DKAW5WuI6Jyfk=
X-Received: by 2002:a05:690e:190d:b0:667:963f:eba5 with SMTP id
 956f58d0204a3-6679f2f1945mr5384886d50.106.1783602277849; Thu, 09 Jul 2026
 06:04:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6dd60d4365ed96f472c9b59dc8fca6bf@manguebit.org> <20260706182936.22007-1-pali@kernel.org>
In-Reply-To: <20260706182936.22007-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jul 2026 08:04:25 -0500
X-Gm-Features: AUfX_mzeqK1kZoz40vXWhqkRCSFaq9Tf-R-3EJ7qqWaNl-7UlZf966Is0Qt4TtM
Message-ID: <CAH2r5msn6kfGt6bNcuxEjXvmTCpEu6V1MWWi1EeT9MnLLeKGCg@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: Show reason why autodisabling serverino support
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Jul 6, 2026 at 1:31=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> Extend cifs_autodisable_serverino() function to print also text message w=
hy
> the function was called.
>
> The text message is printed just once for mount then autodisabling
> serverino support. Once the serverino support is disabled for mount it wi=
ll
> not be re-enabled. So those text messages do not cause flooding logs.
>
> This change allows to debug issues why cifs.ko decide to turn off server
> inode number support and hence disable support for detection of hardlinks=
.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifsproto.h | 2 +-
>  fs/smb/client/connect.c   | 2 +-
>  fs/smb/client/dfs_cache.c | 2 +-
>  fs/smb/client/inode.c     | 7 ++++---
>  fs/smb/client/misc.c      | 6 +++++-
>  fs/smb/client/readdir.c   | 4 ++--
>  6 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 1ed97957038f..1202934d7b94 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -317,7 +317,7 @@ int generate_smb311signingkey(struct cifs_ses *ses,
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
> -void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
> +void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char=
 *reason, int rc);
>  bool couldbe_mf_symlink(const struct cifs_fattr *fattr);
>  int check_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
>                      struct cifs_sb_info *cifs_sb, struct cifs_fattr *fat=
tr,
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 85aec302c89e..522c2abd930c 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3875,7 +3875,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct=
 smb3_fs_context *ctx)
>          * After reconnecting to a different server, unique ids won't mat=
ch anymore, so we disable
>          * serverino. This prevents dentry revalidation to think the dent=
ry are stale (ESTALE).
>          */
> -       cifs_autodisable_serverino(cifs_sb);
> +       cifs_autodisable_serverino(cifs_sb, "DFS failover may potentially=
 connect to a different server, inode numbers won't match anymore", 0);
>         /*
>          * Force the use of prefix path to support failover on DFS paths =
that resolve to targets
>          * that have different prefix paths.
> diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
> index 83f8cf2f8d2b..42eee0de8895 100644
> --- a/fs/smb/client/dfs_cache.c
> +++ b/fs/smb/client/dfs_cache.c
> @@ -1328,7 +1328,7 @@ int dfs_cache_remount_fs(struct cifs_sb_info *cifs_=
sb)
>          * After reconnecting to a different server, unique ids won't mat=
ch anymore, so we disable
>          * serverino. This prevents dentry revalidation to think the dent=
ry are stale (ESTALE).
>          */
> -       cifs_autodisable_serverino(cifs_sb);
> +       cifs_autodisable_serverino(cifs_sb, "DFS failover may potentially=
 connect to a different server, inode numbers won't match anymore", 0);
>         /*
>          * Force the use of prefix path to support failover on DFS paths =
that resolve to targets
>          * that have different prefix paths.
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 002a2ec85db5..945a34f3d830 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1090,7 +1090,7 @@ static void cifs_set_fattr_ino(int xid, struct cifs=
_tcon *tcon, struct super_blo
>                         fattr->cf_uniqueid =3D CIFS_I(*inode)->uniqueid;
>                 else {
>                         fattr->cf_uniqueid =3D iunique(sb, ROOT_I);
> -                       cifs_autodisable_serverino(cifs_sb);
> +                       cifs_autodisable_serverino(cifs_sb, "Cannot retri=
eve inode number via get_srv_inum", rc);
>                 }
>                 return;
>         }
> @@ -1546,7 +1546,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr=
 *fattr)
>                         fattr->cf_flags &=3D ~CIFS_FATTR_INO_COLLISION;
>
>                         if (inode_has_hashed_dentries(inode)) {
> -                               cifs_autodisable_serverino(CIFS_SB(sb));
> +                               cifs_autodisable_serverino(CIFS_SB(sb), "=
Inode number collision detected", 0);
>                                 iput(inode);
>                                 fattr->cf_uniqueid =3D iunique(sb, ROOT_I=
);
>                                 goto retry_iget5_locked;
> @@ -1612,8 +1612,9 @@ struct inode *cifs_root_iget(struct super_block *sb=
)
>  iget_root:
>         if (!rc) {
>                 if (fattr.cf_flags & CIFS_FATTR_JUNCTION) {
> +                       cifs_dbg(VFS, "Removing junction mark and disabli=
ng 'serverino' to prevent inode collisions\n");
>                         fattr.cf_flags &=3D ~CIFS_FATTR_JUNCTION;
> -                       cifs_autodisable_serverino(cifs_sb);
> +                       cifs_autodisable_serverino(cifs_sb, "Cannot retri=
eve attributes for junction point", rc);
>                 }
>                 inode =3D cifs_iget(sb, &fattr);
>         }
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 0c54b9b79a2c..f47874734248 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -278,7 +278,7 @@ dump_smb(void *buf, int smb_buf_length)
>  }
>
>  void
> -cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
> +cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb, const char *rea=
son, int rc)
>  {
>         unsigned int sbflags =3D cifs_sb_flags(cifs_sb);
>
> @@ -290,6 +290,10 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs=
_sb)
>
>                 atomic_andnot(CIFS_MOUNT_SERVER_INUM, &cifs_sb->mnt_cifs_=
flags);
>                 cifs_sb->mnt_cifs_serverino_autodisabled =3D true;
> +               if (rc)
> +                       cifs_dbg(VFS, "%s: %d\n", reason, rc);
> +               else
> +                       cifs_dbg(VFS, "%s\n", reason);
>                 cifs_dbg(VFS, "Autodisabling the use of server inode numb=
ers on %s\n",
>                          tcon ? tcon->tree_name : "new server");
>                 cifs_dbg(VFS, "The server doesn't seem to support them pr=
operly or the files might be on different servers (DFS)\n");
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index a50c86bbe60f..ee5996e6d7d8 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -415,7 +415,7 @@ _initiate_cifs_search(const unsigned int xid, struct =
file *file,
>         if (rc =3D=3D 0) {
>                 cifsFile->invalidHandle =3D false;
>         } else if (rc =3D=3D -EOPNOTSUPP && (sbflags & CIFS_MOUNT_SERVER_=
INUM)) {
> -               cifs_autodisable_serverino(cifs_sb);
> +               cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inod=
e number via query_dir_first", rc);
>                 goto ffirst_retry;
>         }
>  error_exit:
> @@ -1029,7 +1029,7 @@ static int cifs_filldir(char *find_entry, struct fi=
le *file,
>                 fattr.cf_uniqueid =3D de.ino;
>         } else {
>                 fattr.cf_uniqueid =3D iunique(sb, ROOT_I);
> -               cifs_autodisable_serverino(cifs_sb);
> +               cifs_autodisable_serverino(cifs_sb, "Cannot retrieve inod=
e number from readdir", 0);
>         }
>
>         if ((sbflags & CIFS_MOUNT_MF_SYMLINKS) && couldbe_mf_symlink(&fat=
tr))
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
