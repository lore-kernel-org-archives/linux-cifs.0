Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5B3B27E2
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927366; cv=none; b=ClIW3tgOgasBg41d9QOB4rRJW4uYOCLwMYmLFTDjUnDSUtR8qUfyp9FPuF7yYNop+bqOQQkLg7+TDTzgoLvWuX8boTQgca9B14oiLIASLwJUHPS1u3Yz0BHwTmgQQ1gTQ5HONYJcTXuK5bA/7IFTSVUsHeQYaHeMOK+WJ6Ra2PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927366; c=relaxed/simple;
	bh=ATGRzqREpv3wp7E2+FdI+DRgl5/1pYwVVUL+xNnCHlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZXvg2vmzRDEAJ4M+/t33PT3GBUXH2hNDlmYBB2P3bHObsMsY3ZRctY+tyuLd9n84XUdYGZ15mVOkyqGzd07CBG1qPqfHKbwkp0SwDicYS0HZIFo3pXq5oKFtITjpL/UlxgZsYofDQ9mJlYfwbAgYvgk7tJAEf7GV3wuZBbpXvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=jB2Jp/qy; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="jB2Jp/qy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780927359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2GJzehYFWAkfMNqD4emP2S3QnVUEDjwlHN3sI7EzgbA=;
	b=jB2Jp/qySI7mBIMlhyjAnLelOBHOmbQdsZxB59+9qp6LBzQueR6hoSpFYkYlZUBGQup8cC
	MzoYfItE+UnmBCdwoHKnEwa1FN5Desm2E8bM6qndw66HZCOGqhK5wfMCVfSVrdykvecRHt
	A4kF9Um1PzxnLJn/y68Bc2IedAz91LWRdTYKHI7Z414r19JTTX6EbOs5FZ4ltFo5d/aQEk
	A3nEY27n5o35wB3z9xzz8TvMmoQzcsKph93uReYcwa3ypgEFmEETwBpKPKzijXN9z/HAAt
	ZWlzSCe6/fNpku1UEfa+u3jc1QHK6KEEUYrS2V6pn2oABPrDZm/UpVeBlMR1mg==
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
Subject: [PATCH v3 0/7] smb/server: implement compression fattr handler
Date: Mon,  8 Jun 2026 14:01:21 +0000
Message-ID: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
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
  - Add patch #06 #07: get correct compression format and file size in get_file_compression_info()

v2: https://lore.kernel.org/linux-cifs/20260607022705.317863-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (7):
  smb: remove duplicate server/smbfsctl.h
  smb: move compression definitions into common/fscc.h
  smb/server: get compression file attribute on open
  smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
  smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
  smb/server: get compression format in get_file_compression_info()
  smb/server: fix incorrect file size in get_file_compression_info()

 fs/smb/client/smb1pdu.h  |   5 --
 fs/smb/client/smb2pdu.h  |   4 --
 fs/smb/common/fscc.h     |  18 +++++++
 fs/smb/common/smbfsctl.h |  10 +++-
 fs/smb/server/smb2pdu.c  |  82 +++++++++++++++++++++++++----
 fs/smb/server/smb2pdu.h  |   3 --
 fs/smb/server/smbfsctl.h |  91 --------------------------------
 fs/smb/server/vfs.c      | 111 +++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.h      |   3 ++
 9 files changed, 213 insertions(+), 114 deletions(-)
 delete mode 100644 fs/smb/server/smbfsctl.h

-- 
2.54.0

