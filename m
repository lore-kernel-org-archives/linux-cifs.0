Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C18101C8;
	Sun, 29 Sep 2024 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727625713; cv=none; b=tTS5ytTKh7Ce7KawMAKbuMcu9Cneg6wpFMgfC/E2BYcsWZQ6vUr99/x654FMF583USSKDYNU3xCh8qPx6vG2D2Tv7oH1RDLVfxgzohOJpEAat33JAAmCxT8s4cmQcsLEk1aek3BtcfHgZbCqoL70AvaP0Ou/1P9WC3iTxZhJ2jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727625713; c=relaxed/simple;
	bh=EgIqzu9KVyWDxVMW2jPhzzdJLfbhTbX2AAkTO9BHsWA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p1341GkPby3qyZz2HM+GblFhazqunkpZ9h/43TWZJ0H1ZCFs7TM0BvkuePiEoWjZ9LB9WQS2a1UI4Ofzk8uFYgpVY6PuXNAIPoNbjgPUkYQ2CSeQbkm4+RVd2OPHaDKA54bl/FNhAK1rVW6avvF2TO77arc8fq2TX6MQy0l/mtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fs9VeEoQ; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fs9VeEoQ"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53994aadb66so213833e87.2;
        Sun, 29 Sep 2024 09:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727625709; x=1728230509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+j5mE6mA7Lzt2F2PdEtSO03E+UJc5ymhCaR2gz+DIc=;
        b=fs9VeEoQk9F/BP1F9qcGW55z0JXeUivNy2tYRb3+fIbrAxvoMmtCUyLWel6uyeQC2O
         5h/9a+4ztrSITs9bvhTUQLEciZGrxRF3FhCUBh9nYg3hFZeZUVBW3GPTCmsm4j+fg2mR
         ZRK9NfY5ajOG4zMxcWQXCSyueT5xdXmP//4ctcJ/RQJTdE3kxlAhlJb9UdA8zwA0bp8j
         yU6RZhTgZ+ZU88ad9aIVK2q7683KxACZcWQ9mFrjnmCrPAs91qAGlnsPaoouBiHCKgoD
         E+M6AdRZeZzaycTXhdd9rS2u8MxMDdJSEQM+vy3vClkri8wUyBvJkStzXovdlh3orQfy
         yR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727625709; x=1728230509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+j5mE6mA7Lzt2F2PdEtSO03E+UJc5ymhCaR2gz+DIc=;
        b=GjizTZEXiERLXVcR95jfRHwpp3a3kEM0KzxPeDmPGxZzHLvfi/DkP7JDZgfr5SOtDB
         JrKRq2g6y6n0p42xfIvm/WTUM2vwh7z0myHfSCqpoNBR6HMT9zZApNVJCJcyceNtIJG1
         iYsNbNaof0I/B1YguFV2xlTKwjnYt0RyzIsr/B38rUkTqjqc4QOrlGC10zGNAmayqN1A
         ia/LnT7AcfXvJl6uIaNg+e6bABiey6X+7/xZ1Oj/zdjvQqrEsVwKebrQ3rGK2zHDItQA
         mWppEyLTzhd1JI6IjIl9GHHGh9uhXlQWnpm5LgNs4Uend30ovjm49DUZ0WtGiVW7CNMI
         i4jg==
X-Forwarded-Encrypted: i=1; AJvYcCUggVinHDJWCLjH+02MMMcnFLy9F6jPlAp3kKmEwvfte3tBQRYc9sOwr64ZACjHnx4hnDE3FCHpxY1VM2xV@vger.kernel.org, AJvYcCVhJSHy1b0uKvOnk0IlDipHXa1xF1f/gx6WiyZjhKEs5BGhPrvCrnDGt8hIx6idCS7d0yHxQLlMZLCO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc8oP729ke6xA296qtACVpcMQ0AoAkQlLveBDj2KqhEMUY6Gln
	ItUThAbIZBNNa+4+RSqyAgB+iNRQfIvDoS/NsqU4cjxKeOlxcslskmEFYLMCRSe/dkPc3MmRjq/
	1BaX2r03+RgHat2iI8vSVO7zc5lk=
X-Google-Smtp-Source: AGHT+IGWR9qr1K7uGnsqXJnOR8e5EOEzNxJIt9URZAfnzk1X+BtQDiaM2b45YUT1XqJfPvP5nM5hjucWKhnOK5EPx0o=
X-Received: by 2002:a05:6512:158f:b0:533:46cc:a736 with SMTP id
 2adb3069b0e04-5389fc6b0c1mr4847822e87.37.1727625709130; Sun, 29 Sep 2024
 09:01:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928215948.4494-3-pali@kernel.org> <20240929140343.9147-1-pali@kernel.org>
In-Reply-To: <20240929140343.9147-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 11:01:38 -0500
Message-ID: <CAH2r5mukT=cTCc5fRg-=w1n2zqqr73piYPHJZo+To=TARsa3UA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Remove intermediate object of failed create
 reparse call
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Running regression tests on these currently.  Let me know if
additional patches to add for these experiments

1c2fcb28ce99 (HEAD -> for-next, origin/for-next, origin/HEAD) cifs: Do
not convert delimiter when parsing NFS-style symlinks
92484193d70a cifs: Validate content of NFS reparse point buffer
c77a8e49f2d3 cifs: Fix buffer overflow when parsing NFS reparse points
ab7d68fd4bcc cifs: Remove intermediate object of failed create reparse call
ab50485ea1b4 smb: Update comments about some reparse point tags
1600fe2d42a1 smb: client: stop flooding dmesg with automounts
f7a33d56e52f smb: client: stop flooding dmesg on failed session setups
e1b72ef3ba03 cifs: Check for UTF-16 null codepoint in SFU symlink
target location
9717d5343849 Merge tag 'v6.12-rc-ksmbd-server-fixes' of
git://git.samba.org/ksmbd

On Sun, Sep 29, 2024 at 9:04=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
> intermediate object created by CREATE. Otherwise empty object stay on the
> server when reparse call failed.
>
> This ensures that if the creating of special files is unsupported by the
> server then no empty file stay on the server as a result of unsupported
> operation.
>
> Fixes: 102466f303ff ("smb: client: allow creating special files via repar=
se points")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
> Changes in v2:
> * Increase out_buftype[] and out_iov[] members from 2 to 4 as required by=
 smb2_compound_op
> * Call free_rsp_buf() for all members of out_buftype[]/out_iov[]
>
> I would like if you double check this smb2_compound_op() usage if there
> is not some other memory issue. As V1 contained both memory leak and
> buffer overflow (smb2_compound_op wrote out of those two arrays).
>
> ---
>  fs/smb/client/smb2inode.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 11a1c53c64e0..6e69a3b98be3 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1205,9 +1205,12 @@ struct inode *smb2_get_reparse_inode(struct cifs_o=
pen_info_data *data,
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>         struct cifsFileInfo *cfile;
>         struct inode *new =3D NULL;
> +       int out_buftype[4] =3D {};
> +       struct kvec out_iov[4] =3D {};
>         struct kvec in_iov[2];
>         int cmds[2];
>         int rc;
> +       int i;
>
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path,
>                              SYNCHRONIZE | DELETE |
> @@ -1228,7 +1231,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_op=
en_info_data *data,
>                 cmds[1] =3D SMB2_OP_POSIX_QUERY_INFO;
>                 cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfi=
le);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms,
> -                                     in_iov, cmds, 2, cfile, NULL, NULL,=
 NULL);
> +                                     in_iov, cmds, 2, cfile, out_iov, ou=
t_buftype, NULL);
>                 if (!rc) {
>                         rc =3D smb311_posix_get_inode_info(&new, full_pat=
h,
>                                                          data, sb, xid);
> @@ -1237,12 +1240,27 @@ struct inode *smb2_get_reparse_inode(struct cifs_=
open_info_data *data,
>                 cmds[1] =3D SMB2_OP_QUERY_INFO;
>                 cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfi=
le);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms,
> -                                     in_iov, cmds, 2, cfile, NULL, NULL,=
 NULL);
> +                                     in_iov, cmds, 2, cfile, out_iov, ou=
t_buftype, NULL);
>                 if (!rc) {
>                         rc =3D cifs_get_inode_info(&new, full_path,
>                                                  data, sb, xid, NULL);
>                 }
>         }
> +
> +       if (rc) {
> +               /*
> +                * If CREATE was successful but SMB2_OP_SET_REPARSE faile=
d then
> +                * remove the intermediate object created by CREATE. Othe=
rwise
> +                * empty object stay on the server when reparse call fail=
ed.
> +                */
> +               if (((struct smb2_hdr *)out_iov[0].iov_base)->Status =3D=
=3D STATUS_SUCCESS &&
> +                   ((struct smb2_hdr *)out_iov[1].iov_base)->Status !=3D=
 STATUS_SUCCESS)
> +                       smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
> +       }
> +
> +       for (i =3D 0; i < ARRAY_SIZE(out_buftype); i++)
> +               free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
> +
>         return rc ? ERR_PTR(rc) : new;
>  }
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
