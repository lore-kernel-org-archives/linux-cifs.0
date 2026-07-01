Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6317E40960C
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902377; cv=none; b=cyO8sPeWOMVLYDze/96wKHss2MMuF9OinSZNjPZ49bY1y02X3ZuebUV/nGWDgF/T9gnq6Xom4meGv6GGpSXuZgb5z88Q1I5cBDkmjGvpOoAhse1Qm5RTGqR1FqFcdmE/l5IvZrHZnB/Nzzuu4jtqKtxJ6DVHINklALzh0zJbMA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902377; c=relaxed/simple;
	bh=AbUDocnzw76lfzBftTzab3sPtb10DZFATWQ9lHOsVVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KlsgpXJ7EC6wtljXTmRu6Vz+Z5s7DScXjrE8kl3biq6IuvVeYGo+8VMvAmzoRpzBJd5e1f8lowXJC//L9+eQj5Yfih+A6ByLix2QK0V7mHk9q3Mu9ZSYUJsKFbtUcCIWuHFLKZ2sCvrT5jqjUvhZx3PRMdC44U6jtqiVsK+qL4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=N2oBFovp; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="N2oBFovp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782902369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RNH/z8ZH7GJR8zKibEpQtIX0+S0Pu3LqYjGtTh9KTS0=;
	b=N2oBFovppk1Kv0ljxykwhOzXoQ8j06rxjWzdxlPDM8BNwzqgYATenvm9uAg09m+BqiZaLF
	OfL5UPQzKUIn/m8SL1ALDlqM0wvPLPXx/PdmZE+JtUu80VM/D8gtt4QU4H9iXTQBFlWP+O
	+CqzipVMCc/fm8hsD5csyOB9m2xcFVoETIWnbqFNVAWWETZNg+yQYvJ6OZU+Y6ib21VtzU
	cGF5bvNDdWcym6ox3yQtd2f1fxMBXE/bS3ZIWXahW0St6C5TC6DsOmqCkCex80YaeeYTdB
	M1OvAmeIMcs5ecPXXQfDgXdkjnM8nzUfl7UgrH0dF+64rVI8sO5fDBq05WIaCQ==
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
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/1] smb/client: fix incorrect nlink returned by fstat()
Date: Wed,  1 Jul 2026 10:39:06 +0000
Message-ID: <20260701103907.794299-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1: https://lore.kernel.org/linux-cifs/20260629152659.703943-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smb/client: fix incorrect nlink returned by fstat()

 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.54.0

