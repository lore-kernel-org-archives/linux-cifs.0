Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D051345A2A8
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 13:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665917; cv=none; b=Ng15Ye+adNg0hlWUOfXsCc4d8Ckq+xWDcTwRAktqHDkLi57VB3bOq3hDaFXHiaR+pSqZrXQghiyaLc5sdSHAKKnDDDBUsqfW7NzXXP4FSzlG/clk7pkeP9C/cqfPHWytJxGHc9pMfLcyk1p0iEiVdJYmiY7x3y+SvAceNPUXkZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665917; c=relaxed/simple;
	bh=lB9hj8psDso0Jym+46/LL9DWP3iDtcZUr3NvS+e48QI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=chAbKJrxK1eSplqXK/X7RbhZQ61WpqvkNEg3nNhk9KcQUGE6WcXMlk6AQYefZHK65WDnW+afzF/jBDyblZPxWJ2muJ1rJjWOHKqqcWS2U8G8qjdGI7cIIOSNKJ0Y6iSfH8i+d2Ve10pOCWsewCo9r47Iy64fVYCQaFtVgkqL4wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=axqoQyZo; arc=none smtp.client-ip=95.215.58.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="axqoQyZo"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lB9hj8psDso0Jym+46/LL9DWP3iDtcZUr3NvS+e48QI=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665911; v=1; x=1788270711;
 b=axqoQyZoYLOsaik6p4Ln9gym90m2KuRt+T5uXdRgKvtZZPgJQdgliCnVay+Q8+XCzvLUyUJD
 Oc+8PZXH9fF3gkmYzJ4epMX+q6flOVH0BeXwec2MF40plVkzw43qGNAlnC2nXkf4MG5/SiEK+sA
 9nL0ihOEGCTFBd2xXeYBQU1n57xS+FjbbtwNYTfv5VSeneTxRbMidFXPRJXAOLuTaN0yGl7ehjl
 YW3Z0VKcBUtdDVfO7viDto/qCTnndUDeXwVENn3MjUBbfN2krsJnFvPWCRvZdkPvSm0h5n6pzCu
 D+gEV3spnjEH+3Ax0CKvkrNtYjSO0vdj9hdeercs8HyJQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from workspace-fedora (116.128.244.171)
	by smtp.migadu.com with ESMTPS id f7e5b7662ac16178;
	Tue, 25 Aug 2026 13:51:41 +0000
X-Mizu-Trace-ID: f7e5b7662ac16178
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 0/3] ksmbd: refactor smb2_notify() to a blocking wait
Date: Tue, 25 Aug 2026 13:51:05 +0000
Message-ID: <20260825135108.716663-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v4->v5: Rebased on ksmbd-for-next branch.

v4: https://lore.kernel.org/linux-cifs/20260809161916.1071530-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smb/server: support compound fid in notify requests

Gael Blivet (2):
  ksmbd: temporarily remove interim-work change notify handling
  ksmbd: refactor smb2_notify() to a blocking wait

 fs/smb/server/ksmbd_work.c |   3 -
 fs/smb/server/ksmbd_work.h |   5 +-
 fs/smb/server/smb2pdu.c    | 349 +++++++------------------------------
 fs/smb/server/vfs_cache.c  |  48 -----
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 65 insertions(+), 346 deletions(-)

-- 
2.55.0

