Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B71F30C37D;
	Mon, 18 Aug 2025 13:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523152; cv=none; b=dpu/Qa5AgiDgHV+wKyE4vsZXZKeuh3MeZ95iLzmTGg0vzDIVVL9ye4YfMo68YnTgbnTRQQBqsqvOM5fuFkcmtx6D8uBmeCis55AjQhxhVBjiNN2imocrt6jQfq7z2NR8HzvRDbErct7yEQmXtgRu6R+gePFNrUwQVFCLV9tFHsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523152; c=relaxed/simple;
	bh=njnO65N1FUdQsTPZZA0jmoNzSulQnCmYwm6RgIUOLHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd/elinJ3ECSiZlNO6/XyNjPx/hb0XrTjrEfE+rBJK7nGYuiFTY1jmYO72Cd44DcoBD1ngsln3MSp1WxR5cPVyI3v6MVau7P0ZcOBUnPPIiDwBb2FXgeErIWzYEcnhQjx8l0CZK+TeCSSFcL4NT+bA5xpgTd0PGKES+l2u+3EHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0WDs1km; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0WDs1km"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF9CC4CEEB;
	Mon, 18 Aug 2025 13:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523149;
	bh=njnO65N1FUdQsTPZZA0jmoNzSulQnCmYwm6RgIUOLHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0WDs1kmFyHNK0f+5pJvveuKJ+LDaseghEMVAEsa6eyTJ0EXcmewmPiD2mzRqushk
	 NA7ypPJJbKUuWINqMv78uR4h0vPuFUzX2xEq2njjMOiNQPLZAot+3GQfwaTLEs+SpG
	 6y6W/JPi4naYR76mcVfkKlHVIveiGltsY5czr+k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 054/515] smb: client: dont wait for info->send_pending == 0 on error
Date: Mon, 18 Aug 2025 14:40:40 +0200
Message-ID: <20250818124500.498960157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 8c48e1c7520321cc87ff651e96093e2f412785fb upstream.

We already called ib_drain_qp() before and that makes sure
send_done() was called with IB_WC_WR_FLUSH_ERR, but
didn't called atomic_dec_and_test(&sc->send_io.pending.count)

So we may never reach the info->send_pending == 0 condition.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 5349ae5e05fa ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1316,10 +1316,6 @@ void smbd_destroy(struct TCP_Server_Info
 	log_rdma_event(INFO, "cancelling idle timer\n");
 	cancel_delayed_work_sync(&info->idle_timer_work);
 
-	log_rdma_event(INFO, "wait for all send posted to IB to finish\n");
-	wait_event(info->wait_send_pending,
-		atomic_read(&info->send_pending) == 0);
-
 	/* It's not possible for upper layer to get to reassembly */
 	log_rdma_event(INFO, "drain the reassembly queue\n");
 	do {
@@ -1965,7 +1961,11 @@ int smbd_send(struct TCP_Server_Info *se
 	 */
 
 	wait_event(info->wait_send_pending,
-		atomic_read(&info->send_pending) == 0);
+		atomic_read(&info->send_pending) == 0 ||
+		sc->status != SMBDIRECT_SOCKET_CONNECTED);
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED && rc == 0)
+		rc = -EAGAIN;
 
 	return rc;
 }


