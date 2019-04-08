Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526CBC10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 14:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1999D21473
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554735585;
	bh=tf7x//QWBke56NGxWS1CxE2hSrqxxrGkxANpcc/VJaY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XYyc6CCdtS15IFAPl9n1JeEBvNRlZHMIDief+hXT9gqYda33UKCHHqV/sHRRt+U7p
	 CbyH5XCHr/QPGA5Y4qr7BpKfNvEwDYq88CoZh1aSYVriJ/hlyo+0z2pc7MtScs3bxv
	 g8YADyaqgXVWBXcrHOob3alIFo/WrDoZIJhqdTwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfDHO7o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 10:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbfDHO7o (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Apr 2019 10:59:44 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB32321473;
        Mon,  8 Apr 2019 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554735584;
        bh=tf7x//QWBke56NGxWS1CxE2hSrqxxrGkxANpcc/VJaY=;
        h=From:To:Cc:Subject:Date:From;
        b=kEaOlBKXAnC8lOhR5Tk998OPY5AAGD/n5FGQWK8IO2BrQRZUk3s+G/IuPNgcyS1io
         ZiToxq3R5oxOk1OsHo3bg2mCCT5PbMWGv1On1i4uep/5BiYHKQEC+XLu8IOYqhtd4v
         2T/3eRqbV8v3SElVvkPI/W7/flqZenvKoz1azDFM=
From:   Jeff Layton <jlayton@kernel.org>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org
Subject: [RFC PATCH] cifs: remove superfluous inode_lock in cifs_{strict_}fsync
Date:   Mon,  8 Apr 2019 10:59:42 -0400
Message-Id: <20190408145942.6448-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Originally, filemap_write_and_wait took the i_mutex internally, but
commit 02c24a82187d pushed the mutex acquisition into the individual
fsync routines, leaving it up to the subsystem maintainers to remove
it if it wasn't needed.

For cifs, I see no reason to take the inode_lock here. All of the
operations inside that lock are protected in other ways.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cifs/file.c | 5 -----
 1 file changed, 5 deletions(-)

Steve, would you or someone else be able to test this?

I'm proposing a similar patch for kcephfs. I don't have an appropriate
test rig at the moment, and I was hoping someone more involved with
cifs.ko development these days may be able to do so.

Thanks,
Jeff

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 89006e044973..c4b84fd423c3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2424,7 +2424,6 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	rc = file_write_and_wait_range(file, start, end);
 	if (rc)
 		return rc;
-	inode_lock(inode);
 
 	xid = get_xid();
 
@@ -2449,7 +2448,6 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 	}
 
 	free_xid(xid);
-	inode_unlock(inode);
 	return rc;
 }
 
@@ -2461,12 +2459,10 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
-	struct inode *inode = file->f_mapping->host;
 
 	rc = file_write_and_wait_range(file, start, end);
 	if (rc)
 		return rc;
-	inode_lock(inode);
 
 	xid = get_xid();
 
@@ -2483,7 +2479,6 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	free_xid(xid);
-	inode_unlock(inode);
 	return rc;
 }
 
-- 
2.20.1

