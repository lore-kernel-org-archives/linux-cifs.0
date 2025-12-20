Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1AA1D5CF2
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766237217; cv=none; b=KAgVHj7qG16KzxZWVV4S2SF61TNZq0CF/ccHNu3IBzHDqnQIEoBjw2ZzzSpBkc92g4zwGDVMBfq5b+11GXN4UynLUX8mhVgLLTd687pGayjekxrIMLALe8v64g6kqYDx4Mcp0zvWVUhtfRsON+3VFPewBEDdjUr3U3KoBFf0Tg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766237217; c=relaxed/simple;
	bh=SLjmXuYT4Hlc41aCP8cDi7DfO5H8eyVPhSgKMe/0s3c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YjrUZGN8/oQxIMZ2Qh78wxv//YtsZtMNkR4s8jLg+WfKCUhbHB/9PEIihhCthE66oaj03dL6OToAhBJtAroc84I1WS9zgsq3WH4+QsHO8P7k8RkNm8NEN9ZwIDPZQZKzvHoVS6ckDA/dY7zIGFVU5YWe/b3IemMHf/dlmhF4OL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ha1tjXS2; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ha1tjXS2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766237213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ufVJ1qB21hwIN4LaKDQzv86MCBsxqwnMKGvluYb9m3o=;
	b=Ha1tjXS2Jtw3vJjM6Qu77N0sf/sucDevXFGkXCJmadZiM4tBPdn6byxu7WJPGAOccjwbLs
	jDtuQbZCje1rvoyUIV/jg2tVyz2ZPFcy+kVoERaLqbFwOdR5AQRbAa3b5KdthyPw+xIW5A
	iSjeXxK3CzIStg2ZhZwypiU0wFPkVHI=
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
Subject: [PATCH v4 0/2] smb/server: fix minimum PDU size
Date: Sat, 20 Dec 2025 21:25:49 +0800
Message-ID: <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v3: https://lore.kernel.org/linux-cifs/20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev/
v3->v4:
  - Patch #01: remove `struct smb_pdu`

ChenXiaoSong (2):
  smb/server: fix minimum SMB1 PDU size
  smb/server: fix minimum SMB2 PDU size

 fs/smb/server/connection.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.43.0

