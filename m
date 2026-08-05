Received: from out-160.mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3B30C156
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 04:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785904713; cv=none; b=tT9VuXmPJwFsUSj32ZyoJ8gMPQcOWcGBqo45dFrxuM+MoIxtTdt1lqZQPPb54F/ZXavXUPe5ZUcBoe/y1BIlYKH1WGZbnzwNo5xOqDnh4CT0ITuclVftia/X1U77tmMPtrc8TVZAh5tmLoVPPJOZUbvL1/Y7pbCzj4JcN3tRqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785904713; c=relaxed/simple;
	bh=xV3ZMLJ9M50cXb8gbeHKTwn+u1wxVM0hwRqsExUteiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FD+RwBXrNGvGGf8E5db//hN4Caw8pbr3zAs3xJvTRJR+D6xd0wOMpgxQE8BMhGTofjcziUmnigDYRJiY5YLM+3pawQgqQWfD657DDhzzxG0fyJ0MA7mpnPYecZxOZj1RBY9Spvs+20YITKW3Y4fKAwJsjldqkETSOzV56cz05ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=i9cTSs8S; arc=none smtp.client-ip=95.215.58.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="i9cTSs8S"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785904706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kAmxebxIKNK4u+3+CrSCvi3QXoT6DdTam/1yaGbKlG4=;
	b=i9cTSs8SIXCOm8fB7lGH8M2bMiSewybO5aX3hVVquoT6nWY6AvL2hOqrDgWDCWudEPaaL9
	VkPRsi29Q7cdpN9CPLXJWwMWWiAk3ZR83WzlJr9cebN1grb2z89w9cW5aW4gnDevu2uzTw
	+IyFfwPhcgr52W035JGqYAT9067yMA7iBIec3lxCVRzz+Gdbki8GEpn2jhYghIpWc+1E5t
	nG/PTkjKAlfi/1S0pP74ufTGLct0SApqbUaDj/tm/8GGnXrRchBEXED3UZ+Zpg3lwMBBpI
	7irsg6Uu0l0/CKJtr51N5dfHK1PX66eVsYUxXLSKc51BXLk5tbXUXIxYWj2APQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 0/3] smb: fix xfstests generic/035
Date: Wed,  5 Aug 2026 04:37:01 +0000
Message-ID: <20260805043704.304533-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v2->v3:
  - Patch #02: iterate over `global_ft.idr`.

v2: https://lore.kernel.org/linux-cifs/20260804123301.285434-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (3):
  smb/server: rename to ksmbd_has_nonposix_open_child()
  smb/server: deny overwriting targets with non-POSIX opens
  smb/client: fix nlink of an overwritten open file

 fs/smb/client/inode.c     | 11 ++++++-----
 fs/smb/server/vfs.c       | 15 ++++++++++++++-
 fs/smb/server/vfs_cache.c | 29 ++++++++++++++++++++++++++++-
 fs/smb/server/vfs_cache.h |  3 ++-
 4 files changed, 50 insertions(+), 8 deletions(-)

-- 
2.54.0

