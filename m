Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B634BA35
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759876188; cv=none; b=M5CD0Xs0+A8toqca0Zkxmc2BHd+nMn4m4HLQ3k1rEudrSpJq0OnAXL9Hj+ipxVY/XaNUxK+Myo71dr3MfIDOq89PTzCn6vKEpGqEKWeLzh/re9yq94B0dt5XOJ0dEvwBQce9C+fGU7tCtPcJqHn05p8bHsfEvk7Ga5AurNM7Pl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759876188; c=relaxed/simple;
	bh=WjUMnr6VdnvUd+RcTfreFkZVC4eEfFnqQ49infiEYnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hxQlh66T9TVbaOc7Vy1IrNPCCEwr2Ba8svnxf6lOYplZZkds97kjCQ/+F4TIu0mtzRpmA13JVr1eIw2fXtzfE8BOdcbcIXeU7DZgXgHgDqVaGTqc7QDuKxRrSd2PNHhgOYheFRv0yEPYgmFUvdrfTI+Zp6ao6elA6uvxTZgNY1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jikXZeBQ; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jikXZeBQ"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-78e4056623fso56274636d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 07 Oct 2025 15:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759876185; x=1760480985; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDroJCXSyHFWr15yKVr56a9YV2Go6NLAYo6YZ490ODI=;
        b=jikXZeBQrx8x/0i6n4+hFiKjSl+8QqW3aMaIHaWhYhfEuaD7TH8TStM7BVjCpDz6C0
         cJyqHCgbvYdIB4zdVRNXfQIC3ZF3Ly13o7Fmpm0Iu9YYMmBSTEsQVINycRbLMBgzgAlS
         ZYKMWIw0ZBGwznctWkcl3JbSG/2sRHeB9U+Gmqi5SAf8GoTPpOSIvGuTHe7i94P6ZeEB
         acx4cxlvaCr+xrnVo58lxhK/AM4juG7yY8oyCWOqvo0Su4J4j+EJwTdCjygGwPuG67D9
         Gy0pz3PrTSqrvqdUpjRuCAqHajFbPOtOrWjmGWF91IlQyUO8ZjDnDTrAIeGbSh2VKlMv
         Lz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759876185; x=1760480985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDroJCXSyHFWr15yKVr56a9YV2Go6NLAYo6YZ490ODI=;
        b=RkZExQ7pXE3RMggH+36AJzabu+mV/E6CrCSDgKQcDrm0bbZ6TFCwQLOJaIZ9jZK5cV
         qBUQVtmCPezNATxORVcPysFa2eh99raQHcXP3LCw99wp+zTpF+XRPLTJAoxl/wui4Clj
         JjQ2lBYeTmIfVbWGBIM2j4tjyinEo19HIwd5PoaguCRRQ/iw17v14ieKq+hq8EJ3YoZ4
         FLfQ0ODZtqAWZqulJyoYnzNMj7GuxomHdGwSCdVI1hB7IznbwO40OaIKl6KI2/HhmhRI
         GbjPvxGqEhoUgkXsOiyv6j/MgQySu+H/qIVXQURMHmtyRQbdQ+PaUeGPG1zQf+BDg6BI
         OPwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXszHAg9D6DRD6S68k/NpR6Cfz4uRyoqsSJ5cMQMEc80kdJNUqNOFfpt6QwRy+QFIb7A6zbu/LyL3TC@vger.kernel.org
X-Gm-Message-State: AOJu0YyCzh4Yu4ZjjJEiuModSg1X6KhnlJr99fE/qaJhazUktRLPDn9j
	3K9sMaoJzi9nCMZGI/eJhYaKAPIMSp9hBFwxiPvMheqrWIdlDLWeAN8CTY1591Xj/m0hWo/+Ffb
	SWsJQiN4qOuEqc9+FmZDaB2ltm9bqVhU=
X-Gm-Gg: ASbGncugnIgX9+iAyKPj1P/2kkXPVOcRVU/dTux5A3fTz82rmWOxS59Csiu2oR9YzcO
	0SjfG7gmvnKcFzw01DPH346i2j3i+mz+DsMWK+J1qmnIji+fJXYU7BJOQG+KkDjJR8CloYWny8f
	UqCvRyhSzNF10W9NYlAgScK6HoPxm5gEJYKQGGAAxtzS86oKZbDfiUyDWVAsaE6hWw6E7UeV1It
	/kWD5GboE6wuOHIIoBepBhP64qF6+Y3VP/IAo8tUaE3ttBlm/LyqWjNunmDYHT2aRcuyOnQkzQu
	ZaMb9T9BiMaf7sr42/Ncq2moSYx0Rdiyn30z4dFZ+9SCSROInR5Ze0a+0UwYrO5hTPMINAsRUq1
	MJb+Fs0MTbi3zGqdU97HdhAEpUCKW9Y3EwT+2jK0Mhr8yrw==
X-Google-Smtp-Source: AGHT+IF8UUjRat1RVTJtqoZFUJZuWu6vGuNYwd9yPs4rpLQF+yS16Dl7ZTlNXy1Xj/rUKYWO0KHL9M3rsEam14v9kvI=
X-Received: by 2002:ad4:5f46:0:b0:879:df50:3a24 with SMTP id
 6a1803df08f44-87b2ef6ddfcmr16258206d6.49.1759876184531; Tue, 07 Oct 2025
 15:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007192326.234467-1-pc@manguebit.org>
In-Reply-To: <20251007192326.234467-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 7 Oct 2025 17:29:33 -0500
X-Gm-Features: AS18NWDvyuYgoLNdB-AGvRFzsP11HyCzF3KZ4YLR-Huik6-UAvC6brp8uZ_iyG4
Message-ID: <CAH2r5ms2e_8TnnWKdm9Ack+-pMyRNbBaL-U1BMr-cNf3u+P6cg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] smb: client: fix missing timestamp updates with O_TRUNC
To: Paulo Alcantara <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tentatively merged into cifs-2.6.git for-next pending additional
review/testing (also added the RB from David Howells)

On Tue, Oct 7, 2025 at 2:23=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Don't call ->set_file_info() on open handle to prevent the server from
> stopping [cm]time updates automatically as per MS-FSA 2.1.4.17.
>
> Fix this by checking for ATTR_OPEN bit earlier in cifs_setattr() to
> prevent ->set_file_info() from being called when opening a file with
> O_TRUNC.  Do the truncation in ->open() instead.
>
> This also saves two roundtrips when opening a file with O_TRUNC and
> there are currently no open handles to be reused.
>
> Before patch:
>
> $ mount.cifs //srv/share /mnt -o ...
> $ cd /mnt
> $ exec 3>foo; stat -c 'old: %z %y' foo; sleep 2; echo test >&3; exec 3>&-=
; sleep 2; stat -c 'new: %z %y' foo
> old: 2025-10-03 13:26:23.151030500 -0300 2025-10-03 13:26:23.151030500 -0=
300
> new: 2025-10-03 13:26:23.151030500 -0300 2025-10-03 13:26:23.151030500 -0=
300
>
> After patch:
>
> $ mount.cifs //srv/share /mnt -o ...
> $ cd /mnt
> $ exec 3>foo; stat -c 'old: %z %y' foo; sleep 2; echo test >&3; exec 3>&-=
; sleep 2; stat -c 'new: %z %y' foo
> $ exec 3>foo; stat -c 'old: %z %y' foo; sleep 2; echo test >&3; exec 3>&-=
; sleep 2; stat -c 'new: %z %y' foo
> old: 2025-10-03 13:28:13.911933800 -0300 2025-10-03 13:28:13.911933800 -0=
300
> new: 2025-10-03 13:28:26.647492700 -0300 2025-10-03 13:28:26.647492700 -0=
300
>
> Reported-by: Frank Sorenson <sorenson@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/cifsglob.h |   5 ++
>  fs/smb/client/file.c     |  94 +++++++++++++++++-------
>  fs/smb/client/inode.c    | 152 ++++++++++++++++++++++-----------------
>  3 files changed, 159 insertions(+), 92 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3ac254e123dc..8f6f567d7474 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1566,6 +1566,11 @@ struct cifsFileInfo *cifsFileInfo_get(struct cifsF=
ileInfo *cifs_file);
>  void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_=
hdlr,
>                        bool offload);
>  void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
> +int cifs_file_flush(const unsigned int xid, struct inode *inode,
> +                   struct cifsFileInfo *cfile);
> +int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
> +                      const char *full_path, struct cifsFileInfo *open_f=
ile,
> +                      loff_t size);
>
>  #define CIFS_CACHE_READ_FLG    1
>  #define CIFS_CACHE_HANDLE_FLG  2
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index a5ed742afa00..ecbb63e66521 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -952,6 +952,66 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_fil=
e,
>         }
>  }
>
> +int cifs_file_flush(const unsigned int xid, struct inode *inode,
> +                   struct cifsFileInfo *cfile)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> +       struct cifs_tcon *tcon;
> +       int rc;
> +
> +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
> +               return 0;
> +
> +       if (cfile && (OPEN_FMODE(cfile->f_flags) & FMODE_WRITE)) {
> +               tcon =3D tlink_tcon(cfile->tlink);
> +               return tcon->ses->server->ops->flush(xid, tcon,
> +                                                    &cfile->fid);
> +       }
> +       rc =3D cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile)=
;
> +       if (!rc) {
> +               tcon =3D tlink_tcon(cfile->tlink);
> +               rc =3D tcon->ses->server->ops->flush(xid, tcon, &cfile->f=
id);
> +               cifsFileInfo_put(cfile);
> +       } else if (rc =3D=3D -EBADF) {
> +               rc =3D 0;
> +       }
> +       return rc;
> +}
> +
> +static int cifs_do_truncate(const unsigned int xid, struct dentry *dentr=
y)
> +{
> +       struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(dentry));
> +       struct inode *inode =3D d_inode(dentry);
> +       struct cifsFileInfo *cfile =3D NULL;
> +       struct TCP_Server_Info *server;
> +       struct cifs_tcon *tcon;
> +       int rc;
> +
> +       rc =3D filemap_write_and_wait(inode->i_mapping);
> +       if (is_interrupt_error(rc))
> +               return -ERESTARTSYS;
> +       mapping_set_error(inode->i_mapping, rc);
> +
> +       cfile =3D find_writable_file(cinode, FIND_WR_FSUID_ONLY);
> +       rc =3D cifs_file_flush(xid, inode, cfile);
> +       if (!rc) {
> +               if (cfile) {
> +                       tcon =3D tlink_tcon(cfile->tlink);
> +                       server =3D tcon->ses->server;
> +                       rc =3D server->ops->set_file_size(xid, tcon,
> +                                                       cfile, 0, false);
> +               }
> +               if (!rc) {
> +                       netfs_resize_file(&cinode->netfs, 0, true);
> +                       cifs_setsize(inode, 0);
> +                       inode->i_blocks =3D 0;
> +               }
> +       }
> +       if (cfile)
> +               cifsFileInfo_put(cfile);
> +       return rc;
> +}
> +
>  int cifs_open(struct inode *inode, struct file *file)
>
>  {
> @@ -1004,6 +1064,12 @@ int cifs_open(struct inode *inode, struct file *fi=
le)
>                         file->f_op =3D &cifs_file_direct_ops;
>         }
>
> +       if (file->f_flags & O_TRUNC) {
> +               rc =3D cifs_do_truncate(xid, file_dentry(file));
> +               if (rc)
> +                       goto out;
> +       }
> +
>         /* Get the cached handle as SMB2 close is deferred */
>         if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
>                 rc =3D cifs_get_writable_path(tcon, full_path,
> @@ -2685,13 +2751,10 @@ cifs_get_readable_path(struct cifs_tcon *tcon, co=
nst char *name,
>  int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
>                       int datasync)
>  {
> -       unsigned int xid;
> -       int rc =3D 0;
> -       struct cifs_tcon *tcon;
> -       struct TCP_Server_Info *server;
>         struct cifsFileInfo *smbfile =3D file->private_data;
>         struct inode *inode =3D file_inode(file);
> -       struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> +       unsigned int xid;
> +       int rc =3D 0;
>
>         rc =3D file_write_and_wait_range(file, start, end);
>         if (rc) {
> @@ -2712,26 +2775,7 @@ int cifs_strict_fsync(struct file *file, loff_t st=
art, loff_t end,
>                 }
>         }
>
> -       tcon =3D tlink_tcon(smbfile->tlink);
> -       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
> -               server =3D tcon->ses->server;
> -               if (server->ops->flush =3D=3D NULL) {
> -                       rc =3D -ENOSYS;
> -                       goto strict_fsync_exit;
> -               }
> -
> -               if ((OPEN_FMODE(smbfile->f_flags) & FMODE_WRITE) =3D=3D 0=
) {
> -                       smbfile =3D find_writable_file(CIFS_I(inode), FIN=
D_WR_ANY);
> -                       if (smbfile) {
> -                               rc =3D server->ops->flush(xid, tcon, &smb=
file->fid);
> -                               cifsFileInfo_put(smbfile);
> -                       } else
> -                               cifs_dbg(FYI, "ignore fsync for file not =
open for write\n");
> -               } else
> -                       rc =3D server->ops->flush(xid, tcon, &smbfile->fi=
d);
> -       }
> -
> -strict_fsync_exit:
> +       rc =3D cifs_file_flush(xid, inode, smbfile);
>         free_xid(xid);
>         return rc;
>  }
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 8bb544be401e..ce88bef4e44c 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3007,28 +3007,24 @@ int cifs_fiemap(struct inode *inode, struct fiema=
p_extent_info *fei, u64 start,
>
>  void cifs_setsize(struct inode *inode, loff_t offset)
>  {
> -       struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
> -
>         spin_lock(&inode->i_lock);
>         i_size_write(inode, offset);
>         spin_unlock(&inode->i_lock);
> -
> -       /* Cached inode must be refreshed on truncate */
> -       cifs_i->time =3D 0;
> +       inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>         truncate_pagecache(inode, offset);
>  }
>
> -static int
> -cifs_set_file_size(struct inode *inode, struct iattr *attrs,
> -                  unsigned int xid, const char *full_path, struct dentry=
 *dentry)
> +int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
> +                      const char *full_path, struct cifsFileInfo *open_f=
ile,
> +                      loff_t size)
>  {
> -       int rc;
> -       struct cifsFileInfo *open_file;
> -       struct cifsInodeInfo *cifsInode =3D CIFS_I(inode);
> +       struct inode *inode =3D d_inode(dentry);
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> +       struct cifsInodeInfo *cifsInode =3D CIFS_I(inode);
>         struct tcon_link *tlink =3D NULL;
>         struct cifs_tcon *tcon =3D NULL;
>         struct TCP_Server_Info *server;
> +       int rc =3D -EINVAL;
>
>         /*
>          * To avoid spurious oplock breaks from server, in the case of
> @@ -3039,19 +3035,25 @@ cifs_set_file_size(struct inode *inode, struct ia=
ttr *attrs,
>          * writebehind data than the SMB timeout for the SetPathInfo
>          * request would allow
>          */
> -       open_file =3D find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
> -       if (open_file) {
> +       if (open_file && (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE)) =
{
>                 tcon =3D tlink_tcon(open_file->tlink);
>                 server =3D tcon->ses->server;
> -               if (server->ops->set_file_size)
> -                       rc =3D server->ops->set_file_size(xid, tcon, open=
_file,
> -                                                       attrs->ia_size, f=
alse);
> -               else
> -                       rc =3D -ENOSYS;
> -               cifsFileInfo_put(open_file);
> -               cifs_dbg(FYI, "SetFSize for attrs rc =3D %d\n", rc);
> -       } else
> -               rc =3D -EINVAL;
> +               rc =3D server->ops->set_file_size(xid, tcon,
> +                                               open_file,
> +                                               size, false);
> +               cifs_dbg(FYI, "%s: set_file_size: rc =3D %d\n", __func__,=
 rc);
> +       } else {
> +               open_file =3D find_writable_file(cifsInode, FIND_WR_FSUID=
_ONLY);
> +               if (open_file) {
> +                       tcon =3D tlink_tcon(open_file->tlink);
> +                       server =3D tcon->ses->server;
> +                       rc =3D server->ops->set_file_size(xid, tcon,
> +                                                       open_file,
> +                                                       size, false);
> +                       cifs_dbg(FYI, "%s: set_file_size: rc =3D %d\n", _=
_func__, rc);
> +                       cifsFileInfo_put(open_file);
> +               }
> +       }
>
>         if (!rc)
>                 goto set_size_out;
> @@ -3069,20 +3071,15 @@ cifs_set_file_size(struct inode *inode, struct ia=
ttr *attrs,
>          * valid, writeable file handle for it was found or because there=
 was
>          * an error setting it by handle.
>          */
> -       if (server->ops->set_path_size)
> -               rc =3D server->ops->set_path_size(xid, tcon, full_path,
> -                                               attrs->ia_size, cifs_sb, =
false, dentry);
> -       else
> -               rc =3D -ENOSYS;
> -       cifs_dbg(FYI, "SetEOF by path (setattrs) rc =3D %d\n", rc);
> -
> -       if (tlink)
> -               cifs_put_tlink(tlink);
> +       rc =3D server->ops->set_path_size(xid, tcon, full_path, size,
> +                                       cifs_sb, false, dentry);
> +       cifs_dbg(FYI, "%s: SetEOF by path (setattrs) rc =3D %d\n", __func=
__, rc);
> +       cifs_put_tlink(tlink);
>
>  set_size_out:
>         if (rc =3D=3D 0) {
> -               netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true=
);
> -               cifs_setsize(inode, attrs->ia_size);
> +               netfs_resize_file(&cifsInode->netfs, size, true);
> +               cifs_setsize(inode, size);
>                 /*
>                  * i_blocks is not related to (i_size / i_blksize), but i=
nstead
>                  * 512 byte (2**9) size is required for calculating num b=
locks.
> @@ -3090,15 +3087,7 @@ cifs_set_file_size(struct inode *inode, struct iat=
tr *attrs,
>                  * this is best estimate we have for blocks allocated for=
 a file
>                  * Number of blocks must be rounded up so size 1 is not 0=
 blocks
>                  */
> -               inode->i_blocks =3D (512 - 1 + attrs->ia_size) >> 9;
> -
> -               /*
> -                * The man page of truncate says if the size changed,
> -                * then the st_ctime and st_mtime fields for the file
> -                * are updated.
> -                */
> -               attrs->ia_ctime =3D attrs->ia_mtime =3D current_time(inod=
e);
> -               attrs->ia_valid |=3D ATTR_CTIME | ATTR_MTIME;
> +               inode->i_blocks =3D (512 - 1 + size) >> 9;
>         }
>
>         return rc;
> @@ -3118,7 +3107,7 @@ cifs_setattr_unix(struct dentry *direntry, struct i=
attr *attrs)
>         struct tcon_link *tlink;
>         struct cifs_tcon *pTcon;
>         struct cifs_unix_set_info_args *args =3D NULL;
> -       struct cifsFileInfo *open_file;
> +       struct cifsFileInfo *open_file =3D NULL;
>
>         cifs_dbg(FYI, "setattr_unix on file %pd attrs->ia_valid=3D0x%x\n"=
,
>                  direntry, attrs->ia_valid);
> @@ -3132,6 +3121,9 @@ cifs_setattr_unix(struct dentry *direntry, struct i=
attr *attrs)
>         if (rc < 0)
>                 goto out;
>
> +       if (attrs->ia_valid & ATTR_FILE)
> +               open_file =3D attrs->ia_file->private_data;
> +
>         full_path =3D build_path_from_dentry(direntry, page);
>         if (IS_ERR(full_path)) {
>                 rc =3D PTR_ERR(full_path);
> @@ -3159,9 +3151,17 @@ cifs_setattr_unix(struct dentry *direntry, struct =
iattr *attrs)
>         rc =3D 0;
>
>         if (attrs->ia_valid & ATTR_SIZE) {
> -               rc =3D cifs_set_file_size(inode, attrs, xid, full_path, d=
irentry);
> +               rc =3D cifs_file_set_size(xid, direntry, full_path,
> +                                       open_file, attrs->ia_size);
>                 if (rc !=3D 0)
>                         goto out;
> +               /*
> +                * The man page of truncate says if the size changed,
> +                * then the st_ctime and st_mtime fields for the file
> +                * are updated.
> +                */
> +               attrs->ia_ctime =3D attrs->ia_mtime =3D current_time(inod=
e);
> +               attrs->ia_valid |=3D ATTR_CTIME | ATTR_MTIME;
>         }
>
>         /* skip mode change if it's just for clearing setuid/setgid */
> @@ -3206,14 +3206,24 @@ cifs_setattr_unix(struct dentry *direntry, struct=
 iattr *attrs)
>                 args->ctime =3D NO_CHANGE_64;
>
>         args->device =3D 0;
> -       open_file =3D find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
> -       if (open_file) {
> -               u16 nfid =3D open_file->fid.netfid;
> -               u32 npid =3D open_file->pid;
> +       rc =3D -EINVAL;
> +       if (open_file && (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE)) =
{
>                 pTcon =3D tlink_tcon(open_file->tlink);
> -               rc =3D CIFSSMBUnixSetFileInfo(xid, pTcon, args, nfid, npi=
d);
> -               cifsFileInfo_put(open_file);
> +               rc =3D CIFSSMBUnixSetFileInfo(xid, pTcon, args,
> +                                           open_file->fid.netfid,
> +                                           open_file->pid);
>         } else {
> +               open_file =3D find_writable_file(cifsInode, FIND_WR_FSUID=
_ONLY);
> +               if (open_file) {
> +                       pTcon =3D tlink_tcon(open_file->tlink);
> +                       rc =3D CIFSSMBUnixSetFileInfo(xid, pTcon, args,
> +                                                   open_file->fid.netfid=
,
> +                                                   open_file->pid);
> +                       cifsFileInfo_put(open_file);
> +               }
> +       }
> +
> +       if (rc) {
>                 tlink =3D cifs_sb_tlink(cifs_sb);
>                 if (IS_ERR(tlink)) {
>                         rc =3D PTR_ERR(tlink);
> @@ -3221,8 +3231,8 @@ cifs_setattr_unix(struct dentry *direntry, struct i=
attr *attrs)
>                 }
>                 pTcon =3D tlink_tcon(tlink);
>                 rc =3D CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, args=
,
> -                                   cifs_sb->local_nls,
> -                                   cifs_remap(cifs_sb));
> +                                           cifs_sb->local_nls,
> +                                           cifs_remap(cifs_sb));
>                 cifs_put_tlink(tlink);
>         }
>
> @@ -3264,8 +3274,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct=
 iattr *attrs)
>         struct inode *inode =3D d_inode(direntry);
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>         struct cifsInodeInfo *cifsInode =3D CIFS_I(inode);
> -       struct cifsFileInfo *wfile;
> -       struct cifs_tcon *tcon;
> +       struct cifsFileInfo *cfile =3D NULL;
>         const char *full_path;
>         void *page =3D alloc_dentry_path();
>         int rc =3D -EACCES;
> @@ -3285,6 +3294,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct=
 iattr *attrs)
>         if (rc < 0)
>                 goto cifs_setattr_exit;
>
> +       if (attrs->ia_valid & ATTR_FILE)
> +               cfile =3D attrs->ia_file->private_data;
> +
>         full_path =3D build_path_from_dentry(direntry, page);
>         if (IS_ERR(full_path)) {
>                 rc =3D PTR_ERR(full_path);
> @@ -3311,25 +3323,24 @@ cifs_setattr_nounix(struct dentry *direntry, stru=
ct iattr *attrs)
>
>         rc =3D 0;
>
> -       if ((attrs->ia_valid & ATTR_MTIME) &&
> -           !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
> -               rc =3D cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wf=
ile);
> -               if (!rc) {
> -                       tcon =3D tlink_tcon(wfile->tlink);
> -                       rc =3D tcon->ses->server->ops->flush(xid, tcon, &=
wfile->fid);
> -                       cifsFileInfo_put(wfile);
> -                       if (rc)
> -                               goto cifs_setattr_exit;
> -               } else if (rc !=3D -EBADF)
> +       if (attrs->ia_valid & ATTR_MTIME) {
> +               rc =3D cifs_file_flush(xid, inode, cfile);
> +               if (rc)
>                         goto cifs_setattr_exit;
> -               else
> -                       rc =3D 0;
>         }
>
>         if (attrs->ia_valid & ATTR_SIZE) {
> -               rc =3D cifs_set_file_size(inode, attrs, xid, full_path, d=
irentry);
> +               rc =3D cifs_file_set_size(xid, direntry, full_path,
> +                                       cfile, attrs->ia_size);
>                 if (rc !=3D 0)
>                         goto cifs_setattr_exit;
> +               /*
> +                * The man page of truncate says if the size changed,
> +                * then the st_ctime and st_mtime fields for the file
> +                * are updated.
> +                */
> +               attrs->ia_ctime =3D attrs->ia_mtime =3D current_time(inod=
e);
> +               attrs->ia_valid |=3D ATTR_CTIME | ATTR_MTIME;
>         }
>
>         if (attrs->ia_valid & ATTR_UID)
> @@ -3459,6 +3470,13 @@ cifs_setattr(struct mnt_idmap *idmap, struct dentr=
y *direntry,
>
>         if (unlikely(cifs_forced_shutdown(cifs_sb)))
>                 return -EIO;
> +       /*
> +        * Avoid setting [cm]time with O_TRUNC to prevent the server from
> +        * disabling automatic timestamp updates as specified in
> +        * MS-FSA 2.1.4.17.
> +        */
> +       if (attrs->ia_valid & ATTR_OPEN)
> +               return 0;
>
>         do {
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> --
> 2.51.0
>


--=20
Thanks,

Steve
