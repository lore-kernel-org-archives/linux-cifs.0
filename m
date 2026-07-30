Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213DF32470F
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 02:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377583; cv=none; b=EYM3LvNCsh/VmJxYGardJlt1mrOPNIYJDYIY1EX4FAHgaDMqHCgSClzeJPKpOUjm4qgn1tkC4Kz1Xq7utsRJ2dc+3/lSkGAj/mGUooiI+txiztvaCPOStenX/dbFLgS0aVAz/gM/HrVC1txWJmImhUIbaQ4jPoaDI77JALwR+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377583; c=relaxed/simple;
	bh=XhVmt94+PIsNXzn6Nj05RXiMtw3CtJsdwQdyFAJSwxE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gFcpIo2BMNY3+UHUfOVVYYLfUuDQWVTj2czZQFRQoj1ijmzfSVvRB9MbcF2wM+g4mXvkHw/w8r83hg/qge1znvBoqI8iXmlVPVjSN1h/wc3tg8UESGUbNCcl7s8AUg7RXpGFHxTsoMeqPUT39RTWsb7JI1044EpG3MmXhfIJQFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=KctSUFga; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="KctSUFga"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785377577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ivX56sO3cKniAPxAAoa9Xy8J2lTiJFNeVOs+2TAN/vI=;
	b=KctSUFga4QUyfF0Ovx5XvoLT+G0dR6wnQ7dCt5ieFNG+caIEFeuxUDwNbyIudRwZeW+50h
	VWXwaQcxYR8TkueOBtUFHvpAAXIuXt1ySGCcEHzQAzBmaUHIC/A7glWikxtlY/ylTkEvY8
	NRgt8rUYCuo5BuDE7Ewfj3LSGtJxF2QHfvvrrTwP8eiBQXMnbBWK3JHOBG5rJYlxR5voMh
	rZ0soVjjTN8U0873UEtgvlnkfWE5pvuT/YSA75569f1hYVonm3pwb8mZfaVBUoVWchK+p8
	aTdAsegwYFxiyQ0KWq3MNCjemvnPiVcBbCCarE3m85JJ4mMATmwq7l1a0zfXoA==
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
	hch@infradead.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 0/2] generic: new test to check nlink returned by fstat()
Date: Thu, 30 Jul 2026 02:12:36 +0000
Message-ID: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v3->v4:
  - Patch#01: only add generic/002 to the "hardlink" group.
  - Patch#02: use `_fail` and `_exit`.

v3: https://lore.kernel.org/linux-cifs/20260724031210.332153-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (2):
  generic/002: add test to hardlink group
  generic: new test to check nlink returned by fstat()

 tests/generic/002     |  2 +-
 tests/generic/798     | 59 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out |  2 ++
 3 files changed, 62 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

-- 
2.43.0

