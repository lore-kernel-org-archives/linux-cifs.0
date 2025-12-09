Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C285F23314B
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242708; cv=none; b=XEkxDzUhUC+tHx+eeV8OXMju2P8xKF6/soNZXJXqyd5wah0BJCdtaEwLomOOicSHOMwB20qHuTV4gmQmtUvN+gWSfBO7jbdAcYPLGyl40a2x49UDgVmISxaZGWsJXKqv1bHwn/+RGZs8BeRDSJQUKV4TD+pjj2CtBfQ/9lpBM0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242708; c=relaxed/simple;
	bh=f/ChYEkOVbjfthe0HiZ9fuRshyYqaJPxznwNnWno0j0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gwhrBCiOJqgl2rveb+ym0pr1xcAf1/AW3AI/2WjJyGpYA1Ubq06v/Jv6aRqvzUs1UpYufGFoRnQ/MlMba+UoR/XQtmsYRjmt4IRVA02xREFE27+JFY6ij7QeN1QY2g6jF+nBJ6cu9eF+apoc+gqs5WHpjTKuyW3wPUKEORwtnkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mdImJ495; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mdImJ495"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cqGaw1mC0ZhwGOw7NcksdnrYQdplRRV+FEW0gH5oTh8=;
	b=mdImJ495hLbldg7G0OJ3R+/gRnvkhHGR6tOHuZRxKiuXGNpVkWxEVtyLh3w3lcqbNBM9p+
	Q4qvc8nsMeaJkELe+jOH15K7g3ztpcIsPLIMnCD+TvSVRycatthTPYjoD75Lddd/h0rL9x
	gjec1JfGZS59QBqwPMe6J2iFt6Wt+nU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 00/13 smb: move duplicate definitions into common header file, part 2
Date: Tue,  9 Dec 2025 09:10:06 +0800
Message-ID: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I'm currently working on implementing the SMB2 change notify feature in
ksmbd, and noticed several duplicated definitions that exist on both client
and server. Maybe we can clean these up first.

This is a continuous effort to move duplicated definitions in both client
and server into common header files, which makes the code easier to
maintain.

The previous work is here:
https://lore.kernel.org/linux-cifs/20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev/

ChenXiaoSong (7):
  smb: add documentation references for smb2 change notify definitions
  smb: move notify completion filter flags into common/smb2pdu.h
  smb: move SMB2 Notify Action Flags into common/smb2pdu.h
  smb: move file_notify_information to common/fscc.h
  smb: move File Attributes definitions into common/fscc.h
  smb: update struct duplicate_extents_to_file_ex
  smb/server: add comment to FileSystemName of
    FileFsAttributeInformation

ZhangGuoDong (6):
  smb: move smb3_fs_vol_info into common/fscc.h
  smb: move some definitions from common/smb2pdu.h into common/fscc.h
  smb/client: remove DeviceType Flags and Device Characteristics
    definitions
  smb: introduce struct create_posix_ctxt_rsp
  smb: introduce struct file_posix_info
  smb: move some SMB1 definitions into common/smb1pdu.h

 fs/smb/client/cifspdu.h    |  67 +-----
 fs/smb/client/inode.c      |  22 +-
 fs/smb/client/readdir.c    |  28 +--
 fs/smb/client/reparse.h    |   4 +-
 fs/smb/client/smb2pdu.c    |   9 +-
 fs/smb/client/smb2pdu.h    |  21 +-
 fs/smb/common/fscc.h       | 419 ++++++++++++++++++++++++++++++++++-
 fs/smb/common/smb1pdu.h    |  59 +++++
 fs/smb/common/smb2pdu.h    | 433 ++-----------------------------------
 fs/smb/common/smbglob.h    |   2 -
 fs/smb/server/oplock.c     |   8 +-
 fs/smb/server/smb2pdu.c    |  91 ++++----
 fs/smb/server/smb2pdu.h    |  27 +--
 fs/smb/server/smb_common.h |   9 +-
 14 files changed, 589 insertions(+), 610 deletions(-)
 create mode 100644 fs/smb/common/smb1pdu.h

-- 
2.43.0

