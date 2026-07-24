Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6597A373BF4
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 03:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784862765; cv=none; b=t3/r2jf1xzyKu/y+8CWTHI0Wz7YrvIOwm/T4jN2UXWz43vMOCT02FsGg8grssxJMg35U7dmHRnYDpQ4rSPNO9rWnkrvHeYm3U+RXmQY1zbaHHPqWIyOmpvRmeOI+WIocKYD/msZSZslIki/2kOHUvZHx/XkmrLkElp97AE3X9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784862765; c=relaxed/simple;
	bh=kT8fXw48GA90xYFzXC6PVtJSsjx1Ljxdu/pcwjMrORE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNic4UoJuxiwOOxdHpX/f5P8CnnmA6buRvxeH3i2Xsi2QlfRE5Nlhg/Zh6Ynrh0bp+YzxKv4yVtPHCsrd+qzG8KDPQVAJGCiBjacsoXsu43jhKcgXiTsXZsRpJxBLzhTsg/T6onvdPrQoVUJAkY4cDe480EC13kxOhPrpeOAiNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=iF27km2e; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="iF27km2e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784862750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zV7EcMguRzNIbr6K1is2ZOzospwqJItfpqXu67VyszI=;
	b=iF27km2eavhAGPLodyOD6pFEE0hDC1dvXzIRvAsqSm7bTJoekfZ1pwVxH85uqWdwBXcMwQ
	YFh7CdbhV4mHGopVR5JMnXFLqDU4UjtA3tmh2JW2PLAbid1J3FT+Yhp2GrZ7L/+IEdmO35
	fV1iNcMneL05T3xLPNOnYckMkp1Ww87lrAup6B4PaSYkdpHlBhYAycvBQFSqyDYCciN9n2
	Uwv9TXW7QswdYsAMzKufx3oRjE51fWVxe1qvel3CvuA/y929u5ibk3V37fdokhWiDnZ/Mx
	KLuagWtwsTKKHevsAEAsqZ6cXULLz3PArIhqm6hjtFpbGqFoOYatRkfHpLdCvw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	fstests@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 xfstests 0/2] generic: new test to check nlink returned by fstat()
Date: Fri, 24 Jul 2026 03:12:08 +0000
Message-ID: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v2->v3: use `xfs_io -c 'stat -r'` to call fstat().

v2: https://lore.kernel.org/linux-cifs/20260720163502.732454-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (2):
  generic/002: simplify the hardlink count test
  generic: new test to check nlink returned by fstat()

 tests/generic/002     | 16 +++++-------
 tests/generic/002.out |  2 +-
 tests/generic/798     | 60 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out |  2 ++
 4 files changed, 69 insertions(+), 11 deletions(-)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

-- 
2.43.0

