Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0009881732
	for <linux-cifs@vger.kernel.org>; Wed, 31 Dec 2025 13:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767186635; cv=none; b=J+7cSsn12/vGE7DH8VvCUPqotncR7EQ8AXEQReukDjUBcMtbTywKv7RGAWrcq/Q4a13lkiqaPgoDtM7BnNib4BZaY2XLft3zePrCzwlVdiePzC5WPdIro3C1Zw9uIwnnn/jycFTMdQHeAqnNzCwjOd7++WyUjiweEY5jiF2itr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767186635; c=relaxed/simple;
	bh=lnu1l5c65iTLAQVILtQ0S5elCIdKvvoT6TAUrWEGVtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TJWVB3rISfC23ByJ5Y1sOBjtBQd/ZiLE3uj3jM+mKc8Rn/i+C/qxDEx+tpBOi1DoDapG2yQylQaxevJxVFqx7+1Y3HpWYlJUKxMc04ZsRAs86qCZwBJcurgYviQMWoceFgmvt5+RwgfB6+EwhZIwJrRDiw+4cg/3aGIYEupedNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZtRhPiRv; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZtRhPiRv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767186628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=InNrp3B5vVkt5rqucW7pykP9N4MUsRFIVlK/n55cTZQ=;
	b=ZtRhPiRvzcHNzMPlnXJEzYKpYE/gQZ14HFm6139Ytx1vFkWYoJXFGxcNyvhKMYwPIPSDzP
	0CXItRuYuHtOBLRzEku07OTzgp9TIohTPiGbMSQ1KdF4wNYvA9vdBBmouJXNicjSsNMveB
	KFw9EuhaJ8BBiBPSavBLceRBMzvELaY=
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
Subject: [PATCH v7 0/5] smb: improve search speed of SMB2 maperror
Date: Wed, 31 Dec 2025 21:09:13 +0800
Message-ID: <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
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

v6: https://lore.kernel.org/linux-cifs/20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev/
v6->v7:
  - Patch #02: store the cpu-endian values in the table
               update coding style of `gen_smb2_mapping` script: use tabs instead of spaces
               update comment: sorted by NT status code (cpu-endian, ascending)
  - Patch #04: update cmp_smb2_status(): the first argument is a cpu-endian value

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
 fs/smb/client/smb2maperror.c      | 2467 +-------------------
 fs/smb/client/smb2maperror_test.c |   48 +
 fs/smb/client/smb2proto.h         |    1 +
 fs/smb/common/smb2status.h        | 3488 ++++++++++++++---------------
 8 files changed, 1975 insertions(+), 4151 deletions(-)
 create mode 100644 fs/smb/client/gen_smb2_mapping
 create mode 100644 fs/smb/client/smb2maperror_test.c

-- 
2.43.0

