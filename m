Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFC51DE89A
	for <linux-cifs@vger.kernel.org>; Thu, 25 Dec 2025 02:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766628703; cv=none; b=XqJUrUvMa0d2InbIIaF16JuigqHb1nJYrlfzasS0G5TRb/iKLuaR5VNtSxvMkZnrq+w75EWpUzwr5PiRvV/nEK+6Q1w6LHtNyx40D9eCZKY3waY5/fKarA+Sr8w2UdaSNyTLjIoGZ7486EwXtbn/4BW1Se0821+/FqHNA0JN/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766628703; c=relaxed/simple;
	bh=a5X7MGj1yVvYcPlqANkL+P9EStlf0HoMVzgmLiWfgXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BNyFBR5d75VXGywc0E8zm1BJmEzrSRHz3HZesJHdWGwRfMiz8JxMLDK1heEPdstWt4fV+rMf2bB744mEw8c5cX+7TN8EN9eZW8+2QoCgXAQa1HDP7+WFT7pY/tZOHhlrUzJ/RWkfd9okegp8ly9ihu7wOftXPKxqMtZ1xnc8DHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BfKBIoy0; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BfKBIoy0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766628698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=W2wvvZWJf2Ubuw/f+vLNsRPvN2Tn7tX775nqaF2Z/7Y=;
	b=BfKBIoy0ROnYxjUk1XvO8NxW/7qHw6v0utUaki5tt7RVMHQ02R0itbLNZpZJMMN6+VMawl
	5nO09gz4pWPKSuIZX3gcFj4qLPbNJON1vDB+SLFic/w7H9CcdXhYB7JvHLUhMyiNgURV7Q
	4A8I44s7AYJnR9InnzZGLswarEri8Lk=
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
Subject: [PATCH v6 0/5] smb: improve search speed of SMB2 maperror
Date: Thu, 25 Dec 2025 10:10:30 +0800
Message-ID: <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Sort `smb2_error_map_table` array at build time, thanks to David for his patches.

v5: https://lore.kernel.org/linux-cifs/20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev/
v5->v6:
  - The following changes are based on David's suggestions. Thanks to David for the review.
  - Patch #03 #04 #05: replace `err_map_num` with `ARRAY_SIZE(smb2_error_map_table)`
  - Patch #03: add `__init` to `smb2_init_maperror()`
  - Patch #04: use `__inline_bsearch()` instead of `bsearch()`
               add `__always_inline` to `cmp_smb2_status()`

v4: https://lore.kernel.org/linux-cifs/20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev/
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
+----------+--------+--------+

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
 fs/smb/client/smb2maperror.c      | 2464 +-------------------
 fs/smb/client/smb2maperror_test.c |   48 +
 fs/smb/client/smb2proto.h         |    1 +
 fs/smb/common/smb2status.h        | 3488 ++++++++++++++---------------
 8 files changed, 1972 insertions(+), 4150 deletions(-)
 create mode 100644 fs/smb/client/gen_smb2_mapping
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

