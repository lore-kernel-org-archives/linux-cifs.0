Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335E31BB69F;
	Tue, 10 Sep 2024 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989008; cv=none; b=ZRnRWX1E0yuEGxdwEKY1U/0PHmejYTUmeEw54nl2mlWEOLvX8WgxRnJfjZqsDMJTrNNzIDzHgD4gfXDqPO27cfPnUBI9RnPGbx5K8p5pRVU5HFkqgj/k9TzTYqqcN7qKqGGvxQ3KexBvp1jlB9T7CnNTTSdSztVgtHdBxx8NUYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989008; c=relaxed/simple;
	bh=PeLBCaC4W0vGegOjs1rbN7MoUicwWj/JzycTr/0ekiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUAn1VieBf8Hbqn1EZPoY4HPQUj8ht6kVyouer3djgVuAQ9UnnijGkgMc/jainjiqJxlU6cEcR+UASLmwSH/5NVuIOpKLWevvDF3tssG80UcYWU6NoX8hS0p3GFJkLDiGmhNoYARsia3N/qOFHqG7XusuYa4AnmamJBFGG5nSB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lreYfj9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lreYfj9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7047C4CECE;
	Tue, 10 Sep 2024 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725989007;
	bh=PeLBCaC4W0vGegOjs1rbN7MoUicwWj/JzycTr/0ekiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lreYfj9KBc6ISby1KdAVbSpIJvd956ilwZWyTh1138uVQmoRMjeKQObGNtmDVmfbv
	 Kww0QGjlHvr77qhNNcQJZUczR343ehqSgmPAHc10jBzJ5dEuBSGThCWrZ2ETwXPcmb
	 UM3WryjfX1ekO7DwJ6wFIChjFQ3s3kRbHV1pUkMw7K/rZBNTLBmTvZ5Fc/qtKadpFc
	 EGaKKrZNfdk+5FjRKmZlvlME5bLKDcVi0oqEVR8xR2S7UeHtvpZt0cuJNbhZKQJ78h
	 A6s0ZtQHcYQuupTAzE54+3CHiZttpuk73GsqSD5TQIckuQhq2boN7L6ZCjK3aSR3EC
	 DTGPkkGOxLdvg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	Rickard Andersson <rickaran@axis.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 12/12] smb: client: fix hang in wait_for_response() for negproto
Date: Tue, 10 Sep 2024 13:22:54 -0400
Message-ID: <20240910172301.2415973-12-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910172301.2415973-1-sashal@kernel.org>
References: <20240910172301.2415973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.50
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 7ccc1465465d78e6411b7bd730d06e7435802b5c ]

Call cifs_reconnect() to wake up processes waiting on negotiate
protocol to handle the case where server abruptly shut down and had no
chance to properly close the socket.

Simple reproducer:

  ssh 192.168.2.100 pkill -STOP smbd
  mount.cifs //192.168.2.100/test /mnt -o ... [never returns]

Cc: Rickard Andersson <rickaran@axis.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d2307162a2de..e325e06357ff 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -656,6 +656,19 @@ allocate_buffers(struct TCP_Server_Info *server)
 static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
+	/*
+	 * If we're in the process of mounting a share or reconnecting a session
+	 * and the server abruptly shut down (e.g. socket wasn't closed, packet
+	 * had been ACK'ed but no SMB response), don't wait longer than 20s to
+	 * negotiate protocol.
+	 */
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsInNegotiate &&
+	    time_after(jiffies, server->lstrp + 20 * HZ)) {
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
2.43.0

