Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABD4C33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 00:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF21A206E6
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 00:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEQChekF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgAQAFC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 19:05:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27565 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgAQAFC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 19:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579219499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ZMSohtMnPRAPAREa8pgIJxf1Qh375Ycttp/nXgBEprI=;
        b=FEQChekFMh9HYgINDPDdWci0eJiPMOOFfkNWKjfGM4QA9z9NyiyBcOgYk7cExlKNoobdWu
        No9ZTMdfzHaUA9/sOiFuDZS/PJ9hZbg0JLKnEDQbUfj+lsWilEYGE9/5sbBqJgj8hJfLxM
        uPsOTGNGBE5k+T65R5uQvaZy6mr2Yc4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-fkIZMCClPpuCMXUFpMwtfQ-1; Thu, 16 Jan 2020 19:04:58 -0500
X-MC-Unique: fkIZMCClPpuCMXUFpMwtfQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F91B8017CC
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jan 2020 00:04:57 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02EFF5D9C9;
        Fri, 17 Jan 2020 00:04:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: add support for fallocate mode 0 for non-sparse files
Date:   Fri, 17 Jan 2020 10:04:48 +1000
Message-Id: <20200117000448.13704-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ 1336264

When we extend a file we must also force the attributes (the size)
to be revalidated.

This fixes an issue with holetest in xfs-tests which performs the following
sequence :
1, create a new file
2, use fallocate mode==0 to populate the file
3, mmap the file
4, touch each page by reading the mmapped region.

If we don't revalidate the file as part of step 2, the handle will still have
cached attributes where the size is 0 and thus the mmap will not map the
requested region leading to SIGBUS for the application in step 4.

We already had the same crash bug for sparse files but we never triggered that
with our xfstests.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c  |  6 ++----
 fs/cifs/cifsfs.h  |  2 +-
 fs/cifs/inode.c   |  6 +++---
 fs/cifs/smb2ops.c | 23 ++++++++++++++++++++---
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5492b9860baa..638337dc04ee 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -957,11 +957,9 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
 		/*
 		 * Some applications poll for the file length in this strange
 		 * way so we must seek to end on non-oplocked files by
-		 * setting the revalidate time to zero.
+		 * forcing revalidation.
 		 */
-		CIFS_I(inode)->time = 0;
-
-		rc = cifs_revalidate_file_attr(file);
+		rc = cifs_revalidate_file_attr(file, true);
 		if (rc < 0)
 			return (loff_t)rc;
 	}
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index b59dc7478130..e72aec945875 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -75,7 +75,7 @@ extern int cifs_mkdir(struct inode *, struct dentry *, umode_t);
 extern int cifs_rmdir(struct inode *, struct dentry *);
 extern int cifs_rename2(struct inode *, struct dentry *, struct inode *,
 			struct dentry *, unsigned int);
-extern int cifs_revalidate_file_attr(struct file *filp);
+extern int cifs_revalidate_file_attr(struct file *filp, bool force);
 extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ca76a9287456..1db84db822ec 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2050,13 +2050,13 @@ cifs_zap_mapping(struct inode *inode)
 	return cifs_revalidate_mapping(inode);
 }
 
-int cifs_revalidate_file_attr(struct file *filp)
+int cifs_revalidate_file_attr(struct file *filp, bool force)
 {
 	int rc = 0;
 	struct inode *inode = file_inode(filp);
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
 
-	if (!cifs_inode_needs_reval(inode))
+	if (!force && !cifs_inode_needs_reval(inode))
 		return rc;
 
 	if (tlink_tcon(cfile->tlink)->unix_ext)
@@ -2112,7 +2112,7 @@ int cifs_revalidate_file(struct file *filp)
 	int rc;
 	struct inode *inode = file_inode(filp);
 
-	rc = cifs_revalidate_file_attr(filp);
+	rc = cifs_revalidate_file_attr(filp, false);
 	if (rc)
 		return rc;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6250370c1170..6c0fe6544fd7 100644
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
@@ -3106,9 +3107,19 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		else if (i_size_read(inode) >= off + len)
 			/* not extending file and already not sparse */
 			rc = 0;
-		/* BB: in future add else clause to extend file */
-		else
-			rc = -EOPNOTSUPP;
+		/* extend file */
+		else {
+			eof = cpu_to_le64(off + len);
+			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+					  cfile->fid.volatile_fid, cfile->pid,
+					  &eof);
+			if (!rc) {
+				rc = cifs_revalidate_file_attr(file, true);
+				if (rc)
+					cifs_dbg(FYI, "Validation during fallocate "
+						 "failed, error=%ld\n", rc);
+			}
+		}
 		if (rc)
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
@@ -3146,6 +3157,12 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 					  cfile->fid.volatile_fid, cfile->pid,
 					  &eof);
+			if (!rc) {
+				rc = cifs_revalidate_file_attr(file, true);
+				if (rc)
+					cifs_dbg(FYI, "Validation during fallocate "
+						 "failed, error=%ld\n", rc);
+			}
 		}
 	}
 
-- 
2.13.6

