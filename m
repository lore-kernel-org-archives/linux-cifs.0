Received: from cvsmtppost18.nm.naver.com (cvsmtppost18.nm.naver.com [114.111.35.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62143EC81D
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 07:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359108; cv=none; b=AHTJsm4mJK3tKodj2ZVRuVtiFrcqckD2/ksAMc/E6ql5wMH1fhJpqbGBsUCTsZY5N3wMkjRJD9pqj4dOqzMAHVo3s/FutRxGxx6qMi/85BSZ5VSlIe277o43N4/iKyQXJjjtmTCiQVaMDA06J449fV2EReIWao3unjwHUYfJ1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359108; c=relaxed/simple;
	bh=1p+LVU6640k2DJxnef4Exd3u26yuJVyOPBWRG7Y571c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CQK2Wv7i/JNaLRzmHfvtWMRMQDj/viFVydTDzR9Mf2pbO4NYKLrLFud/HlCWdnevvt19DUbOM084rEVxwutvyw+0nxencoz3gi/RbEljTLCFya7htjYPVIIJKdpVHTicgRF0cUo7AnQW9vd5ZrKntA06YB6ycRa0EtoqIS9R7YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=WZ/vuM17; arc=none smtp.client-ip=114.111.35.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="WZ/vuM17"
Received: from cvsendbo013.nm ([10.112.18.56])
  by cvsmtppost18.nm.naver.com with ESMTP id S9RIxq6TSneIsDkRA22cqA
  for <linux-cifs@vger.kernel.org>;
  Wed, 07 Oct 2026 07:44:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791359096; bh=1p+LVU6640k2DJxnef4Exd3u26yuJVyOPBWRG7Y571c=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=WZ/vuM17ukSdVz69d6NLVgrkVZ1Bg9w0/wyeKfOEJAmhYMWhTcjWfUYnszwMfIW+C
	 8m8MKu2gtmXeG/nlL0HmC4QzNS32DSRGS0jxjCXBRP6IcXbWkAv3u9pfTxdAku7avr
	 caPnfGfaTs2YStSP/3L03/way3v8zNK63YDpm3tb6NZW+HX9so3oaVALWRxyqfA5rP
	 hBYAw0gq3vshJkcwCqlNcbOMFCO2M3dn2nBVcigpspI9NeUzGxYQeEXoR81RMRdDbh
	 vEcGhHAEOZYlvzZF49Wh+mGfJo71kUGeBsrakplQuoy1tsdF1sdYglbooG1UTYqdk4
	 61h4QmeKm3FRg==
X-Session-ID: Zg9fNVl9RQ29Xb90oN3sSA
X-Works-Send-Opt: OPRwpzGdjHmdKHFOMr39Ko3YKHmrjAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: X9nZKqulFqJZ+Hm9axMr+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp004.nm.naver.com with ESMTP id Zg9fNVl9RQ29Xb90oN3sSA
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Wed, 07 Oct 2026 07:44:55 -0000
From: Sung Byeongchan <tjdqudcks0424@naver.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: validate share path for batch oplock reconnects
Date: Wed,  7 Oct 2026 16:44:44 +0900
Message-ID: <20261007074444.84875-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Durable reconnects backed by a lease reach
ksmbd_validate_name_reconnect(), which rejects reconnecting an open through
a different share root.  Batch oplock reconnects return immediately after
checking the oplock level and therefore skip that validation.

An authenticated client which owns a disconnected durable batch-oplock
handle can present its valid reconnect context on another tree.  The
preserved open is then rebound to that tree even when the client can no
longer connect to the source share.

Route successful batch-oplock reconnects through the same name and
share-root validation as lease reconnects.  Keep invalid oplock levels on
the existing error path.

This was found by source review with AI assistance.  In two independent
boots, a same-owner client was denied a new tree connect to the source
share, but reconnected its durable handle on an unrelated read-only share
and read the source file.  Routing the batch-oplock path through the
validator rejected the cross-share reconnect and preserved same-share
reconnects.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
---
 fs/smb/server/oplock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 25ff8408f0ba2..70b7b085d4fdc 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -2489,9 +2489,10 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 		if (opinfo->level != SMB2_OPLOCK_LEVEL_BATCH) {
 			pr_err("oplock level is not equal to SMB2_OPLOCK_LEVEL_BATCH\n");
 			ret = -EBADF;
+			goto out;
 		}
 
-		goto out;
+		goto validate_name;
 	}
 
 	if (memcmp(conn->ClientGUID, fp->client_guid,
@@ -2528,6 +2529,7 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 		goto out;
 	}
 
+validate_name:
 	if (!ksmbd_inode_pending_delete(fp))
 		ret = ksmbd_validate_name_reconnect(share, fp, name);
 out:
-- 
2.43.0

