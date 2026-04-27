Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DD834AAE3
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303843; cv=none; b=DpnaY3ne/4k/BKu6R/bGuc+mdqHc2gZBIJdgJtIg/EPbzKnvnBcsvjQxUJ5omXPlorM7R24mK6GdJFdkHpG7JwOmJrq7/bSSTuphFWZYAWI4LZCKM3HMPQASjPn4rTmOolZEHvoPP2+3xcxGJvL1t6CbfOaZ/OEsgX6aUdOMonY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303843; c=relaxed/simple;
	bh=o05Io1xRtBayWGYR2oc3Xg7A3FtUEcWOi0kE+EBlUgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2Z2gBNee+OZKdWUeyZLQWUZaumYO66S2N8T9P74utolgEPH48YKjD/g03YzIemC7SX4FwONhDV+CNjIdGXRZYDfXmfZ6Tm6kWsQ0SQ5do3F2sAi3k4XMDJz1qAe5EnbwVtjcCmv416gVtG2sevrsTDXMFbh7Ae47Wfp5AJTElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TtibyKQa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TtibyKQa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777303840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47TW6xAuGaXgyo+FT4sWhE5OZ+F3gm9XYQOGltuTIYQ=;
	b=TtibyKQacpyqnurVak8k+SJ2yvToKr/eBg29DVfO7RFAPvFgnYe+IEqE5yspyNplyTegEq
	ylycGDvXxMhqjj7IEPPOV+ChVRkq4Xw9D/5Z+LObce19RX1zkB16kVcyyfdcUkeJxD4F6r
	BI1hrRcEh/CAk7eaKo/UkS/rA7SvRTU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-fGjFsSZnM_6IA_Ug3IaImg-1; Mon,
 27 Apr 2026 11:30:35 -0400
X-MC-Unique: fGjFsSZnM_6IA_Ug3IaImg-1
X-Mimecast-MFC-AGG-ID: fGjFsSZnM_6IA_Ug3IaImg_1777303830
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9ADD31800464;
	Mon, 27 Apr 2026 15:30:30 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C698A19560AB;
	Mon, 27 Apr 2026 15:30:26 +0000 (UTC)
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
Subject: [PATCH v4 06/22] netfs: Fix zeropoint update where i_size > remote_i_size
Date: Mon, 27 Apr 2026 16:29:33 +0100
Message-ID: <20260427152953.180038-7-dhowells@redhat.com>
In-Reply-To: <20260427152953.180038-1-dhowells@redhat.com>
References: <20260427152953.180038-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix the update of the zero point[*] by netfs_release_folio() when there is
uncommitted data in the pagecache beyond the folio being released but the
on-server EOF is in this folio (ie. i_size > remote_i_size).  The update
needs to limit zero_point to remote_i_size, not i_size as i_size is a local
phenomenon reflecting updates made locally to the pagecache, not stuff
written to the server.  remote_i_size tracks the server's i_size.

[*] The zero point is the file position from which we can assume that the
    server will just return zeros, so we can avoid generating reads.

Note that netfs_invalidate_folio() probably doesn't need fixing as
zero_point should be updated by setattr after truncation or fallocate.

Found with:

    fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
        /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

    truncate 0x0 0x1bbae 0x82864
    write 0x3ef2e 0xf9c8 0x1bbae
    write 0x67e05 0xcb5a 0x4e8f6
    mapread 0x57781 0x85b6 0x7495f
    copy_range 0x5d3d 0x10329 0x54fac 0x7495f
    write 0x64710 0x1c2b 0x7495f
    mapread 0x64000 0x1000 0x7495f

on cifs with the default cache option.

It shows read-gaps on folio 0x64 failing with a short read (ie. it hits
EOF) if the FMODE_READ check is commented out in netfs_perform_write():

                if (//(file->f_mode & FMODE_READ) ||
                    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/misc.c       |  4 ++--
 include/linux/netfs.h | 35 +++++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 9d92d068f1da..37d9651078e6 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -299,9 +299,9 @@ bool netfs_release_folio(struct folio *folio, gfp_t gfp)
 		return false;
 
 	netfs_read_sizes(ctx, &i_size, &remote_i_size, &zero_point);
-	end = umin(folio_next_pos(folio), i_size);
+	end = folio_next_pos(folio);
 	if (end > zero_point)
-		netfs_write_zero_point(ctx, end);
+		netfs_push_back_zero_point(ctx, umin(end, remote_i_size));
 
 	if (folio_test_private(folio))
 		return false;
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 90e061e444ce..59f35d2eeb2e 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -530,11 +530,11 @@ static inline void netfs_write_remote_i_size(struct netfs_inode *ictx,
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	struct inode *inode = &ictx->inode;
 
-	preempt_disable();
+	spin_lock(&inode->i_lock);
 	write_seqcount_begin(&inode->i_size_seqcount);
 	ictx->_remote_i_size = remote_i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
-	preempt_enable();
+	spin_unlock(&inode->i_lock);
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
 	preempt_disable();
 	ictx->_remote_i_size = remote_i_size;
@@ -605,11 +605,11 @@ static inline void netfs_write_zero_point(struct netfs_inode *ictx,
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	struct inode *inode = &ictx->inode;
 
-	preempt_disable();
+	spin_lock(&inode->i_lock);
 	write_seqcount_begin(&inode->i_size_seqcount);
 	ictx->_zero_point = zero_point;
 	write_seqcount_end(&inode->i_size_seqcount);
-	preempt_enable();
+	spin_unlock(&inode->i_lock);
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
 	preempt_disable();
 	ictx->_zero_point = zero_point;
@@ -635,8 +635,27 @@ static inline void netfs_write_zero_point(struct netfs_inode *ictx,
 static inline void netfs_push_back_zero_point(struct netfs_inode *ictx,
 					      unsigned long long to)
 {
-	if (to > netfs_read_zero_point(ictx))
-		netfs_write_zero_point(ictx, to);
+#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	struct inode *inode = &ictx->inode;
+
+	spin_lock(&inode->i_lock);
+	write_seqcount_begin(&inode->i_size_seqcount);
+	if (to > ictx->_zero_point)
+		ictx->_zero_point = to;
+	write_seqcount_end(&inode->i_size_seqcount);
+	spin_unlock(&inode->i_lock);
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
+	preempt_disable();
+	if (to > ictx->_zero_point)
+		ictx->_zero_point = to;
+	preempt_enable();
+#else
+	unsigned long long old = ictx->_zero_point;
+
+	while (to > old) {
+		old = cmpxchg_release(&ictx->_zero_point, old, to);
+	}
+#endif
 }
 
 /**
@@ -709,12 +728,12 @@ static inline void netfs_write_sizes(struct netfs_inode *ictx,
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	struct inode *inode = &ictx->inode;
 
-	preempt_disable();
+	spin_lock(&inode->i_lock);
 	write_seqcount_begin(&inode->i_size_seqcount);
 	ictx->_remote_i_size = remote_i_size;
 	ictx->_zero_point = zero_point;
 	write_seqcount_end(&inode->i_size_seqcount);
-	preempt_enable();
+	spin_unlock(&inode->i_lock);
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
 	preempt_disable();
 	ictx->_remote_i_size = remote_i_size;

