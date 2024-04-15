Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8DF84FBC
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 12:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713185766; cv=none; b=aH54KDeq4gQv+wCVOFiOkuEZf7ZZxl6hhGjLMLSaXmWmeKkKS+Pv3yltpELH7W6/wu0P6KzpnV16LWQ6aPndvfD29UFohy59HQC2vMbkpWD/bDrUtFyrz6BErHIPsgPIe1QQLQceUJBf9BEbPASEkkMo+jNKT9Se+z5IX6W8K20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713185766; c=relaxed/simple;
	bh=n94TpGfIfb2d3Q8WFMR3nEO5bJDJjugyTBiWTsZtgl0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OYB7/3URM9OV0/uDBUJgmlHoqo0bEbaEtFP3FFBgqQFJ6gcsfRF5qCutsNlmSqxM01VTibcL2bP2qFYJigM2H+NoIv8k1SuZ7KfzqRyUE+fxMkeAr9AHBFiFvrnItoAx+uoxLqDbNreU0D3SxCE5nxYlDZ6/5stD4SN9wG9qXos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=urpYL62C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urpYL62C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32466C113CC
	for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713185766;
	bh=n94TpGfIfb2d3Q8WFMR3nEO5bJDJjugyTBiWTsZtgl0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=urpYL62CXnknnVpyC6z9FD4+eAT/xDBhYZvtfXVc4avCw86tNFjaMKwBXemO9Uj7b
	 ait0Par/FLnzuCmgJVX/HbSdnjUGikI1XmC6kukcnv9bkDbm4UDwFTB9tG1IiAFSJW
	 77RzKKp24R2VKuiA3AJ7y05ZLvBJvKdJN+jVf4zG6xno3r2dUiGhULWZspPwDnDjR9
	 fLEUkH88DMMQLcpO06MZw9Bbx9mcyT1Pufd1ysXEm0u6WaO3PVoA21pbxKzwlVRDMQ
	 W4LcTeW6XgBkgd8kfcZdUOHBxPTOiRMN0INw+CxQ0nNNCjqurUxSfZKEX2MNw093cF
	 eOcGwHiI1sVQA==
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5aa17c69cf7so2398759eaf.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 05:56:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YxEbN2YDiQ4Dl0wR4ljO99Tbjel9fmr2lHS1ucRBycaYuiXGZiB
	do9pycrpmdrUPs/C/BLrSUPc3FJiGRqfYyWqf97/JGVUZU6xxM5oxDpj3ADcre7lM7hlav82Ayu
	+C/RW80tIY+WHpmzoem8hR9VtQys=
X-Google-Smtp-Source: AGHT+IH4EoxUI+Usny1pM18DLcWXTzhxiDXvKYHP8jqo/waHox/f27S52PyCPP1w+CVegZpv1yK2Gjeqgv6hMJ7u06g=
X-Received: by 2002:a05:6820:3089:b0:5ac:4372:1d6a with SMTP id
 eu9-20020a056820308900b005ac43721d6amr9032524oob.3.1713185765529; Mon, 15 Apr
 2024 05:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313130708.2915988-1-mmakassikis@freebox.fr>
 <CAF6XXKVNTF2yZK=QdKi-YNZC5N93x-NrN7a=hDGZNNCUfxTAwA@mail.gmail.com>
 <CAKYAXd9o2d0Ky-242+UV3DcHWs1ZMYd+ErP8Ueqn3nvucMQtJA@mail.gmail.com> <CAF6XXKUjE-vo+z5aKrfXEet59EJB+yjy3uh1xhJQRQaFppdWkw@mail.gmail.com>
In-Reply-To: <CAF6XXKUjE-vo+z5aKrfXEet59EJB+yjy3uh1xhJQRQaFppdWkw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 15 Apr 2024 21:55:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_8b00geiawuUQ3F4htQvucjH7KGpbOFV1Js7Pwf-JQig@mail.gmail.com>
Message-ID: <CAKYAXd_8b00geiawuUQ3F4htQvucjH7KGpbOFV1Js7Pwf-JQig@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clear RENAME_NOREPLACE before calling vfs_rename
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 4=EC=9B=94 15=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 9:36, M=
arios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Mon, Apr 15, 2024 at 12:51=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.o=
rg> wrote:
> >
> > 2024=EB=85=84 4=EC=9B=94 15=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 6:0=
1, Marios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
> > >
> > > On Wed, Mar 13, 2024 at 2:07=E2=80=AFPM Marios Makassikis
> > > <mmakassikis@freebox.fr> wrote:
> > > >
> > > > File overwrite case is explicitly handled, so it is not necessary t=
o
> > > > pass RENAME_NOREPLACE to vfs_rename.
> > > >
> > > > Clearing the flag fixes rename operations when the share is a ntfs-=
3g
> > > > mount. The latter uses an older version of fuse with no support for
> > > > flags in the ->rename op.
> > > >
> > > > Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> > > > ---
> > > >  fs/smb/server/vfs.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > >
> > > Bumping this as I haven't received any feedback.
> > > Are there any issues with the patch ?
> > Sorry for missing this patch. Please cc me when submitting the patch
> > to the list next time.
> > I didn't understand why it is a problem with ntfs-3g yet.
> > Is it just clean-up patch ? or this flags cause some issue with ntfs-3g=
 ?
> > Could you please elaborate more ?
> >
> > Thanks!
>
> Until commit 74d7970febf ("ksmbd: fix racy issue from using ->d_parent
> and ->d_name"),
> the logic to overwrite a file or fail depending on the ReplaceIfExists
> flag was open-coded.
> This is the same as calling vfs_rename() with the RENAME_NOREPLACE flag, =
so it
> makes sense to use that instead.
>
> When using FUSE, the behaviour depends on the userland application implem=
enting
> the fs. On the kernel side, this is the function that ends up being calle=
d:
>
> fs/fuse/dir.c:
> static int fuse_rename2(struct mnt_idmap *idmap, struct inode *olddir,
>                         struct dentry *oldent, struct inode *newdir,
>                         struct dentry *newent, unsigned int flags)
> {
>         struct fuse_conn *fc =3D get_fuse_conn(olddir);
>         int err;
>
>         if (fuse_is_bad(olddir))
>                 return -EIO;
>
>         if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOU=
T))
>                 return -EINVAL;
>
>         if (flags) {
>                 if (fc->no_rename2 || fc->minor < 23)
>                         return -EINVAL;
>
>                 err =3D fuse_rename_common(olddir, oldent, newdir, newent=
, flags,
>                                          FUSE_RENAME2,
>                                          sizeof(struct fuse_rename2_in));
>                 if (err =3D=3D -ENOSYS) {
>                         fc->no_rename2 =3D 1;
>                         err =3D -EINVAL;
>                 }
>         } else {
>                 err =3D fuse_rename_common(olddir, oldent, newdir, newent=
, 0,
>                                          FUSE_RENAME,
>                                          sizeof(struct fuse_rename_in));
>         }
>
>         return err;
> }
>
> Because ntfs-3g uses an older version of the FUSE API and flags are
> passed by ksmbd,
> rename attempts fail because of this bit:
>
>         if (flags) {
>                 if (fc->no_rename2 || fc->minor < 23)
>                         return -EINVAL;
>
> ksmbd already handles the overwrite case before even calling
> vfs_rename(). So passing
> the flag doesn't add much.
Okay, Thanks for your detailed explanation:)

Can you fix a warning from checkpatch.pl ?

WARNING: Block comments use a trailing */ on a separate line
#123: FILE: fs/smb/server/vfs.c:758:
+ * filesystems that may not support rename flags (e.g: fuse) */

total: 0 errors, 1 warnings, 13 lines checked

Thanks.

>
> --
> Marios
