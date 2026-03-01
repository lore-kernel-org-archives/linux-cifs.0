Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B682D97AA;
	Sun,  1 Mar 2026 02:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330668; cv=none; b=K6pHiyRzjCJMgtalEM/OmyZhF+TfBeYVwozanSFlZ0dA3TdpOtK8Scxc+EkN4bjgZoKuUlfKz6I4QoznHKIzU0dTwy05iJwrny+vXpkf0uFpUVHEKiLdsM9U/dhMPq6HKwXBjlow3rpiYdQMisC+nMpD68SqFEzZwgs7ZZGxyws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330668; c=relaxed/simple;
	bh=PtjEi62M5e1gbennm83en1UevUZJNZZqKbiet6sa0Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ww9T/VUR0p1DKDzVBqgZxtq0q7HB4tY7d7eZJz5o5XiMaNEGlTtAhgICb90TthVz/HJaVsANpUP7WZedmes/4w8sOERslp4prKukJI6rSpP8c4FyrqpOd5XOjbPeWTiY2a463j/+ZGpQaAXSASpodUBwyvvx+WEMZD0hD7rUEf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMie+rQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMie+rQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9367DC19425;
	Sun,  1 Mar 2026 02:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330668;
	bh=PtjEi62M5e1gbennm83en1UevUZJNZZqKbiet6sa0Qg=;
	h=From:To:Cc:Subject:Date:From;
	b=DMie+rQgJ/RHr3eXMKwCb1dFNNpWAwHxpV0qFklHt9L+eqPvK1x4xkoxs0UFO3B6l
	 z40hdBEuEEKAIzA2aZSMOOfL3KwTXGHIrOjwMxBEGIv5Dl/jc2gaXnYobULais1dZd
	 Ll3JTLkR4NK4rTP48D98zEjUqkE9oFsR6EFpBvmHn+cnzQ+azmzkUJZTYSpDyERN/L
	 Zi1kpeesxrDY90Bug+7MAc6KN/ons9posGVHJmJ+gUS+cK7UYLSVWwJ8gUZK69ULss
	 6sKgltUcLHpjZ2enNyMASEimaCnZRzima+uMY7XfRlvlWrA11BwU+7bpSkCZZQriQo
	 0JYQ95JjqJ9Wg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: tianshuo han <hantianshuo233@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org
Subject: FAILED: Patch "ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:04:26 -0500
Message-ID: <20260301020426.1732892-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 010eb01ce23b34b50531448b0da391c7f05a72af Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 24 Jan 2026 10:55:46 +0900
Subject: [PATCH] ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off
 reset in error paths

The problem occurs when a signed request fails smb2 signature verification
check. In __process_request(), if check_sign_req() returns an error,
set_smb2_rsp_status(work, STATUS_ACCESS_DENIED) is called.
set_smb2_rsp_status() set work->next_smb2_rcv_hdr_off as zero. By resetting
next_smb2_rcv_hdr_off to zero, the pointer to the next command in the chain
is lost. Consequently, is_chained_smb2_message() continues to point to
the same request header instead of advancing. If the header's NextCommand
field is non-zero, the function returns true, causing __handle_ksmbd_work()
to repeatedly process the same failed request in an infinite loop.
This results in the kernel log being flooded with "bad smb2 signature"
messages and high CPU usage.

This patch fixes the issue by changing the return value from
SERVER_HANDLER_CONTINUE to SERVER_HANDLER_ABORT. This ensures that
the processing loop terminates immediately rather than attempting to
continue from an invalidated offset.

Reported-by: tianshuo han <hantianshuo233@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/server.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 554ae90df906d..d2410a3f163ae 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -126,21 +126,21 @@ static int __process_request(struct ksmbd_work *work, struct ksmbd_conn *conn,
 andx_again:
 	if (command >= conn->max_cmds) {
 		conn->ops->set_rsp_status(work, STATUS_INVALID_PARAMETER);
-		return SERVER_HANDLER_CONTINUE;
+		return SERVER_HANDLER_ABORT;
 	}
 
 	cmds = &conn->cmds[command];
 	if (!cmds->proc) {
 		ksmbd_debug(SMB, "*** not implemented yet cmd = %x\n", command);
 		conn->ops->set_rsp_status(work, STATUS_NOT_IMPLEMENTED);
-		return SERVER_HANDLER_CONTINUE;
+		return SERVER_HANDLER_ABORT;
 	}
 
 	if (work->sess && conn->ops->is_sign_req(work, command)) {
 		ret = conn->ops->check_sign_req(work);
 		if (!ret) {
 			conn->ops->set_rsp_status(work, STATUS_ACCESS_DENIED);
-			return SERVER_HANDLER_CONTINUE;
+			return SERVER_HANDLER_ABORT;
 		}
 	}
 
-- 
2.51.0




