Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB77230B53C
	for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777063080; cv=pass; b=jeV6m/y2LozS2srf86xynhqE2j2b1Gcwzr3yH8BS17STDB+XAAJRrP3lTqVjNIKAb5lzarVoPrKvfCpDFce2sAEkmYYqGS4z20pC6uSJn/6/R2wBAabhsOJ9f2RdU5xWmqTJVRJu0pnXJ/jb18dF6bMBJ9UG5y1fTTq0nNer5oU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777063080; c=relaxed/simple;
	bh=WEi1IyVTSJSMWo3lSvBJY7SPqfqbMiDWeId+3hTeMbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=G0FQWQwQE4Pwvp/mPszTslUDxYuzKnwA8FOm1NvXtRkp200Y+RJ24nmX4y2dFXn3s/HMajOozRRS1SUX8BCCCC1I5sy/rJmC1gRTyoXP4Ze2smiA6UEevNJQNmnksbh44dqYUkafr758JgMtv1U/fvZWBvZQdjExL/SbMF8kkc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYeGbIhD; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYeGbIhD"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89fc349b5ceso117202456d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 13:37:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777063078; cv=none;
        d=google.com; s=arc-20240605;
        b=O3NC5SvSu21yQedU0+cH4ep6HKZmaldD4vhywRLWeoM9/rLJy0EcKIK3dYXGCk98Cp
         mAWmjeS1R7SYeJQ3WxXBOlZMQ1OBzVQwO9D1uWTqpz7vMPvSwJeJFMdS244I3OCctzS0
         daH5A1HyUxhqP7HRrtnxyGNPpUnMfXNxTWEOgE74mN46LGjXtUeEp/pdNAP4mhc4ruOk
         b8bdwTfOb0Ew2Cx0gteHzUIvvZL5qmLfCmIWAPFnV0YwiM+jYfJS7asG2GXMT4wkk/5o
         QfI+JfBEnDPWc5oqhUfCfpdVcAT4HjdAuVcQgHElUY1SrG/0Kpj35WMDEpUmGzyovkR8
         azBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xr13CaE/4HKRaTP0rlQj5Re8CRzk22i2iP2P86qR84I=;
        fh=oqvqryoj0hTQIMkchDbtvb54Y1JuyVVDfLtiX0FTFu4=;
        b=eNEo8jbSy17Hh87wViyyQkoQtChtTPt8rI2HsehRjBNsZyGIIU6daSo9+6R+ppR4++
         GYhlvGFwU++OlnBcv8Y6kNSiMxpdNDnb2/uwvZ3FWsckf/HvN+93g4BXqNenXIbtf0Mw
         wXQQNDDoal3SM/vsRhMyxDmncYrRbpuq9+CrWrDWBNg5IM8oq9Mn6iksopFTjPbX1GhW
         xY4NtPL/+/ZetF4xlx0B2zLemwQX4CqZX/4mg5glqmYq5qIxraxMpvmw9vPJVUYUNCs6
         WIuHMsznTs6vgJVdE59/QBkOYsAVZO9EAXVxEdgz1zE+GZK4Hl5FDcozcx1AgYZnfyE+
         AuvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777063078; x=1777667878; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xr13CaE/4HKRaTP0rlQj5Re8CRzk22i2iP2P86qR84I=;
        b=KYeGbIhDMbDQEFscqH+1K6J70NxAoTtj1Wwhj/6XICBVYaGpl2c+8DLnRgiwnta4SZ
         kTiIptrb/ZpZcgIwhS5L+ptAmpbxuIKTtVGQTuU/tjWIOLuu2+R/M9rQ8nvj1sV1bNQj
         JpI5MUr7MQufh3EpA4xDPcnRh6sxUybAQOBeNrfpkvpLiINBN/GM1Kh4BwWWuLul/exi
         wAMvAvH07ybrMoumpgPwJHacLOKhEqmHcvqcQBX1dNv9nAsoZ8oqdX4NPX2mzNR+sGps
         /ejVT9xrKTZGlnYMBkemBWnkKIxJR7GvYUQhKGWHe7/J7y0OQxPbHNNm71EMT2wSyxcx
         6cHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777063078; x=1777667878;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xr13CaE/4HKRaTP0rlQj5Re8CRzk22i2iP2P86qR84I=;
        b=B9CX/7ZX9+/RW1USoJac5TtskWtT0kvHAEMnXJwiVytxq0J7vrfctR/r/QDO4iaG3r
         bSPVTISrk/6LuuowfvjcK3hmJ9K/Gp4IviATV+i4JRzg/9OWU4XUmMLdPGpqrmOMLERo
         Xdy2GJl0sHWtHdTM+fYpaZGz4JLaRzPPLGH6FbvH5vKYPgAlkWs/YE8ap2FUbKxlZvqb
         lXuU8TtrttYhuan2zZml5dqcEwXF81P/heMKcOOaS6+xp7doYZm1dDiEOb3JkwNIKBvX
         35j8dpz3M1UxzrtYd6yFSbDWOIDcK34NNUST0hjtD309q3BZQk+HTJZ8xOS6lRQA64RA
         fd3Q==
X-Forwarded-Encrypted: i=1; AFNElJ+R/Xt98Vc6RGFBx9inUUR7c1WD+9wh9QeP4Mn43syi8uQ2nrXo+EcQamHoPybjpFdhZ9XcWO6IzepG@vger.kernel.org
X-Gm-Message-State: AOJu0YyEsXvynK6hp2MgXnUoqXPdbZJXpgzWnES3HnlKpx7QyGojpFGo
	YkNEIhHSG/hSxA04J32MmKiigTNpdUdKUAMLL7CVPwAI7UHzPQbpXnZzBtRCMskPo0EteyhxKlJ
	7SxkDdA6brMRa1+8eW64NvtzIYXA0YZw=
X-Gm-Gg: AeBDieucuoNcbfYBh29G1FgUP3ZS/B8adXqz000yaLBPqpXT1jAKTzy92eWjk4z0ZQn
	cA+DTBB0ZomD3eJ2hVKqJ7ZD0OC1Q6lDx7XNaf6HfUEAVVofaD+rkp1qQaZiOYdFclMHHl0HrdV
	oa1ntcUE6q2GrKDTUFx4uW/UsTMqRja7G7W9Un5LHv3U9xhBipC3up+yjUO3p3el2JINhKgnWFT
	KQedFy4X8UXIT0J9mk49wMKps2Kd+8/54rcC8SxaAcOQWB8n+mfgQeCbFjaTH8/Q0yi3KAbfXqx
	eMDCZfFPHui/jZSO5/0b2Z2tCY5QKOP0E6NZnlE5WlRJv8biFU1MgAv6gQCa99BYgv23HZI8dt4
	ELn9FEpBf7RNDfISC/1dWwom/gN2G3yFiQVwloBtuJJqm/EPqAW3RTjrUm3bpRfF/ixktw5f/Mc
	jwYpXrBEcelEH3e8hI2AH3b37bp1WttAJ1
X-Received: by 2002:a05:6214:588e:b0:8b0:2017:958e with SMTP id
 6a1803df08f44-8b02800cb6bmr520436036d6.13.1777063077708; Fri, 24 Apr 2026
 13:37:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260423-case-sensitivity-v10-0-c385d674a6cf@oracle.com> <20260423-case-sensitivity-v10-10-c385d674a6cf@oracle.com>
In-Reply-To: <20260423-case-sensitivity-v10-10-c385d674a6cf@oracle.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Apr 2026 15:37:45 -0500
X-Gm-Features: AQROBzB-0lTRy0XdRF_00F7qjWcYsiEfyHM_qgbK7lfREUt6QweFIgrUE_8q7ec
Message-ID: <CAH2r5mtiF8TsYvDF=wY=GMZWzKvswymbj5fqKk-TPQHAKhb+hQ@mail.gmail.com>
Subject: Re: [PATCH v10 10/17] cifs: Implement fileattr_get for case sensitivity
To: Chuck Lever <cel@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looking at other flags that fileattr_fill_flags() can set would it
make sense to set
FS_IMMUTABLE_FL and FS_APPEND_FL based on the smb ACL in the same new
function cifs_fileattr_get()?
What about about  FS_NOATIME_FL?

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
