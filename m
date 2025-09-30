Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E7A16A956;
	Tue, 30 Sep 2025 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246097; cv=none; b=G+4Ii0NMINJKoOCCVlO7lyE4KkYhask/z+tO45pVYGO4UMtD8G2CEaTeUq6MdgTuLo/ufc7L7/9oqKt1F1Av86kbyQ/VgA6rOb1UUXguIwN+wbJY8QC1yppLxby97/L3asRcBnHF+aw58tynVuskY7FTvfF3Z8o2MGI0Vjnx+TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246097; c=relaxed/simple;
	bh=6A92gVe2uWyF9qKhCvGXNf3WhwwcWUjgNzD+C1XUgzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOY+LehrREZm2oYEk6wckH9p++LdxbQH0fwnLMGDZvDFjvpZhXRWApUsE0WIleiH6ds0GnTLd5XhehdLSj63h2Sl18T6X2h9DjgLZ20Q5JVrqLjSWEV8k81v30pftIko0bSJHZzYKkppUoyJE+PsLjOmYmvVVSafZjuzEq/oIAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz+Kj+7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz+Kj+7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45623C4CEF0;
	Tue, 30 Sep 2025 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246095;
	bh=6A92gVe2uWyF9qKhCvGXNf3WhwwcWUjgNzD+C1XUgzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz+Kj+7nTxrzQidt+psk8QOFCskbFgFYwIiWo/60SMWVr/RSdFpAHIOqQf/Qqnugu
	 nG6CTsU21lZ0QnqgyszyRlxHtNftelSLPc/vlriwPaSEpqppvWV9umWrX2cQpsVYsU
	 fAiBS9MnX+26j7b4t5K38u15DDFhQXmsoLdj4ta8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 33/89] smb: server: use disable_work_sync in transport_rdma.c
Date: Tue, 30 Sep 2025 16:47:47 +0200
Message-ID: <20250930143823.289459656@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit f7f89250175e0a82e99ed66da7012e869c36497d ]

This makes it safer during the disconnect and avoids
requeueing.

It's ok to call disable_work[_sync]() more than once.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 8f5a393828065..d059c890d1428 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -398,9 +398,9 @@ static void free_transport(struct smb_direct_transport *t)
 	wait_event(t->wait_send_pending,
 		   atomic_read(&t->send_pending) == 0);
 
-	cancel_work_sync(&t->disconnect_work);
-	cancel_work_sync(&t->post_recv_credits_work);
-	cancel_work_sync(&t->send_immediate_work);
+	disable_work_sync(&t->disconnect_work);
+	disable_work_sync(&t->post_recv_credits_work);
+	disable_work_sync(&t->send_immediate_work);
 
 	if (t->qp) {
 		ib_drain_qp(t->qp);
-- 
2.51.0



