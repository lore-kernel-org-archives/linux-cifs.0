Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859828;
	b=sueLn7726rdVH+y0Xus/0iEpj0G8z5ZCCLmvJPtxaDgUeaC6gsQRkQYMhezImBJEGq0L
	 AkvItmWrYskHoDpX+6FPBbtPezw/VkN/TB+y5IkeaoA2pJuHc8VzPFGSIb6NQazDdOgex
	 NKmlI9zm0M/8V2AvKgTWYoqON00DZpZ3WyRWEc7nAcSNldbqEESHm7Yjla9JwsKZ/wxn7
	 IRWqkfo5mrGFE5DtGQBKSPpxpTIHV+HZ2FFQJsCichzg9rZaMsS6gSlZ7sZsa2C+JmbPw
	 2k2VH27uYkG7INkHBhH38NlAD5KpxOQPmz0y6IZpkUsyH0Q/QGjUkpKOzVQezkmBvDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859828;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
	b=nBRMI1TltioJNxFUBcppz8gAPSL2jMJprTe3fUY1bNXkqymlCjY80+ytf3wZHmIzq4/T
	 G59d1whK4O9WEIRWF1TWRJODg7Zho6ZM2Wrsi/fP1L4BiWdSFirSDUrtMW9F9a6OdlTcb
	 11X3I6wrs/l5j0avVXlOmq708AZy5LUpy19g3+8wdQIqD5XNh4OxjKwAN5ODihSFNy/8q
	 WBnbOx5l7mjEx9mHNHtW/P996DqXNJ9tmKXlbejzFYDIKdesSBXwAjGUTG0Kz6fLU4rth
	 H0e6SgCSdqmoVmGmGlrq0PykkymLcbQq9iiSMoj6iUyNeMb2w5gKV7LflEBs65LgCtQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WOxtFWMy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBE4606A8AC
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 20:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBBE4606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WOxtFWMy
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so4809377a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:10:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859823; cv=none;
        d=google.com; s=arc-20260327;
        b=Ymt1nPFLHJYBPjzXb/JbwidpfYFqBoYZi6h7IYWo+aXcmZIcDMLj6b+P3Sa1jwl6zW
         HW9LKIZBQz4qWxUuE0xvLN1ecR8kDD2jWfOQWCjgGA4cK6w6qxPBXy+3hPewDyTv3+Nb
         eyqfPJuOzyK+WEQ3GboT87/ArT1jXjBDYi8DMuaosSUUXa76IDhV7rWgigAzIMnm0RNv
         WvAyc0Q6QvPWK6HB9BSKKWwu6Rm3OzZzayhnT+4gcHuXHCuGYpuo3jz8qTDdvbqOuy6b
         I1z99PUa/ohJ0rmVWci6yBaffZq4ELbxrUEhBMQE80QE08dNdYg8f7gAUdEdv/TSRDB8
         zqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
        fh=yE3jK+YWHmWy+XERCnA2oPcBQsoGG5QOx+I3h9r6mYU=;
        b=h9G2gUtntxDc8WKA6VfHWh+vM+YU+I76aJTiYY/xvBgaD0dmuDyrTUB7eBxca0udFJ
         nrLfj4a7RdkM1sxqWcHxP4RavXXKebEOgjq8/I8/zryfs55JnqCRsQ2P0ibGPA8JqSAm
         qRWcZiwCC9Xjjyz3SkevmAbYKLlJXTv8PknGz8jhBsc/bOjINO5asol78wEBE+PUOldB
         zTo+QNT8J7pRBPlchRM/LP3Un8IadZdHVwLmUsE6L2RcJlHXhUf9OznSAU3TiR+Nmbwf
         khSvD/NeEFyDMIv5izRYL2l0193/5epd3ihpwj/bqbSrKeVGOhb0miaGURSd9+fKmfJZ
         C0rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859823; x=1795464623; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
        b=WOxtFWMyKSPKodrqO+mGvFaJ85nCUDAL1UbckpoCKdZZSDr6KLP1X3+k/+dUDOnHsz
         Liv0XREDYRmthCicNGPv20LYm7ELc2RuwqA4Qa7jKGzmBys8KG0igoBS5BLir3B/I5Oi
         /bgRuIn+89jEfgoRFFsF4kxmgi+DuU8n5fJ3Rg4LrQkfy2rePKI3IipY7ZyCU5oGLJVq
         PSha1QRCep6BbWSr4yXUqyOX3gDVTapQFi10/X2ht30305k3ESrBvJ7NkpVVSXa6XAsH
         nbsd+tFu6FNI6TlqkTQduwEBjohtbx6EC8CpwweOUWlftKpCXtgRzKyhkQ87oy+TaMVf
         TxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859823; x=1795464623;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ysm1ObvRHi8QkErB3cHCKWgyx+Xhy7Q4KWF6rBHGU1o=;
        b=g5RMem9u9D9HaE6fM3S71tz916GL5pY4QWX4MQAAS6sz7UAw4iXgXwRidBk7UPD9C9
         yBa7pwkRMBMqOlb84I8qrSmxxvhg62DC8Pe5x0nByxJPSJ9kx5h8EVIMtyyf+Z2UKHJk
         Ziyh7cAnz49MMqsLbSSzgJPDGYp99Uat6CdbWN41NXIjOtiVgtF5GVx0u7ZYkwbbVJNB
         850UfG8vA/j3BQcevC8Ried6DnGdA4Hzf6s+aijepdE2vsdPjVqnZCH+ssZpNxbSAV/y
         FDvokaejUR4NymNqaRUddpDVx4itEoQTFHTEygxXn/riIMN/QkssLlmN//2g/R1+a4Pu
         kaJQ==
X-Forwarded-Encrypted: i=1; AL+hErGnJvZL+qzgmSpp7tZjqsCOfZp93bJw7iNSo0SXjQLy4fn8l3XOOZwngOG4Y9db1/H9x15STtEeRD08@vger.kernel.org
X-Gm-Message-State: APuU4Z9r6fdPlanvZBbVEyKu04Eh0hSFpYDF1d7FR3QyhOhuAFV0GQCA
	NqSHxdSfQAfHQYykhdrLVm3qO22kfEhsJh/a5OkfcEM42BQQNNwpm2c3e6S2/KxqAijAj4Oyjcn
	kanb0cqA1tJSV+7p+xZFhuoZLEZ3p03E=
X-Gm-Gg: AYBFou05navkL8em9ZNuup0T1NyunbDRQup8Fx9odKI8HtBmsOe4+imgVJkgZU8euwt
	Ssrx/A2LtFzXWm9nM29j2rHpdjYkhbgMHVDfKDycK72AqLEyprcI1wIKeVibWATMISaSxTyehVg
	gMfIaB1XVltmxz5jBQt/HQvjW9eLu83kDVeJY7UWhZeHUq7p3aDSdAkvSYNNeUjluB7mV1pRsFn
	1l70oP5VcOk6+0iO4slve0cSzVnpiv+wC2CbdTzSxRm7Z+TcvrUUJzX8xvDGcf2mMZ/dC9cUML0
	K98nomYgip/w7oLbtjfZdkkDOLUOD4EeGIOZSY9qSBz3XTI5SJZgPIfEW886EKzuXh58UJycBKz
	iKcFFGtYYRJuQ4WjmNUOEFZyr/49w1TgoZE9jCJHodvBNp5g1kqwd+nUaP1ka3xC0bvVprQ==
X-Received: by 2002:a17:907:802:b0:c29:5172:6151 with SMTP id
 a640c23a62f3a-c5096415a37mr947928266b.45.1794859823120; Mon, 16 Nov 2026
 12:10:23 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-2-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-2-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 21:10:11 +0100
X-Gm-Features: AclHuK8HNkwAKAuOh7lYPiqcrySU8WxcW1gHG_-7Ti6IFMhOniGdmSp4CPwzuwg
Message-ID: <CAOQ4uxi+50NU8qzg+Owvr8gFZ4vYF5FqWg4Hr9vB6ONUpPsFwg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/10] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Add provenance time (ptime), indicating the time when a file or
> directory was created. This is user-settable via file_setattr() and
> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>
> The semantics of when to preserve this new timestamp are the same as
> mtime, the idea being that there is a correspondence like this:
>
> ctime <-> btime
> mtime <-> ptime
>
> so every operation (copying, moving, ...) that currently preserves mtime
> should also preserve ptime.
>
> Also add fa_xflags_mask to struct file_attr (and equivalent

That is a very big "Also" part
This is a significant UAPI change that needs to be delivered and
explained with a patch on its own.

> fsx_xflags_mask to struct file_kattr) to let the filesystems advertise
> their support for specific xflags and users advertise what they want to
> change, behaving like statx.stx_attributes_mask:
> - on GET (file_getattr): each filesystem fills the mask according to
>   their supported xflags, e.g. FS_XFLAG_PTIME or FS_XFLAG_COWEXTSIZE,
>   and provides the values in the corresponding struct fields;
> - on SET (file_setattr): userspace fills the mask according to which
>   xflags it wants to change, VFS validates this and preserves xflags
>   that were not specified in the mask;
> - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
>   compatibility with older programs.
>
> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> xflags and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> validate that the xflags passed in xflags and xflags_mask fields are
> valid.
>
> Finally, add the missing FS_XFLAG_PROJID flag, to allow userspace to set
> the projid using file_[sg]etattr().

This part also belongs with the xflags_mask patch

>
> [ This is a re-implementation of the initial patch[1] by Sean Smith
>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
>   utimensat() ]
>
> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmai=
l.com
> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c            | 75 +++++++++++++++++++++++++++++++++++++--
>  fs/stat.c                 |  2 ++
>  include/linux/fileattr.h  |  6 ++++
>  include/linux/stat.h      |  1 +
>  include/uapi/linux/fs.h   |  9 ++++-
>  include/uapi/linux/stat.h |  7 +++-
>  6 files changed, 95 insertions(+), 5 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..12610fb6a751 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,14 +102,23 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       /*
> +        * fsx_xflags_mask contains only flags added after the
> +        * file_[gs]etattr() API, so we need to tell userspace the filesy=
stem
> +        * actually supports all legacy and new advertised flags
> +        */
> +       __u32 mask =3D (FS_XFLAGS_MASK | fa->fsx_xflags_mask) &
> +                    FS_FILE_ATTR_XFLAGS_MASK;
>
>         memset(fattr, 0, sizeof(struct file_attr));
>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> +       fattr->fa_xflags_mask =3D mask;
>         fattr->fa_extsize =3D fa->fsx_extsize;
>         fattr->fa_nextents =3D fa->fsx_nextents;
>         fattr->fa_projid =3D fa->fsx_projid;
>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>  }
>
>  /**
> @@ -141,15 +150,23 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>                                  struct file_kattr *fa)
>  {
> -       __u64 mask =3D FS_XFLAGS_MASK;
> +       __u64 mask =3D fattr->fa_xflags_mask ?: FS_XFLAGS_MASK;
> +
> +       if (fattr->fa_xflags_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
> +               return -EINVAL;
>
>         if (fattr->fa_xflags & ~mask)
>                 return -EINVAL;
>
>         fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MASK=
);
> +       fa->fsx_xflags_mask =3D fattr->fa_xflags_mask;
>         fa->fsx_extsize =3D fattr->fa_extsize;
>         fa->fsx_projid =3D fattr->fa_projid;
>         fa->fsx_cowextsize =3D fattr->fa_cowextsize;
> +       if (fattr->fa_xflags_mask & FS_XFLAG_PTIME) {
> +               fa->fsx_ptime.tv_sec =3D fattr->fa_ptime_sec;
> +               fa->fsx_ptime.tv_nsec =3D fattr->fa_ptime_nsec;
> +       }
>
>         return 0;
>  }
> @@ -232,6 +249,23 @@ static int fileattr_set_prepare(struct inode *inode,
>             !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>                 return -EINVAL;
>
> +       if (fa->fsx_xflags_mask & FS_XFLAG_PTIME) {
> +               if (!(old_ma->fsx_xflags_mask & FS_XFLAG_PTIME))
> +                       return -EOPNOTSUPP;
> +
> +               if (!(fa->fsx_xflags & FS_XFLAG_PTIME))
> +                       return -EINVAL;
> +
> +               if ((unsigned long)fa->fsx_ptime.tv_nsec >=3D NSEC_PER_SE=
C)
> +                       return -EINVAL;
> +
> +               fa->fsx_ptime =3D timestamp_truncate(fa->fsx_ptime, inode=
);
> +
> +               if (!timespec64_equal(&old_ma->fsx_ptime, &fa->fsx_ptime)=
 &&
> +                   (fa->flags & old_ma->flags) & (FS_APPEND_FL | FS_IMMU=
TABLE_FL))
> +                       return -EPERM;

I don't know what this is but it looks strange.


> +       }
> +
>         /*
>          * It is only valid to set the DAX flag on regular files and
>          * directories on filesystems.
> @@ -288,13 +322,41 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap,=
 struct dentry *dentry,
>         if (!err) {
>                 /* initialize missing bits from old_ma */
>                 if (fa->flags_valid) {
> -                       fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLAG=
_COMMON;
> +                       /* FS_IOC_SETFLAGS */
> +                       fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLAG=
S_MASK) &
> +                                         ~FS_XFLAG_COMMON;
>                         fa->fsx_extsize =3D old_ma.fsx_extsize;
>                         fa->fsx_nextents =3D old_ma.fsx_nextents;
>                         fa->fsx_projid =3D old_ma.fsx_projid;
>                         fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
> +                       fa->fsx_ptime =3D old_ma.fsx_ptime;
>                 } else {
> +                       /*
> +                        * Preserve unmasked xflags when running file_set=
attr()
> +                        * with a mask, which doesn't need a read-modify-=
write
> +                        * so these attributes would be set to 0.
> +                        *
> +                        * With FS_IOC_FSSETXATTR or mask =3D=3D 0 (legac=
y mode)
> +                        * this is not needed as userspace does
> +                        * read-modify-write already.
> +                        */
> +                       if (fa->fsx_xflags_mask) {
> +                               fa->fsx_xflags |=3D old_ma.fsx_xflags &
> +                                                 ~fa->fsx_xflags_mask;
> +                               fileattr_fill_xflags(fa, fa->fsx_xflags &
> +                                                    ~FS_XFLAG_RDONLY_MAS=
K);
> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_EXTS=
IZE))
> +                                       fa->fsx_extsize =3D old_ma.fsx_ex=
tsize;
> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_PROJ=
ID))
> +                                       fa->fsx_projid =3D old_ma.fsx_pro=
jid;
> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_COWE=
XTSIZE))
> +                                       fa->fsx_cowextsize =3D old_ma.fsx=
_cowextsize;
> +                       }
>                         fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
> +
> +                       /* xflags not present in fsxattr */
> +                       if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
> +                               fa->fsx_ptime =3D old_ma.fsx_ptime;
>                 }
>

This whole flags/xflags duality needs a closer look
This looks a bit too complicated right now.

I don't have time to do the full review so wanted to give you the
main feedback first.

I'll try to get to it this week.

Thanks,
Amir.
