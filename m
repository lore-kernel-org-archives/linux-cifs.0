Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8157D199928
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 20:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724443732; cv=none; b=G7TCuVj6Hug8vuD/5V/0hBR1bhMoglj/Jlc0LXqlqqLUiojVlAKkLtIAbqpS2fc86fhx/HycCwx1xePMZRDK6bMKoDYnmcYe2ED9bcGOdDAZ5ZFFTQ7ORMlbX7jwBv2cqNM9z8EFicq2hTcZJgSgBPhKR9BmEQONlsFVdgbY0qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724443732; c=relaxed/simple;
	bh=g8vGiYgfUHHfeHz8oFJMF7SqHkz4KAmGdS17s4e9lUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb7ZG5mf+2YnRRcIrF78iPI2MLaDNTZySDpKjymPwC+Hsan08aCKH5OVIi6wkoHb3h+IGd6S5TCJPeabd3+Wpwufh9+6F1Pz3O0zUO1FOLiDNws3MyS6QLKiIQpmv8atvq1/3/ejc6QyGwc6WN3TaAq2TC+AMYXBxJj2ZUBKYtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N440LJsG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N440LJsG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724443729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LLNXobqu9Lr51n4CzgcItZvbbRppxWdYVF89daxGYJk=;
	b=N440LJsGGOY/B2U51BAAmYfpFknVsyB5eK+wBVN0rwORqx3SLRefS4Cpvl173FcwPTElHG
	nZdW5Chy5M74mxR9XOVQXOYYFPxwGC4w2ucpgg8b98wCJl6n87dFPUou9Rk6c6+oU1nZuI
	xTtfVSTK7vTmk1IOAhbNldZy49KwHp8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-xMba_EeYPL-FTD2gDob40w-1; Fri,
 23 Aug 2024 16:08:44 -0400
X-MC-Unique: xMba_EeYPL-FTD2gDob40w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96CB019560AD;
	Fri, 23 Aug 2024 20:08:40 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DE7901955E8C;
	Fri, 23 Aug 2024 20:08:35 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Paulo Alcantara <pc@manguebit.com>,
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
	Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH 2/9] afs: Fix post-setattr file edit to do truncation correctly
Date: Fri, 23 Aug 2024 21:08:10 +0100
Message-ID: <20240823200819.532106-3-dhowells@redhat.com>
In-Reply-To: <20240823200819.532106-1-dhowells@redhat.com>
References: <20240823200819.532106-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

At the end of an kAFS RPC operation, there is an "edit" phase (originally
intended for post-directory modification ops to edit the local image) that
the setattr VFS op uses to fix up the pagecache if the RPC that requested
truncation of a file was successful.

afs_setattr_edit_file() calls truncate_setsize() which sets i_size, expands
the pagecache if needed and truncates the pagecache.  The first two of
those, however, are redundant as they've already been done by
afs_setattr_success() under the io_lock and the first is also done under
the callback lock (cb_lock).

Fix afs_setattr_edit_file() to call truncate_pagecache() instead (which is
called by truncate_setsize(), thereby skipping the redundant parts.

Fixes: 100ccd18bb41 ("netfs: Optimise away reads above the point at which there can be no data")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Wilcox (Oracle) <willy@infradead.org>
cc: Pankaj Raghav <p.raghav@samsung.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 3acf5e050072..a95e77670b49 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -695,13 +695,18 @@ static void afs_setattr_edit_file(struct afs_operation *op)
 {
 	struct afs_vnode_param *vp = &op->file[0];
 	struct afs_vnode *vnode = vp->vnode;
+	struct inode *inode = &vnode->netfs.inode;
 
 	if (op->setattr.attr->ia_valid & ATTR_SIZE) {
 		loff_t size = op->setattr.attr->ia_size;
-		loff_t i_size = op->setattr.old_i_size;
+		loff_t old = op->setattr.old_i_size;
+
+		/* Note: inode->i_size was updated by afs_apply_status() inside
+		 * the I/O and callback locks.
+		 */
 
-		if (size != i_size) {
-			truncate_setsize(&vnode->netfs.inode, size);
+		if (size != old) {
+			truncate_pagecache(inode, size);
 			netfs_resize_file(&vnode->netfs, size, true);
 			fscache_resize_cookie(afs_vnode_cache(vnode), size);
 		}

