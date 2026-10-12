Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BF470130
	for <linux-cifs@vger.kernel.org>; Mon, 12 Oct 2026 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815443; cv=pass; b=fEhreFYGbRsK03Ev8EM+FgcWlmVOXOUhSERLBlSUZ/C6jyCOvoV9s004CdHLNNgu2dJ/8jJYA8I7/wbs63Wcf/upasbTDYh8vsK23HmoCgsstA3QAXWXRaFqX16twJhR1djaGi225dRd3eokymf5tLI4VVeTd+qbUm3ZsFwSPa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815443; c=relaxed/simple;
	bh=cY/JBGh/hwGpvSrRdbWicIuwFqUbUO1NYgLVdjhfIyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hVAtvTf8GOkGpzVEkREFncbeAngsDMAJHeicyIXe+xRdmzB2WCatZg/2UHE2tkwGjwR2T3NIsI5E6bnTCIlhFEuMpuKiJHZ4p5ikE7oWc1N5/abKS3pVULKM2xD3HaGPoOnebprKiqMNfKWPio+X7qwDehsA4NuoIC/YEb6JEuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XO6es4hr; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XO6es4hr"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-7907f01e487so118668137.2
        for <linux-cifs@vger.kernel.org>; Mon, 12 Oct 2026 07:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791815441; cv=none;
        d=google.com; s=arc-20260327;
        b=cpk9+g1ngJVoWUZugPRYDSd5kglcRDR/vaGih++22eO2rZs3EKsXJ5VgjXuXjW5hsx
         wWj9vc2Ux6Zpzc6ChMuoroZTg8Fs6/FmItI4+MEasyhKBcskmlnDAGHT4bq5QgqVZ3CE
         brL4bLXMaaOXc009k5mrH3malKNE239BoiUjMOzmVDmPlUWIJds8F/M7zXc4+pq2LCsv
         RHxY6uoMHsUXXqYEMvFKoYqt/vXhtgsPzTuWxR65JTwChB90LEsvRLvPEohXQMdqC1L5
         0RmCD6KThJeyAf/qYzhvgP3eYVulbEMY/3EG86WtDIJaVnv7WrLF4wQh1oZpzR/9d8xA
         1Zmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i53cakjPfkVLTz+URoRixAorII/+Ktg3Ujd3YzzVevU=;
        fh=2Q1VXv/UuOxE4weBBcZmCknXmlcLM/OqPNkzlk2jphA=;
        b=ecJPGx7Eh7n2osIuksvnhXaap2Sng4gH41SIRJ4pt1frDRrWVCTt0QPy9Cmk6aiEaD
         GqoSZ3LOmyqZkoRMhAzXF1xXAALMuVCiR2HlrgJuHFQ4gxqaRDuNmGGgWCFtOS9UDX32
         uTpgmMgXTqdwwZvpqT0UtStqtxBYJ2YmOwsH/A9DKZz1H9y/HBswANhaRW5qCcMIRox8
         MbYZ5XT9R/L8qGfXrLCDeIY/Fpv1r9ft+zEtQmEJl/NgAq/r4BhY7HUgL3d36jIjJzYX
         BDc/oR9BRXRCPR5PxpLMMjeXVJGJ+pAeJhwZZ4z7ZnjKzzkoYeIzgGmUY/knCNPQVniO
         cwIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791815441; x=1792420241; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i53cakjPfkVLTz+URoRixAorII/+Ktg3Ujd3YzzVevU=;
        b=XO6es4hr7UFZt+vCQzlHIEk7+R1F1N2exL1e+mqPwbW+ZczPJ8bzfHEzdohWJKGhSf
         Nc9yrKP2zzV2hwrKYrJG9R1amefatBC0W7G82uWdyoifO59VF+1SRpbJbw5j9rUW7kY6
         /vU/e7lRZHbrrnytLLDUXmy6HYw7Fb/UeDqRtJi4sZvLCGRl5idBu1aomGPGmBJ0vOtX
         bWrgFHYcJxreDnliqY1LW2jabzkv5+RV/UL/ESshEhy0GQtwdcokNdpFSXtHAUvcQARB
         3HvfSpavQ/Z5FN8rN7Rxvx5zyxMYNyxgLzhK00dzHXfzW3ejqmC5nyoezH0YXwEqZ3hH
         L0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791815441; x=1792420241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i53cakjPfkVLTz+URoRixAorII/+Ktg3Ujd3YzzVevU=;
        b=zTD/ze02ssLL4hdyrLGfEe4m6A3yOOr5FKdYsoNkVKNb45eio5xKbqcUynkocZ3UgF
         +PoBxBN4yPn5XBMEIFrewqKT18T5/sMLRUjHpOaPVwb5kJq61bnse8LRvaX+jjvVd5p9
         jDzYffxAhRttHyae2K8auTgiobFPpsNMFYIXlJucj5ng4i9NoWaZXGIOakdDP1v5+8Dy
         W+Z9QkG6LoE4Wr6ftyW2RaQ7h2edecoBHj8SdL06hwijMAr3aQxj9U+gLJFF2Ou1yDhq
         ozPh+fqxwx8xjWWLKYVdwVsXMOHy8qJdqMwjv6d9KMW5B+FlbepetA0wbbRuvkaZR3z4
         5qnw==
X-Forwarded-Encrypted: i=1; AKwUvByQrTqh9BXhWpDBskV+KGgQ9E2Ddu4bI06tbc2BjCgrmNs0NYqeZfxCNbvRnU7mVgvHgd7lnEp7/i+K@vger.kernel.org
X-Gm-Message-State: AFq9FYL+z3pRy4J15o7YA0SQw56eU9tdInKW22+aCqJ5LZZDbR1zSXVt
	i/lcEU9LeUlxSDEckDT09EdGjMrjTCjXt+h0BrhFpzbiNSKhhXlEQgChxzX/F6TI75V25eN1JYm
	jGSPK6qG1Ut2EObuQGZ9odIbxGApqEKI=
X-Gm-Gg: AYBFou2uX9sYyoO5Yqxj7uRlbBGAfmP4W9EvbkWCo5XpswVPjHyPM5a2DmJR+b8bfkH
	or63xf6WXXod9lVd58PO4QiVXMIvmCpvQaIATzI/WoHC5wb3G/XhjUXi5DdqhoZllDT/W1uK36N
	WAnpiijFJUR5YhV19bGijEWZIu+WFmSl0dJzxZ7Q2dkUVbWbqJMUbS8fJIqVxxWwbmjFKRAeOd9
	zdEsovMTacL9tBGqNF4i9LfSgpBx0HaBLCGvDoN2QY6qqTRy1jdpe/ob/8RovzREAqECd5Dosc2
	rYmU7U8pOc+jSsqR1w0M2Ywe6C1xGEVuOExlG32o82AQvmDqv3d7CWw=
X-Received: by 2002:a05:6102:419f:b0:7c8:18a2:f769 with SMTP id
 ada2fe7eead31-7cb391458acmr2293372137.0.1791815440564; Mon, 12 Oct 2026
 07:30:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aszji59b6B79a3Hi@sirena.org.uk>
In-Reply-To: <aszji59b6B79a3Hi@sirena.org.uk>
From: Ozgur <zgrieee@gmail.com>
Date: Mon, 12 Oct 2026 17:30:28 +0300
X-Gm-Features: AclHuK-FGPOheor9BkRHjONa2cvRES-RJIe10Ctv35rk327UqJcfONC6p4NJl7A
Message-ID: <CAOFRbGnVCnW4CEvhp_x6t58v0sB2to+6AP0hHYtci0EBnUWQzQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the vfs-brauner tree
To: Mark Brown <broonie@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Paulo Alcantara <pc@manguebit.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org>, 12 Eki 2026 Pzt, 16:50 tarihinde =C5=9Funu=
 yazd=C4=B1:
>
> Hi all,

Hi Mark,

i noticed Namjae Jeon's commit (2de2cdd9cc08, ntfs: add pathname
access for named streams) is currently present in fs-next and your
reported build failure appears to result from this commit interacting
with VFS changes that make mnt_idmap const in the ->setattr() and
->getattr() callbacks, and i think fs-next before changes are
integrated into linux-next

i compiled linux-next tree but couldnt reproduce the build failure.

Regards

Ozgur

>
> After merging the vfs-brauner tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> /tmp/next/build/fs/smb/client/cifsfs.c:1258:18: error: incompatible funct=
ion pointer types initializing 'int (*)(const struct mnt_idmap *, struct de=
ntry *, struct file_kattr *)' with an expression of type 'int (struct mnt_i=
dmap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-poi=
nter-types]
>  1258 |         .fileattr_set =3D cifs_fileattr_set,
>       |                         ^~~~~~~~~~~~~~~~~
> /tmp/next/build/fs/smb/client/cifsfs.c:1270:18: error: incompatible funct=
ion pointer types initializing 'int (*)(const struct mnt_idmap *, struct de=
ntry *, struct file_kattr *)' with an expression of type 'int (struct mnt_i=
dmap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-poi=
nter-types]
>  1270 |         .fileattr_set =3D cifs_fileattr_set,
>       |                         ^~~~~~~~~~~~~~~~~
> 2 errors generated.
> make[6]: *** [/tmp/next/build/scripts/Makefile.build:290: fs/smb/client/c=
ifsfs.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> make[5]: *** [/tmp/next/build/scripts/Makefile.build:551: fs/smb/client] =
Error 2
> make[5]: *** Waiting for unfinished jobs....
> /tmp/next/build/fs/ntfs/namei.c:793:40: error: passing 'const struct mnt_=
idmap *' to parameter of type 'struct mnt_idmap *' discards qualifiers [-We=
rror,-Wincompatible-pointer-types-discards-qualifiers]
>   793 |                 stream_vi =3D ntfs_create_named_stream(idmap, dir=
, base_name,
>       |                                                      ^~~~~
> /tmp/next/build/fs/ntfs/stream.h:35:58: note: passing argument to paramet=
er 'idmap' here
>    35 | struct inode *ntfs_create_named_stream(struct mnt_idmap *idmap,
>       |                                                          ^
> 1 error generated.
>
>
> Caused by the constification series for mnt_idmap interacting with:
>
>    2de2cdd9cc08f (ntfs: add pathname access for named streams)
>    121e0c35720b2 (smb: client: implement fileattr_set for compression fla=
gs)
>
> from the cifs and ntfs trees.  I have applied the fixup below and can
> carry as needed.
>
> From 6b75090639b332f5fa52a558edbba295d8bb42fc Mon Sep 17 00:00:00 2001
> From: Mark Brown <broonie@kernel.org>
> Date: Mon, 12 Oct 2026 13:55:24 +0100
> Subject: [PATCH] cifs: Fix semantic conflict with const mnt_idmap
>
> /tmp/next/build/fs/smb/client/cifsfs.c:1258:18: error: incompatible funct=
ion pointer types initializing 'int (*)(const struct mnt_idmap *, struct de=
ntry *, struct file_kattr *)' with an expression of type 'int (struct mnt_i=
dmap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-poi=
nter-types]
>  1258 |         .fileattr_set =3D cifs_fileattr_set,
>       |                         ^~~~~~~~~~~~~~~~~
> /tmp/next/build/fs/smb/client/cifsfs.c:1270:18: error: incompatible funct=
ion pointer types initializing 'int (*)(const struct mnt_idmap *, struct de=
ntry *, struct file_kattr *)' with an expression of type 'int (struct mnt_i=
dmap *, struct dentry *, struct file_kattr *)' [-Wincompatible-function-poi=
nter-types]
>  1270 |         .fileattr_set =3D cifs_fileattr_set,
>       |                         ^~~~~~~~~~~~~~~~~
> 2 errors generated.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  fs/ntfs/named_stream.c | 6 +++---
>  fs/ntfs/stream.h       | 2 +-
>  fs/smb/client/cifsfs.h | 2 +-
>  fs/smb/client/ioctl.c  | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ntfs/named_stream.c b/fs/ntfs/named_stream.c
> index d74bebf90966b..95a3c05f98211 100644
> --- a/fs/ntfs/named_stream.c
> +++ b/fs/ntfs/named_stream.c
> @@ -553,7 +553,7 @@ int ntfs_stream_path_names(struct ntfs_volume *vol,
>   *
>   * Return: Referenced stream inode on success, or ERR_PTR() on failure.
>   */
> -struct inode *ntfs_create_named_stream(struct mnt_idmap *idmap,
> +struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
>                 struct inode *dir, __le16 *base_name, int base_len,
>                 __le16 *stream_name, int stream_len)
>  {
> @@ -988,13 +988,13 @@ static ssize_t ntfs_stream_listxattr(struct dentry =
*dentry, char *buffer,
>  }
>
>  #ifdef CONFIG_NTFS_FS_POSIX_ACL
> -static struct posix_acl *ntfs_stream_get_acl(struct mnt_idmap *idmap,
> +static struct posix_acl *ntfs_stream_get_acl(const struct mnt_idmap *idm=
ap,
>                 struct dentry *dentry, int type)
>  {
>         return ERR_PTR(-EOPNOTSUPP);
>  }
>
> -static int ntfs_stream_set_acl(struct mnt_idmap *idmap,
> +static int ntfs_stream_set_acl(const struct mnt_idmap *idmap,
>                 struct dentry *dentry, struct posix_acl *acl, int type)
>  {
>         return -EOPNOTSUPP;
> diff --git a/fs/ntfs/stream.h b/fs/ntfs/stream.h
> index 5cbf6e8f6b681..76b6c9cca5cc0 100644
> --- a/fs/ntfs/stream.h
> +++ b/fs/ntfs/stream.h
> @@ -32,7 +32,7 @@ struct inode *ntfs_stream_lookup_inode_by_name(struct i=
node *dir,
>                 __le16 *name, int name_len);
>  struct dentry *ntfs_lookup_stream(struct inode *dir, struct dentry *dent=
ry,
>                 const struct ntfs_stream_path *path);
> -struct inode *ntfs_create_named_stream(struct mnt_idmap *idmap,
> +struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
>                 struct inode *dir, __le16 *base_name, int base_len,
>                 __le16 *stream_name, int stream_len);
>  int ntfs_unlink_named_stream(struct inode *dir, struct dentry *dentry);
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index 7600467babb67..e54d3798eb2f7 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -91,7 +91,7 @@ extern const struct inode_operations cifs_namespace_ino=
de_operations;
>
>  struct file_kattr;
>  int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
> -int cifs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
> +int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dent=
ry,
>                       struct file_kattr *fa);
>
>
> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> index af4664f5b1202..bb8808289a468 100644
> --- a/fs/smb/client/ioctl.c
> +++ b/fs/smb/client/ioctl.c
> @@ -181,7 +181,7 @@ static int cifs_set_compression(unsigned int xid, str=
uct dentry *dentry,
>                                             compression_state);
>  }
>
> -int cifs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
> +int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dent=
ry,
>                       struct file_kattr *fa)
>  {
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry);
> --
> 2.47.3
>
