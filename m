Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73C938CFE1
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 08:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674274; cv=none; b=bmkLGsEhBdgWynsTscs9LGdsuzPv+cY5to6/vB7tYUuiV6u9KhXNZoswYoI867G1sewaG6bDc8B5kHMSGjerYKzglcOi01COkhb01v3vKCyPy9Rw1KE0jjcfwKXZxHTtlHi2E3oUvJfsrMURyydIxCu5e31Uy6FrONUMVtYxjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674274; c=relaxed/simple;
	bh=mtHnEjvRwJ+xdJf8DIqVxDhrtVHQt4N+eCpgfUIB8lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGEWtQXWvVcVe1+ts3EcKeZChzf3o89FpUM36EnFYx+3tVmgKn5R+4PLUq/tMnDyRSuAx7YbVFwxXgXDr+arJ7SX+ewYP9XwbglfuIbdHPNKIn2t7cbevTC5Tkdebn/btARf7tf67CtCCAcOAzkBkFMh1mjfsMqTjJfKqWxKjPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dWNnr1zb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dWNnr1zb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776674271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ob6xCMZuqNEj/Bt5UZPBU1fDVm9Ru5OkhDx15MsP/Ik=;
	b=dWNnr1zb2eQtWlaOyOu8vRTpJdz7WP7r/QvvcxC7slsfUMAM54/NP4Nn5nSt2SRzVzSfeR
	8juCM3x6tdJvXs8Ycqcjmq5zBjcYR4JZkXUDgX7fMGefOe3QpvhxB5nCET0iUgkAPv4fyp
	6uTXpMhMUsQ2+4V7Ii328JVJEJk2rjE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-G8XKq8e8P8akCl28AhsOsg-1; Mon,
 20 Apr 2026 04:37:46 -0400
X-MC-Unique: G8XKq8e8P8akCl28AhsOsg-1
X-Mimecast-MFC-AGG-ID: G8XKq8e8P8akCl28AhsOsg_1776674264
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0F7819560A3;
	Mon, 20 Apr 2026 08:37:44 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4663195608E;
	Mon, 20 Apr 2026 08:37:41 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 06/11] netfs: Fix the trace displayed for the total overwrite of a streamed write
Date: Mon, 20 Apr 2026 09:36:57 +0100
Message-ID: <20260420083705.1009074-7-dhowells@redhat.com>
In-Reply-To: <20260420083705.1009074-1-dhowells@redhat.com>
References: <20260420083705.1009074-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Change netfs_perform_write() to carry the trace value in a variable and
emit it later to make it easier to select the value displayed.

Fix the display of netfs_streaming_write_cont in the "folio_now_filled:"
section.  It should only be set to that if we come from the section that
filled in a gap in an already streamed write (and would otherwise display
netfs_streaming_write_cont).  If it came from the bit that just overwrites
the entire folio (which would ordinarily display netfs_whole_folio_modify),
make it display netfs_whole_folio_modify_filled instead.

Fixes: 1bfeb53e990b ("netfs: Fix streaming write being overwritten")
Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c    | 27 ++++++++++++++++-----------
 include/trace/events/netfs.h |  1 +
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 6399141b4f0a..de82eb6ed473 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -150,6 +150,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	do {
+		enum netfs_folio_trace trace;
 		struct netfs_folio *finfo;
 		struct netfs_group *group;
 		unsigned long long fpos;
@@ -223,7 +224,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			netfs_set_group(folio, netfs_group);
-			trace_netfs_folio(folio, netfs_folio_is_uptodate);
+			trace = netfs_folio_is_uptodate;
 			goto copied;
 		}
 
@@ -239,7 +240,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			folio_zero_segment(folio, offset + copied, flen);
 			__netfs_set_group(folio, netfs_group);
 			folio_mark_uptodate(folio);
-			trace_netfs_folio(folio, netfs_modify_and_clear);
+			trace = netfs_modify_and_clear;
 			goto copied;
 		}
 
@@ -247,11 +248,13 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		if (!maybe_trouble && offset == 0 && part >= flen) {
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
 			if (likely(copied == part)) {
-				if (finfo)
+				if (finfo) {
+					trace = netfs_whole_folio_modify_filled;
 					goto folio_now_filled;
+				}
 				__netfs_set_group(folio, netfs_group);
 				folio_mark_uptodate(folio);
-				trace_netfs_folio(folio, netfs_whole_folio_modify);
+				trace = netfs_whole_folio_modify;
 				goto copied;
 			}
 			if (copied == 0)
@@ -273,7 +276,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (copied > finfo->dirty_len)
 				finfo->dirty_len = copied;
 			finfo->dirty_offset = 0;
-			trace_netfs_folio(folio, netfs_whole_folio_modify_efault);
+			trace = netfs_whole_folio_modify_efault;
 			goto copied;
 		}
 
@@ -299,7 +302,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			netfs_set_group(folio, netfs_group);
-			trace_netfs_folio(folio, netfs_just_prefetch);
+			trace = netfs_just_prefetch;
 			goto copied;
 		}
 
@@ -313,7 +316,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (offset == 0 && copied == flen) {
 				__netfs_set_group(folio, netfs_group);
 				folio_mark_uptodate(folio);
-				trace_netfs_folio(folio, netfs_streaming_filled_page);
+				trace = netfs_streaming_filled_page;
 				goto copied;
 			}
 
@@ -328,7 +331,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len = copied;
 			folio_attach_private(folio, (void *)((unsigned long)finfo |
 							     NETFS_FOLIO_INFO));
-			trace_netfs_folio(folio, netfs_streaming_write);
+			trace = netfs_streaming_write;
 			goto copied;
 		}
 
@@ -341,9 +344,11 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			finfo->dirty_len += copied;
-			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen)
+			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
+				trace = netfs_streaming_cont_filled_page;
 				goto folio_now_filled;
-			trace_netfs_folio(folio, netfs_streaming_write_cont);
+			}
+			trace = netfs_streaming_write_cont;
 			goto copied;
 		}
 
@@ -364,8 +369,8 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			folio_detach_private(folio);
 		folio_mark_uptodate(folio);
 		kfree(finfo);
-		trace_netfs_folio(folio, netfs_streaming_cont_filled_page);
 	copied:
+		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
 
 		/* Update the inode size if we moved the EOF marker */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index ee7fea84f055..67f6d56c94ce 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -178,6 +178,7 @@
 	EM(netfs_just_prefetch,			"mod-prefetch")	\
 	EM(netfs_whole_folio_modify,		"mod-whole-f")	\
 	EM(netfs_whole_folio_modify_efault,	"mod-whole-f!")	\
+	EM(netfs_whole_folio_modify_filled,	"mod-whole-f+")	\
 	EM(netfs_modify_and_clear,		"mod-n-clear")	\
 	EM(netfs_streaming_write,		"mod-streamw")	\
 	EM(netfs_streaming_write_cont,		"mod-streamw+")	\

