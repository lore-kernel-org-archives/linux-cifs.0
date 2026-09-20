Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0043D7D74
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789883826; cv=none; b=bUIz4uuKG1s/idQdkTKSrIsDW6NxpwR5M/wTXFA30/ULv+EtxIYHM0kLNRtfdqMOLpw892mvRdfsyww8iPLyEh9GhMNRolDDt/B2jB8kAijLXC2fwRNnA8c6+O+Ci+UDMQ82L9nJklGaNK23OAQVPOp6l9kSYfE92dmFtYZyv3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789883826; c=relaxed/simple;
	bh=qNSjSPJ8+/TRJ5drmhcR2+QZn0GaqooROE1QKibCd4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z7xTJ4RZkODc4jtPev+O2/laxeZ6EWZ+sPXs4zc2ClLwi/h2eqJWlkgmpoDHU+fUsEhCyfZWuJb+xmMmp13tZK7pVuFdIxDMsFlvsS7A/iRYNqcr+0puaq13NWU8l8M55U76DNu/fA5C5MkiDo+owtFsqd4WA4TeiCd5W66cceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zci3L5c4; arc=none smtp.client-ip=95.215.58.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zci3L5c4"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qNSjSPJ8+/TRJ5drmhcR2+QZn0GaqooROE1QKibCd4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789883819; v=1; x=1790488619;
 b=Zci3L5c4tBCT6TFsNvKvP8Jph+r9GsVycxaHxsRCtFXKAbUN0b20LWu7mwEBhC4Yc8oQUse+
 ErQWD+r5aVKDsRQLE9Vn3JD8rxsAZzGPYkLtyxE9jCuENMItg+m0gVlSMHw125AT21yuQXwJB86
 +DKzeHVUNgY6gMevCjy49jw0=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 484b70df6fd80013;
	Sun, 20 Sep 2026 05:56:59 +0000
X-Mizu-Trace-ID: 484b70df6fd80013
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/3] smb: update POSIX extension specification references
Date: Sun, 20 Sep 2026 13:56:50 +0800
Message-ID: <20260920055653.114794-1-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

ZhangGuoDong (3):
  smb/server: update POSIX extension specification references
  smb/client: update POSIX extension specification references
  smb/common: update POSIX extension specification references

 fs/smb/client/smb2pdu.h | 10 +++++++---
 fs/smb/common/fscc.h    |  3 +--
 fs/smb/server/smb2pdu.h | 16 +++++++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

-- 
2.55.0

