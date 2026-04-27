Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702E534F255
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303856; cv=none; b=ULRGKwDNSIaXpxyOZUtPzrfL41BjCYmhwhpt757YEEklaS6M0MkM73wqvA5c8mCtLB2F7QyMlaASVijNi6gicmnSpjxphGVcEwO+Fq+3EBxtZJJfNPeD8ck0M8CDYfzS5LMQtp4ghqIx60cBgvGMNOedoe2AyOSPExwrG7XNJWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303856; c=relaxed/simple;
	bh=VrBMZhmWiHPaD8tO+9hsAivp0KvomApYCwcuJnCGxUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoF0b6VmeS0ZuW+G6eWswKNmxOIQ/vKhbKU2kzojSPRy1/hzJDLeCon14QJRkHdiREKAIHEaBhRu8Zk2IkgIGK0egV40f/lo/gR5LGi1I3+6ZWouycsMaknUJfCgF5gjM6CbkL5TLuXhc6pyXEz2vMSu+zC+Of3YGCTEIgubJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eMrTuxzG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eMrTuxzG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777303854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xJlXFm6gho8MPz3RsbSXNfFwZ2mKHUMmXSQpBOBJ+wU=;
	b=eMrTuxzGkPnuwT8Nhoex9pIVyoXDi7ufG+Gbd0Vrlfh0AR7CqeO5X/1YxcxHOx4kudEeyi
	7eJXssvDFXQlXoJBHX+oqXPlyaYx+c7F99hcdeXZU5Xq1CS46izEatnSn/rDvd3Qt6gEJg
	XxuLsRXVxdJ961cjmRT7iYELn7YsSGs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-I7iT7UYXMKaqiWSCxLJ2dQ-1; Mon,
 27 Apr 2026 11:30:49 -0400
X-MC-Unique: I7iT7UYXMKaqiWSCxLJ2dQ-1
X-Mimecast-MFC-AGG-ID: I7iT7UYXMKaqiWSCxLJ2dQ_1777303845
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47F5C18001D6;
	Mon, 27 Apr 2026 15:30:45 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A5EA5180047F;
	Mon, 27 Apr 2026 15:30:41 +0000 (UTC)
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
Subject: [PATCH v4 09/22] netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes gone
Date: Mon, 27 Apr 2026 16:29:36 +0100
Message-ID: <20260427152953.180038-10-dhowells@redhat.com>
In-Reply-To: <20260427152953.180038-1-dhowells@redhat.com>
References: <20260427152953.180038-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
index 37d9651078e6..4e91a8d75bce 100644
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

