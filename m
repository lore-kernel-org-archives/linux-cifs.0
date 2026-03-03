Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDB047ECD9
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772550854; cv=none; b=BpDmkOpb3+31E//zqbh3no3fxLzPQQu8cQ6blVDwjTCWkAW5rICBdw+U4TwD/i3aBpdkdGSSogF0hNkIsT79IkkRSQKdRJtHPYJZHY5bU3rcaO8+VK0uoM8Ct4xB4epAtfpIikb8yF0apim56/K4Ot0vqrQeW8/5w30Ojsz/lwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772550854; c=relaxed/simple;
	bh=zAqoleofBNijRAUlMV9aaQjxqifL6wCoKXp08cMD8r0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ls8SgKjZ+XRe3Z6QPDuRbBGz6Kw6VO9e4Zka3H7cBjHwDy4dpVEg2e8JMCTS0yNv6i/OJsVT7UYcxKb0XzEdeQdp++mmio+4D2KH32F3pivuMlaAcNGirmj8jN2TKAhsK4bXVYLdL/M2DbMhOirC2BqeBgzc730AElyu5slFp5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gIt2YZoN; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gIt2YZoN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772550849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vmTkIQj5mC1sH6xq8VsuLHQtX2ahcBOuSTziCF0bmWE=;
	b=gIt2YZoNvhAeS2oh7m206/3/++gTsfn6daEDbl21Xm5P0CqmRbCXahf+KD/2lt9HUSEiXt
	xFGH5aTw8OSoEifiBmoWfgB3Q6RyDXsLXs0JbvvImxpiDcX4Vo+dp0rYTxu6XXo/ts0ua2
	xY/OL45QNVN1PSzZos7y8iYHMzhrudA=
From: zhang.guodong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v5 0/7] smb: fix some bugs, move duplicate definitions into common header file, part 2
Date: Tue,  3 Mar 2026 15:13:10 +0000
Message-ID: <20260303151317.136332-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

v4->v5:
  - Add patch #01 #02 #03
  - Patch #06: keep vol_serial_number as u32 in smb_mnt_fs_info and cifs_tcon
  - Patch #07:
    - Add new flexible array member `sids_and_name[]` to file_posix_info
    - smb311_posix_qinfo -> file_posix_info

v4: https://lore.kernel.org/linux-cifs/20260225041100.707468-1-zhang.guodong@linux.dev/

v1: https://lore.kernel.org/all/20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev/
v2: https://lore.kernel.org/linux-cifs/20251211143228.172470-1-chenxiaosong.chenxiaosong@linux.dev/

The following patches from v1 and v2 have already been merged into mainline:
  - 94d5b8dbc5d9 smb: move some SMB1 definitions into common/smb1pdu.h
  - 2b6abb893e71 smb: move File Attributes definitions into common/fscc.h
  - c97503321ed3 smb: update struct duplicate_extents_to_file_ex
  - 2e0d224d8988 smb/server: add comment to FileSystemName of FileFsAttributeInformation
  - ab0347e67dac smb/client: remove DeviceType Flags and Device Characteristics definitions
  - 08c2a7d2bae9 smb: move file_notify_information to common/fscc.h
  - 6539e18517b6 smb: move SMB2 Notify Action Flags into common/smb2pdu.h
  - 9ec7629b430a smb: move notify completion filter flags into common/smb2pdu.h
  - bcdd6cfaf2ec smb: add documentation references for smb2 change notify definitions

The following patches from v4 have already been merged into cifs-2.6.git for-next:
  - smb: update some doc references

This is a continuous effort to move duplicated definitions in both client
and server into common header files, which makes the code easier to maintain.

The previous work is here:
  - part 1: https://lore.kernel.org/linux-cifs/20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev/

ZhangGuoDong (7):
  smb/client: fix buffer size for smb311_posix_qinfo in
    smb2_compound_op()
  smb/client: fix buffer size for smb311_posix_qinfo in
    SMB311_posix_query_info()
  smb/client: remove unused SMB311_posix_query_info()
  smb: move some definitions from common/smb2pdu.h into common/fscc.h
  smb: move file_basic_info into common/fscc.h
  smb: move filesystem_vol_info into common/fscc.h
  smb: introduce struct file_posix_info

 fs/smb/client/cifsglob.h   |   2 +-
 fs/smb/client/inode.c      |   2 +-
 fs/smb/client/readdir.c    |  28 +--
 fs/smb/client/reparse.h    |   2 +-
 fs/smb/client/smb1pdu.h    |   9 -
 fs/smb/client/smb2inode.c  |   4 +-
 fs/smb/client/smb2pdu.c    |  26 +--
 fs/smb/client/smb2pdu.h    |  21 +--
 fs/smb/client/smb2proto.h  |   3 -
 fs/smb/common/fscc.h       | 371 ++++++++++++++++++++++++++++++++++++-
 fs/smb/common/smb2pdu.h    | 343 ----------------------------------
 fs/smb/server/smb2pdu.c    |  65 +++----
 fs/smb/server/smb2pdu.h    |  30 +--
 fs/smb/server/smb_common.h |   8 -
 14 files changed, 428 insertions(+), 486 deletions(-)

-- 
2.52.0

