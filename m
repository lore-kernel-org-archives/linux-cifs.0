Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9511DAC92
	for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 20:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381881; cv=none; b=AjSuzglToBp4m4b1Qb9oJ0oB9ORbxBqgfxkTtt3mLTYEeNCyDEIcKKaNhrFNXceJaa9C6zXS/OwLTBSAoXCUJOlO8AA73Y/8preV0Jqw9NmfzFA8VOH02blAbKv47gMo4wo2iYdFbxVWUu4OygJAj9US+q4vHVPtcsbPMOv8Y28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381881; c=relaxed/simple;
	bh=0HAISuIxjXuHYtmzbbMFtfDDjYEsez984EWtKLp+Uhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPn05Ld5Vs/szBsJ5Kv6w5nQKLqa1NwexwR5gJZIOd3HaODoXBdGajgHMv6boz6AkVpBnex8x+iiPMM0AvwtfF6mfilO4SxIwQPS/1aGF4Q9icQtX/udEojN2bHAh3zOt9Gv58iVXC+lXq3Y7bkIrwBV1O4LrV8mgGysISVdAG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KX2b9D07; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KX2b9D07"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734381878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OrdAljyu/86B7Uupqp5aIMyvZ1Oua6M6rtiSOl8cYT8=;
	b=KX2b9D07LHq0mWypvFI6Nx3D+ww5ambap6PXi7pQM5scgDMS4pk/QxvCd3Od0wyNyGKpw9
	MzIuszAyyP8yTgeY0DB6UzPcTdui/0EA/7GuFthE8RuvpDRUjSN/OOWSLMGPrtk2qpmGA+
	YVfL1YKLAfD4VpGByikwigRo/bfhs4M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-CmBsNdYvNwikLl9PUzf_eA-1; Mon,
 16 Dec 2024 15:44:34 -0500
X-MC-Unique: CmBsNdYvNwikLl9PUzf_eA-1
X-Mimecast-MFC-AGG-ID: CmBsNdYvNwikLl9PUzf_eA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA3D6195604F;
	Mon, 16 Dec 2024 20:44:31 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2010319560AD;
	Mon, 16 Dec 2024 20:44:25 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 24/32] afs: Fix cleanup of immediately failed async calls
Date: Mon, 16 Dec 2024 20:41:14 +0000
Message-ID: <20241216204124.3752367-25-dhowells@redhat.com>
In-Reply-To: <20241216204124.3752367-1-dhowells@redhat.com>
References: <20241216204124.3752367-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

If we manage to begin an async call, but fail to transmit any data on it
due to a signal, we then abort it which causes a race between the
notification of call completion from rxrpc and our attempt to cancel the
notification.  The notification will be necessary, however, for async
FetchData to terminate the netfs subrequest.

However, since we get a notification from rxrpc upon completion of a call
(aborted or otherwise), we can just leave it to that.

This leads to calls not getting cleaned up, but appearing in
/proc/net/rxrpc/calls as being aborted with code 6.

Fix this by making the "error_do_abort:" case of afs_make_call() abort the
call and then abandon it to the notification handler.

Fixes: 34fa47612bfe ("afs: Fix race in async call refcounting")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
---
 fs/afs/internal.h          |  9 +++++++++
 fs/afs/rxrpc.c             | 12 +++++++++---
 include/trace/events/afs.h |  2 ++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 39d2e29ed0e0..96fc466efd10 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1336,6 +1336,15 @@ extern void afs_send_simple_reply(struct afs_call *, const void *, size_t);
 extern int afs_extract_data(struct afs_call *, bool);
 extern int afs_protocol_error(struct afs_call *, enum afs_eproto_cause);
 
+static inline void afs_see_call(struct afs_call *call, enum afs_call_trace why)
+{
+	int r = refcount_read(&call->ref);
+
+	trace_afs_call(call->debug_id, why, r,
+		       atomic_read(&call->net->nr_outstanding_calls),
+		       __builtin_return_address(0));
+}
+
 static inline void afs_make_op_call(struct afs_operation *op, struct afs_call *call,
 				    gfp_t gfp)
 {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 9f2a3bb56ec6..a122c6366ce1 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -430,11 +430,16 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
 	return;
 
 error_do_abort:
-	if (ret != -ECONNABORTED) {
+	if (ret != -ECONNABORTED)
 		rxrpc_kernel_abort_call(call->net->socket, rxcall,
 					RX_USER_ABORT, ret,
 					afs_abort_send_data_error);
-	} else {
+	if (call->async) {
+		afs_see_call(call, afs_call_trace_async_abort);
+		return;
+	}
+
+	if (ret == -ECONNABORTED) {
 		len = 0;
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, NULL, 0, 0);
 		rxrpc_kernel_recv_data(call->net->socket, rxcall,
@@ -445,6 +450,8 @@ void afs_make_call(struct afs_call *call, gfp_t gfp)
 	call->error = ret;
 	trace_afs_call_done(call);
 error_kill_call:
+	if (call->async)
+		afs_see_call(call, afs_call_trace_async_kill);
 	if (call->type->done)
 		call->type->done(call);
 
@@ -602,7 +609,6 @@ static void afs_deliver_to_call(struct afs_call *call)
 	abort_code = 0;
 call_complete:
 	afs_set_call_complete(call, ret, remote_abort);
-	state = AFS_CALL_COMPLETE;
 	goto done;
 }
 
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 49a749672e38..cdb5f2af7799 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -118,6 +118,8 @@ enum yfs_cm_operation {
  */
 #define afs_call_traces \
 	EM(afs_call_trace_alloc,		"ALLOC") \
+	EM(afs_call_trace_async_abort,		"ASYAB") \
+	EM(afs_call_trace_async_kill,		"ASYKL") \
 	EM(afs_call_trace_free,			"FREE ") \
 	EM(afs_call_trace_get,			"GET  ") \
 	EM(afs_call_trace_put,			"PUT  ") \

