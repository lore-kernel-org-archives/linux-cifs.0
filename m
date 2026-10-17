Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7A20D4FC
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199076; cv=none; b=gbEs4mJxJUF9F35/a3ATamPJ/bFQ+9pm7lyK0uCGggRf56JooYZCGVLC+NPn3yuv1941N+yb0RtjK7zKVoiV6srT4xpfLmBNHsbPh+y8s/WWafmJ6naFzOTM9kAnHzyakiJk1brPgrw76vQiStuR6kmj5tB5GZD5lw47qfbW9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199076; c=relaxed/simple;
	bh=677mBkUONVMU2XpgoooCqDqpt6E8ucmVaaNj7+clSLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KlUeOgPYGw0rJRW5aYhuKKa0yb6Zdn8gvR/uUz02GwR+0NdzKZypQn8opOx5WtkkZ2T1CR/CjbolB3YdhBzABSGrMAoYGq8TvrKxZ1sS1LBXs/1mdzs3HvBWEIE95DOU2wM4FneJDH9fmXFpcrrHU30kFB0g9JxzqMBuZo128o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKVRerjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKVRerjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F911F000C4;
	Sat, 17 Oct 2026 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199075;
	bh=q3+MejJxuzxmrHYQQsYxu6dOlFc/md9XGxCIYl6FNYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKVRerjl8GeQZHRjxOR5fmT+qWNkKk20HJesXh0tJptBuABfynfaIHwNFZjHg7yaP
	 6ncY8TYpv8BezvhW2HlaihumOAzU2hFVNJDbot86SZSzNAN/Ht0+fXpi6ig9GjSjfT
	 dy+Ca3Bz+McM0K06pqhnrtuPH6uXZ+uRrS3L/fSUJb7dLb0BpC/MWFhRqXGxEYA0UA
	 R1e1z8iKHNxi6qMQqWEhFRBvqxFmvSqrVlUCKdosgTDG9cRGCn/8gWLMFI0Gt7WUdh
	 +2P5aN6Aczr1njcLl3Xb+WzaLCLQMQe9nq0i2bAHhKllQ8jnzjrUuvuS5JKZIXyIs1
	 7hDY4dtpEgStA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 16/22] ksmbd: use requested mode in POSIX creates
Date: Sat, 17 Oct 2026 10:03:38 +0900
Message-Id: <20261017010344.11478-16-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The share mode helpers treat a requested POSIX mode of zero as an
unspecified mode, replacing it with the share's default permissions.

Use the requested mode, including zero, before applying the share masks
and forced modes. Pass an explicit default-mode sentinel for non-POSIX
creates to keep their existing mode selection.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/share_config.h | 4 ++--
 fs/smb/server/smb2pdu.c           | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/mgmt/share_config.h b/fs/smb/server/mgmt/share_config.h
index 91691b525907..390c966726f4 100644
--- a/fs/smb/server/mgmt/share_config.h
+++ b/fs/smb/server/mgmt/share_config.h
@@ -45,7 +45,7 @@ static inline umode_t
 share_config_create_mode(struct ksmbd_share_config *share,
 			 umode_t posix_mode)
 {
-	umode_t mode = (posix_mode ?: (umode_t)-1) & share->create_mask;
+	umode_t mode = posix_mode & share->create_mask;
 
 	return mode | share->force_create_mode;
 }
@@ -54,7 +54,7 @@ static inline umode_t
 share_config_directory_mode(struct ksmbd_share_config *share,
 			    umode_t posix_mode)
 {
-	umode_t mode = (posix_mode ?: (umode_t)-1) & share->directory_mask;
+	umode_t mode = posix_mode & share->directory_mask;
 
 	return mode | share->force_directory_mode;
 }
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 396f10fb2a91..953a2eeaa15a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4752,7 +4752,7 @@ int smb2_open(struct ksmbd_work *work)
 	/*create file if not present */
 	if (!file_present) {
 		rc = smb2_creat(work, &path, name, open_flags,
-				posix_mode,
+				posix_ctxt ? posix_mode : (umode_t)-1,
 				req->CreateOptions & FILE_DIRECTORY_FILE_LE);
 		if (rc) {
 			if (rc == -ENOENT) {
-- 
2.25.1

