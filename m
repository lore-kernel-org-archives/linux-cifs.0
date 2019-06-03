Return-Path: <SRS0=aXsT=UC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C8BC04AB5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 17:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4182326539
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 17:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FR8kVhog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbfFCR32 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jun 2019 13:29:28 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44112 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbfFCR32 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jun 2019 13:29:28 -0400
Received: by mail-lf1-f65.google.com with SMTP id r15so14224630lfm.11
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jun 2019 10:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UL/1W9flynu1j2KtEVUiSdHqbqUU8wNGT3BA+gepvXE=;
        b=FR8kVhogJ9cBKtXVLQQRu0i57RZtoVry60VZvDmAIQDj3Hr4Yuf6IeXLtKRIQvWLYt
         JsZBChPj9wVWOnNZ3hijTRDZtYJc3Zug2MWduf65XrLNJSIqYX/TX1R33XWk+gZyfIMp
         fBNJPe5rWF0bqeh/wDTK+ooma4W9HoGTg1zBMz6hrY3ZN8fBD/khfteAsPVEfDFcZN92
         nukApFbkiA4fK/pSVfn3tmVxrO3W0jEWUlvBghWHou3B1jw+PfkpPGuncas10apENWgY
         nlaFFQoSczeV2xYvsZhqre0gEonAl8ht49POLMCaNLKgUfYVXBclmEQW99B/yeGmiPNp
         JqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UL/1W9flynu1j2KtEVUiSdHqbqUU8wNGT3BA+gepvXE=;
        b=Z6EoGUuxocWsIYM/L0oxslKc3n4cmkPHzNZ2YpRnP/gdB/FOEPBKwCkmkzOy30W75Y
         FutvAzPtFENhJLZXmDE827ArJyf1/UFJa9p9SVIjpsZ53nGBRPGvqp0p/LT6fxNXC02+
         t2SVNClw1pwncIWY/ohU3YvVQHQ+QTyxT1hs02DLyN52TbPP1oljBcLzrxYO/pkF8Nlu
         RruPftkMIOBM2YGEXsppd0ghtBDfkYAahT+ab250lwDoRale3SjBm3rkd3Tdnc5eCpzq
         L8GK9xuU/kVQSACNSEmKjMPkLcd/hE7zNe45XG1s+fr//cKPq2PQPdzFL6owo6T7+Wms
         LbGg==
X-Gm-Message-State: APjAAAVQ7b/hbcqspWL1qtvvNetEZRPC6UC+sIm0ZCa79Uvn6/4s/DLb
        z0swbsAAKKrhOn5xy5Cb8Ea447BfG78e8NQzXw==
X-Google-Smtp-Source: APXvYqwG3T1SQT2hgBsvhDBAXrXNIQxvQe5CKKrRuNn9GOIZA4eusy+0rNxg31/IP1y75G0oF0m6klhXfg7iCBDgFjE=
X-Received: by 2002:a05:6512:1d2:: with SMTP id f18mr13897274lfp.173.1559582965870;
 Mon, 03 Jun 2019 10:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190603075922.27266-1-lsahlber@redhat.com>
In-Reply-To: <20190603075922.27266-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 3 Jun 2019 10:29:14 -0700
Message-ID: <CAKywueRZ-QVi1dZc2WMSZAT-9YVhS6Soy4jbaauP6ds+x-a9bA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add global spinlock for the openFileList
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 3 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 01:02, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> We can not depend on the tcon->open_file_lock here since in multiuser mod=
e
> we may have the same file/inode open via multiple different tcons.
>
> The current code is race prone and will crash if one user deletes a file
> at the same time a different user opens/create the file.
>
> RHBZ:  1580165
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c   |  1 +
>  fs/cifs/cifsglob.h |  5 +++++
>  fs/cifs/file.c     | 12 ++++++++++--
>  3 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f5fcd6360056..20cc4eaa7a49 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1459,6 +1459,7 @@ init_cifs(void)
>         GlobalTotalActiveXid =3D 0;
>         GlobalMaxActiveXid =3D 0;
>         spin_lock_init(&cifs_tcp_ses_lock);
> +       spin_lock_init(&cifs_list_lock);
>         spin_lock_init(&GlobalMid_Lock);
>
>         cifs_lock_secret =3D get_random_u32();
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 334ff5f9c3f3..807b7cd7d48d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1817,6 +1817,11 @@ GLOBAL_EXTERN struct list_head           cifs_tcp_=
ses_list;
>   * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
>   */
>  GLOBAL_EXTERN spinlock_t               cifs_tcp_ses_lock;
> +/*
> + * This lock protects the cifsInodeInfo->openFileList as well as
> + * cifsFileInfo->flist|tlist.
> + */
> +GLOBAL_EXTERN spinlock_t               cifs_list_lock;
>
>  #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
>  /* Outstanding dir notify requests */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 06e27ac6d82c..8e96a5ae83bf 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file=
 *file,
>         atomic_inc(&tcon->num_local_opens);
>
>         /* if readable file instance put first in list*/
> +       spin_lock(&cifs_list_lock);
>         if (file->f_mode & FMODE_READ)
>                 list_add(&cfile->flist, &cinode->openFileList);
>         else
>                 list_add_tail(&cfile->flist, &cinode->openFileList);
> +       spin_unlock(&cifs_list_lock);

You are protecting cinode->openFileList here - this should be a lock
per inode structure.

>         spin_unlock(&tcon->open_file_lock);
>
>         if (fid->purge_cache)
> @@ -413,8 +415,10 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_fil=
e, bool wait_oplock_handler)
>         cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
>
>         /* remove it from the lists */
> +       spin_lock(&cifs_list_lock);
>         list_del(&cifs_file->flist);

The same here - inode lock.


>         list_del(&cifs_file->tlist);

It is a list per tcon - existing tcon lock is protecting here.

> +       spin_unlock(&cifs_list_lock);
>         atomic_dec(&tcon->num_local_opens);
>
>         if (list_empty(&cifsi->openFileList)) {
> @@ -1459,8 +1463,10 @@ void
>  cifs_move_llist(struct list_head *source, struct list_head *dest)
>  {
>         struct list_head *li, *tmp;
> +       spin_lock(&cifs_list_lock);
>         list_for_each_safe(li, tmp, source)
>                 list_move(li, dest);
> +       spin_unlock(&cifs_list_lock);
>  }
>
>  void
> @@ -1469,7 +1475,9 @@ cifs_free_llist(struct list_head *llist)
>         struct cifsLockInfo *li, *tmp;
>         list_for_each_entry_safe(li, tmp, llist, llist) {
>                 cifs_del_lock_waiters(li);
> +               spin_lock(&cifs_list_lock);
>                 list_del(&li->llist);
> +               spin_unlock(&cifs_list_lock);
>                 kfree(li);
>         }
>  }

Above two functions operate on lists of locks of inode's files - all
protected by cifsi->lock_sem.

> @@ -1950,9 +1958,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_i=
node, bool fsuid_only,
>                         return 0;
>                 }
>
> -               spin_lock(&tcon->open_file_lock);
> +               spin_lock(&cifs_list_lock);
>                 list_move_tail(&inv_file->flist, &cifs_inode->openFileLis=
t);
> -               spin_unlock(&tcon->open_file_lock);
> +               spin_unlock(&cifs_list_lock);

inode lock.

>                 cifsFileInfo_put(inv_file);
>                 ++refind;
>                 inv_file =3D NULL;
> --
> 2.13.6
>

What is the reasoning under using a global spin lock? Global locking
is always a source of performance problems and should be avoided as
much as possible.

--
Best regards,
Pavel Shilovsky
