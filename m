Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB9D23EAB9
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 02:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766543584; cv=none; b=sgPYlrKnUcYKRgO/oaFi1kHMuE1lWTgc9jGydfc1Q65TGebSDAnAvLzblcpLAWW6yE26PHfE70ObXJOf46eKj8NB7b60JGPi8MidGwX+EukgGGKOBStzt2ZMBnYTyUUNkcbWIoQV9xxDd/rKw4OvVLt6RBLyaphW38TbQVLtcfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766543584; c=relaxed/simple;
	bh=sS/PlEHY0DyymzOgQHGVtJdWj//3SkfF16NQ3QlaKYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XkcQr5bR35WcSfCX+Q4C9ULSRBiHiUhXKR+M0k7a24wGe8DBHc/lvIlgGre1VhgSEgyVX4xpKKgY84o3O5Yv8+Wm8/GkxvNjr8WR2dzp4N0MS63xQgaY2Up2ndS18UtXw56qAXXAR7K02nsju6sZa7Ta1cTQKB0EhuyZdN/DjGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K7XOL906; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K7XOL906"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766543571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+QwDt/UdDvpeK2KHCVaeOQsVlMocLddnAIB/+5rJDBU=;
	b=K7XOL906PrA+pXUhq7AXgY2mqM4zyO14s3gCLbRbs1OqVbFHkZhuxHJwTVNML0HJSlQ3OD
	1To/KdJMnneXGbmBE5lmdpUC/QgE2tMXzGY76GGNjOsLrqHyp9uU5Mi8PYvoMZfK5YxIjO
	mV51V+LNOKy0i8CSqXAB2hZOd8Uk3hA=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 0/5] smb: improve search speed of SMB2 maperror
Date: Wed, 24 Dec 2025 10:31:39 +0800
Message-ID: <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v4: https://lore.kernel.org/linux-cifs/ce09c209-c97e-4dcb-b3a7-b18ba56a86a1@linux.dev/T/#t
v4->v5:
  - Sort the array at build time, thanks to David for his patches.

The following patches from v4 have already been merged into the mainline:
  - 01ab0d1640e3 smb/server: rename include guard in smb_common.h
  - d8f52650b24d smb/client: update some SMB2 status strings
  - d159702c9492 smb/client: add two elements to smb2_error_map_table array
  - 523ecd976632 smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
  - bf80d1517dc8 smb/client: remove unused elements from smb2_error_map_table array
  - 6c1eb31ecb97 smb/client: reduce loop count in map_smb2_to_linux_error() by half

When searching for the last element and printing error message,
the comparison count are shown in the table below:

+----------+--------+--------+
|          | Before | After  |
|          |Patchset|Patchset|
+----------+--------+--------+
|Comparison|  3486  |   10   |
|  Count   |        |        |
+---------+---------+--------+

ChenXiaoSong (3):
  smb/client: check whether smb2_error_map_table is sorted in ascending
    order
  smb/client: use bsearch() to find target in smb2_error_map_table
  smb/client: introduce KUnit test to check search result of
    smb2_error_map_table

David Howells (2):
  cifs: Label SMB2 statuses with errors
  cifs: Autogenerate SMB2 error mapping table

 fs/smb/Kconfig                    |   17 +
 fs/smb/client/Makefile            |   14 +
 fs/smb/client/cifsfs.c            |    5 +
 fs/smb/client/gen_smb2_mapping    |   85 +
 fs/smb/client/smb2maperror.c      | 2465 +-------------------
 fs/smb/client/smb2maperror_test.c |   48 +
 fs/smb/client/smb2proto.h         |    1 +
 fs/smb/common/smb2status.h        | 3488 ++++++++++++++---------------
 8 files changed, 1973 insertions(+), 4150 deletions(-)
 create mode 100644 fs/smb/client/gen_smb2_mapping
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

