Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E07C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 20:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE38861A18
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 20:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCZUbv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 16:31:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230223AbhCZUbm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Mar 2021 16:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616790701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=k2/C98eO98u7A2KMpJm+Awb9/1oI/8Pfx6S88pHCHNo=;
        b=DLYLoMpbcqPqkXcVvwOt7Zwr3iphrrkYiPO6d3iwFq9UJTDhKxni30uJwEOSHYnLeFNap6
        JhtNelZjwEbPCOcvRDO7PgwQnYEfaoUxNyx8gSlhIC7PMhSH+uNI37pjsxY3M8V0sc6egN
        JZZMA82kMFxSDbbs68NDAoRQxxyN7Vs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-zkzDsLCUNc67BoBeVthxnA-1; Fri, 26 Mar 2021 16:31:39 -0400
X-MC-Unique: zkzDsLCUNc67BoBeVthxnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4545651;
        Fri, 26 Mar 2021 20:31:38 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 011E260CE9;
        Fri, 26 Mar 2021 20:31:37 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add FALLOC_FL_INSERT_RANGE support
Date:   Sat, 27 Mar 2021 06:31:30 +1000
Message-Id: <20210326203130.116299-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3bb18944aaa4..e51aee5ce664 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3678,6 +3678,48 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
+			      loff_t off, loff_t len)
+{
+	int rc;
+	unsigned int xid;
+	struct cifsFileInfo *cfile = file->private_data;
+	__le64 eof, count;
+
+	xid = get_xid();
+
+	if (off + len < off) {
+		rc = -EFBIG;
+		goto out;
+	}
+
+	if (off >= i_size_read(file->f_inode)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	count = i_size_read(file->f_inode) - off;
+	eof = i_size_read(file->f_inode) + len;
+
+	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+			  cfile->fid.volatile_fid, cfile->pid, &eof);
+	if (rc < 0)
+		goto out;
+
+	rc = smb2_copychunk_range(xid, cfile, cfile, off, count, off + len);
+	if (rc < 0)
+		goto out;
+
+	rc = smb3_zero_range(file, tcon, off, len, 1);
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
@@ -3851,6 +3893,8 @@ static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
 		return smb3_simple_falloc(file, tcon, off, len, true);
 	else if (mode == FALLOC_FL_COLLAPSE_RANGE)
 		return smb3_collapse_range(file, tcon, off, len);
+	else if (mode == FALLOC_FL_INSERT_RANGE)
+		return smb3_insert_range(file, tcon, off, len);
 	else if (mode == 0)
 		return smb3_simple_falloc(file, tcon, off, len, false);
 
-- 
2.29.2

