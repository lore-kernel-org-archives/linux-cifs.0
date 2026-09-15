Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666A643F8D7
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454843; cv=none; b=S6yM9FnxoZQ5gkI2yO02n6EjNDLrNlOhWf8vC7C2WyjtTc0u8h03xiD1/V0W1oTBvaFtlO6F6tW4PgjzBv1+tp7Z7Pdz4vwOQ+/eeH4Omdmy2KSaHlTALIGprTTbmgy4h/JGRlUIWkrIHO+mLe2OxKqjeu8jI3Izp+kXDG3IJu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454843; c=relaxed/simple;
	bh=+3ERNBJFwPl50yJZZHlp2PHXwBblW0CqD5+iSNP0474=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrF9fjX18u/Y3apjXzw3xvWaZwaH8yZpZkTI8exB976ShD2FGEh6Sd7/2N/11cPRXyH9vUydyS7QW7OiBWmMLiCEhCTEeS++bieeybJXiN21WL+BP/+/4uoyFYNHZvej60Akts1juEwSLKqX4iypnX4PwHNXzUevXkKNbCK36+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=aydMRccZ; arc=none smtp.client-ip=91.218.175.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="aydMRccZ"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+3ERNBJFwPl50yJZZHlp2PHXwBblW0CqD5+iSNP0474=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454837; v=1; x=1790059637;
 b=aydMRccZs0tdhoaLz9JbImXkjf5bSoSs+69I/46Dq5A5dxt3yxw+9gjOKy/+YF0nLUDetyH+
 HUXpX0tqFE8DFrM1lwLxKwQCUseSG2qmQDRqY0gujLD3tJYvg6oJbuEwCRcAtzfjP0z67F+Qq33
 S2oomoqIW6J74utrLNQAISROCxlXoQclzJ41QGF7nWsdRtn3V7B9Mcih4hqGI80cEFd2D7JPKGX
 xArk4lIiWMUB5ZGiVSATEjna+duC9xJUjpfLLN6XwLX/Q1j31cqUgpt5ET4D2QYrNtVKSaM9QQX
 2peVlNU1KnLDNwDuE2IrUcqArG1s8rAvPxsRwJ7nltxcA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 86a5aee0e2ecbe57;
	Tue, 15 Sep 2026 06:47:17 +0000
X-Mizu-Trace-ID: 86a5aee0e2ecbe57
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/3] smb/server: align partial normalized name responses to UTF-16
Date: Tue, 15 Sep 2026 06:46:56 +0000
Message-ID: <20260915064657.110687-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
References: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See MS-FSA 2.1.5.12.30.

Set AvailableNameLength to
BlockAlignTruncate((OutputBufferSize -
                    FieldOffset(FILE_NAME_INFORMATION.FileName)), 2).

Link: https://lore.kernel.org/linux-cifs/ebb45fdd-76f0-4d92-9899-13ecdaea555c@chenxiaosong.com/
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 18b4676829b1..9d5f354417b8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -16,6 +16,7 @@
 #include <linux/mount.h>
 #include <linux/filelock.h>
 #include <linux/fileattr.h>
+#include <linux/math.h>
 #include <linux/timekeeping.h>
 #include <linux/unaligned.h>
 
@@ -7218,7 +7219,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 	struct ksmbd_file *fp;
 	int fileinfoclass = 0;
 	int rc = 0;
-	unsigned int fixed_len;
+	unsigned int fixed_len, req_output_len;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 
 	if (test_share_config_flag(work->tcon->share_conf,
@@ -7325,6 +7326,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 		rc = -EOPNOTSUPP;
 	}
 	if (!rc) {
+		req_output_len = le32_to_cpu(req->OutputBufferLength);
 		fixed_len = le32_to_cpu(rsp->OutputBufferLength);
 		switch (fileinfoclass) {
 		case FILE_ALL_INFORMATION:
@@ -7335,14 +7337,13 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			break;
 		case FILE_NORMALIZED_NAME_INFORMATION:
 			fixed_len = FILE_NORMALIZED_NAME_INFORMATION_SIZE;
+			req_output_len = round_down(req_output_len, 2);
 			break;
 		case FILE_STREAM_INFORMATION:
 			fixed_len = FILE_STREAM_INFORMATION_SIZE;
 			break;
 		}
-		rc = buffer_check_err(le32_to_cpu(req->OutputBufferLength),
-				      fixed_len,
-				      rsp);
+		rc = buffer_check_err(req_output_len, fixed_len, rsp);
 	}
 	ksmbd_fd_put(work, fp);
 
-- 
2.55.0

