Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727B9357D00
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 00:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785977221; cv=none; b=RCCuYwq3T77RChRHt7eG6Riv8zKC+ysk7JsCyYAOS1KF99z9qlEA6DaawUX8PwC9N1AJUdy7QchwPkmvzX2yIgPHroF9YsNDsuqIGUFG3dtu+EuV/f2byWgW6BeZ95USUzUY9/Os7C/sC130lmtLrw/2Q748rqdpg7f/REwchx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785977221; c=relaxed/simple;
	bh=Q/7l5UII2u3yUFjQqWDSQmFm5zrxXfm28uBE4rz9+vo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A1TctvbfwHJH+5cRVTanRz6gm9U9YlS/DKi52woquEyCmjdDAM5UUpWr5vlYH1KXJbe+yS+w/Bd+WV0gAcwKKaN88G82DDbuBmVP6yjmeVdJ8V1Fc4jrOv6okEZfspaU2Uh8nhSGMlkQIzmTnu4ntGS7/WSbPRy7GZoqOcTqg8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hoGORbHA; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hoGORbHA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785977214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GLaB2SDC0sWG1AequVNIXe9xf93diI+HqL9gFfnbhkE=;
	b=hoGORbHADWBvszOl088PIyFEVOHZePfu7Pn6ncO+aS3SuWNsziGqw8SFj3ngFTzUO54MhX
	Ac39PSE/7oLrsb77K2bBaRU/t5PpdN6ikZPtD4GZZ3K/lCeOp3CQlaXpAonuYXZnvIgxtw
	P97Qqy/K9hPbdld0rwyLhOjRoowQmd/coptz0Hfw+F7+oLVWDrwGhUlDMP2y37HlI6qVTt
	W3hqBVgkng437n5SNRHaX9UcL8Y0RR4x4gzAERnb25pSxHrfS/kyYy6GBfdjsgnNCOBnzv
	cvwcI2ye/e95RmWtKlC0F03KpoD+LlNuufsfu8CeoZ3euEQTKGS0RxGB9jOfoA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH samba 0/1] smbd: remove redundant rename destination open check
Date: Thu,  6 Aug 2026 00:46:00 +0000
Message-ID: <20260806004601.314121-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

RFC v1: https://lore.kernel.org/linux-cifs/20260805133145.312198-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (1):
  smbd: remove redundant rename destination open check

 source3/smbd/smb2_reply.c | 43 ---------------------------------------
 1 file changed, 43 deletions(-)

-- 
2.54.0

