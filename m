Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D442B407562
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996217; cv=none; b=UDryj6uhv6VzYn4H71LD5jN6//MVECeNgKF/UNe676qBuqy85VPTDBCBUh7G28CDifYyT+8iWH1ycFz3ijGITlabzvRMgJcW2tDJw/r+aLdI91nYMp4MMvoGVVo1WxN1Kb9Sz4+I1jl0VRYcOFtOn1gw3JRu1SUhQTyvjIVB7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996217; c=relaxed/simple;
	bh=x3bH6MlfYgUnGRwzoV8lg3XaLJR4NM8antQly7ibNoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hlIGNyO2myLisqybub2ZFO4AOH6VfQgu+CnAem9TgSH/JB/BP3wvr7GrCmoFG5zMDFOFZIakUsovWZd4WWqHY1EnEscIyqJxHyYU3HbeF1OhBGLkfEL5oTaNZhD73DRQLtgNEJIYXo5rLVfX23q6jXiTLPHJC5HMYOAomm1AV0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i9rTqcrW; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i9rTqcrW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P0y/cM9SHhDziEhJURviJ6EceCr35nuyB+be22MiWaQ=;
	b=i9rTqcrWpm6zAuS+967c7umTdxw4AlMZju4LfatUEuKRVsSYGu0kYaVa4249VnZJAGx29D
	UATXIgyt1UpZrT+KIk3jTw16FGQCoGQn7S+mIwz1m6e+yckablnae355h7JU9g2LW8f+94
	4KnHbYQj6SYM5KCvowN032lNi8bXjCY=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	hehuiwen@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 00/17] smb/client: update SMB1 maperror
Date: Wed, 21 Jan 2026 19:48:55 +0800
Message-ID: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

My dear team member, Huiwen He, added some NT error code macro definitions
and updated some arrays of SMB1 maperror. He will also update the relevant
code in the userspace Samba repository.

This is a preparation to improve the search speed of the SMB1 maperror.
Huiwen He and I will soon complete the patches of improving the search
speed of the SMB1 maperror (I have already sent the first version).

Huiwen He (17):
  smb/client: map NT_STATUS_INVALID_INFO_CLASS to ERRbadpipe
  smb/client: add NT_STATUS_OS2_INVALID_LEVEL
  smb/client: rename ERRinvlevel to ERRunknownlevel
  smb/client: add NT_STATUS_VARIABLE_NOT_FOUND
  smb/client: add NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT
  smb/client: add NT_STATUS_VOLUME_DISMOUNTED
  smb/client: add NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT
  smb/client: add NT_STATUS_ENCRYPTION_FAILED
  smb/client: add NT_STATUS_DECRYPTION_FAILED
  smb/client: add NT_STATUS_RANGE_NOT_FOUND
  smb/client: add NT_STATUS_NO_RECOVERY_POLICY
  smb/client: add NT_STATUS_NO_EFS
  smb/client: add NT_STATUS_WRONG_EFS
  smb/client: add NT_STATUS_NO_USER_KEYS
  smb/client: add NT_STATUS_VOLUME_NOT_UPGRADED
  smb/client: remove some literal NT error codes from
    ntstatus_to_dos_map
  smb/client: remove useless comment in mapping_table_ERRSRV

 fs/smb/client/nterr.c        | 15 ++++++++++++
 fs/smb/client/nterr.h        | 13 +++++++++++
 fs/smb/client/smb1maperror.c | 45 ++++++++++++------------------------
 fs/smb/client/smberr.h       |  2 +-
 4 files changed, 44 insertions(+), 31 deletions(-)

-- 
2.43.0

