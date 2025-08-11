Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34A170A26;
	Mon, 11 Aug 2025 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754921721; cv=none; b=Egu9In4EHqpNdD5dhp19YDPalWp2tXOorgow5Zp4oAKNuU8EgwAFpoyeoS4yxUJBJJnMl+EQ1Fmb+zVpJamnun18tymmygoKeHxDwyZg1tSbhSQyJ8cRAcQbLkAG9rBhRkZOgysETapReP3zNekIioGHZ5mMlgfoGlaHLEdY1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754921721; c=relaxed/simple;
	bh=jlxefgRH0WVE0rzJVyd/8S1bvpbZvv/m7+Vv0eJO7e8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hOC8OMK8oHBjCA1tL8CfBcNFoWN0XnE65sV6WOjwmkcooEu078LMetOJKQW+DFKFKZezXDrl2oX+Q0y3L8ReLkbkLDAmAxwzFEheCS+aHB9y49uZiRInNRl5cC95XXZGEMWGEnesAczxIfbBzJc/BPWkw18PFJuBUoPTrorOoT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c0xVX08dSzYQv92;
	Mon, 11 Aug 2025 22:15:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A02FA1A14EF;
	Mon, 11 Aug 2025 22:15:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBHw+plocdNUDQ--.57266S4;
	Mon, 11 Aug 2025 22:15:14 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V3 0/2] Fix mid_q_entry memory leaks in SMB client and further cleanup
Date: Mon, 11 Aug 2025 22:07:36 +0800
Message-Id: <20250811140738.1141817-1-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXIBHw+plocdNUDQ--.57266S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyUZw48JFWrXFykuw1xZrb_yoW8WrWkpF
	WfCFy3Grn8J34SvwsxJa18X3Z5A3WkGa47XFy7tr1vyFn8ZF18Kr1vyrna9Fy7GrZ5Xa4a
	gr4qyr4j9F17ua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

This series contains the remaining patch from my previous mid processing
fix series, plus an additional cleanup patch. The first three patches of
my earlier series have already been merged into mainline. 

Patch 1/2: The final patch from that series, which improves the helper
function for mid cancellation conditions. The previous helper function
had awkward semantics requiring callers to negate the return value,
and was inefficient due to the extra negation in wait loops.

Patch 2/2: A cleanup patch that removes unnecessary mid_queue_lock usage
and standardizes mid_state access with READ_ONCE/WRITE_ONCE. This builds
on the fixes to make the locking model cleaner and more consistent.

These patches are independent and can be applied separately if needed.

V3:
 - Use mid_lock to protect the update of mid->callback rather than
   its execution. 

V2:
 - Inline the mid_execute_callback() in the smb2ops.c to eliminate
   the sparse warning.

Wang Zhaolong (2):
  smb: client: fix mid_q_entry memleak leak with per-mid locking
  smb: client: Clean up mid_queue_lock usage and standardize mid_state
    access

 fs/smb/client/cifsglob.h      | 21 +++++++++++
 fs/smb/client/cifssmb.c       |  8 ++--
 fs/smb/client/cifstransport.c | 69 +++++++++++++++++++++++------------
 fs/smb/client/connect.c       | 25 ++++++-------
 fs/smb/client/smb1ops.c       |  5 ++-
 fs/smb/client/smb2ops.c       | 26 ++++++-------
 fs/smb/client/smb2pdu.c       | 10 +++--
 fs/smb/client/smb2transport.c |  3 +-
 fs/smb/client/transport.c     | 50 ++++++++++++++-----------
 9 files changed, 135 insertions(+), 82 deletions(-)

-- 
2.39.2

