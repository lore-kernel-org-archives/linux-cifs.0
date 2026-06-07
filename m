Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA001DFF0
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 02:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780799288; cv=none; b=HUiCL+fK4mvuJ2r46TyRJ25ozd+a4qq5nE2MgsAUOpacIUmYi4wPQ8pKDBkSkNROMLlvs2nJdtRXx8bU/NhVptGwvxqcOKAEAhc3cJsGHOuGK4Lie5vbFGo/Tcbg92pMxOpPvASYGfWSoeLv2cDYIJz22T4xLRkFvlHVAR3raHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780799288; c=relaxed/simple;
	bh=f1AO0bLAe0r7TYtqTXHUWTimYVwwmHfsrVMAI803rcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BVdCOHRDY9KAfPUiDpTWcBuSfRd4lEueq8ZuSPXJ84zMgjZOtn0ehvK6dU/uzhcfgJRlafIUNZiagnl4SlXmSujdWAoXw9mMyzN8H54wzznsYceqBaZCR5ULjjR3azxrt2/7Now6LzCodKV7hSLfYsWrUn6Zu85yBTNiewHbkek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=I7lY23Z2; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="I7lY23Z2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780799281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2VZg9/YJHwiKaoLMZEHdBsYaDmfgiSmMO+dwkCF4tNs=;
	b=I7lY23Z2Z4uHAkFkM1y1Q8Phle201qElGhQxI8LiIsrbH72VlJuXIpBB8D3tiPAgzgrd2A
	NZ2rk6sExFs7txXpMhbY8JQj7FJhf6fdV2xjlDXV22L8VTldPQDQVFnrew9XxPJEmiY2zs
	1wGXufzBvrxw9xc9X2epxR8xuwJlkSshmwVsOprqoLheAktfFqrz4POY8T6l+DPwY2cq3f
	sirJfy8cu7HOy7wai+pNPkzBY9qd9TrylV7YhMiaWmXDmBR6OpVqPRJ9MujeUgPzwETIvE
	5ar3xnsZGRepqhKJQ047xDF02w+EJM0DkjWA4GusU8gaZvDDyap6QusP8Zr+Pg==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/5] smb/server: implement compression fattr handler
Date: Sun,  7 Jun 2026 02:27:00 +0000
Message-ID: <20260607022705.317863-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2:
  - Patch #02: remove unneeded `return`
  - Patch #03: return LZNT1 if the is compressed
  - Patch #04:
    - Don't roll back `fp->f_ci->m_fattr` when `ksmbd_vfs_set_dos_attrib_xattr()` fails
    - Remove unneeded `goto`

v1: https://lore.kernel.org/linux-cifs/20260606092601.299698-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (5):
  smb: move compression definitions into common/fscc.h
  smb/server: get compression file attribute on open
  smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
  smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
  smb: remove duplicate server/smbfsctl.h

 fs/smb/client/smb1pdu.h  |   5 --
 fs/smb/client/smb2pdu.h  |   4 --
 fs/smb/common/fscc.h     |  18 +++++++
 fs/smb/common/smbfsctl.h |  10 +++-
 fs/smb/server/smb2pdu.c  |  73 ++++++++++++++++++++++---
 fs/smb/server/smb2pdu.h  |   3 --
 fs/smb/server/smbfsctl.h |  91 --------------------------------
 fs/smb/server/vfs.c      | 111 +++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.h      |   3 ++
 9 files changed, 206 insertions(+), 112 deletions(-)
 delete mode 100644 fs/smb/server/smbfsctl.h

-- 
2.54.0

