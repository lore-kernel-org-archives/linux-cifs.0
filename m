Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3D9CA6F
	for <linux-cifs@vger.kernel.org>; Sun, 12 Jul 2026 02:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783824923; cv=none; b=VcjiehRDQ4tODH8k6o2NNY3GAq0X19Mv6fCBxawiMi6LHh+4R0WPRODXalwGZ7pF/aJnX8x+IqYfvLmviQqVm03RArmeT5BvLV2SYbdQqIT+AWMr88LflbcBLAOQoGNqm00J3ajxmdLp+9hAaVrDN9fqdwx8+IUBGHqJfn72Lsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783824923; c=relaxed/simple;
	bh=COjfZ2lSHPonCdOxldVPyvI4eQWZhDbzsLF0mrGtwU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WkKdDV+P2nPkxFXhtLKDDXnoL9IIstvMECRu36zH1V+MDzGW5wllGq3jUocrRpbH6VnXHFPLBstsbA/TP+06Kxvb5kIvzmuCv2URjcl/EPH/+GK3VBYdAe5U0ZeJXc7kqssbSwHoLC+OgE2IP15vJs/rnpSNTwvOslD/Z38TqvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7CbJi5A; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7CbJi5A"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3811e59df58so1350904a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 11 Jul 2026 19:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783824922; x=1784429722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k7LgNwxuoWBLJ8SbEmrF+q/5b6oVtW1AjKvLyEOzJLc=;
        b=i7CbJi5AxoAFkvDytRR/rMxCufz6MGvx4U+M7UpdYNziclXEI+HsxW3vTXkWhhw/ly
         d7uEVii8WqQV1fxyLodsvGcePaKhcrvzFWtKL0rAvLourkuDXCHrLM5+DZF1zF3tqUUs
         Kc3tcDF6HYabLOeuDFq+PNR7m9eHlwJuLD6nFGSfv82JjVqd8aNiuVn2EpA94zI1a4Yk
         KxBrhZcjbLID1M3cfnQ/bO4NG4pVgNXYN7C4/OZsIMhTtR0UGpNWyaJ6LoKmHAPA58/F
         2f7GgSekwsK65X6H+nN4nH2METvjikU0IdAz+970pXuwyoHhCR1u5kUzvNZ0MhOGNLwH
         VrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783824922; x=1784429722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k7LgNwxuoWBLJ8SbEmrF+q/5b6oVtW1AjKvLyEOzJLc=;
        b=FOS0cn/4nJ5q2/07/V42X/3nfVaxq0QFwgwdeamSd0KGwonpxo8lve4BVI7UQiXLV3
         YjBnHCb8Y3+XAkwXMcUCAWW7S88ddJd98Ug4tHE1Kuc1WcYNMu517IOIGkkTZcoUZAvF
         tDx6RnYZC5tWHTAKxT/2f7mciYGOfhv7yDxnQ5jZxLGtlU9a4Kt011w/y6mnaiAOifGB
         zBrc4yzSXwoLjdDEVzYr8+s/xVDPg+VpMZtt5KooBos5WLn4F+KRITaOBvFS5/Z8/avn
         p1TbQYDsjizooRhrQafqckUQ4qNKyeM5WCkoUOwrfGbO0+FNrM4L9PdVSX1NzdjxcAVg
         Sn3g==
X-Forwarded-Encrypted: i=1; AHgh+RoziYPzfJly0tqqzJGe58GXTvVr9na2sideM1vtY041uabgogmZQB88R1dbj9mtDLXAOwMgaSW5LMuy@vger.kernel.org
X-Gm-Message-State: AOJu0YzBKRbtvhO0dfbexboRfQu27yNjrA/96iyiIUWxDYP/q7Q+tQOz
	pR9afqbnRImbPe1BlGMqTDXzSYu5lGzD0eoYqaPACG0zx6bJf9l+wll/
X-Gm-Gg: AfdE7cki7+V137xSxpTeGggKIyhqNiFtm+UIVap3Wf6BB/u2ZlTTL+gWok5P2/OaSKj
	8lVLbZVIA+96IoTsCu3mPaomX/957abCMYru5VQqKnaMBZYGxJLLMWvl6KKqOltSOLViW8xub1M
	aIg1A6lXkXqcH+VYinE8AdN8D5voZmcEhy5oNJwAr7rKJNf/fab8j8UziPXdp5WflwdV6VNnx3+
	gQXjblKIjxi08uhObyva0JQd8DS6aoXyv64n97B+irjgstVF9+n1kGxxMDdB4EHmqfFG2KxtziI
	o84PR2VfX4OqW8C1+d1QkIwSi3XyfUXpH8MogrFuDalPMAFUxA9AkwcSvelUgRp1dcO5qD9+gsl
	8nRMFCme8Qi5BWpd2F4hqvjj4sOFDIe+qsVYQy1HncKt3GcVKXEiICGsINgPU81x3TcTezcTk6V
	JfIHvaUYRiT2FRoB/YU9aY/Q==
X-Received: by 2002:a17:90b:2783:b0:387:e0bb:5802 with SMTP id 98e67ed59e1d1-38dc7bad0aamr4405786a91.41.1783824921873;
        Sat, 11 Jul 2026 19:55:21 -0700 (PDT)
Received: from FredPC ([2600:380:805f:5cb5:2256:566b:b74d:6f4e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311a6115e61sm36804748eec.22.2026.07.11.19.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 19:55:21 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: use kvzalloc() for megabyte buffer in simple fallocate
Date: Sat, 11 Jul 2026 19:54:02 -0700
Message-ID: <20260712025402.1804211-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

Currently in smb3_simple_fallocate_range(), a 1 MB buffer is allocated
using kzalloc(). Under heavy memory fragmentation, a contiguous 1 MB block
of physical memory (an order-8 allocation) may not be available,
causing the allocation to fail.

This failure was observed during xfstests generic/013 on a 4GB RAM
test machine running fsstress:

fsstress: page allocation failure: order:8,
mode:0x40dc0(GFP_KERNEL|__GFP_ZERO|__GFP_COMP),
nodemask=(null),cpuset=/,mems_allowed=0

Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 warn_alloc+0x163/0x190
 __alloc_pages_slowpath.constprop.0+0x71b/0x12f0
 __alloc_frozen_pages_noprof+0x2f6/0x340
 alloc_pages_mpol+0xb6/0x170
 ___kmalloc_large_node+0xb3/0xd0
 __kmalloc_large_noprof+0x1e/0xc0
 smb3_simple_falloc.isra.0+0x62b/0x960
 cifs_fallocate+0xed/0x180
 vfs_fallocate+0x165/0x3c0
 __x64_sys_fallocate+0x48/0xa0
 do_syscall_64+0xe1/0x640
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

Node 0 Normal: 3375*4kB ... 7*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB

Since this scratch buffer does not require physically contiguous memory,
switch the allocation to kvzalloc(). This retains the performance
benefits of kmalloc() under normal conditions, while gracefully falling
back to virtually contiguous memory when physical allocation fails.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Tested-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d4875f9532b4..55b53bb9e3fd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3595,7 +3595,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3652,7 +3652,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 
  out:
 	kfree(out_data);
-	kfree(buf);
+	kvfree(buf);
 	return rc;
 }
 
-- 
2.53.0

