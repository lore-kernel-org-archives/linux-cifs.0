Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CBF2413D66
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782901534; cv=none; b=qZA7bzlkIkrAMtuFGx/UiYoWUvIleTATF+/AFfbcfMlmRtKHDphBgHpfZRnVth96kxCdoNbI8xtnnCO2b01CnTTXyfJDxw2BqAD0Ci1aF2nTC2JFlZ6409HzA38h2hexaQLR+GINN6DoF++nVcyww8dDZANZmw/dEiipqdwEr7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782901534; c=relaxed/simple;
	bh=WyhbZD1ofElffTKod3j0crGaox9jdKgtRBUVR158NAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwAiSOBskSUmho7JU4/Bl5mef09JVd2RhHq6yslezNBcgmv1R0HwUvrzruIYw24hD07TuOX1VxI9xo6xff0Pnbu9cKZMgj2W26kBIzlVB8d/ZucgECqLKQ7YfVbYh3cdcQ061aWJ9y7q4cSvKbTGlvJLhGBzcpxnNtY6kMIJVP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [123.114.53.210])
	by app1 (Coremail) with SMTP id ygmowABnicOq6kRqaUnOAA--.38360S4;
	Wed, 01 Jul 2026 18:23:49 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	aaptel@suse.com,
	xizh2024@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH 2/3] smb: client: check posix_info_parse() in cifs_posix_to_fattr()
Date: Wed,  1 Jul 2026 18:23:22 +0800
Message-ID: <60461bf5482d51ebd950fc84fd19ece9ac1917fb.1782898568.git.xizh2024@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782898568.git.xizh2024@lzu.edu.cn>
References: <cover.1782898568.git.xizh2024@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABnicOq6kRqaUnOAA--.38360S4
X-Coremail-Antispam: 1UD129KBjvJXoWrZF13uFy3Xr48Aw4rWFyxuFg_yoW8Jr4UpF
	Wag34rCF43Xr18uw1xC3W0kay3t34rJF1UWr97Jw1Sy3Z5J3ySgF1DKFZ09r1Ska1rGFWr
	tFs0yFW0qF95CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7
	Cv6cx26r4rMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2Iq
	xVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42
	IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aV
	CY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbJPEDUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsPCWpEzdUDSgAAsz

From: Zihan Xi <xizh2024@lzu.edu.cn>

posix_info_parse() returns an error without filling the output structure.
Check the return value before calling sid_to_id() to avoid using
uninitialized owner/group SID data.

Fixes: 9934430e2178 ("SMB3.1.1: Fix ids returned in POSIX query dir")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 fs/smb/client/readdir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 1ff77f3d1de0..df46aa919c27 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -244,9 +244,11 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 {
 	struct smb2_posix_info_parsed parsed;
 
-	posix_info_parse(info, NULL, &parsed);
-
 	memset(fattr, 0, sizeof(*fattr));
+	if (posix_info_parse(info, NULL, &parsed) < 0) {
+		cifs_dbg(VFS, "Invalid POSIX info payload\n");
+		return;
+	}
 	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
-- 
2.43.0

