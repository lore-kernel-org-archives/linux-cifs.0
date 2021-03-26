Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0374EC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 01:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A421F61A42
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 01:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhCZBcF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 21:32:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230137AbhCZBcA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Mar 2021 21:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616722317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DlN71cKYOmS5IHeeJ6QpruSNXv6TWSKr5ALsdrk0/uc=;
        b=F0iRHOVFLRyAGjgBJtbGcU/g6AWqmmu3l9TELQtBt3q+XovTX8z2JerEb+1BPrJEn149u5
        J0lpOmNYtBy4UV5YZW2h38BA/dnBMC3VmZ7tmMQHJNqiYDJL76EJsKmiENftzzdM3Zt3II
        4RsXZipjfiq/V5N5PKIas4zYqbgwNNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-HrzQwXV9P1ycFD2nDjtkvw-1; Thu, 25 Mar 2021 21:31:55 -0400
X-MC-Unique: HrzQwXV9P1ycFD2nDjtkvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70A5F501E8;
        Fri, 26 Mar 2021 01:31:54 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9627B5C3DF;
        Fri, 26 Mar 2021 01:31:53 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add support for FALLOC_FL_COLLAPSE_RANGE
Date:   Fri, 26 Mar 2021 11:31:46 +1000
Message-Id: <20210326013146.80962-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9bae7e8deb09..1082c22551d7 100644
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
+		rc -EFBIG;
+		goto out;
+	}
+
+	if (off >= i_size_read(file->f_inode) ||
+	    off + len >= i_size_read(file->f_inode)) {
+		rc -EINVAL;
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

