Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8491E0DFD
	for <linux-cifs@vger.kernel.org>; Fri, 13 Dec 2024 13:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734097858; cv=none; b=qG6KlIz5OeMImMwWW6QxJpPW2nAVSiD0EKrHhBeDb7y6i1wQ2cpVRKUiBxWMCyJjtTG99HSJpHu9oxPhKHQGt91Qq8ZLlYY/WPVd3xomu1hNbc/O9li+JLzSBudBGotJqgUUqZbRuQ9U1kvUl+2o6TgsfoyZbCVMINHh8vCDPiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734097858; c=relaxed/simple;
	bh=ee8bCaSWFbPmnDIBL40JFQm2oyep1Gfed/yf6gabDzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEZiLkYMEDDHjq7tBjW13B/pA5JXdMaq/BgmMoGeT3fDUPis3fkjojtXLcfhBkqBAEwTpYQ+vyTo0PxZKSqsSmEvLoQ8FWcxEMLXjlc54wIQea0qEC7gM+9QZ7yKhUZ/Ton7SegiFnevmqS74jF+j1d1QfBurTcuXmhAj35cZ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MwVdUgwf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwVdUgwf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734097855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5M1ENZFbO/mNMn248U1qss6F8q2hwKZC+45ijoUGNaQ=;
	b=MwVdUgwfQSQIi4jmyuKEgAO2ZchpnKwypFPV9WsITKHn5sFkT/AA0Tl3NzjgFy9lKEMJ3l
	1l2cWgmr3Jw5hO0t9OmBzeEwq2o7kuuuky/ianG5BZlHTSov57JhquBrIjyngLMZi+DT15
	sjkfVw0YkZNQDEu/Ql3ozUoHhZIgU3Q=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-492-komwBIjYNoKdH0VnGk57oA-1; Fri,
 13 Dec 2024 08:50:52 -0500
X-MC-Unique: komwBIjYNoKdH0VnGk57oA-1
X-Mimecast-MFC-AGG-ID: komwBIjYNoKdH0VnGk57oA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D61E71956056;
	Fri, 13 Dec 2024 13:50:49 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.48])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC2561956052;
	Fri, 13 Dec 2024 13:50:44 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Anna Schumaker <anna@kernel.org>,
	Dave Wysochanski <dwysocha@redhat.com>
Subject: [PATCH 04/10] nfs: Fix oops in nfs_netfs_init_request() when copying to cache
Date: Fri, 13 Dec 2024 13:50:04 +0000
Message-ID: <20241213135013.2964079-5-dhowells@redhat.com>
In-Reply-To: <20241213135013.2964079-1-dhowells@redhat.com>
References: <20241213135013.2964079-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When netfslib wants to copy some data that has just been read on behalf of
nfs, it creates a new write request and calls nfs_netfs_init_request() to
initialise it, but with a NULL file pointer.  This causes
nfs_file_open_context() to oops - however, we don't actually need the nfs
context as we're only going to write to the cache.

Fix this by just returning if we aren't given a file pointer and emit a
warning if the request was for something other than copy-to-cache.

Further, fix nfs_netfs_free_request() so that it doesn't try to free the
context if the pointer is NULL.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Reported-by: Max Kellermann <max.kellermann@ionos.com>
Closes: https://lore.kernel.org/r/CAKPOu+9DyMbKLhyJb7aMLDTb=Fh0T8Teb9sjuf_pze+XWT1VaQ@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <trondmy@kernel.org>
cc: Anna Schumaker <anna@kernel.org>
cc: Dave Wysochanski <dwysocha@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-nfs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/nfs/fscache.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 810269ee0a50..d49e4ce27999 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -263,6 +263,12 @@ int nfs_netfs_readahead(struct readahead_control *ractl)
 static atomic_t nfs_netfs_debug_id;
 static int nfs_netfs_init_request(struct netfs_io_request *rreq, struct file *file)
 {
+	if (!file) {
+		if (WARN_ON_ONCE(rreq->origin != NETFS_PGPRIV2_COPY_TO_CACHE))
+			return -EIO;
+		return 0;
+	}
+
 	rreq->netfs_priv = get_nfs_open_context(nfs_file_open_context(file));
 	rreq->debug_id = atomic_inc_return(&nfs_netfs_debug_id);
 	/* [DEPRECATED] Use PG_private_2 to mark folio being written to the cache. */
@@ -274,7 +280,8 @@ static int nfs_netfs_init_request(struct netfs_io_request *rreq, struct file *fi
 
 static void nfs_netfs_free_request(struct netfs_io_request *rreq)
 {
-	put_nfs_open_context(rreq->netfs_priv);
+	if (rreq->netfs_priv)
+		put_nfs_open_context(rreq->netfs_priv);
 }
 
 static struct nfs_netfs_io_data *nfs_netfs_alloc(struct netfs_io_subrequest *sreq)

