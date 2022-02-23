Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B526C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Feb 2022 01:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiBWBOy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Feb 2022 20:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiBWBOx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Feb 2022 20:14:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9FC1396B5
        for <linux-cifs@vger.kernel.org>; Tue, 22 Feb 2022 17:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645578865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tKWFnXD4lRNjvlW/uR3GsRTJ6fRgVp1YJiBvmEsFaW0=;
        b=O2tmx2S3rhQX7X0uC5ej3eMlptcnWk+Qy88uCAOekt8Maw783ncb1LLBdBpt4NGBRTaQ1h
        UOwWn276zhTC1t+SFdXsCC0mWvqdr1f5OA2/RxASsH5lXRjpBybWlm0YvXwfqPc3bkx2Lr
        JNvVFrgXzHOEuiZ62SIlHEQUlYIQpqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-jnbsQXI5Oki3Q30EsDE_9A-1; Tue, 22 Feb 2022 20:14:24 -0500
X-MC-Unique: jnbsQXI5Oki3Q30EsDE_9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86E2D1800D50;
        Wed, 23 Feb 2022 01:14:23 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-34.bne.redhat.com [10.64.54.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E23F25DB80;
        Wed, 23 Feb 2022 01:14:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: truncate the inode and mapping when we simulate fcollapse
Date:   Wed, 23 Feb 2022 11:14:16 +1000
Message-Id: <20220223011416.323085-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ:1997367

When we collapse a range in smb3_collapse_range() we must make sure
we update the inode size and pagecache accordingly.

If not, both inode size and pagecahce may be stale until it is refreshed.

This can be demonstrated for the inode size by running :

xfs_io -i -f -c "truncate 320k" -c "fcollapse 64k 128k" -c "fiemap -v"  \
/mnt/testfile

where we can see the result of stale data in the fiemap output.
The third line of the output is wrong, all this data should be truncated.

 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        hole               128
   1: [128..383]:      128..383           256   0x1
   2: [384..639]:      hole               256

And the correct output, when the inode size has been updated correctly should
look like this:

 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        hole               128
   1: [128..383]:      128..383           256   0x1

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index af5d0830bc8a..891b11576e55 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -25,6 +25,7 @@
 #include "smb2glob.h"
 #include "cifs_ioctl.h"
 #include "smbdirect.h"
+#include "fscache.h"
 #include "fs_context.h"
 
 /* Change credits for different ops and return the total number of credits */
@@ -3887,29 +3888,38 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 {
 	int rc;
 	unsigned int xid;
+	struct inode *inode;
 	struct cifsFileInfo *cfile = file->private_data;
+	struct cifsInodeInfo *cifsi;
 	__le64 eof;
 
 	xid = get_xid();
 
-	if (off >= i_size_read(file->f_inode) ||
-	    off + len >= i_size_read(file->f_inode)) {
+	inode = d_inode(cfile->dentry);
+	cifsi = CIFS_I(inode);
+
+	if (off >= i_size_read(inode) ||
+	    off + len >= i_size_read(inode)) {
 		rc = -EINVAL;
 		goto out;
 	}
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
-				  i_size_read(file->f_inode) - off - len, off);
+				  i_size_read(inode) - off - len, off);
 	if (rc < 0)
 		goto out;
 
-	eof = cpu_to_le64(i_size_read(file->f_inode) - len);
+	eof = cpu_to_le64(i_size_read(inode) - len);
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, &eof);
 	if (rc < 0)
 		goto out;
 
 	rc = 0;
+
+	cifsi->server_eof = i_size_read(inode) - len;
+	truncate_setsize(inode, cifsi->server_eof);
+	fscache_resize_cookie(cifs_inode_cookie(inode), cifsi->server_eof);
  out:
 	free_xid(xid);
 	return rc;
-- 
2.30.2

