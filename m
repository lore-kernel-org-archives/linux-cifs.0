Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F22303CAE
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 09:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780738021; cv=none; b=gdqSkbZVkZ4XxbMr3QlJqzN25sAmJSVk9ZLTvrSbvPTPtYopDy8+24UrsfQ4Cdh7FuIunJgHFw+aKfePceMU6SIVXly09/Qj0qLorU+KIxtV+7ktByQ19bKgyd2ZyFbOtq6X7PbaXxGyyLA4Qm7FopB8fw5veyBtgC/nE9F4zdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780738021; c=relaxed/simple;
	bh=AsGq61h4qkZaISM9fvWX2bI/DTzVgqqDCiIkOyTaWHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SIILoi7WXeaAn1QlOD/3GFbGHbshmzNtTRf73K9ZHZO42Vwsn3ID4RsO7DkNaeIFpBbkdbxT7Ud286dZ/Q+5lTuemWRI5GWH06hX4pbvIEglNqGw0iJEkD5RlZN9S5I563CjHtV7GXSgntp8z3H2V+OrpbCXx8odZ7ehjhJd6Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=m0IVD7Xk; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="m0IVD7Xk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780738015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WAwP1Ljhhyua+laGPlw09X6Hui7032sf2pWKDcAbaKU=;
	b=m0IVD7XkF8iUXqt5Fg2QTyKtko141OJCz3D4VIhbBbsTvYRu7O12j6Zd7Hw5GVPXaARZPQ
	qwZK36v/Mt7YUPuEFmVh1iQ5M72m7LqMEkSS92zwPLYq2xq4k8hbtHiPG3cCclHyZB28YG
	gnxXeepx0LP6SDkxrywP04IsMF3bYXMhmObGBbUeSKLd1jMGV9rbiO9a1LjCYBs07q7G4z
	wMC977EU3jq5BDe2W2scV4dhUg9LAzOcIJ8Bqgyij2IzUZW+fHKhBVYhctd4RpCmxFQQ1k
	I8DAlpvn4Pkolk7Gun30kEfiM2PZW2liD7RJCEw2fWAXjYj5f2TNiIWWOYqEkQ==
From: chenxiaosong@chenxiaosong.com
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
Subject: [PATCH 0/5] smb/server: implement compression fattr handler
Date: Sat,  6 Jun 2026 09:25:56 +0000
Message-ID: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

ChenXiaoSong (5):
  smb: move compression definitions into common/fscc.h
  smb/server: get compression file attribute on open
  smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
  smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
  smb: remove duplicate server/smbfsctl.h

 fs/smb/client/smb1pdu.h  |   5 --
 fs/smb/client/smb2pdu.h  |   4 --
 fs/smb/common/fscc.h     |  18 ++++++
 fs/smb/common/smbfsctl.h |  10 +++-
 fs/smb/server/smb2pdu.c  |  73 +++++++++++++++++++++---
 fs/smb/server/smb2pdu.h  |   3 -
 fs/smb/server/smbfsctl.h |  91 ------------------------------
 fs/smb/server/vfs.c      | 116 +++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs.h      |   3 +
 9 files changed, 211 insertions(+), 112 deletions(-)
 delete mode 100644 fs/smb/server/smbfsctl.h

-- 
2.54.0

