Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A7342C98
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121708; cv=none; b=c1ZFSsIUHeaThMl9RiQ5tpoJAZLRrtKjn+9wrDEEB33IXodFj8G6d/NfvI5ZRb2Wy2Cw55KFX2sogsw/o4I4skbORuix9SSLzDkdJrvWKiKfAdLQTNQVv22Wj7IruOHemEi1G8D71UYD7lnhfWoYjCHihAq920MOC5G6ujbM+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121708; c=relaxed/simple;
	bh=9j5/dEk1nuavP9c7Mm6z3WVXHb5kswzKhu0IZvmrw7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2CsgSG/kP0CTWRG1r+aahq9bPZ0R/7T/Rr+qqXqu1xSJDKXJk2SScDva+/VplEF0baX0uA9OOF8z4CZyAmEQt0n/K1HSFWAJ6NFzz0cq+ma584eJoaFT33qm0IeMwC46xbHYFBU31euGLnuLpvesxJgEu/9cz0gGoye/c6PelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2NWL5zX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2NWL5zX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SAuDfItFyO4D0alvtN3lqINjyYfl9NeJc3tZVlSezTo=;
	b=N2NWL5zXcvsKqrOnJ4H2sjLr0uBjpB+awf4sKCXfMN4fUKB2y1S/PV0wNsDf/0wmmHvqTH
	3O5sIdbeVcOHqjsMrJh4HzYnFkLrf8xFIsuO7t+vY1VrZ5WTYZpQDeBf8q4o0zcoX9DZh7
	3vhOLE4+H2vJwD+p+RT4K+qdt3WycjE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-oHXAZx66PZOgSkRAq2LP3g-1; Sat,
 25 Apr 2026 08:55:01 -0400
X-MC-Unique: oHXAZx66PZOgSkRAq2LP3g-1
X-Mimecast-MFC-AGG-ID: oHXAZx66PZOgSkRAq2LP3g_1777121699
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CB631800348;
	Sat, 25 Apr 2026 12:54:59 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B8963007572;
	Sat, 25 Apr 2026 12:54:56 +0000 (UTC)
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
Subject: [PATCH v3 05/19] netfs: Fix streaming write being overwritten
Date: Sat, 25 Apr 2026 13:54:09 +0100
Message-ID: <20260425125426.3855807-6-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

In order to avoid reading whilst writing, netfslib will allow "streaming
writes" in which dirty data is stored directly into folios without reading
them first.  Such folios are marked dirty but may not be marked uptodate.
If a folio is entirely written by a streaming write, uptodate will be set,
otherwise it will have a netfs_folio struct attached to ->private recording
the dirty region.

In the event that a partially written streaming write page is to be
overwritten entirely by a single write(), netfs_perform_write() will try to
copy over it, but doesn't discard the netfs_folio if it succeeds; further,
it doesn't correctly handle a partial copy that overwrites some of the
dirty data.

Fix this by the following:

 (1) If the folio is successfully overwritten, free the netfs_folio struct
     before marking the page uptodate.

 (2) If the copy to the folio partially fails, but short of the dirty data,
     just ignore the copy.

 (3) If the copy partially fails and overwrites some of the dirty data,
     accept the copy, update the netfs_folio struct to record the new data.
     If the folio is now filled, free the netfs_folio and set uptodate,
     otherwise return a partial write.

Found with:

	fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
	  /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

	truncate 0x0 0 0x927c0
	write 0x63fb8 0x53c8 0
	copy_range 0xb704 0x19b9 0x24429 0x79380
	write 0x2402b 0x144a2 0x90660 *
	write 0x204d5 0x140a0 0x927c0 *
	copy_range 0x1f72c 0x137d0 0x7a906 0x927c0 *
	read 0x00000 0x20000 0x9157c
	read 0x20000 0x20000 0x9157c
	read 0x40000 0x20000 0x9157c
	read 0x60000 0x20000 0x9157c
	read 0x7e1a0 0xcfb9 0x9157c

on cifs with the default cache option.

It shows folio 0x24 misbehaving if the FMODE_READ check is commented out in
netfs_perform_write():

		if (//(file->f_mode & FMODE_READ) ||
		    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Fixes: 8f52de0077ba ("netfs: Reduce number of conditional branches in netfs_perform_write()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c    | 45 +++++++++++++++++++++++++-----------
 include/trace/events/netfs.h |  2 ++
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index fab172252759..165e4a3c8b62 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -246,18 +246,36 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		/* See if we can write a whole folio in one go. */
 		if (!maybe_trouble && offset == 0 && part >= flen) {
 			copied = copy_folio_from_iter_atomic(folio, offset, part, iter);
-			if (unlikely(copied == 0))
+			if (likely(copied == part)) {
+				if (finfo) {
+					trace = netfs_whole_folio_modify_filled;
+					goto folio_now_filled;
+				}
+				__netfs_set_group(folio, netfs_group);
+				folio_mark_uptodate(folio);
+				trace = netfs_whole_folio_modify;
+				goto copied;
+			}
+			if (copied == 0)
 				goto copy_failed;
-			if (unlikely(copied < part)) {
+			if (!finfo || copied <= finfo->dirty_offset) {
 				maybe_trouble = true;
 				iov_iter_revert(iter, copied);
 				copied = 0;
 				folio_unlock(folio);
 				goto retry;
 			}
-			__netfs_set_group(folio, netfs_group);
-			folio_mark_uptodate(folio);
-			trace = netfs_whole_folio_modify;
+
+			/* We overwrote some existing dirty data, so we have to
+			 * accept the partial write.
+			 */
+			finfo->dirty_len += finfo->dirty_offset;
+			if (finfo->dirty_len == flen)
+				goto folio_now_filled;
+			if (copied > finfo->dirty_len)
+				finfo->dirty_len = copied;
+			finfo->dirty_offset = 0;
+			trace = netfs_whole_folio_modify_efault;
 			goto copied;
 		}
 
@@ -327,16 +345,10 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 				goto copy_failed;
 			finfo->dirty_len += copied;
 			if (finfo->dirty_offset == 0 && finfo->dirty_len == flen) {
-				if (finfo->netfs_group)
-					folio_change_private(folio, finfo->netfs_group);
-				else
-					folio_detach_private(folio);
-				folio_mark_uptodate(folio);
-				kfree(finfo);
 				trace = netfs_streaming_cont_filled_page;
-			} else {
-				trace = netfs_streaming_write_cont;
+				goto folio_now_filled;
 			}
+			trace = netfs_streaming_write_cont;
 			goto copied;
 		}
 
@@ -350,6 +362,13 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			goto out;
 		continue;
 
+	folio_now_filled:
+		if (finfo->netfs_group)
+			folio_change_private(folio, finfo->netfs_group);
+		else
+			folio_detach_private(folio);
+		folio_mark_uptodate(folio);
+		kfree(finfo);
 	copied:
 		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 0b702f74aefe..67f6d56c94ce 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -177,6 +177,8 @@
 	EM(netfs_folio_is_uptodate,		"mod-uptodate")	\
 	EM(netfs_just_prefetch,			"mod-prefetch")	\
 	EM(netfs_whole_folio_modify,		"mod-whole-f")	\
+	EM(netfs_whole_folio_modify_efault,	"mod-whole-f!")	\
+	EM(netfs_whole_folio_modify_filled,	"mod-whole-f+")	\
 	EM(netfs_modify_and_clear,		"mod-n-clear")	\
 	EM(netfs_streaming_write,		"mod-streamw")	\
 	EM(netfs_streaming_write_cont,		"mod-streamw+")	\

