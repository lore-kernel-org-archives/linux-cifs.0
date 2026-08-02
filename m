Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430603803D6
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785690551; cv=none; b=upNvS/TjEzZXwihtRKrSpR1k+L7qo1EbpiCX3oGC2pHE9xzHTfoFOsFHudH7e+mpqHpv+2Tn/GJOYFQDo+ebihoZhDIAK1eCAvCVDsXTI46rEkFYBB0HhaR37oJ8h3+WG+h5rd+1Ner4D8On4KAPzRlyqBsJtBDV/WCZeIc5lTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785690551; c=relaxed/simple;
	bh=O+U3DWJXNXduFdTZ3Hq3p90g2qv1qW/RjloQIHduijY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R2SvAil4BJCdDVkvubAagYOTj/2R1VvUeRkN8n1HHXQRltiOwCk61hOVVMDcirD5l1e0Ed5Y6b/luU3clIAFxGNUrb6clCCmGcO/i6Ofo3nWssob97GU3OAkCZsiPojSxd+GDi4rHaGsNtYxdchqDoh2i2XI6ZA117D0Q4mfU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=BmDPoOAs; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="BmDPoOAs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785690544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eVUjdCgh6bVyqGve+/V7Ru/b2Q3BAb4JV6TTN63A8Fo=;
	b=BmDPoOAsgtUts8Qw+GQzhCkAzhFNg7fSktyDuOFmONNIDH1L6boPH+CT/BNRwzMs5DOeSf
	Px6BF9hIX6b2yHZBjpGvtDECvkqvNNAVSwSFDuq6JiPljqjg49gvPX75KfNFAl0JLPFt4E
	xHx448xpkZ//+NO6OMZaUJkxcMx2f7nqQ9aE7nHEbNJTnjcVbbrYmxVZl19zeJ1uCbCBbT
	DxKAdjIkAJNoCZsfckmZyDyiUMv/CGbIMFYhkYaltZPbNLWE0y7rotgovJRJTR1vOOon4H
	A3sIl09JPIFS1sygfhMrZabar0TUHvWBGzDU8xGIpn25fIKPXPqlUZ3IFF0UTw==
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
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/2] smb/server: fix posix state check for directory rename
Date: Sun,  2 Aug 2026 17:07:55 +0000
Message-ID: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

ChenXiaoSong (2):
  smb/server: pass source ksmbd_file to rename helpers
  smb/server: fix posix state check for directory rename

 fs/smb/server/smb2pdu.c   | 2 +-
 fs/smb/server/vfs.c       | 6 +++---
 fs/smb/server/vfs.h       | 4 ++--
 fs/smb/server/vfs_cache.c | 5 ++++-
 fs/smb/server/vfs_cache.h | 2 +-
 5 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.54.0

