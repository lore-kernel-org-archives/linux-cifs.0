Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BF261B92
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 22:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770934966; cv=pass; b=H1IpcmYeGu3iVIQbQJpLvkA3ZKxdU/ild3qA4DVu1SDho3izEYK26dc5FJ1NTlmbvJH7LpWrI1ANycGNFBfE1qmELLJNyUMtL8qztlH4bRchl7N8oZWhJx3GV+zo14tUoInh7qSfuwbWSjGbumxfmOvAYvSx1Ob0BOEUGkwvw2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770934966; c=relaxed/simple;
	bh=qYUPf2iSq0VfSvyh1ETTnUbBdclvgqPYBjdUHt7qXEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AKLBk0nemQQLSthUyf3t4F+JyzdWPWjXaIVbeH95WdvYxKbmYtviAtM9rU5ZxJ/D01TrG2tr1N9AgQpbuE7CCfcaot+Pel6Dn7EJwpMox7pfH0YWdlP3vV7soiaouNm9MLOFEzwEW5QApo/sgvRd0hza9Pgs/ir+qU9g4wRBzNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iX/5WysE; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iX/5WysE"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-502a4e3e611so2824481cf.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 14:22:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770934963; cv=none;
        d=google.com; s=arc-20240605;
        b=idCdo8FWSTBU27BoAJQMtUz9FgFP3NCx4w2a/C44iY9B/3sAioOKtJELiI90DY/Zb7
         +b6eRBp9QuXJ1tJwGZ5YrSFVlgTRlNMfgI5N3sa0x3BeoxMPs1uQrIEJ89g/FmVkDhHk
         pmiddixKcn6y4q1lCGyqzo+G8FZzsLxfop4NNWpDQfwoDqvRagFUvM/niqEsO5LVjtFL
         4APKRIygDiuiBebGZA/prFYdjM8QDFW0H0X4Vj25VX1qVeV4AgzIl83MXeveffrA9DqS
         jp/2TY/ukirpvkSRY/+FlT1hSgO+BwA8/jVZp4TFIlDKgeGZnkQMgM60/4crTdFcwgA6
         AcTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wHzzfE+8RUF6xjWSMrT7VuyuQE86x9KTpKZ0eH12mfw=;
        fh=MfXkNjxwIg25z37U0i35WVvcoZtNRs5VT6uOti/U4VQ=;
        b=VjqOIaHm7SvZq/Rz0QetOv0zGw0MK4wgD37iBNJI40MOK/1z1zIjUg5BWvm6Lu7YBM
         gUWxgkUAXVtPNUTym2I/c3PWgwXrokF4IBa5lb4ILkaI3bUC4byy98XGOzZ5urAwiLCV
         svXAO1ZDciKtGh3fj3CUoacpWf6+R5aj5iDfi4hDV1qKD4XZIAxysEdFAQkTHXF6MBg/
         rI1dcgm7v0q9XlawoArQ0ZJzByv42257MwgLVbWXT6ipueTdBYRQht8XB3U3+lNsFDvd
         kJu8qskTz7pKCSPNle828QkPr2gQh5DHxdOvL+jVEVhelFQYyJEnlUVq3JW0FcBqBcz+
         fSzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770934963; x=1771539763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHzzfE+8RUF6xjWSMrT7VuyuQE86x9KTpKZ0eH12mfw=;
        b=iX/5WysE31hjG1/XWO9Fw9Rcane9r2XzbhrFMEEFEpla5ECEUsjsHergoha0XoYt9S
         uHN4VqdEKWpS9vLu4PGDhtqt3aVoBWMolvWnmK1v451bOaQsKf+AM/oVS0jErue88OQ8
         G+lB9wiRnG8t5fFwXdaVotajBYy+cDoflz0u63gWObLEf8cMXzgnCqRfqMDzBiEQCVUq
         dmOrNg6OY77GLIuO98yHDfLMElcFl6uCbImuj8hnesmFIEmnUX3exoazMagENWSg+F2v
         mHbAyu4NKmbQcjYO8N9kQ//yJbkzIAbmvlqDZVy5jUIlcnE4nAgutWz1DeKUBVjVBceO
         H86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770934963; x=1771539763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wHzzfE+8RUF6xjWSMrT7VuyuQE86x9KTpKZ0eH12mfw=;
        b=rw+MXuqRMpEWqA9UDpsa3Uj6w+Pmds/EsAKDSwvTRm1qU9i0rLshYFFVjdMUT2E6uZ
         qkd9YxGBv7B/CdBhhNYvetmEwA+C8hq7vtEUw3EBHts826l7UdOX85Xl4iqNZ+ckTgkz
         5wD6DElezScQmynniNe6NUVQdaIc3QfMqdIZ6G/xakk6BR+6T91e0lWjZVPTo7yBinIA
         PqHLZvjUbSeb4sFa9Pdsi6L/T50CYhGDVgb0TCuZuP2wccYuTop/HZndO1mUKe00Qq63
         MJ6+noynAm9YKjzh8IS+NdlOxllF7oY0EDApTHuWY7Ode7+ENeAd9DSm36CgT/zEHs81
         E8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCWoYhWOm0NycvnzFER6vWnc6NPwBgAuhZuZA3lH69njwGefB5GPw3VD5+myJjREFRN1WSBLLVIcRrVH@vger.kernel.org
X-Gm-Message-State: AOJu0YzLp8rvkCiGlztPNXO81zPQYKmjJ3p6nD+VGKnPEUCAVQE647h0
	dKSUTghxT71IgkF2sOwnrM30ttrWFdcm+WHI/e4sz2WCDA5BdLNOyQtBLERVt3wgxwzctfrqwbc
	tdR5Xemm6hcTyjv4GYKhr0oaqO1cUtoo=
X-Gm-Gg: AZuq6aJETok9hw9pgAB+u9mF2r+0L13ebm0cG1EhZzYSyvHmIvuq7OlhVaojHxZYaYa
	dRwjCdcRfm+A5UO0qKB9gpl+aumxUJpXZwk99Potq4gvgRTH7MRmXC3qOuamv32WBwqMPcSgusC
	q4zPZbOC2Zj641ltesGB/iMoNp+CfuUGxBoTa52CL3aLUyXCPPVjrOml9kBvXBEFkH+sKzZSBl3
	ywdiQaRtlTCEBDKDoRzXx+hGHpdjC59yTa5IwHNZ8LQKH+h86qIC4ffLDNJKwGCFaVnfHRoFYXN
	u3flOB+U8rcRPc/PgBAs+L8gaQPaa2ZfJaXT4sHjxQlvwu4IsMxawnVtW9QakFSnEbIcBBbsaSf
	ZxDpQPyyh0mOgvsbYQlgwItDBPT2vqckUssGfaaZlIEfOGkK+ztlpI/dU/Ll/ZKEqTBbNiv3ZyC
	/CzLOPaqJmomIDDLc8+gva
X-Received: by 2002:a05:622a:38e:b0:4f1:8bfd:bdc0 with SMTP id
 d75a77b69052e-506934f988dmr49399121cf.39.1770934962401; Thu, 12 Feb 2026
 14:22:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212194626.879692-1-pc@manguebit.org>
In-Reply-To: <20260212194626.879692-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 16:22:29 -0600
X-Gm-Features: AZwV_QjuVzfUACQJaNqZJUgZtz1kVLsbGKo3XUciWOqs_o0LOgx5irZpMIEwt-0
Message-ID: <CAH2r5mu5c6eC2yAfK0tfh2ySnPG--DjaqpDsJyUhxg_-6Xx=qQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix data corruption due to racy lease checks
To: Paulo Alcantara <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch generates the following warnings.  Let me know if updates needed.

  You are using:           gcc-15 (Ubuntu 15.2.0-4ubuntu4) 15.2.0
  CC [M]  file.o
  CHECK   file.c
file.c:2378:17: warning: context imbalance in 'cifs_setlk' - different
lock contexts for basic block
file.c:2937:9: warning: context imbalance in 'cifs_strict_writev' -
different lock contexts for basic block
file.c:2956:9: warning: context imbalance in 'cifs_file_write_iter' -
wrong count at exit
file.c:3257:9: warning: context imbalance in 'cifs_oplock_break' -
different lock contexts for basic block

On Thu, Feb 12, 2026 at 1:46=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Customer reported data corruption in some of their files.  It turned
> out the client would end up calling cacheless IO functions while
> having RHW lease, bypassing the pagecache and then leaving gaps in the
> file while writing to it.  It was related to concurrent opens changing
> the lease state while having writes in flight.  Lease breaks and
> re-opens due to reconnect could also cause same issue.
>
> Fix this by serialising the lease updates with
> cifsInodeInfo::open_file_lock.  When handling oplock break, make sure
> to use the downgraded oplock value rather than one in cifsInodeinfo as
> it could be changed concurrently.
>
> Reported-by: Frank Sorenson <sorenson@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/cifsglob.h  | 36 ++++++++++++++++++++-----
>  fs/smb/client/file.c      | 57 ++++++++++++++++++++++++---------------
>  fs/smb/client/smb1ops.c   | 16 ++++++++---
>  fs/smb/client/smb2misc.c  | 10 +++----
>  fs/smb/client/smb2ops.c   | 44 +++++++++++++++++-------------
>  fs/smb/client/smb2proto.h |  2 +-
>  6 files changed, 110 insertions(+), 55 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 7eb0131963dd..aab54daae3ac 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -515,8 +515,10 @@ struct smb_version_operations {
>         /* check for STATUS_NETWORK_SESSION_EXPIRED */
>         bool (*is_session_expired)(char *);
>         /* send oplock break response */
> -       int (*oplock_response)(struct cifs_tcon *tcon, __u64 persistent_f=
id, __u64 volatile_fid,
> -                       __u16 net_fid, struct cifsInodeInfo *cifs_inode);
> +       int (*oplock_response)(struct cifs_tcon *tcon, __u64 persistent_f=
id,
> +                              __u64 volatile_fid, __u16 net_fid,
> +                              struct cifsInodeInfo *cifs_inode,
> +                              unsigned int oplock);
>         /* query remote filesystem */
>         int (*queryfs)(const unsigned int, struct cifs_tcon *,
>                        const char *, struct cifs_sb_info *, struct kstatf=
s *);
> @@ -1531,10 +1533,6 @@ int cifs_file_set_size(const unsigned int xid, str=
uct dentry *dentry,
>  #define CIFS_CACHE_RW_FLG      (CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_F=
LG)
>  #define CIFS_CACHE_RHW_FLG     (CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FL=
G)
>
> -#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) =
|| (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE=
))
> -#define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FL=
G)
> -#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG=
) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CAC=
HE))
> -
>  /*
>   * One of these for each file inode
>   */
> @@ -2312,4 +2310,30 @@ static inline void cifs_requeue_server_reconn(stru=
ct TCP_Server_Info *server)
>         queue_delayed_work(cifsiod_wq, &server->reconnect, delay * HZ);
>  }
>
> +static inline bool __cifs_cache_state_check(struct cifsInodeInfo *cinode=
,
> +                                           unsigned int oplock_flags,
> +                                           unsigned int sb_flags)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(cinode->netfs.inode.i_sb=
);
> +       unsigned int oplock =3D READ_ONCE(cinode->oplock);
> +       unsigned int sflags =3D cifs_sb->mnt_cifs_flags;
> +
> +       return (oplock & oplock_flags) || (sflags & sb_flags);
> +}
> +
> +#define CIFS_CACHE_READ(cinode) \
> +       __cifs_cache_state_check(cinode, CIFS_CACHE_READ_FLG, \
> +                                CIFS_MOUNT_RO_CACHE)
> +#define CIFS_CACHE_HANDLE(cinode) \
> +       __cifs_cache_state_check(cinode, CIFS_CACHE_HANDLE_FLG, 0)
> +#define CIFS_CACHE_WRITE(cinode) \
> +       __cifs_cache_state_check(cinode, CIFS_CACHE_WRITE_FLG, \
> +                                CIFS_MOUNT_RW_CACHE)
> +
> +static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
> +{
> +       guard(spinlock)(&cinode->open_file_lock);
> +       WRITE_ONCE(cinode->oplock, 0);
> +}
> +
>  #endif /* _CIFS_GLOB_H */
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 51360d64b7b2..88273f82812b 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -731,14 +731,14 @@ struct cifsFileInfo *cifs_new_fileinfo(struct cifs_=
fid *fid, struct file *file,
>                 oplock =3D fid->pending_open->oplock;
>         list_del(&fid->pending_open->olist);
>
> -       fid->purge_cache =3D false;
> -       server->ops->set_fid(cfile, fid, oplock);
> -
>         list_add(&cfile->tlist, &tcon->openFileList);
>         atomic_inc(&tcon->num_local_opens);
>
>         /* if readable file instance put first in list*/
>         spin_lock(&cinode->open_file_lock);
> +       fid->purge_cache =3D false;
> +       server->ops->set_fid(cfile, fid, oplock);
> +
>         if (file->f_mode & FMODE_READ)
>                 list_add(&cfile->flist, &cinode->openFileList);
>         else
> @@ -1410,7 +1410,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool c=
an_flush)
>                 oplock =3D 0;
>         }
>
> -       server->ops->set_fid(cfile, &cfile->fid, oplock);
> +       scoped_guard(spinlock, &cinode->open_file_lock)
> +               server->ops->set_fid(cfile, &cfile->fid, oplock);
>         if (oparms.reconnect)
>                 cifs_relock_file(cfile);
>
> @@ -1437,11 +1438,11 @@ smb2_can_defer_close(struct inode *inode, struct =
cifs_deferred_close *dclose)
>  {
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>         struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> +       unsigned int oplock =3D READ_ONCE(cinode->oplock);
>
> -       return (cifs_sb->ctx->closetimeo && cinode->lease_granted && dclo=
se &&
> -                       (cinode->oplock =3D=3D CIFS_CACHE_RHW_FLG ||
> -                        cinode->oplock =3D=3D CIFS_CACHE_RH_FLG) &&
> -                       !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags)=
);
> +       return cifs_sb->ctx->closetimeo && cinode->lease_granted && dclos=
e &&
> +               (oplock =3D=3D CIFS_CACHE_RHW_FLG || oplock =3D=3D CIFS_C=
ACHE_RH_FLG) &&
> +               !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags);
>
>  }
>
> @@ -2371,7 +2372,7 @@ cifs_setlk(struct file *file, struct file_lock *flo=
ck, __u32 type,
>                         cifs_zap_mapping(inode);
>                         cifs_dbg(FYI, "Set no oplock for inode=3D%p due t=
o mand locks\n",
>                                  inode);
> -                       CIFS_I(inode)->oplock =3D 0;
> +                       cifs_reset_oplock(CIFS_I(inode));
>                 }
>
>                 rc =3D server->ops->mand_lock(xid, cfile, flock->fl_start=
, length,
> @@ -2930,7 +2931,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_i=
ter *from)
>                 cifs_zap_mapping(inode);
>                 cifs_dbg(FYI, "Set Oplock/Lease to NONE for inode=3D%p af=
ter write\n",
>                          inode);
> -               cinode->oplock =3D 0;
> +               cifs_reset_oplock(cinode);
>         }
>  out:
>         cifs_put_writer(cinode);
> @@ -2966,7 +2967,7 @@ ssize_t cifs_file_write_iter(struct kiocb *iocb, st=
ruct iov_iter *from)
>                         cifs_dbg(FYI,
>                                  "Set no oplock for inode=3D%p after a wr=
ite operation\n",
>                                  inode);
> -                       cinode->oplock =3D 0;
> +                       cifs_reset_oplock(cinode);
>                 }
>                 return written;
>         }
> @@ -3154,9 +3155,11 @@ void cifs_oplock_break(struct work_struct *work)
>         struct super_block *sb =3D inode->i_sb;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>         struct cifsInodeInfo *cinode =3D CIFS_I(inode);
> +       bool cache_read, cache_write, cache_handle;
>         struct cifs_tcon *tcon;
>         struct TCP_Server_Info *server;
>         struct tcon_link *tlink;
> +       unsigned int oplock;
>         int rc =3D 0;
>         bool purge_cache =3D false, oplock_break_cancelled;
>         __u64 persistent_fid, volatile_fid;
> @@ -3177,29 +3180,40 @@ void cifs_oplock_break(struct work_struct *work)
>         tcon =3D tlink_tcon(tlink);
>         server =3D tcon->ses->server;
>
> -       server->ops->downgrade_oplock(server, cinode, cfile->oplock_level=
,
> -                                     cfile->oplock_epoch, &purge_cache);
> +       scoped_guard(spinlock, &cinode->open_file_lock) {
> +               unsigned int sbflags =3D cifs_sb->mnt_cifs_flags;
>
> -       if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
> -                                               cifs_has_mand_locks(cinod=
e)) {
> +               server->ops->downgrade_oplock(server, cinode, cfile->oplo=
ck_level,
> +                                             cfile->oplock_epoch, &purge=
_cache);
> +               oplock =3D READ_ONCE(cinode->oplock);
> +               cache_read =3D (oplock & CIFS_CACHE_READ_FLG) ||
> +                       (sbflags & CIFS_MOUNT_RO_CACHE);
> +               cache_write =3D (oplock & CIFS_CACHE_WRITE_FLG) ||
> +                       (sbflags & CIFS_MOUNT_RW_CACHE);
> +               cache_handle =3D oplock & CIFS_CACHE_HANDLE_FLG;
> +       }
> +
> +       if (!cache_write && cache_read && cifs_has_mand_locks(cinode)) {
>                 cifs_dbg(FYI, "Reset oplock to None for inode=3D%p due to=
 mand locks\n",
>                          inode);
> -               cinode->oplock =3D 0;
> +               cifs_reset_oplock(cinode);
> +               oplock =3D 0;
> +               cache_read =3D cache_write =3D cache_handle =3D false;
>         }
>
>         if (S_ISREG(inode->i_mode)) {
> -               if (CIFS_CACHE_READ(cinode))
> +               if (cache_read)
>                         break_lease(inode, O_RDONLY);
>                 else
>                         break_lease(inode, O_WRONLY);
>                 rc =3D filemap_fdatawrite(inode->i_mapping);
> -               if (!CIFS_CACHE_READ(cinode) || purge_cache) {
> +               if (!cache_read || purge_cache) {
>                         rc =3D filemap_fdatawait(inode->i_mapping);
>                         mapping_set_error(inode->i_mapping, rc);
>                         cifs_zap_mapping(inode);
>                 }
>                 cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc)=
;
> -               if (CIFS_CACHE_WRITE(cinode))
> +               if (cache_write)
>                         goto oplock_break_ack;
>         }
>
> @@ -3214,7 +3228,7 @@ void cifs_oplock_break(struct work_struct *work)
>          * So, new open will not use cached handle.
>          */
>
> -       if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_c=
loses))
> +       if (!cache_handle && !list_empty(&cinode->deferred_closes))
>                 cifs_close_deferred_file(cinode);
>
>         persistent_fid =3D cfile->fid.persistent_fid;
> @@ -3232,7 +3246,8 @@ void cifs_oplock_break(struct work_struct *work)
>         if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)=
) {
>                 spin_unlock(&cinode->open_file_lock);
>                 rc =3D server->ops->oplock_response(tcon, persistent_fid,
> -                                                 volatile_fid, net_fid, =
cinode);
> +                                                 volatile_fid, net_fid,
> +                                                 cinode, oplock);
>                 cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
>         } else
>                 spin_unlock(&cinode->open_file_lock);
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 9c3b97d2a20a..970aeffe936e 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -395,6 +395,7 @@ cifs_downgrade_oplock(struct TCP_Server_Info *server,
>                       struct cifsInodeInfo *cinode, __u32 oplock,
>                       __u16 epoch, bool *purge_cache)
>  {
> +       lockdep_assert_held(&cinode->open_file_lock);
>         cifs_set_oplock_level(cinode, oplock);
>  }
>
> @@ -894,6 +895,9 @@ static void
>  cifs_set_fid(struct cifsFileInfo *cfile, struct cifs_fid *fid, __u32 opl=
ock)
>  {
>         struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
> +
> +       lockdep_assert_held(&cinode->open_file_lock);
> +
>         cfile->fid.netfid =3D fid->netfid;
>         cifs_set_oplock_level(cinode, oplock);
>         cinode->can_cache_brlcks =3D CIFS_CACHE_WRITE(cinode);
> @@ -1139,12 +1143,16 @@ cifs_close_dir(const unsigned int xid, struct cif=
s_tcon *tcon,
>         return CIFSFindClose(xid, tcon, fid->netfid);
>  }
>
> -static int
> -cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
> -               __u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *=
cinode)
> +static int cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent=
_fid,
> +                               __u64 volatile_fid, __u16 net_fid,
> +                               struct cifsInodeInfo *cinode, unsigned in=
t oplock)
>  {
> +       unsigned int sbflags =3D CIFS_SB(cinode->netfs.inode.i_sb)->mnt_c=
ifs_flags;
> +       __u8 op;
> +
> +       op =3D !!((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT=
_RO_CACHE));
>         return CIFSSMBLock(0, tcon, net_fid, current->tgid, 0, 0, 0, 0,
> -                          LOCKING_ANDX_OPLOCK_RELEASE, false, CIFS_CACHE=
_READ(cinode) ? 1 : 0);
> +                          LOCKING_ANDX_OPLOCK_RELEASE, false, op);
>  }
>
>  static int
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index 0871b9f1f86a..d1ae839e4863 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -484,16 +484,16 @@ cifs_convert_path_to_utf16(const char *from, struct=
 cifs_sb_info *cifs_sb)
>         return to;
>  }
>
> -__le32
> -smb2_get_lease_state(struct cifsInodeInfo *cinode)
> +__le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int o=
plock)
>  {
> +       unsigned int sbflags =3D CIFS_SB(cinode->netfs.inode.i_sb)->mnt_c=
ifs_flags;
>         __le32 lease =3D 0;
>
> -       if (CIFS_CACHE_WRITE(cinode))
> +       if ((oplock & CIFS_CACHE_WRITE_FLG) || (sbflags & CIFS_MOUNT_RW_C=
ACHE))
>                 lease |=3D SMB2_LEASE_WRITE_CACHING_LE;
> -       if (CIFS_CACHE_HANDLE(cinode))
> +       if (oplock & CIFS_CACHE_HANDLE_FLG)
>                 lease |=3D SMB2_LEASE_HANDLE_CACHING_LE;
> -       if (CIFS_CACHE_READ(cinode))
> +       if ((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT_RO_CA=
CHE))
>                 lease |=3D SMB2_LEASE_READ_CACHING_LE;
>         return lease;
>  }
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 262df6d2c2c8..1e13dd0a24c3 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1460,6 +1460,8 @@ smb2_set_fid(struct cifsFileInfo *cfile, struct cif=
s_fid *fid, __u32 oplock)
>         struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
>         struct TCP_Server_Info *server =3D tlink_tcon(cfile->tlink)->ses-=
>server;
>
> +       lockdep_assert_held(&cinode->open_file_lock);
> +
>         cfile->fid.persistent_fid =3D fid->persistent_fid;
>         cfile->fid.volatile_fid =3D fid->volatile_fid;
>         cfile->fid.access =3D fid->access;
> @@ -2684,16 +2686,19 @@ smb2_is_network_name_deleted(char *buf, struct TC=
P_Server_Info *server)
>         return false;
>  }
>
> -static int
> -smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
> -               __u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *=
cinode)
> +static int smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent=
_fid,
> +                               __u64 volatile_fid, __u16 net_fid,
> +                               struct cifsInodeInfo *cinode, unsigned in=
t oplock)
>  {
> +       unsigned int sbflags =3D CIFS_SB(cinode->netfs.inode.i_sb)->mnt_c=
ifs_flags;
> +       __u8 op;
> +
>         if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
>                 return SMB2_lease_break(0, tcon, cinode->lease_key,
> -                                       smb2_get_lease_state(cinode));
> +                                       smb2_get_lease_state(cinode, oplo=
ck));
>
> -       return SMB2_oplock_break(0, tcon, persistent_fid, volatile_fid,
> -                                CIFS_CACHE_READ(cinode) ? 1 : 0);
> +       op =3D !!((oplock & CIFS_CACHE_READ_FLG) || (sbflags & CIFS_MOUNT=
_RO_CACHE));
> +       return SMB2_oplock_break(0, tcon, persistent_fid, volatile_fid, o=
p);
>  }
>
>  void
> @@ -4053,6 +4058,7 @@ smb2_downgrade_oplock(struct TCP_Server_Info *serve=
r,
>                       struct cifsInodeInfo *cinode, __u32 oplock,
>                       __u16 epoch, bool *purge_cache)
>  {
> +       lockdep_assert_held(&cinode->open_file_lock);
>         server->ops->set_oplock_level(cinode, oplock, 0, NULL);
>  }
>
> @@ -4093,19 +4099,19 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinod=
e, __u32 oplock,
>         if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
>                 return;
>         if (oplock =3D=3D SMB2_OPLOCK_LEVEL_BATCH) {
> -               cinode->oplock =3D CIFS_CACHE_RHW_FLG;
> +               WRITE_ONCE(cinode->oplock, CIFS_CACHE_RHW_FLG);
>                 cifs_dbg(FYI, "Batch Oplock granted on inode %p\n",
>                          &cinode->netfs.inode);
>         } else if (oplock =3D=3D SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
> -               cinode->oplock =3D CIFS_CACHE_RW_FLG;
> +               WRITE_ONCE(cinode->oplock, CIFS_CACHE_RW_FLG);
>                 cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
>                          &cinode->netfs.inode);
>         } else if (oplock =3D=3D SMB2_OPLOCK_LEVEL_II) {
> -               cinode->oplock =3D CIFS_CACHE_READ_FLG;
> +               WRITE_ONCE(cinode->oplock, CIFS_CACHE_READ_FLG);
>                 cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
>                          &cinode->netfs.inode);
>         } else
> -               cinode->oplock =3D 0;
> +               WRITE_ONCE(cinode->oplock, 0);
>  }
>
>  static void
> @@ -4140,7 +4146,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode=
, __u32 oplock,
>         if (!new_oplock)
>                 strscpy(message, "None");
>
> -       cinode->oplock =3D new_oplock;
> +       WRITE_ONCE(cinode->oplock, new_oplock);
>         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
>                  &cinode->netfs.inode);
>  }
> @@ -4149,30 +4155,32 @@ static void
>  smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
>                       __u16 epoch, bool *purge_cache)
>  {
> -       unsigned int old_oplock =3D cinode->oplock;
> +       unsigned int old_oplock =3D READ_ONCE(cinode->oplock);
> +       unsigned int new_oplock;
>
>         smb21_set_oplock_level(cinode, oplock, epoch, purge_cache);
> +       new_oplock =3D READ_ONCE(cinode->oplock);
>
>         if (purge_cache) {
>                 *purge_cache =3D false;
>                 if (old_oplock =3D=3D CIFS_CACHE_READ_FLG) {
> -                       if (cinode->oplock =3D=3D CIFS_CACHE_READ_FLG &&
> +                       if (new_oplock =3D=3D CIFS_CACHE_READ_FLG &&
>                             (epoch - cinode->epoch > 0))
>                                 *purge_cache =3D true;
> -                       else if (cinode->oplock =3D=3D CIFS_CACHE_RH_FLG =
&&
> +                       else if (new_oplock =3D=3D CIFS_CACHE_RH_FLG &&
>                                  (epoch - cinode->epoch > 1))
>                                 *purge_cache =3D true;
> -                       else if (cinode->oplock =3D=3D CIFS_CACHE_RHW_FLG=
 &&
> +                       else if (new_oplock =3D=3D CIFS_CACHE_RHW_FLG &&
>                                  (epoch - cinode->epoch > 1))
>                                 *purge_cache =3D true;
> -                       else if (cinode->oplock =3D=3D 0 &&
> +                       else if (new_oplock =3D=3D 0 &&
>                                  (epoch - cinode->epoch > 0))
>                                 *purge_cache =3D true;
>                 } else if (old_oplock =3D=3D CIFS_CACHE_RH_FLG) {
> -                       if (cinode->oplock =3D=3D CIFS_CACHE_RH_FLG &&
> +                       if (new_oplock =3D=3D CIFS_CACHE_RH_FLG &&
>                             (epoch - cinode->epoch > 0))
>                                 *purge_cache =3D true;
> -                       else if (cinode->oplock =3D=3D CIFS_CACHE_RHW_FLG=
 &&
> +                       else if (new_oplock =3D=3D CIFS_CACHE_RHW_FLG &&
>                                  (epoch - cinode->epoch > 1))
>                                 *purge_cache =3D true;
>                 }
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index c7759e37d975..881e42cf66ce 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -42,7 +42,7 @@ struct mid_q_entry *smb2_setup_async_request(struct TCP=
_Server_Info *server,
>                                              struct smb_rqst *rqst);
>  struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
>                                      __u64 ses_id, __u32  tid);
> -__le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
> +__le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int o=
plock);
>  bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *se=
rver);
>  int smb3_handle_read_data(struct TCP_Server_Info *server,
>                           struct mid_q_entry *mid);
> --
> 2.53.0
>


--=20
Thanks,

Steve
