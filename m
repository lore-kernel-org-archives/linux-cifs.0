Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECB634CFC3;
	Fri, 13 Feb 2026 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990641; cv=none; b=PX69PIPnt+G09RNpv8RA1BQjuskckl2y7n9OJAb41nB94VoY1DA/GO6N5RiDF9kBqoS0Pm9GSl/xwwGH+jh16wrTyT3k32+7atzdhWg3dwB0qoaNtVj6hE+XjTqovzqTok5shE1KFk42nqjHrj7QEwofNkW6zVbA7p6lM8POFoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990641; c=relaxed/simple;
	bh=+QXBS5/8u1qeK/neHg3DTQD3+dUvoNxJX/vO2q7iNyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gllmItZyGdX8K+GOzg8Juu0EU5IL1N8uZNI1IxcjK8N6TSkspI/bHQFP7cOzjT2RSRecxsdt2Z2sdRYRMcsj6VLo8PODjjzQQEu2EgmcRRHzalVtBsTIOtaxvGWShlmP8/WyaxYFhhxLHmkjpziCRLbuSpgkzd0Me1quChmEBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZdBFhVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZdBFhVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF2FC116C6;
	Fri, 13 Feb 2026 13:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990641;
	bh=+QXBS5/8u1qeK/neHg3DTQD3+dUvoNxJX/vO2q7iNyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZdBFhVt3DIxHHpmvOZzczH+hZwWA3DjegOxRD9kqVuAi9yXvTDtEUFX5hirlGhFo
	 BXj8+TXNgJ8G5y6t3df3FZsTlk8VpNCKuRYrGu76e3Bp1ZRZmTttQ048y8A5D5LflP
	 4qlSiPe0xm7WEZUuQaOcQy/K7qhSTnRtlwax76n8=
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
Subject: [PATCH 6.19 07/49] smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available
Date: Fri, 13 Feb 2026 14:47:26 +0100
Message-ID: <20260213134708.994779039@linuxfoundation.org>
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

commit 6e3c5052f9686192e178806e017b7377155f4bab upstream.

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

Fixes: 5fb9b459b368 ("smb: client: count the number of posted recv_io messages in order to calculated credits")
Fixes: 89b021a72663 ("smb: server: manage recv credits by counting posted recv_io and granted credits")
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
 fs/smb/common/smbdirect/smbdirect_socket.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -239,6 +239,7 @@ struct smbdirect_socket {
 		 */
 		struct {
 			u16 target;
+			atomic_t available;
 			atomic_t count;
 		} credits;
 
@@ -387,6 +388,7 @@ static __always_inline void smbdirect_so
 	INIT_WORK(&sc->recv_io.posted.refill_work, __smbdirect_socket_disabled_work);
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 
+	atomic_set(&sc->recv_io.credits.available, 0);
 	atomic_set(&sc->recv_io.credits.count, 0);
 
 	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);


