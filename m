Return-Path: <SRS0=uI0J=YV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D14CA9EC0
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Oct 2019 23:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7186E214E0
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Oct 2019 23:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u7dVKbbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfJ1XS5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Oct 2019 19:18:57 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42318 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfJ1XS4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Oct 2019 19:18:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so13162114ljh.9
        for <linux-cifs@vger.kernel.org>; Mon, 28 Oct 2019 16:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xT/ZHUdnnFGv0+dKACOZ9tFuBtbo/66azQKuxeRJEmw=;
        b=u7dVKbbRQNig6BDY3xUi95KdTY30OorR0c6cbkKue10v8Q7l8BBbf5cLrrzbwSeDBm
         Gyj0AoMsbAYctr0WvxFtrWPlLHrE0BZToWXiBVGJXQvXFLEP67pg4swK6agExeVJKXQE
         9SqtCq1iV07440Z8M8T8iMm1s7gVSNOn3UE/UDAZrsAeqJ1gjm59eFVgsEcY7eEhBMk0
         Az+WSqA/DWYgOxeCPKsgE01OqCgfyjG9diQjH5hJznJ7LR/5zR4NKptQo7UqzGLkOhh+
         lOSvhbvCyfFHBMNYNMJ6Z2y4TG8km3zmPM+f6IQlW+DoYXpIv3QVjUaXNl8f4O0kPaZy
         n/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xT/ZHUdnnFGv0+dKACOZ9tFuBtbo/66azQKuxeRJEmw=;
        b=MLq7xMC7qB1xJ+z+wiWaGqwtvraCvS7kxUaydLCaocofhJGP43UU/uJmzLHIjfKQr8
         Mkv01Xu+pzLz+KTVJ7lI88LkqYmT6MkXgKYm3c2loQJ038SBoxyOgb4QjIApMpzRcSRE
         wynuuuOYmPD3SKRqpRP+i8Mu5yctMjwBbOR/9LUauw0e89zYPR419IABAQ5s5CgQf7AS
         UgurY+nE1MlqYNBOJGg4uux/qF7wRiHvCVG/2biljlH2nf07SKa/IArS5KojSu/MboX+
         y7Uo8LnOBBS19rlgJ7LaSGzp/yf74kHmZUke3PCYYZJQ9giXs5Gjr6WQ2fNMR5ZyY/83
         AoGA==
X-Gm-Message-State: APjAAAULLoCfOV99t4hsOxY0HhSdYpgSSacFiP/d8sf3qZ/9RREyVMfm
        y2MVxpeGQcSQGwN054FRsR/BgtvaIwrd7yWId9TJ95U=
X-Google-Smtp-Source: APXvYqxt/ucFw/IFUWfeqTTQ/J8iQ765RL5zQSzbn0113T/PJrPiEdBMBpEayTuzQZ2F9jng70dMm9jWSCAG6ZyoxxI=
X-Received: by 2002:a2e:9942:: with SMTP id r2mr211692ljj.168.1572304732299;
 Mon, 28 Oct 2019 16:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191026210419.7575-1-lsahlber@redhat.com> <20191026210419.7575-2-lsahlber@redhat.com>
In-Reply-To: <20191026210419.7575-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 28 Oct 2019 16:18:40 -0700
Message-ID: <CAKywueRtakp4KX2=HafEy4WOZmCHC-f_ey1S9R6DzzxMQYBVvQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: move cifsFileInfo_put logic into a work-queue
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D0=B1, 26 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 14:04, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> This patch moves the _put logic to be processed in a separate thread that
> holds no other locks to prevent deadlocks like below from happening
>

Ronnie,

Thanks for creating the patch! Please find my comments below.

...
>
> Reported-by: Frank Sorenson <sorenson@redhat.com>:
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c   | 13 ++++++++-
>  fs/cifs/cifsglob.h |  1 +
>  fs/cifs/file.c     | 79 +++++++++++++++++++++++++++++++++++++-----------=
------
>  3 files changed, 68 insertions(+), 25 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e4e3b573d20c..f8e201c45ccb 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -119,6 +119,7 @@ extern mempool_t *cifs_mid_poolp;
>
>  struct workqueue_struct        *cifsiod_wq;
>  struct workqueue_struct        *decrypt_wq;
> +struct workqueue_struct        *fileinfo_put_wq;
>  struct workqueue_struct        *cifsoplockd_wq;
>  __u32 cifs_lock_secret;
>
> @@ -1557,11 +1558,18 @@ init_cifs(void)
>                 goto out_destroy_cifsiod_wq;
>         }
>
> +       fileinfo_put_wq =3D alloc_workqueue("cifsfileinfoput",
> +                                    WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLA=
IM, 0);
> +       if (!fileinfo_put_wq) {
> +               rc =3D -ENOMEM;
> +               goto out_destroy_decrypt_wq;
> +       }
> +
>         cifsoplockd_wq =3D alloc_workqueue("cifsoplockd",
>                                          WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>         if (!cifsoplockd_wq) {
>                 rc =3D -ENOMEM;
> -               goto out_destroy_decrypt_wq;
> +               goto out_destroy_fileinfo_put_wq;
>         }
>
>         rc =3D cifs_fscache_register();
> @@ -1627,6 +1635,8 @@ init_cifs(void)
>         cifs_fscache_unregister();
>  out_destroy_cifsoplockd_wq:
>         destroy_workqueue(cifsoplockd_wq);
> +out_destroy_fileinfo_put_wq:
> +       destroy_workqueue(fileinfo_put_wq);
>  out_destroy_decrypt_wq:
>         destroy_workqueue(decrypt_wq);
>  out_destroy_cifsiod_wq:
> @@ -1656,6 +1666,7 @@ exit_cifs(void)
>         cifs_fscache_unregister();
>         destroy_workqueue(cifsoplockd_wq);
>         destroy_workqueue(decrypt_wq);
> +       destroy_workqueue(fileinfo_put_wq);
>         destroy_workqueue(cifsiod_wq);
>         cifs_proc_clean();
>  }
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 50dfd9049370..8361e30adcd9 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1902,6 +1902,7 @@ void cifs_queue_oplock_break(struct cifsFileInfo *c=
file);
>  extern const struct slow_work_ops cifs_oplock_break_ops;
>  extern struct workqueue_struct *cifsiod_wq;
>  extern struct workqueue_struct *decrypt_wq;
> +extern struct workqueue_struct *fileinfo_put_wq;
>  extern struct workqueue_struct *cifsoplockd_wq;
>  extern __u32 cifs_lock_secret;
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0e0217641de1..e222cf04b325 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -368,30 +368,8 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
>         return cifs_file;
>  }
>
> -/**
> - * cifsFileInfo_put - release a reference of file priv data
> - *
> - * Always potentially wait for oplock handler. See _cifsFileInfo_put().
> - */
> -void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
> -{
> -       _cifsFileInfo_put(cifs_file, true);
> -}
> -
> -/**
> - * _cifsFileInfo_put - release a reference of file priv data
> - *
> - * This may involve closing the filehandle @cifs_file out on the
> - * server. Must be called without holding tcon->open_file_lock and
> - * cifs_file->file_info_lock.
> - *
> - * If @wait_for_oplock_handler is true and we are releasing the last
> - * reference, wait for any running oplock break handler of the file
> - * and cancel any pending one. If calling this function from the
> - * oplock break handler, you need to pass false.
> - *
> - */
> -void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_=
handler)
> +static void
> +_cifsFileInfo_put_work(struct cifsFileInfo *cifs_file, bool wait_oplock_=
handler)
>  {
>         struct inode *inode =3D d_inode(cifs_file->dentry);
>         struct cifs_tcon *tcon =3D tlink_tcon(cifs_file->tlink);
> @@ -480,6 +458,59 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_fil=
e, bool wait_oplock_handler)
>         kfree(cifs_file);
>  }
>
> +struct cifsFileInfo_w {
> +       struct work_struct put;
> +       struct cifsFileInfo *cifs_file;
> +       bool wait_oplock_handler;
> +};
> +
> +static void cifsFileInfo_put_work(struct work_struct *work)
> +{
> +       struct cifsFileInfo_w *cfiw =3D container_of(work,
> +                                                  struct cifsFileInfo_w,=
 put);
> +       _cifsFileInfo_put_work(cfiw->cifs_file, cfiw->wait_oplock_handler=
);
> +       kfree(cfiw);
> +}
> +
> +/**
> + * cifsFileInfo_put - release a reference of file priv data
> + *
> + * Always potentially wait for oplock handler. See _cifsFileInfo_put().
> + */
> +void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
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

cinode->open_file_lock should be mentioned here as well.

> + *
> + * If @wait_for_oplock_handler is true and we are releasing the last
> + * reference, wait for any running oplock break handler of the file
> + * and cancel any pending one. If calling this function from the
> + * oplock break handler, you need to pass false.
> + *
> + */
> +void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_=
handler)
> +{
> +       struct cifsFileInfo_w *work;
> +
> +       work =3D kmalloc(sizeof(struct cifsFileInfo_w), GFP_KERNEL);

I would suggest to make this a part of cifsFileInfo structure (like
oplock handling work) to avoid unnecessary memory allocations every
time we put/close the handle.

> +       if (work =3D=3D NULL) {
> +               _cifsFileInfo_put_work(cifs_file, wait_oplock_handler);
> +               return;
> +       }
> +
> +       INIT_WORK(&work->put, cifsFileInfo_put_work);
> +       work->cifs_file =3D cifs_file;
> +       work->wait_oplock_handler =3D wait_oplock_handler;
> +       queue_work(fileinfo_put_wq, &work->put);

I don't think we should offload the work to another thread
unconditionally here - e.g. cifs_close() can safely do it in the same
thread. Since there are more places where we want to offload, so let's
do the similar thing as we have to the "wait_oplock_handler" argument:

cifsFileInfo_put(cifs_file) -> _cifsFileInfo_put(cifs_file, true /*
wait_oplock_handler */, true /* offload */);

and convert cifs_close() to call _cifsFileInfo_put(cifs_file, true /*
wait_oplock_handler */, false /* offload */);

Note, that we do not need to conditionally cancel the worker thread as
we do for the oplock handler because once we reach zero references
there should be only one thread (we) that has access to the file info
structure, thus no need to cancel anything. We may add a Warning if
the work is scheduled but we reached zero references to highlight a
potential bug.

Also, as an optimization, we may use the caller thread to check the
number of references and only offload if both conditions meet:
"offload" argument is true and the current number of references is 1
(putting the last reference). This optimization may be done in the
same patch or as a separate patch.

Thoughts?

--
Best regards,
Pavel Shilovsky
