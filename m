Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8B8C677F1
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Feb 2023 21:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBPVt3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjBPVtX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 16:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8970B4B529
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 13:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676584109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gp2W96yfCpLFU4rVrbJwG/yzMjTMitm55rNRmKmTZrE=;
        b=S3LvI54i9oZNVWcjVyhwA9WFyAAj4f6PXlTJROOe0XqPxx+nz13xEp7SJt+/isDGksupA3
        7YOE66oFqxEE4lZdVTDgfYC4pZdPRvCdIFPZeHpMhD1JqcZ4+Kb3ORiJ99Kv7WtxwpRPAr
        eO46jIb38lTQ9h358HeS149aIEXqDdE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-t-XLGBKJN1OaorYTO7C7CA-1; Thu, 16 Feb 2023 16:48:25 -0500
X-MC-Unique: t-XLGBKJN1OaorYTO7C7CA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2CB738123AF;
        Thu, 16 Feb 2023 21:48:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BB9E492B15;
        Thu, 16 Feb 2023 21:48:22 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 06/17] splice: Export filemap/direct_splice_read()
Date:   Thu, 16 Feb 2023 21:47:34 +0000
Message-Id: <20230216214745.3985496-7-dhowells@redhat.com>
In-Reply-To: <20230216214745.3985496-1-dhowells@redhat.com>
References: <20230216214745.3985496-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

filemap_splice_read() and direct_splice_read() should be exported.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: David Hildenbrand <david@redhat.com>
cc: John Hubbard <jhubbard@nvidia.com>
cc: linux-cifs@vger.kernel.org
cc: linux-mm@kvack.org
cc: linux-block@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/splice.c  | 1 +
 mm/filemap.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 4c6332854b63..928c7be2f318 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -373,6 +373,7 @@ ssize_t direct_splice_read(struct file *in, loff_t *ppos,
 	kfree(bv);
 	return ret;
 }
+EXPORT_SYMBOL(direct_splice_read);
 
 /**
  * generic_file_splice_read - splice data from file to a pipe
diff --git a/mm/filemap.c b/mm/filemap.c
index 8c7b135c8e23..570f86578f7c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2969,6 +2969,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 
 	return total_spliced ? total_spliced : error;
 }
+EXPORT_SYMBOL(filemap_splice_read);
 
 static inline loff_t folio_seek_hole_data(struct xa_state *xas,
 		struct address_space *mapping, struct folio *folio,

