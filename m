Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9981534EC
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jul 2024 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722270056; cv=none; b=N+JS82sHjl2agr6Xrw8xtwt/qT7JqoCKuVF5fbJuaFXKERoA/3jOZC/SudOay8JwuDYUJ/S3tS5KfzGggzYyoxQumUnUCeWtAV06UpRYPFX1Lp0trvQHw4Eb2/UBpKqva4kduEkfLQJ8jj2R6Lm+sP+7Ubpi9eTtbiDJPCURdN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722270056; c=relaxed/simple;
	bh=Q4gwfJJHtF30kFPtvejKeAQF831UgJF7V7gJtMLCh9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i93zGB5u54ZrKZX1TnhQaoNNWjtfX+tK0IcQRigWejh9kmI2iggjf08XiG/2uEi0SBeymQWt7VymlLMRV7K31nr/SSkyrdqkVGhskhp3posRqd4oqw9JTngbqD/P2AVdOwNTUEexBNz7SsgEQU2/M5PEo7dKipm0Y31H4wMZ26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VESzchOo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VESzchOo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722270054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/oVpDumRjUlX+aosidOXdQbOjRrDxev6yeZ4FfFDPg=;
	b=VESzchOoU7xgS5wS2iDeleEPgIVstiYYBSoNRQObVNK0SC3S2sLncLlUx8gr00rQvQf3YX
	MIR9aov8dDhRtuRiHemrfSj0OaYXY/JSM4l0XEPD5iaffPmpKedNNUjmEn/BcFvBsAW4G0
	wvXyN+2lVT4mhZdzGn6y/JrQHUClpIg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-WgW1m07KO_iavDTjj_y9Sw-1; Mon,
 29 Jul 2024 12:20:49 -0400
X-MC-Unique: WgW1m07KO_iavDTjj_y9Sw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73DCC1955D4C;
	Mon, 29 Jul 2024 16:20:45 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.216])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7174519560AE;
	Mon, 29 Jul 2024 16:20:39 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>
Subject: [PATCH 04/24] netfs: Record contention stats for writeback lock
Date: Mon, 29 Jul 2024 17:19:33 +0100
Message-ID: <20240729162002.3436763-5-dhowells@redhat.com>
In-Reply-To: <20240729162002.3436763-1-dhowells@redhat.com>
References: <20240729162002.3436763-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Record statistics for contention upon the writeback serialisation lock that
prevents racing writeback calls from causing each other to interleave their
writebacks.  These can be viewed in /proc/fs/netfs/stats on the WbLock line,
with skip=N indicating the number of non-SYNC writebacks skipped and wait=N
indicating the number of SYNC writebacks that waited.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/internal.h    |  2 ++
 fs/netfs/stats.c       |  5 +++++
 fs/netfs/write_issue.c | 10 +++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 7773f3d855a9..9e6e0e59d7e4 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -117,6 +117,8 @@ extern atomic_t netfs_n_wh_upload_failed;
 extern atomic_t netfs_n_wh_write;
 extern atomic_t netfs_n_wh_write_done;
 extern atomic_t netfs_n_wh_write_failed;
+extern atomic_t netfs_n_wb_lock_skip;
+extern atomic_t netfs_n_wb_lock_wait;
 
 int netfs_stats_show(struct seq_file *m, void *v);
 
diff --git a/fs/netfs/stats.c b/fs/netfs/stats.c
index 95ed2d2623a8..5fe1c396e24f 100644
--- a/fs/netfs/stats.c
+++ b/fs/netfs/stats.c
@@ -39,6 +39,8 @@ atomic_t netfs_n_wh_upload_failed;
 atomic_t netfs_n_wh_write;
 atomic_t netfs_n_wh_write_done;
 atomic_t netfs_n_wh_write_failed;
+atomic_t netfs_n_wb_lock_skip;
+atomic_t netfs_n_wb_lock_wait;
 
 int netfs_stats_show(struct seq_file *m, void *v)
 {
@@ -78,6 +80,9 @@ int netfs_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&netfs_n_rh_rreq),
 		   atomic_read(&netfs_n_rh_sreq),
 		   atomic_read(&netfs_n_wh_wstream_conflict));
+	seq_printf(m, "WbLock : skip=%u wait=%u\n",
+		   atomic_read(&netfs_n_wb_lock_skip),
+		   atomic_read(&netfs_n_wb_lock_wait));
 	return fscache_stats_show(m);
 }
 EXPORT_SYMBOL(netfs_stats_show);
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 9258d30cffe3..e7d4f39b8fdc 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -503,10 +503,14 @@ int netfs_writepages(struct address_space *mapping,
 	struct folio *folio;
 	int error = 0;
 
-	if (wbc->sync_mode == WB_SYNC_ALL)
+	if (!mutex_trylock(&ictx->wb_lock)) {
+		if (wbc->sync_mode == WB_SYNC_NONE) {
+			netfs_stat(&netfs_n_wb_lock_skip);
+			return 0;
+		}
+		netfs_stat(&netfs_n_wb_lock_wait);
 		mutex_lock(&ictx->wb_lock);
-	else if (!mutex_trylock(&ictx->wb_lock))
-		return 0;
+	}
 
 	/* Need the first folio to be able to set up the op. */
 	folio = writeback_iter(mapping, wbc, NULL, &error);

