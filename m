Return-Path: <SRS0=ZfIs=YR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BA7CA9EAF
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Oct 2019 23:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DA3021BE5
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Oct 2019 23:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dGAmNjo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732531AbfJXXv5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Oct 2019 19:51:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21990 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727309AbfJXXv5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Oct 2019 19:51:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571961115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ay+H43716LcJWxs3r6XhGXXVAp/IfXwwEUjmXma++M=;
        b=dGAmNjo8sYSGYso5j6Y/ulNk2cOwtqOp4ODWe8y1Mo0xZ+P91pwH7QoDb/P4sDFekHnv4k
        5OL6x07TlVAnCNcMhq6Zi5khyoJhb+bJP4E1dxepS1ow0LW4nkgB3DaPQTPgzTVp9sHld9
        jaIO+l4FdpfwtsS2rO5cyMQy5gGKQhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-4dY972RcP6WureeizopdAA-1; Thu, 24 Oct 2019 19:51:53 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E3F11005500
        for <linux-cifs@vger.kernel.org>; Thu, 24 Oct 2019 23:51:53 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-48.bne.redhat.com [10.64.54.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 677A25DD61;
        Thu, 24 Oct 2019 23:51:52 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Dave Wysochanski <dwysocha@redhat.com>
Subject: [PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
Date:   Fri, 25 Oct 2019 09:51:20 +1000
Message-Id: <20191024235120.8059-2-lsahlber@redhat.com>
In-Reply-To: <20191024235120.8059-1-lsahlber@redhat.com>
References: <20191024235120.8059-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 4dY972RcP6WureeizopdAA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

There's a deadlock that is possible and can easily be seen with
a test where multiple readers open/read/close of the same file
and a disruption occurs causing reconnect.  The deadlock is due
a reader thread inside cifs_strict_readv calling down_read and
obtaining lock_sem, and then after reconnect inside
cifs_reopen_file calling down_read a second time.  If in
between the two down_read calls, a down_write comes from
another process, deadlock occurs.

        CPU0                    CPU1
        ----                    ----
cifs_strict_readv()
 down_read(&cifsi->lock_sem);
                               _cifsFileInfo_put
                                  OR
                               cifs_new_fileinfo
                                down_write(&cifsi->lock_sem);
cifs_reopen_file()
 down_read(&cifsi->lock_sem);

Fix the above by changing all down_write(lock_sem) calls to
down_write_trylock(lock_sem)/msleep() loop, which in turn
makes the second down_read call benign since it will never
block behind the writer while holding lock_sem.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Suggested-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h  |  5 +++++
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/file.c      | 23 +++++++++++++++--------
 fs/cifs/smb2file.c  |  2 +-
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 50dfd9049370..d78bfcc19156 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1391,6 +1391,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file=
);
 struct cifsInodeInfo {
 =09bool can_cache_brlcks;
 =09struct list_head llist;=09/* locks helb by this inode */
+=09/*
+=09 * NOTE: Some code paths call down_read(lock_sem) twice, so
+=09 * we must always use use cifs_down_write() instead of down_write()
+=09 * for this semaphore to avoid deadlocks.
+=09 */
 =09struct rw_semaphore lock_sem;=09/* protect the fields above */
 =09/* BB add in lists for dirty pages i.e. write caching info for oplock *=
/
 =09struct list_head openFileList;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e53e9f62b87b..fe597d3d5208 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -170,6 +170,7 @@ extern int cifs_unlock_range(struct cifsFileInfo *cfile=
,
 =09=09=09     struct file_lock *flock, const unsigned int xid);
 extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
=20
+extern void cifs_down_write(struct rw_semaphore *sem);
 extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
 =09=09=09=09=09      struct file *file,
 =09=09=09=09=09      struct tcon_link *tlink,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0e0217641de1..a80ec683ea32 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -281,6 +281,13 @@ cifs_has_mand_locks(struct cifsInodeInfo *cinode)
 =09return has_locks;
 }
=20
+void
+cifs_down_write(struct rw_semaphore *sem)
+{
+=09while (!down_write_trylock(sem))
+=09=09msleep(10);
+}
+
 struct cifsFileInfo *
 cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 =09=09  struct tcon_link *tlink, __u32 oplock)
@@ -306,7 +313,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *fi=
le,
 =09INIT_LIST_HEAD(&fdlocks->locks);
 =09fdlocks->cfile =3D cfile;
 =09cfile->llist =3D fdlocks;
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
 =09list_add(&fdlocks->llist, &cinode->llist);
 =09up_write(&cinode->lock_sem);
=20
@@ -464,7 +471,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, =
bool wait_oplock_handler)
 =09 * Delete any outstanding lock records. We'll lose them when the file
 =09 * is closed anyway.
 =09 */
-=09down_write(&cifsi->lock_sem);
+=09cifs_down_write(&cifsi->lock_sem);
 =09list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 =09=09list_del(&li->llist);
 =09=09cifs_del_lock_waiters(li);
@@ -1027,7 +1034,7 @@ static void
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 =09struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
 =09list_add_tail(&lock->llist, &cfile->llist->locks);
 =09up_write(&cinode->lock_sem);
 }
@@ -1049,7 +1056,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct c=
ifsLockInfo *lock,
=20
 try_again:
 =09exist =3D false;
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
=20
 =09exist =3D cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 =09=09=09=09=09lock->type, lock->flags, &conf_lock,
@@ -1072,7 +1079,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct c=
ifsLockInfo *lock,
 =09=09=09=09=09(lock->blist.next =3D=3D &lock->blist));
 =09=09if (!rc)
 =09=09=09goto try_again;
-=09=09down_write(&cinode->lock_sem);
+=09=09cifs_down_write(&cinode->lock_sem);
 =09=09list_del_init(&lock->blist);
 =09}
=20
@@ -1125,7 +1132,7 @@ cifs_posix_lock_set(struct file *file, struct file_lo=
ck *flock)
 =09=09return rc;
=20
 try_again:
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
 =09if (!cinode->can_cache_brlcks) {
 =09=09up_write(&cinode->lock_sem);
 =09=09return rc;
@@ -1331,7 +1338,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
 =09int rc =3D 0;
=20
 =09/* we are going to update can_cache_brlcks here - need a write access *=
/
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
 =09if (!cinode->can_cache_brlcks) {
 =09=09up_write(&cinode->lock_sem);
 =09=09return rc;
@@ -1522,7 +1529,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct =
file_lock *flock,
 =09if (!buf)
 =09=09return -ENOMEM;
=20
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
 =09for (i =3D 0; i < 2; i++) {
 =09=09cur =3D buf;
 =09=09num =3D 0;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index e6a1fc72018f..8b0b512c5792 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -145,7 +145,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct fi=
le_lock *flock,
=20
 =09cur =3D buf;
=20
-=09down_write(&cinode->lock_sem);
+=09cifs_down_write(&cinode->lock_sem);
 =09list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 =09=09if (flock->fl_start > li->offset ||
 =09=09    (flock->fl_start + length) <
--=20
2.13.6

