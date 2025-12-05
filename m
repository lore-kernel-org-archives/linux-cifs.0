Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93CD335572
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764941221; cv=none; b=egaSSz73j3KmZQqDt3sSBGLmqKwL/kz2+03n7lzO8upRsMOxGY97aNpSQ3uCjhwIHYg4U/dFAp+FpUQaBir7VNckZZFZqh9TOnfG0aLUEHUQCgO0PU5K/ahsD2P0R34kyfBKJ/oOCVKcshZkf+iWrrz9XP+5eE/JUbobAEWcpcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764941221; c=relaxed/simple;
	bh=c47xT7wbjW3QvK5SkcxYdMTitg/gBjxXczfzlkbp5eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Np2ORPf8cdl3zrwdDj90+9jfxJA+Cam02xXpD9CvzORVU848Q9Q7xJsp0/h0IL6X/24lCeEZhxLFdpy3BdNv3SJFO+F7OTmgnX4/qFcLNIg+T4/dNQfTI2R5/7+uCPb1VUldaLrGpe0KTGAKrAHc1QuI6UXYLafuL1JndhQqHZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dOBEbjHD; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dOBEbjHD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764941204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4OO8ZLxc62rFL3goUJ523STAz0a99bywbUG+QQbGHo4=;
	b=dOBEbjHDPk2940jWzyfrsFpdTRhqSl1s2P711yrMOvdAfLuKGuwLaK80Ck38B8YjB2wk9t
	WElv0ubCCulgpoinI1UU0i4LI8xb426rI9uiBu8fn5cm5xUJl35AYzJajBb4CDo3PcxXq2
	PLfcYXbKz0ZZaw26Qo+Ke1ge6eE/SqU=
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
Subject: [PATCH v3 0/9] smb: improve search speed of SMB2 maperror
Date: Fri,  5 Dec 2025 21:25:26 +0800
Message-ID: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
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
    - Replace it with this version(v3) patch #0001: update commit message: array has 1743 elements

  - [v1 02/10] smb/client: remove unused elements from smb2_error_map_table array: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=905d8999d67dcbe4ce12ef87996e4440e068196d
    - It is the same as patch #0002 in this version(v3).

  - [v1 03/10] smb: add two elements to smb2_error_map_table array: https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commitdiff;h=ba521f56912f6ff5121e54c17c855298f947c9ea
    - Replace it with this version(v3) patch #0003 #0004.

v2: https://lore.kernel.org/all/20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev/
v2->v3:
  - Patch #0007: move struct status_to_posix_error to smb2glob.h,
                 change smb2_get_err_map to be a global function,
                 delete unused forward declaration `struct statfs` in smb2proto.h.
  - Patch #0008: create new smb2maperror_test.c, refer to the implementation in fs/ext4/mballoc-test.c.

ChenXiaoSong (9):
  smb/client: reduce loop count in map_smb2_to_linux_error() by half
  smb/client: remove unused elements from smb2_error_map_table array
  smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
  smb/client: add two elements to smb2_error_map_table array
  smb/client: sort smb2_error_map_table array
  smb/client: use bsearch() to find target status code
  smb/client: introduce smb2_get_err_map()
  smb/client: introduce smb2maperror KUnit tests
  smb/server: rename include guard in smb_common.h

 fs/smb/Kconfig                    | 17 ++++++
 fs/smb/client/cifsfs.c            |  2 +
 fs/smb/client/smb2glob.h          |  6 ++
 fs/smb/client/smb2maperror.c      | 91 ++++++++++++++++++-------------
 fs/smb/client/smb2maperror_test.c | 86 +++++++++++++++++++++++++++++
 fs/smb/client/smb2proto.h         |  4 +-
 fs/smb/common/smb2status.h        |  5 +-
 fs/smb/server/smb2pdu.c           |  2 +-
 fs/smb/server/smb_common.h        |  6 +-
 9 files changed, 174 insertions(+), 45 deletions(-)
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

