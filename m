Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C9D396ECE;
	Mon,  5 May 2025 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486394; cv=none; b=fG0HGq7eJeB4pNdggCf/aYlZnldPYDdWJQyOQyAoqyXpC7UA6FJU752hCrwBQrIGqf55NgRuPfxJGhU4zGObaR2kIUfJmnCYMjURrD3xiKPSu+Kntje6ZI1Y3Q4TfQvYxswU83/kTdqwneNW+mup7jln9jkWHRaF8KlfxLFwnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486394; c=relaxed/simple;
	bh=quuASae4hE1C53gRPtbWy3TjwALa9FhSqMYG6241Z5I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2gyb6prB4mV/R1i8lMEuZM8CEZKHQtN6Y572IPvhnlPvslF4d59ItATmTCDmiiV4328dhByB6cwvvYuJmYfGowabrIsVVxq4w7QzGoYd5wAtr03K2DlhNxjod0rV1cUMBcEdPd8AeMxGgGD0LVJDXABZ/OJa19fGpHmfl9fxng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OsC4/Z02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OsC4/Z02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4405C4CEEE;
	Mon,  5 May 2025 23:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486394;
	bh=quuASae4hE1C53gRPtbWy3TjwALa9FhSqMYG6241Z5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsC4/Z02OU6Wj2TFg0lcj9MyJz1CVWsMaT7/8znHvumF3AGvvYGnnKsvBkZD6d6M0
	 z95xxxSiFqZ3+uTig/rzfuXSqDdt+5allC1jjsa73xVfKUanHiMj2XNu4KoBHfVkht
	 +/bU9inc6FhcOpdSRZnCfhT5Ueh0VjSZ9Pn6hD+UR0pK1drUCzRi3ckEuA5hAnA/g1
	 VUYRfURFCtL0gGSpcsMb8cGEK2xBNPbH6i4jHZgTJuMJuHBzCLlXzftAnpgBJGskQO
	 +kImAzBjSi1A2a+Nr3UPeCynWSsmKanj6eS4cwOlk2h35JaIpE7gL2CioBvPrQmGEg
	 MClA1O+EQgEew==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.1 005/212] cifs: Fix negotiate retry functionality
Date: Mon,  5 May 2025 19:02:57 -0400
Message-Id: <20250505230624.2692522-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit e94e882a6d69525c07589222cf3a6ff57ad12b5b ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 10 ++++++++++
 fs/smb/client/smb1ops.c |  7 -------
 fs/smb/client/smb2ops.c |  3 ---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 6aeb25006db82..0baa64c48c3d1 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4178,11 +4178,13 @@ int
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
@@ -4202,6 +4204,14 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
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
index 225cc7e0304c2..1489b9d21b609 100644
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
index a62f3e5a7689c..c9b9892b510ea 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -422,9 +422,6 @@ smb2_negotiate(const unsigned int xid,
 	server->CurrentMid = 0;
 	spin_unlock(&server->mid_lock);
 	rc = SMB2_negotiate(xid, ses, server);
-	/* BB we probably don't need to retry with modern servers */
-	if (rc == -EAGAIN)
-		rc = -EHOSTDOWN;
 	return rc;
 }
 
-- 
2.39.5

