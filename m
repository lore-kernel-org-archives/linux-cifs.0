Received: from out-186.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190A3D333B
	for <linux-cifs@vger.kernel.org>; Sun,  9 Aug 2026 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786292427; cv=none; b=tgkv48cyRwfpW/Vibf2HNKxLnd7XNc07VHTq6r8V3tek9uVAnIKrzsLeADOFr3ST4BGFHayAtZoEXrIwcMS53hB/ZljotIsHkqseM+rDg5RiMa7Afh3EavoRaKX+srYUN2Mz7ENNKhWTKrgXTntQiptLe91/18L3HnedlQvlLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786292427; c=relaxed/simple;
	bh=7DX8JUpbMhcawM7dxu1kPKj0ASmeAmZa/pkpOrxGrfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d/BwUYes7lrWMMv2P+ARcVW5nY4LfD8W8oBCUFY6SD3LfpbxNyhU3Yfsf9kqZIhInOjonLisDqCh9RDCjjxEgCrccG2UGY3KIbH60r86176WJJjWq1m7Cd++wJogLXvxBdKrP0Bop5DhLKa6uWvPVTg+ve8RURlDNeXNc1OEHnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hrT+gQzq; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hrT+gQzq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786292420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eO2eUvLPu9DOE0W3RcWmjQN0UbK9lEi2zz8QMgS9M6I=;
	b=hrT+gQzq643bIDLeDjqjDVPscIFtzjmlDOLZbzIQ+ofA7UnGdxjIsIGms7sokDkRpO+hQk
	fTmonolAicjpnznptJgWilV+Hsiy3oRSTX2A/iuYPe8+ELLIgo/JUN/ScTTn1oGvzwuz4V
	QKv0TrqSfj2iUZJpdomPaEyLqqD1J/r7zrsqEQByWw38RQOCf604Vm4LBnuARXnivaDG5Z
	TuCmBdOV/keEsY+T55NKVq4aW0ZsdljTKdm4vcsKbb2zRM4PCWppzylthY+rpHaIR4XI4Z
	0QSBDRfszNoTmxWZElsiaGJFqgCXq2XsEW2KF2xwz0uzCWgrZgIcB7QfcomvFw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
Date: Sun,  9 Aug 2026 16:19:13 +0000
Message-ID: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The next version of my complete notify implementation may still take some time to modify,
so merging Gael's patch sooner would help avoid repeated rebasing.

v3->v4:
  - Patch #03:
    - Rename: ksmbd_notify_wait -> ksmbd_notify_req.
    - Return the error code instead of 0 when an error occurs in `smb2_notify()`.

v3: https://lore.kernel.org/linux-cifs/20260808064145.1002261-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smb/server: support compound fid in notify requests

Gael Blivet (2):
  ksmbd: temporarily remove interim-work change notify handling
  ksmbd: refactor smb2_notify() to a blocking wait

 fs/smb/server/ksmbd_work.c |   3 -
 fs/smb/server/ksmbd_work.h |   5 +-
 fs/smb/server/smb2pdu.c    | 335 +++++++------------------------------
 fs/smb/server/vfs_cache.c  |  48 ------
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 65 insertions(+), 332 deletions(-)

-- 
2.54.0

