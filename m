Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18763E8C77
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789299360; cv=none; b=GR8t/dTMRBETBsuFiKOAekTQCyjzt/y9xtjrPXTZvsj7DSSPyv5sNF7jXpd2YyjjXRCohtJPVId1YX01iZbQU3A+rylsTKAfSsDuieOkSc4dl0BWSQHIFV+QxY+6nNvmozVe0q7rXOt8/OQbnXM7x2Jy2AggTXrNHyZyC79M5Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789299360; c=relaxed/simple;
	bh=xI4ipDaPmNP4RWvPg1NvpZwJw3eeyk+E+RUDI6mmHn0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fc1lp5pNY6xfTchAuM3JDVPwiHAlr+7ZbiZmKwc4ExvNJPPNkMXzJ3pZ3huxqWvGtDdtTpXu0BnRzEunGsKEwe/dBEg6j8wEYmBT3VKifYHIukE5H/Vj5H/M3147kMsXKfJOTOieIYK9q4obEHnSIHPGHwXyLzLh7P8FMriN8RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ap4YXbdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ap4YXbdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3C91F00893;
	Sun, 13 Sep 2026 11:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789299356;
	bh=icFbRItDWb+jES6cZwUxWpmh1GcQ4nJXYyZnIgyiz6U=;
	h=From:To:Cc:Subject:Date;
	b=Ap4YXbdD5mUkW9AtBB5Aqi3plQFgIOjIR4zC7Gj2cVgCObOCYVXeAMszxDQWh9C2k
	 l7SfwQnoZXA8LlTU/rTi8lxnyCavQ63+UfEfykqpRVGs6otazww3NKfvtfCzvtdut9
	 i4RyTRfDcksJ5xzFgym+0FVpJnhPvkNmvlObdgL4nhW3WpcEXVwFM6xVNcq0HVoyVT
	 Dq+/r/Is0TB5b/2/C5Qj1nmSZvSufmiL4RimBoGuGhr1QZOi4vu2BDpDhE0Jt3rUze
	 /jop2l2uDJr6aLHAY6gELobnSMTsvw9V6Bob/A9caESFso8FbL78H/d/HrgqYFDndF
	 LshGXaK+aEjvQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Mobin Aydinfar <mobin@mobintestserver.ir>
Subject: [PATCH 2/3] ksmbd: fix partial normalized name responses
Date: Sun, 13 Sep 2026 20:35:52 +0900
Message-Id: <20260913113552.11486-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Windows may request FILE_NORMALIZED_NAME_INFORMATION with an output
buffer that only fits the fixed portion of the variable-length response.
Treat the fixed portion as FILE_ALTERNATE_NAME_INFORMATION_SIZE so ksmbd
returns STATUS_BUFFER_OVERFLOW instead of STATUS_INFO_LENGTH_MISMATCH.

This avoids rejecting valid partial normalized-name responses.

Fixes: 6b8b79226bc3 ("ksmbd: fix partial file information responses")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f4d96799e1d2..38cddbf3e6ed 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7318,6 +7318,9 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		case FILE_ALTERNATE_NAME_INFORMATION:
 			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
 			break;
+		case FILE_NORMALIZED_NAME_INFORMATION:
+			fixed_len = FILE_ALTERNATE_NAME_INFORMATION_SIZE;
+			break;
 		case FILE_STREAM_INFORMATION:
 			fixed_len = FILE_STREAM_INFORMATION_SIZE;
 			break;
-- 
2.25.1

