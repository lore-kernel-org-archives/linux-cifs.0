Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E03319F40B
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034379; cv=none; b=dzNeU3dQ8NrBkUASyiGlqoNS6iT46ZGPZWi4ZyDtNyfxyzyJ7fPTFcPGUJ742xc3/pxhkVfj1A1I75OMt1+B6x5exO7hvzvcEKEOw784ZK3CaZsNidDmrdZnKBz6n5R3HeEi8JhikxAjhOUynvvTg78VEJUzguwTEBk7AtgHNhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034379; c=relaxed/simple;
	bh=bq9jm+PbY0D3Tr4OQxr6xeT7pc2f7giEniqj6KSbEHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IvfsvWqT6Ylvnk1hJYkdbyd8ODOxOqLrUtLDEX6Oo7PhyMMDsHRDHsBvUf+Nvsi34rtgUAj4GSzbUETsdExFSOEAvrDZiX90Liz2yiE7EeFlE2qgUbdBwsTKhaT7mgzcfV/ep7F4uv5xcrFWj4M1GIJVvqYG+oM3rSFSE5JiuFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AGq1EnG7; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AGq1EnG7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=amtwIbN3zIc+peWXbJdA5a3NzTr2VPM59mGxwFST9Kw=;
	b=AGq1EnG7olVJqb1HTgiB+ofSiRe89BcR+T55wNxB8xY+oYOeL2yuzRet9Ouy+OkHWpP1tx
	dPiAHSWHKMMtMaK5LopRfZ5MiMtpUKbLAwnIHlITOUViDJWC82PJFvE6L3jarfGXLpDmXz
	no6pOWfoCeZAo0qNm6WhU6Ui525kbTM=
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
Subject: [PATCH v4 00/10] smb: improve search speed of SMB2 maperror
Date: Sat,  6 Dec 2025 23:18:16 +0800
Message-ID: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Before applying this patchset, when searching for the last element of
smb2_error_map_table array and calling smb2_print_status(),
3486 comparisons are needed.

After applying this patchset, only 10 comparisons are required.

v1: https://lore.kernel.org/linux-cifs/20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev/
The three patches from v1 have already been applied to the for-next branch of cifs-2.6.git.
Please replace the following patches:

  - [v1 01/10] smb/client: reduce loop count in map_smb2_to_linux_error() by half: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=26866d690bd180e1860548c43e70fdefe50638ff
    - Replace it with this version(v4) patch #0001: update commit message: array has 1743 elements

  - [v1 02/10] smb/client: remove unused elements from smb2_error_map_table array: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=905d8999d67dcbe4ce12ef87996e4440e068196d
    - It is the same as patch #0002 in this version(v4).

  - [v1 03/10] smb: add two elements to smb2_error_map_table array: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=ba521f56912f6ff5121e54c17c855298f947c9ea
    - Replace it with this version(v4) patch #0003 #0004.

v3: https://lore.kernel.org/linux-cifs/20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev/
v3->v4:
  - Patch #0008: the KUnit test searches all elements of the smb2_error_map_table array
  - Create patch #0009

ChenXiaoSong (10):
  smb/client: reduce loop count in map_smb2_to_linux_error() by half
  smb/client: remove unused elements from smb2_error_map_table array
  smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
  smb/client: add two elements to smb2_error_map_table array
  smb/client: sort smb2_error_map_table array
  smb/client: use bsearch() to find target status code
  smb/client: introduce smb2_get_err_map()
  smb/client: introduce smb2maperror KUnit tests
  smb/client: update some SMB2 status strings
  smb/server: rename include guard in smb_common.h

 fs/smb/Kconfig                    |  17 +++++
 fs/smb/client/cifsfs.c            |   2 +
 fs/smb/client/smb2glob.h          |   6 ++
 fs/smb/client/smb2maperror.c      | 101 +++++++++++++++++-------------
 fs/smb/client/smb2maperror_test.c |  71 +++++++++++++++++++++
 fs/smb/client/smb2proto.h         |   4 +-
 fs/smb/common/smb2status.h        |   5 +-
 fs/smb/server/smb2pdu.c           |   2 +-
 fs/smb/server/smb_common.h        |   6 +-
 9 files changed, 165 insertions(+), 49 deletions(-)
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

