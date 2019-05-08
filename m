Return-Path: <SRS0=nxME=TI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E1EC04A6B
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 18:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5048206A3
	for <linux-cifs@archiver.kernel.org>; Wed,  8 May 2019 18:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HdsCy/25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbfEHSmt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 May 2019 14:42:49 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44664 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfEHSmt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 May 2019 14:42:49 -0400
Received: by mail-lj1-f195.google.com with SMTP id e13so3799724ljl.11;
        Wed, 08 May 2019 11:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=801loZJ0jfUDsDQIz80w/KLYHC3XFpoSrb8jnyCcUpc=;
        b=HdsCy/25ugkm/lUT33Cdp9SCDR3PPtsEtERMBKrAgGnBfuTk0Pa3B9kp7wYnbdpSEl
         3oxqJ7ZalwWfJAJbpZnPpwkEox+Y9xfSwtoWoZeh7PY1myCTwf3rvUwq96Tu03WRKs9P
         ga/WZ1DmAueyA9p1SZea8o7w42563adY6WO7l1sevWTxTcVpex/lUjYDHrDCpzFw/ocV
         0/bOz+fphaAt9R2q9ks+/OvuECHfpYD1VXRk26eatens7j8xotJ3gtRv1VXRqpVwGEpI
         vgtG7pA2UyWDniJKik+WKfw/tBtuCxO0qzSBJg6xe26kATnkDKi9v+5dVcs8Ya66bYDf
         XYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=801loZJ0jfUDsDQIz80w/KLYHC3XFpoSrb8jnyCcUpc=;
        b=Xoyr44bjqONVGU4MrRdN/U9gllKkdlVjPd7+SYSiEW2cn809hgu2vQsNjy6LQsrWK9
         ePN5up4nyiQhCLnm8Sfk06wZ3jDkz7X3nkyT3bawMshdheV4yj6zpBvgx5a++jUFHrCZ
         +oHDkih5/MvPax7MwWuJmMZzrWFrlgATqOrXvkzW1toSn550H+y2eTJIbWRsYtR9NgV+
         IwM+K7IBPiQTYAiClvikoPsylCf0QVs/bkZfg9FvEZVvKVFuInanPdLttxniP0hsRMKA
         t3N86cOA+2ruzQ2OSKTNOl2XpHT30BBw7u+GKeCFrdcKc3EFtGXC5gx/U9CT9nX0xvlr
         GWkQ==
X-Gm-Message-State: APjAAAXLjiM4FOEEwIzplud8lPEPsJH9mtIyKp29jhG/MSARQ9hjl0ZB
        5ki3vBxPavqY2GHRIOvaUzeQlDa9Pp7iUiwnAw==
X-Google-Smtp-Source: APXvYqz4jT10Lf9x8VL/d7AxpIrEhLvPV774EkUC2LKN+8PSTXgttTrEIaOI9Fu2NEJf+WeV8s27ZgooAaxF56cZ6Ag=
X-Received: by 2002:a2e:7e0a:: with SMTP id z10mr7081279ljc.9.1557340966088;
 Wed, 08 May 2019 11:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <1557242200-26194-1-git-send-email-kernel@probst.it>
 <CAH2r5mtqkHYbHJkf_LbAjhujnNRQP6Zmkmqhj1dUHomwsc3e=w@mail.gmail.com>
 <CAKywueSJCs2B2cGmZvGNfxDU7KNvkBOsuyuaOSV=3GWG80f+kw@mail.gmail.com> <A4165E00-AA20-4550-96FE-651271B7091B@canonical.com>
In-Reply-To: <A4165E00-AA20-4550-96FE-651271B7091B@canonical.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 8 May 2019 11:42:35 -0700
Message-ID: <CAKywueQmjm3vhGZkLdB6J2rpjmKA6m0=N4A6bnsq3MW4acYHLQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix strcat buffer overflow and reduce raciness
 in smb21_set_oplock_level()
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Steve French <smfrench@gmail.com>,
        Christoph Probst <kernel@probst.it>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 8 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 01:23, Kai-Heng Feng=
 <kai.heng.feng@canonical.com>:
>
> at 02:28, Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> > =D0=B2=D1=82, 7 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 09:13, Steve Fre=
nch via samba-technical
> > <samba-technical@lists.samba.org>:
> >> merged into cifs-2.6.git for-next
> >>
> >> On Tue, May 7, 2019 at 10:17 AM Christoph Probst via samba-technical
> >> <samba-technical@lists.samba.org> wrote:
> >>> Change strcat to strncpy in the "None" case to fix a buffer overflow
> >>> when cinode->oplock is reset to 0 by another thread accessing the sam=
e
> >>> cinode. It is never valid to append "None" to any other message.
> >>>
> >>> Consolidate multiple writes to cinode->oplock to reduce raciness.
> >>>
> >>> Signed-off-by: Christoph Probst <kernel@probst.it>
> >>> ---
> >>>  fs/cifs/smb2ops.c | 14 ++++++++------
> >>>  1 file changed, 8 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> >>> index c36ff0d..aa61dcf 100644
> >>> --- a/fs/cifs/smb2ops.c
> >>> +++ b/fs/cifs/smb2ops.c
> >>> @@ -2917,26 +2917,28 @@ smb21_set_oplock_level(struct cifsInodeInfo
> >>> *cinode, __u32 oplock,
> >>>                        unsigned int epoch, bool *purge_cache)
> >>>  {
> >>>         char message[5] =3D {0};
> >>> +       unsigned int new_oplock =3D 0;
> >>>
> >>>         oplock &=3D 0xFF;
> >>>         if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
> >>>                 return;
> >>>
> >>> -       cinode->oplock =3D 0;
> >>>         if (oplock & SMB2_LEASE_READ_CACHING_HE) {
> >>> -               cinode->oplock |=3D CIFS_CACHE_READ_FLG;
> >>> +               new_oplock |=3D CIFS_CACHE_READ_FLG;
> >>>                 strcat(message, "R");
> >>>         }
> >>>         if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
> >>> -               cinode->oplock |=3D CIFS_CACHE_HANDLE_FLG;
> >>> +               new_oplock |=3D CIFS_CACHE_HANDLE_FLG;
> >>>                 strcat(message, "H");
> >>>         }
> >>>         if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
> >>> -               cinode->oplock |=3D CIFS_CACHE_WRITE_FLG;
> >>> +               new_oplock |=3D CIFS_CACHE_WRITE_FLG;
> >>>                 strcat(message, "W");
> >>>         }
> >>> -       if (!cinode->oplock)
> >>> -               strcat(message, "None");
> >>> +       if (!new_oplock)
> >>> +               strncpy(message, "None", sizeof(message));
> >>> +
> >>> +       cinode->oplock =3D new_oplock;
> >>>         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
> >>>                  &cinode->vfs_inode);
> >>>  }
> >>> --
> >>> 2.1.4
> >
>
> Doesn=E2=80=99t the race still happen, but implicitly here?
> cinode->oplock =3D new_oplock;
>
> Is it possible to just introduce a lock to force its proper ordering?
> e.g.
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index bf5b8264e119..a3c3c6156d17 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -267,6 +267,7 @@ cifs_alloc_inode(struct super_block *sb)
>           * server, can not assume caching of file data or metadata.
>           */
>          cifs_set_oplock_level(cifs_inode, 0);
> +       mutex_init(&cifs_inode->oplock_mutex);
>          cifs_inode->flags =3D 0;
>          spin_lock_init(&cifs_inode->writers_lock);
>          cifs_inode->writers =3D 0;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 37b5ddf27ff1..6dfd4ab16c4f 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1214,6 +1214,7 @@ struct cifsInodeInfo {
>          struct list_head openFileList;
>          __u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, sy=
stem */
>          unsigned int oplock;            /* oplock/lease level we have */
> +       struct mutex oplock_mutex;
>          unsigned int epoch;             /* used to track lease state cha=
nges */
>   #define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progre=
ss */
>   #define CIFS_INODE_PENDING_WRITERS       (1) /* Writes in progress */
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index b20063cf774f..796b23712e71 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1901,6 +1901,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode=
,
> __u32 oplock,
>          if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
>                  return;
>
> +       mutex_lock(&cinode->oplock_mutex);
>          cinode->oplock =3D 0;
>          if (oplock & SMB2_LEASE_READ_CACHING_HE) {
>                  cinode->oplock |=3D CIFS_CACHE_READ_FLG;
> @@ -1916,6 +1917,8 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode=
,
> __u32 oplock,
>          }
>          if (!cinode->oplock)
>                  strcat(message, "None");
> +       mutex_unlock(&cinode->oplock_mutex);
> +
>          cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
>                   &cinode->vfs_inode);
>   }
>
> Kai-Heng

Unless you calculations on the oplock value or accessing it multiple
times with some logic involved I don't think locking will help much.
If two threads are assigning the same variable, you can end up with
two possible outcomes regardless of whether locking is used or not.

Locking will be needed once we start to make proper decisions based on
previous and new values of the oplock to purge a page cache or flush
buffered data. This still needs to be done and is out of the scope of
this patch which aims to fix the buffer overflow error.

--
Best regards,
Pavel Shilovsky
