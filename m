Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B988846D2AD
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 21:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274085; cv=none; b=pk6I4t6aF6TgOoiKW7tzF8yO20VYK7X7Iaf19+y0KrzpPmRIaGm1QWqcBzlCD976dbnlYQJ5qyub7GfwE04JqIifyMeODK7pKd4z5PB/SS8tbPdLtCvN86n2UsrF0HyDcStOqIdJRpQHw2CD77vp/cAV8R5U4uKh7F/5dcFQ8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274085; c=relaxed/simple;
	bh=EttXnhReWDaZNc/PGIGptRBiAnqcvzfN6Dm1pRr5f+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uP7j5Z8pEHs8l+k4sAyQzt0Le5AiYyZjVvRnAxRhtp4bdXeuIcPkhCHx/3tVcZ0MGnrilgHG2r40y6gxvPOJeUEKvoOpKCTXgJ2TVwUAtdtPML9WfUIH8fxTvX73XO7/4cKmCOLahbl6bAt2Ne4+sqLiJ9e1TzKc+9zNwNfhm+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7Jw+A7Z; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7Jw+A7Z"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c0a81d286so9264291cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 14:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274082; x=1785878882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LRM7mfkSEq/GHrJM51V71J9c4QJVY0Jbu0azwhJmg/s=;
        b=b7Jw+A7Zn+qTnjj9xaBUfkKy+hosFg7I2tVTE9Vfr/Qov/MR2F+BtXZtX/1VPdo5V3
         DE2tBnVy/TCvGBiesoK7j+J+yTHpcSMf/eAXg0wshcAH5v6a1AoUWlAChZHV/Uqa5lW/
         LeppjwT8oKq/7Bnsk6Cg4NRZ9my53GwTKmk/ioADpsNEvCKq5OCpkwHcUJbrpprBkNdh
         nApIK+sFPiRXcTRNaRENEngDj/2QqWaxLYIt2K01O4Hec05gTlwO1dJf3QxY09yFxyAA
         MvjFH9Wr+Z0sZZN+QNLBW9LTY426J+LLKSt7Lckpaxvmhdp114qwHrb7Y7UtnbtX0mBq
         FGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274082; x=1785878882;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LRM7mfkSEq/GHrJM51V71J9c4QJVY0Jbu0azwhJmg/s=;
        b=Ap05qWgksc981UXSBpR8JoJst+rT6SCs8h9GhCSpaQ5nvCEtidw5SV9jHs0FJJDi7y
         O+Gs84DaKqCGVqvnGhJ052+mjo9DmyGkK3iksL0T2w0ahKcTgGo4f1hmFLZpdDb7EUAC
         DeE/S1utL/m9pgGQbds5REUJeEeGpIWVuRBzAZ2cCiPZpgP/vugbLklGKanDZ843SKtb
         oMNYUQkGQNcp8ogHVTOuLerlssL4AfS5tFj6uoNWEPBMRg215KSAmJjtN3ptCqibthqE
         4OhhWd0O+Kuv+MLMGghrbdhjXP45dn/yvnDgmGViofXZsaV3NqgAbwiPX7VQLr5USgjL
         PADQ==
X-Gm-Message-State: AOJu0YzCqBCWHCT5Cz/LtMFlqTLlEG/HIC9f60/gFrwDECFUOy4H+K+p
	msF3s0iG0Uvy14SgJCn1jbtHMhHZPk1q9BeeviNOc7RwEEHaVnevac4bZer69w==
X-Gm-Gg: AR+sD10Tlzdr3XNzKz4w1CXz2j8H+SvNm8Vf3lzCKHP8MSdHvMHdNlzwWBeJrW7aDAl
	ktcmqqeQtMfJNMmY4kPylpg7enGOsmHhKD0tLgqCZanYsnDQ6jlt2seAGfe3SOHbYoQmCXNpr8v
	mS+TWr2yO3cgTrwRUUcEwFZnC1jGYCW19glEHPrzqrLpFR4GF77xj7QAmDH9B2dbEqtalGyXT28
	wKOWNZ/77GKSAgOeZvJLVxZXbPaJ2IauiGo2Emnhgsf7OxBJwRH3CGTAchZvnqhUcTS96YKcH16
	gqDpE5H+Wgv96LU5aTC4Jbx5syM0XbTQF7b52p39kEq0laZ46kpjTXC8JIT5d7gqjH5/H9sf88w
	eHMC4h7j7P7216xuclE61tJ8S0Y9ztTPkTj9gA0iEZqaW7ewVPtCITfVGAkC2Q1xJ8ODZW0my2B
	xH5xdfpPSkrF/UMq8Gwt5p+kmcQwcopabnsyJxkO+6A5v2UQMJfA9vm4R2ieg6iXpkKsNpWI9os
	WvN2chCX8xLJwPa1iwHuj0N5F+yG1sbUFlteKQfG2mBvFbusHaZvqU2Hxw7EZU2uWy/fCeqHIQG
	zYctZdxeeQZ/xNhzaRWgdHjwPVABwjmG35R/TTU=
X-Received: by 2002:a05:622a:313:b0:51c:7aa7:e0eb with SMTP id d75a77b69052e-529d716a395mr37469861cf.40.1785274082510;
        Tue, 28 Jul 2026 14:28:02 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529e2b4f241sm6777091cf.7.2026.07.28.14.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:28:01 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] ksmbd: remove extra byte from ipc_msg_alloc() size calculations
Date: Tue, 28 Jul 2026 14:27:59 -0700
Message-ID: <20260728212759.54722-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three ipc_msg_alloc() calls in transport_ipc.c allocate
sizeof(struct) + payload_len + 1, but the extra byte is
unnecessary. The payload data is binary and copied with
memcpy() to the exact size; no null terminator is needed.

This was present in the original commit that introduced the
file, where the structs already used [0] zero-length arrays,
so the +1 was never correct.

Assisted-by: Opencode:Big-Pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 v2: remove Fixes:
 fs/smb/server/transport_ipc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 0c581b9624d3..41611c013d81 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -658,7 +658,7 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len)
 		return NULL;
 
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
-			blob_len + 1);
+			blob_len);
 	if (!msg)
 		return NULL;
 
@@ -839,7 +839,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
 		return NULL;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz);
 	if (!msg)
 		return NULL;
 
@@ -898,7 +898,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
 		return NULL;
 
-	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
+	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz);
 	if (!msg)
 		return NULL;
 
-- 
2.55.0

