Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7178D37C11B
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370483; cv=none; b=j8gzpjuSfnicB/Fj4juY1AQRNkxSnkED1S2vFkDfp4ggMtbDQIRRRMtL+FI5tpfzhUfjkoH2zpguG/1GqhGUbP4kOI41I+Dae/dC2YrEQoRdut+9eANFHzqLzdTpv1kye9eJnPzrSrHFY3Rn61L5PUy9HefVgLgCNnbOi0rieA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370483; c=relaxed/simple;
	bh=8MqDLY1n6o2WtA6Uutu6RqWSVYZn+dztQ0VDPfEmSm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WttK9L3sWAU92HFenaibSlunmhqa2uItPy4oOdEAjE4dj+xaJC2sIKJF1D0PcPJ4lEfNJMceUxlqo7iP6xAcYwcKSd9Ln+tC49UaUuCyZzrS9fuFbUxqc0p/eyeTtlVEFq4T2tbY/DN/EcXSXQcLTGcAj+W7j/UnEmH6YbEA1BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYOAasTS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYOAasTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnfEm+OhRi/45mFVUOgbuCPGW3hJeL3DRZRk8bidxUc=;
	b=NYOAasTSaLDYc0UvbDgSsDzpYa1tPlVoaXSF8/OmC9N2c8o6d5ENo/om2Tz1hYETJpKW6W
	3HlnlTYqlCAp84KJBE7Xscmhc+33lzy2zuc3isghEOaA+SFUuy3qedwb2xrZOQ7e0IuI9L
	HVMpZPgVyfVZM+xE+yiWhdeN1kh5cx8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-133-ErtfLEkNMF-ON6266K0J_A-1; Wed,
 02 Sep 2026 13:34:35 -0400
X-MC-Unique: ErtfLEkNMF-ON6266K0J_A-1
X-Mimecast-MFC-AGG-ID: ErtfLEkNMF-ON6266K0J_A_1788370472
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A272A195C241;
	Wed,  2 Sep 2026 17:34:31 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7AE1718005BA;
	Wed,  2 Sep 2026 17:34:24 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v11 03/36] mm: Add a bulk end-writeback tool
Date: Wed,  2 Sep 2026 18:33:15 +0100
Message-ID: <20260902173350.3468672-4-dhowells@redhat.com>
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
References: <20260902173350.3468672-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add a tool to perform bulk folio_end_writeback() across a series of
contiguous folios.  The function takes a beginning and an end file position
and ends any folio that lies wholly in the range, leaving the end position
of the last folio it considered in the iterator state for the filesystem to
use as a hint for when to call again.

As folio_end_writeback() has to access the xarray to clear the marks set on
the entries for the folios involved, this tool provides the opportunity to
merge the two xarray accesses (the iteration and the unmarking) and also do
statistics update in bulk.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_collect.c  | 51 +++++++++++++++++++++++++++++++++++++++
 include/linux/writeback.h | 10 ++++++++
 mm/page-writeback.c       | 45 ++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 210eb8f3958d..c5b07b3201d7 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -21,6 +21,57 @@
 #define NEED_RETRY		0x10	/* A front op requests retrying */
 #define SAW_FAILURE		0x20	/* One stream or hit a permanent failure */
 
+struct end_writeback_ctrl {
+	struct xa_state xas;
+	uoff_t fend;
+};
+
+/**
+ * end_writeback_iter - End writeback for the folios within the range
+ * @mapping: The pagecache to modify
+ * @from: Pointer to the starting position
+ * @to: The end position (exclusive)
+ * @ctrl: Iterator state
+ * @folio: The last return from this function or NULL if first call
+ *
+ * Remove the writeback mark on folios that are entirely within in the given
+ * range, where @from is included in the range, but @to is excluded from the
+ * range.
+ *
+ * Return: The folio to end writeback upon or NULL if the next folio isn't
+ * wholly within the range.  Note that this does not necessarily imply that the
+ * ending is complete.  @ctrl->fend is updated to point directly beyond the
+ * folio that was considered and may be negative if cast to loff_t.
+ */
+static
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 uoff_t from, uoff_t to,
+				 struct end_writeback_ctrl *ctrl,
+				 struct folio *folio)
+{
+	if (!folio) {
+		lockdep_assert_in_rcu_read_lock();
+		ctrl->xas = (struct xa_state)
+			__XA_STATE(&mapping->i_pages, from / PAGE_SIZE, 0, 0);
+		folio = xas_find(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	} else {
+		folio_end_writeback(folio);
+	retry:
+		folio = xas_next_entry(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	}
+
+	if (xas_retry(&ctrl->xas, folio))
+		goto retry;
+
+	if (!folio)
+		return NULL;
+
+	ctrl->fend = folio_next_pos(folio);
+	if (ctrl->fend > to)
+		folio = NULL;
+	return folio;
+}
+
 static void netfs_dump_request(const struct netfs_io_request *rreq)
 {
 	pr_err("Request R=%08x r=%d fl=%lx or=%x e=%ld\n",
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b749a9a5a5ee..4f34cbc964f6 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -358,6 +358,16 @@ bool wb_over_bg_thresh(struct bdi_writeback *wb);
 struct folio *writeback_iter(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio, int *error);
 
+/* end_writeback_iter() state. */
+struct end_writeback_ctrl {
+	struct xa_state	xas;	/* The xarray walker */
+	uoff_t		fend;	/* The next file pos after the folio last considered. */
+};
+
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 struct end_writeback_ctrl *ctrl,
+				 uoff_t from, uoff_t to, struct folio *folio);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6c9c7ba89b8a..632b0616eceb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2546,6 +2546,51 @@ struct folio *writeback_iter(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(writeback_iter);
 
+/**
+ * end_writeback_iter - End writeback for the folios within the range
+ * @mapping: The pagecache to modify
+ * @ctrl: Iterator state
+ * @from: Pointer to the starting position
+ * @to: The end position (exclusive)
+ * @folio: The last return from this function or NULL if first call
+ *
+ * Remove the writeback mark on folios that are entirely within in the given
+ * range, where @from is included in the range, but @to is excluded from the
+ * range.
+ *
+ * Return: The folio to end writeback upon or NULL if the next folio isn't
+ * wholly within the range.  Note that this does not necessarily imply that the
+ * ending is complete.  @ctrl->fend is updated to point directly beyond the
+ * folio that was considered and may be negative if cast to loff_t.
+ */
+struct folio *end_writeback_iter(struct address_space *mapping,
+				 struct end_writeback_ctrl *ctrl,
+				 uoff_t from, uoff_t to, struct folio *folio)
+{
+	if (!folio) {
+		lockdep_assert_in_rcu_read_lock();
+		ctrl->xas = (struct xa_state)
+			__XA_STATE(&mapping->i_pages, from / PAGE_SIZE, 0, 0);
+		folio = xas_find(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	} else {
+		folio_end_writeback(folio);
+	retry:
+		folio = xas_next_entry(&ctrl->xas, (to - 1) / PAGE_SIZE);
+	}
+
+	if (xas_retry(&ctrl->xas, folio))
+		goto retry;
+
+	if (!folio)
+		return NULL;
+
+	ctrl->fend = folio_next_pos(folio);
+	if (ctrl->fend > to)
+		folio = NULL;
+	return folio;
+}
+EXPORT_SYMBOL_GPL(end_writeback_iter);
+
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;

