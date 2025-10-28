Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC1734A3AA
	for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673449; cv=none; b=QfinNCtY+ffSvnNyTBfyF7jODKaDjRNqLQmkLz3yih7JUhLHPUBovkkPKY/yii6OmRk01kcixxKCR5W8aN1iIGqhe8TQcXUWVAmfXKSBRqQ1c7vNRGcVi8yBvpcrYbqnH2ZtH/2WfQbLMiYlA6cE+ZludHyYFBQ2qNGQnpe4yiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673449; c=relaxed/simple;
	bh=hxGejzQTOSr5ZviRcRY0xxFw831uESh1M0jNrjgt26o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M7+xkBynVy7VwoNKAeOHQujHxrA8nK2pT1DlBEn61/spIuEOtuLGHNyz6kqpkEloH7tpyyRdEjg541IKGeXAvSpaLYz087zUFV/P/UoNBbbxJpmJLKypW9ayGck9H+dIalycPsbb/oLdLkBhsXCeWH4/XUBVFfrmG4kH0jYwAGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jd5Dwqt+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jd5Dwqt+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=vaSEz0xi2rODa315BDn6GyJ2sDUw6WlXsoYvDMbS+l0=; b=jd5Dwqt+79YRShV11YjOvv0vZm
	VOAvhboWRUuYtHGFpY53x71bRO8NYtDipDvqKmcezUDSeO4QGsw74ychx/eeImwYV8KzxCm3bVJNY
	N7Pz5wD2sxhlLayBcC9yr/3fPFy06YO6PR3oqnaTYkhnsMwUg5J09pVHLDskP+SVVl+FBqSigc8Lx
	NhGlbtAhtTzT+XjonHiO/jQUwCl8BAqEPkH1dfJvMv60xmpi/LCuU3uXjJ0BpxB04NeDs61alkReK
	VJplcojfu1Ci3yDuzfLQmH2ZroNo8X/2gCEKHznC30FkGjZPpWU7qrb4M5K3YzT3ixCTad933Q61I
	CIl+NSDp07EpZgcngOpCFT5G5asWM9L8g27Itnk4iYjtmcnwlMN12xyY1LLnzkYDzIFXl6lxGbLwB
	7eoSrFakq1/6VY53RGs5oirQPrux5sM1Tg4lPUFJbcIQTalZGe2sqWGvwA0yyNYg+iJJCnqbfJmLR
	xm87K0Ntbh9HfRm+aE/UiruL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vDnji-00BSvP-0L;
	Tue, 28 Oct 2025 17:43:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: client: call smbd_destroy() in the same splace as kernel_sock_shutdown()/sock_release()
Date: Tue, 28 Oct 2025 18:43:46 +0100
Message-ID: <20251028174347.1800568-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With commit b0432201a11b ("smb: client: let destroy_mr_list() keep
smbdirect_mr_io memory if registered") the changes from commit
214bab448476 ("cifs: Call MID callback before destroying transport") and
commit 1d2a4f57cebd ("cifs:smbd When reconnecting to server, call
smbd_destroy() after all MIDs have been called") are no longer needed.

And it's better to use the same logic flow, so that
the chance of smbdirect related problems is smaller.

Fixes: 214bab448476 ("cifs: Call MID callback before destroying transport")
Fixes: 1d2a4f57cebd ("cifs:smbd When reconnecting to server, call smbd_destroy() after all MIDs have been called")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/connect.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd12f3eb61dc..61b693ed7126 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -310,6 +310,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 			 server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
+	} else if (cifs_rdma_enabled(server)) {
+		smbd_destroy(server);
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -338,12 +340,6 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 		mid_execute_callback(mid);
 		release_mid(mid);
 	}
-
-	if (cifs_rdma_enabled(server)) {
-		cifs_server_lock(server);
-		smbd_destroy(server);
-		cifs_server_unlock(server);
-	}
 }
 
 static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
-- 
2.43.0

