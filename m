Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6872F175D53;
	Fri, 13 Feb 2026 13:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990644; cv=none; b=BiB+bTPrFB0sNdUXCWfnz7CTlQvaKXycGWwfjunJDrdCsYqSualFfJwIY3IeJRP2KzznV5JvCdXIBOS51jWr3u27NGPYALgia7weG5ancyrBdtSlDi3nyekxYVS4ujk0Ju/WxBHMAzof+WU2vdoB3GXvbgfWoxgxhtu0yWarPxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990644; c=relaxed/simple;
	bh=gGyt+PUOM7SPmGjyFiomuY23yo7/+Tp7dkoEZJ8MuQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjDWAE3jJDVPPU4jUV6ICPdzDs5CiYR3T/lU79rLszzXAhD364eZaeKfL/GgD7oBPH3xIxihTNGef9+PqZeHYKkyLIAHdfjJtguvfISmn/sLunmsATojJrfeWwXMri6I3hj9l9EVhuqGEbgdL4SkEcpFxpFGPuQGjucJLXaID34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO9SrVY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO9SrVY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C85C116C6;
	Fri, 13 Feb 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990644;
	bh=gGyt+PUOM7SPmGjyFiomuY23yo7/+Tp7dkoEZJ8MuQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO9SrVY+1bASsOcKkXLDrPOS2Cydi8utkfDfM5rNbtQMGbHYNY3PQPsdEOub13nln
	 cpHZ9whTix8NhGHiFaB1fsdUMaOnNqWkCilOoPvwWZwtqzmxCeNtq1RVKoJ/rL43vU
	 56K2r7QotViq09KpC9xYral58q6g63ExLXNlOatE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 08/49] smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
Date: Fri, 13 Feb 2026 14:47:27 +0100
Message-ID: <20260213134709.030994234@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 8e94268b21c8235d430ce1aa6dc0b15952744b9b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -163,6 +163,17 @@ struct smbdirect_socket {
 		} mem;
 
 		/*
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
+		/*
 		 * The local credit state for ib_post_send()
 		 */
 		struct {
@@ -371,6 +382,9 @@ static __always_inline void smbdirect_so
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


