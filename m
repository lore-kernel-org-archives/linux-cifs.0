Return-Path: <SRS0=Yjbq=YQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00553CA9EB6
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 09:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE58121906
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 09:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfFmKEFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390656AbfJWJCB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Oct 2019 05:02:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48851 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390640AbfJWJCA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Oct 2019 05:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571821319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AWxfr+EUZsXA8gj2FufMpIFo3qd25PIS+Tnl+MsNBiU=;
        b=JfFmKEFh+CymDBeUqOtM/RGOB6oCic9IFXTrW7WzVf/5BJWzlxSW3U0n0pUb/Qe/r8zM73
        FgOgdvqINuI2NdjYMq0jwqrDpRpxCEWIr8ofhF7UcpYQZvKvRd2U/wKvJrbW8csWJHj2tH
        E0Abfyknj9A/0l0n8hFfsLt97syK6F8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-QSLelXi_PPqm-avZX-9r9w-1; Wed, 23 Oct 2019 05:01:55 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8412B1800D6B
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 09:01:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BBCB19C70
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 09:01:54 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 70FFB18089C8;
        Wed, 23 Oct 2019 09:01:54 +0000 (UTC)
Date:   Wed, 23 Oct 2019 05:01:54 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     David Wysochanski <dwysocha@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <147861584.8131501.1571821314367.JavaMail.zimbra@redhat.com>
In-Reply-To: <CALF+zO=4Y1kAYWAkP0A-6h7m4bxrm-fVvzeogMvN06uzQB-EBQ@mail.gmail.com>
References: <1571776423-32000-1-git-send-email-dwysocha@redhat.com> <1786263555.8106229.1571806248056.JavaMail.zimbra@redhat.com> <CALF+zO=4Y1kAYWAkP0A-6h7m4bxrm-fVvzeogMvN06uzQB-EBQ@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock with
 multiple readers
MIME-Version: 1.0
X-Originating-IP: [10.64.54.48, 10.4.195.16]
Thread-Topic: cifs: Fix cifsInodeInfo lock_sem deadlock with multiple readers
Thread-Index: JFyZ8aK6V4XkQEgNlJvC2z2CLWcHmg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: QSLelXi_PPqm-avZX-9r9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "David Wysochanski" <dwysocha@redhat.com>
> To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
> Sent: Wednesday, 23 October, 2019 6:35:34 PM
> Subject: Re: [RFC PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock with m=
ultiple readers
>=20
> On Wed, Oct 23, 2019 at 12:50 AM Ronnie Sahlberg <lsahlber@redhat.com> wr=
ote:
> >
> >
> >
> >
> >
> > ----- Original Message -----
> > > From: "Dave Wysochanski" <dwysocha@redhat.com>
> > > To: linux-cifs@vger.kernel.org
> > > Sent: Wednesday, 23 October, 2019 6:33:43 AM
> > > Subject: [RFC PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock with
> > > multiple readers
> > >
> > > NOTE: I have verified this fixes the problem but have not run
> > > locking tests yet.
> > >
> > > There's a deadlock that is possible that can easily be seen with
> > > multiple readers open/read/close of the same file.  The deadlock
> > > is due to a reader calling down_read(lock_sem) and holding
> > > it across the full IO, even if a network or server disruption
> > > occurs and the session has to be reconnected.  Upon reconnect,
> > > cifs_relock_file is called where down_read(lock_sem) is called
> > > a second time.  Normally this is not a problem, but if there is
> > > another process that calls down_write(lock_sem) in between the
> > > first and second reader call to down_read(lock_sem), this will
> > > cause a deadlock.  The caller of down_write (often either
> > > _cifsFileInfo_put that is just removing and freeing cifsLockInfo
> > > structures from the list of locks, or cifs_new_fileinfo, which
> > > is just attaching cifs_fid_locks to cifsInodeInfo->llist), will
> > > block due to the reader's first down_read(lock_sem) that obtains
> > > the semaphore (read IO in flight).  And then when the server
> > > comes back up, the reader that holds calls down_read(lock_sem)
> > > a second time, and this time is blocked too because of the
> > > blocked in down_write (rw_semaphores would starve writers if
> > > this was not the case).  Interestingly enough, the callers of
> > > down_write in the simple test case was not adding a
> > > conflicting lock at all, just either opening or closing the
> > > file, and modifying the list of locks attached to cifsInodeInfo,
> > > this ends up tripping up the reader process and causing the
> > > deadlock.
> > >
> > > The root of the problem is that lock_sem both protects the
> > > cifsInodeInfo fields (such as the lllist - the list of locks),
> > > but is also being re-used to avoid a conflicting lock coming
> > > in while IO is in flight.  Add a new semaphore that tracks
> > > just the IO in flight, and must be obtained before adding
> > > a new lock.  While this does add another layer of complexity
> > > and a semaphore ordering that must be obeyed to avoid new
> > > deadlocks, it does clealy solve the underlying problem.
> >
> > The patch is hard to read(not your fault) since "patch" decided that al=
most
> > all changes are in cifs_closedir() :-(
> >
>=20
> Sorry I should have also said in the header that the patch was built
> on top of 5.4-rc4 plus Pavel's patch:
> "CIFS: Fix retry mid list corruption on reconnects"
>=20
> Also, there is an obvious bug in this patch where I am taking lock_sem
> inside cifs_find_lock_conflict but that
> does not work for obvious reasons - needs to be moved back to callers.
> FWIW, I have a v2 patch that fixes
> that and I have started some locking tests on.
>=20
> >
> > You are reverting 560d388950. it is unfortunate because I think we shou=
ld
> > make either cifs_reopen_file() or cifs_strict_readv()
> > using down_read_nested() to suppress the warnings from the validator or
> > else we will get a lot of these log entries in dmesg
> > (almost) everytime we get a reconnect.
> >
>=20
> I think you misunderstood the patch or the header didn't explain that
> part.  It is actually removing the top level holding of
> lock_sem across the IO, because that leads to the deadlock - the root
> is that one process calls down_read twice, which
> IMO is erroneous.
>=20
> Instead of leaving the code paths where down_read can be called twice,
> there is a new rw_semaphore, inflight_io_sem, that
> protects the IO from someone adding a brlock that would restrict the
> IO.  The lock_sem still protects the same fields from
> modification, it just does not cover "preventing someone from adding a
> conflicting brlock during IO".
>=20
>=20
> > A different approach, could be to change _cifsFileInfo_put() to use a
> > down_write_trylock()-sleep() loop instead of a blocking down_write() ca=
ll.
> >
> > I.e. something like this ?
> > (and then the same at the other places where we have a deadlock vulnera=
ble
> > down_write() call)
> >
>=20
> Yes your approach is less lines way to go about preventing the
> deadlock.  The biggest downsides I see is that it does not
> remove the code paths which call down_read twice (which is dangerous
> for the reason here), and it does not eliminate
> (but does reduce) the lock contention due to multi-use nature of
> lock_sem (not only does it protect modification to the
> fields, it also doubles as preventing the conflicting brlock during
> IO).  I agree it is simpler and avoids adding another
> semaphore so it may be a better approach.
>=20
> For your suggested approach, I'm not sure how many places there are
> that really matter as far as calls to down_write.
> Looks like there are 9 different calls to down_write(cifsi->lock_sem),
> and I know in the reproducer at least 2 of them matter.



> I would say we should do all 9 to be thorough, not leave anything to
> chance, and have consistent handling of lock_sem.
> What do you think?

I agree 100%.

Lets do it for all 9 instances and add a comment to the header where we spe=
cify that
we must always use a down_write_trylock()/msleep() instead of down_write() =
for this because we may need to call down_read() recursively in some
codepaths.

Doing it for all places whether we strictly need to or not, today, is most =
future proof since the number of places where we MUST
do this can change in the future with semi-unrelated patches and then we wo=
uld accidentally reintroduce the deadlock.


Can you try a simple patch where we do this for all 9 places and see if fix=
es the deadlock?
And send to the list if it works?

Since the patch is so trivial being just a
- down_write()
+ if (!down_write_trylock())
+      msleep()
it will be trivial to backport it to earlier versions.



regards
ronnie sahlberg


>=20
>=20
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 936e03892e2a..530af080dc61 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -464,7 +464,8 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_fi=
le,
> > bool wait_oplock_handler)
> >          * Delete any outstanding lock records. We'll lose them when th=
e
> >          file
> >          * is closed anyway.
> >          */
> > -       down_write(&cifsi->lock_sem);
> > +       while (!down_write_trylock(&cifsi->lock_sem))
> > +               msleep(125);
> >         list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, lli=
st)
> >         {
> >                 list_del(&li->llist);
> >                 cifs_del_lock_waiters(li);
> >
> >
> >
> >
> > >
> > > Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> > > ---
> > >  fs/cifs/cifsfs.c   |  1 +
> > >  fs/cifs/cifsglob.h |  1 +
> > >  fs/cifs/file.c     | 24 +++++++++++++++++++-----
> > >  3 files changed, 21 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index c049c7b3aa87..10f614324e4e 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -1336,6 +1336,7 @@ static ssize_t cifs_copy_file_range(struct file
> > > *src_file, loff_t off,
> > >
> > >       inode_init_once(&cifsi->vfs_inode);
> > >       init_rwsem(&cifsi->lock_sem);
> > > +     init_rwsem(&cifsi->io_inflight_sem);
> > >  }
> > >
> > >  static int __init
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 50dfd9049370..40e8358dc1cc 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -1392,6 +1392,7 @@ struct cifsInodeInfo {
> > >       bool can_cache_brlcks;
> > >       struct list_head llist; /* locks helb by this inode */
> > >       struct rw_semaphore lock_sem;   /* protect the fields above */
> > > +     struct rw_semaphore io_inflight_sem; /* Used to avoid lock
> > > conflicts  */
> > >       /* BB add in lists for dirty pages i.e. write caching info for
> > >       oplock */
> > >       struct list_head openFileList;
> > >       spinlock_t      open_file_lock; /* protects openFileList */
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 5ad15de2bb4f..417baa7f5dd3 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -621,7 +621,7 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> > >       struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> > >       int rc =3D 0;
> > >
> > > -     down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
> > > +     down_read(&cinode->lock_sem);
> > >       if (cinode->can_cache_brlcks) {
> > >               /* can cache locks - no need to relock */
> > >               up_read(&cinode->lock_sem);
> > > @@ -973,6 +973,7 @@ int cifs_closedir(struct inode *inode, struct fil=
e
> > > *file)
> > >       struct cifs_fid_locks *cur;
> > >       struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry))=
;
> > >
> > > +     down_read(&cinode->lock_sem);
> > >       list_for_each_entry(cur, &cinode->llist, llist) {
> > >               rc =3D cifs_find_fid_lock_conflict(cur, offset, length,=
 type,
> > >                                                flags, cfile, conf_loc=
k,
> > > @@ -980,6 +981,7 @@ int cifs_closedir(struct inode *inode, struct fil=
e
> > > *file)
> > >               if (rc)
> > >                       break;
> > >       }
> > > +     up_read(&cinode->lock_sem);
> > >
> > >       return rc;
> > >  }
> > > @@ -1027,9 +1029,11 @@ int cifs_closedir(struct inode *inode, struct =
file
> > > *file)
> > >  cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
> > >  {
> > >       struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry))=
;
> > > +     down_write(&cinode->io_inflight_sem);
> > >       down_write(&cinode->lock_sem);
> > >       list_add_tail(&lock->llist, &cfile->llist->locks);
> > >       up_write(&cinode->lock_sem);
> > > +     up_write(&cinode->io_inflight_sem);
> > >  }
> > >
> > >  /*
> > > @@ -1049,6 +1053,7 @@ int cifs_closedir(struct inode *inode, struct f=
ile
> > > *file)
> > >
> > >  try_again:
> > >       exist =3D false;
> > > +     down_write(&cinode->io_inflight_sem);
> > >       down_write(&cinode->lock_sem);
> > >
> > >       exist =3D cifs_find_lock_conflict(cfile, lock->offset, lock->le=
ngth,
> > > @@ -1057,6 +1062,7 @@ int cifs_closedir(struct inode *inode, struct f=
ile
> > > *file)
> > >       if (!exist && cinode->can_cache_brlcks) {
> > >               list_add_tail(&lock->llist, &cfile->llist->locks);
> > >               up_write(&cinode->lock_sem);
> > > +             up_write(&cinode->io_inflight_sem);
> > >               return rc;
> > >       }
> > >
> > > @@ -1077,6 +1083,7 @@ int cifs_closedir(struct inode *inode, struct f=
ile
> > > *file)
> > >       }
> > >
> > >       up_write(&cinode->lock_sem);
> > > +     up_write(&cinode->io_inflight_sem);
> > >       return rc;
> > >  }
> > >
> > > @@ -1125,14 +1132,17 @@ int cifs_closedir(struct inode *inode, struct
> > > file
> > > *file)
> > >               return rc;
> > >
> > >  try_again:
> > > +     down_write(&cinode->io_inflight_sem);
> > >       down_write(&cinode->lock_sem);
> > >       if (!cinode->can_cache_brlcks) {
> > >               up_write(&cinode->lock_sem);
> > > +             down_write(&cinode->io_inflight_sem);
> > >               return rc;
> > >       }
> > >
> > >       rc =3D posix_lock_file(file, flock, NULL);
> > >       up_write(&cinode->lock_sem);
> > > +     up_write(&cinode->io_inflight_sem);
> > >       if (rc =3D=3D FILE_LOCK_DEFERRED) {
> > >               rc =3D wait_event_interruptible(flock->fl_wait,
> > >               !flock->fl_blocker);
> > >               if (!rc)
> > > @@ -1331,6 +1341,7 @@ struct lock_to_push {
> > >       int rc =3D 0;
> > >
> > >       /* we are going to update can_cache_brlcks here - need a write
> > >       access */
> > > +     down_write(&cinode->io_inflight_sem);
> > >       down_write(&cinode->lock_sem);
> > >       if (!cinode->can_cache_brlcks) {
> > >               up_write(&cinode->lock_sem);
> > > @@ -1346,6 +1357,7 @@ struct lock_to_push {
> > >
> > >       cinode->can_cache_brlcks =3D false;
> > >       up_write(&cinode->lock_sem);
> > > +     up_write(&cinode->io_inflight_sem);
> > >       return rc;
> > >  }
> > >
> > > @@ -1522,6 +1534,7 @@ struct lock_to_push {
> > >       if (!buf)
> > >               return -ENOMEM;
> > >
> > > +     down_write(&cinode->io_inflight_sem);
> > >       down_write(&cinode->lock_sem);
> > >       for (i =3D 0; i < 2; i++) {
> > >               cur =3D buf;
> > > @@ -1593,6 +1606,7 @@ struct lock_to_push {
> > >       }
> > >
> > >       up_write(&cinode->lock_sem);
> > > +     up_write(&cinode->io_inflight_sem);
> > >       kfree(buf);
> > >       return rc;
> > >  }
> > > @@ -3148,7 +3162,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, st=
ruct
> > > iov_iter *from)
> > >        * We need to hold the sem to be sure nobody modifies lock list
> > >        * with a brlock that prevents writing.
> > >        */
> > > -     down_read(&cinode->lock_sem);
> > > +     down_read(&cinode->io_inflight_sem);
> > >
> > >       rc =3D generic_write_checks(iocb, from);
> > >       if (rc <=3D 0)
> > > @@ -3161,7 +3175,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, st=
ruct
> > > iov_iter *from)
> > >       else
> > >               rc =3D -EACCES;
> > >  out:
> > > -     up_read(&cinode->lock_sem);
> > > +     up_read(&cinode->io_inflight_sem);
> > >       inode_unlock(inode);
> > >
> > >       if (rc > 0)
> > > @@ -3887,12 +3901,12 @@ ssize_t cifs_user_readv(struct kiocb *iocb,
> > > struct
> > > iov_iter *to)
> > >        * We need to hold the sem to be sure nobody modifies lock list
> > >        * with a brlock that prevents reading.
> > >        */
> > > -     down_read(&cinode->lock_sem);
> > > +     down_read(&cinode->io_inflight_sem);
> > >       if (!cifs_find_lock_conflict(cfile, iocb->ki_pos,
> > >       iov_iter_count(to),
> > >                                    tcon->ses->server->vals->shared_lo=
ck_type,
> > >                                    0, NULL, CIFS_READ_OP))
> > >               rc =3D generic_file_read_iter(iocb, to);
> > > -     up_read(&cinode->lock_sem);
> > > +     up_read(&cinode->io_inflight_sem);
> > >       return rc;
> > >  }
> > >
> > > --
> > > 1.8.3.1
> > >
> > >
>=20

