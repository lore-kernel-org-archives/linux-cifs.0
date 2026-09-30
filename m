Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D7C515964;
	Wed, 30 Sep 2026 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787087; cv=none; b=NmcY0Ibj/QjUVNDgI0Ua0siy25rEYqn6FhzkEOETtOCsktMN2JceAn7DZOYuswEkL0OI3w2AKKefbCR0mKutxr4b6bb4MS5ZcfQn9MaQTLokcFLjZAj7sFa+0KGHWANFB0JGHKXnDfXzi7bjx2LWrPYLmdZXZcqs1VTRs9QIowM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787087; c=relaxed/simple;
	bh=BqZkI4oh23gmoVjQp26DQlBZQfuDCO0zzrH+vQvqSzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKWNZNblSk6onOotbHer37QIlcjD51whwZp1Gq1eShC5iLOfKqJtsA0mN70Dkqndm/0vg5t1o+Z2wBBeIiBhJInLeBuW2FzhxCiwAwevmBZiHOucFxbRsAkW+AXshdKokyG99jQLTjlP5YahkXKJALF1u+xodDR6FQIoP22dpnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=at4XwyrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="at4XwyrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CBD1F008A4;
	Wed, 30 Sep 2026 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787086;
	bh=lBjDVKGZ6H+iJUidgdv6YOaS5uWwO6vYv58wACrZyCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=at4XwyrRwGZD0wqwro3tRVqVT9ru+xJpyF8gNhHRA4ttFRJ607jkBgifkhkJricxp
	 s3gBqkoF9jYnp+2LyV9RaDTrW+40rocnfMHYOWmzsoiM3wmtnyIELNabebN7N7FCvy
	 bbdXi+iVaySPKWOqF/563BMvNyRWrAs2pDe7RkzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 063/457] netfs: Fix netfs_read_gaps() to use separate sink folios
Date: Wed, 30 Sep 2026 17:22:48 +0200
Message-ID: <20260930152347.399092552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit fc3ae66514ca5e87251f79044236e3e8babd24a3 ]

Fix netfs_read_gaps() to use separate folios rather than re-using a single
sink folio to discard the unwanted data so that cifs checksum checking sees
all the data that was fetched.

Fixes: 7f84a7b9892d ("netfs: Make netfs_read_folio() handle streaming-write pages")
Reported-by: Frank Sorenson <sorenson@redhat.com>
Closes: https://lore.kernel.org/r/a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/3228134.1789399227@warthog.procyon.org.uk
Tested-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Paulo Alcantara <pc@manguebit.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Namjae Jeon <linkinjeon@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 424df70a5c30f..105194de6e13e 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -482,15 +482,14 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	struct netfs_group *group = netfs_folio_group(folio);
 	struct netfs_folio *finfo = netfs_folio_info(folio);
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
-	struct folio *sink = NULL;
-	struct bio_vec *bvec;
+	struct bio_vec *bvec = NULL;
 	unsigned int from = finfo->dirty_offset;
 	unsigned int to = from + finfo->dirty_len;
-	unsigned int off = 0, i = 0;
+	unsigned int off = 0;
 	size_t flen = folio_size(folio);
 	size_t nr_bvec = flen / PAGE_SIZE + 2;
 	size_t part;
-	int ret;
+	int ret, i = 0, sink_from = -1, sink_to = -1;
 
 	_enter("%lx", folio->index);
 
@@ -515,24 +514,23 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	if (!bvec)
 		goto discard;
 
-	sink = folio_alloc(GFP_KERNEL, 0);
-	if (!sink) {
-		kfree(bvec);
-		goto discard;
-	}
-
 	trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
 
-	rreq->direct_bv = bvec;
-	rreq->direct_bv_count = nr_bvec;
 	if (from > 0) {
 		bvec_set_folio(&bvec[i++], folio, from, 0);
 		off = from;
 	}
+	sink_from = i;
 	while (off < to) {
+		struct folio *sink = folio_alloc(GFP_KERNEL, 0);
+
+		if (!sink)
+			goto discard;
 		part = min_t(size_t, to - off, PAGE_SIZE);
-		bvec_set_folio(&bvec[i++], sink, part, 0);
+		bvec_set_folio(&bvec[i], sink, part, 0);
 		off += part;
+		sink_to = i;
+		i++;
 	}
 	if (to < flen)
 		bvec_set_folio(&bvec[i++], folio, flen - to, to);
@@ -553,8 +551,10 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 		folio_mark_uptodate(folio);
 	}
 
-	if (sink)
-		folio_put(sink);
+	if (sink_to >= 0)
+		for (; sink_from <= sink_to; sink_from++)
+			folio_put(bvec_folio(&bvec[sink_from]));
+	kfree(bvec);
 	folio_unlock(folio);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
@@ -563,6 +563,10 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 	netfs_put_failed_request(rreq);
 alloc_error:
 	folio_unlock(folio);
+	if (sink_to >= 0)
+		for (; sink_from <= sink_to; sink_from++)
+			folio_put(bvec_folio(&bvec[sink_from]));
+	kfree(bvec);
 	return ret;
 }
 
-- 
2.53.0



