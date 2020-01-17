Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE4FC33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 01:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C6920728
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 01:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g3TA+ypH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAQBPy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 20:15:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727008AbgAQBPy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Jan 2020 20:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579223752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=iKH1+avQYPgYqMDf1jVQu4//axCgYLEVgnlI/3j8jXw=;
        b=g3TA+ypHk8fCj8A+xKx6Diho/5YptueoCSGmrPbpXCZbnuXxELMpbiYn6+hmsDDL9U7EiL
        MS+uoCukfjGqPCBmNshkhHs7SYLIw121CMOU8iirCgCjgyzLBPwu9Zc+sNPJqNiy5AZjc4
        3zppgavnHN0uAelPUBrnOfNLl7uUViQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-NeLC2rv3NOGcWGqzL1cEeg-1; Thu, 16 Jan 2020 20:15:51 -0500
X-MC-Unique: NeLC2rv3NOGcWGqzL1cEeg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53A1A107ACC5
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jan 2020 01:15:50 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACC2F84334;
        Fri, 17 Jan 2020 01:15:49 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
Date:   Fri, 17 Jan 2020 11:15:41 +1000
Message-Id: <20200117011541.17004-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ 1336264

When we extend a file we must also force the size to be updated.

This fixes an issue with holetest in xfs-tests which performs the following
sequence :
1, create a new file
2, use fallocate mode==0 to populate the file
3, mmap the file
4, touch each page by reading the mmapped region.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.h  |  3 +++
 fs/cifs/inode.c   |  4 ++--
 fs/cifs/smb2ops.c | 64 +++++++++++++++++++++++++------------------------------
 3 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index b59dc7478130..096a4c18fbd0 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -149,6 +149,9 @@ extern ssize_t cifs_file_copychunk_range(unsigned int xid,
 					size_t len, unsigned int flags);
 
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
+extern void cifs_setsize(struct inode *inode, loff_t offset);
+extern int cifs_truncate_page(struct address_space *mapping, loff_t from);
+
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ca76a9287456..9b547f7f5f5d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2228,7 +2228,7 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 	return -ENOTSUPP;
 }
 
-static int cifs_truncate_page(struct address_space *mapping, loff_t from)
+int cifs_truncate_page(struct address_space *mapping, loff_t from)
 {
 	pgoff_t index = from >> PAGE_SHIFT;
 	unsigned offset = from & (PAGE_SIZE - 1);
@@ -2245,7 +2245,7 @@ static int cifs_truncate_page(struct address_space *mapping, loff_t from)
 	return rc;
 }
 
-static void cifs_setsize(struct inode *inode, loff_t offset)
+void cifs_setsize(struct inode *inode, loff_t offset)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6250370c1170..938c985b9919 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -12,6 +12,7 @@
 #include <linux/uuid.h>
 #include <linux/sort.h>
 #include <crypto/aead.h>
+#include "cifsfs.h"
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
@@ -3095,28 +3096,32 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		}
 
 	/*
+	 * Extending the file
+	 */
+	if ((keep_size == false) && i_size_read(inode) < off + len) {
+		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
+			smb2_set_sparse(xid, tcon, cfile, inode, false);
+
+		eof = cpu_to_le64(off + len);
+		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+				  cfile->fid.volatile_fid, cfile->pid, &eof);
+		if (rc == 0) {
+			cifsi->server_eof = off + len;
+			cifs_setsize(inode, off + len);
+			cifs_truncate_page(inode->i_mapping, inode->i_size);
+			truncate_setsize(inode, off + len);
+		}
+		goto out;
+	}
+
+	/*
 	 * Files are non-sparse by default so falloc may be a no-op
-	 * Must check if file sparse. If not sparse, and not extending
-	 * then no need to do anything since file already allocated
+	 * Must check if file sparse. If not sparse, and since we are not
+	 * extending then no need to do anything since file already allocated
 	 */
 	if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0) {
-		if (keep_size == true)
-			rc = 0;
-		/* check if extending file */
-		else if (i_size_read(inode) >= off + len)
-			/* not extending file and already not sparse */
-			rc = 0;
-		/* BB: in future add else clause to extend file */
-		else
-			rc = -EOPNOTSUPP;
-		if (rc)
-			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
-				tcon->tid, tcon->ses->Suid, off, len, rc);
-		else
-			trace_smb3_falloc_done(xid, cfile->fid.persistent_fid,
-				tcon->tid, tcon->ses->Suid, off, len);
-		free_xid(xid);
-		return rc;
+		rc = 0;
+		goto out;
 	}
 
 	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
@@ -3130,25 +3135,14 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		 */
 		if ((off > 8192) || (off + len + 8192 < i_size_read(inode))) {
 			rc = -EOPNOTSUPP;
-			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
-				tcon->tid, tcon->ses->Suid, off, len, rc);
-			free_xid(xid);
-			return rc;
-		}
-
-		smb2_set_sparse(xid, tcon, cfile, inode, false);
-		rc = 0;
-	} else {
-		smb2_set_sparse(xid, tcon, cfile, inode, false);
-		rc = 0;
-		if (i_size_read(inode) < off + len) {
-			eof = cpu_to_le64(off + len);
-			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-					  cfile->fid.volatile_fid, cfile->pid,
-					  &eof);
+			goto out;
 		}
 	}
 
+	smb2_set_sparse(xid, tcon, cfile, inode, false);
+	rc = 0;
+
+out:
 	if (rc)
 		trace_smb3_falloc_err(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len, rc);
-- 
2.13.6

