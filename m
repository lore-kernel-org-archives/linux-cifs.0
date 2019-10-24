Return-Path: <SRS0=ZfIs=YR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C070CA9EAF
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Oct 2019 22:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF11D2166E
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Oct 2019 22:22:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dM3a70dc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfJXWWp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Oct 2019 18:22:45 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39211 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfJXWWp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Oct 2019 18:22:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id 195so20421807lfj.6
        for <linux-cifs@vger.kernel.org>; Thu, 24 Oct 2019 15:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aU0iP5CmSHUVI5uSPp29ZIOe+PEwKvMBMSbDGnySMlk=;
        b=dM3a70dca3wwQeWYngW2s9d2q2ef/1BhCUPoFxkZWe4yJUTpV6AiK2Q739tcNpM8rE
         VJcj8IhyArOdjOIYlQ3WEtjahYiyJWmjW0JpE+ivqK3YVTPmrNUFnLKxUe/6Qk3bQj31
         PTqQ0oUd6cr++cdmU6c+ACTw6RHOWiyWg5VEiXgy4hwXIq/iR0+RA3QnKzo6l/RZbFuA
         QRj5bXeujrnDKuqfXGExki73Nq4KYzugIF0w8LAIEfpZ/iwNXADbHwh07WwtRXzGca5x
         gzMN/QTltMB5ukfiOTa3BYnrLh/gUDBSGJq0I1lU1H/52Vya104H+0cxqDZLMosET5+n
         8Lxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aU0iP5CmSHUVI5uSPp29ZIOe+PEwKvMBMSbDGnySMlk=;
        b=ZwOTpmdnCu0n8STyJhyafHK9L70mz6q8RNJS9WzzAXFh42Ea7CuoNDVAWGmrMWJ4TV
         1mW7kZb4W5RdbXszfdTz0OMaU1Yu/mAhv7H2eKitvB/qFta/g3mvg6LS4vhmJUDfKj4C
         9HZHJgySLPGFWr0d2+sH+4w2bGRN9a+tyOe9wqwmt1+OjId3UGw+ZhN1jxcShq6M6fob
         /0IbBcKoGP+6BLiwUFF6Q6dG4fgJGBwEmOUWDmWpMdk4MOBAGBb76ko5iy79K/CCxgAI
         m1BS9opS/06LY/orSmwVkKUj1c0g5BHZQMXLjz8ztcm0dSkTMm2cmwZexLG0gZ4YekaT
         Lk8w==
X-Gm-Message-State: APjAAAV0uWACPZTGY/tDgSonxlbGqLofNPUbdGeWzNV67Qcq+s5QSh9Z
        vbFfFMBIBcgEHogbbrvpBr6n+zwsoywvRSaBu8yShbw=
X-Google-Smtp-Source: APXvYqwC715t4r/rnI8HGc6iVC5KjFAGBxSC8eVCUbbyXtFkWqKm/ez8871gHX1phFEFWlmwVq08TrTJyFiJxmGSksU=
X-Received: by 2002:ac2:55b4:: with SMTP id y20mr289654lfg.173.1571955761866;
 Thu, 24 Oct 2019 15:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <1571882902-23966-1-git-send-email-dwysocha@redhat.com>
In-Reply-To: <1571882902-23966-1-git-send-email-dwysocha@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 24 Oct 2019 15:22:30 -0700
Message-ID: <CAKywueTnbWBW9CtGL8vjYaPVOZxvG54=YNk=kYSJFA1gMQoC1w@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
To:     Dave Wysochanski <dwysocha@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 24 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 04:04, Dave Wysoch=
anski <dwysocha@redhat.com>:
>
> There's a deadlock that is possible and can easily be seen with
> a test where multiple readers open/read/close of the same file
> and a disruption occurs causing reconnect.  The deadlock is due
> a reader thread inside cifs_strict_readv calling down_read and
> obtaining lock_sem, and then after reconnect inside
> cifs_reopen_file calling down_read a second time.  If in
> between the two down_read calls, a down_write comes from
> another process, deadlock occurs.
>
>         CPU0                    CPU1
>         ----                    ----
> cifs_strict_readv()
>  down_read(&cifsi->lock_sem);
>                                _cifsFileInfo_put
>                                   OR
>                                cifs_new_fileinfo
>                                 down_write(&cifsi->lock_sem);
> cifs_reopen_file()
>  down_read(&cifsi->lock_sem);
>
> Fix the above by changing all down_write(lock_sem) calls to
> down_write_trylock(lock_sem)/msleep() loop, which in turn
> makes the second down_read call benign since it will never
> block behind the writer while holding lock_sem.
>
> Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> Suggested-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h |  5 +++++
>  fs/cifs/file.c     | 24 ++++++++++++++++--------
>  fs/cifs/smb2file.c |  3 ++-
>  3 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 50dfd9049370..2c4a7adbcb4e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1391,6 +1391,11 @@ struct cifs_writedata {
>  struct cifsInodeInfo {
>         bool can_cache_brlcks;
>         struct list_head llist; /* locks helb by this inode */
> +       /*
> +        * NOTE: Some code paths call down_read(lock_sem) twice, so
> +        * we must always use use down_write_trylock()/msleep() loop
> +        * to avoid deadlock.
> +        */
>         struct rw_semaphore lock_sem;   /* protect the fields above */
>         /* BB add in lists for dirty pages i.e. write caching info for op=
lock */
>         struct list_head openFileList;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5ad15de2bb4f..52454df5ae39 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -306,7 +306,8 @@ struct cifsFileInfo *
>         INIT_LIST_HEAD(&fdlocks->locks);
>         fdlocks->cfile =3D cfile;
>         cfile->llist =3D fdlocks;
> -       down_write(&cinode->lock_sem);
> +       while (!down_write_trylock(&cinode->lock_sem))
> +               msleep(125);
>         list_add(&fdlocks->llist, &cinode->llist);
>         up_write(&cinode->lock_sem);
>
> @@ -464,7 +465,8 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file=
, bool wait_oplock_handler)
>          * Delete any outstanding lock records. We'll lose them when the =
file
>          * is closed anyway.
>          */
> -       down_write(&cifsi->lock_sem);
> +       while (!down_write_trylock(&cifsi->lock_sem))
> +               msleep(125);

Please wrap the above code into a helper function e.g.
cifs_acquire_lock_sem(struct cifsInodeInfo *cinode) or any other name
you like.

Other than that it looks good.

--
Best regards,
Pavel Shilovsky
