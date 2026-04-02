Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAC63DD510
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139584; cv=none; b=GB5mmrM2ZRfej7DxjKW3tYuUIT8IWjbKanhk1qbWeSxE/lWRtK3JMhi2qeTshJlwT6ffQRqe7XvOofBb1TFjWF/XVCC91YJlmUEvSfBN2Qp+s/S2zGt61gjQhpLyTln2TKiWTbpwP0EyhH/itPYMLL7vSfDnyYbsnfV84HJvsDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139584; c=relaxed/simple;
	bh=BnHpjpqiEySw6avpX4qyduo3FtzWBVBfD0VjWGkZiAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E41U9/9oFgNUMMurhy18g/NG7d28ovUWzXIggQdLDXWNHfWPAml5+vt7XgdAje396miPnZyeRVt+rdZU4SWk1/SRFhMdUrWbKyKlRYcPFVvx8PnjFxskqUnV5J1gwmCz0UEOdliXNC7CZROy4qawSfPHla5cm316pq3mzoP1R9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ASFMiDvy; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ASFMiDvy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GA26MpNK1PLvK311ka2IkW6uD6ecxoXEcBSK+/lNejQ=;
	b=ASFMiDvy94lJa0fTCTQhczpTfj5ed3KGlcY01+E/pR78OsEFTNlSrEbC/+1W9kiLHtmJVf
	XOlfSUzctht4VusZq0/HWA+zz9LfvosCubz5pbG/YBjwCr0wm/nThpALzHIb7FpZIjmMw7
	cyQgsCHJH32od6dGlz/gsbJ6z2Ggk4Q=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH v3 00/13] smb: improve search speed of SMB1 maperror
Date: Thu,  2 Apr 2026 14:18:26 +0000
Message-ID: <20260402141839.461257-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

v2->v3:
  - All test cases passed for v3, please see ChenXiaoSong's blog: https://chenxiaosong.com/en/smb1maperror-test.html
  - Patch #01: Correct the SMB1 mapping  NT_STATUS_OBJECT_NAME_INVALID 
  - Patch #02 #10: gen_smb1_mapping: Enhance regex robustness to cover mixed-case prefixes (e.g., ErrNotALink), and match exact filenames to prevent mapping outputs to incorrect files.
  - Patch #06: Add `__init` to `DEFINE_CHECK_SORT_FUNC`
  - Patch #07: Use `KUNIT_ASSERT_NOT_NULL`
  - Add patch #08: Move ERRnetlogonNotStarted to DOS error class

v2: https://lore.kernel.org/linux-cifs/20260401072912.355072-1-huiwen.he@linux.dev/

When searching for the last element, the comparison counts are shown in the table below:

+--------------------+--------+--------+
|                    |Before  |After   |
|                    |Patchset|Patchset|
+--------------------+--------+--------+
| ntstatus_to_dos_map|   533  |    9   |
+--------------------+--------+--------+
|mapping_table_ERRDOS|    34  |    5   |
+--------------------+--------+--------+
|mapping_table_ERRSRV|    37  |    5   |
+--------------------+--------+--------+

The following patches from v1 have already been merged into the mainline:
  - a71a4aab4834 smb/client: add parentheses to NT error code definitions containing bitwise OR operator
  - a9adafd40165 smb/client: add 4 NT error code definitions
  - 98def4eb0244 smb/server: remove unused nterr.h
  - 9f99caa8950a smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
  - b2b50fca34da smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
  - a1237c203f17 smb/client: fix NT_STATUS_NO_DATA_DETECTED value

Huiwen He (9):
  smb/client: annotate nterr.h with DOS error codes
  smb/client: autogenerate SMB1 NT status to DOS error mapping
  smb/client: replace nt_errs with ntstatus_to_dos_map
  smb/client: refactor ntstatus_to_dos() to return mapping entry
  smb/client: use binary search for NT status to DOS mapping
  smb/client: move ERRnetlogonNotStarted to DOS error class
  smb/client: annotate smberr.h with POSIX error codes
  smb/client: autogenerate SMB1 DOS/SRV to POSIX error mapping
  smb/client: use binary search for SMB1 DOS/SRV error mapping

Youling Tang (4):
  smb/client: check if ntstatus_to_dos_map is sorted
  smb/client: introduce KUnit test to check ntstatus_to_dos_map search
  smb/client: check if SMB1 DOS/SRV error mapping arrays are sorted
  smb/client: introduce KUnit tests to check DOS/SRV err mapping search

 fs/smb/client/.gitignore          |    3 +
 fs/smb/client/Kconfig             |   11 +
 fs/smb/client/Makefile            |   25 +-
 fs/smb/client/cifsfs.c            |    6 +
 fs/smb/client/gen_smb1_mapping    |  112 +++
 fs/smb/client/nterr.c             |  704 -------------------
 fs/smb/client/nterr.h             | 1082 +++++++++++++++--------------
 fs/smb/client/smb1maperror.c      |  873 +++++------------------
 fs/smb/client/smb1maperror_test.c |   83 +++
 fs/smb/client/smb1proto.h         |    9 +
 fs/smb/client/smberr.h            |  415 +++++++----
 11 files changed, 1235 insertions(+), 2088 deletions(-)
 create mode 100644 fs/smb/client/gen_smb1_mapping
 delete mode 100644 fs/smb/client/nterr.c
 create mode 100644 fs/smb/client/smb1maperror_test.c

-- 
2.53.0

