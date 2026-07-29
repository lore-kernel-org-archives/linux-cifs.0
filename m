Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D024052C8
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 16:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785342680; cv=pass; b=iYxyqYdNa3UhGMJIYtXTN8DsokGhe+6YfzjK7B2Ya7A9nJnZgtQY9gqdEoWxE9MkKY69akoIVMNTXFGRN9heSFyzNmh297tE1feNTjBdDTSc6aRPGfd5cWiU/IpMKcrNu7vDfHeM67U5pHTVtyGnXTNikmoFiRNomT7D1YalAl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785342680; c=relaxed/simple;
	bh=S9SC+Xya2EQfqf9tNwbGoOGjCrrJQ5Kh7ijB/buwyGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ll/uAdDElVxVdDbqQvzg4I0s1BqZopT9jQ7FPPkFtSd7zmdhVQc5P40JJ7+DgT+w8c86Z56kheaIavJfiyDrBVnxsHuOXeTKxD38vIz8XZPjkL4AbkqzHB6oDsE7hUlOyYwZ327rnUSx/D8rkcDsGNCfaoC4Jhru4Vv1xWnFvY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYetWZzB; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYetWZzB"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e54f8c051so64853485a.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 09:31:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785342678; cv=none;
        d=google.com; s=arc-20260327;
        b=oi2F0d4Z83M0scOxu6NQcoWsBk6sVcMN14lsEki3c33A+E3pqXrb+nQjeB0WuKrvXg
         eA034kgL4MAh7Tye5/2e+2KfK1a8EnugXj3Y/9POjfoB1mWe06WyzpLBwCrSBW/wo3LA
         7cC5nUO6fFTbbClJV91L0O8IflCKMAJ/1urNvEPHPds1w486eTFWM7VnpLRqE+SWTCrU
         ZFxiIKJTxCMBJSZGSfusIWwmdRv77uHEw6r70Uh0CcK9EZ7UF+hB2zF4MjLLxwviBumg
         3enl9Burbal4G2pWSqhy5+HcvFgivZ5QXK+3lTmqU/ZoApezLbpRl8mEz0FsLeezo1qZ
         FNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H21FkzzATqmSB3dNxAkJ0SfsF/b0DzYCWUc7+kRSXj4=;
        fh=gR2nwP3xD+g3no74dxtgD1eVB7sOOI0mSCRbJuRuK24=;
        b=gE08sYLZDdUyFsqjxjOvrjuBa4vJc4vHteplTSgA9SWk1zQNJI1nb1z69wumTojpy9
         buADfJPMw398lsavqhFqB7ooDcpaidv60F/Ob0IYr1x0jaoZCP6tiwF1GntHAsfu67RO
         RtOp5hc1jX8gRYv5oZsVNFtX30IkZ3C0lIHbSPwEMfjmvgK7945RLZfdxvfXstKlGLBO
         4iiCXRKtDB2RKKszR+cIrd3diPFbIj4A9DVbyjiqBoIYSXTFZkXXazC9KqoXHjS+BZNq
         TnFIsVq5KcJfNNnB/B52id0eJ5qRioK0dduo7O4GZeWCeXc6upVDikm/g7vcLSDqLbaR
         grtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785342678; x=1785947478; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H21FkzzATqmSB3dNxAkJ0SfsF/b0DzYCWUc7+kRSXj4=;
        b=QYetWZzBpnhDpGLcZVLD2UMwC82knMTFtgYTl6C2uoGd2BXrlfuS4WNHy97dICpRrJ
         gOPL9V10aVBvlDXDRzYu58Cs3xGNUMGNoqnvWqDj9pRWxISdTI3VihTpXScLVFzq4Shv
         tEJLV6pSejLFAa3ktnbQZUMn4VOBGAENnxUJgIB8+1X4hmnT/CqMdsr6NJC4YsYAElMk
         gIVVhEuEYClK1UwONs09lPUbXfnfaRazQu5BjEIihBkKeUVjrqM1gFKsAvl1xFPrLamq
         1PPFpEp9LMEeNccwEP90GkLxTPtI7oOQgqkJwE4CUx1KNiut2LrddjQnU7fw9v6B0H/t
         mPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785342678; x=1785947478;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H21FkzzATqmSB3dNxAkJ0SfsF/b0DzYCWUc7+kRSXj4=;
        b=pxf2yuQtvVuhRr2my5LkJCIXFyAj2p75PHnFfGETs7Ii3vgBBgh/K1pAfOjOTzhDzi
         F9CWIU85JzAnCI6EFLlkd86xHrcz8OhuiN6qiAzI5pa9mVyJFKjA+qblCFCHepoZPs4a
         2zerXoPWBBnTm4J8iGxCxQ+pXnoRiAC5L4sXoc8x/FkvsT7QKeFn3COYV4vHRCUv2RzK
         uGTlLGXFFo9NFuRIJb4qK97MQoA1o4yrWlcUpzHiXCtvvKxRzmlROgilxj6pL7elmFrn
         8ETkPYTy/Gl6EyL0YhFikKpcQuTLGeO7j9WarnYgsJZd2y8FfulyzMd0O7vgYZ8BTrpE
         QhTQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGxX9HWVr+ueCTeG8jYQccnt366ALRg4sbwHxICPNerSREejDCiexjzZs8m4tZzzj/yMT0Ejd5Dhem@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+Ya4NIFJpPs7clnYM4c8EaNy3NXl/cRTNR3glQAi5z4zswsiL
	OYprqzFm+SlJZiqKFqjFLdMvqOl3H6g57lEF4PXvZXpat7VAMbam3pydKJ8hIwyN5h8P0Nk37RX
	ivWN56S7fwuNh6MyQz8BS/BBgV3rJ0Y0=
X-Gm-Gg: AR+sD11sS3dK/vFBgPKZ9a/HIcbShRBsWDVOh5HwUc7skCFnXzmNDitzflTk9v2fHHv
	A+5VVrVhGEm+dnxKXNn+GvnLS1E7liTnZ7qRMvxcbWpQGBNL8AT9qW99bj6+okx/Y+VBJTNHjHg
	56iNxOWr5Ekd4MiBwYEtbLWQWJPzhiNd/d3zKfrqwwfHgZGwWXFS96z4tXo5iHX4atqL5TmTuGw
	NSeTKJsLkAxH81sulPUxxYiJSr+OBlGS3+SE78mWTtalqVrob1uGq5VxjMVuVqLLWjnjPJaGCJM
	e9n4FBc+kwYf+cB4TW/ukBdGzD9IxpxaSHtAXlQkofDY9RGk2HPQXNrgJ/GB6liEemxHE5IGOlO
	jSbT3kL5InIczBbVjqs8pYGmcXtbOBsaDL/1AVu1KVqEL649FQ2u8jDzxdu0xsw4vl8R+IyvAG3
	y84PrbuVxQEbwGTtefS001uVL7
X-Received: by 2002:a05:620a:4445:b0:92e:eeb6:b879 with SMTP id
 af79cd13be357-933025fe6dcmr709988485a.41.1785342677543; Wed, 29 Jul 2026
 09:31:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716022214.2727070-1-yijiangshan@kylinos.cn>
In-Reply-To: <20260716022214.2727070-1-yijiangshan@kylinos.cn>
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Jul 2026 11:31:05 -0500
X-Gm-Features: AUfX_myTS-L8_63bZ_SeAWVg2RUljtftNFyM8rksYMhQpz3sjCmcWPBXn9L8PtY
Message-ID: <CAH2r5mv962Lp+mLi2JCjvWhtJLbzLqwmjxYSCjSUyy_KLjAzuw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: clear setuid/setgid bit on write with
 cifsacl/modefromsid/posix extensions
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, akpm@linux-foundation.org, 
	jlayton@kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	13667453960@163.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

doesn't the bit only get cleared if it is a non-root user? Does the
patch need changes to see if root is writing?  When I asked AI it
responded with:

On modern Linux:
A process without CAP_FSETID will have the setuid/setgid bits cleared
when writing to a regular file.
A process with CAP_FSETID (typically root, though capabilities can be
granted independently) may preserve them.

On Wed, Jul 15, 2026 at 9:23=E2=80=AFPM Jiangshan Yi <yijiangshan@kylinos.c=
n> wrote:
>
> When a file has the setuid or setgid bit set and is written to, the VFS
> strips those bits and issues a setattr with ATTR_KILL_SUID/ATTR_KILL_SGID
> together with an ATTR_MODE carrying the already-cleared mode.
>
> Both cifs_setattr_unix() and cifs_setattr_nounix() unconditionally droppe=
d
> ATTR_MODE in that case:
>
>         /* skip mode change if it's just for clearing setuid/setgid */
>         if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
>                 attrs->ia_valid &=3D ~ATTR_MODE;
>
> This is fine for the default mount, where the mode is only emulated via
> the DOS read-only attribute and cannot represent the setuid/setgid bits
> anyway.  However, with the "cifsacl" or "modefromsid" mount options the
> mode is stored on the server through an ACL (id_mode_to_cifs_acl()), with
> the SMB3.1.1 POSIX extensions the mode is sent to the server directly,
> and with the SMB1 Unix extensions (cifs_setattr_unix) the mode is sent
> via CIFSSMBUnixSetPathInfo().  In all those cases dropping ATTR_MODE mean=
s
> the cleared mode is never pushed to the server, so the setuid/setgid bit
> survives the write.
>
> This is a security issue: on local filesystems the setuid bit is stripped
> when a file is written, but over these cifs.ko mounts the bit persists on
> the server, potentially allowing an unexpected privilege escalation on
> subsequent execution.
>
> Fix this in two places:
>
>   1. cifs_setattr_nounix(): only take the "skip mode change" shortcut
>      when the mode is emulated via the DOS read-only attribute (i.e.
>      neither cifsacl/modefromsid nor the SMB3.1.1 POSIX extensions are
>      in effect), so that the cleared mode is propagated to the server
>      in the ACL / POSIX cases.
>
>   2. cifs_setattr_unix(): this function is only called when Unix
>      extensions are in effect, so the mode is always stored on the
>      server.  Remove the shortcut entirely so that the cleared mode is
>      always pushed.
>
> Fixes: d32c4f2626ac ("CIFS: ignore mode change if it's just for clearing =
setuid/setgid bits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
> ---
>  fs/smb/client/inode.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index deed04dd9b91..e1cecd58ea9d 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3200,9 +3200,13 @@ cifs_setattr_unix(struct dentry *direntry, struct =
iattr *attrs)
>                 attrs->ia_valid &=3D ~(ATTR_CTIME | ATTR_MTIME);
>         }
>
> -       /* skip mode change if it's just for clearing setuid/setgid */
> -       if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
> -               attrs->ia_valid &=3D ~ATTR_MODE;
> +       /*
> +        * This function is only called when Unix extensions are in effec=
t,
> +        * so the mode is always sent to and stored on the server.  Do no=
t
> +        * skip the mode change when clearing setuid/setgid bits: droppin=
g
> +        * ATTR_MODE here would leave those bits set on the server after =
a
> +        * write, which is a security issue.
> +        */
>
>         args =3D kmalloc_obj(*args);
>         if (args =3D=3D NULL) {
> @@ -3400,8 +3404,23 @@ cifs_setattr_nounix(struct dentry *direntry, struc=
t iattr *attrs)
>                 attrs->ia_valid &=3D ~(ATTR_UID | ATTR_GID);
>         }
>
> -       /* skip mode change if it's just for clearing setuid/setgid */
> -       if (attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
> +       /*
> +        * Skip the mode change if it is only being done to clear the
> +        * setuid/setgid bits *and* the mode is emulated via the DOS
> +        * read-only attribute (the default, non-ACL case), which cannot
> +        * represent the setuid/setgid bits anyway.
> +        *
> +        * When the mode is instead stored on the server - i.e. with the
> +        * cifsacl or modefromsid mount options (via an ACL) or with the
> +        * SMB3.1.1 POSIX extensions - the cleared mode must be pushed to
> +        * the server.  Dropping ATTR_MODE here would leave the setuid/
> +        * setgid bit set on the server after a write, which is a securit=
y
> +        * issue (the bits are not stripped as they are on local
> +        * filesystems).
> +        */
> +       if ((attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID)) &&
> +           !((sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)=
) ||
> +             cifs_sb_master_tcon(cifs_sb)->posix_extensions))
>                 attrs->ia_valid &=3D ~ATTR_MODE;
>
>         if (attrs->ia_valid & ATTR_MODE) {
> --
> 2.25.1
>
>


--=20
Thanks,

Steve
