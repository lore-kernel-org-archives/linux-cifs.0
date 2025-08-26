Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA6938DD8;
	Tue, 26 Aug 2025 12:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212607; cv=none; b=LoAj634ciIa9ums2GgjPwnNu40JQPfd7QHtn9DdCIyDlKV3/QieNAvkym2/Ix9q9Wg4gOgbIw9Rr/ZPEf4qncH6PQC5ogN2KqYkYrrtpaF9Lb9fQs8bo5rOFcyZulN99mT1WwHiD6N52dKzo/bSdX+b2iaqanYzbsheGFrqqcx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212607; c=relaxed/simple;
	bh=fSC//JZcfqNjjxceabuhKYZKg0/ytUODfn8kAxuiE5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y25XqXRDJHQjKwhUhSCuvJvDXwP+QpFmZgTS++vFU4bfIb30d5qw7dE0NZcoYsDAaGjls4/ig4Omw0o0VHFWTVIrj8Ud6eHNm4Ce3pQgp0ZTAke1gZXfn4JtpQvQrywKpyCWbsiu1LZ1xIMW56DMDOmqhRNN+jXqVbVBnMDrOvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6V365ZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6V365ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90248C4CEF1;
	Tue, 26 Aug 2025 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212606;
	bh=fSC//JZcfqNjjxceabuhKYZKg0/ytUODfn8kAxuiE5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6V365ZOfiiIdQUhZJJYP+6dkWgpI+OI/10VaoZGiP6EOftykT7UBa9cXUNJdzue0
	 5N+KAYrqH3rmG/Vs8MHk7AkdeuMyfbQn/WkgrpFsI9qCLnZwXE9g8/7RmASAAAtjSH
	 51lOFLzhDz2FbsS/qE3JccIAUmEaczXH/sxkh1yY=
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
Subject: [PATCH 6.6 034/587] smb: client: dont wait for info->send_pending == 0 on error
Date: Tue, 26 Aug 2025 13:03:03 +0200
Message-ID: <20250826110953.819783468@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
@@ -1338,10 +1338,6 @@ void smbd_destroy(struct TCP_Server_Info
 	log_rdma_event(INFO, "cancelling idle timer\n");
 	cancel_delayed_work_sync(&info->idle_timer_work);
 
-	log_rdma_event(INFO, "wait for all send posted to IB to finish\n");
-	wait_event(info->wait_send_pending,
-		atomic_read(&info->send_pending) == 0);
-
 	/* It's not possible for upper layer to get to reassembly */
 	log_rdma_event(INFO, "drain the reassembly queue\n");
 	do {
@@ -2053,7 +2049,11 @@ int smbd_send(struct TCP_Server_Info *se
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


