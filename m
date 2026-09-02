Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBB24A8A35
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370694; cv=none; b=pT7bkVxR5gM6Vjyaqd+wbuqqConZl3SpvqbvVtg8FvvOtrXT0TnPNJlJe8z6b3nP8OgMa1H8cOsakp3peSCNYVAkL5bWWEuNKiEQ17HSuIwoYTmBY5qHTrkF96cbNbh3g+FM/nfVh90gutjlYoxXsXwIhdysNDRcCr5F8LaKSes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370694; c=relaxed/simple;
	bh=ehdJ46KUuu6vgydNc7aTnfx0kdluipRSzyFBLRqutIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWB3B/AbpkIOk6g0mIhLsGAYtJKMGUNA3H2hpzp0mkbywNhwD9EIq5MlKReJCwCzwZMC+DEEOu+F8T8J52XzAUiGb8VVlMm/7IWv3qQtBAByfwmLD6GJV2FE17BmRctyxyqx6y457r6ipdGJmbHO7U/Bgu6WWWmaDVTMsY42V+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DxaJirIh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxaJirIh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788370691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FuK4SHGkgyeyAMFNuAIR9NMGMpbuILYiN5I+Qlu1IU8=;
	b=DxaJirIhpVDtRHGXDkoEk49Zg+KaVq6qJGwwmMdY2pky3u9Qdi8/WkGO3Afpaeb1UA79i5
	H6VILJL7Y05iXdd6eU8z+psMb3DjDLFzotukCCbaa2tDD8fwfHle33F4/bQi6mK6oGCnBY
	2Nz7EKjOHzILKdVlSzot74M5pjTTiS8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-569-ZAzP__-jN7CXIvFQ3LCOyg-1; Wed,
 02 Sep 2026 13:38:06 -0400
X-MC-Unique: ZAzP__-jN7CXIvFQ3LCOyg-1
X-Mimecast-MFC-AGG-ID: ZAzP__-jN7CXIvFQ3LCOyg_1788370683
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94D911802562;
	Wed,  2 Sep 2026 17:38:03 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.158])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE5A41955D8D;
	Wed,  2 Sep 2026 17:37:57 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 30/36] netfs: Check for too much data being read
Date: Wed,  2 Sep 2026 18:33:42 +0100
Message-ID: <20260902173350.3468672-31-dhowells@redhat.com>
In-Reply-To: <20260902173350.3468672-1-dhowells@redhat.com>
References: <20260902173350.3468672-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Put in a check in read subreq termination to detect more data being read
for a subrequest than was requested.  In the event that this happens, abort
the rest of the read request on the basis that some of the read buffer may
have been corrupted and return -EIO.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/read_collect.c      | 24 ++++++++++++++++++++++++
 include/trace/events/netfs.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index fddeae4161e0..11cc1ac37fc5 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -353,6 +353,15 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			notes |= HIT_PENDING;
 
 		transferred = READ_ONCE(front->transferred);
+		if (unlikely(transferred > front->len)) {
+			/* Ugh...  A subreq overran its allotted length.  It
+			 * may have corrupted the read buffer.
+			 */
+			stream->failed = true;
+			stream->error = -EIO;
+			rreq->error = -EIO;
+			goto abandon_request;
+		}
 
 		/* If we can collect the next folio from a pending op, do so,
 		 * but we should only do it if we don't otherwise need to wait
@@ -663,6 +672,21 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		break;
 	}
 
+	/* If the subrequest read more than it was supposed to, abort
+	 * the request with EIO as we may have clobbered other parts
+	 * of the buffer that are already read.
+	 */
+	if (subreq->transferred > subreq->len) {
+		trace_netfs_sreq(subreq, netfs_sreq_trace_too_much);
+		__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+		__clear_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+		subreq->error = -EIO;
+		trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
+		trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
+		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
+		goto skip_error_checks;
+	}
+
 	/* Deal with retry requests, short reads and errors.  If we retry
 	 * but don't make progress, we abandon the attempt.
 	 */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 006bd2c73670..d098978623f7 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -133,6 +133,7 @@
 	EM(netfs_sreq_trace_submit,		"SUBMT")	\
 	EM(netfs_sreq_trace_superfluous,	"SPRFL")	\
 	EM(netfs_sreq_trace_terminated,		"TERM ")	\
+	EM(netfs_sreq_trace_too_much,		"!TOOM")	\
 	EM(netfs_sreq_trace_wait_for,		"_WAIT")	\
 	EM(netfs_sreq_trace_write,		"WRITE")	\
 	EM(netfs_sreq_trace_write_skip,		"SKIP ")	\

