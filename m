Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D46191494;
	Sun, 22 Dec 2024 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885098; cv=none; b=C+fc5PQPiVSgA1W9ukjyCJpjdunxZOHcw1A0Z5LdaLFiw8WsGduaFQxipXaEdLcEbJpSet9HmCP+yRB6hKo7+65l+oUJQzG7VLMYcY/UoaaLrD4kTDI6VLzpQdRuFuAjObX73XCSprG+evLIudganzXz8rCsQ5a14ZoUL5NcI08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885098; c=relaxed/simple;
	bh=NRRD2uElNzPne/pT6ZpTaz7mf1/D4UiWgY+uhccv2l0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DiV6B+CR3NvlWT+eHLJowe/djC8s2MZ6rZWwSmto8+4je4dp12G5vL3uWNnItEpEjgibZAmevtur7CJxW8JzGYrOLKg5ni4ehN/2pz8hu4BCdJ6e63aGYYS7l8Iezv9kTDF0bcvMEXKlrHdLpLx69SaPobgGw2T5Q0nFSo/0cP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uGjb6QIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uGjb6QIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06F4C4CEDC;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885098;
	bh=NRRD2uElNzPne/pT6ZpTaz7mf1/D4UiWgY+uhccv2l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGjb6QIJzmtCS6Us5/vgHCRG5Vs9dxlv4AToOib9mD3SIXRdvR6XXFKJb3oLxZVuC
	 lIEL7sZYw5YHL7vESYxduYa1VDkxVeerCoK11RZEgdab2KmAcxVCu2KBQq9wITvHAD
	 6bSz76yqRJH8EqkFPp3RKMRXfpBqo653tV3z1EsvU6ZYEMuBHaFPAa0njELHdqtMUF
	 emL+C6H5cLCLdkhoX0/YEmg+j1JvTPyVfj1fPKFrSRemN1H6asA03Ren29YLTJ42SY
	 66Twz/m2FFOLiZS5lHXxHHzKOcYX2D4+GdORmAGYpDL7J+CUlmJ6S7fp28UMk8WWtF
	 DQsDtUeNu3icQ==
Received: by pali.im (Postfix)
	id BC88EF38; Sun, 22 Dec 2024 17:31:27 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] cifs: Fix negotiate retry functionality
Date: Sun, 22 Dec 2024 17:30:49 +0100
Message-Id: <20241222163050.24359-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222163050.24359-1-pali@kernel.org>
References: <20241222163050.24359-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB negotiate retry functionality in cifs_negotiate() is currently broken
and does not work when doing socket reconnect. Caller of this function,
which is cifs_negotiate_protocol() requires that tcpStatus after successful
execution of negotiate callback stay in CifsInNegotiate. But if the
CIFSSMBNegotiate() called from cifs_negotiate() fails due to connection
issues then tcpStatus is changed as so repeated CIFSSMBNegotiate() call
does not help.

Fix this problem by moving retrying code from negotiate callback (which is
either cifs_negotiate() or smb2_negotiate()) to cifs_negotiate_protocol()
which is caller of those callbacks. This allows to properly handle and
implement correct transistions between tcpStatus states as function
cifs_negotiate_protocol() already handles it.

With this change, cifs_negotiate_protocol() now handles also -EAGAIN error
set by the RFC1002_NEGATIVE_SESSION_RESPONSE processing after reconnecting
with NetBIOS session.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/connect.c | 10 ++++++++++
 fs/smb/client/smb1ops.c |  7 -------
 fs/smb/client/smb2ops.c |  3 ---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9a76cdf71086..fdeeb0b9000d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4206,11 +4206,13 @@ int
 cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 			struct TCP_Server_Info *server)
 {
+	bool in_retry = false;
 	int rc = 0;
 
 	if (!server->ops->need_neg || !server->ops->negotiate)
 		return -ENOSYS;
 
+retry:
 	/* only send once per connect */
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus != CifsGood &&
@@ -4230,6 +4232,14 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	spin_unlock(&server->srv_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
+	if (rc == -EAGAIN) {
+		/* Allow one retry attempt */
+		if (!in_retry) {
+			in_retry = true;
+			goto retry;
+		}
+		rc = -EHOSTDOWN;
+	}
 	if (rc == 0) {
 		spin_lock(&server->srv_lock);
 		if (server->tcpStatus == CifsInNegotiate)
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 01a7d6b23c7e..0533aca770fc 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -426,13 +426,6 @@ cifs_negotiate(const unsigned int xid,
 {
 	int rc;
 	rc = CIFSSMBNegotiate(xid, ses, server);
-	if (rc == -EAGAIN) {
-		/* retry only once on 1st time connection */
-		set_credits(server, 1);
-		rc = CIFSSMBNegotiate(xid, ses, server);
-		if (rc == -EAGAIN)
-			rc = -EHOSTDOWN;
-	}
 	return rc;
 }
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 50adb5cdfce9..119ecb6641d1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -464,9 +464,6 @@ smb2_negotiate(const unsigned int xid,
 	server->CurrentMid = 0;
 	spin_unlock(&server->mid_lock);
 	rc = SMB2_negotiate(xid, ses, server);
-	/* BB we probably don't need to retry with modern servers */
-	if (rc == -EAGAIN)
-		rc = -EHOSTDOWN;
 	return rc;
 }
 
-- 
2.20.1

