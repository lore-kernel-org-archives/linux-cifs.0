Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DA21A83E5;
	Fri, 16 May 2025 03:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747365571; cv=none; b=pKbamidFct7op1h5L2F209x/2YMLEe71osZUqG2nI+q5vxz5yLsXTPA4LcLEiyNBqYZJmMRav4sxZW7zphQojWAoAyP+R17C1YzB6cMAQNki508xdMTVhVJvvZKY5w9X8fdMsTNA+zowTZAO9U3NyjlKqv02Uc6f5hrkNQ1wGIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747365571; c=relaxed/simple;
	bh=S9hNRYZGBtGHnYh+1TJ2cA7pQVIF2TmPgmAfd2x3vSo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Iam8lScw/8U+/KrxRBg0nWG9s/MYgjCh/pRdNZR18B29bBfglb9lrJLBoAFLkwJ61BSNLPJxd0Bx/gNtT/k63eAUbzq/0ws89in8JiLsk+3zhGrXWRQ0ML3uTnI3ld3L+fdqHz/dX1ejCS63olycsERVFEoomJcVpYbL7vJ60ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZzBzH5ptwzQkRL;
	Fri, 16 May 2025 11:15:23 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 466BE180B41;
	Fri, 16 May 2025 11:19:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 16 May
 2025 11:19:24 +0800
From: Wang Zhaolong <wangzhaolong1@huawei.com>
To: <sfrench@samba.org>, <sfrench@us.ibm.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <wangzhaolong1@huawei.com>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>
Subject: [PATCH -next 0/2] smb: client: Fix use-after-free in readdir
Date: Fri, 16 May 2025 11:19:21 +0800
Message-ID: <20250516031923.159247-1-wangzhaolong1@huawei.com>
X-Mailer: git-send-email 2.34.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)

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
  cifs: Reset all search buffer pointers when releasing buffer

 fs/smb/client/readdir.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
2.34.3

