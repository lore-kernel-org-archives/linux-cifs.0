Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A766A25228C;
	Sun,  1 Mar 2026 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329026; cv=none; b=RiHTpxj3+HAijyxrNe+9rtLUFhwRkSTO54C5p9OyDGy9/09KZkfHNcRFOURZz68Vs+evmNlvkW/wO62z6riXyleFnnuvhnv5IuzE4eo887NQ8va8UujsB6DeKjSJoxKvJ4/MT/YC5H467tXJ/xqjMoSgzdMzM811rpnxVGJENx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329026; c=relaxed/simple;
	bh=oxvsOiSz8L10aYUgdUWLx5H2u+roGuxFUc7QI/f11fM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=muKuL4BGvZDxnmQlKvS1a2xcmE0KE1dmBcbhxW0O6SfXVioMCPXB5ggBo8QK25J4aKiC2itebqBtFvQl+2FNy9dEqimDUfXzdJef5StNv5fdoG1xY7cxGrOfdvcvM/2e8EQD8OP/ykC4XpACdeo6cyx835ppUtcwS3eiOEB5e/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOzVbkDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOzVbkDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C9AC19421;
	Sun,  1 Mar 2026 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329026;
	bh=oxvsOiSz8L10aYUgdUWLx5H2u+roGuxFUc7QI/f11fM=;
	h=From:To:Cc:Subject:Date:From;
	b=hOzVbkDhRaJ9Y1E0TaTnyxQ0B27URgR5/CK+10Nxv3DjXXmivU2RHDGBg3rgvPrcU
	 fnIGAoccd9kG+f6M8G8C5cc0V/L72pJXfomzvQITcxXHiLsKbG76YASWwPrEs5p5Gr
	 zgnTvP9ZkaSgECOYBuNLNWqi8uFLQl6FJuGEP6M+qxxBSHpzp/uF/Ild/Esr6t/sQb
	 60KIRLBkNU8xvzuAgZ4mBq0et43FUJtpDYWQ5gPSvT4PPI1CtSyT81/E0ET8hM5Ih9
	 7tc/AWshL+flEfi2uAhcAq7HjEk0oILukMBxSjwhFuqrOtiHjJp2/OnpaRx4p2vWng
	 yM28OHnr12NUw==
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
Subject: FAILED: Patch "smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:37:04 -0500
Message-ID: <20260301013704.1697258-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
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




