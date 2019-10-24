Return-Path: <SRS0=ZfIs=YR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D33ACA9EB9
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Oct 2019 02:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F27CD2084B
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Oct 2019 02:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cr6O+nE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408168AbfJXCI3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Oct 2019 22:08:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33055 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2408092AbfJXCI3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Oct 2019 22:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571882907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6ztLRceEh+GlM9KbaXqjTtQMabPALX4VRhLhXgPR4zk=;
        b=cr6O+nE0Ve5FdcSfFugDy+IZT2BUaA3K7pZqwybI30SMW0NBxmwPtf4tIzWX1UUWGCADXS
        bxaoy5DXyrSqvoA1y6WUs6NLKvxygRYKQupGKHA3wwUAIg5LadHifEZMv2S5lmNOx8K/Fa
        r0MBnNGuZNbsQPHVVfkXHj2R13fZ9dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-790jP3jKOvu4YI6zlKCJmw-1; Wed, 23 Oct 2019 22:08:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A43A747B
        for <linux-cifs@vger.kernel.org>; Thu, 24 Oct 2019 02:08:24 +0000 (UTC)
Received: from dwysocha.rdu.csb (ovpn-120-59.rdu2.redhat.com [10.10.120.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 554595C1D4
        for <linux-cifs@vger.kernel.org>; Thu, 24 Oct 2019 02:08:24 +0000 (UTC)
From:   Dave Wysochanski <dwysocha@redhat.com>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
Date:   Wed, 23 Oct 2019 22:08:22 -0400
Message-Id: <1571882902-23966-1-git-send-email-dwysocha@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 790jP3jKOvu4YI6zlKCJmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
 fs/cifs/cifsglob.h |  5 +++++
 fs/cifs/file.c     | 24 ++++++++++++++++--------
 fs/cifs/smb2file.c |  3 ++-
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 50dfd9049370..2c4a7adbcb4e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1391,6 +1391,11 @@ struct cifs_writedata {
 struct cifsInodeInfo {
 =09bool can_cache_brlcks;
 =09struct list_head llist;=09/* locks helb by this inode */
+=09/*
+=09 * NOTE: Some code paths call down_read(lock_sem) twice, so
+=09 * we must always use use down_write_trylock()/msleep() loop
+=09 * to avoid deadlock.
+=09 */
 =09struct rw_semaphore lock_sem;=09/* protect the fields above */
 =09/* BB add in lists for dirty pages i.e. write caching info for oplock *=
/
 =09struct list_head openFileList;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5ad15de2bb4f..52454df5ae39 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -306,7 +306,8 @@ struct cifsFileInfo *
 =09INIT_LIST_HEAD(&fdlocks->locks);
 =09fdlocks->cfile =3D cfile;
 =09cfile->llist =3D fdlocks;
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
 =09list_add(&fdlocks->llist, &cinode->llist);
 =09up_write(&cinode->lock_sem);
=20
@@ -464,7 +465,8 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, =
bool wait_oplock_handler)
 =09 * Delete any outstanding lock records. We'll lose them when the file
 =09 * is closed anyway.
 =09 */
-=09down_write(&cifsi->lock_sem);
+=09while (!down_write_trylock(&cifsi->lock_sem))
+=09=09msleep(125);
 =09list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
 =09=09list_del(&li->llist);
 =09=09cifs_del_lock_waiters(li);
@@ -1027,7 +1029,8 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
 cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
 {
 =09struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(cfile->dentry));
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
 =09list_add_tail(&lock->llist, &cfile->llist->locks);
 =09up_write(&cinode->lock_sem);
 }
@@ -1049,7 +1052,8 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
=20
 try_again:
 =09exist =3D false;
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
=20
 =09exist =3D cifs_find_lock_conflict(cfile, lock->offset, lock->length,
 =09=09=09=09=09lock->type, lock->flags, &conf_lock,
@@ -1072,7 +1076,8 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
 =09=09=09=09=09(lock->blist.next =3D=3D &lock->blist));
 =09=09if (!rc)
 =09=09=09goto try_again;
-=09=09down_write(&cinode->lock_sem);
+=09=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09=09msleep(125);
 =09=09list_del_init(&lock->blist);
 =09}
=20
@@ -1125,7 +1130,8 @@ int cifs_closedir(struct inode *inode, struct file *f=
ile)
 =09=09return rc;
=20
 try_again:
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
 =09if (!cinode->can_cache_brlcks) {
 =09=09up_write(&cinode->lock_sem);
 =09=09return rc;
@@ -1331,7 +1337,8 @@ struct lock_to_push {
 =09int rc =3D 0;
=20
 =09/* we are going to update can_cache_brlcks here - need a write access *=
/
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
 =09if (!cinode->can_cache_brlcks) {
 =09=09up_write(&cinode->lock_sem);
 =09=09return rc;
@@ -1522,7 +1529,8 @@ struct lock_to_push {
 =09if (!buf)
 =09=09return -ENOMEM;
=20
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
 =09for (i =3D 0; i < 2; i++) {
 =09=09cur =3D buf;
 =09=09num =3D 0;
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index e6a1fc72018f..61f6cc8d9cc9 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -145,7 +145,8 @@
=20
 =09cur =3D buf;
=20
-=09down_write(&cinode->lock_sem);
+=09while (!down_write_trylock(&cinode->lock_sem))
+=09=09msleep(125);
 =09list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
 =09=09if (flock->fl_start > li->offset ||
 =09=09    (flock->fl_start + length) <
--=20
1.8.3.1

