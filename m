Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BAE9475
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 01:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775870404; cv=pass; b=be9rxmshMZjukqkEjQumaevx+TiOfBR0ko6Cc8GqJF6uHD/bLw0tDnMbVgmKmjirt9bKDmyBTZQKv0dXIzo8NF9crlcG860aZnkt5LN67+jpYZ6wAxW+DEbzFkPvQkFYAv923PTcWk3BI8Xgjt19rmyP2kUCmrCFNs43Szp8XqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775870404; c=relaxed/simple;
	bh=22rFAgDqVDG50ejhrpQv4hJWXdghfRkmLipndupE0ss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hcj2sMCTFKP/jDsgxPV4Zkn0jMtBATiqIV+IVkCUkn85wLHyKqo/Y0seLYsquUWmT9M0Q4OB1BvPxUxqWGOTh2bDPLBSyoYzZnuMFK5jO8atH8c/Dpx6MlEoIiKwlaORBHubpnmbNVUl7bAChPwoRQH/4/V6ZzghGmNWudnxFYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ScjNDfg2; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScjNDfg2"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-89fc4147f2eso30986276d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 18:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775870402; cv=none;
        d=google.com; s=arc-20240605;
        b=AHI2OOgVvI9fT8uP7+TaIFqAQ7bhV4W5OUvJo4vfshiXHH1q0rK/kizIvsYPODkDCW
         +Z0VenxMtE5A5qM5OybOMtIJyFmNb3AFBID3TyKx0401IeIEFjlZN1oDf2/TsaJAE7dp
         TofKoqSSxPbWBIrkQrF01+6h/0iWePyI5353fxRkzVA/rUlPFYZ9nmhb794y8h3lNDej
         LbuzUfI7WeNcS9d+rcmrIyKK/jpA8icqLPQF9SSdu0gPq1lstpVu4uP9MPxk0GcVuQDg
         9vkag1zGrqzSKEW5HssgQRNXVljY0iPuQ9O99uxG/fqUiN9Zx0IulNbv4IbjNxgWkxz5
         wOQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BoYCXVPyh3KeQurt9+gDQolsDYN//x6FIjC2f2/YJk8=;
        fh=zeoA/GWtRpxsc3E8KiFMbtUyA14sDCAHCM2/Yi/44io=;
        b=CAV8BrqARpe0VPDTJ7LikCPs92Sj2U+q62wbf6H80r9hIGr1dx5rd5EWSY6D3caNJN
         Ig4w4nHzk/WjK2nNMjO0lAsAgjTjPl72Qm/0kQsnazBp5KkiudC0j64sjaoLGTbsUctr
         4ZU6hQbIH3oAmbKn9onqG1wsQrajND/cqJYQmLwra4E2Hkxiv1GdmrGZEn5Qk5sEWjyQ
         aWULrAv9zehaDrI/rg2b8kD/tS//ioMGwfNvEEBkcCikkZFql8MkJj+sSX0SYKHDkIIE
         Vqrk3zwSiYmNPWtYgY5WUc9nxGnvRbu2bPcRd04H9rsU9PZz14Ze9gO9SHAe74NuXYrI
         Vncg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775870402; x=1776475202; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoYCXVPyh3KeQurt9+gDQolsDYN//x6FIjC2f2/YJk8=;
        b=ScjNDfg2TXABRaqGnDRC5kscf5XlZrZDDxXgggkuofrKbXAmRK12PimPCCb0AfctQM
         i7mt73HHyHlHwMkqr6DyrCUXN1t2Eswey3LrsmDTG1XD4LastO6Qvi61igjD3b6lwtbx
         9oBDGxibAilVcZFVXzBYOLLrqLAk76wfPEiQCJ+wr3Wjvackm4FcrriC0o9qqUM1vsLk
         wNno9gsrX55vN8ulgd5luh/j7brHMfBQeHPteZOyeXRX1PzTz4WnLnl9zuWwXNN0pAgq
         OYarNgXVrpgIXTq15mWaiaOeCgHy8QjcGLUidTiuCEhc0j+C5B1WncsAgZNGp2KOysYy
         eEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775870402; x=1776475202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BoYCXVPyh3KeQurt9+gDQolsDYN//x6FIjC2f2/YJk8=;
        b=Acxfjzh+izRFIqfvVE2UJy2+vk5qTBL4DLFl6KiP4orRskCJaDKSyefNpuUvhOLFBP
         Lv0kRu3TvEBbrdMLGs5opFWWDiJPgYFQAIJiP+XHGJzjiOnBBsimq6wMfWiEymjAIEV4
         MleYHSAMYkmQl70BcjQ8WpWRQltTilqx25Q/1OxAjsnWTZizwOMi853h7bciYjxApSoQ
         LFQKqUe6eG+zTnssseRceA+rSvNuWd2je6JTUn3urj6xvVOtpDF2yvp272hhkMD8KV6W
         +PoplLX9HLqJW9ayE9vHp9g0NQf/A1Jym3+FH14IKI/uDsNo1OH5fdy/9eQfRmOuZwSL
         R/vw==
X-Forwarded-Encrypted: i=1; AJvYcCU2OKdqyQHSHj4MsGcUn8NbP52GknpdU1pqaoJLgyPfNIlz92anNWS+SeIaAOQk1qXVHzbR/N4Ly5BL@vger.kernel.org
X-Gm-Message-State: AOJu0YxQnTB11fhBDmtOZvJ0wmBQeVSFa+vRT9TqE+FeAs2Ga5tf5eD2
	AbzWaXhg8dDnHaYAwiiRl05uzlqpgM0tZeNDNB+MX8cPYWa7TyyHw5pKQSj9UkuD+TIv+K3dd9i
	WnFmG3qlYNBPk8/+RT0cW6ewax44OEyg=
X-Gm-Gg: AeBDiesLQKPAlizIgSHpz5uQzRaJFYzke5/r+Cb9yIHxp/cpTOdR9HYPYoGxGs+KTJm
	qkI6uE4CLAFGXT1i8CaCkEjF+QjVeQCpvHvOATlNSOzi3LuuGseujg2z9bOyWTaOCGlOm/enONE
	ebswnX/b0ISS5kgdoJZm1XeJ+qI/KbVw/x0QyQaqColuXhftVke3W0TdM7nYBL2g/Yns6qQW0wa
	CEgv1Wxe7FXXR3y2l5d2OEE+RTRB+eNj+wbJopCvRRLavUKuzUHHnXCtptDutusqmQPyuJr7zME
	EAFGnQpKFBWRmH++eLSsrpAZrIUzWrzFn2oRRemA1d/2/1hCJsXe0uar2BxfY2oSKdSmsj8je2A
	zCQnh0QuGpgtQLgBskdPr1haIL5w/dgklBBCaD4ggh75evjektj6fjOtqJM63XoBQ9e44I5kBgk
	YikoKBbWM9Va9Y4hYRoKKDEQ==
X-Received: by 2002:a05:6214:3f81:b0:895:48c2:aedc with SMTP id
 6a1803df08f44-8ac862aaea0mr85807826d6.39.1775870401696; Fri, 10 Apr 2026
 18:20:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410232055.1582463-1-pc@manguebit.org>
In-Reply-To: <20260410232055.1582463-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 10 Apr 2026 20:19:48 -0500
X-Gm-Features: AQROBzARoYM-u0fR89e2CVNtSwAzLVKiCkVB8reyFtV35u3oyT1bDy_YUe9_JXA
Message-ID: <CAH2r5mvGYy9i8mPoWZah2kpv=98xaSFATsn1xbpihUa_RuhLEQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: get rid of d_drop()+d_add()
To: Paulo Alcantara <pc@manguebit.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, 
	NeilBrown <neilb@ownmail.net>, linux-fsdevel@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next

On Fri, Apr 10, 2026 at 6:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Replace d_drop()+d_add() in cifs_tmpfile() and cifs_create() with
> d_instantiate(), and in cifs_atomic_open() with d_splice_alias() if
> in-lookup, otherwise d_instantiate().
>
> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
> Closes: https://lore.kernel.org/r/20260408065719.GF3836593@ZenIV
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: NeilBrown <neilb@ownmail.net>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/cifsfs.h |  4 +--
>  fs/smb/client/dir.c    | 62 ++++++++++++++++++++++++++----------------
>  2 files changed, 40 insertions(+), 26 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index 64c7a4c6ac83..18f9f93a01b4 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -52,9 +52,9 @@ void cifs_sb_deactive(struct super_block *sb);
>  /* Functions related to inodes */
>  extern const struct inode_operations cifs_dir_inode_ops;
>  struct inode *cifs_root_iget(struct super_block *sb);
> -int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
> +int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
>                 struct dentry *direntry, umode_t mode, bool excl);
> -int cifs_atomic_open(struct inode *inode, struct dentry *direntry,
> +int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
>                      struct file *file, unsigned int oflags, umode_t mode=
);
>  int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
>                  struct file *file, umode_t mode);
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index bfc887d506b6..6ea1ae7f7a46 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -219,6 +219,7 @@ static int __cifs_do_create(struct inode *dir, struct=
 dentry *direntry,
>         int rdwr_for_fscache =3D 0;
>         __le32 lease_flags =3D 0;
>
> +       *inode =3D NULL;
>         *oplock =3D 0;
>         if (tcon->ses->server->oplocks)
>                 *oplock =3D REQ_OPLOCK;
> @@ -462,7 +463,6 @@ static int __cifs_do_create(struct inode *dir, struct=
 dentry *direntry,
>                 goto out_err;
>         }
>
> -       d_drop(direntry);
>         *inode =3D newinode;
>         return rc;
>
> @@ -478,11 +478,11 @@ static int cifs_do_create(struct inode *dir, struct=
 dentry *direntry,
>                           unsigned int xid, struct tcon_link *tlink,
>                           unsigned int oflags, umode_t mode,
>                           __u32 *oplock, struct cifs_fid *fid,
> -                         struct cifs_open_info_data *buf)
> +                         struct cifs_open_info_data *buf,
> +                         struct inode **inode)
>  {
>         void *page =3D alloc_dentry_path();
>         const char *full_path;
> -       struct inode *inode;
>         int rc;
>
>         full_path =3D build_path_from_dentry(direntry, page);
> @@ -491,9 +491,7 @@ static int cifs_do_create(struct inode *dir, struct d=
entry *direntry,
>         } else {
>                 rc =3D __cifs_do_create(dir, direntry, full_path, xid,
>                                       tlink, oflags, mode, oplock,
> -                                     fid, buf, &inode);
> -               if (!rc)
> -                       d_add(direntry, inode);
> +                                     fid, buf, inode);
>         }
>         free_dentry_path(page);
>         return rc;
> @@ -504,13 +502,13 @@ static int cifs_do_create(struct inode *dir, struct=
 dentry *direntry,
>   * Look up, create and open a CIFS file.
>   *
>   * The initial dentry state is in-lookup or hashed-negative.  On success=
, dentry
> - * will become hashed-positive by calling d_drop() & d_add(), respective=
ly.
> + * will become hashed-positive by calling d_splice_alias() if in-lookup,
> + * otherwise d_instantiate().
>   */
> -int
> -cifs_atomic_open(struct inode *inode, struct dentry *direntry,
> -                struct file *file, unsigned int oflags, umode_t mode)
> +int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
> +                    struct file *file, unsigned int oflags, umode_t mode=
)
>  {
> -       struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode);
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dir);
>         struct cifs_open_info_data buf =3D {};
>         struct TCP_Server_Info *server;
>         struct cifsFileInfo *file_info;
> @@ -519,6 +517,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *=
direntry,
>         struct tcon_link *tlink;
>         struct cifs_tcon *tcon;
>         unsigned int sbflags;
> +       struct dentry *alias;
> +       struct inode *inode;
>         unsigned int xid;
>         __u32 oplock;
>         int rc;
> @@ -545,13 +545,13 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>                 if (!d_in_lookup(direntry))
>                         return -ENOENT;
>
> -               return finish_no_open(file, cifs_lookup(inode, direntry, =
0));
> +               return finish_no_open(file, cifs_lookup(dir, direntry, 0)=
);
>         }
>
>         xid =3D get_xid();
>
>         cifs_dbg(FYI, "parent inode =3D 0x%p name is: %pd and dentry =3D =
0x%p\n",
> -                inode, direntry, direntry);
> +                dir, direntry, direntry);
>
>         tlink =3D cifs_sb_tlink(cifs_sb);
>         if (IS_ERR(tlink)) {
> @@ -572,13 +572,21 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>
>         cifs_add_pending_open(&fid, tlink, &open);
>
> -       rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
> -                           &oplock, &fid, &buf);
> +       rc =3D cifs_do_create(dir, direntry, xid, tlink, oflags, mode,
> +                           &oplock, &fid, &buf, &inode);
>         if (rc) {
>                 cifs_del_pending_open(&open);
>                 goto out;
>         }
>
> +       if (d_in_lookup(direntry)) {
> +               alias =3D d_splice_alias(inode, direntry);
> +               if (!IS_ERR_OR_NULL(alias))
> +                       direntry =3D alias;
> +       } else {
> +               d_instantiate(direntry, inode);
> +       }
> +
>         if ((oflags & (O_CREAT | O_EXCL)) =3D=3D (O_CREAT | O_EXCL))
>                 file->f_mode |=3D FMODE_CREATED;
>
> @@ -622,11 +630,12 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>   * Create a CIFS file.
>   *
>   * The initial dentry state is hashed-negative.  On success, dentry will=
 become
> - * hashed-positive by calling d_drop() & d_add(), respectively.
> + * hashed-positive by calling d_instantiate().
>   */
> -int cifs_create(struct mnt_idmap *idmap, struct inode *inode,
> +int cifs_create(struct mnt_idmap *idmap, struct inode *dir,
>                 struct dentry *direntry, umode_t mode, bool excl)
>  {
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(dir);
>         int rc;
>         unsigned int xid =3D get_xid();
>         /*
> @@ -640,19 +649,20 @@ int cifs_create(struct mnt_idmap *idmap, struct ino=
de *inode,
>         struct tcon_link *tlink;
>         struct cifs_tcon *tcon;
>         struct TCP_Server_Info *server;
> +       struct inode *inode;
>         struct cifs_fid fid;
>         __u32 oplock;
>         struct cifs_open_info_data buf =3D {};
>
>         cifs_dbg(FYI, "cifs_create parent inode =3D 0x%p name is: %pd and=
 dentry =3D 0x%p\n",
> -                inode, direntry, direntry);
> +                dir, direntry, direntry);
>
> -       if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb)))) {
> +       if (unlikely(cifs_forced_shutdown(cifs_sb))) {
>                 rc =3D smb_EIO(smb_eio_trace_forced_shutdown);
>                 goto out_free_xid;
>         }
>
> -       tlink =3D cifs_sb_tlink(CIFS_SB(inode->i_sb));
> +       tlink =3D cifs_sb_tlink(cifs_sb);
>         rc =3D PTR_ERR(tlink);
>         if (IS_ERR(tlink))
>                 goto out_free_xid;
> @@ -663,9 +673,13 @@ int cifs_create(struct mnt_idmap *idmap, struct inod=
e *inode,
>         if (server->ops->new_lease_key)
>                 server->ops->new_lease_key(&fid);
>
> -       rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode, =
&oplock, &fid, &buf);
> -       if (!rc && server->ops->close)
> -               server->ops->close(xid, tcon, &fid);
> +       rc =3D cifs_do_create(dir, direntry, xid, tlink, oflags,
> +                           mode, &oplock, &fid, &buf, &inode);
> +       if (!rc) {
> +               d_instantiate(direntry, inode);
> +               if (server->ops->close)
> +                       server->ops->close(xid, tcon, &fid);
> +       }
>
>         cifs_free_open_info(&buf);
>         cifs_put_tlink(tlink);
> @@ -1035,7 +1049,7 @@ static int set_tmpfile_attr(const unsigned int xid,=
 unsigned int oflags,
>   * Create a hidden temporary CIFS file with delete-on-close bit set.
>   *
>   * The initial dentry state is unhashed-negative.  On success, dentry wi=
ll
> - * become unhashed-positive by calling d_drop() & d_instantiate(), respe=
ctively.
> + * become unhashed-positive by calling d_instantiate().
>   */
>  int cifs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
>                  struct file *file, umode_t mode)
> --
> 2.53.0
>


--=20
Thanks,

Steve
