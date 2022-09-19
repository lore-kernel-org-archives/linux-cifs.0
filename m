Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84F0ECAAD3
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 05:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiISFjU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 01:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiISFjT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 01:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783D718352
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 22:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663565957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hB2SGjUYo7DOHUAAs7vrKwwFpmfRC1H+SXeT/msLtKA=;
        b=JqPAx/3y+gO5zhdhfoG8kSEqHrGRYoTgPQI5Rc3QHqmBNNjl9uNI/DaJcZ5fB/+BJrf9sg
        hBMLyR++AU7Kz6oecuWbOM1u7pa22pVO63Xa1A7C7d6cN7jpVrB/1PFQuP25IhHVyAXI8z
        qcWVwhNqeLteZb+DnAACVj+Es2PtIyo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-R5n_33_nM2qbC4V_XVztvw-1; Mon, 19 Sep 2022 01:39:09 -0400
X-MC-Unique: R5n_33_nM2qbC4V_XVztvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B7BF811E67;
        Mon, 19 Sep 2022 05:39:09 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0EA42084836;
        Mon, 19 Sep 2022 05:39:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: destage dirty pages before re-reading them for cache=none
Date:   Mon, 19 Sep 2022 15:39:01 +1000
Message-Id: <20220919053901.465232-2-lsahlber@redhat.com>
In-Reply-To: <20220919053901.465232-1-lsahlber@redhat.com>
References: <20220919053901.465232-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is the opposite case of kernel bugzilla 216301.
If we mmap a file using cache=none and then proceed to update the mmapped
area these updates are not reflected in a later pread() of that part of the
file.
To fix this we must first destage any dirty pages in the range before
we allow the pread() to proceed.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6f38b134a346..b38cebefb0db 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4271,6 +4271,16 @@ static ssize_t __cifs_readv(
 		len = ctx->len;
 	}
 
+	if (direct && file->f_inode->i_mapping &&
+	    file->f_inode->i_mapping->nrpages != 0) {
+		rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
+						  offset, offset + len - 1);
+		if (rc) {
+			kref_put(&ctx->refcount, cifs_aio_ctx_release);
+			return rc;
+		}
+	}
+	
 	/* grab a lock here due to read response handlers can access ctx */
 	mutex_lock(&ctx->aio_mutex);
 
-- 
2.35.3

