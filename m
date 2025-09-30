Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FA81EE02F;
	Tue, 30 Sep 2025 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244567; cv=none; b=H61vYjOwWh6mLglNYoRZsFxAdQ/5QFjr1HVYOM6eII/Vv5LSc+CI2jkHfWGpM7SFSIRlxs0hYan2dnKwv4QWyP3rWbf5Fice95Po89aaXg2ahDJa3sbfKOcMO95D5BqWZLZRwvQQvGoviZEVL9ossoDt3FrTzhsSEec4v8u57l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244567; c=relaxed/simple;
	bh=I3W7/Df49uVwZz6Z7ZncJ5VHdMHgyXW8xHTN0A9RPdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsyulwT1PvWdZdnnt+GDwjOmI0mHzvNj9j7DH0YSm+xBNDX+wG42D/t/0RxuLr9vp42DoxCh9mICTsOqRuMeNNe22nFKDklo0SxBtG+mmTZagbDbCAHfyvLg28QUi9/K6o9WIuQmAfx7D3kCpBX/cpkv6NdSjUlVfEk4UrsFJCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+a48hW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+a48hW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16A9C4CEF0;
	Tue, 30 Sep 2025 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244567;
	bh=I3W7/Df49uVwZz6Z7ZncJ5VHdMHgyXW8xHTN0A9RPdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+a48hW7HBokoW/BjowyohutJwQhhtimbamhxotyJu7V+b2W21h+9brzbsSAvL+zG
	 DM4rbGFeT5OoDpOQ3aXIhsP03okMH4QmzPQwFQhzp+fqs9S9WhDP0rjdsR+Or/rcHL
	 7qb9S7SyawtPnjnj1rt3XluXW2CAFJ4go5C7HQGs=
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
Subject: [PATCH 6.16 046/143] smb: server: use disable_work_sync in transport_rdma.c
Date: Tue, 30 Sep 2025 16:46:10 +0200
Message-ID: <20250930143833.071844499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 10a6b4ed1a037..74dfb6496095d 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -399,9 +399,9 @@ static void free_transport(struct smb_direct_transport *t)
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



