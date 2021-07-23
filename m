Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2456EC4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 01:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1FA760EB2
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 01:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhGWAlA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 20:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232892AbhGWAlA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Jul 2021 20:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627003294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uY/drB4p2x++Vk7RFsOCJhV9k1kv/h1jOWTDSCA43uY=;
        b=Sc8+FZ32YOr43ogT/btji9+/UQBE5C0MjIzxMGyEnetFktxDgTRRDZw+7ONpKxmrfB0074
        QE610tX0iCcctYxDzPsvY/sOh4xHSIYi5eECxljvbo8jUftvL4yJPaY8GLV3HCKr2oE2Xs
        ZOekMOQoQL6oTmkgxQ/xjPdXX27P+Uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-vtjvZUlvNCqqOK0AsqOpWA-1; Thu, 22 Jul 2021 21:21:33 -0400
X-MC-Unique: vtjvZUlvNCqqOK0AsqOpWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A4511084F4B;
        Fri, 23 Jul 2021 01:21:32 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-145.bne.redhat.com [10.64.54.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64E9D19CBA;
        Fri, 23 Jul 2021 01:21:31 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix fallocate when trying to allocate a hole.
Date:   Fri, 23 Jul 2021 11:21:24 +1000
Message-Id: <20210723012124.3405007-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove the conditional checking for out_data_len and skipping the fallocate
if it is 0. This is wrong will actually change any legitimate the fallocate
where the entire region is unallocated into a no-op.

Additionally, before allocating the range, if FALLOC_FL_KEEP_SIZE is set then
we need to clamp the length of the fallocate region as to not extend the size of the file.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5cefb5972396..238717654e46 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3667,11 +3667,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
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
@@ -3794,6 +3789,24 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	if (keep_size == true) {
+		/*
+		 * We can not preallocate pages beyond the end of the file
+		 * in SMB2.
+		 */
+		if (off >= i_size_read(inode)) {
+			rc = -EFBIG;
+			goto out;
+		}
+		/*
+		 * For fallocates that are partially beyond the end of file,
+		 * clamp len so we only fallocate up to the end of file.
+		 */
+		if (off + len > i_size_read(inode)) {
+			len = i_size_read(inode) - off;
+		}
+	}
+
 	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
 		/*
 		 * At this point, we are trying to fallocate an internal
-- 
2.30.2

