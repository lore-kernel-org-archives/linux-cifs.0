Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF28D241665;
	Fri, 13 Feb 2026 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990838; cv=none; b=Qr8hFpVnxpFDfIkAxrf+qI3Qlqm8n0EjhBoncExA8rf/BFxkIbO46l5pHt0YgMFYzGYA30XEMk2zVTMXxBAzFQu1b07nFWp61Cc85zPzLJWKIQP4dVyd8Mnpvfl5rGjeiU3yp5CbdzcBvkzKJyJsdiSZB7SCznq5N25+hOZoimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990838; c=relaxed/simple;
	bh=V1i9r5Ys2mI4LX6/pqhslP2btIAgBvl9r7ram1eHI0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwsmxzhEHzMvIyzGaIDG329usjSljbIsvCfMPFHeaPoFQS79AJ5vzYvRq2Sn8m7wYb9BOnlpEZctm0M7fgJP9qGkH29TKi0WpcxjSEnGTtwYWAGQFukaYLwS7ordXzBLebJWbrDU/K5oAl68Jqzyr+su4xuM4gydMgdclqxteac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K18O0RvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K18O0RvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D55FC116C6;
	Fri, 13 Feb 2026 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990838;
	bh=V1i9r5Ys2mI4LX6/pqhslP2btIAgBvl9r7ram1eHI0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K18O0RvTJdZwlxEuOUWAIrlUv3gdAZHGmK33fHAstv+eP3bRpAEaa8z+CWgGTYHBQ
	 eAb7V5Y5eVkQCT6U3uEipldkTv6su/vKeZnVWT4Rurj+sNHu+IJqmcXBbGC2p8KvwH
	 Jhry2z3GA++TVaQXG6axYne/OVNUtfPCrk/uhHWg=
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
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 09/49] smb: server: make use of smbdirect_socket.recv_io.credits.available
Date: Fri, 13 Feb 2026 14:47:53 +0100
Message-ID: <20260213134709.227991546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 26ad87a2cfb8c1384620d1693a166ed87303046e upstream.

The logic off managing recv credits by counting posted recv_io and
granted credits is racy.

That's because the peer might already consumed a credit,
but between receiving the incoming recv at the hardware
and processing the completion in the 'recv_done' functions
we likely have a window where we grant credits, which
don't really exist.

So we better have a decicated counter for the
available credits, which will be incremented
when we posted new recv buffers and drained when
we grant the credits to the peer.

This fixes regression Namjae reported with
the 6.18 release.

Fixes: 89b021a72663 ("smb: server: manage recv credits by counting posted recv_io and granted credits")
Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_rdma.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -926,6 +926,8 @@ static void smb_direct_post_recv_credits
 		}
 	}
 
+	atomic_add(credits, &sc->recv_io.credits.available);
+
 	if (credits)
 		queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
@@ -972,19 +974,37 @@ static void send_done(struct ib_cq *cq,
 
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
+	int missing;
+	int available;
 	int new_credits;
 
 	if (atomic_read(&sc->recv_io.credits.count) >= sc->recv_io.credits.target)
 		return 0;
 
-	new_credits = atomic_read(&sc->recv_io.posted.count);
-	if (new_credits == 0)
+	missing = (int)sc->recv_io.credits.target - atomic_read(&sc->recv_io.credits.count);
+	available = atomic_xchg(&sc->recv_io.credits.available, 0);
+	new_credits = (u16)min3(U16_MAX, missing, available);
+	if (new_credits <= 0) {
+		/*
+		 * If credits are available, but not granted
+		 * we need to re-add them again.
+		 */
+		if (available)
+			atomic_add(available, &sc->recv_io.credits.available);
 		return 0;
+	}
 
-	new_credits -= atomic_read(&sc->recv_io.credits.count);
-	if (new_credits <= 0)
-		return 0;
+	if (new_credits < available) {
+		/*
+		 * Readd the remaining available again.
+		 */
+		available -= new_credits;
+		atomic_add(available, &sc->recv_io.credits.available);
+	}
 
+	/*
+	 * Remember we granted the credits
+	 */
 	atomic_add(new_credits, &sc->recv_io.credits.count);
 	return new_credits;
 }


