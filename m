Return-Path: <SRS0=Yjbq=YQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667B3CA9EB6
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 08:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DF6D205C9
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 08:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Snx1zvVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbfJWIxk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Oct 2019 04:53:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38178 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390366AbfJWIxk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Oct 2019 04:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571820818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5aWa6HLexegzteGzP7qwHy0DGjqglfeMO1sV0YslHs=;
        b=Snx1zvVSTF5uDps3PsnzrBWlr9t925GyC5n0/zENT7pDjg4WQKFnGIs8hvU1fhtfPRURrF
        bmWhAFQZw+kBwJCiMUQPftvzxa1/6Dpif9XTlibgGgqTtcmyvzgvwwKlDGPS2eQ1K5GvNe
        vCn1UiPF694AwCFx36CevtcmURen19Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-OWev2_Z_PXWhbWOAWX0qbQ-1; Wed, 23 Oct 2019 04:53:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B9DE1005509
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 08:53:30 +0000 (UTC)
Received: from dwysocha.rdu.csb (ovpn-120-59.rdu2.redhat.com [10.10.120.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31413101F96B
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 08:53:30 +0000 (UTC)
From:   Dave Wysochanski <dwysocha@redhat.com>
To:     linux-cifs@vger.kernel.org
Subject: [RFC PATCH v2] cifs: Fix cifsInodeInfo lock_sem deadlock with multiple readers
Date:   Wed, 23 Oct 2019 04:53:27 -0400
Message-Id: <1571820807-2449-1-git-send-email-dwysocha@redhat.com>
In-Reply-To: <1786263555.8106229.1571806248056.JavaMail.zimbra@redhat.com>
References: <1786263555.8106229.1571806248056.JavaMail.zimbra@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: OWev2_Z_PXWhbWOAWX0qbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch applies on 5.4-rc4 plus Pavel's patch:
"CIFS: Fix retry mid list corruption on reconnects"

v2 Changes
* In the original version I had erroneously moved lock_sem
inside cifs_find_lock_conflict but the lock_sem should be
taken in the caller of that function not inside it.
* I have started to run some basic locking tests with=20
disruptions of the server and they run ok so far.


There's a deadlock that is possible that can easily be seen with
multiple readers open/read/close of the same file.  The deadlock
is due to a reader calling down_read(lock_sem) and holding
it across the full IO, even if a network or server disruption
occurs and the session has to be reconnected.  Upon reconnect,
cifs_relock_file is called where down_read(lock_sem) is called
a second time.  Normally this is not a problem, but if there is
another process that calls down_write(lock_sem) in between the
first and second reader call to down_read(lock_sem), this will
cause a deadlock.  The caller of down_write (often either
_cifsFileInfo_put that is just removing and freeing cifsLockInfo
structures from the list of locks, or cifs_new_fileinfo, which
is just attaching cifs_fid_locks to cifsInodeInfo->llist), will
block due to the reader's first down_read(lock_sem) that obtains
the semaphore (read IO in flight).  And then when the server
comes back up, the reader that holds calls down_read(lock_sem)
a second time, and this time is blocked too because of the
blocked in down_write (rw_semaphores would starve writers if
this was not the case).  Interestingly enough, the callers of
down_write in the simple test case was not adding a
conflicting lock at all, just either opening or closing the
file, and modifying the list of locks attached to cifsInodeInfo,
this ends up tripping up the reader process and causing the
deadlock.

The root of the problem is that lock_sem both protects the
cifsInodeInfo fields (such as the lllist - the list of locks),
but is also being re-used to prevent a conflicting lock added
while IO is in flight.  Add a new semaphore that tracks
just the IO in flight, and must be obtained before adding
a new lock.  While this does add another layer of complexity
and a semaphore ordering that must be obeyed to avoid new
deadlocks, it does clealy solve the underlying problem of
the deadlock and double call to down_read by the same thread.

Due to the removal of the possibility of a thread calling
down_read(lock_sem) twice, this patch also reverts
560d388950ce ("CIFS: silence lockdep splat in cifs_relock_file()")

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
---
 fs/cifs/cifsfs.c   |  1 +
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/file.c     | 32 +++++++++++++++++++++++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c049c7b3aa87..10f614324e4e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1336,6 +1336,7 @@ static ssize_t cifs_copy_file_range(struct file *src_=
file, loff_t off,
=20
 =09inode_init_once(&cifsi->vfs_inode);
 =09init_rwsem(&cifsi->lock_sem);
+=09init_rwsem(&cifsi->io_inflight_sem);
 }
=20
 static int __init
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 50dfd9049370..40e8358dc1cc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1392,6 +1392,7 @@ struct cifsInodeInfo {
 =09bool can_cache_brlcks;
 =09struct list_head llist;=09/* locks helb by this inode */
 =09struct rw_semaphore lock_sem;=09/* protect the fields above */
+=09struct rw_semaphore io_inflight_sem; /* Used to avoid lock conflicts  *=
/
 =09/* BB add in lists for dirty pages i.e. write caching info for oplock *=
/
 =09struct list_head openFileList;
 =09spinlock_t=09open_file_lock;=09/* protects openFileList */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5ad15de2bb4f..a8b494205781 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -621,7 +621,7 @@ int cifs_open(struct inode *inode, struct file *file)
 =09struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
 =09int rc =3D 0;
=20
-=09down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
+=09down_read(&cinode->lock_sem);
 =09if (cinode->can_cache_brlcks) {
 =09=09/* can cache locks - no need to relock */
 =09=09up_read(&cinode->lock_sem);
@@ -1027,9 +1027,11 @@ int cifs_closedir(struct inode *inode, struct file *=
file)
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 =09struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
+=09down_write(&cinode->io_inflight_sem);
 =09down_write(&cinode->lock_sem);
 =09list_add_tail(&lock->llist, &cfile->llist->locks);
 =09up_write(&cinode->lock_sem);
+=09up_write(&cinode->io_inflight_sem);
 }
=20
 /*
@@ -1049,6 +1051,7 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
=20
 try_again:
 =09exist =3D false;
+=09down_write(&cinode->io_inflight_sem);
 =09down_write(&cinode->lock_sem);
=20
 =09exist =3D cifs_find_lock_conflict(cfile, lock->offset, lock->length,
@@ -1057,6 +1060,7 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
 =09if (!exist && cinode->can_cache_brlcks) {
 =09=09list_add_tail(&lock->llist, &cfile->llist->locks);
 =09=09up_write(&cinode->lock_sem);
+=09=09up_write(&cinode->io_inflight_sem);
 =09=09return rc;
 =09}
=20
@@ -1077,6 +1081,7 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
 =09}
=20
 =09up_write(&cinode->lock_sem);
+=09up_write(&cinode->io_inflight_sem);
 =09return rc;
 }
=20
@@ -1125,14 +1130,17 @@ int cifs_closedir(struct inode *inode, struct file =
*file)
 =09=09return rc;
=20
 try_again:
+=09down_write(&cinode->io_inflight_sem);
 =09down_write(&cinode->lock_sem);
 =09if (!cinode->can_cache_brlcks) {
 =09=09up_write(&cinode->lock_sem);
+=09=09down_write(&cinode->io_inflight_sem);
 =09=09return rc;
 =09}
=20
 =09rc =3D posix_lock_file(file, flock, NULL);
 =09up_write(&cinode->lock_sem);
+=09up_write(&cinode->io_inflight_sem);
 =09if (rc =3D=3D FILE_LOCK_DEFERRED) {
 =09=09rc =3D wait_event_interruptible(flock->fl_wait, !flock->fl_blocker);
 =09=09if (!rc)
@@ -1331,6 +1339,7 @@ struct lock_to_push {
 =09int rc =3D 0;
=20
 =09/* we are going to update can_cache_brlcks here - need a write access *=
/
+=09down_write(&cinode->io_inflight_sem);
 =09down_write(&cinode->lock_sem);
 =09if (!cinode->can_cache_brlcks) {
 =09=09up_write(&cinode->lock_sem);
@@ -1346,6 +1355,7 @@ struct lock_to_push {
=20
 =09cinode->can_cache_brlcks =3D false;
 =09up_write(&cinode->lock_sem);
+=09up_write(&cinode->io_inflight_sem);
 =09return rc;
 }
=20
@@ -1522,6 +1532,7 @@ struct lock_to_push {
 =09if (!buf)
 =09=09return -ENOMEM;
=20
+=09down_write(&cinode->io_inflight_sem);
 =09down_write(&cinode->lock_sem);
 =09for (i =3D 0; i < 2; i++) {
 =09=09cur =3D buf;
@@ -1593,6 +1604,7 @@ struct lock_to_push {
 =09}
=20
 =09up_write(&cinode->lock_sem);
+=09up_write(&cinode->io_inflight_sem);
 =09kfree(buf);
 =09return rc;
 }
@@ -3148,20 +3160,23 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct=
 iov_iter *from)
 =09 * We need to hold the sem to be sure nobody modifies lock list
 =09 * with a brlock that prevents writing.
 =09 */
-=09down_read(&cinode->lock_sem);
+=09down_read(&cinode->io_inflight_sem);
=20
 =09rc =3D generic_write_checks(iocb, from);
 =09if (rc <=3D 0)
 =09=09goto out;
=20
-=09if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),
+=09down_read(&cinode->lock_sem);
+=09if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(from),=
=20
 =09=09=09=09     server->vals->exclusive_lock_type, 0,
-=09=09=09=09     NULL, CIFS_WRITE_OP))
+=09=09=09=09     NULL, CIFS_WRITE_OP)) {
+=09=09up_read(&cinode->lock_sem);
 =09=09rc =3D __generic_file_write_iter(iocb, from);
+=09}
 =09else
 =09=09rc =3D -EACCES;
 out:
-=09up_read(&cinode->lock_sem);
+=09up_read(&cinode->io_inflight_sem);
 =09inode_unlock(inode);
=20
 =09if (rc > 0)
@@ -3887,12 +3902,15 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct =
iov_iter *to)
 =09 * We need to hold the sem to be sure nobody modifies lock list
 =09 * with a brlock that prevents reading.
 =09 */
+=09down_read(&cinode->io_inflight_sem);
 =09down_read(&cinode->lock_sem);
 =09if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(to),
 =09=09=09=09     tcon->ses->server->vals->shared_lock_type,
-=09=09=09=09     0, NULL, CIFS_READ_OP))
+=09=09=09=09     0, NULL, CIFS_READ_OP)) {
+=09=09up_read(&cinode->lock_sem);
 =09=09rc =3D generic_file_read_iter(iocb, to);
-=09up_read(&cinode->lock_sem);
+=09}
+=09up_read(&cinode->io_inflight_sem);
 =09return rc;
 }
=20
--=20
1.8.3.1

