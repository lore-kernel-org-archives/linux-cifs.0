Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1607B34BA5A
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 21:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776978191; cv=pass; b=gb8jmFtlO71mR/m+okQoD73/nzLs2BlCpv52zJu85Li83dOGU8q0Le0y1rrO+B3A3GTe/myTWa9R7HHkW5cM0AUlX/2rQFtZn1N1EUhfy2E1o43keoBw1BWUji2/SHDJ0blLi1K499aq3EbPU8fRoCH4x6lTL3yLkpsqZodrbqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776978191; c=relaxed/simple;
	bh=xhEH603J8v85yHWTGq8ZnN7Uus4HM3riSO2QoNgy+fs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MfbrZT47ZvPN9hvTbUyLuBFYyZh3Ev8C1qj1AhK8nVe1MwMZkAQBHZ7+94C5Kfe2tiZXYTT9Yl4Q95mg0hH59sfmQVEECZIkwIth1VPKlIF2UzGk2znGSEK7xI8WVCsKjH8wsk3N2qzSkE+UuwcOLoYmykmMUSqCNQd5o0lEBrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rDvAu1SN; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rDvAu1SN"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8acb7f2586bso74626636d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 14:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776978188; cv=none;
        d=google.com; s=arc-20240605;
        b=dUO8t0+0GgNvbWXdKwOaZhqQk+KlariZAP8IrKrt2nYw1y1TkSGl233DEdliKW7to0
         ZFqf/cyPniV87/T44VUybdWfdEYG7dIgTsYS6KbADs/ynva+ih1DPNp/im3X897pKPGP
         uJjY0g7QlecFxLSsLzM/ih3mzZNLq5Pwb2BM4NuXWxoivnCSCXmRZ8RTR+v6nz5b7LAw
         NPW7rt1l31gabSGwIwRempp1Hdj0a87pe0Nnxg9RTttBQl1Udw3VibWSosDh+cZ4wJSd
         sXQPjHfBo9nIXvUOdS4d1cabkTrG0Y+epThP1ANHBU+bilJzmw6LeEqyjg7zo40epg0y
         w7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PB9D2kfgkJFOe3p8pXvyrrOYHUrSUtT15eUJWPkJgQk=;
        fh=CVx+ncaNKCiPm2zcnoziVehPm9UrtAQNg+ymCkdgz5E=;
        b=fWGp2wvC2zDlDTHvZQQZ1XDiVORa6vt71b+oZMRibIXoE/9zwJ6Ji4cVoF19a2ucqF
         vEzH9XTfF+SyXkB8PYusqOhykqJqHbL52JqDYhEPt5+RTvQW0snpho8mbzEPcTANIIr6
         Fl+HKz4gSLlNhOt9EpOXu3symkrYK1gfkpX7/8NyKgkIoStRQlu/C2Fi4vReGbn2dQfR
         igjt95CFyIW1IkT/35qQAlxKwGNyHnD7S5zIf2VxfaB8aEZzjzRH+NPd77VMwTksg/dQ
         p8CqsvlEntNNsA56NqJX8fgdRk8wSgzOh4txMeQLcm4Er07YOYOIf8dERRz3fe1NMs2e
         7thQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776978188; x=1777582988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PB9D2kfgkJFOe3p8pXvyrrOYHUrSUtT15eUJWPkJgQk=;
        b=rDvAu1SNNCNFOtPGGZA1Ilm0Le5RC3HqJ0wXokdqmzOLVNi8lHw7GMMZu9w9TKLwL2
         97WG5/8zvZHB8yvJKvWest8upLdKisDZ7H05Ka5/vdYNhsrnM3D9ri/hCBGJJWSYMJ6A
         4aV5pN8ZpW+OvUAVyQXtCxyz+lKlPQ3JSP3K8P+ESur67eGHrRIzYUzsXwVHkCd6yj2/
         ctzXdJjsBXDJTbKbibVy0FNHQzCBCqmL0wFBtBXUGYA9rjTxlgcuc+yyfB6WixhGhej1
         k1hqtskE52BY3YNgHMeEYZ4kRq1QB4GqeTj/Zh+a80rccrsXdmSCnU6wEvXr81Y4Mp/o
         /xVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776978188; x=1777582988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PB9D2kfgkJFOe3p8pXvyrrOYHUrSUtT15eUJWPkJgQk=;
        b=bj+lTqf0tF1UBryxlP3BktpOIqU08uRYAOey6qgrTFLsyFTRZwxxy2uszZwiKDvx6U
         ttDWz90y4NhTAay6zGF+KBAvABux36MLxfNCZBag1MT3j4vraijB83nz46e6rJIkbNn+
         ecw2y6kHpi9QDQFoAKz0kScMzXGMls0YTs8ln104PSLfqYVGnmFAd/T5Bxm53k2AlZcI
         pUsftJZGCUfAn4DhljyQOw9JQGlih5oaJ9r1ulG/v2LkWy9b7WSTRgMPCzAq7hEIylYL
         aPldXiy9XSk/rIQU9LYc58DVFdLJ4rIeOaubWK4pBFo9BzdA3ZJeqBTJF55vUctLS4G+
         UO1g==
X-Forwarded-Encrypted: i=1; AFNElJ+wfmx4PVKBJEvzFVnnWlZqaBTPtc/AmRyeuFkrzNJxR/q5My88Yr5L/AE7FjXUAWMhTqZHKS/twGRJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwaZbpHPbYJ/yDOeU10fD42LlYsxUwe44UqRmsQYvXeaY9Q+4bf
	ycEcl44mfj4KkAccroO6pFIExV4vOIi87ia+/pS9lAsJ6F7hEYsReBVHVpCA41OgA1pKXNWuBJb
	+t1oWxIYUBtJCgUa22sfjuFzhJvcyOQI=
X-Gm-Gg: AeBDieuuLJiNxYqCZiCrYNoL5rTwfopVgwNiPBt2xkxUa+u7n8UdxQbNUP2N0XPJ3xl
	RrnwlsZyQZf+Opf2h8JttWtloVmCgo52rAQYpAd1vM1gOfRjm/RTOqTwp6dxV+IaFalj75hoT7s
	bqPvYjk13m49opxifLcmuUzusioCHVM+NyxoxmNBe66CyN9zqUeORJouYo6qSvjflFSJjupgeid
	YDvn6EHXgU/vGUjl3OVefSP5e76MvVjfexGwyaH/zToo64MmkvVGIhVd7ui8qkQZJ8EfWY2iLpG
	+2ld2Ic9s6Gu9SN1ml+5oBAvlGKy2o6JgvkNQHEDAm5fVo98EYGLes/44Jm8PRKao1yxdy6IOAr
	Y8msZzxepFf7jiTX9DosrGIMgvsb/sObYuS921ftwld6o+gO4hGdhza61Ht3NoGh8o2SMgQuhd/
	xkbv4GyceI+nvJxcEYD+Cek6OEHl2kWAU=
X-Received: by 2002:ad4:5d65:0:b0:8ae:6282:df2e with SMTP id
 6a1803df08f44-8b02822456emr461252066d6.44.1776978187970; Thu, 23 Apr 2026
 14:03:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260423-case-sensitivity-v10-0-c385d674a6cf@oracle.com> <20260423-case-sensitivity-v10-10-c385d674a6cf@oracle.com>
In-Reply-To: <20260423-case-sensitivity-v10-10-c385d674a6cf@oracle.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Apr 2026 16:02:56 -0500
X-Gm-Features: AQROBzDF43-id-Qgk6rRbL0HPyUPTg1w8GYo4-J0uBb2d6IfD5ElWAtE-TtbFxA
Message-ID: <CAH2r5mu1Wg_9tZCjei-xF357UjKR+h6jQr9zey39v59rx9quZQ@mail.gmail.com>
Subject: Re: [PATCH v10 10/17] cifs: Implement fileattr_get for case sensitivity
To: Chuck Lever <cel@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, trondmy@kernel.org, 
	anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, hansg@kernel.org, 
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Should this also be checking if the SMB3.1.1 Linux Extensions or SMB
POSIX Extensions are negotiated (ie the server supports case
sensitivity)?

On Thu, Apr 23, 2026 at 8:20=E2=80=AFAM Chuck Lever <cel@kernel.org> wrote:
>
> From: Chuck Lever <chuck.lever@oracle.com>
>
> Upper layers such as NFSD need a way to query whether a filesystem
> handles filenames in a case-sensitive manner. Report CIFS/SMB case
> handling behavior via the FS_XFLAG_CASEFOLD flag.
>
> CIFS servers (typically Windows or Samba) are usually case-insensitive
> but case-preserving, meaning they ignore case during lookups but store
> filenames exactly as provided.
>
> The implementation reports case sensitivity based on the nocase mount
> option, which reflects whether the client expects the server to perform
> case-insensitive comparisons. When nocase is set, the mount is reported
> as case-insensitive.
>
> The callback is registered in all three inode_operations structures
> (directory, file, and symlink) to ensure consistent reporting across
> all inode types.
>
> Acked-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/smb/client/cifsfs.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 2025739f070a..9b70ffa3e01d 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -30,6 +30,7 @@
>  #include <linux/xattr.h>
>  #include <linux/mm.h>
>  #include <linux/key-type.h>
> +#include <linux/fileattr.h>
>  #include <uapi/linux/magic.h>
>  #include <net/ipv6.h>
>  #include "cifsfs.h"
> @@ -1199,6 +1200,22 @@ struct file_system_type smb3_fs_type =3D {
>  MODULE_ALIAS_FS("smb3");
>  MODULE_ALIAS("smb3");
>
> +static int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *f=
a)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb);
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +
> +       /*
> +        * The nocase mount option installs case-insensitive dentry
> +        * operations on this superblock. SMB preserves case on the
> +        * wire and at rest, so the mount matches FS_XFLAG_CASEFOLD
> +        * semantics: case-folded lookup, verbatim storage.
> +        */
> +       if (tcon->nocase)
> +               fa->fsx_xflags |=3D FS_XFLAG_CASEFOLD;
> +       return 0;
> +}
> +
>  const struct inode_operations cifs_dir_inode_ops =3D {
>         .create =3D cifs_create,
>         .atomic_open =3D cifs_atomic_open,
> @@ -1217,6 +1234,7 @@ const struct inode_operations cifs_dir_inode_ops =
=3D {
>         .listxattr =3D cifs_listxattr,
>         .get_acl =3D cifs_get_acl,
>         .set_acl =3D cifs_set_acl,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  const struct inode_operations cifs_file_inode_ops =3D {
> @@ -1227,6 +1245,7 @@ const struct inode_operations cifs_file_inode_ops =
=3D {
>         .fiemap =3D cifs_fiemap,
>         .get_acl =3D cifs_get_acl,
>         .set_acl =3D cifs_set_acl,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  const char *cifs_get_link(struct dentry *dentry, struct inode *inode,
> @@ -1261,6 +1280,7 @@ const struct inode_operations cifs_symlink_inode_op=
s =3D {
>         .setattr =3D cifs_setattr,
>         .permission =3D cifs_permission,
>         .listxattr =3D cifs_listxattr,
> +       .fileattr_get =3D cifs_fileattr_get,
>  };
>
>  /*
>
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
