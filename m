Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BE625A2C6
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894344; cv=none; b=tIEu6uGZuveN/k5RuLKLlP0d2t/KiUvjO3Prz+ubZeuBAe15fRK8LEFMjHzIBILVtqYY2B7fC60lT4jGW6/ZU8YdGWkiGGGRlSUOaoF9wgy8HaflB1BQE9rYJbvDYQE/Gy+gFCAtMADOZKbgHBebTKq890bGywifdvdVaP9nCuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894344; c=relaxed/simple;
	bh=JN9udTp00gYsMoFdOOcTRd+vq4Fs7yMWGm+DhLp5WTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gr6nrUHn6eDqGjNXF4s37kpID3eswTNmKwfsvmUDaBpflP3rO+QKNqiu8iNdLXDrlG6PI4NYEfAyJHhlmQQn5f0uBDYobb3ohIZ4c2QU0vemdMNIPmVXpTVNgsVLaQG3mzLW4ph1T021Yk3niDIcCxYfGh15K8hdFsEs9tyrf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=FaTjLAdl; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="FaTjLAdl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6IXvICZiqdW7qruMlAUk6O7AyPlFQiZSNaFTvJ4GVx4=;
	b=FaTjLAdl7CNx4hJmQt+YuRuEciTTeJLvXWKv93fAU0MSEBIRPX2O3B9vrqdof1ulFZI1v/
	qS/8qTUmxvHb4iIqDwwzW1Lrt+z6Vf4wjFD3Yku703UmtG2eoyaFFy3Niv8F1kpPuB4dU6
	2e5zwDwz4u5NxeccT9mpydka48dHn0lu3/BwHq9dLR2iEnqHQwVg6QLOJ+wvaTHSxdhH1F
	ON5cysQ745elt788+vToFJb1l7YQV/NeVgutjRktgC8c+JtlgiBiWw+F3Y7kCfcM6XogiC
	odHOl7/Yp3CLggiuhli5KUUQKR6pwAyZPYYlWCxTnbY4mqGWCeSEVxHmzz73cg==
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
Subject: [PATCH 0/9] smb/client: improve change notify support
Date: Wed,  1 Jul 2026 08:24:58 +0000
Message-ID: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

This patchset improves support for SMB client's notify feature,
including the following two improvements:

  1. Support for notify cancellation.
  2. Support for receiving all action notifications from the server.
     2.1. Before this patchset, when an operation on the server triggered
          multiple actions, the client received only one action notification.
     2.2. After this patchset, the client can receive all action notifications.

Example:

  smbinfo notify /mnt
  
  # server: touch /export/file1
  Notifications received, returned data_len is 24
  Action: 0x00000001, FileName: file1
  Notifications received, returned data_len is 24
  Action: 0x00000003, FileName: file1
  
  # server: mv /export/file1 /export/file2
  Notifications received, returned data_len is 48
  Action: 0x00000004, FileName: file1
  Action: 0x00000005, FileName: file2
  Notifications received, returned data_len is 24
  Action: 0x00000003, FileName: file2
  Notifications received, returned data_len is 24
  Action: 0x00000002, FileName: file1

Then press `Ctrl+C` to exit `smbinfo notify` command.
The following packets can be captured using tcpdump:

  - client: Cancel Request
  - server: Notify Response, Error: STATUS_CANCELLED

ChenXiaoSong (9):
  smb/client: factor out cifs_new_dir_fileinfo()
  smb/client: close cached notify handles on closedir
  smb/client: prepare notify ioctl per-open state
  smb/client: cache SMB3 change notify handles
  smb/client: retry change notify after invalid cached handle
  smb/client: add helpers for sending cancel requests
  smb/client: remember async ids from SMB2 pending responses
  smb/client: send SMB2 cancel requests
  smb/client: make SMB2 change notify interruptible

 fs/smb/client/cifsglob.h      |   6 ++
 fs/smb/client/cifsproto.h     |   4 +
 fs/smb/client/file.c          |  54 +++++++++++++
 fs/smb/client/readdir.c       |  14 ++--
 fs/smb/client/smb2ops.c       | 148 ++++++++++++++++++++++++++--------
 fs/smb/client/smb2pdu.c       |   1 +
 fs/smb/client/smb2proto.h     |   3 +
 fs/smb/client/smb2transport.c | 105 ++++++++++++++++++++++++
 fs/smb/client/transport.c     |  49 ++++++++---
 9 files changed, 332 insertions(+), 52 deletions(-)

-- 
2.54.0

