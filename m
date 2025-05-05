Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B71534AA80;
	Mon,  5 May 2025 22:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484775; cv=none; b=FSetCZBI5MAuDscHITWy4k3EFghCMFge1tfBnQBikb0xMvd6wyWVRlw92+7kGuqsGVd5p5Fj9gMSqtSxaokX+Uicn7q3EgASPyic8iZ5jWkxIEF/oGmxHsuubJyzEkQ9BPDx+7wTvxUClpMNVS/B8GLDSLBfeng1NatRZJj+RwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484775; c=relaxed/simple;
	bh=Up7GBGn+1JQjRWAGIiLexWJfhifSBLS3crnTV7sudA4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VAFJiz8Mb/4yUGWUTJi4lp9pHROD2eDTQah71w58w3Wplq5xmpsIKFrdmxiGqy8hZSa0n/NQmzk2tSOC3sEFpYP6o3L0Nq1bRTtU/MMg7mR87Yov+RsVYKAKQMJjvN+8YzNuR3bJKi4Jm0PQuZ+fxOvynueVqhB4FHWtSmNS3RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsdB4LBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsdB4LBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB5BC4CEE4;
	Mon,  5 May 2025 22:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484775;
	bh=Up7GBGn+1JQjRWAGIiLexWJfhifSBLS3crnTV7sudA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsdB4LBjbVEj/b3eM8hsecQg9l91fiwKKZelscl8MI0N6UCCzEFUzpq/yMcHBjeFY
	 wsrs/fv7ZAtKmUJTeaeMmnwJPCMYWz2VjZ1Rt5pY/7Cpc5ajxZp1xa8SF2Lj65k+U5
	 5Okw4ECzQd6MojsbnJ7mAOpz42CfRZz9EM3v8PVi1D2KbNLUIGHaRnKIw5UBa6JppA
	 hPHU6zvkE36BxYN8KqcWM3vR4wRq3Ek79vdeQtavA2/oCufsQ1o39mn+PzcJhSKOLB
	 ncWq1VZZ0JXj0BVCcZ00vuBUkUbMBLmb/jaHjePsuse7cADiJEMk8CzpA1Q4e5ay3z
	 IUiygiw8RpJKQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 006/486] cifs: Fix negotiate retry functionality
Date: Mon,  5 May 2025 18:31:22 -0400
Message-Id: <20250505223922.2682012-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index d5549e06a533d..1a0748fb16dd5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3937,11 +3937,13 @@ int
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
@@ -3961,6 +3963,14 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
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
index 55cceb8229323..a2dbebd13720b 100644
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
index 590b70d71694b..ff50cdfde5fe4 100644
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
2.39.5

