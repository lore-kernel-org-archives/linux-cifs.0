Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9FA72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046155; cv=none; b=XcEJUAp403fggfNe35X4JatLUP50Y6juSdrczIWjQz72m2uLi8w7U7rrWuPE4Rir6k3yj++8TdHtLL6DxKvdOCsUOv1Ztro09i+hei3F+lPgv9yuWA9ouMvl3YVCxQa09b3fiIJrfXFPsN+XBzJglbJYLPYD0D27jgMW24OIkC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046155; c=relaxed/simple;
	bh=KAN9KAXcTzE6vnYmgfBZuvdtd50pIXvSqWXZth1lNC8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=he1AkbEHdg2JLK53dmvP8UckW7Jh1IS3R5iP+igL4FwuEzokLkmbnweSQtOsk1iEUDk1wYQsHupA/hBdqjcqH7vfnGev1PtRvX0Q7d5XK1/++5AeZaoOTDgHblEYr3pd/Srg5BotSVfO5fxOSXWrajO4BAs5ZYbd2Yw4hr69dos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ej1HpRXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ej1HpRXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C961F000E9;
	Sun, 21 Jun 2026 12:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046154;
	bh=IM0Y/cPG7I1G2voX5akZ80Jz/1wHxeQHBJ7Qs7BD86M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ej1HpRXndyVSSwlYsyuV3soVVS2j/Ax6P1Og4J59Thzfabl9LekZGLVKSHLxib18S
	 JxvxBVH5ylSFaLxeSsEVnhydMDPOwFbHqRQkvjs2Ujy72dKX7uLxk1G7YuuZ5ALtLw
	 fN+L1/ifCCFrm0BNfVIpUBSxzYiDc81XwBR7JOl56IngGEuvLqzwH7y8ZNEh3DopNv
	 VALy6gntk+J7o4qgQrR30M41Hjks6a1/opCM9Dd5LZwUdZbijiLETKoMWLWI4gH6BT
	 6x4LymgZhKzsU7j5ERT0jAsT2YZ7eg08LbpfZTnp3fefsoZI/kgLxSF4sSmddhRFo6
	 28YckgSaExQbA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 12/29] ksmbd: return success for deferred final close
Date: Sun, 21 Jun 2026 21:48:27 +0900
Message-Id: <20260621124844.6235-12-linkinjeon@kernel.org>
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

ksmbd_close_fd() marks an open file as FP_CLOSED and drops the file table
reference. If another in-flight request still holds a reference, the final
close is deferred until that request drops its reference.

The function currently returns -EINVAL in that deferred-final-close case
because fp is cleared when the reference count does not reach zero.  That
turns a valid close into STATUS_FILE_CLOSED.

smb2.compound_find.compound_find_close sends QUERY_DIRECTORY and then
closes the same directory handle before receiving the find response.
The query holds a reference while it builds the response, so close must
mark the handle closed and return success even though final teardown is
delayed. Track whether the handle was successfully transitioned to
FP_CLOSED and return success when only the final close is deferred.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 98c5bac93d63..b617edef950a 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -640,6 +640,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 {
 	struct ksmbd_file	*fp;
 	struct ksmbd_file_table	*ft;
+	bool closed = false;
 
 	if (!has_file_id(id))
 		return 0;
@@ -654,6 +655,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
 		}
@@ -661,7 +663,7 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 	write_unlock(&ft->lock);
 
 	if (!fp)
-		return -EINVAL;
+		return closed ? 0 : -EINVAL;
 
 	__put_fd_final(work, fp);
 	return 0;
-- 
2.25.1

