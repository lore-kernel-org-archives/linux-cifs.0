Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F8A72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046167; cv=none; b=RnWtcDO0twF8b6MeHPvnKwG4CzVUY79ALmsiPmFglwI9uD7pJlKVdKHkgycwJKGUNn8WtnYG97qkRnYiQfKwjfwg7bm1LbqFb26MV6OXUAV8zAwzASBQgVWPNeCgnydClmIG5JDwZRWZe9jT2hpymyzx92dqzPV45WcizkAAkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046167; c=relaxed/simple;
	bh=WbBnNote1vFp3oglQrkScvy+W7xw/MNFlYHpBY2gNz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g+TC5xp5MQ9XwLwc5NLKr8ReUo5F/VmJwYwM7RLh5d0xX8OyxZiyxSL7H2UXl2w5oVJi9malj4UiCd3gayhzSx8jgqZxWx1xCjz4LPT9o9ek9KE9Fzf+tmRv1TbzhxaazG9Cddi/jNJ6H1HlwQv/wiVIqyjwc+0UU13QE+ihaBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRu97hNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRu97hNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86151F000E9;
	Sun, 21 Jun 2026 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046166;
	bh=8zbxTIrVaFm8WLH9w5BIKDt/wX+2agIYw1rkAeGhSt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRu97hNxxZNJsa5OFkOk4cDyXZ6NAbmd3Y0aSPZyOFUecUumBcSFABHYPzFZoPVfl
	 2DnHQF2q2MrrxOIdsL7T8xqyxAZy7Ggv1MNlmH4U8lhJOUE6FSX5umIWfefg+hYFpv
	 enCv61Za20tZW8+XCbkJie+vZGh5PojzTZkJ3bQK/o9+yXQz6hGiQDXQrBrq3/h1c3
	 ftRGPM0+excqC0irJLh5PlwpGJGwvNFqvhViB8nSI3+2YBJNN9s5AjaAEGHAVEj4Ld
	 se+Av7dJknEPP9s4H2ye1B4jxDqIKGR29A/mkgZkDkQ9fUeh3dDZN9xikDqodkkd+z
	 P1VUETW2mdDfA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 18/29] ksmbd: apply create security descriptor first
Date: Sun, 21 Jun 2026 21:48:33 +0900
Message-Id: <20260621124844.6235-18-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2.create.aclfile creates files with an SMB2_CREATE_SD_BUFFER create
context and expects the resulting security descriptor to match
the descriptor supplied by the client.

ksmbd currently tries to inherit the parent DACL first and only parses
the SMB2_CREATE_SD_BUFFER context when DACL inheritance fails.
If inheritance succeeds, the explicit security descriptor supplied on
create is ignored. This breaks create requests that include owner/group
information in the security descriptor.

Apply the create security descriptor first when the context is present.
Fall back to the existing inherited/default ACL path only when no create
security descriptor was supplied.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cca04bf84b81..526d5be97364 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3651,14 +3651,16 @@ int smb2_open(struct ksmbd_work *work)
 		if (posix_acl_rc)
 			ksmbd_debug(SMB, "inherit posix acl failed : %d\n", posix_acl_rc);
 
-		if (test_share_config_flag(work->tcon->share_conf,
-					   KSMBD_SHARE_FLAG_ACL_XATTR)) {
-			rc = smb_inherit_dacl(conn, &path, sess->user->uid,
-					      sess->user->gid);
-		}
+		rc = smb2_create_sd_buffer(work, req, &path);
+		if (rc && rc != -ENOENT)
+			goto err_out;
 
-		if (rc) {
-			rc = smb2_create_sd_buffer(work, req, &path);
+		if (rc == -ENOENT) {
+			if (test_share_config_flag(work->tcon->share_conf,
+						   KSMBD_SHARE_FLAG_ACL_XATTR)) {
+				rc = smb_inherit_dacl(conn, &path, sess->user->uid,
+						      sess->user->gid);
+			}
 			if (rc) {
 				if (posix_acl_rc)
 					ksmbd_vfs_set_init_posix_acl(idmap,
-- 
2.25.1

