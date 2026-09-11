Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2A54A49BC
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 16:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144616; cv=none; b=JuZQC+tZeKCfWbSI0ZDSYLtfZnRVQzSydmlkxIAosKYiS6xek4+cb8ogmQVOwpnLSEDhZlclsnG9o4uqizWJOdNK+0cFEq8CSxOv/ZPOB+cxrHVRX2kfVDhjfGAqgH3IThTOq8qcHES1HU1UnQ8LBO9Ji3JPo54IJj9r+rBbLGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144616; c=relaxed/simple;
	bh=ead+rbWZ6FA+9NjbK0Ul9R+GhmqZWgNZzGewUNwfY9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kzQzfapq+CSkbqOWbFQZnoqszm28PhR3fiz7SD9CpN94Fut6JMTK6QKmLczfVwZ/nOZICQ0imAl0yOcaGi7avGhSFCSpoDOzN+zw85KvA7elAcq4G1frznR7UsLgHj2QRVuxef68s1iR/r9wt8Rrzfi6du8S5Quv5gI0uBmg5OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ocsDgq6W; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ocsDgq6W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zB
	V2eM5PZKb2R9vTZjCIM4R0aXa2DOzYfiHxi/VKaaY=; b=ocsDgq6W9L3D+AfhMG
	6n/yy03Gwg8km1bp0BzdAcZjreZ5hoWWeecza9ZlCVdwlcdEnbK5Ls66q5Vzmgc7
	+QqhX+p9gHD5rBaQomoqTtje2IBzz6eoldi2ufwq2sfKOb85hO9dI1PxjKypKpXD
	K6crqhZdJJQFvurM+pJwHdguY=
Received: from hh.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDnmY37LaRqM4PiOg--.53919S2;
	Sat, 12 Sep 2026 00:36:11 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	huhai <huhai@kylinos.cn>
Subject: [PATCH v2 0/4] smbd: fix FSCTL_QUERY_NETWORK_INTERFACE_INFO handling
Date: Sat, 12 Sep 2026 00:35:12 +0800
Message-Id: <20260911163516.6403-1-15815827059@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDnmY37LaRqM4PiOg--.53919S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry5AryfXF1UtrW7Zw4UCFg_yoWfurc_WF
	WUGasrXr4UWF4UKay2yF4UZrWkKw4I9ryxA3W8KrZrGF93XFs7GFsxtr1xX34rWFW7ZrWD
	KF9Iq3WSyFW09jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbku45UUUUU==
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbCzhxO02qkLfxfgwAA3M

From: huhai <huhai@kylinos.cn>

This series fixes several issues in fsctl_query_iface_info_ioctl():
incorrect link speeds, an unlocked IPv6 address-list walk, an invalid
final Next offset, and incorrect IPv4/IPv6 interface reporting.

Patch 1 was previously submitted as a standalone patch; this series
supersedes that submission.

---
v1: https://lore.kernel.org/all/20260910090818.24479-1-15815827059@163.com/

Henry Hu (4):
  ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
  ksmbd: fix unlocked IPv6 addr_list walk in
    fsctl_query_iface_info_ioctl()
  ksmbd: fix invalid Next offset in interface info replies
  ksmbd: report IPv4 and IPv6 addresses independently in iface query

 fs/smb/server/smb2pdu.c | 134 +++++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 57 deletions(-)


base-commit: 08df884136f1c1197bab2a27814404fd329d9aac
-- 
2.25.1

