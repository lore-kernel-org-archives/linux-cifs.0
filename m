Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7CA286A4
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766974512; cv=none; b=JKWYIU7F86cVchHtHmcZRZ8dp2aidDVvaL4Wjg5HwC/cuUtxeiYqJYxQ28ADOBnDsBgtGJLLsB6iCyOR3SKI6zyQzc5n2PWyGY16CZJKgP3fSwOlfwCo1G7A4XaPYfMILlY5azo7uWhxZT7hC7KIg76RdT3K6qMX/2/oGdWs9LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766974512; c=relaxed/simple;
	bh=L9vuETE2WvHsya2JOYaMRNtdM/vFCqkLz6hv4WSTipM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=etDndS1JkZblNhP7eKhiVZdPs73i+PFshLyy/9LbimWDE0W8RgEZgHD4QEYTtqK9QqHGzDmbkXKc0uV0//gs05DcRYkunbC2rLvXbRJp/0YOzM0wtC3YFcyVvGdxiHUYHVJzk3lFHZuwRrrwQJVRLVUY6TmdT5Tn1c11/sDBEMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ny1YqP/4; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ny1YqP/4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766974508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VptwHg7koSxRjUHLi2Hd2X+SsXZIrHpIRViqzbwKROU=;
	b=ny1YqP/4NY1PZ3MEVWhtj47LBAA7BlP91mWuNzQgPGl/oQgAb8TUrF8ntSaro0UdCjqQTB
	g/00eendbbyjHenAq/8ZTzY3Z1eh+3VhUElubdTsZsQXCJIFDOEgJWbI8MbmiMkjBll/xD
	FmT8jGmQCta7vI0tUh8cYhUvcmuFjcQ=
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
Subject: [PATCH 0/2] smb/server: fix some refcount leaks
Date: Mon, 29 Dec 2025 10:13:28 +0800
Message-ID: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

My dear team member, ZhangGuoDong, has caught some refcount leak issues.

Other patches pending review (including those from others) can be found at the following link:
https://chenxiaosong.com/en/smb-patch.html

ZhangGuoDong (2):
  smb/server: fix refcount leak in parse_durable_handle_context()
  smb/server: fix refcount leak in smb2_open()

 fs/smb/server/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.43.0

