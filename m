Return-Path: <SRS0=aXsT=UC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC28C04AB5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 23:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4089126329
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jun 2019 23:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LHYWuGHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfFCXul (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jun 2019 19:50:41 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42727 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfFCXul (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jun 2019 19:50:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id t28so6781013lje.9
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jun 2019 16:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JILy2Kwt5n5MgxuDI12h7mbqak8nD3cD0IpJivyH09k=;
        b=LHYWuGHq+CIPVFUEjAPYYTj37QJBHvwhypSonW+GSc6hclrpWmeJkWh+phrcGaizQs
         qi5lJ9EfvqvlPjHqVMbnStoed5riKRGXH/c2QL9+8vQx8mOSGoJKSql5Qs13ex/27rFT
         NhomMNGTTs8LKcTAwidJgvw0xLuVhJ9BxtWLTqcJFdRQVws518cCpMXgyYPuo7Gom25g
         m4XAM+h9J1QIBNgGVSVeC4+bIN8kN2sgjI3JVkPx/YMAeG4CnNn1qpQGPTisKHuWpw1v
         NMCIFbmkHLtIhc7lxN2pKXc6bO9f6rq/8PwaWfUba75TlO4Zs6K7Ri0JYqugpe4Ni7AV
         dzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JILy2Kwt5n5MgxuDI12h7mbqak8nD3cD0IpJivyH09k=;
        b=V5FAlX2TQZA70Y44qU9yzpPCevw1yt8J1tH/mV4EuzziyXDtjOTV6oqbsHx2QMW8sW
         wwZKPNAGNzQXysuf48x4TJK41sjwFE6zFU3G7EFJsFjDPXJ0vZdnLdzPpSHU15wtlprf
         9mRh//pTDOcVgv92CDHWCAZpFt8c/GqNOtlK7UvYRL0GY9s0j+upC7Rrj6K+H6b2ivbB
         n3lkjS9x2HErAPQyrK8/NuB/alicbwpMOrOiHskXfBg+f6pyW33njZpamZzO+x/AsX+h
         FIMWJ4VUiTG92dAO9KtBCPqZsjgoN6zGWgOj5OX+t3UxW4buDWlOoQislO0L7jhzIcIt
         Ab2A==
X-Gm-Message-State: APjAAAU/l4JmMdnSy8ekKmO3loS7wdUNkLL2VPoMvpvVjo7ErooNzV8k
        ch1hnArmftVyfOHWSPVibEC7lEiEp7FoRcih8Q==
X-Google-Smtp-Source: APXvYqzRmuhn6VXxvZG149zobtX5rYNnJAidIKP+N1E6ccRu5bun4DyPXFZ7DtV7lgnoBe1kseUrOat8wATG4x7uJNo=
X-Received: by 2002:a2e:8583:: with SMTP id b3mr15256506lji.136.1559605839243;
 Mon, 03 Jun 2019 16:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190603075922.27266-1-lsahlber@redhat.com> <CAKywueRZ-QVi1dZc2WMSZAT-9YVhS6Soy4jbaauP6ds+x-a9bA@mail.gmail.com>
 <CAN05THSmjLxZtJeb33XLddHR-nhzsTNxrBAbj8DzpJZ31X7qJg@mail.gmail.com>
In-Reply-To: <CAN05THSmjLxZtJeb33XLddHR-nhzsTNxrBAbj8DzpJZ31X7qJg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 3 Jun 2019 16:50:27 -0700
Message-ID: <CAKywueS1q4dWNdm7dDryM7iSSoL2YhJE5XywtnMDdD8=W_Yh_g@mail.gmail.com>
Subject: Re: [PATCH] cifs: add global spinlock for the openFileList
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 3 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 16:21, ronnie sahlb=
erg <ronniesahlberg@gmail.com>:
>
> On Tue, Jun 4, 2019 at 3:55 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
> >
> > =D0=BF=D0=BD, 3 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 01:02, Ronnie S=
ahlberg <lsahlber@redhat.com>:
> > >
> > > We can not depend on the tcon->open_file_lock here since in multiuser=
 mode
> > > we may have the same file/inode open via multiple different tcons.
> > >
> > > The current code is race prone and will crash if one user deletes a f=
ile
> > > at the same time a different user opens/create the file.
> > >
> > > RHBZ:  1580165
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/cifsfs.c   |  1 +
> > >  fs/cifs/cifsglob.h |  5 +++++
> > >  fs/cifs/file.c     | 12 ++++++++++--
> > >  3 files changed, 16 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index f5fcd6360056..20cc4eaa7a49 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -1459,6 +1459,7 @@ init_cifs(void)
> > >         GlobalTotalActiveXid =3D 0;
> > >         GlobalMaxActiveXid =3D 0;
> > >         spin_lock_init(&cifs_tcp_ses_lock);
> > > +       spin_lock_init(&cifs_list_lock);
> > >         spin_lock_init(&GlobalMid_Lock);
> > >
> > >         cifs_lock_secret =3D get_random_u32();
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 334ff5f9c3f3..807b7cd7d48d 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -1817,6 +1817,11 @@ GLOBAL_EXTERN struct list_head           cifs_=
tcp_ses_list;
> > >   * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
> > >   */
> > >  GLOBAL_EXTERN spinlock_t               cifs_tcp_ses_lock;
> > > +/*
> > > + * This lock protects the cifsInodeInfo->openFileList as well as
> > > + * cifsFileInfo->flist|tlist.
> > > + */
> > > +GLOBAL_EXTERN spinlock_t               cifs_list_lock;
> > >
> > >  #ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
> > >  /* Outstanding dir notify requests */
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 06e27ac6d82c..8e96a5ae83bf 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -338,10 +338,12 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct =
file *file,
> > >         atomic_inc(&tcon->num_local_opens);
> > >
> > >         /* if readable file instance put first in list*/
> > > +       spin_lock(&cifs_list_lock);
> > >         if (file->f_mode & FMODE_READ)
> > >                 list_add(&cfile->flist, &cinode->openFileList);
> > >         else
> > >                 list_add_tail(&cfile->flist, &cinode->openFileList);
> > > +       spin_unlock(&cifs_list_lock);
> >
> > You are protecting cinode->openFileList here - this should be a lock
> > per inode structure.
> >
> > >         spin_unlock(&tcon->open_file_lock);
> > >
> > >         if (fid->purge_cache)
> > > @@ -413,8 +415,10 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs=
_file, bool wait_oplock_handler)
> > >         cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
> > >
> > >         /* remove it from the lists */
> > > +       spin_lock(&cifs_list_lock);
> > >         list_del(&cifs_file->flist);
> >
> > The same here - inode lock.
> >
> >
> > >         list_del(&cifs_file->tlist);
> >
> > It is a list per tcon - existing tcon lock is protecting here.
> >
> > > +       spin_unlock(&cifs_list_lock);
> > >         atomic_dec(&tcon->num_local_opens);
> > >
> > >         if (list_empty(&cifsi->openFileList)) {
> > > @@ -1459,8 +1463,10 @@ void
> > >  cifs_move_llist(struct list_head *source, struct list_head *dest)
> > >  {
> > >         struct list_head *li, *tmp;
> > > +       spin_lock(&cifs_list_lock);
> > >         list_for_each_safe(li, tmp, source)
> > >                 list_move(li, dest);
> > > +       spin_unlock(&cifs_list_lock);
> > >  }
> > >
> > >  void
> > > @@ -1469,7 +1475,9 @@ cifs_free_llist(struct list_head *llist)
> > >         struct cifsLockInfo *li, *tmp;
> > >         list_for_each_entry_safe(li, tmp, llist, llist) {
> > >                 cifs_del_lock_waiters(li);
> > > +               spin_lock(&cifs_list_lock);
> > >                 list_del(&li->llist);
> > > +               spin_unlock(&cifs_list_lock);
> > >                 kfree(li);
> > >         }
> > >  }
> >
> > Above two functions operate on lists of locks of inode's files - all
> > protected by cifsi->lock_sem.
> >
> > > @@ -1950,9 +1958,9 @@ cifs_get_writable_file(struct cifsInodeInfo *ci=
fs_inode, bool fsuid_only,
> > >                         return 0;
> > >                 }
> > >
> > > -               spin_lock(&tcon->open_file_lock);
> > > +               spin_lock(&cifs_list_lock);
> > >                 list_move_tail(&inv_file->flist, &cifs_inode->openFil=
eList);
> > > -               spin_unlock(&tcon->open_file_lock);
> > > +               spin_unlock(&cifs_list_lock);
> >
> > inode lock.
> >
> > >                 cifsFileInfo_put(inv_file);
> > >                 ++refind;
> > >                 inv_file =3D NULL;
> > > --
> > > 2.13.6
> > >
> >
> > What is the reasoning under using a global spin lock? Global locking
> > is always a source of performance problems and should be avoided as
> > much as possible.
>
> In multiuser each user has their own tcon  so if user A and user B
> does a list_add/list_del at the same time
> they are not protected against eachother sicne A and B use different
> tcon->open_file_list spinlocks :-(

In this case both users still have the common thing to lock - inode,
so, locking should be a part of the inode structure to not slow access
to other files on the file system.

We also need to agree on the locking order here - tcon first and inode
second looks fine unless anybody has objections.

>
> I will do the other changes you suggest later today and re-send

Thanks for spotting the problem! It seems that multiuser mounts don't
have that much of usage but *theoretically* this is a right way to
setup SMB authorization on Linux.

--
Best regards,
Pavel Shilovsky
