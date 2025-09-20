Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847222EF655
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758389709; cv=none; b=k2heua7KLWDY8R6WIRdVDAvqok6DibQe8/4i+AFgnAf4pVDCa1Q5a6bQFyxAMgvV1KKj87QAKHPx7i07w56N4zXdKOgjIeRrjOXDgOr36UIc8dpuoavNvuwNKbMbF6tLWII90JhwRUweWa8OeePqYSjUd7692g6XXU1Cib5cPcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758389709; c=relaxed/simple;
	bh=r0sD7vHdwzMkGWFp9VPJgEztFbndoRVr1/oAoAgujwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GvMrRrlmJfSGFcIlyICdZlz9hbzE/HCbOS2uBtklVGDCDCW3ycnHSqpjjCGIY2Pg7xOMoc4oNcN7upPAa7Kcw8Y0UwUq3/4urFKDrn3RSJsgB7RsEk08GfsEmlZcHq+BFfLw5fmDkDUW+WD77xn4WUGG8MlYzEyj8XayjJr25Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WmrHKZU/; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmrHKZU/"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-796fe71deecso23823196d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758389706; x=1758994506; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEXA6XwjOlpHyWHsqL4//akA4zcpe9pStiQsaABM5CY=;
        b=WmrHKZU/yL0UG6Ji+Jmj1GL55+1uz++1ujglwAoXgV42s/RJTFwNpNFG6E/BBHzfUD
         O+DpAbqedwpnzNL0H+Fztf6hR1dgE9dZ37oxmExxcoQ08FnTSKXvltiMxoFg4c+tesNu
         qW4mp2WtkVBHt8dgvSrDIljjIIt9iscqggYFWQd13IZKoFKxjCR+PpZWeWoc86JGTK5v
         KqK2OOZlk3ROwNwcYNhrP7RvmbO7Iogl4IHhte5F/bxJK/XN1+esDy8Q/DbwiyXoCYZV
         hnb3EzNWsz6yALls/5SE6F3TbuDgDXKTss1kXGhy3d6SUT0BR5ApYDTJgyVffpVhbvZb
         F/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758389706; x=1758994506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nEXA6XwjOlpHyWHsqL4//akA4zcpe9pStiQsaABM5CY=;
        b=R0j0RaUcImdu37jHwvVkCDR5oGwHaexz8e2D9n420SPznJiscHFbqqCVqFfHpvP9oK
         b+YBWqRg8FVhuJwmhXxCaTyEzgYn4EY7o6daPHZbZQbt/7/bDv6XF/a3fIg2iehADsQG
         +oF2hUSzLTEciXZYIONy0Xl+IRiDHIILJtnVtoZKCz1l2LYw57IWRxw1PTwR9WRd6+bi
         zD7UlmNx4u1TmK4lPwf45YTS2oBKKXhSe5EOJsb+XJ2cIfpYKC8wDcECfTD8AZ7LcKpY
         g6YUEabTkpDmHWcGT/chH6NEpZo0lkhtJnOliHoSXf4n/8T42KKePZBqAQws1AIs5Nsy
         HzyA==
X-Forwarded-Encrypted: i=1; AJvYcCXGuUGO4o5iTOZg7qMezdinYtZVRyig5wIH2HsAQILHy086FCCh/V7UjQnnlkbqikVGU48wZfWbSnW6@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdtg8PnP3OQKMz0sqLtbP/BEgXdZ8kO60DMubyCJWLck2S3VST
	nlJWFlc5pJK3Iy63heTFnT4F86lKSELRzKkfn0zMWsnYktaCCPBGS7FO0qR9anLX0unVEYsXlap
	Ys+uu+DB3FAwKsQuaToKejpZPjHrxVowSiA==
X-Gm-Gg: ASbGncvj4/GR8nL+BdK3/Kuu5JdwX6b0JEx3579S00U4/qODim2IlFI/GQhzR063NLR
	zI/ZmO9rda7Q9ibhb+iw/AMmdWRty9v0pAwARywwf4cC6bhPT3kyvU5oPnKFbzTTa/ZP1TCp3uz
	3JPdJjhWrqxJyQze3X+Tt7MAABHdh1HrP08xqaD1zZumUe0nV1zlNZWx9YfXmBAjqJDxQIl3xn5
	6jWvamZmqjqtDrVgExRtFhL23wc0nDP4wBoNHxthilCapaeWzhMIQT1Clli7Q2mS1HD+bxq3whv
	KAw9ar+thrQaI9/WWOT7u6ZzmgZqU8R+RKTqmNNwT90sOrsfzMKLlYVNyvlC9Q1oCCiBYSKsuif
	v1dc7SQ/xffo4e8sxlUCT
X-Google-Smtp-Source: AGHT+IFfmnKfbppGGILzMZLy6rG5Pskfs2bEXtk5bkqnUos2ZpPqrt4huyk0t8rYA4hidz09veZOrWIZAjE5k2YoSqc=
X-Received: by 2002:ad4:5f88:0:b0:77c:a783:c9c6 with SMTP id
 6a1803df08f44-79910d9c010mr76143506d6.3.1758389705849; Sat, 20 Sep 2025
 10:35:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-27-pali@kernel.org>
In-Reply-To: <20250831123602.14037-27-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:34:54 -0500
X-Gm-Features: AS18NWBZoZ0_ejcSJEJapY11roboHHAHMr2mnbUwvjBsjb89Z2EE5L-n7bEIz_Q
Message-ID: <CAH2r5msHuceJMDOiwR7GqJx_LWaWJsFxiFV8oMxCPFKaUym3pg@mail.gmail.com>
Subject: Re: [PATCH 26/35] cifs: Add SMB2+ support into cifs_rename_pending_delete()
 function.
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

this patch didn't apply on current mainline

On Sun, Aug 31, 2025 at 7:38=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Currently the cifs_rename_pending_delete() function calls directly the SM=
B1
> functions and therefore cannot be used by SMB2+ dialects.
>
> Change cifs_rename_pending_delete() code to use tcon->ses->server->ops->
> callbacks instead of direct SMB1 functions. This allows to use this
> function also by SMB2 and SMB3 dialects.
>
> Mark the function cifs_rename_pending_delete() as static in inode.c and
> calls it directly. As it is now dialect neutral, remove it from struct
> smb_version_operations callback list.
>
> This change allows to use silly rename in SMB2+ by follow up changes.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/cifsglob.h  |  3 ---
>  fs/smb/client/cifsproto.h |  3 ---
>  fs/smb/client/inode.c     | 56 +++++++++++++++++----------------------
>  fs/smb/client/smb1ops.c   |  1 -
>  4 files changed, 24 insertions(+), 39 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index ec5608924ce7..592a4faa3440 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -453,9 +453,6 @@ struct smb_version_operations {
>         /* unlink file */
>         int (*unlink)(const unsigned int, struct cifs_tcon *, const char =
*,
>                       struct cifs_sb_info *, struct dentry *);
> -       /* open, rename and delete file */
> -       int (*rename_pending_delete)(const char *, struct dentry *,
> -                                    const unsigned int);
>         /* send rename request */
>         int (*rename)(const unsigned int xid,
>                       struct cifs_tcon *tcon,
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index f248b18f1cf3..a29662a4d83d 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -242,9 +242,6 @@ extern int cifs_get_inode_info_unix(struct inode **pi=
node,
>                         struct super_block *sb, unsigned int xid);
>  extern int cifs_set_file_info(struct inode *inode, struct iattr *attrs,
>                               unsigned int xid, const char *full_path, __=
u32 dosattr);
> -extern int cifs_rename_pending_delete(const char *full_path,
> -                                     struct dentry *dentry,
> -                                     const unsigned int xid);
>  extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
>                                 struct cifs_fattr *fattr, uint sidtype);
>  extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 9a5504a3406d..c3f101d10488 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1684,7 +1684,6 @@ cifs_set_file_info(struct inode *inode, struct iatt=
r *attrs, unsigned int xid,
>         return server->ops->set_file_info(inode, full_path, &info_buf, xi=
d);
>  }
>
> -#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>  /*
>   * Open the given file (if it isn't already), set the DELETE_PENDING bit
>   * and rename it to a random name that hopefully won't conflict with
> @@ -1697,9 +1696,11 @@ cifs_set_file_info(struct inode *inode, struct iat=
tr *attrs, unsigned int xid,
>  #define SILLYNAME_LEN (SILLYNAME_PREFIX_LEN + \
>                 SILLYNAME_FILEID_LEN + \
>                 SILLYNAME_COUNTER_LEN)
> -int
> -cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
> -                          const unsigned int xid)
> +static int
> +cifs_rename_pending_delete(const unsigned int xid,
> +                          struct cifs_tcon *tcon,
> +                          const char *full_path,
> +                          struct dentry *dentry)
>  {
>         int oplock =3D 0;
>         int rc;
> @@ -1708,8 +1709,6 @@ cifs_rename_pending_delete(const char *full_path, s=
truct dentry *dentry,
>         struct inode *inode =3D d_inode(dentry);
>         struct cifsInodeInfo *cifsInode =3D CIFS_I(inode);
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> -       struct tcon_link *tlink;
> -       struct cifs_tcon *tcon;
>         __u32 dosattr, origattr;
>         char *sillyname_full_path =3D NULL;
>         bool can_rename_opened_file =3D true;
> @@ -1719,11 +1718,6 @@ cifs_rename_pending_delete(const char *full_path, =
struct dentry *dentry,
>         const char *dirpath_end;
>         size_t dirpath_len;
>
> -       tlink =3D cifs_sb_tlink(cifs_sb);
> -       if (IS_ERR(tlink))
> -               return PTR_ERR(tlink);
> -       tcon =3D tlink_tcon(tlink);
> -
>         /* construct random name ".smb<inodenum><counter>" */
>         while (true) {
>                 static unsigned int sillycounter; /* globally unique */
> @@ -1753,8 +1747,10 @@ cifs_rename_pending_delete(const char *full_path, =
struct dentry *dentry,
>         /*
>          * We cannot rename the opened file if the SMB1 server doesn't
>          * support CAP_INFOLEVEL_PASSTHRU. But we can rename file via pat=
h.
> +        * SMB2+ always supports renaming of the opened file.
>          */
> -       if (!(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
> +       if (tcon->ses->server->vals->protocol_id =3D=3D SMB10_PROT_ID &&
> +           !(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
>                 can_rename_opened_file =3D false;
>
>         dirpath_end =3D strrchr(full_path, CIFS_DIR_SEP(cifs_sb));
> @@ -1821,16 +1817,16 @@ cifs_rename_pending_delete(const char *full_path,=
 struct dentry *dentry,
>                 .fid =3D &fid,
>         };
>
> -       rc =3D CIFS_open(xid, &oparms, &oplock, NULL);
> +       rc =3D tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
>         if (rc !=3D 0)
>                 goto undo_rename_path;
>
>         /* rename the opened file (if it was not already renamed before t=
he open) */
>         if (can_rename_opened_file) {
> -               rc =3D CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, silly=
name,
> +               rc =3D tcon->ses->server->ops->rename_opened_file(
> +                                  xid, tcon, &fid, sillyname_full_path,
>                                    false /* overwrite */,
> -                                  cifs_sb->local_nls,
> -                                  cifs_remap(cifs_sb));
> +                                  cifs_sb);
>                 if (rc !=3D 0) {
>                         rc =3D -EBUSY;
>                         goto undo_close;
> @@ -1839,8 +1835,7 @@ cifs_rename_pending_delete(const char *full_path, s=
truct dentry *dentry,
>
>         /* try to set DELETE_PENDING */
>         if (!test_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags)) {
> -               rc =3D CIFSSMBSetFileDisposition(xid, tcon, true, fid.net=
fid,
> -                                              current->tgid);
> +               rc =3D tcon->ses->server->ops->set_file_disp(xid, tcon, &=
fid, true);
>                 /*
>                  * some samba versions return -ENOENT when we try to set =
the
>                  * file disposition here. Likely a samba bug, but work ar=
ound
> @@ -1856,11 +1851,10 @@ cifs_rename_pending_delete(const char *full_path,=
 struct dentry *dentry,
>                 set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
>         }
>
> -       CIFSSMBClose(xid, tcon, fid.netfid);
> +       tcon->ses->server->ops->close(xid, tcon, &fid);
>
>  out:
>         kfree(sillyname_full_path);
> -       cifs_put_tlink(tlink);
>         return rc;
>
>         /*
> @@ -1870,14 +1864,16 @@ cifs_rename_pending_delete(const char *full_path,=
 struct dentry *dentry,
>          */
>  undo_rename_opened_file:
>         if (can_rename_opened_file)
> -               CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, dentry->d_na=
me.name,
> +               tcon->ses->server->ops->rename_opened_file(
> +                               xid, tcon, &fid, full_path,
>                                 true /* overwrite */,
> -                               cifs_sb->local_nls, cifs_remap(cifs_sb));
> +                               cifs_sb);
>  undo_close:
> -       CIFSSMBClose(xid, tcon, fid.netfid);
> +       tcon->ses->server->ops->close(xid, tcon, &fid);
>  undo_rename_path:
>         if (!can_rename_opened_file)
> -               CIFSSMBRename(xid, tcon, dentry,
> +               tcon->ses->server->ops->rename(
> +                               xid, tcon, dentry,
>                                 sillyname_full_path,
>                                 full_path,
>                                 cifs_sb);
> @@ -1888,7 +1884,6 @@ cifs_rename_pending_delete(const char *full_path, s=
truct dentry *dentry,
>         }
>         goto out;
>  }
> -#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>
>  /* copied from fs/nfs/dir.c with small changes */
>  static void
> @@ -1981,13 +1976,10 @@ int cifs_unlink(struct inode *dir, struct dentry =
*dentry)
>         } else if (rc =3D=3D -ENOENT) {
>                 d_drop(dentry);
>         } else if (rc =3D=3D -EBUSY) {
> -               if (server->ops->rename_pending_delete) {
> -                       rc =3D server->ops->rename_pending_delete(full_pa=
th,
> -                                                               dentry, x=
id);
> -                       if (rc =3D=3D 0) {
> -                               cifs_mark_open_handles_for_deleted_file(i=
node, full_path);
> -                               cifs_drop_nlink(inode);
> -                       }
> +               rc =3D cifs_rename_pending_delete(xid, tcon, full_path, d=
entry);
> +               if (rc =3D=3D 0) {
> +                       cifs_mark_open_handles_for_deleted_file(inode, fu=
ll_path);
> +                       cifs_drop_nlink(inode);
>                 }
>         } else if ((rc =3D=3D -EACCES) && (dosattr =3D=3D 0) && inode) {
>                 attrs =3D kzalloc(sizeof(*attrs), GFP_KERNEL);
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 26798db5c00b..746dd9aa6b1b 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -1422,7 +1422,6 @@ struct smb_version_operations smb1_operations =3D {
>         .mkdir_setinfo =3D cifs_mkdir_setinfo,
>         .rmdir =3D CIFSSMBRmDir,
>         .unlink =3D CIFSSMBDelFile,
> -       .rename_pending_delete =3D cifs_rename_pending_delete,
>         .rename =3D CIFSSMBRename,
>         .rename_opened_file =3D cifs_rename_opened_file,
>         .create_hardlink =3D CIFSCreateHardLink,
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
