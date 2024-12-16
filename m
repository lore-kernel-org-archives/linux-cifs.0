Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50C11D515D
	for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 20:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381815; cv=none; b=jBRDD1JslUuL1rCDkQiMiegg/WQybs+EedGby/f4pCeLS3K6JX4rt8OTXevkDDQJZNHzGKhwLxumsMzlwGjisDJn1GgmTcAih8Smwv6y6ql2T2YIynPCqfSCINu4EoZOh9BJ6p8juzw4e8egqtL5yoT6lSd3D75C/MjvNH8/x8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381815; c=relaxed/simple;
	bh=OTgo6y/iUbtT78QGPD0sssJss9B2yP/TOW1RhzQxkkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gew4hhldK0ff/E9Isz61XkgZNzpKN25iGskVIyzrBiaeMCGMqa0VwtiqiAsXx+iwu72roNu0lZE4aSmsETHkx2x0QH/vHfoK+HTTkNyFG9YmsFyZRy4A6aPc7lUn0a6JU92pA+xSUTLPHe8UioNA13KoBaOt9r2z2aKqphJePoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OQa4S10D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OQa4S10D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734381813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+h5xevLUTgx7DT+yXa3KdTAzsT6twp0kWM1j+wkaZ80=;
	b=OQa4S10DZXzEGPd+hMYVyooWXnUuSopQZH9MEF2+9cPiUeRb1j4mq4U6tkLb4OEE7Rewgr
	+RfNT+y8RFeB6oIWvWktUOEcl2ueVsGirOGEuPEOrWLWFLITUBVL38wXoeSlffQlFPtxma
	2AAc/AH+xyzNiTvf6uNRzNxWcVV4N7Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-8FHzIFyHP_G1A-tElrmP_g-1; Mon,
 16 Dec 2024 15:43:29 -0500
X-MC-Unique: 8FHzIFyHP_G1A-tElrmP_g-1
X-Mimecast-MFC-AGG-ID: 8FHzIFyHP_G1A-tElrmP_g
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 173481956064;
	Mon, 16 Dec 2024 20:43:27 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.48])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79E3719560B0;
	Mon, 16 Dec 2024 20:43:21 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 15/32] cachefiles: Add some subrequest tracepoints
Date: Mon, 16 Dec 2024 20:41:05 +0000
Message-ID: <20241216204124.3752367-16-dhowells@redhat.com>
In-Reply-To: <20241216204124.3752367-1-dhowells@redhat.com>
References: <20241216204124.3752367-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add some tracepoints into the cachefiles write paths.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: netfs@lists.linux.dev
---
 fs/cachefiles/io.c           | 4 ++++
 include/trace/events/netfs.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 6a821a959b59..92058ae43488 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -13,6 +13,7 @@
 #include <linux/falloc.h>
 #include <linux/sched/mm.h>
 #include <trace/events/fscache.h>
+#include <trace/events/netfs.h>
 #include "internal.h"
 
 struct cachefiles_kiocb {
@@ -366,6 +367,7 @@ static int cachefiles_write(struct netfs_cache_resources *cres,
 	if (!fscache_wait_for_operation(cres, FSCACHE_WANT_WRITE)) {
 		if (term_func)
 			term_func(term_func_priv, -ENOBUFS, false);
+		trace_netfs_sreq(term_func_priv, netfs_sreq_trace_cache_nowrite);
 		return -ENOBUFS;
 	}
 
@@ -695,6 +697,7 @@ static void cachefiles_issue_write(struct netfs_io_subrequest *subreq)
 		iov_iter_truncate(&subreq->io_iter, len);
 	}
 
+	trace_netfs_sreq(subreq, netfs_sreq_trace_cache_prepare);
 	cachefiles_begin_secure(cache, &saved_cred);
 	ret = __cachefiles_prepare_write(object, cachefiles_cres_file(cres),
 					 &start, &len, len, true);
@@ -704,6 +707,7 @@ static void cachefiles_issue_write(struct netfs_io_subrequest *subreq)
 		return;
 	}
 
+	trace_netfs_sreq(subreq, netfs_sreq_trace_cache_write);
 	cachefiles_write(&subreq->rreq->cache_resources,
 			 subreq->start, &subreq->io_iter,
 			 netfs_write_subrequest_terminated, subreq);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 2dfc9f716e3b..02f6e179b7bc 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -74,6 +74,9 @@
 #define netfs_sreq_traces					\
 	EM(netfs_sreq_trace_add_donations,	"+DON ")	\
 	EM(netfs_sreq_trace_added,		"ADD  ")	\
+	EM(netfs_sreq_trace_cache_nowrite,	"CA-NW")	\
+	EM(netfs_sreq_trace_cache_prepare,	"CA-PR")	\
+	EM(netfs_sreq_trace_cache_write,	"CA-WR")	\
 	EM(netfs_sreq_trace_clear,		"CLEAR")	\
 	EM(netfs_sreq_trace_discard,		"DSCRD")	\
 	EM(netfs_sreq_trace_donate_to_prev,	"DON-P")	\

