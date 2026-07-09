Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CD336DA0F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 02:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783565899; cv=none; b=dSmVMaxw8hqfMAdO7GjZ4DDX+HYFUAROJa43zMFEbOZrXiBsOgIq5lPLTUVZH65JouYzbFRbDuINjm8E6EeoV5VElyScfBHAyHkLTR3a6eg9H6qsqNfHStwLodGW1MdeHk66jGgimp5f73KeumqzG4cmglbBaD0KzApfSBb7QQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783565899; c=relaxed/simple;
	bh=3JOfCUf13i+D4LDb4Tw/7iHhtqEz7GgFBbgd92oc63k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oDVueFlTRQqCnKzd2AlTMV3Qgn4+44GQdOa9ev4FohM5kP+BP+ejGcVwcz7lXW9wd/mefqd16RTiMbKHoUosxQOARuJc/G952wJz624hGAm713iyKMtRAJe/fGn3YWD+oPgNQQRHqcwOhZjupWnY+I6xcPIgSuSObvG7l9jege8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=iywKI7L9; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="iywKI7L9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783565893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EmfFMcBldBz6vkJxOVfZnh1ET7+u0ohgp6RgTFVNIaY=;
	b=iywKI7L9guZWySolYU00XcAkiRAu3gC47a1PiApq0AL5WCY/UTfpFAktqabU0ugG3PDvpF
	rOYOvNhafCenHY57R0ZZk+cCD+NVC+Y1H9xkQhVFc9Wfo2PUTMFM22iVdN/ztOEMqYYtLh
	G3mRCTPB7SIuPL+erumVLrKLzxcxqQ3iPYMJ4DVqeMewLckC0u70DNRS/M2Zj5b+1NcLDF
	u/kQivQToXPmGIWEJYWvyeQEW2VgfJ8c1oI5DQFsPId8uf9orgxPi+jSpjV7dT0ozpUVv0
	KIC4DlYT7DUOnc8Co8KHmt2C8wE0gwhLgO7oerI2HUKqzGM8QiY6ntskFYqMUg==
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
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 0/4] smb/client: fix incorrect nlink returned by fstat()
Date: Thu,  9 Jul 2026 10:56:59 +0800
Message-ID: <20260709025703.3715326-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v4->v5:
  - Add patch #03
  - Patch #04: add unknown_nlink to struct cifs_open_info_data

v4: https://lore.kernel.org/linux-cifs/20260708162552.209468-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (4):
  smb/client: use stack-allocated smb2_file_all_info in
    smb3_query_mf_symlink()
  smb/client: pass cifs_open_info_data to SMB2_open()
  smb/client: zero-initialize stack-allocated cifs_open_info_data
  smb/client: fix incorrect nlink returned by fstat()

 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/inode.c     |  2 ++
 fs/smb/client/link.c      | 17 ++++-------------
 fs/smb/client/smb1ops.c   |  2 +-
 fs/smb/client/smb2file.c  | 19 ++++++++-----------
 fs/smb/client/smb2ops.c   |  2 +-
 fs/smb/client/smb2pdu.c   | 26 ++++++++++++++------------
 fs/smb/client/smb2proto.h |  2 +-
 8 files changed, 32 insertions(+), 39 deletions(-)

-- 
2.54.0

