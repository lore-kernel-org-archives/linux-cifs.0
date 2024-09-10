Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D29A1B372E;
	Tue, 10 Sep 2024 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725988970; cv=none; b=f+yv3f9mRdXSLaj5gLYf7rBked+X7vKzHvvmzQ6qcqt/iI18Dbe4RY9a7KUscttqd+i4QBZ5zKgAbVjYyVMLc2ml54If5BTuH0QwPnb6mKI7w61GEbVCILP8bKBty5raw3Mp1RFggYs9xpwa0YUguEJofZBJsm8/OMGH/QQ/KR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725988970; c=relaxed/simple;
	bh=PeLBCaC4W0vGegOjs1rbN7MoUicwWj/JzycTr/0ekiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiipgvjGhaUQo5w4PLqMLwvHgRNwgvGs4sXzVnzL9fNgJSpO6xVzt95KzzSV4SU1gHnsM3hCiPxuHeI7HitrM36MO4SbX3x9TkTD7DqIcOe57xTndmjXY7C82Eo2o4sfSck+6Rpi8XxUZMjs2Xb/uuVr9M2MqPsi4Dvn9c2VOjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBCRJG0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBCRJG0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE300C4CECE;
	Tue, 10 Sep 2024 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725988969;
	bh=PeLBCaC4W0vGegOjs1rbN7MoUicwWj/JzycTr/0ekiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBCRJG0JPCdv5YrpgBRwVCybHRErWcFE8TszHVpFDtgJhWgszCmf/VEXBHD0oEXeo
	 0cg/CAe2g+4KKKmWWaYP+2r7DWH7yJIc31SlqpWGkgf2fJDLgdtjqLv5xl8WjVpR96
	 8PUskAmm3lHpFBoVup0IYTA+v0XtRCIteafqBon8T7DV06DLrcWwO36WMz3aXUoevv
	 V9G0LUZv4JZy7YGAjEzOqGEu6wn4BkBN8qqtmeAB/h6HcPp+HAj97IydpszptR9mEz
	 ObpLV4MgPlotBWk3ousSIcsyN89+Xi0bdEpebJev2sok8Ry3wt7kZpgz+pq97t0o9O
	 kPLPu0ZBYNS2Q==
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
Subject: [PATCH AUTOSEL 6.10 16/18] smb: client: fix hang in wait_for_response() for negproto
Date: Tue, 10 Sep 2024 13:22:01 -0400
Message-ID: <20240910172214.2415568-16-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910172214.2415568-1-sashal@kernel.org>
References: <20240910172214.2415568-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.9
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

