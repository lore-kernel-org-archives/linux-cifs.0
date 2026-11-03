Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704090;
	b=MLFoBE2/BgCHfa+FOcv6YIl3v6tCUkkK0IAzwwyGUU1GE0r9kzdiIdP4VjMirWIqs0uG
	 V4YKXn0Lz/zJFOnTSekv8Hj0JFMtfeQvOhqhbdHVmuJq6OvB5Kb/XLLq5bGg1P8ohEPTH
	 nJIV+Dn/DxA2FhZB/UjSyEFR6egq3z0dWOp4KdQU0XP2zfYbkM2QTlcThI4WY0H80R+KX
	 4hM3ZalSm5oYsI70FpYAVQnDBW/WV8tTcT8Bw8XPHjuSc9pMGTeowvTxiQITxfCyvdNJG
	 oAptj9bxn9X2RU6K/ojyaFaUbfnn5mqLRoo586EHT2mqw1WqUnopTt4cU24BbjMGRfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704090;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ezxKqPDG6zEQ77ixrycuzPTXy5tSjoq5DZ4sHQT5GiQ=;
	b=K9MbPQ9SAGzgVyUT3Z4p6ylLLKo+6lLa3gPsYrpj6tYMt9jzdUIj7RywtexOBEr6OKWO
	 aucWEE7Dx8O42HwhW6Nnc3qtmnp5hg20qiqMzxr6I8y9sMt+4e21aqnErmCY5VkSfnM4d
	 ypZ5enMwb4kKXVb+hpo3WvLa1J3z2Q62GyLyAUq4Xk5D2/4M/TvSrzmoxYM1Q6UlvHLDD
	 NQG1r6n2g4VTLI0cvzq8tKbMb8uawBkMPOjt62JtufDR+o6U2X11OEjhPAsceBiXQ0la3
	 rj+u+5PVYWEYTwqA+qVc+gJe2rtX4UJVbHet/G3Nhi7Czutq28p6b4Esu44eiKjqxBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KXTRFL6G;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8623606A326;
	Tue,  3 Nov 2026 11:08:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8623606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KXTRFL6G
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793704084; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ezxKqPDG6zEQ77ixrycuzPTXy5tSjoq5DZ4sHQT5GiQ=;
	b=KXTRFL6GyXRKBM4cBDV0x36BbMMLrwLFsSupaBWFR9b6zfavvXqVY/Rr0Fong4o3La1dM8VH07g+P+55kcCwmkhkGvZU36zkE3S+aT1TRzOsBNuNY5fX6kqMHzgs+7Au7x+ILRgWRqTcCllygi3pX6U1+GtUNx0QoRXIEi1iEok=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XE2a2PR_1793704083;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE2a2PR_1793704083 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 19:08:04 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 6.6.y] ksmbd: fix breaking_cnt leak on early return in oplock_break()
Date: Tue,  3 Nov 2026 19:08:03 +0800
Message-Id: <20261103110803.2517085-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For leases, oplock_break() increments breaking_cnt before calling
oplock_break_pending(), and returns early when the pending check
reports nothing to break: the level is already at or below the
requested level and, for a lease, the state is not HANDLE|READ
caching.  Neither early return decrements the counter, and
wait_lease_breaking(), the only place that force-clears it, sits
below those returns, so breaking_cnt stays elevated for the life of
the open.

A stuck breaking_cnt makes same_client_has_lease() skip lease
upgrades forever, and every subsequent same-client CREATE on that
lease is answered with SMB2_LEASE_FLAG_BREAK_IN_PROGRESS, so the
client never resumes caching.

The ordering dates back to the original SMB3 server code, but the
early return became routinely reachable for leases already broken to
NONE when smb_break_all_levII_oplock() stopped filtering out
non-level-II leases in 17699905a381, "ksmbd: fix lease break and ack
state handling".

Move the increment below the pending check so the early returns
cannot strand the counter.  This is the minimal equivalent of the
reorder that mainline made in b0148dc5625d, "ksmbd: serialize oplock
close with pending break ownership".

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/smb/server/oplock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 6f595756c41fd..ed50dafd70050 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -903,10 +903,15 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 	if (brk_opinfo->is_lease) {
 		struct lease *lease = brk_opinfo->o_lease;
 
-		atomic_inc(&brk_opinfo->breaking_cnt);
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;
+		/*
+		 * Increment breaking_cnt only after the pending check
+		 * above: its early returns would otherwise strand the
+		 * counter, as wait_lease_breaking() is never reached.
+		 */
+		atomic_inc(&brk_opinfo->breaking_cnt);
 
 		if (brk_opinfo->open_trunc) {
 			/*
-- 
2.39.3

