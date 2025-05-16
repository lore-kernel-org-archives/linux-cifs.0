Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E615530C;
	Fri, 16 May 2025 09:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747387310; cv=none; b=CFVmkvLFOe9StTMYNBzpqp8wlidoHwvAuk4p/tc3ZSMnzeT2Ogt6V2nu5qbWvCIZFbYQrIV9/d+f6cMP2TMJBqQM+3tXJCyKEeAgGK8WgTaM0TnuVuqEnlkxqC3kLLlAKqUj1LCd2DOTnufF/dGiSw4CHCNX2Dwyy8mRyCth5DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747387310; c=relaxed/simple;
	bh=31DsqiZfKoEAo/n/fuz2JtG3HxLVTfefOHjr+q6fCQc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uEEU2r/Uwi6rLA4M3OCiNaA0ygeFfBcnImLK+b/PA0bjvcgDWUBGgMKiz+Bg1zET6Xgyrmb1x+xaueOV4//HihW1YAEg3m7q2wIT94PkyRZo0bvC8lASv+vLSTYxSuQD45y5+IanM+Sv92SYCkaVJMF3KlzGKPz/c+HW6zLMg1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZzM1m4289z2Cdht;
	Fri, 16 May 2025 17:18:04 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F3CF1800B2;
	Fri, 16 May 2025 17:21:44 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 16 May
 2025 17:21:43 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <sfrench@us.ibm.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<wangzhaolong1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
Date: Fri, 16 May 2025 17:12:54 +0800
Message-ID: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500010.china.huawei.com (7.202.181.71)

V2:
  - Correct spelling mistakes in the commit message, such as 'lopp' -> 'loop'.
  - The titles of patches follow the same style.

This patch series addresses a use-after-free vulnerability in the SMB/CIFS
client readdir implementation that can be triggered during concurrent
directory reads when a signal interrupts directory enumeration.

The root cause is in the operation sequence in find_cifs_entry():
1. When query_dir_next() fails due to signal interruption (ERESTARTSYS)
2. The code continues to access last_entry pointer before checking the return code
3. This can access freed memory since the buffer may have been released

The race condition can be triggered by processes accessing the same directory
with concurrent readdir operations, especially when signals are involved.

The fix is straightforward:
1. First patch ensures we check the return code before using any pointers
2. Second patch improves defensiveness by resetting all related buffer pointers
   when freeing the network buffer

Wang Zhaolong (2):
  smb: client: Fix use-after-free in cifs_fill_dirent
  smb: client: Reset all search buffer pointers when releasing buffer

 fs/smb/client/readdir.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.39.2

