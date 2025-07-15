Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B645919D09C;
	Tue, 15 Jul 2025 13:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585593; cv=none; b=eFzF4o8xLCkmaM7r7kg3v752cbHXSwQShHn7vG+AB/OhLUNaL0QcEsB+iKZaAbJC4ORlCedYxWwjhDrZn7umBII0ISdI8Kz+EnADf/lTYrFcHA4Xghlp/NbMrI6w+i2jf6whaaeVdxZrwUXtuLP3NToLWZXGiPowmjO9bLwmIXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585593; c=relaxed/simple;
	bh=glIwbtmsq1m1rRqbYxUUdwi7StLm6ZJLOyibE+B3RR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMtAdplWXKgJLlCBr5Aen3DMdFePU6gNKLviLAeIaJcI9ro+G/7NGSHcO7xft9b/w71BxxXGyBn4cFrqI2bmcrZ0xyHLbgP1vmZMpRZGHetTKM+vwGolP63SG4pZpz1ggtyAs7+JU5ao80kSXeOo7dxsXhz08gI/rXIf7hndrIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icRCwRlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icRCwRlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2CFC4CEE3;
	Tue, 15 Jul 2025 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585593;
	bh=glIwbtmsq1m1rRqbYxUUdwi7StLm6ZJLOyibE+B3RR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icRCwRlmZSi92wqnW1HMVeFg0BBOlg4Mon+20AsTgzCKfurw5iRQ0oUMPIYcYkSDe
	 oZdpIHk3/xr2p5sozbs9A8Ynvb/M1JaqR6sz1/vdP96R6+PWnyURDS0CcW8Zqn93Ed
	 pwIHTL4M/96aIuPaoOdaWK6ZBI11jF3Mld0gbEqc=
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
Subject: [PATCH 6.12 099/163] smb: server: make use of rdma_destroy_qp()
Date: Tue, 15 Jul 2025 15:12:47 +0200
Message-ID: <20250715130812.834997324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -432,7 +432,8 @@ static void free_transport(struct smb_di
 	if (t->qp) {
 		ib_drain_qp(t->qp);
 		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
-		ib_destroy_qp(t->qp);
+		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 
 	ksmbd_debug(RDMA, "drain the reassembly queue\n");
@@ -1939,8 +1940,8 @@ static int smb_direct_create_qpair(struc
 	return 0;
 err:
 	if (t->qp) {
-		ib_destroy_qp(t->qp);
 		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 	if (t->recv_cq) {
 		ib_destroy_cq(t->recv_cq);


