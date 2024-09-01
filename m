Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B51DFF7
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 01:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725155657; cv=pass; b=eTeIZaa1plarTzGe+25UMwyAo8PMpmz/npBMbf90YBimNEcDKklmvt8Gq9OBKe3ZOeiBuoDk3yWp/adVVenoG32eCX8waaVfs4hdMYgvzrmdj1Ic8uNij4swstHLBsAr+1n8qZ4qnfknsYiVSVP7b2VTpVnohG2celeKgBF/3pY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725155657; c=relaxed/simple;
	bh=TWc/uBAW7m5JD/emjAzoJMVGlWc6ZV2IBNXI0vgyUU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n7AO4+pCNwpKYF7aQynvZs7peGgkHGs3XyvxqZQ1Q8c0rI2O0hLgYJzEDOKNaiJbw1ss+c/86dzu8YJQ0yywF5JPYJqISejEub7M7Okfy881hMJ72MDjv5DevG0QiaycoaZmPuhAOvcWptjpq/OBPX48Qav2rhGWQoA7XHmpXhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=jqJ0KF1B; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="jqJ0KF1B"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725155264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=14sBLQJP0hgzUx8CZqjewTPIl/dbCSF8pLh/5ViqPpM=;
	b=jqJ0KF1Beb8atXi4DiprpHXgRHUiESY9TIjig3f+0cMcm332gCZkbKI3JhUwO28Qgt9i2W
	GaQt5uogXx5r5e7WIgvjW4x6bUO77S3T5+DIQiK5ZjHAFs0cnYivuxFSZUXD4qBIQUCx9m
	kybYWpB47S7F1I+aguc9PeZ+/awinNJ6Kfp595rJHxk+JM6dR6jRiFf62RgH0pfylv3Xbu
	sxtq8hAnL+KA/l0JYujZeFlWs2gIuPLZ7xj+GCVQeQPEPhIjliIhBi2ujFYs7PiA5frGSK
	c/zOArbccS6vYo/NeWQQVvMhrmnX+1z13ZWQifmCMRwCGlEMG1fgLuofzFGKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725155264; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=14sBLQJP0hgzUx8CZqjewTPIl/dbCSF8pLh/5ViqPpM=;
	b=bsCttmRd7OQNwawCXu7MssISszV6n90CIHlZeyuUZGV1bt+d7oRWdNC4UEmE/wroqmBF//
	JMGqCkpRlwe35gYp5H0ibm53wlUpJxC6KoNMwV/bnnWZfiJ1JUFia8jqzlk2qQ5JnClDrA
	e83U7JAFuiI2NN/3JA5tHnrfquqBeUsz3/asNaIDjrQZtxyXruMKvlfclbHjh/lHiBdplU
	TK69mugUbHN2r5yRIyz0IdMEQc8bbPFuGqsxbrqdfvWmNu3Bey7UaaDL0sOxKXroZgSgtS
	NNFZbZukEw0JLwbEOiTznaUx4cALtMgj4Rsi/edVZ/yC7xoo6zUPLnRMIXO6wg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1725155264; a=rsa-sha256;
	cv=none;
	b=RVdIo11b6kWBOcr31lHVme+6bZycHheBRHlGY1fP2wmRmOMknBYkT5nAUu7eN+RAbwP92h
	uhIs2NEmIemLsJL9lb/t+whCMfaDVZ4P6x1B2Dd9EhcfMVNAUH52ozG5zB3iRPwUZAk+Dg
	0cfA1Y7CEZwpZmZiLiMwB9DNpYur5FTwsVx/BLcqznFJeNb+Z5erC4ADNFJ4cmHe9gG8XR
	u+PwNKCQRIlEu7JCO3SRbDD/XSeQQH6c2ov1a47NtgeA7+voUbessYHkaTi4WXTnuAW02T
	B8Qs6f2/o/6lPBhF6zNsxo82ryNI/B2clp6boCPKMfeujnuxC+1oqp5e6/otkQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Rickard Andersson <rickaran@axis.com>
Subject: [PATCH] smb: client: fix hang in wait_for_response() for negproto
Date: Sat, 31 Aug 2024 22:47:34 -0300
Message-ID: <20240901014734.141366-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Call cifs_reconnect() to wake up processes waiting on negotiate
protocol to handle the case where server abruptly shut down and had no
chance to properly close the socket.

Simple reproducer:

  ssh 192.168.2.100 pkill -STOP smbd
  mount.cifs //192.168.2.100/test /mnt -o ... [never returns]

Cc: Rickard Andersson <rickaran@axis.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index c1c14274930a..e004b515e321 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -656,6 +656,19 @@ allocate_buffers(struct TCP_Server_Info *server)
 static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
+	/*
+	 * If we're in the process of mounting a share or reconnecting a session
+	 * and the server abruptly shut down (e.g. socket wasn't closed properly),
+	 * wait for at least an echo interval (+7s from rcvtimeo) when attempting
+	 * to negotiate protocol.
+	 */
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsInNegotiate &&
+	    time_after(jiffies, server->lstrp + server->echo_interval)) {
+		spin_unlock(&server->srv_lock);
+		cifs_reconnect(server, false);
+		return true;
+	}
 	/*
 	 * We need to wait 3 echo intervals to make sure we handle such
 	 * situations right:
@@ -667,7 +680,6 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
 	 *     a response in >60s.
 	 */
-	spin_lock(&server->srv_lock);
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
-- 
2.46.0

