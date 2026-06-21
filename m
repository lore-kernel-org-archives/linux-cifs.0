Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64A972621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046173; cv=none; b=q0WyEx78oEEoTKjiAbg4yVUgUynfqnKOlKVN0ogXeg7uov2tB8VnY1wOsXBpHCFulO3EHPL+vtiJaAVFw7MCtHHRrn3/c8O89m9mbVUxhp67bVTL9rCaZ5YYdG2B0n3NBlqk5rpXUG75XnwJZYAeb1jv/ABMOMjxd/5bkHieIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046173; c=relaxed/simple;
	bh=OWMO12UYR2jwY7ZNwym6B49REyDFu/m/uAhI9laCzkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i2X08rzPprx6y0Y8OStOZbb8Qt5MaHyF9jxbj7NfdMH5Uwpr9hiSODJuxzhSE0L9D2QlFF7wXVzHJ3hMDbuE6TAa3QilsRWDu/fvCOz1Xouo9OFU6eKie1Jt6BH+IaUvzS9eCE3w3TSagTuSiKNdj2esBnkLIffk/4LYURKydM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fp6y2gy2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fp6y2gy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85E01F00A3A;
	Sun, 21 Jun 2026 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046172;
	bh=/JY0RWFvAnWOS4/cXsI7PdfyA9RVVd1qoafbJ+dnnEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fp6y2gy21s+XrJWJ1skH4CgJATtreiTy27Yjvo07HMnFxqHks8C7NNAGoPZnlhINf
	 3ioEV/5h3ntlxSiqWnFSxmeqtqbZkSsbwGLPyZmgoYp7DBonnTKPwi/6SffuzXuxtZ
	 JOK+UbwT0IUma7ehoDU6VcLiJq+Ih5X2amGsZrSZh1qbYgxt3sFgjE/FpGfFlvALnc
	 iDZUhk/Coec2xmG7xvaK3dQLhZ9Fj8Gcqjnk+voek4aTAOpgxpvx9nueCmBjLffZey
	 GDiqVLSmMCQMValTjZIP8K5ji9M+/TTi0jprYsDLIhmks1kwf2R4EQ1T8RWUL2TncK
	 IqUaZDiwwlWWA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 21/29] ksmbd: return oplock protocol error for level II ack
Date: Sun, 21 Jun 2026 21:48:36 +0900
Message-Id: <20260621124844.6235-21-linkinjeon@kernel.org>
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

SMB2 level II to none oplock breaks do not require an acknowledgment from
the client.  smb2.oplock.levelii500 intentionally acknowledges such a break
and expects the server to reject it with STATUS_INVALID_OPLOCK_PROTOCOL.

ksmbd drops the local level II oplock to none immediately after sending the
break notification because it does not wait for an ACK.  When the client
then sends the invalid ACK, smb20_oplock_break_ack() sees that the oplock
is not in OPLOCK_ACK_WAIT state and returns STATUS_INVALID_DEVICE_STATE
before checking the current oplock level.

If the oplock is already none when an unexpected SMB2 oplock break ACK
arrives, report STATUS_INVALID_OPLOCK_PROTOCOL.  Keep the existing
STATUS_INVALID_DEVICE_STATE response for other unexpected non-wait states.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 97dc24c5c44b..67a1850d4368 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9225,7 +9225,10 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	if (opinfo->op_state != OPLOCK_ACK_WAIT) {
 		ksmbd_debug(SMB, "unexpected oplock state 0x%x\n",
 			    opinfo->op_state);
-		status = STATUS_INVALID_DEVICE_STATE;
+		if (opinfo->level == SMB2_OPLOCK_LEVEL_NONE)
+			status = STATUS_INVALID_OPLOCK_PROTOCOL;
+		else
+			status = STATUS_INVALID_DEVICE_STATE;
 		goto err_out;
 	}
 
-- 
2.25.1

