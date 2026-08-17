Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90B93B4417
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968936; cv=none; b=BttZe1KqHVXKZ2vyfXGYTy7wxd4Jy7zkYN0vBWTO/LjVLhqKDk5KxduIY+6XQApaIpAqt2TCMsihUhALQkKLA0BsPvS89LwmYS8nkPvhtkAES3AlO1mFfiCjJmtkyqi8M6t5WaT90YtPMK1L4YOTPjqoO+Zu6lkwgY7D53p9Vcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968936; c=relaxed/simple;
	bh=GmmM3h4bzasocmTSQMJ78xK1Jg23tDqNw/Dov1Ej7VE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Jf7Igh1s3Byyw94SLBiXz3SwwH6a8DQx2D4sQMq24BZuDNdcMb7jYg5EonSIJ+o/09t0JU2GzLVboINUVREHr3goBu6eSQ7EHeKjPMzSOW+tX6Fwm8SaDgVUxlnq4g7p9gM52EjzEibwHoGTDwT+Fno2ym0dB+4Ycw6JkwAoBeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3B55q3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3B55q3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F02C1F00A3A;
	Mon, 17 Aug 2026 12:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968934;
	bh=T4y8UouqUXvDJZ7M5kfY4geZ4sdosZ1pxjG0FgYqms0=;
	h=From:To:Cc:Subject:Date;
	b=E3B55q3l1UMJGpx06utzzdCVTTCsKg8zHpBq7eQ9hGKAaq0EEoqkusBYID4XVDZJr
	 wEPbStSNwZymptm4HGJlvW03nltXB+feG2gXJIo3TdN41+ojXY+Tu4tnr1e27v0ZD+
	 ZtOQnKlfk+GD++nLwsB20FG93BeSz7UhmBgQQ4S0RAO6NDE0xGezD9RZY1ayjQ2euR
	 4+KR+mWUknKEwNCw1WaWmObaRpbUTwnrA+6mFcAJEk2RjCqOzEfcCNUqqRO27ioS+D
	 0ebneutpuMDLP4DcXMQWMX2hLtn75TZUGUWQwwjriMHMwVLqG6rk8iBYC1BYED4pPf
	 nMcJiJQwGAiPA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: accept unspecified volatile ID on durable reconnect
Date: Mon, 17 Aug 2026 21:15:13 +0900
Message-Id: <20260817121524.8812-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BVT_DurableHandleV1_Reconnect_WithBatchOplock,
BVT_DurableHandleV1_Reconnect_WithLeaseV1,
BVT_DurableHandleV2_Reconnect_WithBatchOplock, and
BVT_DurableHandleV2_Reconnect_WithLeaseV1 fail to reconnect a durable
handle when the request leaves VolatileFileId unset.

A durable reconnect request may omit VolatileFileId by setting it to
zero. Treating zero as an ID makes ksmbd reject the request whenever the
saved volatile ID is nonzero.

Only compare the saved and requested volatile IDs when the request
contains a nonzero value. Explicit mismatches continue to be rejected.

This allows SMB2 durable handle V1 and V2 reconnects that identify the
handle through the persistent ID and reconnect context.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bfa895414fd4..bd806dca9dcd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3584,7 +3584,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (dh_info->fp->durable_volatile_id !=
+			/* A zero VolatileFileId means that the client did not specify it. */
+			if (recon_v2->dcontext.Fid.VolatileFileId &&
+			    dh_info->fp->durable_volatile_id !=
 			    recon_v2->dcontext.Fid.VolatileFileId) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
@@ -3637,7 +3639,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (dh_info->fp->durable_volatile_id !=
+			/* A zero VolatileFileId means that the client did not specify it. */
+			if (recon->Data.Fid.VolatileFileId &&
+			    dh_info->fp->durable_volatile_id !=
 			    recon->Data.Fid.VolatileFileId) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
-- 
2.25.1

