Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E8D2264D9
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 00:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776906001; cv=pass; b=XmPcDBL0KAL8PUeUmGNlWIcPL6Z56JqmGk5bCQ1g3/8mjB5HcU3TXbHlAnLTTToVVxydJcWbW4LD6qOm3Y+XktDRlfoKuB1dVTPoHbzH9mNNLuCRU7v2NGDCXkzQHaUEeNeGQg70fHdAnBCjlh9yYR1qAX13ZK1KMnTbkdHV15g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776906001; c=relaxed/simple;
	bh=glEATcMQjgXcIVNGcFv/jGZwSA4FOZck5uTqZXkwZrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxrEjLPeLDxMCruRr45+Ne3qpvxUHG9G/DL7a5JEhtFF1vpAC5tObD4hCE9STq3YkZ0iTrM/Ufu/tHuLBej0FmqydsVfIGCfvSM0OOulXX6JawbGgKVlizFFe3qOLklw10MyBgyhn6qtHFbtfK2SqSPwAEzKYvuMvJFnjOCRnmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMRiJS2/; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMRiJS2/"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8ee7ffd738dso243490385a.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 17:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776905997; cv=none;
        d=google.com; s=arc-20240605;
        b=TKuVzm60f1i9ADNixjF1sAPIWfdnIdVjdlqgM5xVQMpXZUmhyiTPkeoWTYI7hJ55Cy
         YF2oaNnZgUtBV9Z3aSf3pUbtlXfL8ZVp14HW+VMDkAnW38EOyz+MprgPDVUmPzOTDiZx
         PEuQQY9YRnh9k3OygCCSHhrVStxA1vjjqWM8gWPrZX9i5pLVuEA241SJ9ag7K1iyX73s
         xQ7C+ykJgKmUmRxcEHDG2kKiCP6MH9EWuJVjLMuNe+MWtrXPFQLvlvA4yFkvnOh4Cv+I
         TTszdnvCfo6bg441woiB2rDKjgdDi4FqViyK+iCPrpBeSG3KMTcePBxomKlNsIGeR26A
         V1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        fh=wL0C3xPpXLyfitlSpHug9KYqFYkv5Ilsax5tuZtmVks=;
        b=cfr05sN/H7lmc734t0esgoxx9l6f5hsJwYKt+xLwW7fHPIMwxdOhr5x65cgV/B53uf
         yra6GzugHdrLKeVwFFswOJf7DtHEIU3M2yegLzUvHzzGPFw3UBhCiL4a8uj7PENnKfHV
         qwokgNuvL/UUMDij55+hhlaDM95qwNg3xgfTfgFKHcoJiP44OukLTXKFC6g1hVA2A5Gl
         Z+ihBSsU78kG5YYt75oo1WoJ6c3MfG04E1/9WTDMEuBcdwSPkRUOeAK4mCHsPQfx8v8k
         SpNrDS5wpGiP1raNz17zNQeqre/m8yPHGrpUc583cj0Qgt5qLq93wpCwG2vRhQ1r4OUv
         wqXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776905997; x=1777510797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        b=YMRiJS2/7iPeV6CGivmFNZlhKtWjZPgsedWvhWP74UAv3lHrFmEFD0Aur6BIskzh0g
         QWBYcqG55fzdQVfvpnQ9RV5vQsjz0rWZL56X2ebc3clKJU48exG+EENE6kbVBxOFpPk+
         5t2gNgAxnqyaIvLY5ck4yRXX+nydQgvVrTEgBY8JAQXSqA8G3K6ongzaSlOAcv5LE5uM
         Yo7Lct+7ITiCGlvIXN81wLh8Pdlp3XWrN5vkapIFlpVoCanONo4VVCoHnyFslJtMBaWb
         mcFu62lehj3ZRz/Tw8nwq2iDe7aP0WaWjUg+TjiMd5pr/GNJgLYryCDxWm3FILghrLh2
         OYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776905997; x=1777510797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t/Auuo3ewU9oR2gX8cwKFh7CPK/qOcoVmyN6PErL6wA=;
        b=PXPpY2dGGn4X+mWeeg4ws7pR0GcmuW28+RNCd+5SzVVngZC672cm8odTJpGnkLyhPH
         KBhCLcg/sogUL+sL1t0owxagwFlmOXlox2oCF6oMu4q+Uip2Zx2f/0M62dzjSIVSOGV5
         k4XXd6tdTlNRe2i4cWu3cPPHyozrif+AZiyiVF1+disK1Yya/1tFl8zTtoWPurVsWsU3
         80m6HxycBLG//zTsmgr2TqNBoM88tQ9a/g7M/j7AiC1BSo45bJV8fvJALBbDyAIkWh7n
         6WfgEqf+Kw70X6VPxA6l1sPnMuqL5WdIo5R3FG2rkwQbltC/E9sbUtC+fLwoX9fiYQVL
         xGcw==
X-Forwarded-Encrypted: i=1; AFNElJ/PenE6PPwT8PlFi9aVOFOUHMehrNZdL6SoxdIWd8eDm0z8HPd43U0goYeVyLDyEUCVDo62kwguyr1f@vger.kernel.org
X-Gm-Message-State: AOJu0YxKIFFoxVh3q74zqRIU2Z4hsBCHhdbprNSrnbgWf14I98k9HjfB
	/WmaAJkOOpKkJlH46AZ4Duss2Avlcr7s/49DRtv0tt+wVcvTNBwYxSS++SXJEmtgGbLGMxTC74+
	zfq6t+1Fs3eNslAQt3C8l9SVqBAD6sBY=
X-Gm-Gg: AeBDiesZirXEq4bPATiYC2o3U2tErFU8f9nQGxjAWmQHn9gPZLA6ssDKxtultxjKLqw
	CW0s4B+KZvLoZq/bDaxWqnEVGJN58ZG/GKg306AU/Pgqxqql475dDPfkr1RlD3baDaASgyPKdY1
	9xS4bKIyGIXwYz461FYAndBuVMdyVJ9fh4+lo7TNgI4q/p6hZjEC5y/xg4+Edv6LCo1tTBU1zD7
	bL3YFCjgJgE/Ajh6j6e99cU7u1FR0N1fYd08OdNxvQHp+6F0lHHbIcg6EJSVzWGCQIWP8/WAx+P
	vunfobCzbXJFzTqz+E1dapZWeKgvni0ReOFskIOogA1B7h8IzB9V8+az4E5mqgjqD0qVzh3w/z7
	4H+XG0hVf5lzIZHHF14OLqVaGhJ4Q59tx2VAi0ZCdewrvIfW8iMV2Ma05Rcdtch+moLlug8M10o
	/ZXhJm/1AR22SXl0+tGm6wnVP3eGnELizr+V5q9oRM8cM=
X-Received: by 2002:a05:6214:490a:b0:8ac:b3ba:eb0c with SMTP id
 6a1803df08f44-8b0282f35c0mr336785626d6.2.1776905997499; Wed, 22 Apr 2026
 17:59:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422-case-sensitivity-v9-0-be023cc070e2@oracle.com> <20260422-case-sensitivity-v9-10-be023cc070e2@oracle.com>
In-Reply-To: <20260422-case-sensitivity-v9-10-be023cc070e2@oracle.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 22 Apr 2026 19:59:43 -0500
X-Gm-Features: AQROBzCtyORnfuVHnIm1n6WO0qai8y2HQyRw138-ozkefgToPmyDNAGdDckhKog
Message-ID: <CAH2r5muvUVY8FD6ZM+ARecM8evjejB15n0Ea9Z=GGn=i5aKFNA@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] cifs: Implement fileattr_get for case sensitivity
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
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by: Steve French <stfrench@microsoft.com>

Do you know which xfstests this would enable?  IIRC a few of them
depend on the fs supporting fileattr_get

On Wed, Apr 22, 2026 at 6:34=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
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
