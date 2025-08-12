Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921FB2FF145;
	Tue, 12 Aug 2025 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021775; cv=none; b=s+Me4wjlwg7V4rla51To+yFvG1LtX/+9herKnwD7fW4Umkrn+JLb0WwmJkbe7pE/OKPG/s1ebRXdXaR1ql7L6VC2Kdq728G7nqCJu8mjCQs7Hsc4XWX14SjgSRe4T4FmFZrLRezmlVvWUmsOZmmAsLMdIpUKQO+JftbnUx9ITmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021775; c=relaxed/simple;
	bh=3mDWtLAAM0IFBkSSkQkbMoDKPuk+wEpOvuEDfGrv//o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuK4FOuy0LdCsokZtxMiSxJkUteJlHeSCS2CB1JoPPyG33FW7v5NypK7itnjX/IgEkRYkDyBtpoGIqkK1K/vRmqJWtfvSXx8m4TsYTDTUYt0Cqfx89K3D6USdbXXEqtj/95pjhaD3/wUJhSpb/8041mNrjjjw0hJEQ9AAycqkG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPRn0UL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPRn0UL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03729C4CEF6;
	Tue, 12 Aug 2025 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021775;
	bh=3mDWtLAAM0IFBkSSkQkbMoDKPuk+wEpOvuEDfGrv//o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPRn0UL4qsfUuBE//RF/pr+fxGnom9ho2UnFsV/Ota6Ix0tmW0C+AZUuvkvUg4q6b
	 vYE0IyvdyGgP3hu9wL16OPHfQlx+J4bVdo2ACnZCNOCXiykZb4G2Z4AETRrDs9rY4s
	 xfljwj5uomc9Qgq2BradBCI8s1FLJFGsUK42CWgA=
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
Subject: [PATCH 6.6 220/262] smb: server: let recv_done() avoid touching data_transfer after cleanup/move
Date: Tue, 12 Aug 2025 19:30:08 +0200
Message-ID: <20250812173002.514935139@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit a6c015b7ac2d8c5233337e5793f50d04fac17669 ]

Calling enqueue_reassembly() and wake_up_interruptible(&t->wait_reassembly_queue)
or put_receive_buffer() means the recvmsg/data_transfer pointer might
get re-used by another thread, which means these should be
the last operations before calling return.

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
 fs/smb/server/transport_rdma.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index b22fe18212cf..6c3a57bff147 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -580,16 +580,11 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			else
 				t->full_packet_received = true;
 
-			enqueue_reassembly(t, recvmsg, (int)data_length);
-			wake_up_interruptible(&t->wait_reassembly_queue);
-
 			spin_lock(&t->receive_credit_lock);
 			receive_credits = --(t->recv_credits);
 			avail_recvmsg_count = t->count_avail_recvmsg;
 			spin_unlock(&t->receive_credit_lock);
 		} else {
-			put_recvmsg(t, recvmsg);
-
 			spin_lock(&t->receive_credit_lock);
 			receive_credits = --(t->recv_credits);
 			avail_recvmsg_count = ++(t->count_avail_recvmsg);
@@ -611,6 +606,13 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (is_receive_credit_post_required(receive_credits, avail_recvmsg_count))
 			mod_delayed_work(smb_direct_wq,
 					 &t->post_recv_credits_work, 0);
+
+		if (data_length) {
+			enqueue_reassembly(t, recvmsg, (int)data_length);
+			wake_up_interruptible(&t->wait_reassembly_queue);
+		} else
+			put_recvmsg(t, recvmsg);
+
 		return;
 	}
 	}
-- 
2.39.5



