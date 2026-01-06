Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF02B1E5B9E
	for <linux-cifs@vger.kernel.org>; Tue,  6 Jan 2026 07:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767683789; cv=none; b=PMMoqzEkwouWZo41/E4qb6p5AeAlSFhNQFApmSCakibsUcxH0A6cpIPmdUbsGm4Yz6SOeVWGnJMocp3Ro9wPv8slwp6OqGjfN2GENwuPnEyk3fAg2GK6nDlVLvBPDrizV5BMZU4D3MfstLiYKiESNp3ttyaoJQEDwrIBo6lYQH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767683789; c=relaxed/simple;
	bh=PGuSPraPc4NArRuQ5aPJ+SynhaLTgqE9JdZwViizqS0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U1MHaq4cwzThWKWxMSQTITW9NEAg9eWnpmOAQxaej4UOx9OjUboq9asy/IZ4ReJPNgO/9uTv8k7BrziIBh1fKHoOM8vWBCuXba8J6z8WXjUGZNrvYPGtfwq538GU35X7RmiRKgp2BcMpEnojSPbUjZqoOYaW9fJKy4qwSzunGmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RhmM+SWq; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RhmM+SWq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767683785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WrJdu/+c6y4ltm6akwvk2RqL44Tp0MlylNFm/26csqU=;
	b=RhmM+SWqAhJLqDrIseO5m86q6wdauEaMSOOS9kEgEPAQt+xLiuCy6HCItkRb9XDQOZ5dhg
	G+Dr6z2+oj1Epf7lc50JWonJGuArXqE+5pTz4TMJahdsScPmpC6qv7FJYSCUzRYgRL3lQG
	RIlfFMcsTSekWR85kvcx7sCR+h/GAkw=
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
Subject: [PATCH v8 0/5] smb: improve search speed of SMB2 maperror
Date: Tue,  6 Jan 2026 15:15:02 +0800
Message-ID: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
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

v7: https://lore.kernel.org/linux-cifs/20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev/
v7->v8:
  - Patch #04 #05: use `const struct status_to_posix_error *`
  - Patch #04: update print message in map_smb2_to_linux_error()
               - pr_notice(..., err_map->smb2_status, ...)
               - cifs_dbg(..., le32_to_cpu(smb2err), ...)

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
 fs/smb/client/gen_smb2_mapping    |   86 +
 fs/smb/client/smb2maperror.c      | 2469 +-------------------
 fs/smb/client/smb2maperror_test.c |   45 +
 fs/smb/client/smb2proto.h         |    1 +
 fs/smb/common/smb2status.h        | 3488 ++++++++++++++---------------
 8 files changed, 1973 insertions(+), 4152 deletions(-)
 create mode 100644 fs/smb/client/gen_smb2_mapping
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

