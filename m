Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA273C197F
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968954; cv=none; b=eaWu8WBOnnMHHVat3HwxplgSu4e/n5uxt6CiS+ZziZ8JVNesKujSilhAUCMAwXS6IntHUzPzGiFqcLeE38RJUvWUv1SPgoOw21vl00Cg0khF+Lf/F3BfT//bWcgwWCZvUu6dydeL3weBV80wL9HtZBNi/OieyWQU8GVS0sWluTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968954; c=relaxed/simple;
	bh=FsPeaZsYT2w7aX7nZaFrH1L6jXSSAw7kEcoCxbBbND0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QSAKeRzYe3kYV34HmgnMBAzZqTqp937W1BbzF5ckjgUYcTjErAUZMTdRfnUjskFeKp4daV+FaPX1uqU1tR7nFWMyJLUKvxVpg1CWBR+PjFH5oF7iWHUvnSUhKrcoxM0i054HmfqQLFRzu+JvudhkYkYjhhxkSoQLXzFAreW/cXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSNovPMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSNovPMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04431F00A3A;
	Mon, 17 Aug 2026 12:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968951;
	bh=3T2JTAt0ZAyMeSLvwtU4b1VuvUR2/mHDUis49n6oP+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSNovPMy9aY3z0hrKcNTNKHf8OZUiSNorMgRQSCIfg3RgmSzg53JEWj+STOGXaDq+
	 4MNqTE2oQbIwiM6m0Y7V48oili/ub/blzOcSLUl9YEmW5PHcZZDKMyGzju2oqc+TLv
	 gzJ2CE4vSFsUOBVK5RJsd3DzeCfum//rae3ZIpLVHwqK59pYKmTr/rKw3Qt7FUrKeb
	 obex0nt+QokEDIXA3td9BiJAEZYZJcGmteOU5pI14T1YhULlnzyhLB4XY6h+Zfu12N
	 AjuyuW1BrNXzth+wbSqb1jUniNZlXtgh7DeLh6tEda2PAEKQfKxUKNGy2N5mG5DKxW
	 yhwVSnnBlru2A==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: decrypt requests from expired encrypted sessions
Date: Mon, 17 Aug 2026 21:15:21 +0900
Message-Id: <20260817121524.8812-9-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous-session replacement marks the old session expired but retains its
SMB3 encryption key. An in-flight encrypted request can still arrive on
that connection. Rejecting the expired session before decryption made ksmbd
treat the request as a key failure and abort the transport, causing
reconnect failures.

Allow key lookup for expired sessions that have encryption enabled. Keep
the session reference during validation so the normal
STATUS_USER_SESSION_DELETED response is encrypted with the old key. The
session remains expired and no command is executed.

Fixes: fa9415d4024f ("ksmbd: mark SMB2_SESSION_EXPIRED to session when destroying previous session")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/auth.c    | 12 ++++++------
 fs/smb/server/smb2pdu.c |  8 ++++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index bcd371f5550d..78491b20897e 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -724,15 +724,15 @@ static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 		sess = work->sess;
 	else {
 		/*
-		 * An encrypted SESSION_SETUP request may reauthenticate an expired
-		 * Kerberos session.  Keep using the established decryption key so
-		 * that the command can reach the session setup handler. Other
-		 * commands are rejected there with STATUS_NETWORK_SESSION_EXPIRED.
+		 * A previous-session replacement leaves the old encryption key in
+		 * place.  Use it to authenticate an encrypted request, then let
+		 * session validation reject the expired session.  This preserves the
+		 * encrypted STATUS_USER_SESSION_DELETED response without reviving
+		 * the session.
 		 */
 		sess = ksmbd_session_lookup_all_states(work->conn, ses_id);
 		if (sess && sess->state != SMB2_SESSION_VALID &&
-		    (sess->state != SMB2_SESSION_EXPIRED ||
-		     !sess->kerberos_expiry)) {
+		    (sess->state != SMB2_SESSION_EXPIRED || !sess->enc)) {
 			ksmbd_user_session_put(sess);
 			sess = NULL;
 		}
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ade16532a8c1..8d06c934f24f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1012,6 +1012,14 @@ int smb2_check_user_session(struct ksmbd_work *work)
 				1 : -EKEYEXPIRED;
 		}
 		if (work->sess->state != SMB2_SESSION_VALID) {
+			/*
+			 * Keep the reference for an encrypted request so the caller can
+			 * return STATUS_USER_SESSION_DELETED encrypted with the old key.
+			 */
+			if (work->encrypted &&
+			    work->sess->state == SMB2_SESSION_EXPIRED &&
+			    work->sess->enc)
+				return -ENOENT;
 			ksmbd_user_session_put(work->sess);
 			work->sess = NULL;
 			return -ENOENT;
-- 
2.25.1

