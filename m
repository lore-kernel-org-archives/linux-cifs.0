Return-Path: <SRS0=zgNb=YW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3A8CA9EC0
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 03:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 873AC21479
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Oct 2019 03:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OHkwjURU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfJ2DJK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Oct 2019 23:09:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49406 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730831AbfJ2DJJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Oct 2019 23:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572318548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hQGcgUXyZVIgwPcX+ChQCoNarqjlo03MxrZjJOly4A=;
        b=OHkwjURUObisghKdY4ospnnE/QmhifKz67uOnMBthgpagW/kM1gArWhDzKVlbJjzPDpRin
        FrUwqY3QIqQM9WvUhd1NET2bmrDNP46MNq9+trneakxXyn2jw1n1ahIh5TnRse08z1h6zJ
        oNFJR9Z4KlmszVdJm2w6JlPef1TKCcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-Wmre8eT2N0y9irfxfgVu1g-1; Mon, 28 Oct 2019 23:09:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EDAA801E5C;
        Tue, 29 Oct 2019 03:09:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63D5426344;
        Tue, 29 Oct 2019 03:09:05 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55F8018095FF;
        Tue, 29 Oct 2019 03:09:05 +0000 (UTC)
Date:   Mon, 28 Oct 2019 23:09:05 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <589180340.8825747.1572318545200.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAKywueRtakp4KX2=HafEy4WOZmCHC-f_ey1S9R6DzzxMQYBVvQ@mail.gmail.com>
References: <20191026210419.7575-1-lsahlber@redhat.com> <20191026210419.7575-2-lsahlber@redhat.com> <CAKywueRtakp4KX2=HafEy4WOZmCHC-f_ey1S9R6DzzxMQYBVvQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: move cifsFileInfo_put logic into a work-queue
MIME-Version: 1.0
X-Originating-IP: [10.64.54.48, 10.4.195.18]
Thread-Topic: cifs: move cifsFileInfo_put logic into a work-queue
Thread-Index: 6+pvrbe/P24XDYAlHMjMfzQhuEgWkg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Wmre8eT2N0y9irfxfgVu1g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "Pavel Shilovsky" <piastryyy@gmail.com>
> To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
> Sent: Tuesday, 29 October, 2019 9:18:40 AM
> Subject: Re: [PATCH] cifs: move cifsFileInfo_put logic into a work-queue
>=20
> =D1=81=D0=B1, 26 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 14:04, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > This patch moves the _put logic to be processed in a separate thread th=
at
> > holds no other locks to prevent deadlocks like below from happening
> >
>=20
> Ronnie,
>=20
> Thanks for creating the patch! Please find my comments below.

I will update the patch.  Thanks.

>=20
> ...
> >
> > Reported-by: Frank Sorenson <sorenson@redhat.com>:
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c   | 13 ++++++++-
> >  fs/cifs/cifsglob.h |  1 +
> >  fs/cifs/file.c     | 79
> >  +++++++++++++++++++++++++++++++++++++-----------------
> >  3 files changed, 68 insertions(+), 25 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index e4e3b573d20c..f8e201c45ccb 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -119,6 +119,7 @@ extern mempool_t *cifs_mid_poolp;
> >
> >  struct workqueue_struct        *cifsiod_wq;
> >  struct workqueue_struct        *decrypt_wq;
> > +struct workqueue_struct        *fileinfo_put_wq;
> >  struct workqueue_struct        *cifsoplockd_wq;
> >  __u32 cifs_lock_secret;
> >
> > @@ -1557,11 +1558,18 @@ init_cifs(void)
> >                 goto out_destroy_cifsiod_wq;
> >         }
> >
> > +       fileinfo_put_wq =3D alloc_workqueue("cifsfileinfoput",
> > +
> > WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLAIM,
> > 0);
> > +       if (!fileinfo_put_wq) {
> > +               rc =3D -ENOMEM;
> > +               goto out_destroy_decrypt_wq;
> > +       }
> > +
> >         cifsoplockd_wq =3D alloc_workqueue("cifsoplockd",
> >                                          WQ_FREEZABLE|WQ_MEM_RECLAIM, 0=
);
> >         if (!cifsoplockd_wq) {
> >                 rc =3D -ENOMEM;
> > -               goto out_destroy_decrypt_wq;
> > +               goto out_destroy_fileinfo_put_wq;
> >         }
> >
> >         rc =3D cifs_fscache_register();
> > @@ -1627,6 +1635,8 @@ init_cifs(void)
> >         cifs_fscache_unregister();
> >  out_destroy_cifsoplockd_wq:
> >         destroy_workqueue(cifsoplockd_wq);
> > +out_destroy_fileinfo_put_wq:
> > +       destroy_workqueue(fileinfo_put_wq);
> >  out_destroy_decrypt_wq:
> >         destroy_workqueue(decrypt_wq);
> >  out_destroy_cifsiod_wq:
> > @@ -1656,6 +1666,7 @@ exit_cifs(void)
> >         cifs_fscache_unregister();
> >         destroy_workqueue(cifsoplockd_wq);
> >         destroy_workqueue(decrypt_wq);
> > +       destroy_workqueue(fileinfo_put_wq);
> >         destroy_workqueue(cifsiod_wq);
> >         cifs_proc_clean();
> >  }
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 50dfd9049370..8361e30adcd9 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1902,6 +1902,7 @@ void cifs_queue_oplock_break(struct cifsFileInfo
> > *cfile);
> >  extern const struct slow_work_ops cifs_oplock_break_ops;
> >  extern struct workqueue_struct *cifsiod_wq;
> >  extern struct workqueue_struct *decrypt_wq;
> > +extern struct workqueue_struct *fileinfo_put_wq;
> >  extern struct workqueue_struct *cifsoplockd_wq;
> >  extern __u32 cifs_lock_secret;
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 0e0217641de1..e222cf04b325 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -368,30 +368,8 @@ cifsFileInfo_get(struct cifsFileInfo *cifs_file)
> >         return cifs_file;
> >  }
> >
> > -/**
> > - * cifsFileInfo_put - release a reference of file priv data
> > - *
> > - * Always potentially wait for oplock handler. See _cifsFileInfo_put()=
.
> > - */
> > -void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
> > -{
> > -       _cifsFileInfo_put(cifs_file, true);
> > -}
> > -
> > -/**
> > - * _cifsFileInfo_put - release a reference of file priv data
> > - *
> > - * This may involve closing the filehandle @cifs_file out on the
> > - * server. Must be called without holding tcon->open_file_lock and
> > - * cifs_file->file_info_lock.
> > - *
> > - * If @wait_for_oplock_handler is true and we are releasing the last
> > - * reference, wait for any running oplock break handler of the file
> > - * and cancel any pending one. If calling this function from the
> > - * oplock break handler, you need to pass false.
> > - *
> > - */
> > -void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool
> > wait_oplock_handler)
> > +static void
> > +_cifsFileInfo_put_work(struct cifsFileInfo *cifs_file, bool
> > wait_oplock_handler)
> >  {
> >         struct inode *inode =3D d_inode(cifs_file->dentry);
> >         struct cifs_tcon *tcon =3D tlink_tcon(cifs_file->tlink);
> > @@ -480,6 +458,59 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_f=
ile,
> > bool wait_oplock_handler)
> >         kfree(cifs_file);
> >  }
> >
> > +struct cifsFileInfo_w {
> > +       struct work_struct put;
> > +       struct cifsFileInfo *cifs_file;
> > +       bool wait_oplock_handler;
> > +};
> > +
> > +static void cifsFileInfo_put_work(struct work_struct *work)
> > +{
> > +       struct cifsFileInfo_w *cfiw =3D container_of(work,
> > +                                                  struct cifsFileInfo_=
w,
> > put);
> > +       _cifsFileInfo_put_work(cfiw->cifs_file, cfiw->wait_oplock_handl=
er);
> > +       kfree(cfiw);
> > +}
> > +
> > +/**
> > + * cifsFileInfo_put - release a reference of file priv data
> > + *
> > + * Always potentially wait for oplock handler. See _cifsFileInfo_put()=
.
> > + */
> > +void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
> > +{
> > +       _cifsFileInfo_put(cifs_file, true);
> > +}
> > +
> > +/**
> > + * _cifsFileInfo_put - release a reference of file priv data
> > + *
> > + * This may involve closing the filehandle @cifs_file out on the
> > + * server. Must be called without holding tcon->open_file_lock and
> > + * cifs_file->file_info_lock.
>=20
> cinode->open_file_lock should be mentioned here as well.
>=20
> > + *
> > + * If @wait_for_oplock_handler is true and we are releasing the last
> > + * reference, wait for any running oplock break handler of the file
> > + * and cancel any pending one. If calling this function from the
> > + * oplock break handler, you need to pass false.
> > + *
> > + */
> > +void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool
> > wait_oplock_handler)
> > +{
> > +       struct cifsFileInfo_w *work;
> > +
> > +       work =3D kmalloc(sizeof(struct cifsFileInfo_w), GFP_KERNEL);
>=20
> I would suggest to make this a part of cifsFileInfo structure (like
> oplock handling work) to avoid unnecessary memory allocations every
> time we put/close the handle.
>=20
> > +       if (work =3D=3D NULL) {
> > +               _cifsFileInfo_put_work(cifs_file, wait_oplock_handler);
> > +               return;
`> > +       }
> > +
> > +       INIT_WORK(&work->put, cifsFileInfo_put_work);
> > +       work->cifs_file =3D cifs_file;
> > +       work->wait_oplock_handler =3D wait_oplock_handler;
> > +       queue_work(fileinfo_put_wq, &work->put);
>=20
> I don't think we should offload the work to another thread
> unconditionally here - e.g. cifs_close() can safely do it in the same
> thread. Since there are more places where we want to offload, so let's
> do the similar thing as we have to the "wait_oplock_handler" argument:
>=20
> cifsFileInfo_put(cifs_file) -> _cifsFileInfo_put(cifs_file, true /*
> wait_oplock_handler */, true /* offload */);
>=20
> and convert cifs_close() to call _cifsFileInfo_put(cifs_file, true /*
> wait_oplock_handler */, false /* offload */);
>=20
> Note, that we do not need to conditionally cancel the worker thread as
> we do for the oplock handler because once we reach zero references
> there should be only one thread (we) that has access to the file info
> structure, thus no need to cancel anything. We may add a Warning if
> the work is scheduled but we reached zero references to highlight a
> potential bug.
>=20
> Also, as an optimization, we may use the caller thread to check the
> number of references and only offload if both conditions meet:
> "offload" argument is true and the current number of references is 1
> (putting the last reference). This optimization may be done in the
> same patch or as a separate patch.
>=20
> Thoughts?

Yes, that makes it much better. Thanks!

>=20
> --
> Best regards,
> Pavel Shilovsky
>=20

