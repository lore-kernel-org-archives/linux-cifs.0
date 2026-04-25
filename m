Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04581377EB0
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121705; cv=none; b=bMsYQuF60Xj3q4Wx3RD6dBn7MaelZTCjXAIDvz9cZK9K7OAk4k9sap1KYcouhgipjWgNIfUMG7Y7/bzGd/FNRz5s5NaHkhne8345IHuJop7P9iBHKO9uem79JAP+N0Yt9AQn49ZsUOoj8BDpRJeRKqsoF9m4DPrpYWd12d8HOeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121705; c=relaxed/simple;
	bh=L9uDEWc377LyFxnGqjoD7bz8n9BmlU910383FaIozvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJk5Uzth5G7Cs05DdVWtXCGDVNdx5VqryVjJTC2V0XzB1ZaCp4Ti4H3D+uaQb315XX7GU/0HhuuhQD6rMXiT8i/VDR9L+ks2SeCWokOrrbiABgTsComShWQaNug+uK1y2IxCW+haxXG4823UkFxa3TioFmDhO+KDgBY8gW1IyHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GQPlU7SS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQPlU7SS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=noSFW4QrgU04t76ao8sma85MSS21oApvyuIr1RZUnw4=;
	b=GQPlU7SSK/msLvJkoVcpBW///KwFr7L6OneuRfKWYfUSNDFnPTMloVPrdoOWSEfa/5KFAu
	XnszRcR5/5h2V93u64S1gxbCVgw1HEpRczhvYDxdmJqfSNbZ9hSxRuuHcd4xWCmYapIJjg
	3S0yjfATLPy+kSKwBiiOhNiFMsbDKq4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-hRy78XhgPO-RfzkCfb6ycA-1; Sat,
 25 Apr 2026 08:54:52 -0400
X-MC-Unique: hRy78XhgPO-RfzkCfb6ycA-1
X-Mimecast-MFC-AGG-ID: hRy78XhgPO-RfzkCfb6ycA_1777121690
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B0EE1956056;
	Sat, 25 Apr 2026 12:54:50 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B9991944CED;
	Sat, 25 Apr 2026 12:54:45 +0000 (UTC)
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
	Marc Dionne <marc.dionne@auristor.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 03/19] netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes gone
Date: Sat, 25 Apr 2026 13:54:07 +0100
Message-ID: <20260425125426.3855807-4-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

If a streaming write is made, this will leave the relevant modified folio
in a not-uptodate, but dirty state with a netfs_folio struct hung off of
folio->private indicating the dirty range.  Subsequently truncating the
file such that the dirty data in the folio is removed, but the first part
of the folio theoretically remains will cause the netfs_folio struct to be
discarded... but will leave the dirty flag set.

If the folio is then read via mmap(), netfs_read_folio() will see that the
page is dirty and jump to netfs_read_gaps() to fill in the missing bits.
netfs_read_gaps(), however, expects there to be a netfs_folio struct
present and can oops because truncate removed it.

Fix this by calling folio_cancel_dirty() in netfs_invalidate_folio() in the
event that all the dirty data in the folio is erased (as nfs does).

Also add some tracepoints to log modifications to a dirty page.

This can be reproduced with something like:

    dd if=/dev/zero of=/xfstest.test/foo bs=1M count=1
    umount /xfstest.test
    mount /xfstest.test
    xfs_io -c "w 0xbbbf 0xf96c" \
           -c "truncate 0xbbbf" \
           -c "mmap -r 0xb000 0x11000" \
           -c "mr 0xb000 0x11000" \
           /xfstest.test/foo

with fscaching disabled (otherwise streaming writes are suppressed) and a
change to netfs_perform_write() to disallow streaming writes if the fd is
open O_RDWR:

	if (//(file->f_mode & FMODE_READ) || <--- comment this out
	    netfs_is_cache_enabled(ctx)) {

It should be reproducible even without this change, but if prevents the
above trivial xfs_io command from reproducing it.

Note that the initial dd is important: the file must start out sufficiently
large that the zero-point logic doesn't just clear the gaps because it
knows there's nothing in the file to read yet.  Unmounting and mounting is
needed to clear the pagecache (there are other ways to do that that may
also work).

This was initially reproduced with the generic/522 xfstest on some patches
that remove the FMODE_READ restriction.

Fixes: 9ebff83e6481 ("netfs: Prep to use folio->private for write grouping and streaming write")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/misc.c              | 6 +++++-
 include/trace/events/netfs.h | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 6df89c92b10b..d8e8a4b59768 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -256,6 +256,7 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 			/* Move the start of the data. */
 			finfo->dirty_len = fend - iend;
 			finfo->dirty_offset = offset;
+			trace_netfs_folio(folio, netfs_folio_trace_invalidate_front);
 			return;
 		}
 
@@ -264,12 +265,14 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 		 */
 		if (iend >= fend) {
 			finfo->dirty_len = offset - fstart;
+			trace_netfs_folio(folio, netfs_folio_trace_invalidate_tail);
 			return;
 		}
 
 		/* A partial write was split.  The caller has already zeroed
 		 * it, so just absorb the hole.
 		 */
+		trace_netfs_folio(folio, netfs_folio_trace_invalidate_middle);
 	}
 	return;
 
@@ -277,8 +280,9 @@ void netfs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 	netfs_put_group(netfs_folio_group(folio));
 	folio_detach_private(folio);
 	folio_clear_uptodate(folio);
+	folio_cancel_dirty(folio);
 	kfree(finfo);
-	return;
+	trace_netfs_folio(folio, netfs_folio_trace_invalidate_all);
 }
 EXPORT_SYMBOL(netfs_invalidate_folio);
 
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 8c936fc575d5..0b702f74aefe 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -194,6 +194,10 @@
 	EM(netfs_folio_trace_copy_to_cache,	"mark-copy")	\
 	EM(netfs_folio_trace_end_copy,		"end-copy")	\
 	EM(netfs_folio_trace_filled_gaps,	"filled-gaps")	\
+	EM(netfs_folio_trace_invalidate_all,	"inval-all")	\
+	EM(netfs_folio_trace_invalidate_front,	"inval-front")	\
+	EM(netfs_folio_trace_invalidate_middle,	"inval-mid")	\
+	EM(netfs_folio_trace_invalidate_tail,	"inval-tail")	\
 	EM(netfs_folio_trace_kill,		"kill")		\
 	EM(netfs_folio_trace_kill_cc,		"kill-cc")	\
 	EM(netfs_folio_trace_kill_g,		"kill-g")	\

