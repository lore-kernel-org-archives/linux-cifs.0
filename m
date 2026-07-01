Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22453B7778
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903430; cv=none; b=i0H0w98uVVOOttk03j8GzhvZqLNI1ovnx75FrnwtW7bBTxH/vdRVvPcwZu40f/nEJpwX2Bo/YcpkAqlwV4p0O/KwaZXCF8wNWUDtC8H8tHA7Y3RvCI+vWJM0JBxN6zthzdRfGUwrTpwfMajl5bEggqxY0D+1pXRwnNgwA0Gd2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903430; c=relaxed/simple;
	bh=MWeZfn3saTOtcRi1eUue9GkqNlifiRg/K5JnEhruOG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XPK/BFssyOig3+xIymAmsvBCv6OK58iG6LEKL3dCdHmAEP0DXZy1hz5pXWMUnHvmAOgeTSHqza00E2kCYhIw9iQFiAu7kC+X04mB10SqY/5sY2bYe+eIoGX+ARmfFRF+XYmFmpDoN/GE+xg/cBeUGd3StFhUYye+xRlQuWtqSRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=qy754nAp; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="qy754nAp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782903422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9Wo61wTjCpddLJOrH0Edv6UUT9vC/fcvgdIdmqf6YGc=;
	b=qy754nApguSB14dJW2+izq29TU5HdhJDUh5daCzi3AgoSL3NPa+1MCuA6do+2fcaZULqu2
	BJ/ouPuZjmR4k5FSsrh4+WTSusxBTewt2NYBYVmfxh6vspGu0sl11nXY3hICGz6nM3yiMJ
	oT+LJHaBOA9HjC58trGufQX6zemI1XrcJejUA/HBvDpTB5pE0EaiOi8+FSbu8t1vYnnV+p
	B6YxdOqzfTSq4okTaV4eNddXVo3mBCl44X4Pdo85jMrHbDdhgLikKl9OqzjhhcRRYB2cmN
	8WLsx3sy63AL27RTUycsg+JLdWqUSuaggolOoQ1FjOypA0AW9DIyapWJhJsQdA==
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
Subject: [PATCH v3 0/1] smb/client: fix incorrect nlink returned by fstat()
Date: Wed,  1 Jul 2026 10:56:34 +0000
Message-ID: <20260701105635.794615-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v2->v3: update commit message.

v2: https://lore.kernel.org/linux-cifs/20260701103907.794299-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smb/client: fix incorrect nlink returned by fstat()

 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.54.0

