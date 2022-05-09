Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBA0C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 16:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbiEIQkW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 12:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238927AbiEIQkU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 12:40:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65B172C122
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 09:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652114185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqq8RFDDVTG3pqBstpoDmsSPOYQOvaUiiYkEmL2VRNA=;
        b=OAk9gMcFBTNZ5ap84/8E2nzfX12DXeWyzVfukk92UTEuD4nkpZ3vZzV+4UV3mzdhfJn9rN
        YMIO5AQor8uCA/LKZRKsirhb6MFVgTybIjaSsEt1jLSy4WRBu+hFt1Wj6fh5dN3g8pzf0R
        jUknpdVBf8cjuatnRoUFBWQIgyq1U8Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-QAT3AU-jOzajhnp3QEXzPg-1; Mon, 09 May 2022 12:36:23 -0400
X-MC-Unique: QAT3AU-jOzajhnp3QEXzPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B210803D45;
        Mon,  9 May 2022 16:36:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12F7314E0423;
        Mon,  9 May 2022 16:36:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/6] iov_iter: Add a general purpose iteration function
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     dhowells@redhat.com, Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 09 May 2022 17:36:21 +0100
Message-ID: <165211418137.3154751.986565648214214085.stgit@warthog.procyon.org.uk>
In-Reply-To: <165211416682.3154751.17287804906832979514.stgit@warthog.procyon.org.uk>
References: <165211416682.3154751.17287804906832979514.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add a function, iov_iter_scan(), to iterate over the buffers described by
an I/O iterator, kmapping and passing each contiguous chunk the the
supplied scanner function in turn, up to the requested amount of data or
until the scanner function returns an error.

This can be used, for example, to hash all the data in an iterator by
having the scanner function call the appropriate crypto update function.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/uio.h |    4 ++++
 lib/iov_iter.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 5a3c6f296b96..8d89203064e7 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -244,6 +244,10 @@ int iov_iter_npages(const struct iov_iter *i, int maxpages);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
+ssize_t iov_iter_scan(struct iov_iter *i, size_t bytes,
+		      ssize_t (*scanner)(struct iov_iter *i, const void *p,
+					 size_t len, size_t off, void *priv),
+		      void *priv);
 
 static inline size_t iov_iter_count(const struct iov_iter *i)
 {
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 8db34ddd23be..834e1e268eb6 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1789,6 +1789,46 @@ ssize_t extract_iter_to_iter(struct iov_iter *orig,
 }
 EXPORT_SYMBOL(extract_iter_to_iter);
 
+/**
+ * iov_iter_scan - Scan a source iter
+ * @i: The iterator to scan
+ * @bytes: The amount of buffer/data to scan
+ * @scanner: The function to call for each bit
+ * @priv: Private data to pass to the scanner function
+ *
+ * Scan an iterator, passing each segment to the scanner function.  If the
+ * scanner returns an error at any time, scanning stops and the error is
+ * returned, otherwise the sum of the scanner results is returned.
+ */
+ssize_t iov_iter_scan(struct iov_iter *i, size_t bytes,
+		      ssize_t (*scanner)(struct iov_iter *i, const void *p,
+					 size_t len, size_t off, void *priv),
+		      void *priv)
+{
+	ssize_t ret = 0, scanned = 0;
+
+	if (!bytes)
+		return 0;
+	if (iter_is_iovec(i))
+		might_fault();
+
+	iterate_and_advance(
+		i, bytes, base, len, off, ({
+				ret = scanner(i, base, len, off, priv);
+				if (ret < 0)
+					break;
+				scanned += ret;
+			}), ({
+				ret = scanner(i, base, len, off, priv);
+				if (ret < 0)
+					break;
+				scanned += ret;
+			})
+	);
+	return ret < 0 ? ret : scanned;
+}
+EXPORT_SYMBOL(iov_iter_scan);
+
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 			       struct iov_iter *i)
 {


