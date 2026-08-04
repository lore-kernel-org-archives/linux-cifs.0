Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E49385D9B
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 12:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785846857; cv=none; b=Q7U2di7IJmcl9gTXyDb6lsm7FIhbAyyYEL6Yg0fWTUX43wklffAVHBZXryshW/HoPNFEqdx/SboXPCYyNhxoaEMe1aFEW8fg/WzwV7OEWvOcwClNQIoNiuEV/OuudnVZRc3fLzQW3CfQAswYkLcZahzlsiYVxXfxuTZOu2gaLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785846857; c=relaxed/simple;
	bh=W4QDUfk9xcJl1iJ3PMNEmaOyU9OkKaI+QrY5AYze38Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=caIxdidxvHq/FRIDXUgDexp0w2VomGc2TVVFO8WWjVMi4lVbxxmVGztwqMiBWTD1EDnXQ/spLGvl4TI9ulGsq5gaDyZtDYdeN3x3abhEmwVODjwQOye5MyMXFZfVwpsX6rMOWuooKKB1tKxezGEdFtSgyb3vYYRlUtjFGfZyU+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=rUoMuthl; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="rUoMuthl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785846850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R5bzhbiDmsskJT//lyasEZ2t4OC/o0r6laphcrR4AAg=;
	b=rUoMuthli/saKAFFCpy7AqyHUbcfveJTY+lAWnwaZ45ALOxza76OssfRFnOQpBLIQQOtan
	ulHFbTZpxP7EZIHo9cFqkZMWdz6DL+ZkXJu9QLd8aFbFW31W3dWpHz2R1oRFzNnFV5KQfb
	gs8ZDs6/VeKCpMZIzo8mP6buYIqi7cx0m052KS6I1MfT2Iw5zRHS0TuqpR9a4ORJN3soyz
	zD9s2ZGs0UkQi21zVbURY3bK8x9y7cn2Ud/xcfOsPEYAPf4QmBf/wia+Lhe7YxuyrF9Qz1
	dM2KnZQDgR77lxXdZafFpfKFgT8BVtQ3tjOzXfo16B6PTl5HAn13UpzhIWJ5Cw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/3] smb: fix xfstests generic/035
Date: Tue,  4 Aug 2026 12:32:58 +0000
Message-ID: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
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
  - Add patch #01 #03.
  - Patch #02: introduce helper ksmbd_has_other_nonposix_open().

v1: https://lore.kernel.org/linux-cifs/20260611085847.653284-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (3):
  smb/server: rename to ksmbd_has_nonposix_open_child()
  smb/server: deny overwriting targets with non-POSIX opens
  smb/client: fix nlink of an overwritten open file

 fs/smb/client/inode.c     | 11 ++++++-----
 fs/smb/server/vfs.c       | 15 ++++++++++++++-
 fs/smb/server/vfs_cache.c | 34 +++++++++++++++++++++++++++++++++-
 fs/smb/server/vfs_cache.h |  3 ++-
 4 files changed, 55 insertions(+), 8 deletions(-)

-- 
2.54.0

