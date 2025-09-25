Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77CF2FD1B8
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758815464; cv=none; b=BE1HCbTavsByOByJ4Y1mmLPOv8z5aWQPlnt3+CQTginWXpXfikr46PmGO9qmyBtAfgbEIaUJVG/W8euNfkaIYTX50FUDqUcbktcTkGzvgS39yTUGPb/BpJS20569R822jZpPU6ATWIGoob/FRmwrFrx1rydCAGdxjZo4zQKVVyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758815464; c=relaxed/simple;
	bh=bqup4E+Z4LYVlj/a9cb1gPbIL51orOjXv5Sja43sUbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EdSSMC0Snsam8W2iW17RFMc31g7D86GwSAkvFce45C/93jyeWlrrtZ2ycmpSE1Q2+6JMQik1c4nkqTG1N3FBL39TIUTGFHTotWZdh8xery4TXw3GT/Zty5Tixj8kHBeXJwhJeUlcHS7vZQukAALa9wwfUaI5N0i8xn0qAFzUH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iY7XgZl3; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iY7XgZl3"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62fa0653cd1so1803297a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 08:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758815460; x=1759420260; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8pkBkCfzzGdkuWc/HhosQmhWOM0aTTicipXFn1WFKUs=;
        b=iY7XgZl3CUVbARqjTBzgBZlbHnruBEfqbcILUqCkFf03LMoXHc1VqKP4IZ1j2/t0fi
         FIKoJ8kqortoCrvZvWc3WlqzvO5dOfsgRUygx40+5XbwygOkecx4O+SquB52zRpbWfuo
         RfEdlBQQDkPogGkeg+F7JlAf/jdMmVCLOpGW1QujNbSQuH0uduOnbuIsOSmoNSSy/koL
         63g7jg7eV1RRLL/RkCMrqetIRffD144AAmKTznZVL4gh3fnO0d2Ya3Qgq2Zz025DfXtc
         eGnJQ1SiKAZJtdArrsxcrFLRIM15gKql3d3dT+idetJ++b9cklFnN3x0qb7MX8MMizbY
         Q26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758815460; x=1759420260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pkBkCfzzGdkuWc/HhosQmhWOM0aTTicipXFn1WFKUs=;
        b=cYTps8hxetvhkxhOY5w1JJGWe8S5aZrNQ2po65bXrG/g0yYuLC8uGCGNPIJ3ibwflx
         X+3YHG0lbKq4K6zUAx6DBBmNeLPadTwmbGbhZ1SA9NOFmw2sDp+lNzSzElf+e6WDgABG
         DGbQsagmXLq/k0do6qVfohzQShLe7Wq5kKv1ByI5tgeqTByxogmWMu/t9bJY0oA1qY+f
         RDIZ2pbT3Osa5iQh79lcAUeQo8SuRekD45La5PwFNAXqyxgPdH+AZPtAFXy5A3zsEDvU
         82W3WjqC5UwEsZzAqAH8aGMEWj21Y1AuuGbBhoAYVfp7hhlYy1pnQqrAqHYz47aZwG+j
         PcEw==
X-Forwarded-Encrypted: i=1; AJvYcCWFYVMZtlsb5dSE9UwPoTZY9YN+5jF9wYHIQ7CQ96TA6GZNBaEPhm6ihvzD6OOJW8H1pLmGjxdOF8ob@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4VPIiWHX9abHL2wyi5h2loYtyMdNMtMgAOl0Na8AD41g5AGTu
	oeQZEsPpAdtbplq2k0f6G+r0dxXZ9kF96M5ILhyF41hMw1V39Z/GiSYn9uo3NSQz743vklEjzjv
	5IHBuhAUzzZzySzyR/Zo8Cm+7p7gXugBjFQkX
X-Gm-Gg: ASbGncv1nBAjTNvwW5gwVby/A+JTwK55/p+PgyQ3YAC1bm7KzuX+Mo0SpYFSbnN6Sbf
	SRtwziBpfNgAHClt9aealPIT1akcddT725SWu3r5lGVCTYI5gqvmVFdM3N1LU2o9wb6xm6f4lVQ
	TpkaOQ6VN1jCA1jtI0hteQHOABqCUCeZYNHV9A2lc/G8V7GpLLoq/2844hE0VPx2sbge5fBaI8k
	Vo3BprqX0RUL2ajdwK6nXgTIMYxUiC5Whl6q1qzvg==
X-Google-Smtp-Source: AGHT+IEPELCD3OHR2BGTubqUw5ydVo0EBqdmNaM5DUUzIA4oXmm6t1IFpxRmnv1QnAOHXgoMgCOHn19rV0i1+BCN878=
X-Received: by 2002:a05:6402:5189:b0:628:6fc1:a3f with SMTP id
 4fb4d7f45d1cf-6349fa7e3c0mr3078578a12.17.1758815459987; Thu, 25 Sep 2025
 08:50:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925151140.57548-1-cel@kernel.org>
In-Reply-To: <20250925151140.57548-1-cel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 25 Sep 2025 17:50:48 +0200
X-Gm-Features: AS18NWDi1hkVUuMtcyKFJEsHH4fQmmUb6QosD-2WEc6arB-jdISZEtt1CuTxQwI
Message-ID: <CAOQ4uxj-d87B+L+WgbFgmBQqdrYzrPStyfOKtVfcQ19bOEV6CQ@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Plumb case sensitivity bits into statx
To: Chuck Lever <cel@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Volker Lendecke <Volker.Lendecke@sernet.de>, Gabriel Krisman Bertazi <krisman@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 5:21=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
> From: Chuck Lever <chuck.lever@oracle.com>
>
> Both the NFSv3 and NFSv4 protocols enable NFS clients to query NFS
> servers about the case sensitivity and case preservation behaviors
> of shared file systems. Today, the Linux NFSD implementation
> unconditionally returns "the export is case sensitive and case
> preserving".
>
> However, a few Linux in-tree file system types appear to have some
> ability to handle case-folded filenames. Some of our users would
> like to exploit that functionality from their non-POSIX NFS clients.
>
> Enable upper layers such as NFSD to retrieve case sensitivity
> information from file systems by adding a statx API for this
> purpose. Introduce a sample producer and a sample consumer for this
> information.
>
> If this mechanism seems sensible, a future patch might add a similar
> field to the user-space-visible statx structure. User-space file
> servers already use a variety of APIs to acquire this information.
>
> Suggested-by: Jeff Layton <jlayton@kernel.org>
> Cc: Volker Lendecke <Volker.Lendecke@sernet.de>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  fs/fat/file.c             |  5 +++++
>  fs/nfsd/nfs3proc.c        | 35 +++++++++++++++++++++++++++--------
>  include/linux/stat.h      |  1 +
>  include/uapi/linux/stat.h | 15 +++++++++++++++
>  4 files changed, 48 insertions(+), 8 deletions(-)
>
> I'm certain this RFC patch has a number of problems, but it should
> serve as a discussion point.
>
>
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 4fc49a614fb8..8572e36d8f27 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -413,6 +413,11 @@ int fat_getattr(struct mnt_idmap *idmap, const struc=
t path *path,
>                 stat->result_mask |=3D STATX_BTIME;
>                 stat->btime =3D MSDOS_I(inode)->i_crtime;
>         }
> +       if (request_mask & STATX_CASE_INFO) {
> +               stat->result_mask |=3D STATX_CASE_INFO;
> +               /* STATX_CASE_PRESERVING is cleared */
> +               stat->case_info =3D statx_case_ascii;
> +       }
>
>         return 0;
>  }
> diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
> index b6d03e1ef5f7..b319d1c4385c 100644
> --- a/fs/nfsd/nfs3proc.c
> +++ b/fs/nfsd/nfs3proc.c
> @@ -697,6 +697,31 @@ nfsd3_proc_fsinfo(struct svc_rqst *rqstp)
>         return rpc_success;
>  }
>
> +static __be32
> +nfsd3_proc_case(struct svc_fh *fhp, struct nfsd3_pathconfres *resp)
> +{
> +       struct path p =3D {
> +               .mnt            =3D fhp->fh_export->ex_path.mnt,
> +               .dentry         =3D fhp->fh_dentry,
> +       };
> +       u32 request_mask =3D STATX_CASE_INFO;
> +       struct kstat stat;
> +       __be32 nfserr;
> +
> +       nfserr =3D nfserrno(vfs_getattr(&p, &stat, request_mask,
> +                                     AT_STATX_SYNC_AS_STAT));
> +       if (nfserr !=3D nfs_ok)
> +               return nfserr;
> +       if (!(stat.result_mask & STATX_CASE_INFO))
> +               return nfs_ok;
> +
> +       resp->p_case_insensitive =3D
> +               stat.case_info & STATX_CASE_FOLDING_TYPE ? 0 : 1;
> +       resp->p_case_preserving =3D
> +               stat.case_info & STATX_CASE_PRESERVING ? 1 : 0;
> +       return nfs_ok;
> +}
> +
>  /*
>   * Get pathconf info for the specified file
>   */
> @@ -722,17 +747,11 @@ nfsd3_proc_pathconf(struct svc_rqst *rqstp)
>         if (resp->status =3D=3D nfs_ok) {
>                 struct super_block *sb =3D argp->fh.fh_dentry->d_sb;
>
> -               /* Note that we don't care for remote fs's here */
> -               switch (sb->s_magic) {
> -               case EXT2_SUPER_MAGIC:
> +               if (sb->s_magic =3D=3D EXT2_SUPER_MAGIC) {
>                         resp->p_link_max =3D EXT2_LINK_MAX;
>                         resp->p_name_max =3D EXT2_NAME_LEN;
> -                       break;
> -               case MSDOS_SUPER_MAGIC:
> -                       resp->p_case_insensitive =3D 1;
> -                       resp->p_case_preserving  =3D 0;
> -                       break;
>                 }
> +               resp->status =3D nfsd3_proc_case(&argp->fh, resp);
>         }
>
>         fh_put(&argp->fh);
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index e3d00e7bb26d..abb47cbb233a 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -59,6 +59,7 @@ struct kstat {
>         u32             atomic_write_unit_max;
>         u32             atomic_write_unit_max_opt;
>         u32             atomic_write_segments_max;
> +       u32             case_info;
>  };
>
>  /* These definitions are internal to the kernel for now. Mainly used by =
nfsd. */
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 1686861aae20..e929b30d64b6 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -219,6 +219,7 @@ struct statx {
>  #define STATX_SUBVOL           0x00008000U     /* Want/got stx_subvol */
>  #define STATX_WRITE_ATOMIC     0x00010000U     /* Want/got atomic_write_=
* fields */
>  #define STATX_DIO_READ_ALIGN   0x00020000U     /* Want/got dio read alig=
nment info */
> +#define STATX_CASE_INFO                0x00040000U     /* Want/got case =
folding info */
>
>  #define STATX__RESERVED                0x80000000U     /* Reserved for f=
uture struct statx expansion */
>
> @@ -257,4 +258,18 @@ struct statx {
>  #define STATX_ATTR_WRITE_ATOMIC                0x00400000 /* File suppor=
ts atomic write operations */
>
>
> +/*
> + * File system support for case folding is available via a bitmap.
> + */
> +#define STATX_CASE_PRESERVING          0x80000000 /* File name case is p=
reserved */
> +
> +/* Values stored in the low-order byte of .case_info */
> +enum {
> +       statx_case_sensitive =3D 0,
> +       statx_case_ascii,
> +       statx_case_utf8,
> +       statx_case_utf16,
> +};
> +#define STATX_CASE_FOLDING_TYPE                0x000000ff
> +
>  #endif /* _UAPI_LINUX_STAT_H */
> --
> 2.51.0
>

CC unicode maintainer and SMB list.

Thanks,
Amir.
