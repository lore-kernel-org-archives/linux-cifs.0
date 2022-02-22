Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBE1C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Feb 2022 05:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiBVFgA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Feb 2022 00:36:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiBVFf7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Feb 2022 00:35:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34A97B4583
        for <linux-cifs@vger.kernel.org>; Mon, 21 Feb 2022 21:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645508134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4DHm7qMC9lLy2Ml7EZiF2Nx+iqu4Txf/Rskz0nVNE2M=;
        b=dU/EYsDTyhVgN69WYFEFPHnnFnRFFi1x1G4EhojIb/wNKInSO46OItzcw/TgJiI+NIkfXh
        1UOW5ZwID6foGdqAOd1nDDi9TKCyCU1Bt4mqkBWBzUo2GZqpd6ArxK0YByRGhyobTWwQWH
        cVeshpFaiXL0x4RjOOxfi3C57DIA9Uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-W6hIm1WiMkmOXQsmfroj-Q-1; Tue, 22 Feb 2022 00:35:29 -0500
X-MC-Unique: W6hIm1WiMkmOXQsmfroj-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC085801AAD;
        Tue, 22 Feb 2022 05:35:28 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-34.bne.redhat.com [10.64.54.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D54E78C0D;
        Tue, 22 Feb 2022 05:35:27 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: truncate the inode and mapping when we simulate fcollapse
Date:   Tue, 22 Feb 2022 15:35:21 +1000
Message-Id: <20220222053521.289668-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index af5d0830bc8a..5cd3247e71b9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -25,6 +25,7 @@
 #include "smb2glob.h"
 #include "cifs_ioctl.h"
 #include "smbdirect.h"
+#include "fscache.h"
 #include "fs_context.h"
 
 /* Change credits for different ops and return the total number of credits */
@@ -3887,29 +3888,39 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
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
+	eof = i_size_read(inode) - len;
+	cifsi->server_eof = eof;
+	truncate_setsize(inode, eof);
+	fscache_resize_cookie(cifs_inode_cookie(inode), eof);
  out:
 	free_xid(xid);
 	return rc;
-- 
2.30.2

