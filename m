Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED933065D
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 01:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782263681; cv=none; b=TcmPQ00iNo176XguQx7RHy5znDH0VFYkPptMkHCVhJqN4rmAMSP4aZ/adKsxUzf79sR1Qyb2gkcvsG4UWGqTlStZIVQGNMJuqbJqYI/SWyEOdcKEXXgA9D8bRiKZygAdn+lBp1u1tl1VTnKiE653LvgbbvB+zjvcj9STWLqb8Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782263681; c=relaxed/simple;
	bh=8y7lgkFh5MNBRGCNdUZOiTKcB+MdQ2THFZ+3OQ2g4EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ES8zfsvsQbAoLbLoWtGqdw4oJZ9sGi74SngqRpnGKSK4NDCkoBcLr1IX1U1nwwHpbJe0IRpslWUBxtBMLWjMwktU316DQt8u4O6igtACfCKPAmrOTuDF6O4x7tis4CS7pseYprTrqS3MesGdK/mh0J/iZoPbyyRdnndjGkb3sGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=qRWoY0fa; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="qRWoY0fa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=H1
	Z3ts7s4IiDRsqtYBAJLaeyBbRLUvdMXNpfjbEV+A8=; b=qRWoY0faHCohoLYhSy
	UgvO0qdQBfCPNYs7jMOin/JoMbHfsHPG750kgrPvFU3B3o7GHhfhRXTBx+2RvJPz
	GILVufKrhtCr0+lcVDEvPpVpvWt/3CbFCVD8LHU71xzyFfFq7YwoVDXYU5HK7wqF
	5EPixsW1EVaeOyfjhoaiKlPCs=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCXb24yLztqsdWDFQ--.18691S2;
	Wed, 24 Jun 2026 09:13:24 +0800 (CST)
From: liuqiangneo@163.com
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
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH v2 0/3] ksmbd: fix some memory leaks in ksmbd_vfs_* functions
Date: Wed, 24 Jun 2026 09:13:17 +0800
Message-ID: <20260624011320.9146-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXb24yLztqsdWDFQ--.18691S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw4fCFW3Zr1kJFyrtF1DKFg_yoWfJFg_Wr
	n3Xas7Xr1rXan8Gw4UtrZ0vF1agw1kWry8Was2qFySyFWfCrZ8W3yDCFWkXr1DXF4jqw45
	Cw13KFsaq3yaqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU835r7UUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC4BZCo2o7LzZxtgAA3Y

From: Qiang Liu <liuqiang@kylinos.cn>

This series fixes several memory leaks in ksmbd_vfs_* functions,
where dynamically allocated buffers were not freed on error paths.

---
v1->v2:
- In function ksmbd_vfs_get_sd_xattr, remove the free_n_data branch label and
  uniformly reuse out_free as the resource cleanup exit for all code paths.
- Use `goto` to free n.data in ksmbd_vfs_set_dos_attrib_xattr function

Link to v1:
https://lore.kernel.org/linux-cifs/20260623021240.34722-1-liuqiangneo@163.com/
---

Qiang Liu (3):
  ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
  ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
  ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr

 fs/smb/server/vfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
2.43.0

