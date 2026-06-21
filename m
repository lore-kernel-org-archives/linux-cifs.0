Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC37672621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046133; cv=none; b=nHnMi8BMae4I29EKdJJ2B+vuRLBlrSv1KDffJgcmFeOU34A1rDQpNhWZI5hLLb6e5qfvmCR1/em8dP9CX2ZgUiCEcnIXmFWBaSU16S6L7TCmHRlSkBm267MTy2LZ9fo2IEeP8VqL4VvZIKRYcVVOzg+hjyeWPoIFCfA1b11KHLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046133; c=relaxed/simple;
	bh=t4KcybIvGVRwhf/qxZNVdglx3aujRyshlABy/Wzv5Rc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bb4A1LIs0H1sPf1rWICGwFpuvkT6hHM5noRQouxJuo7vDeegGycWTDZgXjnl+y2wW2Sk4w1OZx5YZdRhjbIMSd7xCXcO+sdub3BloVMc8uMAFnufbmczoXTl6xUz82o2jfxsfvoR3UxvBkyRPZH6GL55qiA2yg32ccfJZu+jCxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qa6rZZ1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qa6rZZ1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DB61F000E9;
	Sun, 21 Jun 2026 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046132;
	bh=KEKs0CzZoBZL4Sf08qkvp1KHJioVi3v6Di3qF4QEOKU=;
	h=From:To:Cc:Subject:Date;
	b=Qa6rZZ1JFUmuiw791ghIF1zdePAkOqcmlpXiK9Iy7tnEFM5RXsGyUcByG39jTsbWS
	 WZ1MuwgTz4XPqq5eOx5YN8lMt9sqv8epN41mbmamw+BsUMe4apEb8Br8UWoFKd/X7E
	 MFPNfnlx7MvLChT4cyvRqCEZ6H37lLKy6TR8uRemukJaE5GHEl2AyCuBsNUW+Z/Ep/
	 qMVIoE44DSa2O99qHqWbf0sbUeDVfNVJQlXUrW8206jNNJE8kp1VEnv2tvVYCZJ5JL
	 xSK4xDoE4mAjxA9YQ7E7qnwUoOwtkSxeZYTeOVH5D22rhFxBTafdboiVxYmW/NqO+f
	 L8L44R7t9oz7w==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 01/29] ksmbd: handle missing create contexts for lease opens
Date: Sun, 21 Jun 2026 21:48:16 +0900
Message-Id: <20260621124844.6235-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_find_context_vals() assumes that callers only search create
contexts when the SMB2 CREATE request contains a non-empty create context
area. That is not always true. a client can send RequestedOplockLevel set
to SMB2_OPLOCK_LEVEL_LEASE without a lease create context.

In that case parse_lease_state() searches for a lease context and
smb2_find_context_vals() starts parsing from offset 0 with length 0,
returning -EINVAL. This makes the open fail with STATUS_INVALID_PARAMETER.
The smbtorture smb2.lease.duplicate_open test hits this while creating
a second file without a lease request.

Return NULL when the request has no create context area so the missing
context is treated the same as any other absent create context.  The open
then continues without granting a lease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 400a3f2f8489..0a97d86cabf5 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1758,6 +1758,9 @@ struct create_context *smb2_find_context_vals(void *open_req, const char *tag, i
 	 * CreateContextsOffset and CreateContextsLength are guaranteed to
 	 * be valid because of ksmbd_smb2_check_message().
 	 */
+	if (!req->CreateContextsOffset || !req->CreateContextsLength)
+		return NULL;
+
 	cc = (struct create_context *)((char *)req +
 				       le32_to_cpu(req->CreateContextsOffset));
 	remain_len = le32_to_cpu(req->CreateContextsLength);
-- 
2.25.1

