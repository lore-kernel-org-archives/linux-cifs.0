Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7C1BF80D;
	Tue, 10 Sep 2024 17:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989028; cv=none; b=V6j1bq0JucQ+XX/phVZsUSkWwyURpky02rt89sKZAaa7N0p06z9YIqPruSlv/di1hropJibTv5gO6N/0ukeJa0Enhsr+tC8Zz0h9cEgOGcg+JGVeTaFWSAfrhUOJDgsb8MMCTS/2g6hon/AT/JQykjow+iEgg3neCYEYfqi47N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989028; c=relaxed/simple;
	bh=2HpttHegFA1bFFguN7zA8hJD4HBGeNlLW2d3dWxNu3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDF/rxsUs7mNlCHHdH6aJRbazRfqcbxayGxCkHm605GZ6ZSZ7zRi9ci/UA8bEB75DM1Mjb937iVu45ogUBh2nM3kPHNj33K+r/PDOqaZF0vOursF1wOglWz7GvjEA+rgY8YiOBytx5PfP/Paufuc5Dvra9W/t4hq9aKiVXcQov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EznWeSZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EznWeSZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B616BC4CECE;
	Tue, 10 Sep 2024 17:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725989028;
	bh=2HpttHegFA1bFFguN7zA8hJD4HBGeNlLW2d3dWxNu3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EznWeSZrAG8me+2EPEvTxrjmF88CL0JWmuenYOV7TtVFf4SH8DHPusMnn5tr5jIkS
	 0bHKrYQ8CypL6ywxZwvAjFq/6+4RFB+4JhhOaxw46Qh0IhFxxQEkg5jEMBr8oALMo+
	 uh/wQdc8ijo+B6a1MyvWRH73bkKp5fOKk38G/dGxhZWZCtXCrhxWDQKVeZODcOfA2u
	 hMJZ4KWI9HM2XCLxpuKLWIqlgK76XO0lSbKj/FJgs3ytYR9zdBlTydgmr8n1Oq2eqR
	 VBPfT68iJP/kVn6QNqQxRh+YUdqD0wCg6GUsIG3TXlZuSUoqGVtEkfPJsmlyO26Gj0
	 UsIIiaXVbWCKA==
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
Subject: [PATCH AUTOSEL 6.1 8/8] smb: client: fix hang in wait_for_response() for negproto
Date: Tue, 10 Sep 2024 13:23:28 -0400
Message-ID: <20240910172332.2416254-8-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910172332.2416254-1-sashal@kernel.org>
References: <20240910172332.2416254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.109
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
index 21b344762d0f..87ce71b39b77 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -673,6 +673,19 @@ allocate_buffers(struct TCP_Server_Info *server)
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
@@ -684,7 +697,6 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
 	 *     a response in >60s.
 	 */
-	spin_lock(&server->srv_lock);
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
-- 
2.43.0

