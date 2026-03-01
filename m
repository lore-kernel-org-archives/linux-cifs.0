Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E7B1F9F70;
	Sun,  1 Mar 2026 01:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328394; cv=none; b=SCZW3hH0I5hVPUjQhVB+4sEtO0W3KO7HdoYq3pIEHM24KHQYSHqpCARKDOMYuvGi3hyHYI/qemlin8OyHPVpD7oltp3rCUkTo8qINx2DHrhT4lJt5sR7w3JnJxxyWTDADcKaeX+jQeX6Wjz+R+yjbnfBEDixjyXhNypn4E9h8GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328394; c=relaxed/simple;
	bh=qAU5EaUm4GCXXrAhKYiSsUAbIkisxrOZpjSX4xxB/T0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AXRqeUfim2nxMZm50vQ8P6fmwruC2CIhDLKZqKbI8vG6vvgkv0uupTaeaZ3fzLqSgPxgY5+6SV+TkITG545VPPG1ofKxsfE6OT4KLMFlpTDOqr3xdnL1ezK7aAwSARHqNZ9XigeTIqWBQnY5DqAiJkJovgA3x2LIDTwaNbKenTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvAXyUWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvAXyUWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D4EC19421;
	Sun,  1 Mar 2026 01:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328394;
	bh=qAU5EaUm4GCXXrAhKYiSsUAbIkisxrOZpjSX4xxB/T0=;
	h=From:To:Cc:Subject:Date:From;
	b=hvAXyUWTrLXq7z5+exNwZYdohWFnVlZxwhtAaTBBLVgRg/gAD90+dM0RHGyQyUNtk
	 hfZXlFtFXfOXF+A6Ggzh4WayWN12U/qIAbuvKs0eLr/4mswwAafj82NrhPHksj6LXm
	 YoW3puoTF7EMPF4890hy0wBbc7GqMwSkqN+8VM1H8j4ieruFuqlO6GjqaT5qFV6Mg9
	 qGNmsZHCg9DSS6e53V+1CUJ8teSbJZUtwhg2TsjYjKNrcqyZ4tsIGE7zlf5XIMpjOs
	 e6p63QcbYw/uRiOURapP0aeIvPXABVO5RvWcXbHYBn+M8CZOzfvqngw0D0G33SGVOO
	 1h/DMv+ccS/Rg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	metze@samba.org
Cc: Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: FAILED: Patch "smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:26:32 -0500
Message-ID: <20260301012632.1683939-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 8e94268b21c8235d430ce1aa6dc0b15952744b9b Mon Sep 17 00:00:00 2001
From: Stefan Metzmacher <metze@samba.org>
Date: Thu, 22 Jan 2026 18:16:42 +0100
Subject: [PATCH] smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 403a8b2cd30e4..95265192bb01b 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -162,6 +162,17 @@ struct smbdirect_socket {
 			mempool_t		*pool;
 		} mem;
 
+		/*
+		 * This is a coordination for smbdirect_send_batch.
+		 *
+		 * There's only one possible credit, which means
+		 * only one instance is running at a time.
+		 */
+		struct {
+			atomic_t count;
+			wait_queue_head_t wait_queue;
+		} bcredits;
+
 		/*
 		 * The local credit state for ib_post_send()
 		 */
@@ -371,6 +382,9 @@ static __always_inline void smbdirect_socket_init(struct smbdirect_socket *sc)
 	INIT_DELAYED_WORK(&sc->idle.timer_work, __smbdirect_socket_disabled_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
 
+	atomic_set(&sc->send_io.bcredits.count, 0);
+	init_waitqueue_head(&sc->send_io.bcredits.wait_queue);
+
 	atomic_set(&sc->send_io.lcredits.count, 0);
 	init_waitqueue_head(&sc->send_io.lcredits.wait_queue);
 
@@ -485,6 +499,8 @@ struct smbdirect_send_batch {
 	 */
 	bool need_invalidate_rkey;
 	u32 remote_key;
+
+	int credit;
 };
 
 struct smbdirect_recv_io {
-- 
2.51.0




