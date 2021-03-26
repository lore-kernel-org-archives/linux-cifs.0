Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DA1C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 19:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7606196C
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 19:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCZTwp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 15:52:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230298AbhCZTwm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Mar 2021 15:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616788361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pRMd6weXBtSfjzrJVOVqZD2RntUBFIaT97mCoFYt+1M=;
        b=NUEXYQYX7hz4gtDSdQIXMX8GpUbelIHn8jWGHvIkfSM9o8/LwzTTipDlLaCJGD9xvsvNFo
        3IbKS41PJSff9qDsIXFkOpIq1yJgJbOlI/OkccyZgRG+8iZ4B3bEQnmJulsnmRAeWPlCs3
        brtlapnblb6KuXmWd8PbGwUokoZFz88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-CSzxyfxMPq6ykcZl706CZQ-1; Fri, 26 Mar 2021 15:52:38 -0400
X-MC-Unique: CSzxyfxMPq6ykcZl706CZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D42671005D7B;
        Fri, 26 Mar 2021 19:52:37 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 065D91B5C3;
        Fri, 26 Mar 2021 19:52:36 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add support for FALLOC_FL_COLLAPSE_RANGE
Date:   Sat, 27 Mar 2021 05:52:29 +1000
Message-Id: <20210326195229.114110-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9bae7e8deb09..3bb18944aaa4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3640,6 +3640,44 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
+			    loff_t off, loff_t len)
+{
+	int rc;
+	unsigned int xid;
+	struct cifsFileInfo *cfile = file->private_data;
+	__le64 eof;
+
+	xid = get_xid();
+
+	if (off + len < off) {
+		rc = -EFBIG;
+		goto out;
+	}
+
+	if (off >= i_size_read(file->f_inode) ||
+	    off + len >= i_size_read(file->f_inode)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
+				  i_size_read(file->f_inode) - off - len, off);
+	if (rc < 0)
+		goto out;
+
+	eof = i_size_read(file->f_inode) - len;
+	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+			  cfile->fid.volatile_fid, cfile->pid, &eof);
+	if (rc < 0)
+		goto out;
+
+	rc = 0;
+ out:
+	free_xid(xid);
+	return rc;
+}
+
 static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offset, int whence)
 {
 	struct cifsFileInfo *wrcfile, *cfile = file->private_data;
@@ -3811,6 +3849,8 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 		return smb3_zero_range(file, tcon, off, len, false);
 	} else if (mode == FALLOC_FL_KEEP_SIZE)
 		return smb3_simple_falloc(file, tcon, off, len, true);
+	else if (mode == FALLOC_FL_COLLAPSE_RANGE)
+		return smb3_collapse_range(file, tcon, off, len);
 	else if (mode == 0)
 		return smb3_simple_falloc(file, tcon, off, len, false);
 
-- 
2.29.2

