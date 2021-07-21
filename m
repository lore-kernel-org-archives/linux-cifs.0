Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DA1C07E9B
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 00:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 961E96108B
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 00:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhGUAKK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jul 2021 20:10:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229738AbhGUAJs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Jul 2021 20:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626828624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/q+GnSwc6XqvZVPwYwm38R1Vmxu1GoQ1+LMIZ8j56QM=;
        b=NlDKzG8N/8NaU/auBui97WMlDHb75jRkbVXWwA63Cw6lwRRXDq1NshLYA2DJkXGOIB2sAb
        CVtdNL1zoGA1MtQNvbIRiEBieVyzvhs05bcGosQvVkG/q6LgjtpWczSuHVUEp1i4g9AhfY
        esBgHWF3EAyPCoCPKC9qHp8eiKWIiTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-6hDswlG3NSWkReH55bTThQ-1; Tue, 20 Jul 2021 20:50:22 -0400
X-MC-Unique: 6hDswlG3NSWkReH55bTThQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEAED1084F40;
        Wed, 21 Jul 2021 00:50:21 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-145.bne.redhat.com [10.64.54.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 546F75D703;
        Wed, 21 Jul 2021 00:50:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: only write 64kb at a time when fallocating a small region of a file
Date:   Wed, 21 Jul 2021 10:50:15 +1000
Message-Id: <20210721005015.3329781-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We only allow sending single credit writes through the SMB2_write() synchronous
api so split this into smaller chunks.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ba3c58e1f725..7fefa100887b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3617,7 +3617,7 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	int rc, nbytes;
 	struct kvec iov[2];
 
 	io_parms.netfid = cfile->fid.netfid;
@@ -3625,13 +3625,25 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 	io_parms.tcon = tcon;
 	io_parms.persistent_fid = cfile->fid.persistent_fid;
 	io_parms.volatile_fid = cfile->fid.volatile_fid;
-	io_parms.offset = off;
-	io_parms.length = len;
 
-	/* iov[0] is reserved for smb header */
-	iov[1].iov_base = buf;
-	iov[1].iov_len = io_parms.length;
-	return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
+	while (len) {
+		io_parms.offset = off;
+		io_parms.length = len;
+		if (io_parms.length > 65536)
+			io_parms.length = 65536;
+		/* iov[0] is reserved for smb header */
+		iov[1].iov_base = buf;
+		iov[1].iov_len = io_parms.length;
+		rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
+		if (rc)
+			break;
+		if (nbytes > len)
+			return -EINVAL;
+		buf += nbytes;
+		off += nbytes;
+		len -= nbytes;
+	}
+	return rc;
 }
 
 static int smb3_simple_fallocate_range(unsigned int xid,
@@ -3655,11 +3667,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			(char **)&out_data, &out_data_len);
 	if (rc)
 		goto out;
-	/*
-	 * It is already all allocated
-	 */
-	if (out_data_len == 0)
-		goto out;
 
 	buf = kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
-- 
2.30.2

