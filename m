Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F092E8DED;
	Tue, 15 Jul 2025 13:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586213; cv=none; b=b/m1x0p83fqoJV1Qz5MOMx15M7c1WKNAjpLUq2tWUJri7wVVeDG6nsHU7Ed6yDmWvAeXUBRbRyGmGGJ4iUNKOX3L7xZQ/oOirrybpmGCr1CSASFVbKzl0V+N2Z4O7/I9lbKmRvy8kcAKni4l6efpF+UsS2iihO8U7MXG88Scthk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586213; c=relaxed/simple;
	bh=07p/tU9vqJ6zMZ4aA0BxmG0TwquGFfGfmrFSId/XYok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8SasUbN6MCmnXB/EBaK4SIP6Y+lspIEkzEQjwZnEZBRyXqV4FLSvBEy6JUe5b4zevElKPOtfXj+RIPjWddnqcJ6ue9sLj5i4r8nj834dUvWwDgIpfhxhqaqT5PLwHuxpKMTidLk9ukkZFSzyll7Dq0+hD5TDEsY/YArr/YRTJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxutz4zZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxutz4zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2983AC4CEF1;
	Tue, 15 Jul 2025 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586213;
	bh=07p/tU9vqJ6zMZ4aA0BxmG0TwquGFfGfmrFSId/XYok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxutz4zZv39og93gdAMKftODnarAsMJ3nVixBEkJ371YYn4lgMCStiDEn/wwq75x9
	 25K7rKiT0KBWLYjOeTUmyMSb9Jhj7UcShwwwxnUzhnTDlP6NQdzh4RLQfNxd2I/5Z2
	 LKrmYwPkMS2dQt7qSDcX9O9pvagX+SVvYk0k6dKs=
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
	Stefan Metzmacher <metze@samba.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 58/77] smb: server: make use of rdma_destroy_qp()
Date: Tue, 15 Jul 2025 15:13:57 +0200
Message-ID: <20250715130754.055823553@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 0c2b53997e8f5e2ec9e0fbd17ac0436466b65488 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 355673f2830be..91e663d5d5bc1 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -426,7 +426,8 @@ static void free_transport(struct smb_direct_transport *t)
 	if (t->qp) {
 		ib_drain_qp(t->qp);
 		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
-		ib_destroy_qp(t->qp);
+		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 
 	ksmbd_debug(RDMA, "drain the reassembly queue\n");
@@ -1934,8 +1935,8 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	return 0;
 err:
 	if (t->qp) {
-		ib_destroy_qp(t->qp);
 		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 	if (t->recv_cq) {
 		ib_destroy_cq(t->recv_cq);
-- 
2.39.5



