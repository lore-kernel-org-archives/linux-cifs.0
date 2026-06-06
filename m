Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B8E3845B0
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780757042; cv=none; b=UKi8hRlY9iuAPCvazvx/pjKeqdMUI72d9X66EVPHC50J7595O6bdW/hFs3OcFcj1Sf8QHoDUsDyafmgOvX8EBQoMMFPlJVdgqFKVXuBfsy8uV0FCDgjagHAhxQPy1J0MetHZLXjYqW1FNkNcjMpkQgm2DiBr9KzY5oxYlipQQM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780757042; c=relaxed/simple;
	bh=X2/oXyB4xU7zE/Lfo9d4EUL7l8G7yofTLVAQGCPbNfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UFNZRrt+fQB3oSLC1T8VEj5Vpsz8zMcqAM8jN70DRLemVvbXudLsypKuLwubxHVGjSNRWKPpQoXW+nADlmYwxSPoraRy6dXs0thBdELuJyATNj+KgnjQRrCnYN5zUr0x9zaqPrznrec9em4woOxLoxttR0QcQO1lCvkG0mlG71U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NhgOlH9R; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NhgOlH9R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780757038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mTHLaEYkRnrTr2lyf1tIGoFZEAx/HRiH0pJ40dLnPc0=;
	b=NhgOlH9RMcRDSPjfFlBXcNDgxXi9ZMVJ03QpadWWOdUX+mKc6n+aapwgogyyzOhpXUV+Xd
	J6zleHDS9PNxHn+QThnE/Zh9izJ1lBERrEPdwUC/9U842NIyTG+r9ejiOqasDJqgjclad/
	EBGPtAIQ/YKD9eY/gvqFXNC/cQRiy0U=
From: Huiwen He <huiwen.he@linux.dev>
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
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v1 0/3] smb: client: fix file compression flag ioctls
Date: Sat,  6 Jun 2026 22:43:13 +0800
Message-ID: <20260606144316.183032-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

This series fixes three CIFS compression flag ioctl issues.

Patch 1 fixes lsattr showing random flags when the file does not
have the compressed attribute set.

Patch 2 fixes chattr +c failures caused by sending
FSCTL_SET_COMPRESSION on a handle without FILE_WRITE_DATA access.

Patch 3 fixes chattr -c failures by sending
COMPRESSION_FORMAT_NONE when FS_COMPR_FL is cleared.

Thanks,
Huiwen He

---
Link before v1:
patch 1: https://lore.kernel.org/linux-cifs/20260602105930.713403-1-huiwen.he@linux.dev
patch 2: https://lore.kernel.org/linux-cifs/20260604151859.102653-1-huiwen.he@linux.dev
patch 3: https://lore.kernel.org/linux-cifs/20260605170055.172146-1-huiwen.he@linux.dev
---
Huiwen He (3):
  smb/client: always return a value for FS_IOC_GETFLAGS
  smb/client: use writable handle for FS_IOC_SETFLAGS compression
  smb/client: allow FS_IOC_SETFLAGS to clear compression

 fs/smb/client/cifsglob.h  |   2 +-
 fs/smb/client/cifssmb.c   |   4 +-
 fs/smb/client/ioctl.c     | 151 +++++++++++++++++++++++++++++++++++---
 fs/smb/client/smb1ops.c   |   5 +-
 fs/smb/client/smb1proto.h |   2 +-
 fs/smb/client/smb2ops.c   |   4 +-
 fs/smb/client/smb2pdu.c   |   6 +-
 fs/smb/client/smb2proto.h |   3 +-
 8 files changed, 153 insertions(+), 24 deletions(-)

-- 
2.43.0

