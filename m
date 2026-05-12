Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B70D306762
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589278; cv=none; b=Pvu8Ux1DZqeYvhRIvaAFcd9xqidbWa60LuAX4kEr5QDf/TyH+RCYSDImnV0JKbQ+qD2JoEaO1TFKaZ47kC56wiwxUe4fvDVkptOIoECcuwcUPmzi5m5OhAtW9xSQ63GbjvOZdlKS6kY5+u8JBiSUToFuuNJmRpLlCvqJZJ4xZP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589278; c=relaxed/simple;
	bh=xKMwK6XyTR2S1NYi1ll51KBolxqfDxdt7e/1pyWESn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPlEWnoT3Vwre9zkYTVnjfarAmrBD9c3RcDxJsFmQ+ppV3YPVC8h7Dm2cexHYvye9Db2Nklvx891oiTYQ+Hx46fBKvTtpEo/9bx5XqCWKFE7Yd22Ds8vINxBvj1t68RLda9Wl7mspGhMr/zZNQKH0MzgVhERUDH/5CfV2jDtAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ESDwvOU9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ESDwvOU9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9C1Tq0bWPjxQKHy18dUxRo+Gdg144k5WV4DnkH5buY=;
	b=ESDwvOU9H30pCG26xCkdugXSC2NuEzMpQ3Gy1FjknwXEuJ60/wJCTV4cNA4en+SFFLKln/
	r+cU6DF0wct7P3WgJvyKplWjjUf4LeNXTvPkpytVLYnYyUlnAoLvAnf/n64zXjvQvYSzzq
	tGultgAj02XgepFvoOvK5Inl4eeHcyY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-bwxtmLZrM4-IwKg61xVfcA-1; Tue,
 12 May 2026 08:34:22 -0400
X-MC-Unique: bwxtmLZrM4-IwKg61xVfcA-1
X-Mimecast-MFC-AGG-ID: bwxtmLZrM4-IwKg61xVfcA_1778589261
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7C5A19560B1;
	Tue, 12 May 2026 12:34:20 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 906F21944B0C;
	Tue, 12 May 2026 12:34:17 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/24] netfs: Fix missing locking around retry adding new subreqs
Date: Tue, 12 May 2026 13:33:39 +0100
Message-ID: <20260512123404.719402-3-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_retry_read_subrequests() and netfs_retry_write_stream() to take
the appropriate lock when adding extra subrequests into
stream->subrequests.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Closes: https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_retry.c  | 6 +++++-
 fs/netfs/write_retry.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index cca9ac43c077..5ec548b996d6 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -175,7 +175,9 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 			list_for_each_entry_safe_from(subreq, tmp,
 						      &stream->subrequests, rreq_link) {
 				trace_netfs_sreq(subreq, netfs_sreq_trace_superfluous);
+				spin_lock(&rreq->lock);
 				list_del(&subreq->rreq_link);
+				spin_unlock(&rreq->lock);
 				netfs_put_subrequest(subreq, netfs_sreq_trace_put_done);
 				if (subreq == to)
 					break;
@@ -203,8 +205,10 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 					     refcount_read(&subreq->ref),
 					     netfs_sreq_trace_new);
 
+			spin_lock(&rreq->lock);
 			list_add(&subreq->rreq_link, &to->rreq_link);
-			to = list_next_entry(to, rreq_link);
+			spin_unlock(&rreq->lock);
+			to = subreq;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			stream->sreq_max_len	= umin(len, rreq->rsize);
diff --git a/fs/netfs/write_retry.c b/fs/netfs/write_retry.c
index 29489a23a220..32735abfa03f 100644
--- a/fs/netfs/write_retry.c
+++ b/fs/netfs/write_retry.c
@@ -130,7 +130,9 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 			list_for_each_entry_safe_from(subreq, tmp,
 						      &stream->subrequests, rreq_link) {
 				trace_netfs_sreq(subreq, netfs_sreq_trace_discard);
+				spin_lock(&wreq->lock);
 				list_del(&subreq->rreq_link);
+				spin_unlock(&wreq->lock);
 				netfs_put_subrequest(subreq, netfs_sreq_trace_put_done);
 				if (subreq == to)
 					break;
@@ -153,8 +155,10 @@ static void netfs_retry_write_stream(struct netfs_io_request *wreq,
 					     netfs_sreq_trace_new);
 			trace_netfs_sreq(subreq, netfs_sreq_trace_split);
 
+			spin_lock(&wreq->lock);
 			list_add(&subreq->rreq_link, &to->rreq_link);
-			to = list_next_entry(to, rreq_link);
+			spin_unlock(&wreq->lock);
+			to = subreq;
 			trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
 
 			stream->sreq_max_len	= len;

