Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8140B1EBFE0;
	Tue, 12 Aug 2025 18:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022983; cv=none; b=WQYf1l7MhJsuIDV6O//PYMOSRYCZOlxqUm5FgC8BZ+jHehp3ILWrIw3ZbUoDp3osAL5Y9kraHI0cPAJXO6raRzukN8Vo/8/iVL00JPm3CxdHNxjk+RX53veMPrAZ8pn0sMf2fUYPKUs69dPEBQ8qwskNF5XfPma22cxmoo65MHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022983; c=relaxed/simple;
	bh=ko5GUk66oeXzE3fo1ybmu2FyiO9+VxfLpAS7Yc40Hf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib1O3xyTsWon5KvTk5770zj8m3y0YByExeGsBgEf/tfpdEmjvjxfXEEaqcNm+eVhyYHAmVYM6TjOOmmiQCtOZHNKOSdBJN3HD/1yxjzMGYNfcj5Mvio9HEe3aCdgaG7OF/YO4j5Z73cu34MVeZDkMTeRcnpcm2ojbLLynlRr+vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbmwnSyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbmwnSyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D9AC4CEF6;
	Tue, 12 Aug 2025 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022983;
	bh=ko5GUk66oeXzE3fo1ybmu2FyiO9+VxfLpAS7Yc40Hf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbmwnSylFN7nKACUTZlUrrNo49EpzTEd/aWyiO7LiMqq+duJ6wZxIjbrD0tsaDinA
	 xNR8EDvwZB+SHngY0wU1kGxMkZECDh4mxcAsMBmQa0k8XC+Px9TV98TzYkg8Muw3Ot
	 R0HuzPYj0D9ak7dey1l/jBgFZRt9Eo/huNUUQaW0=
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
Subject: [PATCH 6.12 314/369] smb: server: let recv_done() avoid touching data_transfer after cleanup/move
Date: Tue, 12 Aug 2025 19:30:11 +0200
Message-ID: <20250812173028.535401870@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index b5e9fd9369e9..805c20f619b0 100644
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



