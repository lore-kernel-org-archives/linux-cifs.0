Return-Path: <SRS0=aXsT=UC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1456BC04AB5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 23:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D0426583
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 23:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2/5X60y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfFCXVr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jun 2019 19:21:47 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52760 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCXVr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jun 2019 19:21:47 -0400
Received: by mail-it1-f196.google.com with SMTP id l21so8516491ita.2
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jun 2019 16:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=puy5GipYRMRDEedhaSTY2iWMflnqe40GecHbdvSMB4U=;
        b=j2/5X60ykP4m2ns/a0pekhEQuEjs4cv/OzTCL+ijzr9i3xcqvhNp4CylVyNOEbIra0
         5+XSjnWyfDn+K+mUs/9K4bI4gKAArCD1qM763IIa4Z7fvM7ppS0xgEn5P4ERPy0z7vLZ
         ZGmKKFJ5outTffpW0ANHgB0Am91nEqTGiHKSHnInVWV0cpj3R43+d8+8txVcJCxLlK2S
         laORA3MLURZtHeO6QHxksbp5AkN0wQJiEC5VZV0mOeNtKOxD4rGfVZs6ujZrewQ8+JuQ
         DfoxkCpL8fkH3oTlv4R+P0FwoHZlq6IdIcq63Z/FxGGDkMs4D2dCmJ55Zwo5KcpB8KD6
         Ymyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=puy5GipYRMRDEedhaSTY2iWMflnqe40GecHbdvSMB4U=;
        b=sWSbTLzB3pxMKcyTSgcdTZQhKmns4Hp76+q+4Pd4orP2GUKymB6+awynIdz+lEAWOI
         R9iSeFq6XV7HJuO6mLzlPVbALQ3YrsEZ2Im1OviDEXTKqKSqeiA7Aghs+yielrlKztSo
         0OChFE/Me1QV9rHEzO23rSD3QPi6XFAf8sDG11Klmnv+FkoYwvWpru7fIBzEW5BwUCbK
         FkNu6Sw3YcfScdFmmCbxgbJXdwB5o2XmEXMNcn/v2QRrjRVX6MgMzmPY4P9IALeyU2O9
         girv8GSBh0IUqnSmP4MpdPstX/3Cd3LCd/P4AIpXOH/i7Ty30KjXvMOCl+5reEJJRFOs
         SyfQ==
X-Gm-Message-State: APjAAAWy8sFD43W31Gat/l53oGU+PQ7NENm9kgJII+ekSZ2vbGm89o51
        rNj1zewrA3DqRudWIg+V3kTPACz7uO8OrWvzdPE=
X-Google-Smtp-Source: APXvYqx+CZBGjAmNykqOlfov9RhRNydONIyPFh74sl1GXWT8R1edcWVGSGn9cifvdESq69x5Tpt9amkF/BzHvtO0Rmk=
X-Received: by 2002:a24:292:: with SMTP id 140mr20454900itu.57.1559604105931;
 Mon, 03 Jun 2019 16:21:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190603075922.27266-1-lsahlber@redhat.com> <CAKywueRZ-QVi1dZc2WMSZAT-9YVhS6Soy4jbaauP6ds+x-a9bA@mail.gmail.com>
In-Reply-To: <CAKywueRZ-QVi1dZc2WMSZAT-9YVhS6Soy4jbaauP6ds+x-a9bA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 4 Jun 2019 09:21:34 +1000
Message-ID: <CAN05THSmjLxZtJeb33XLddHR-nhzsTNxrBAbj8DzpJZ31X7qJg@mail.gmail.com>
Subject: Re: [PATCH] cifs: add global spinlock for the openFileList
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 4, 2019 at 3:55 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D0=BF=D0=BD, 3 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 01:02, Ronnie Sah=
lberg <lsahlber@redhat.com>:
> >
> > We can not depend on the tcon->open_file_lock here since in multiuser m=
ode
> > we may have the same file/inode open via multiple different tcons.
> >
> > The current code is race prone and will crash if one user deletes a fil=
e
> > at the same time a different user opens/create the file.
> >
> > RHBZ:  1580165
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c   |  1 +
> >  fs/cifs/cifsglob.h |  5 +++++
> >  fs/cifs/file.c     | 12 ++++++++++--
> >  3 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index f5fcd6360056..20cc4eaa7a49 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -1459,6 +1459,7 @@ init_cifs(void)
> >         GlobalTotalActiveXid =3D 0;
> >         GlobalMaxActiveXid =3D 0;
> >         spin_lock_init(&cifs_tcp_ses_lock);
> > +       spin_lock_init(&cifs_list_lock);
> >         spin_lock_init(&GlobalMid_Lock);
> >
> >         cifs_lock_secret =3D get_random_u32();
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 334ff5f9c3f3..807b7cd7d48d 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1817,6 +1817,11 @@ GLOBAL_EXTERN struct list_head           cifs_tc=
p_ses_list;
> >   * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
> >   */
> >  GLOBAL_EXTERN spinlock_t               cifs_tcp_ses_lock;
> > +/*
> > + * This lock protects the cifsInodeInfo->openFileList as well as
> > + * cifsFileInfo->flist|tlist.
> > + */
> > +GLOBAL_EXTERN spinlock_t               cifs_list_lock;
> >
> >  #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
> >  /* Outstanding dir notify requests */
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 06e27ac6d82c..8e96a5ae83bf 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct fi=
le *file,
> >         atomic_inc(&tcon->num_local_opens);
> >
> >         /* if readable file instance put first in list*/
> > +       spin_lock(&cifs_list_lock);
> >         if (file->f_mode & FMODE_READ)
> >                 list_add(&cfile->flist, &cinode->openFileList);
> >         else
> >                 list_add_tail(&cfile->flist, &cinode->openFileList);
> > +       spin_unlock(&cifs_list_lock);
>
> You are protecting cinode->openFileList here - this should be a lock
> per inode structure.
>
> >         spin_unlock(&tcon->open_file_lock);
> >
> >         if (fid->purge_cache)
> > @@ -413,8 +415,10 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_f=
ile, bool wait_oplock_handler)
> >         cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
> >
> >         /* remove it from the lists */
> > +       spin_lock(&cifs_list_lock);
> >         list_del(&cifs_file->flist);
>
> The same here - inode lock.
>
>
> >         list_del(&cifs_file->tlist);
>
> It is a list per tcon - existing tcon lock is protecting here.
>
> > +       spin_unlock(&cifs_list_lock);
> >         atomic_dec(&tcon->num_local_opens);
> >
> >         if (list_empty(&cifsi->openFileList)) {
> > @@ -1459,8 +1463,10 @@ void
> >  cifs_move_llist(struct list_head *source, struct list_head *dest)
> >  {
> >         struct list_head *li, *tmp;
> > +       spin_lock(&cifs_list_lock);
> >         list_for_each_safe(li, tmp, source)
> >                 list_move(li, dest);
> > +       spin_unlock(&cifs_list_lock);
> >  }
> >
> >  void
> > @@ -1469,7 +1475,9 @@ cifs_free_llist(struct list_head *llist)
> >         struct cifsLockInfo *li, *tmp;
> >         list_for_each_entry_safe(li, tmp, llist, llist) {
> >                 cifs_del_lock_waiters(li);
> > +               spin_lock(&cifs_list_lock);
> >                 list_del(&li->llist);
> > +               spin_unlock(&cifs_list_lock);
> >                 kfree(li);
> >         }
> >  }
>
> Above two functions operate on lists of locks of inode's files - all
> protected by cifsi->lock_sem.
>
> > @@ -1950,9 +1958,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs=
_inode, bool fsuid_only,
> >                         return 0;
> >                 }
> >
> > -               spin_lock(&tcon->open_file_lock);
> > +               spin_lock(&cifs_list_lock);
> >                 list_move_tail(&inv_file->flist, &cifs_inode->openFileL=
ist);
> > -               spin_unlock(&tcon->open_file_lock);
> > +               spin_unlock(&cifs_list_lock);
>
> inode lock.
>
> >                 cifsFileInfo_put(inv_file);
> >                 ++refind;
> >                 inv_file =3D NULL;
> > --
> > 2.13.6
> >
>
> What is the reasoning under using a global spin lock? Global locking
> is always a source of performance problems and should be avoided as
> much as possible.

In multiuser each user has their own tcon  so if user A and user B
does a list_add/list_del at the same time
they are not protected against eachother sicne A and B use different
tcon->open_file_list spinlocks :-(

I will do the other changes you suggest later today and re-send
>
> --
> Best regards,
> Pavel Shilovsky
