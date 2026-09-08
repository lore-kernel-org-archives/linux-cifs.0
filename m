Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A262F3614
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 13:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874551; cv=none; b=I2cZfTiS8RbEuqlQu3RDIfJgLEnfGhlIoTYooFuFITgCGwdQoliT+dh0LMU7CujnZB6wu/VkiZ7Bl5Pp22EJ6QlsM9CV0XtzukgbUPUquo15rdWs2h5g/Pd3xGEJHZ/XJ7pt6uCcmvkGOrjEUf/CsKq8SWhw8GckvXeJV/dRbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874551; c=relaxed/simple;
	bh=jRLWmSQ1yJt4NVQzPoosjnnS6qFiP+AbIGW1zlfD8ek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mSMGmANy8K2Jp0/1RImX/hc68M2xvQs0/3vCqD1V59DK/LMsvvS/OjFML8BSyAfLPA74J9RnL4/R86CaZkVwfxiX3jwUpNBdmMGNFjMAOqjkSa5uL6RMG89hSepfhysqLBfPWNEBZsb9y8uBVGc9ZSzYCv+LSzaskPXGqDAUwy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7jJAjxu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7jJAjxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399D81F00AC4
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788874535;
	bh=PB7mGes5DxmiOJerZm8E11TDr69SJwv8NYwNhjZZWCQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=L7jJAjxuuDmn1rF2EJlP/Bndi/IW3TEdyXadm0mOkNt6XOdJHZw6XE/Faqpq3T5O4
	 dOih1KmECuCqqP9T6hPQKXQLoGOvhlm5AkEIDuSp05KNEU7WqUR6oU7ZXBQXCn7ptW
	 n37Vx8tWjZTpA/8D8U+d7IU9YakR0WWKQ9LubTDUmkTzkjlRb/Evn0Nk/9CZjZccbz
	 HzActnS+tfObzu0k0vVkiGv6rZkw4jZERgxHJvVduYNSEpLstYwnm0C6/cwwfoVp+P
	 ThHgD2u7qMuasZdFkDkn6DNeju7dRDvNdML7gY+RW0epyL+f2TRD2hn3+K4UydkWmm
	 a4JZIuXAykX7Q==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c25b661d37dso649766666b.0
        for <linux-cifs@vger.kernel.org>; Tue, 08 Sep 2026 06:35:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz2Cwip2ZEBQy17xgy949xLJyIlm1TUJNTrh/3p1rmZl3QvvGYj0TD8GBa6UTlFL/1b0GpvNH/UYzjd@vger.kernel.org
X-Gm-Message-State: AFuF++kDMOjC4hhYyrTIl4wmH7srRClaWlUMh1I5CvWGIJQz3AeeepB6
	RF5rIHI34flqvXXxFck6oeinN35izSW7IUpnkgjGqr/73h9ToZAHfBeCVlp2IlCFfZX6RB6ziUb
	CS1IiNUPqhJb37DtiHIAXNFqXt6pN5tA=
X-Received: by 2002:a17:907:ea8d:b0:c26:2795:b494 with SMTP id
 a640c23a62f3a-c262795c1b3mr741273366b.49.1788874530621; Tue, 08 Sep 2026
 06:35:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908081631.9735-1-15815827059@163.com>
In-Reply-To: <20260908081631.9735-1-15815827059@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 22:35:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8g5RbLf7d7uNvtLZmODR2w_xW900E8dcWD1QyF5_hRfw@mail.gmail.com>
X-Gm-Features: AcwNN1WYpfTc2JE2BDFx-ZUXyxY7AN9NsXmy2W21aau5cA21jpg-cbjdzn6rCXQ
Message-ID: <CAKYAXd8g5RbLf7d7uNvtLZmODR2w_xW900E8dcWD1QyF5_hRfw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix invalid pointer dereference when
 get_inode_acl() fails
To: huhai <15815827059@163.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org, 
	Henry Hu <huhai@kylinos.cn>, stable@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 5:16=E2=80=AFPM huhai <15815827059@163.com> wrote:
>
> From: Henry Hu <huhai@kylinos.cn>
>
> When get_inode_acl() fails, it returns an ERR_PTR(), but
> ksmbd_acls_fattr() stored that pointer in smb_fattr without
> checking for errors. Later callers then passed the error pointer
> to security descriptor helpers or posix_acl_release(), resulting
> in an invalid pointer dereference.
>
> This was reproduced on an XFS-backed share when xfs_get_acl()
> returned ERR_PTR(-ENOMEM). Querying the SMB ACL from a CIFS client
> triggered the crash:
>
>   BUG: unable to handle page fault for address: fffffffffffffff8
>   RIP: smb_acl_sec_desc_scratch_len+0x58/0x90 [ksmbd]
>   Call Trace:
>    smb2_query_info+0x40d/0x17c0 [ksmbd]
>    handle_ksmbd_work+0x1ca/0x770 [ksmbd]
>
> Fix this by checking the return values from get_inode_acl() in
> ksmbd_acls_fattr() and propagating any errors to its callers.
> Update smb2_open() and smb2_get_info_sec() to handle these errors.
>
> Cc: stable@vger.kernel.org
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Assisted-by: Codex:gpt-5.6-sol
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: Henry Hu <huhai@kylinos.cn>
> ---
>  fs/smb/server/smb2pdu.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index b7ce67094626..c6df9a9789ba 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3634,9 +3634,9 @@ static int smb2_create_sd_buffer(struct ksmbd_work =
*work,
>                             le32_to_cpu(sd_buf->ccontext.DataLength), tru=
e, false);
>  }
>
> -static void ksmbd_acls_fattr(struct smb_fattr *fattr,
> -                            struct mnt_idmap *idmap,
> -                            struct inode *inode)
> +static int ksmbd_acls_fattr(struct smb_fattr *fattr,
> +                           struct mnt_idmap *idmap,
> +                           struct inode *inode)
>  {
>         vfsuid_t vfsuid =3D i_uid_into_vfsuid(idmap, inode);
>         vfsgid_t vfsgid =3D i_gid_into_vfsgid(idmap, inode);
> @@ -3649,9 +3649,19 @@ static void ksmbd_acls_fattr(struct smb_fattr *fat=
tr,
>
>         if (IS_ENABLED(CONFIG_FS_POSIX_ACL)) {
>                 fattr->cf_acls =3D get_inode_acl(inode, ACL_TYPE_ACCESS);
> -               if (S_ISDIR(inode->i_mode))
> +               if (IS_ERR(fattr->cf_acls))
> +                       return PTR_ERR(fattr->cf_acls);
-EOPNOTSUPP and -ENODATA can indicate that the filesystem does not
support or have ACL, so those errors can be normalized to NULL.
However, other errors such as -ENOMEM, -EIO, and ACL corruption errors
should be propagated to the caller like this.

> +
> +               if (S_ISDIR(inode->i_mode)) {
>                         fattr->cf_dacls =3D get_inode_acl(inode, ACL_TYPE=
_DEFAULT);
> +                       if (IS_ERR(fattr->cf_dacls)) {
> +                               posix_acl_release(fattr->cf_acls);
> +                               return PTR_ERR(fattr->cf_dacls);
Ditto.
Thanks.
