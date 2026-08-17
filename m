Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA1B3E5EF6
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968944; cv=none; b=iKzWZErk9Jg2Y+4bTFSY1t9Cb6ZSPIL9lNv/otQKrPBZSd/DImBhc7LFndsSOURUP2RiaBI3PmKBggR0n4sgySF5W0dOjYWU+GH23T4t9ueishoAMwzwBYxYTBLT0vISS8BrD7Kq2xtnrNNiB04flXMAk9FX/Oi2RLVPfMJ5C9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968944; c=relaxed/simple;
	bh=b69AioJq1V13j3QUR+lx5C6tVUQKluL+Zm6IZhWEGJI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cTX/msznGncrs7lSgxd7hMxN/WMQrOh9vet/m6NqtvW3QTH8nulrHNBQwtERLb7sH8swGzRxS3IzVDN4+77MNqm4ckH4sDG3tr/NQiWzjDubfL3QTphBZvhlNnGSwtqzrGmy+6e1cWPj9ENQZ2/mHp/VFsM1yCV97PfMsL40LBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kotzc1Rv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kotzc1Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D241F00A3A;
	Mon, 17 Aug 2026 12:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968943;
	bh=yemK62qmnIEy0d3mb4LmxSllrCpNQ6mJRiZzQFsRAd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kotzc1RvdKI6sY5QwSdNGZLSGKitD8rAkVY+bZKb06Gjv8d5OxUXWKRXh6r9/H/RM
	 23HikXE0Len3l3uvOBYMs5P9IBiLUOaRfMzlGYilAWf/yyywX/0RPMFpZPdcr1rLxF
	 eRiqBDxt5NVev+o6CesstjKel+CTpvTPtP20Nql/FKfHbdB9dbN+/wxaTRmC+O3tyw
	 BrCH9fpflKSz8g4PqTy0zRF8apa5WKWqEbEkel8ta5z4mhkzi1wRHCdCA6gJry5fTD
	 Yd+FSqSx1TCr/d9rG5CF/t/OEoJL7ACU4Ng/finkW6jHWHKZL2che7vPJbJEso6UpD
	 jbRwpVlObm6xw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix encrypted request lookup on bound channels
Date: Mon, 17 Aug 2026 21:15:17 +0900
Message-Id: <20260817121524.8812-5-linkinjeon@kernel.org>
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

An SMB3 multichannel binding registers the secondary connection in the
session channel list, but does not insert the session into the secondary
connection's session xarray.

The decryption path only searches the connection-local xarray.  As a
result, every encrypted request received on a bound channel fails with
"Could not get decryption key".

Use the channel-aware session lookup for decryption.  Also stop using the
temporary conn->binding flag to decide whether the global lookup is
allowed.  Validate the permanent channel association under chann_lock
instead.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/auth.c              |  2 +-
 fs/smb/server/mgmt/user_session.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 2f89af029247..bcd371f5550d 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -729,7 +729,7 @@ static int ksmbd_get_encryption_key(struct ksmbd_work *work, __u64 ses_id,
 		 * that the command can reach the session setup handler. Other
 		 * commands are rejected there with STATUS_NETWORK_SESSION_EXPIRED.
 		 */
-		sess = ksmbd_session_lookup(work->conn, ses_id);
+		sess = ksmbd_session_lookup_all_states(work->conn, ses_id);
 		if (sess && sess->state != SMB2_SESSION_VALID &&
 		    (sess->state != SMB2_SESSION_EXPIRED ||
 		     !sess->kerberos_expiry)) {
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index f4675c457714..31eccad5d732 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -551,11 +551,18 @@ struct ksmbd_session *ksmbd_session_lookup_all_states(struct ksmbd_conn *conn,
 						      unsigned long long id)
 {
 	struct ksmbd_session *sess;
+	bool channel_found;
 
 	sess = ksmbd_session_lookup(conn, id);
-	if (!sess && conn->binding) {
+	if (!sess) {
 		sess = ksmbd_session_lookup_slowpath(id);
-		if (sess && !xa_load(&sess->ksmbd_chann_list, (long)conn)) {
+		if (!sess)
+			return NULL;
+
+		down_read(&sess->chann_lock);
+		channel_found = xa_load(&sess->ksmbd_chann_list, (long)conn);
+		up_read(&sess->chann_lock);
+		if (!channel_found) {
 			ksmbd_user_session_put(sess);
 			sess = NULL;
 		}
-- 
2.25.1

