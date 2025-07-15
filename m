Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7AA26D4F2;
	Tue, 15 Jul 2025 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586979; cv=none; b=B7xRr1ZvcA6R2wgcA7hMq1EkE/pDZdsBSUY6mL6mO4eDtbvh8KNOrZ9udX4Pg7+zZf4CJemtKDehYnMrbTxwuB+aI4RMvfKqLbJdoWsxBt64ez8CW71Ml8O3YV12xK3zeQMQ8Km5Wm0Komc+ovQGD9Wrb8O1gLGKMIWZnMLWCSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586979; c=relaxed/simple;
	bh=dzAD5IRDnweDKX7utVEkexM2eEOIPdWp0Jo6C1sUI4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE/n4uOM2uQe3ZM4t25kQKKSkb2uoIOtd94NoYHgG5yVFU0bwRa+igsUg12Gks7bgmlhD5l5MPp2RjAhtkYpxqvNmrV40mF/uKfTe/uofIvY/8ceIeJYJSMqLoxCqi/AUxh0Zd3+uUOA6OSr0gW54O1c2IOFXzIw86yFjLyj0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tezsGdj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tezsGdj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB89C4CEE3;
	Tue, 15 Jul 2025 13:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586978;
	bh=dzAD5IRDnweDKX7utVEkexM2eEOIPdWp0Jo6C1sUI4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tezsGdj/4J3FSeT3w7rJGnd8S3KNMDME4rCt4Kj8Qscx9Jzj/PbnvkpC0iARGsuO0
	 dx7S6oW++MzrAMvfrqaBF+jXNjXzGwlN6+O9pWtE9mFrM92RH2x/pgS9Iok2ISfw9N
	 97L0Lk2ntfiSYXec3D2ZkBisKtGHGWB5d1N/KAbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 6.15 119/192] smb: server: make use of rdma_destroy_qp()
Date: Tue, 15 Jul 2025 15:13:34 +0200
Message-ID: <20250715130819.665683443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 0c2b53997e8f5e2ec9e0fbd17ac0436466b65488 upstream.

The qp is created by rdma_create_qp() as t->cm_id->qp
and t->qp is just a shortcut.

rdma_destroy_qp() also calls ib_destroy_qp(cm_id->qp) internally,
but it is protected by a mutex, clears the cm_id and also calls
trace_cm_qp_destroy().

This should make the tracing more useful as both
rdma_create_qp() and rdma_destroy_qp() are traces and it makes
the code look more sane as functions from the same layer are used
for the specific qp object.

trace-cmd stream -e rdma_cma:cm_qp_create -e rdma_cma:cm_qp_destroy
shows this now while doing a mount and unmount from a client:

  <...>-80   [002] 378.514182: cm_qp_create:  cm.id=1 src=172.31.9.167:5445 dst=172.31.9.166:37113 tos=0 pd.id=0 qp_type=RC send_wr=867 recv_wr=255 qp_num=1 rc=0
  <...>-6283 [001] 381.686172: cm_qp_destroy: cm.id=1 src=172.31.9.167:5445 dst=172.31.9.166:37113 tos=0 qp_num=1

Before we only saw the first line.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -433,7 +433,8 @@ static void free_transport(struct smb_di
 	if (t->qp) {
 		ib_drain_qp(t->qp);
 		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
-		ib_destroy_qp(t->qp);
+		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 
 	ksmbd_debug(RDMA, "drain the reassembly queue\n");
@@ -1940,8 +1941,8 @@ static int smb_direct_create_qpair(struc
 	return 0;
 err:
 	if (t->qp) {
-		ib_destroy_qp(t->qp);
 		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 	if (t->recv_cq) {
 		ib_destroy_cq(t->recv_cq);


