Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00EBC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 01:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379015AbiDUBSh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Apr 2022 21:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiDUBSh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Apr 2022 21:18:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A335C12AF0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 18:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650503748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a8bzPDlwDWXP/F1oEBFvZBfAexg9wGiS45fFVla7tIE=;
        b=J7Zz9u/BNhyCw5MCvYjh+/GjBcszinkgenc+iJunmFMpKDYQPjvx+sEAX3sIjDlmzQOct7
        02cB1iIcrxszIfU+ZZVk3S3OxVTlgIh0oqBoaUBldpVpTw1d6zpVUxWYcQ+7kj+jKw6ZmV
        itlwmMWkc5aMSH1NKH8AZ9H82k6O5oo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-jtJ4H04OMPqBvKuPZag8SQ-1; Wed, 20 Apr 2022 21:15:44 -0400
X-MC-Unique: jtJ4H04OMPqBvKuPZag8SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C126F811E75;
        Thu, 21 Apr 2022 01:15:43 +0000 (UTC)
Received: from thinkpad (vpn2-54-19.bne.redhat.com [10.64.54.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 414E37B7C;
        Thu, 21 Apr 2022 01:15:43 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: destage any unwritten data to the server before calling copychunk_write
Date:   Thu, 21 Apr 2022 11:15:36 +1000
Message-Id: <20220421011536.1859398-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

because the copychunk_write might cover a region of the file that has not yet
been sent to the server and thus fail.

A simple way to reproduce this is:
truncate -s 0 /mnt/testfile; strace -f -o x -ttT xfs_io -i -f -c 'pwrite 0k 128k' -c 'fcollapse 16k 24k' /mnt/testfile

the issue is that the 'pwrite 0k 128k' becomes rearranged on the wire with
the 'fcollapse 16k 24k' due to write-back caching.

fcollapse is implemented in cifs.ko as a SMB2 IOCTL(COPYCHUNK_WRITE) call
and it will fail serverside since the file is still 0b in size serverside
until the writes have been destaged.
To avoid this we must ensure that we destage any unwritten data to the
server before calling COPYCHUNK_WRITE.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1997373
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a67df8eaf702..d6aaeff4a30a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1858,9 +1858,17 @@ smb2_copychunk_range(const unsigned int xid,
 	int chunks_copied = 0;
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
+	struct inode *inode;
 
 	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
 
+	/*
+	 * We need to flush all unwritten data before we can send the
+	 * copychunk ioctl to the server.
+	 */
+	inode = d_inode(trgtfile->dentry);
+	filemap_write_and_wait(inode->i_mapping);
+
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
-- 
2.30.2

