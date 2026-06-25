Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897AC2E040D
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396437; cv=none; b=Ag2NX+8LrbsEDA05zNMZ4n0q9UFt9D1z5MRoqpFIqOagamIaJPTn9CEZJvuCxod8QCb5PCcSYGIcTcH+4tkD1iWG/t5pjXNfIfZbPsKUlGUc2GYgOKx5htuwLJzriVmgVsjkWqR/ZoN3pKHlMtZHn66sUnBHIfunSlI9An3pn7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396437; c=relaxed/simple;
	bh=/eMp+WImKJH9LzmD/3lNc54QT+Yi3S0Sw6GyYiwY1Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+EIEL8jON2lWMc7VEtZk9Yn3hJoZ6wZlHBOP6R62EbUSwEEu8mrnDD7Ly/uVlcUZNCWdTkmU+uX8JZu6srQDuAJ+m8SOA8NYpX6i/XTjOn7satoSnPdkLFTWV86dwUSEVgHJTkOcTqvDRjgs0Ky2qMEIYpAUz6ADjSYim6bnec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KxkTGiw8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KxkTGiw8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2m325Nx+i8DIrEF7y0AraLoEtm5viE2NtVsSnCJNNQA=;
	b=KxkTGiw8Vxxrs98rvqzZzF/aOUpSvaWTWEtDo9bJzbiB00nxOvm91AQV+FlUZrqeDV1E42
	Vue1DFYTUzsFfYiLLbJlVvW/Evu/88trMPgg17rOXlsKxafqzBcRYyyXS7e/2vfEd/V+mH
	BLHquMBBXh3hF7dwOwjMUnm+vJrJVDs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-zCJMXNQDNpWQhZEmFmPgFg-1; Thu,
 25 Jun 2026 10:07:09 -0400
X-MC-Unique: zCJMXNQDNpWQhZEmFmPgFg-1
X-Mimecast-MFC-AGG-ID: zCJMXNQDNpWQhZEmFmPgFg_1782396426
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFDC4180AC7E;
	Thu, 25 Jun 2026 14:07:05 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF9661800370;
	Thu, 25 Jun 2026 14:07:02 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Christoph Hellwig <hch@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/15] netfs: Fix netfs_create_write_req() to handle async cache object creation
Date: Thu, 25 Jun 2026 15:06:20 +0100
Message-ID: <20260625140640.3116900-3-dhowells@redhat.com>
In-Reply-To: <20260625140640.3116900-1-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

netfs_create_write_req() will skip caching if the fscache cookie is
disabled, but this is a problem because async cache object creation might
not have got far enough yet that has been enabled - thereby causing the
call to fscache_begin_write_operation() to be skipped.

Fix this by removing the checks on the cookie and delegating this to
fscache_begin_write_operation().

Fixes: 7b589a9b45ae ("netfs: Fix handling of USE_PGPRIV2 and WRITE_TO_CACHE flags")
Closes: https://sashiko.dev/#/patchset/20260624115737.2964520-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index c03c7cc45e47..4f55228f0fd4 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -106,7 +106,7 @@ struct netfs_io_request *netfs_create_write_req(struct address_space *mapping,
 	_enter("R=%x", wreq->debug_id);
 
 	ictx = netfs_inode(wreq->inode);
-	if (is_cacheable && netfs_is_cache_enabled(ictx))
+	if (is_cacheable)
 		fscache_begin_write_operation(&wreq->cache_resources, netfs_i_cookie(ictx));
 	if (rolling_buffer_init(&wreq->buffer, wreq->debug_id, ITER_SOURCE) < 0)
 		goto nomem;

