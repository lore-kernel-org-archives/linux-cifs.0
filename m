Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6E28469F
	for <linux-cifs@vger.kernel.org>; Sun, 18 Jan 2026 09:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768727678; cv=none; b=DtGkdcsJq8nrEcgDtK+wlOqOCnwmWzpb/jh5o+9BO4CSRlfzqJpqtS271cnz/4zedW1PVzRrr8Z9XrIqtJac++kTvd9vw02FYrvat5RuN2Lh10sszHOftRLLsBP4VOCNthc25fnQ5GQu41whRhFOrjXlOGHavtGkhczcZvug7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768727678; c=relaxed/simple;
	bh=SYn8oj3meUKNAqShWR5qNj/zf+4RdidVbhtm8JivUI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1DVGt1Ze5p3N6ZvJIIvpKw7yT3bCiswQWVQAp/gjpQcIjq9OHXL1RWSWp6V3TtT0zqsPF2sJQgKemuDSfyKKqs7EYKSivIu0XrwdnqSNDiARfJpIKNaAj3LdLY8QmNoNTLmoGd+d5A6Tj3hpneKEPhyMEE+BK5T+nSJkKaSX44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OC2weLyX; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OC2weLyX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768727673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7I6ugrdWbqSRKtkaMzOAMl0kp6oJKsZKf5ArDSpEHEw=;
	b=OC2weLyXdj3UveNp5s9qJV16zdtDTfQk0Gg7eoSeM//r8OSPx33wXEqTMhAxq1KEvLyXpv
	WI2cwSHnOrSXkXVSY67NDudG9qRMaAHf6LZb1Cr/wewxHUBuBSLAD81R6R+8MsKawCsigS
	Hsu8IdhRieBQDQH72Hs/Q+22nY1Gn2g=
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
Subject: [PATCH v9 0/1] smb: improve search speed of SMB2 maperror
Date: Sun, 18 Jan 2026 17:13:12 +0800
Message-ID: <20260118091313.1988168-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v8: https://lore.kernel.org/linux-cifs/20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev/
v8->v9:
  - Fix build error when `CONFIG_CIFS=y`

The following patches from v8 have already been merged into cifs-2.6.git for-next:
  - 9303cdba632a smb/client: use bsearch() to find target in smb2_error_map_table
  - 430ae68414c2 smb/client: check whether smb2_error_map_table is sorted in ascending order
  - 9d40867a8685 cifs: Autogenerate SMB2 error mapping table
  - ce609a4b3a27 cifs: Label SMB2 statuses with errors

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

ChenXiaoSong (1):
  smb/client: introduce KUnit test to check search result of
    smb2_error_map_table

 fs/smb/Kconfig                    | 17 ++++++++++++
 fs/smb/client/smb2maperror.c      |  8 ++++++
 fs/smb/client/smb2maperror_test.c | 45 +++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

