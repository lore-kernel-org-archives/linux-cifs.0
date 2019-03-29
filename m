Return-Path: <SRS0=xN7r=SA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC0DC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 18:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F76F2184C
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 18:20:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jg69dXIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfC2SUa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 14:20:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35619 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729949AbfC2SUa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Mar 2019 14:20:30 -0400
Received: by mail-lj1-f195.google.com with SMTP id t4so2819686ljc.2
        for <linux-cifs@vger.kernel.org>; Fri, 29 Mar 2019 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s9qyz+v1KLTje4S4WeQU7q6ybOz9QHLeH2FqttEDl9Q=;
        b=Jg69dXIHlrIh53bLtZon0Fa+qu14Sj3wb6EPHPc2mG0eCsIkimtJL8EJX66KCSnnB3
         giBg7Njko4Ip6nB/zsawHqBwiz7MjeImb6491bbCt+sFLn4mnTVG0B5xVuJdBPTog1LS
         KvkKSiuvPrFN3diwVA6g5IUB3tN4xS41648IXlcO0MpOGKxN7gu0AIW03oWknlRPoUH6
         mJw0Y3M5cBZXxnBxI++cTPMFe+eNG6hFBlIbJmr5UYyTI+s5vY/dp8Aw9NDAddkcLqxA
         07qgkHsxPTYPvw3VugG+Ijnp+CnBbEY78b0Lk6h4WBHvvR0e1OqEJahqRnMj2HdAh2vP
         EovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s9qyz+v1KLTje4S4WeQU7q6ybOz9QHLeH2FqttEDl9Q=;
        b=HCxs+8nyKVac1kbOQ9xK4lJ0Dy5vjn1CHi+YZRcL1MGM1FcASd+JhTTa77i6vNg+u3
         PR+nrenyd74blvO2ZytUSTnGxT8u6Z6dodeGgc1C1gnLfsTUTPoakwWUNz0411bfIsEN
         JjQbaAyn0fsACwyArZKh1pFZbhPDO57J+fmNGf9t0PrCCC7n+2nMqpsgJltLzupzs8tx
         uZ22EXARDdfCY5F69jsCcrvX5VQXwqhIzS6B22/4u2IfDW8cc9vGmQ/OpKUtxnVV4vzF
         Po16JGJxqKUFtcsIB9NYxFXU0ihJ9i8kKZvQn24cYzDjaY5hTbqWx9EIOFiP56P6GCaP
         +h/Q==
X-Gm-Message-State: APjAAAURV2dj3bgTmLUqJrhwE32Jqp9wPPoZ0fvRzimoBGJemhu5WL5c
        pbOe+b/mbD5twqHSmLs/0cognBGCu9xRNkhKjaUV2Do=
X-Google-Smtp-Source: APXvYqxHYN4BI/bj7W/w17WUvliEAft064jzMirnPKCkYGXjkvyo0F3Dgx3TbElIHsXhYtGdagzLtmfUtf0JpmiPlX8=
X-Received: by 2002:a2e:9585:: with SMTP id w5mr10639514ljh.132.1553883627316;
 Fri, 29 Mar 2019 11:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190329094912.15409-1-aaptel@suse.com>
In-Reply-To: <20190329094912.15409-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 29 Mar 2019 11:20:15 -0700
Message-ID: <CAKywueSGjv95AnBgYL9454WKUq--y2T2wigtCzDNLHXEZa6Edw@mail.gmail.com>
Subject: Re: [PATCH v3] CIFS: keep FileInfo handle live during oplock break
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 29 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 02:49, Aurelien Ap=
tel <aaptel@suse.com>:
>
> In the oplock break handler, writing pending changes from pages puts
> the FileInfo handle. If the refcount reaches zero it closes the handle
> and waits for any oplock break handler to return, thus causing a deadlock=
.
>
> To prevent this situation:
>
> * We add a wait flag to cifsFileInfo_put() to decide whether we should
>   wait for running/pending oplock break handlers
>
> * We keep an additionnal reference of the SMB FileInfo handle so that
>   for the rest of the handler putting the handle won't close it.
>   - The ref is bumped everytime we queue the handler via the
>     cifs_queue_oplock_break() helper.
>   - The ref is decremented at the end of the handler
>
> This bug was triggered by xfstest 464.
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
> changes since v2:
>
> * add _cifsFileInfo_put() and make cifsFileInfo_put() a wrapper of it
>
> fs/cifs/cifsglob.h |  2 ++
>  fs/cifs/file.c     | 30 +++++++++++++++++++++++++-----
>  fs/cifs/misc.c     | 25 +++++++++++++++++++++++--
>  fs/cifs/smb2misc.c |  6 +++---
>  4 files changed, 53 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 38feae812b47..ce0b1e8bc50c 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1325,6 +1325,7 @@ cifsFileInfo_get_locked(struct cifsFileInfo *cifs_f=
ile)
>  }
>
>  struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
> +void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_=
hdlr);
>  void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
>
>  #define CIFS_CACHE_READ_FLG    1
> @@ -1847,6 +1848,7 @@ GLOBAL_EXTERN spinlock_t gidsidlock;
>  #endif /* CONFIG_CIFS_ACL */
>
>  void cifs_oplock_break(struct work_struct *work);
> +void cifs_queue_oplock_break(struct cifsFileInfo *cfile);
>
>  extern const struct slow_work_ops cifs_oplock_break_ops;
>  extern struct workqueue_struct *cifsiod_wq;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 89006e044973..9c0ccc06d172 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -360,12 +360,30 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
>         return cifs_file;
>  }
>
> -/*
> - * Release a reference on the file private data. This may involve closin=
g
> - * the filehandle out on the server. Must be called without holding
> - * tcon->open_file_lock and cifs_file->file_info_lock.
> +/**
> + * cifsFileInfo_put - release a reference of file priv data
> + *
> + * Always potentially wait for oplock handler. See _cifsFileInfo_put().
>   */
>  void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
> +{
> +       _cifsFileInfo_put(cifs_file, true);
> +}
> +
> +/**
> + * _cifsFileInfo_put - release a reference of file priv data
> + *
> + * This may involve closing the filehandle @cifs_file out on the
> + * server. Must be called without holding tcon->open_file_lock and
> + * cifs_file->file_info_lock.
> + *
> + * If @wait_for_oplock_handler is true and we are releasing the last
> + * reference, wait for any running oplock break handler of the file
> + * and cancel any pending one. If calling this function from the
> + * oplock break handler, you need to pass false.
> + *
> + */
> +void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_=
handler)
>  {
>         struct inode *inode =3D d_inode(cifs_file->dentry);
>         struct cifs_tcon *tcon =3D tlink_tcon(cifs_file->tlink);
> @@ -414,7 +432,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>
>         spin_unlock(&tcon->open_file_lock);
>
> -       oplock_break_cancelled =3D cancel_work_sync(&cifs_file->oplock_br=
eak);
> +       oplock_break_cancelled =3D wait_oplock_handler ?
> +               cancel_work_sync(&cifs_file->oplock_break) : false;
>
>         if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
>                 struct TCP_Server_Info *server =3D tcon->ses->server;
> @@ -4603,6 +4622,7 @@ void cifs_oplock_break(struct work_struct *work)
>                                                              cinode);
>                 cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
>         }
> +       _cifsFileInfo_put(cfile, false /* do not wait for ourself */);
>         cifs_done_oplock_break(cinode);
>  }
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index bee203055b30..1e1626a2cfc3 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -501,8 +501,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server=
_Info *srv)
>                                            CIFS_INODE_DOWNGRADE_OPLOCK_TO=
_L2,
>                                            &pCifsInode->flags);
>
> -                               queue_work(cifsoplockd_wq,
> -                                          &netfile->oplock_break);
> +                               cifs_queue_oplock_break(netfile);
>                                 netfile->oplock_break_cancelled =3D false=
;
>
>                                 spin_unlock(&tcon->open_file_lock);
> @@ -607,6 +606,28 @@ void cifs_put_writer(struct cifsInodeInfo *cinode)
>         spin_unlock(&cinode->writers_lock);
>  }
>
> +/**
> + * cifs_queue_oplock_break - queue the oplock break handler for cfile
> + *
> + * This function is called from the demultiplex thread when it
> + * receives an oplock break for @cfile.
> + *
> + * Assumes the tcon->open_file_lock is held.
> + * Assumes cfile->file_info_lock is NOT held.
> + */
> +void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
> +{
> +       /*
> +        * Bump the handle refcount now while we hold the
> +        * open_file_lock to enforce the validity of it for the oplock
> +        * break handler. The matching put is done at the end of the
> +        * handler.
> +        */
> +       cifsFileInfo_get(cfile);
> +
> +       queue_work(cifsoplockd_wq, &cfile->oplock_break);
> +}
> +
>  void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
>  {
>         clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 0e3570e40ff8..e311f58dc1c8 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -555,7 +555,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct sm=
b2_lease_break *rsp,
>                         clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
>                                   &cinode->flags);
>
> -               queue_work(cifsoplockd_wq, &cfile->oplock_break);
> +               cifs_queue_oplock_break(cfile);
>                 kfree(lw);
>                 return true;
>         }
> @@ -712,8 +712,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_S=
erver_Info *server)
>                                            CIFS_INODE_DOWNGRADE_OPLOCK_TO=
_L2,
>                                            &cinode->flags);
>                                 spin_unlock(&cfile->file_info_lock);
> -                               queue_work(cifsoplockd_wq,
> -                                          &cfile->oplock_break);
> +
> +                               cifs_queue_oplock_break(cfile);
>
>                                 spin_unlock(&tcon->open_file_lock);
>                                 spin_unlock(&cifs_tcp_ses_lock);
> --
> 2.16.4
>

Looks good, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
