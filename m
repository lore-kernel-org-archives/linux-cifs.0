Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADD02CCC5
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 00:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788914585; cv=none; b=FziMHzZSXhYeWJgTrMRAyQLqvIJTKk1c7xD+2uCQO1EosaEH4DhVZCZLI6StaVpLd14E+9gamYlEJVgHMMUDBsjaPaP8Tm8M72necmWWTpluqzdgGhB9VwvKZRmSIdyEmoQM9IzqvmztVw0TMjSxtRq2jBqvNJJZ7HAWVjdEVcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788914585; c=relaxed/simple;
	bh=501NVijf8hQU5sQaozm5Cq5rHbsZHWLfAFPjQ4DLrbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlPOPXHR746S9+k/9vRzyu2tfAgElGut0Vb8de9jHpB/xnl0RchV6OqgkqG2B3oHBgkxxxiyHQwUO9TouZKdq3JcqPAtUYZrz0mK+OKPvMl3u1MN9x3WIGCT0z4Uz6ZxtTswY8uwAlqPTf0lGehrL9lWNS18Re5lDtxXwew5a80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPNPOies; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPNPOies"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01241F00A3A
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 00:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788914583;
	bh=fvX3paOkxKl+/epBtSS2786bEsOnAQ8sUO6Fb3dQDFc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SPNPOies1iUJS6rpJAt3DRXYFjsvMG2sVVBMmlQTutMalDBZPf3yFOObwNw2Dxmwe
	 piB5c1aq8WqeDAxjrDMhJ+N01777tz9Z/udgPTPVhHnVNQ7CW74h4dzJJSnHsNiLsL
	 ISZH9iJRiAbkC436Md/j4SbmojYaS19i0T+E5CutPDyFny73e/szSsshTlKI3OGN41
	 u6xTU7HrlH2D4LKDJPviAR1td+VVyui+QTYKRAncmzE7xIHA2o3OqGfW/OPb++n5iP
	 8oT77qczhVug2kvg9eF7QDZzLtSKevLE0AEdwu1cdVe1IYRbPNEMG3RPa9UErV9jUH
	 GbtYD5JKt9BFw==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f8694aeso134208966b.0
        for <linux-cifs@vger.kernel.org>; Tue, 08 Sep 2026 17:43:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSmN0vZ4l3XoWjbYnAT4CacBFrl3ynnLhVl3Uf4DwCY4dFhaQehWSr+2VfCKNK3Gajw5/f7AA1P2WH@vger.kernel.org
X-Gm-Message-State: AFuF++kbhOe3a10P20qxdU3KoHlSLcP0O8jStIBemhXRApDKlLBlGqbl
	Ov4OOmAA6nDuiWSY2Gf0hUCOV9+W0oNLJsWotNnEpiqbnOiT7yfuqfyD8P0UgTlLPU3R8eNQ5qJ
	Mex6G4pw/J5Sv0qfZVlqufc4P0iSwn0U=
X-Received: by 2002:a17:907:6d15:b0:c12:3cbf:9f6d with SMTP id
 a640c23a62f3a-c29042b6f3bmr498570966b.1.1788914582356; Tue, 08 Sep 2026
 17:43:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908081631.9735-1-15815827059@163.com> <CAKYAXd8g5RbLf7d7uNvtLZmODR2w_xW900E8dcWD1QyF5_hRfw@mail.gmail.com>
 <170e71f3.a2f8.1a0819a3e24.Coremail.15815827059@163.com>
In-Reply-To: <170e71f3.a2f8.1a0819a3e24.Coremail.15815827059@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 9 Sep 2026 09:42:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-D-rMQTJJ170UGyoq2=fyGCCAe7QMEAJPM=Nk=c=+XBA@mail.gmail.com>
X-Gm-Features: AcwNN1Wo10lWkAJlLsdt9BdwmslsjtqoWQ-uH57Pw_UuoQua2ONMctz-bduGNoQ
Message-ID: <CAKYAXd-D-rMQTJJ170UGyoq2=fyGCCAe7QMEAJPM=Nk=c=+XBA@mail.gmail.com>
Subject: Re: Re: [PATCH] ksmbd: fix invalid pointer dereference when
 get_inode_acl() fails
To: huhai <15815827059@163.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org, 
	Henry Hu <huhai@kylinos.cn>, stable@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 12:19=E2=80=AFAM huhai <15815827059@163.com> wrote:
>
> At 2026-09-08 21:35:18, "Namjae Jeon" <linkinjeon@kernel.org> wrote:
> >On Tue, Sep 8, 2026 at 5:16=E2=80=AFPM huhai <15815827059@163.com> wrote=
:
> >>
> >> From: Henry Hu <huhai@kylinos.cn>
> >>
> >> When get_inode_acl() fails, it returns an ERR_PTR(), but
> >> ksmbd_acls_fattr() stored that pointer in smb_fattr without
> >> checking for errors. Later callers then passed the error pointer
> >> to security descriptor helpers or posix_acl_release(), resulting
> >> in an invalid pointer dereference.
> >>
> >> This was reproduced on an XFS-backed share when xfs_get_acl()
> >> returned ERR_PTR(-ENOMEM). Querying the SMB ACL from a CIFS client
> >> triggered the crash:
> >>
> >>   BUG: unable to handle page fault for address: fffffffffffffff8
> >>   RIP: smb_acl_sec_desc_scratch_len+0x58/0x90 [ksmbd]
> >>   Call Trace:
> >>    smb2_query_info+0x40d/0x17c0 [ksmbd]
> >>    handle_ksmbd_work+0x1ca/0x770 [ksmbd]
> >>
> >> Fix this by checking the return values from get_inode_acl() in
> >> ksmbd_acls_fattr() and propagating any errors to its callers.
> >> Update smb2_open() and smb2_get_info_sec() to handle these errors.
> >>
> >> Cc: stable@vger.kernel.org
> >> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> >> Assisted-by: Codex:gpt-5.6-sol
> >> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >> Signed-off-by: Henry Hu <huhai@kylinos.cn>
> >> ---
> >>  fs/smb/server/smb2pdu.c | 29 +++++++++++++++++++++++------
> >>  1 file changed, 23 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> >> index b7ce67094626..c6df9a9789ba 100644
> >> --- a/fs/smb/server/smb2pdu.c
> >> +++ b/fs/smb/server/smb2pdu.c
> >> @@ -3634,9 +3634,9 @@ static int smb2_create_sd_buffer(struct ksmbd_wo=
rk *work,
> >>                             le32_to_cpu(sd_buf->ccontext.DataLength), =
true, false);
> >>  }
> >>
> >> -static void ksmbd_acls_fattr(struct smb_fattr *fattr,
> >> -                            struct mnt_idmap *idmap,
> >> -                            struct inode *inode)
> >> +static int ksmbd_acls_fattr(struct smb_fattr *fattr,
> >> +                           struct mnt_idmap *idmap,
> >> +                           struct inode *inode)
> >>  {
> >>         vfsuid_t vfsuid =3D i_uid_into_vfsuid(idmap, inode);
> >>         vfsgid_t vfsgid =3D i_gid_into_vfsgid(idmap, inode);
> >> @@ -3649,9 +3649,19 @@ static void ksmbd_acls_fattr(struct smb_fattr *=
fattr,
> >>
> >>         if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
> >>                 fattr->cf_acls =3D get_inode_acl(inode, ACL_TYPE_ACCES=
S);
> >> -               if (S_ISDIR(inode->i_mode))
> >> +               if (IS_ERR(fattr->cf_acls))
> >> +                       return PTR_ERR(fattr->cf_acls);
> >-EOPNOTSUPP and -ENODATA can indicate that the filesystem does not
> >support or have ACL, so those errors can be normalized to NULL.
> >However, other errors such as -ENOMEM, -EIO, and ACL corruption errors
> >should be propagated to the caller like this.
>
> Thanks for the review! You are right that unsupported or missing ACLs nee=
d
> to be distinguished from actual failures, and I noticed that the generic
> VFS POSIX ACL callers only treat -EOPNOTSUPP as meaning "no ACL":
>
> For example, posix_acl_chmod() does:
>     acl =3D get_inode_acl(inode, ACL_TYPE_ACCESS);
>     if (IS_ERR_OR_NULL(acl)) {
>         if (acl =3D=3D ERR_PTR(-EOPNOTSUPP))
>             return 0;
>         return PTR_ERR(acl);
>     }
>
> posix_acl_create() does:
>
>     p =3D get_inode_acl(dir, ACL_TYPE_DEFAULT);
>     if (!p || p =3D=3D ERR_PTR(-EOPNOTSUPP)) {
>         *mode &=3D ~current_umask();
>         return 0;
>     }
>     if (IS_ERR(p))
>         return PTR_ERR(p);
>
> Mainstream in-tree filesystems, such as ext4, XFS, and Btrfs, already
> convert -ENODATA (or -ENOATTR in XFS, which is an alias for -ENODATA)
> to NULL internally. Therefore, I think KSMBD should only normalize
> -EOPNOTSUPP to NULL and propagate all other errors.
>
> Please let me know what you think, and I will send a v2 accordingly.
Okay. Please send v2 patch.
