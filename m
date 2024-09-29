Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE45FDA7;
	Sun, 29 Sep 2024 21:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727646876; cv=none; b=c1XDZOrOZWcqySHacP9m0yf786q27RRAzla05mBMQxFg+30VmWioZ+OCy07vsWEgTl1T9/rivdtLctMd9m4krwVtkK7pi6JZPLizDNJzyTVcyx96f4pC4Ra5LAKZe/LZOSbp6kWwJnkXVRUYEVlUayRpePYzgNNjoqrE0ni5GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727646876; c=relaxed/simple;
	bh=4EXyjx0BtDEYzpgZeHi7LSBMQBV74puqcA3Ii/KXx24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xkq2YGCmQMK/fEXYgoFsI3Q90tld99SbSxCv2dNBhhahdWHTjiag9Nz9TQtMXno6dbJ86mQ28ug1JBMMf+1Swx/9+rzCMKXPTnIHkNNRt+zlMkQN3wX7m2UaGORuUsh9nL81eqdzpx7+06dCN3aDQyckY3xvA8qzOGAJBMZ8yJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kc2dWdA+; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kc2dWdA+"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5389e24a4d1so3156331e87.3;
        Sun, 29 Sep 2024 14:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727646872; x=1728251672; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XttYWPhjUs17rBo7xGzGiAD7d2sc6qPPafyCL8FUmtA=;
        b=kc2dWdA+v7U0A3H5vv79t1ll59Wjs/Il5WuDVFIRsW8W1VocbrAHNBVSaEenRWeH/x
         fTqEi8muzc2YJgSYG8W308ZHgrKwYXhyrKJbMKQfNVD6pGtokgDaX1hD/QjTGRNiuzf7
         hKl8mIc/rQ1doYGLhzAsZPfZxIZWZEWS1OA4NfRnmLjye+OCdEBNWzMYHzhokfUI4Flk
         9dAcQDGWVtepAL7yYcTz8Eg5lvBDu88jF9TdLxUPI+lSDsTaU5daFlPdhzNk/9FB8AB6
         /3tf9mejbTAt7mC4kLE2+CGhShqq67ri+yHlD7TARvukHBw/Cid1NwdbBe1tMDPxzuh0
         eZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727646872; x=1728251672;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XttYWPhjUs17rBo7xGzGiAD7d2sc6qPPafyCL8FUmtA=;
        b=f1uHsZpDcaYS6JNj2j80Eufv+B6hZ8NIfyme3/7fvDhkkrnm62dd7e44v7iKXnbQI4
         8Tc8eu4AuJP8FKrriPFShMBE4rW+OTcHe/OPNEvo7fDWvugx7pIGN8biEFXFhNpTkHCX
         royQUT8T3r0VSguyPJdcDdZkzcHIEzMjzMw/M6mHqXKuvn6KBPJTWhOYJDthczm9/f4F
         TY+KihvU8h47DYnv2kkWd/+Q0JnZLK+zwGt1NfcbO+IVPlnj6sDMZQhzPy/8J5X6rLLr
         UlAoJogtJwtYRo+GeYDQTQMTqCCDm3TYAH38sC/52yDl3/v7nle3uOhws+Qbe+pEjkTq
         QHkg==
X-Forwarded-Encrypted: i=1; AJvYcCUP0xSmWlXavK4lpoBpxEl4cqs3Rf7gT+iy90mlHQA/Gyg9Vid1msnjUSWCe3VWbRWw9etPbtN+Xk+uquPb@vger.kernel.org, AJvYcCXgD+8c8ZxMGNFTo9/oK+cf0DoGqnNO2/qn2wyEzzIUxpVmV1qwrxRpe9W5lPf1hbF5xOVJk8uEzOxs@vger.kernel.org
X-Gm-Message-State: AOJu0YyENa9okfSdRL/XnyCsz/AFVza1X+SNB8P4R2E/JDR5AracIvzb
	0BhEcV4qQlaW+bn8K34wtOIHkLO+mfKufP5YYUzi5YIPuzTbuRv91oZP3AtIudvjR8VLoIwHZEj
	E216sikkzaJgUOhimF0WWgmkIO7E=
X-Google-Smtp-Source: AGHT+IERQ8hnerV6Y4gR7EfazWd7CWku/ORyluzxAvgr60QwpolUGHAoJsFQup/qWZ1p0k7C06bXruMqx67N9NU7+9w=
X-Received: by 2002:a05:6512:ad2:b0:52f:89aa:c344 with SMTP id
 2adb3069b0e04-5389fc3c23dmr5311826e87.16.1727646871956; Sun, 29 Sep 2024
 14:54:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20240929185053.10554-3-pali@kernel.org>
In-Reply-To: <20240929185053.10554-3-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 16:54:20 -0500
Message-ID: <CAH2r5muBtrnwm4YXm_DuncR7bK68xwY3OP2GwV07-LEm-BPWTw@mail.gmail.com>
Subject: Re: [PATCH 2/7] cifs: Improve creating native symlinks pointing to directory
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000019e8290623492286"

--00000000000019e8290623492286
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is a version of the same patch without the function rename (so
presumably easier to backport) and also that fixes to minor checkpatch
warnings (and merged this and also patches 3, 4 and 6 into
cifs-2.6.git for-next pending additional review and tesitng):


On Sun, Sep 29, 2024 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> SMB protocol for native symlinks distinguish between symlink to directory
> and symlink to file. These two symlink types cannot be exchanged, which
> means that symlink of file type pointing to directory cannot be resolved =
at
> all (and vice-versa).
>
> Windows follows this rule for local filesystems (NTFS) and also for SMB.
>
> Linux SMB client currenly creates all native symlinks of file type. Which
> means that Windows (and some other SMB clients) cannot resolve symlinks
> pointing to directory created by Linux SMB client.
>
> As Linux system does not distinguish between directory and file symlinks,
> its API does not provide enough information for Linux SMB client during
> creating of native symlinks.
>
> Add some heuristic into the Linux SMB client for choosing the correct
> symlink type during symlink creation. Check if the symlink target locatio=
n
> ends with slash, or last path component is dot or dot dot, and check if t=
he
> target location on SMB share exists and is a directory. If at least one
> condition is truth then create a new SMB symlink of directory type.
> Otherwise create it as file type symlink.
>
> This change improves interoperability with Windows systems. Windows syste=
ms
> would be able to resolve more SMB symlinks created by Linux SMB client
> which points to existing directory.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c   | 131 ++++++++++++++++++++++++++++++++++++--
>  fs/smb/client/smb2inode.c |   3 +-
>  fs/smb/client/smb2proto.h |   1 +
>  3 files changed, 130 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 507e17244ed3..9390ab801696 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -24,13 +24,16 @@ int smb2_create_reparse_symlink(const unsigned int xi=
d, struct inode *inode,
>         struct inode *new;
>         struct kvec iov;
>         __le16 *path;
> +       bool directory =3D false;
>         char *sym, sep =3D CIFS_DIR_SEP(cifs_sb);
>         u16 len, plen;
>         int rc =3D 0;
>
> -       sym =3D kstrdup(symname, GFP_KERNEL);
> +       len =3D strlen(symname)+1;
> +       sym =3D kzalloc(len+1, GFP_KERNEL); /* +1 for possible directory =
slash */
>         if (!sym)
>                 return -ENOMEM;
> +       memcpy(sym, symname, len);
>
>         data =3D (struct cifs_open_info_data) {
>                 .reparse_point =3D true,
> @@ -45,6 +48,125 @@ int smb2_create_reparse_symlink(const unsigned int xi=
d, struct inode *inode,
>                 goto out;
>         }
>
> +       /*
> +        * SMB distinguish between symlink to directory and symlink to fi=
le.
> +        * They cannot be exchanged (symlink of file type which points to
> +        * directory cannot be resolved and vice-versa). First do some si=
mple
> +        * check, if the original Linux symlink target ends with slash, o=
r
> +        * last path component is dot or dot dot then it is for sure syml=
ink
> +        * to the directory.
> +        */
> +       if (!directory) {
> +               const char *basename =3D kbasename(symname);
> +               int basename_len =3D strlen(basename);
> +               if (basename_len =3D=3D 0 || /* symname ends with slash *=
/
> +                   (basename_len =3D=3D 1 && basename[0] =3D=3D '.') || =
/* last component is "." */
> +                   (basename_len =3D=3D 2 && basename[0] =3D=3D '.' && b=
asename[1] =3D=3D '.')) /* last component is ".." */
> +                       directory =3D true;
> +       }
> +
> +       /*
> +        * If it was not detected as directory yet and the symlink is rel=
ative
> +        * then try to resolve the path on the SMB server, check if the p=
ath
> +        * exists and determinate if it is a directory or not.
> +        */
> +       if (!directory && symname[0] !=3D '/') {
> +               __u32 oplock;
> +               struct tcon_link *tlink;
> +               struct cifs_tcon *tcon;
> +               struct cifs_fid fid;
> +               struct cifs_open_parms oparms;
> +               char *resolved_path;
> +               char *path_sep;
> +               int open_rc;
> +               int full_path_len =3D strlen(full_path);
> +               int symname_len =3D strlen(symname);
> +
> +               tlink =3D cifs_sb_tlink(cifs_sb);
> +               if (IS_ERR(tlink)) {
> +                       rc =3D PTR_ERR(tlink);
> +                       goto out;
> +               }
> +
> +               resolved_path =3D kzalloc(full_path_len + symname_len + 1=
, GFP_KERNEL);
> +               if (!resolved_path) {
> +                       rc =3D -ENOMEM;
> +                       goto out;
> +               }
> +
> +               /*
> +                * Compose the resolved SMB symlink path from the SMB ful=
l path
> +                * and Linux target symlink path.
> +                */
> +               memcpy(resolved_path, full_path, full_path_len+1);
> +               path_sep =3D strrchr(resolved_path, sep);
> +               if (path_sep)
> +                       path_sep++;
> +               else
> +                       path_sep =3D resolved_path;
> +               memcpy(path_sep, symname, symname_len+1);
> +               if (sep =3D=3D '\\')
> +                       convert_delimiter(path_sep, sep);
> +
> +               tcon =3D tlink_tcon(tlink);
> +
> +               oparms =3D (struct cifs_open_parms) {
> +                       .tcon =3D tcon,
> +                       .cifs_sb =3D cifs_sb,
> +                       .desired_access =3D FILE_READ_ATTRIBUTES,
> +                       .disposition =3D FILE_OPEN,
> +                       .path =3D resolved_path,
> +                       .fid =3D &fid,
> +               };
> +
> +               /* Try to open as NOT_FILE */
> +               oplock =3D 0;
> +               oparms.create_options =3D cifs_create_options(cifs_sb, CR=
EATE_NOT_FILE);
> +               open_rc =3D tcon->ses->server->ops->open(xid, &oparms, &o=
plock, NULL);
> +               if (open_rc =3D=3D 0) {
> +                       /* Successful open means that the target path is =
definitely a directory. */
> +                       directory =3D true;
> +                       tcon->ses->server->ops->close(xid, tcon, &fid);
> +               } else if (open_rc !=3D -ENOTDIR) {
> +                       /* Try to open as NOT_DIR */
> +                       oplock =3D 0;
> +                       oparms.create_options =3D cifs_create_options(cif=
s_sb, CREATE_NOT_DIR);
> +                       open_rc =3D tcon->ses->server->ops->open(xid, &op=
arms, &oplock, NULL);
> +                       if (open_rc =3D=3D 0) {
> +                               tcon->ses->server->ops->close(xid, tcon, =
&fid);
> +                       } else if (open_rc =3D=3D -EISDIR) {
> +                               /* -EISDIR means that the target path is =
definitely a directory. */
> +                               directory =3D true;
> +                       } else {
> +                               cifs_dbg(FYI,
> +                                        "%s: cannot determinate if the s=
ymlink target path '%s' "
> +                                        "is directory or not, creating '=
%s' as file symlink\n",
> +                                        __func__, symname, full_path);
> +                       }
> +               }
> +
> +               kfree(resolved_path);
> +               cifs_put_tlink(tlink);
> +       }
> +
> +       /*
> +        * For absolute symlinks it is not possible to determinate
> +        * if it should point to directory or file.
> +        */
> +       if (!directory && symname[0] =3D=3D '/')
> +               cifs_dbg(FYI,
> +                        "%s: cannot determinate if the symlink target pa=
th '%s' "
> +                        "is directory or not, creating '%s' as file syml=
ink\n",
> +                        __func__, symname, full_path);
> +
> +       /* Ensure that directory symlink target in inode would have trail=
ing slash */
> +       len =3D strlen(data.symlink_target);
> +       if (directory && data.symlink_target[len-1] !=3D '/') {
> +               /* symlink_target has already preallocated one byte more =
*/
> +               data.symlink_target[len] =3D '/';
> +               data.symlink_target[len+1] =3D '\0';
> +       }
> +
>         plen =3D 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
>         len =3D sizeof(*buf) + plen * 2;
>         buf =3D kzalloc(len, GFP_KERNEL);
> @@ -69,7 +191,8 @@ int smb2_create_reparse_symlink(const unsigned int xid=
, struct inode *inode,
>         iov.iov_base =3D buf;
>         iov.iov_len =3D len;
>         new =3D smb2_create_reparse_inode(&data, inode->i_sb, xid,
> -                                    tcon, full_path, &iov, NULL);
> +                                       tcon, full_path, directory,
> +                                       &iov, NULL);
>         if (!IS_ERR(new))
>                 d_instantiate(dentry, new);
>         else
> @@ -137,7 +260,7 @@ static int mknod_nfs(unsigned int xid, struct inode *=
inode,
>         };
>
>         new =3D smb2_create_reparse_inode(&data, inode->i_sb, xid,
> -                                    tcon, full_path, &iov, NULL);
> +                                       tcon, full_path, false, &iov, NUL=
L);
>         if (!IS_ERR(new))
>                 d_instantiate(dentry, new);
>         else
> @@ -283,7 +406,7 @@ static int mknod_wsl(unsigned int xid, struct inode *=
inode,
>         data.wsl.eas_len =3D len;
>
>         new =3D smb2_create_reparse_inode(&data, inode->i_sb,
> -                                    xid, tcon, full_path,
> +                                       xid, tcon, full_path, false,
>                                      &reparse_iov, &xattr_iov);
>         if (!IS_ERR(new))
>                 d_instantiate(dentry, new);
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 0fc73035d6dc..fffb9df4faeb 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1198,6 +1198,7 @@ struct inode *smb2_create_reparse_inode(struct cifs=
_open_info_data *data,
>                                      const unsigned int xid,
>                                      struct cifs_tcon *tcon,
>                                      const char *full_path,
> +                                    bool directory,
>                                      struct kvec *reparse_iov,
>                                      struct kvec *xattr_iov)
>  {
> @@ -1217,7 +1218,7 @@ struct inode *smb2_create_reparse_inode(struct cifs=
_open_info_data *data,
>                              FILE_READ_ATTRIBUTES |
>                              FILE_WRITE_ATTRIBUTES,
>                              FILE_CREATE,
> -                            CREATE_NOT_DIR | OPEN_REPARSE_POINT,
> +                            (directory ? CREATE_NOT_FILE : CREATE_NOT_DI=
R) | OPEN_REPARSE_POINT,
>                              ACL_NO_MODE);
>         if (xattr_iov)
>                 oparms.ea_cctx =3D xattr_iov;
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 4ac30d29d5a1..fd092f2bb8c5 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -61,6 +61,7 @@ struct inode *smb2_create_reparse_inode(struct cifs_ope=
n_info_data *data,
>                                      const unsigned int xid,
>                                      struct cifs_tcon *tcon,
>                                      const char *full_path,
> +                                    bool directory,
>                                      struct kvec *reparse_iov,
>                                      struct kvec *xattr_iov);
>  int smb2_query_reparse_point(const unsigned int xid,
> --
> 2.20.1
>
>


--=20
Thanks,

Steve

--00000000000019e8290623492286
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-cifs-Improve-creating-native-symlinks-pointing-to-di.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Improve-creating-native-symlinks-pointing-to-di.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m1o3ulmp0>
X-Attachment-Id: f_m1o3ulmp0

RnJvbSA3OWJjOGYxYTBkYTkzYTJiNmU5N2JhMmViNTU1NDZjMDhhMDFjMTY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UGFsaT0yMFJvaD1DMz1BMXI/PSA8cGFsaUBr
ZXJuZWwub3JnPgpEYXRlOiBTdW4sIDI5IFNlcCAyMDI0IDIwOjUwOjQ4ICswMjAwClN1YmplY3Q6
IFtQQVRDSF0gY2lmczogSW1wcm92ZSBjcmVhdGluZyBuYXRpdmUgc3ltbGlua3MgcG9pbnRpbmcg
dG8gZGlyZWN0b3J5Ck1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsg
Y2hhcnNldD1VVEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpTTUIgcHJvdG9j
b2wgZm9yIG5hdGl2ZSBzeW1saW5rcyBkaXN0aW5ndWlzaCBiZXR3ZWVuIHN5bWxpbmsgdG8gZGly
ZWN0b3J5CmFuZCBzeW1saW5rIHRvIGZpbGUuIFRoZXNlIHR3byBzeW1saW5rIHR5cGVzIGNhbm5v
dCBiZSBleGNoYW5nZWQsIHdoaWNoCm1lYW5zIHRoYXQgc3ltbGluayBvZiBmaWxlIHR5cGUgcG9p
bnRpbmcgdG8gZGlyZWN0b3J5IGNhbm5vdCBiZSByZXNvbHZlZCBhdAphbGwgKGFuZCB2aWNlLXZl
cnNhKS4KCldpbmRvd3MgZm9sbG93cyB0aGlzIHJ1bGUgZm9yIGxvY2FsIGZpbGVzeXN0ZW1zIChO
VEZTKSBhbmQgYWxzbyBmb3IgU01CLgoKTGludXggU01CIGNsaWVudCBjdXJyZW5seSBjcmVhdGVz
IGFsbCBuYXRpdmUgc3ltbGlua3Mgb2YgZmlsZSB0eXBlLiBXaGljaAptZWFucyB0aGF0IFdpbmRv
d3MgKGFuZCBzb21lIG90aGVyIFNNQiBjbGllbnRzKSBjYW5ub3QgcmVzb2x2ZSBzeW1saW5rcwpw
b2ludGluZyB0byBkaXJlY3RvcnkgY3JlYXRlZCBieSBMaW51eCBTTUIgY2xpZW50LgoKQXMgTGlu
dXggc3lzdGVtIGRvZXMgbm90IGRpc3Rpbmd1aXNoIGJldHdlZW4gZGlyZWN0b3J5IGFuZCBmaWxl
IHN5bWxpbmtzLAppdHMgQVBJIGRvZXMgbm90IHByb3ZpZGUgZW5vdWdoIGluZm9ybWF0aW9uIGZv
ciBMaW51eCBTTUIgY2xpZW50IGR1cmluZwpjcmVhdGluZyBvZiBuYXRpdmUgc3ltbGlua3MuCgpB
ZGQgc29tZSBoZXVyaXN0aWMgaW50byB0aGUgTGludXggU01CIGNsaWVudCBmb3IgY2hvb3Npbmcg
dGhlIGNvcnJlY3QKc3ltbGluayB0eXBlIGR1cmluZyBzeW1saW5rIGNyZWF0aW9uLiBDaGVjayBp
ZiB0aGUgc3ltbGluayB0YXJnZXQgbG9jYXRpb24KZW5kcyB3aXRoIHNsYXNoLCBvciBsYXN0IHBh
dGggY29tcG9uZW50IGlzIGRvdCBvciBkb3QgZG90LCBhbmQgY2hlY2sgaWYgdGhlCnRhcmdldCBs
b2NhdGlvbiBvbiBTTUIgc2hhcmUgZXhpc3RzIGFuZCBpcyBhIGRpcmVjdG9yeS4gSWYgYXQgbGVh
c3Qgb25lCmNvbmRpdGlvbiBpcyB0cnV0aCB0aGVuIGNyZWF0ZSBhIG5ldyBTTUIgc3ltbGluayBv
ZiBkaXJlY3RvcnkgdHlwZS4KT3RoZXJ3aXNlIGNyZWF0ZSBpdCBhcyBmaWxlIHR5cGUgc3ltbGlu
ay4KClRoaXMgY2hhbmdlIGltcHJvdmVzIGludGVyb3BlcmFiaWxpdHkgd2l0aCBXaW5kb3dzIHN5
c3RlbXMuIFdpbmRvd3Mgc3lzdGVtcwp3b3VsZCBiZSBhYmxlIHRvIHJlc29sdmUgbW9yZSBTTUIg
c3ltbGlua3MgY3JlYXRlZCBieSBMaW51eCBTTUIgY2xpZW50CndoaWNoIHBvaW50cyB0byBleGlz
dGluZyBkaXJlY3RvcnkuCgpTaWduZWQtb2ZmLWJ5OiBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwu
b3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
Ci0tLQogZnMvc21iL2NsaWVudC9yZXBhcnNlLmMgICB8IDEzMiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKystLQogZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYyB8ICAgMyArLQog
ZnMvc21iL2NsaWVudC9zbWIycHJvdG8uaCB8ICAgMSArCiAzIGZpbGVzIGNoYW5nZWQsIDEzMSBp
bnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQv
cmVwYXJzZS5jIGIvZnMvc21iL2NsaWVudC9yZXBhcnNlLmMKaW5kZXggYzg0OGI1ZTg4ZDMyLi40
ZmFlNGU3MzQzZTYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvcmVwYXJzZS5jCisrKyBiL2Zz
L3NtYi9jbGllbnQvcmVwYXJzZS5jCkBAIC0yNCwxMyArMjQsMTYgQEAgaW50IHNtYjJfY3JlYXRl
X3JlcGFyc2Vfc3ltbGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgaW5vZGUgKmlu
b2RlLAogCXN0cnVjdCBpbm9kZSAqbmV3OwogCXN0cnVjdCBrdmVjIGlvdjsKIAlfX2xlMTYgKnBh
dGg7CisJYm9vbCBkaXJlY3RvcnkgPSBmYWxzZTsKIAljaGFyICpzeW0sIHNlcCA9IENJRlNfRElS
X1NFUChjaWZzX3NiKTsKIAl1MTYgbGVuLCBwbGVuOwogCWludCByYyA9IDA7CiAKLQlzeW0gPSBr
c3RyZHVwKHN5bW5hbWUsIEdGUF9LRVJORUwpOworCWxlbiA9IHN0cmxlbihzeW1uYW1lKSsxOwor
CXN5bSA9IGt6YWxsb2MobGVuKzEsIEdGUF9LRVJORUwpOyAvKiArMSBmb3IgcG9zc2libGUgZGly
ZWN0b3J5IHNsYXNoICovCiAJaWYgKCFzeW0pCiAJCXJldHVybiAtRU5PTUVNOworCW1lbWNweShz
eW0sIHN5bW5hbWUsIGxlbik7CiAKIAlkYXRhID0gKHN0cnVjdCBjaWZzX29wZW5faW5mb19kYXRh
KSB7CiAJCS5yZXBhcnNlX3BvaW50ID0gdHJ1ZSwKQEAgLTQ1LDYgKzQ4LDEyNiBAQCBpbnQgc21i
Ml9jcmVhdGVfcmVwYXJzZV9zeW1saW5rKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBp
bm9kZSAqaW5vZGUsCiAJCWdvdG8gb3V0OwogCX0KIAorCS8qCisJICogU01CIGRpc3Rpbmd1aXNo
IGJldHdlZW4gc3ltbGluayB0byBkaXJlY3RvcnkgYW5kIHN5bWxpbmsgdG8gZmlsZS4KKwkgKiBU
aGV5IGNhbm5vdCBiZSBleGNoYW5nZWQgKHN5bWxpbmsgb2YgZmlsZSB0eXBlIHdoaWNoIHBvaW50
cyB0bworCSAqIGRpcmVjdG9yeSBjYW5ub3QgYmUgcmVzb2x2ZWQgYW5kIHZpY2UtdmVyc2EpLiBG
aXJzdCBkbyBzb21lIHNpbXBsZQorCSAqIGNoZWNrLCBpZiB0aGUgb3JpZ2luYWwgTGludXggc3lt
bGluayB0YXJnZXQgZW5kcyB3aXRoIHNsYXNoLCBvcgorCSAqIGxhc3QgcGF0aCBjb21wb25lbnQg
aXMgZG90IG9yIGRvdCBkb3QgdGhlbiBpdCBpcyBmb3Igc3VyZSBzeW1saW5rCisJICogdG8gdGhl
IGRpcmVjdG9yeS4KKwkgKi8KKwlpZiAoIWRpcmVjdG9yeSkgeworCQljb25zdCBjaGFyICpiYXNl
bmFtZSA9IGtiYXNlbmFtZShzeW1uYW1lKTsKKwkJaW50IGJhc2VuYW1lX2xlbiA9IHN0cmxlbihi
YXNlbmFtZSk7CisKKwkJaWYgKGJhc2VuYW1lX2xlbiA9PSAwIHx8IC8qIHN5bW5hbWUgZW5kcyB3
aXRoIHNsYXNoICovCisJCSAgICAoYmFzZW5hbWVfbGVuID09IDEgJiYgYmFzZW5hbWVbMF0gPT0g
Jy4nKSB8fCAvKiBsYXN0IGNvbXBvbmVudCBpcyAiLiIgKi8KKwkJICAgIChiYXNlbmFtZV9sZW4g
PT0gMiAmJiBiYXNlbmFtZVswXSA9PSAnLicgJiYgYmFzZW5hbWVbMV0gPT0gJy4nKSkgLyogb3Ig
Ii4uIiAqLworCQkJZGlyZWN0b3J5ID0gdHJ1ZTsKKwl9CisKKwkvKgorCSAqIElmIGl0IHdhcyBu
b3QgZGV0ZWN0ZWQgYXMgZGlyZWN0b3J5IHlldCBhbmQgdGhlIHN5bWxpbmsgaXMgcmVsYXRpdmUK
KwkgKiB0aGVuIHRyeSB0byByZXNvbHZlIHRoZSBwYXRoIG9uIHRoZSBTTUIgc2VydmVyLCBjaGVj
ayBpZiB0aGUgcGF0aAorCSAqIGV4aXN0cyBhbmQgZGV0ZXJtaW5hdGUgaWYgaXQgaXMgYSBkaXJl
Y3Rvcnkgb3Igbm90LgorCSAqLworCWlmICghZGlyZWN0b3J5ICYmIHN5bW5hbWVbMF0gIT0gJy8n
KSB7CisJCV9fdTMyIG9wbG9jazsKKwkJc3RydWN0IHRjb25fbGluayAqdGxpbms7CisJCXN0cnVj
dCBjaWZzX3Rjb24gKnRjb247CisJCXN0cnVjdCBjaWZzX2ZpZCBmaWQ7CisJCXN0cnVjdCBjaWZz
X29wZW5fcGFybXMgb3Bhcm1zOworCQljaGFyICpyZXNvbHZlZF9wYXRoOworCQljaGFyICpwYXRo
X3NlcDsKKwkJaW50IG9wZW5fcmM7CisJCWludCBmdWxsX3BhdGhfbGVuID0gc3RybGVuKGZ1bGxf
cGF0aCk7CisJCWludCBzeW1uYW1lX2xlbiA9IHN0cmxlbihzeW1uYW1lKTsKKworCQl0bGluayA9
IGNpZnNfc2JfdGxpbmsoY2lmc19zYik7CisJCWlmIChJU19FUlIodGxpbmspKSB7CisJCQlyYyA9
IFBUUl9FUlIodGxpbmspOworCQkJZ290byBvdXQ7CisJCX0KKworCQlyZXNvbHZlZF9wYXRoID0g
a3phbGxvYyhmdWxsX3BhdGhfbGVuICsgc3ltbmFtZV9sZW4gKyAxLCBHRlBfS0VSTkVMKTsKKwkJ
aWYgKCFyZXNvbHZlZF9wYXRoKSB7CisJCQlyYyA9IC1FTk9NRU07CisJCQlnb3RvIG91dDsKKwkJ
fQorCisJCS8qCisJCSAqIENvbXBvc2UgdGhlIHJlc29sdmVkIFNNQiBzeW1saW5rIHBhdGggZnJv
bSB0aGUgU01CIGZ1bGwgcGF0aAorCQkgKiBhbmQgTGludXggdGFyZ2V0IHN5bWxpbmsgcGF0aC4K
KwkJICovCisJCW1lbWNweShyZXNvbHZlZF9wYXRoLCBmdWxsX3BhdGgsIGZ1bGxfcGF0aF9sZW4r
MSk7CisJCXBhdGhfc2VwID0gc3RycmNocihyZXNvbHZlZF9wYXRoLCBzZXApOworCQlpZiAocGF0
aF9zZXApCisJCQlwYXRoX3NlcCsrOworCQllbHNlCisJCQlwYXRoX3NlcCA9IHJlc29sdmVkX3Bh
dGg7CisJCW1lbWNweShwYXRoX3NlcCwgc3ltbmFtZSwgc3ltbmFtZV9sZW4rMSk7CisJCWlmIChz
ZXAgPT0gJ1xcJykKKwkJCWNvbnZlcnRfZGVsaW1pdGVyKHBhdGhfc2VwLCBzZXApOworCisJCXRj
b24gPSB0bGlua190Y29uKHRsaW5rKTsKKworCQlvcGFybXMgPSAoc3RydWN0IGNpZnNfb3Blbl9w
YXJtcykgeworCQkJLnRjb24gPSB0Y29uLAorCQkJLmNpZnNfc2IgPSBjaWZzX3NiLAorCQkJLmRl
c2lyZWRfYWNjZXNzID0gRklMRV9SRUFEX0FUVFJJQlVURVMsCisJCQkuZGlzcG9zaXRpb24gPSBG
SUxFX09QRU4sCisJCQkucGF0aCA9IHJlc29sdmVkX3BhdGgsCisJCQkuZmlkID0gJmZpZCwKKwkJ
fTsKKworCQkvKiBUcnkgdG8gb3BlbiBhcyBOT1RfRklMRSAqLworCQlvcGxvY2sgPSAwOworCQlv
cGFybXMuY3JlYXRlX29wdGlvbnMgPSBjaWZzX2NyZWF0ZV9vcHRpb25zKGNpZnNfc2IsIENSRUFU
RV9OT1RfRklMRSk7CisJCW9wZW5fcmMgPSB0Y29uLT5zZXMtPnNlcnZlci0+b3BzLT5vcGVuKHhp
ZCwgJm9wYXJtcywgJm9wbG9jaywgTlVMTCk7CisJCWlmIChvcGVuX3JjID09IDApIHsKKwkJCS8q
IFN1Y2Nlc3NmdWwgb3BlbiBtZWFucyB0aGF0IHRoZSB0YXJnZXQgcGF0aCBpcyBkZWZpbml0ZWx5
IGEgZGlyZWN0b3J5LiAqLworCQkJZGlyZWN0b3J5ID0gdHJ1ZTsKKwkJCXRjb24tPnNlcy0+c2Vy
dmVyLT5vcHMtPmNsb3NlKHhpZCwgdGNvbiwgJmZpZCk7CisJCX0gZWxzZSBpZiAob3Blbl9yYyAh
PSAtRU5PVERJUikgeworCQkJLyogVHJ5IHRvIG9wZW4gYXMgTk9UX0RJUiAqLworCQkJb3Bsb2Nr
ID0gMDsKKwkJCW9wYXJtcy5jcmVhdGVfb3B0aW9ucyA9IGNpZnNfY3JlYXRlX29wdGlvbnMoY2lm
c19zYiwgQ1JFQVRFX05PVF9ESVIpOworCQkJb3Blbl9yYyA9IHRjb24tPnNlcy0+c2VydmVyLT5v
cHMtPm9wZW4oeGlkLCAmb3Bhcm1zLCAmb3Bsb2NrLCBOVUxMKTsKKwkJCWlmIChvcGVuX3JjID09
IDApIHsKKwkJCQl0Y29uLT5zZXMtPnNlcnZlci0+b3BzLT5jbG9zZSh4aWQsIHRjb24sICZmaWQp
OworCQkJfSBlbHNlIGlmIChvcGVuX3JjID09IC1FSVNESVIpIHsKKwkJCQkvKiAtRUlTRElSIG1l
YW5zIHRoYXQgdGhlIHRhcmdldCBwYXRoIGlzIGRlZmluaXRlbHkgYSBkaXJlY3RvcnkuICovCisJ
CQkJZGlyZWN0b3J5ID0gdHJ1ZTsKKwkJCX0gZWxzZSB7CisJCQkJY2lmc19kYmcoRllJLAorCQkJ
CQkgIiVzOiBjYW5ub3QgZGV0ZXJtaW5hdGUgaWYgdGhlIHN5bWxpbmsgdGFyZ2V0IHBhdGggJyVz
JyAiCisJCQkJCSAiaXMgZGlyZWN0b3J5IG9yIG5vdCwgY3JlYXRpbmcgJyVzJyBhcyBmaWxlIHN5
bWxpbmtcbiIsCisJCQkJCSBfX2Z1bmNfXywgc3ltbmFtZSwgZnVsbF9wYXRoKTsKKwkJCX0KKwkJ
fQorCisJCWtmcmVlKHJlc29sdmVkX3BhdGgpOworCQljaWZzX3B1dF90bGluayh0bGluayk7CisJ
fQorCisJLyoKKwkgKiBGb3IgYWJzb2x1dGUgc3ltbGlua3MgaXQgaXMgbm90IHBvc3NpYmxlIHRv
IGRldGVybWluYXRlCisJICogaWYgaXQgc2hvdWxkIHBvaW50IHRvIGRpcmVjdG9yeSBvciBmaWxl
LgorCSAqLworCWlmICghZGlyZWN0b3J5ICYmIHN5bW5hbWVbMF0gPT0gJy8nKQorCQljaWZzX2Ri
ZyhGWUksCisJCQkgIiVzOiBjYW5ub3QgZGV0ZXJtaW5hdGUgaWYgdGhlIHN5bWxpbmsgdGFyZ2V0
IHBhdGggJyVzJyAiCisJCQkgImlzIGRpcmVjdG9yeSBvciBub3QsIGNyZWF0aW5nICclcycgYXMg
ZmlsZSBzeW1saW5rXG4iLAorCQkJIF9fZnVuY19fLCBzeW1uYW1lLCBmdWxsX3BhdGgpOworCisJ
LyogRW5zdXJlIHRoYXQgZGlyZWN0b3J5IHN5bWxpbmsgdGFyZ2V0IGluIGlub2RlIHdvdWxkIGhh
dmUgdHJhaWxpbmcgc2xhc2ggKi8KKwlsZW4gPSBzdHJsZW4oZGF0YS5zeW1saW5rX3RhcmdldCk7
CisJaWYgKGRpcmVjdG9yeSAmJiBkYXRhLnN5bWxpbmtfdGFyZ2V0W2xlbi0xXSAhPSAnLycpIHsK
KwkJLyogc3ltbGlua190YXJnZXQgaGFzIGFscmVhZHkgcHJlYWxsb2NhdGVkIG9uZSBieXRlIG1v
cmUgKi8KKwkJZGF0YS5zeW1saW5rX3RhcmdldFtsZW5dID0gJy8nOworCQlkYXRhLnN5bWxpbmtf
dGFyZ2V0W2xlbisxXSA9ICdcMCc7CisJfQorCiAJcGxlbiA9IDIgKiBVbmlTdHJubGVuKCh3Y2hh
cl90ICopcGF0aCwgUEFUSF9NQVgpOwogCWxlbiA9IHNpemVvZigqYnVmKSArIHBsZW4gKiAyOwog
CWJ1ZiA9IGt6YWxsb2MobGVuLCBHRlBfS0VSTkVMKTsKQEAgLTY5LDcgKzE5Miw4IEBAIGludCBz
bWIyX2NyZWF0ZV9yZXBhcnNlX3N5bWxpbmsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGlub2RlICppbm9kZSwKIAlpb3YuaW92X2Jhc2UgPSBidWY7CiAJaW92Lmlvdl9sZW4gPSBsZW47
CiAJbmV3ID0gc21iMl9nZXRfcmVwYXJzZV9pbm9kZSgmZGF0YSwgaW5vZGUtPmlfc2IsIHhpZCwK
LQkJCQkgICAgIHRjb24sIGZ1bGxfcGF0aCwgJmlvdiwgTlVMTCk7CisJCQkJCXRjb24sIGZ1bGxf
cGF0aCwgZGlyZWN0b3J5LAorCQkJCQkmaW92LCBOVUxMKTsKIAlpZiAoIUlTX0VSUihuZXcpKQog
CQlkX2luc3RhbnRpYXRlKGRlbnRyeSwgbmV3KTsKIAllbHNlCkBAIC0xMzcsNyArMjYxLDcgQEAg
c3RhdGljIGludCBta25vZF9uZnModW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGlub2RlICppbm9k
ZSwKIAl9OwogCiAJbmV3ID0gc21iMl9nZXRfcmVwYXJzZV9pbm9kZSgmZGF0YSwgaW5vZGUtPmlf
c2IsIHhpZCwKLQkJCQkgICAgIHRjb24sIGZ1bGxfcGF0aCwgJmlvdiwgTlVMTCk7CisJCQkJCXRj
b24sIGZ1bGxfcGF0aCwgZmFsc2UsICZpb3YsIE5VTEwpOwogCWlmICghSVNfRVJSKG5ldykpCiAJ
CWRfaW5zdGFudGlhdGUoZGVudHJ5LCBuZXcpOwogCWVsc2UKQEAgLTI4Myw3ICs0MDcsNyBAQCBz
dGF0aWMgaW50IG1rbm9kX3dzbCh1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgaW5vZGUgKmlub2Rl
LAogCWRhdGEud3NsLmVhc19sZW4gPSBsZW47CiAKIAluZXcgPSBzbWIyX2dldF9yZXBhcnNlX2lu
b2RlKCZkYXRhLCBpbm9kZS0+aV9zYiwKLQkJCQkgICAgIHhpZCwgdGNvbiwgZnVsbF9wYXRoLAor
CQkJCQl4aWQsIHRjb24sIGZ1bGxfcGF0aCwgZmFsc2UsCiAJCQkJICAgICAmcmVwYXJzZV9pb3Ys
ICZ4YXR0cl9pb3YpOwogCWlmICghSVNfRVJSKG5ldykpCiAJCWRfaW5zdGFudGlhdGUoZGVudHJ5
LCBuZXcpOwpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIyaW5vZGUuYyBiL2ZzL3NtYi9j
bGllbnQvc21iMmlub2RlLmMKaW5kZXggMDVkZjdhYjdkZmVkLi5jNzFkODZkYjhiYTYgMTAwNjQ0
Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMmlub2RlLmMKKysrIGIvZnMvc21iL2NsaWVudC9zbWIy
aW5vZGUuYwpAQCAtMTE5OCw2ICsxMTk4LDcgQEAgc3RydWN0IGlub2RlICpzbWIyX2dldF9yZXBh
cnNlX2lub2RlKHN0cnVjdCBjaWZzX29wZW5faW5mb19kYXRhICpkYXRhLAogCQkJCSAgICAgY29u
c3QgdW5zaWduZWQgaW50IHhpZCwKIAkJCQkgICAgIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CQkJICAgICBjb25zdCBjaGFyICpmdWxsX3BhdGgsCisJCQkJICAgICBib29sIGRpcmVjdG9yeSwK
IAkJCQkgICAgIHN0cnVjdCBrdmVjICpyZXBhcnNlX2lvdiwKIAkJCQkgICAgIHN0cnVjdCBrdmVj
ICp4YXR0cl9pb3YpCiB7CkBAIC0xMjE3LDcgKzEyMTgsNyBAQCBzdHJ1Y3QgaW5vZGUgKnNtYjJf
Z2V0X3JlcGFyc2VfaW5vZGUoc3RydWN0IGNpZnNfb3Blbl9pbmZvX2RhdGEgKmRhdGEsCiAJCQkg
ICAgIEZJTEVfUkVBRF9BVFRSSUJVVEVTIHwKIAkJCSAgICAgRklMRV9XUklURV9BVFRSSUJVVEVT
LAogCQkJICAgICBGSUxFX0NSRUFURSwKLQkJCSAgICAgQ1JFQVRFX05PVF9ESVIgfCBPUEVOX1JF
UEFSU0VfUE9JTlQsCisJCQkgICAgIChkaXJlY3RvcnkgPyBDUkVBVEVfTk9UX0ZJTEUgOiBDUkVB
VEVfTk9UX0RJUikgfCBPUEVOX1JFUEFSU0VfUE9JTlQsCiAJCQkgICAgIEFDTF9OT19NT0RFKTsK
IAlpZiAoeGF0dHJfaW92KQogCQlvcGFybXMuZWFfY2N0eCA9IHhhdHRyX2lvdjsKZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvc21iMnByb3RvLmggYi9mcy9zbWIvY2xpZW50L3NtYjJwcm90by5o
CmluZGV4IDU2YTg5NmZmN2NkOS4uYWUxYTc2NmFmNjY0IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L3NtYjJwcm90by5oCisrKyBiL2ZzL3NtYi9jbGllbnQvc21iMnByb3RvLmgKQEAgLTYxLDYg
KzYxLDcgQEAgc3RydWN0IGlub2RlICpzbWIyX2dldF9yZXBhcnNlX2lub2RlKHN0cnVjdCBjaWZz
X29wZW5faW5mb19kYXRhICpkYXRhLAogCQkJCSAgICAgY29uc3QgdW5zaWduZWQgaW50IHhpZCwK
IAkJCQkgICAgIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkJICAgICBjb25zdCBjaGFyICpm
dWxsX3BhdGgsCisJCQkJICAgICBib29sIGRpcmVjdG9yeSwKIAkJCQkgICAgIHN0cnVjdCBrdmVj
ICpyZXBhcnNlX2lvdiwKIAkJCQkgICAgIHN0cnVjdCBrdmVjICp4YXR0cl9pb3YpOwogaW50IHNt
YjJfcXVlcnlfcmVwYXJzZV9wb2ludChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLAotLSAKMi40My4w
Cgo=
--00000000000019e8290623492286--
