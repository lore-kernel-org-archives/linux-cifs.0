Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0506F31E820
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 17:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802186; cv=none; b=b+eH9sEltMbRiovc6FbSX5slTehlo0gNe8wIuSK0kIxP/bYjHtEIDmbr7rQQzOsCffXCvvpq0EFZ2ewdKUw1u6oZITF4obfo2cMS93wSjQSa2QOxUIzkMNqtc01zfiIDDUsay3taoKCDmt2SbPgHHKd2Zir8Wrn0HKK2eQOzEkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802186; c=relaxed/simple;
	bh=F77SZg/sZ/piD5kUQ2SFfI8zOo4fCi9+OfCQLMftEEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p1mvG3ciDOCHm5WYfulVRyoextzR+6qEvXzc0/eNF4Jaz/5qSA9Dnm66ZTOIgmpPbAJksZtIWigrvhYsE/bWxx+R33zIIQw3eyoICus0JbFTabhqj6ZZG5HMf0Ss5gclfoeNVdhHEHfPpFAQQUyflM/NYW6104eK3IDjCjJawPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ifrBlWAZ; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ifrBlWAZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781802179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UdU9SurTQu/FuBd2O1l/zrKVszrxAtIFrDjX4R6Tlp0=;
	b=ifrBlWAZvZhFoDAq6Z7B86G0bIvq6Z3OyyTcc7qTVQqDlirIwyRXbD3q1YhLHBbk521SRP
	GSYBLHRk9QEC4TqlG53fOuVKE2Q+s8evYRVokDkAUSkWRUCKOJo30aX9EhJagkA2WzCw93
	mOFvubzk2dY61KbG7/hMMXuNyhY4n+uVSI/v88EYugCivByI3Xts2WqiSrZXZFJDiNraEV
	iR9qpvItI4e+nmbSka12u+fFDxqFAYW5z5bAVmmHiKxGm556qfynOttmlVGEN/aUT8HNiB
	2QCy4Kq7qmbU9dZsOAdlFTeikR3pbDHIRx5tc3p7vl1Bo+WxH/wCIcGIvJG7dw==
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 0/2] smb/client: improve change notify support
Date: Thu, 18 Jun 2026 17:02:00 +0000
Message-ID: <20260618170202.244402-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I still need to do more debugging on this patchset, for example to check
whether there is any race between `ioctl(CIFS_IOC_NOTIFY_INFO)` and
`readdir()`. Maybe I can send this patchset to the mailing list first
to get more suggestions from others.

Before this patchset, when an operation on the server triggered multiple
actions, the client received only one action notification.

After this patchset, the client can receive all action notifications.

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

ChenXiaoSong (2):
  smb/client: introduce smb3_notify_open()
  smb/client: do not call SMB2_close() in smb3_notify()

 fs/smb/client/smb2ops.c | 120 ++++++++++++++++++++++++++++------------
 1 file changed, 86 insertions(+), 34 deletions(-)

-- 
2.54.0

