Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1348124C
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382403; cv=none; b=h/Y2Mkvsatlrnh8cezSgXEvVW+kidbYMNLAq5RTd92cvPeAoAX+iVevnygTFMl2KDP1jb9Ob/u2y3Ii+GejUcsdbzmyLey1DjIO9tHcrOs26U/qt2AtfTXVda0RSdIypqtWXNtGANHwXM+jNeXiQqbB6z6THrMF/tZwmbChhxd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382403; c=relaxed/simple;
	bh=J8QawrkDmZnEn3V+onuYqCDz4wNl7JY0T6BmQPWssTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDKAmrIGVxreF1+d5RUVArN2o+JUcUigrZynIwnS7QcK9riow3VO6G6GNQv6ixLq3X2LfEaL9hfiqPvL3O4A6Piy0315l+WPwnnh9hviXYw2LnmX29h+oENTnm6/bjO/km23Xm19Lqo+f0teg/pPQOhhbZ+YciIddLOkpFIjWQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4ChkRUy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4ChkRUy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777382401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zlc+rWHho9Uqkbw6bMnekEiU8RB1DEnYBoY4FdYh6bg=;
	b=N4ChkRUyzklS2+bQiXzrzojuc54TeQxbPyossdmGAjdLn+xB32mClh8PdGCOHeTO6QWNAv
	mExeo15yHc/YiLC63NAGmx5nBZBPuStfUbISeatDLFKsiR/zyrT6MeI/rkZN/qdz1KQx4Y
	b1OLyV9hXU8nDsIxNzZxv53MqDW9ufQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-_13Brou9PSerEUX30fng9w-1; Tue,
 28 Apr 2026 09:19:58 -0400
X-MC-Unique: _13Brou9PSerEUX30fng9w-1
X-Mimecast-MFC-AGG-ID: _13Brou9PSerEUX30fng9w_1777382396
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9987418C1054;
	Tue, 28 Apr 2026 13:19:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.126])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7933195608E;
	Tue, 28 Apr 2026 13:19:12 +0000 (UTC)
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
Subject: [PATCH v5 15/24] netfs: Fix read-gaps to remove netfs_folio from filled folio
Date: Tue, 28 Apr 2026 14:17:45 +0100
Message-ID: <20260428131756.922303-16-dhowells@redhat.com>
In-Reply-To: <20260428131756.922303-1-dhowells@redhat.com>
References: <20260428131756.922303-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_read_gaps() to remove the netfs_folio record from the folio
record before marking the folio uptodate if it successfully fills the gaps
around the dirty data in a streaming write folio (dirty, but not uptodate).

Found with:

    fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
        /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

    truncate 0x0 0x138b1 0x8b15d *
    write 0x507ee 0x10df7 0x927c0
    write 0x19993 0x10e04 0x927c0 *
    mapwrite 0x66214 0x1a253 0x927c0
    copy_range 0xb704 0x89b9 0x24429 0x79380
    write 0x2402b 0x144a2 0x90660 *
    mapwrite 0x204d5 0x140a0 0x927c0 *
    copy_range 0x1f72c 0x137d0 0x7a906 0x927c0 *
    read 0 0x9157c 0x9157c

on cifs with the default cache option.

It shows folio 0x24 misbehaving if the FMODE_READ check is commented out in
netfs_perform_write():

                if (//(file->f_mode & FMODE_READ) ||
                    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
---
 fs/netfs/buffered_read.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index c0fe6dc40d87..c0a7f9e60f0c 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -395,6 +395,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 {
 	struct netfs_io_request *rreq;
 	struct address_space *mapping = folio->mapping;
+	struct netfs_group *group = netfs_folio_group(folio);
 	struct netfs_folio *finfo = netfs_folio_info(folio);
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	struct folio *sink = NULL;
@@ -461,6 +462,12 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
+		if (group)
+			folio_change_private(folio, group);
+		else
+			folio_detach_private(folio);
+		kfree(finfo);
+		trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}
@@ -496,10 +503,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
-	if (folio_test_dirty(folio)) {
-		trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
+	if (folio_test_dirty(folio))
 		return netfs_read_gaps(file, folio);
-	}
 
 	_enter("%lx", folio->index);
 

