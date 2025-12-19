Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A17231827
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766163848; cv=none; b=Txd3gv3SjLFgMn8RU0OBdHEZxHdxU2+XTXO6/s6NIg1t59G7Ct+oNgCOnxjC4u9l2EFH97Ii7/dAll2LuPOJD7Pnk1BRldwhe/x7cevA6aJjAzpcEG9i7/1W2WNKtLifg6aj0lI9+ikk58oi0ZcVIe8Sp6i2k1HPPZdYY0/TNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766163848; c=relaxed/simple;
	bh=Ky8k49R2P5g1lweoqS8tXe87h6776qwacEQsWDExV2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I/MS00szBCz+eGX5bVQQBl8qeYo9JefBcS4QvqG6LJQH04IK/8O/JD6cbPg+0HI7zTPTyMn3a0QyQnBPme3f9ac3/u51wde1c5XUdMQlIEDi7KMkVQZCANl2udIfCoEFGnpkgZ2nrZea4+qwFQ0xEqjMWp2MgN0ZlevH3QHA4XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gKC/9+S5; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gKC/9+S5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766163838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9V9s48PrAKC/Z+L5jhlu8YgtQP9CQOh8zNErZsVlkD8=;
	b=gKC/9+S5XwVG0ycG5aD+iygsqEK3h/oL6Mjy2hY2NFeLxBxEMCsmUwAaw/PGYJMglXAlkK
	4GJU+x+1V2aelmWs349U94h1Xkem+C/Ngm1xP/9Iexv+KCWvs+QRKpdb2fsEoVu3nSRO3c
	L+iF8A8DLdl2QtSCGwI7f2LQ893lq6I=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH RFC v2 0/3] smb: fix minimum PDU size
Date: Sat, 20 Dec 2025 01:00:54 +0800
Message-ID: <20251219170057.337496-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

If my understanding is incorrect, please let me know.

v1: https://lore.kernel.org/all/20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev/
v1->v2:
  - Create patch #0001 #0003
  - Patch #0002: update value of SMB2_MIN_SUPPORTED_PDU_SIZE

ChenXiaoSong (3):
  smb/server: fix minimum SMB1 PDU size
  smb/server: fix minimum SMB2 PDU size
  smb: use sizeof() to get __SMB2_HEADER_STRUCTURE_SIZE

 fs/smb/common/smb1pdu.h    | 5 +++++
 fs/smb/common/smb2pdu.h    | 8 ++++----
 fs/smb/server/connection.c | 8 ++++----
 3 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.43.0

