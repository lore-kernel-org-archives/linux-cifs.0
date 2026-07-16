Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175ED3A1C9
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 00:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784160751; cv=none; b=lJz5EOGOojKvwbYQPY1E2twZnm+oVZ+9dFXO7PZ+N4/uPwx6pCEebR28ERsNou8ayHwr11yTWAJ6S7rGYhF5161EIYbFTHvp+D4TLCSQ08MaGyBDztxC7BOph2imNeEVX+l1EcjNwAkMh325i+Yi678ZBqOkeZa/OWF7gVR1Qls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784160751; c=relaxed/simple;
	bh=eUV4qN3xQJNGOmXqCQOJ9iQQDAqrdZuuwwVOn0k7YN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KsQdlDlPnJNvE1hSXxVdaYdoyggDbtvnWjYWQejMc99cW5QbC1XKH2jWKudFz6nPRf59keTxSETifnpgssoZIoXWnDZ/hpa0LNNLbjsuJNg29hI8FCloBovLR54wdSJ1zYyjNx5aeobl6YLhnzh8gx4/w26XeYwqq3iZuonfLYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=foTEyL1h; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="foTEyL1h"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784160744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JfRmq/6r7ksegAcXwg57faWKpNi7hHtOI2Mf8pRfsZ8=;
	b=foTEyL1h7C7fggEca+TRMqi3vDAXuBZz7N3Nk5I812rscTSgl2vUbwwG5oMzmyJgetgKEE
	UeRrLNljVaYoJQVlwYJDH6uvoT4Zvw0v9ErYE7VG3KE8ZK3sfHBdMKLdWq9NuqFIXlcUQ/
	QSJj3olPf5j/VeB6m4+LU1a3yLNfr63o1Sb05jSBnNmX1qsYwHXtS+hdUW48PzymBRTfte
	PgePP5ahmPsMXDUqiUaXn7ptN855S5QmhQJExg89D7dkxMDqe9VdzSe857h/hjhAkOV65/
	3D662PVb0PV5UwcspvKv7M6luec5qixtUjiil6OmdwZNY2LVb/JCjaKMzZB+UQ==
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
	gael.blivet@gmail.com,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/3] smb/server: fix some bugs in preparation for change notify support
Date: Thu, 16 Jul 2026 00:11:53 +0000
Message-ID: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2:
  - Update some coding style.
  - Patch #03: use pr_err_ratelimited().

v1: https://lore.kernel.org/linux-cifs/73f4bc4e-3bdc-4bf2-b145-c9b6fc480451@chenxiaosong.com/

I have implemented the ksmbd change notify feature, please see the following GitHub link (some minor changes are also needed):
https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/

However, to make this feature work properly, some pre-existing bugs need to be fixed first.

ChenXiaoSong (3):
  smb/server: fix signing when a response uses more than one iov
  smb/server: cancel async requests when closing connection
  smb/server: stop new async work when closing connection

 fs/smb/server/connection.c | 20 ++++++++++
 fs/smb/server/smb2pdu.c    | 76 ++++++++++++++++++++++++++------------
 2 files changed, 73 insertions(+), 23 deletions(-)

-- 
2.54.0

