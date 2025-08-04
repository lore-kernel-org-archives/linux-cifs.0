Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FDE15E8B
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309532; cv=none; b=dGmWsDp9UFli3A1EtlZCD0ljbniUZaXJyUI4TXtfrMzIEDiGyZ1IEvoMfYWenInBJkMpTLb4TLIDWVCiItXsXVzL/SG12xZXoq6qn2LyhKUp5ly3NH1FU/YZHJi/dPsITVVeHRe1Yzhz8Ds/dBI+jZOifbC2D1qYD433wxuSzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309532; c=relaxed/simple;
	bh=6j9mXZux+pmBKkhXrNTKSl8mHeroTe6/frfRljKBjBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aic3JhmBtPRrQsAxe+FkZuf1hHUXU1MaHIJLkCxWUmSVN8SXGgPzqnqCXjuxw642IYIli0GjJnSg1+pCfpn8NzXpAvl5C+TfuHnFuPpZJcezbX7N7HwD4iGkbo+uD0EF/HrgqcxtaKU+prJEcX7vg6HINCbWMxwo7lTIu3MsWpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bdf0vcbN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bdf0vcbN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=86PQTTD/8vIal3LVRgKzMafkOkFA0tsZeqaHvjLdiYg=; b=bdf0vcbNuGYj5WTKZrDm0nQl+G
	Nm98iy+NBCMwRcNiZAT7NI8WEapLlSdIeEKPtcb4lClpCfAdJRoujcrYcpdvw/xzPpKyGqLQMtXPj
	+o/QBclTTaeeriBWCn8G1VtNLZhDWxRdHwIgZOkXcXtebiNCb6UFQcn/A2mVIoNOPHfdhbAi7PIAS
	yT7YCs5w636nmSGviVCspdHnB3hdzsQoh57iVvPwSU0qQ080wdazA5RY6v8FMDlzpoGh6FKjB09mz
	iKgcJKCLCNUGu8bDTCxHZ+0ML/rkS/HVyZRbDZQz3xpwzsRevQ5YSeUsSauSsRWqaBcsYMJZnAUdV
	OC8otxckEmycHXjfTF+Bqxi5/Z+biR/WoUrhRLBv6tr/G6R5YteMaz77bB/Z5DNKVLLE3gzTWqYeB
	G7aSGF40NkcZO/XxChhffa+yn/aYPyXCMJMvL0VSIqjzy2HlK+RSGpn8JdBqqimzljkld5OLbylUL
	93wlr9uVO9+k24gXo+hhWsOU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu2x-000vyn-1H;
	Mon, 04 Aug 2025 12:12:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 5/5] smb: client: let recv_done() avoid touching data_transfer after cleanup/move
Date: Mon,  4 Aug 2025 14:10:16 +0200
Message-ID: <64cb50961182cd17ac9bdda2913986f322a5acac.1754308712.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754308712.git.metze@samba.org>
References: <cover.1754308712.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Calling enqueue_reassembly() and wake_up_interruptible(&info->wait_reassembly_queue)
or put_receive_buffer() means the reponse/data_transfer pointer might
get re-used by another thread, which means these should be
the last operations before calling return.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 21a12e08082f..58321e483a1a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -479,10 +479,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		data_transfer = smbd_response_payload(response);
 		data_length = le32_to_cpu(data_transfer->data_length);
 
-		/*
-		 * If this is a packet with data playload place the data in
-		 * reassembly queue and wake up the reading thread
-		 */
 		if (data_length) {
 			if (info->full_packet_received)
 				response->first_segment = true;
@@ -491,16 +487,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				info->full_packet_received = false;
 			else
 				info->full_packet_received = true;
-
-			enqueue_reassembly(
-				info,
-				response,
-				data_length);
-		} else
-			put_receive_buffer(info, response);
-
-		if (data_length)
-			wake_up_interruptible(&info->wait_reassembly_queue);
+		}
 
 		atomic_dec(&info->receive_credits);
 		info->receive_credit_target =
@@ -528,6 +515,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			info->keep_alive_requested = KEEP_ALIVE_PENDING;
 		}
 
+		/*
+		 * If this is a packet with data playload place the data in
+		 * reassembly queue and wake up the reading thread
+		 */
+		if (data_length) {
+			enqueue_reassembly(info, response, data_length);
+			wake_up_interruptible(&info->wait_reassembly_queue);
+		} else
+			put_receive_buffer(info, response);
+
 		return;
 	}
 
-- 
2.43.0

