Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E9156236;
	Mon,  8 Dec 2025 06:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174953; cv=none; b=iH/2rAH8dH+YBrTT9TW1sfMdJT1Dvm2zUJ/5IgJqgrsaDgEzlZUE8gOCilQfpwfQcm8R/R98izqJ6wJWDwMWdw9/J+oWGkPxcX33qD9t0VuCwNc+380qqqmArbqxpTJY/+xQzAmbBKEeuorGjOV7k8/hs4pTI8TdzRi+nlVF/jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174953; c=relaxed/simple;
	bh=nCbGKt8+wVQmRaSxGF6EpUSwvPlfsETK4B6Y1syhHVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHgc03hhIEjJpiM7cAu5hFWpFMD7KLnxe0jSEty/Y7q1XcSLvGqXcUbLHPxGn6gbrkujDcNUjJtsFrF93TLmvz/lIGgLZvDMv+0ckB+fj3OL1PLEpZ0UpQTQvT36N6hpFkUPqX7PTr15uhB8qG9wXH42MA3yc0XEnPp9GDjCBqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lwSJkKoe; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lwSJkKoe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o1+e3IvA6jz5eCYy9G2JhAtkcZXSOwv1bB1kWoWPC2g=;
	b=lwSJkKoekwDWmpZFe08gjVjbhF94XjqyPGKm8yPq7URQ1JR6tKNp2VAm/m4MG4hP8bjzBY
	34QyjpsBaAEPBX39VaX3HZXCH23xXXjwf7nkazJb0jIHi+ezTGeMA1NdCIL7ZPSJmZvLQQ
	LeeVsINXwecZQvcs442shJyMnZF5rhk=
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
Subject: [PATCH 00/30] smb: improve search speed of SMB1 maperror
Date: Mon,  8 Dec 2025 14:20:30 +0800
Message-ID: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Before applying this patchset, the patchset ("smb: improve search speed of SMB2 maperror") must
be applied first, which introduces `CONFIG_SMB_KUNIT_TESTS` and avoids some conflicts in `fs/smb/client/cifsfs.c`:
https://chenxiaosong.com/lkml-improve-search-speed-of-smb2-maperror.html (Redirect to the LKML link)

When searching for the last element, the comparison counts are shown in the table below:

+--------------------+--------+--------+
|                    |Before  |After   |
|                    |Patchset|Patchset|
+--------------------+--------+--------+
| ntstatus_to_dos_map|   525  |    9   |
+--------------------+--------+--------+
|             nt_errs|   516  |    9   |
+--------------------+--------+--------+
|mapping_table_ERRDOS|    39  |    5   |
+--------------------+--------+--------+
|mapping_table_ERRSRV|    37  |    5   |
+--------------------+--------+--------+

ChenXiaoSong (30):
  smb/client: fix NT_STATUS_NO_DATA_DETECTED value
  smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
  smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
  smb/server: remove unused nterr.h
  smb/client: add 4 NT error code definitions
  smb/client: add parentheses to NT error code definitions containing
    bitwise OR operator
  smb/client: introduce DEFINE_CMP_FUNC()
  smb/client: sort ntstatus_to_dos_map array
  smb/client: create netmisc_test.c and introduce
    DEFINE_CHECK_SORT_FUNC()
  smb/client: introduce KUnit test to check sort result of
    ntstatus_to_dos_map array
  smb/client: introduce DEFINE_SEARCH_FUNC()
  smb/client: use bsearch() to find target in ntstatus_to_dos_map array
  smb/client: remove useless elements from ntstatus_to_dos_map array
  smb/client: introduce DEFINE_CHECK_SEARCH_FUNC()
  smb/client: introduce KUnit test to check search result of
    ntstatus_to_dos_map array
  smb/client: sort nt_errs array
  smb/client: introduce KUnit test to check sort result of nt_errs array
  smb/client: use bsearch() to find target in nt_errs array
  smb/client: remove useless elements from nt_errs array
  smb/client: introduce KUnit test to check search result of nt_errs
    array
  smb/client: sort mapping_table_ERRDOS array
  smb/client: introduce KUnit test to check sort result of
    mapping_table_ERRDOS array
  smb/client: use bsearch() to find target in mapping_table_ERRDOS array
  smb/client: remove useless elements from mapping_table_ERRDOS array
  smb/client: introduce KUnit test to check search result of
    mapping_table_ERRDOS array
  smb/client: sort mapping_table_ERRSRV array
  smb/client: introduce KUnit test to check sort result of
    mapping_table_ERRSRV array
  smb/client: use bsearch() to find target in mapping_table_ERRSRV array
  smb/client: remove useless elements from mapping_table_ERRSRV array
  smb/client: introduce KUnit test to check search result of
    mapping_table_ERRSRV array

 fs/smb/client/cifsfs.c       |    2 +
 fs/smb/client/cifsproto.h    |    1 +
 fs/smb/client/netmisc.c      |  155 ++++--
 fs/smb/client/netmisc_test.c |  114 ++++
 fs/smb/client/nterr.c        |   12 +-
 fs/smb/client/nterr.h        | 1017 +++++++++++++++++-----------------
 fs/smb/server/nterr.h        |  543 ------------------
 fs/smb/server/smb2misc.c     |    1 -
 fs/smb/server/smb_common.h   |    1 -
 9 files changed, 739 insertions(+), 1107 deletions(-)
 create mode 100644 fs/smb/client/netmisc_test.c
 delete mode 100644 fs/smb/server/nterr.h

-- 
2.43.0

