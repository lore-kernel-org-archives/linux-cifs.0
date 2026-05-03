Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9B43B0AD9
	for <linux-cifs@vger.kernel.org>; Sun,  3 May 2026 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777815867; cv=none; b=U93B5EUJA0XeG7/unDBnf6S/Lpc/JEqgLZ7R2pC2Hm9BvvV41cCx5K/VxfZDONkUAW1jFIrxOJBpD1ToA2ybP28WXcNT1S3LbGZQcMvW8iqgzCfbVJXxfs/wqz6EbjT1pNcEFpiiIMzy695E3/clX7zPSmTWoZYuWGUTndJmOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777815867; c=relaxed/simple;
	bh=m0Di5PofmqphskgOkYlIuUp+PZlyV/Ba/LxTPx40/+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hOODuzOZ7XZjHV6FFirhs/SZq2Ww3ZHInAo4U3msKI3BjUwDrIXplus5Ti1/wp/kSLoaVayDSO09NEiyHxYM4vgR6SFppJwRJbkXth5tcYCyK6Nt4N+EOuz7QHvw6h+iwRtXxg/lvC+VqUw/FiYCvAsmL8P4Oqwsq1Du0EGwYr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=K8yEjOxn reason="key not found in DNS"; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="K8yEjOxn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Transfer-Encoding; bh=T5k6t3ZSrB
	WTULcAB/fp8N0QVmCrwQ2cZ917lKzRwvw=; b=K8yEjOxnwH91m09wv1P1tnXBjO
	ocxuV8pOMuV2sMzXvITFsCr+OgjtTz3XY7+TFK/sj1Rhmd5nFtI2X3d9nV44nrbx
	hBVm294MMv3Y3RY70pgDx23L38fyFtVCRSa5UhYT15b+qpCapRzY7bw1Et+ghWub
	Yww8TZHnedWdQs9EI=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-2.icoremail.net (Coremail) with SMTP id BLQMCkCGaLgHUfdpQGflAQ--.15142S2;
	Sun, 03 May 2026 21:43:38 +0800 (CST)
From: zisenye@stu.xidian.edu.cn
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@chenxiaosong.com,
	gregkh@linuxfoundation.org
Cc: linux-cifs@vger.kernel.org,
	Zisen Ye <zisenye@stu.xidian.edu.cn>
Subject: [PATCH v3 0/1] smb/client: fix out-of-bounds read
Date: Sun,  3 May 2026 21:43:32 +0800
Message-ID: <20260503134333.3260640-1-zisenye@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BLQMCkCGaLgHUfdpQGflAQ--.15142S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYZ7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx
	8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24l42xK82IYc2Ij64vIr41l4c
	8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOxhL
	UUUUU
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAgUCEGn2FOdYKwAAsK

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

v2->v3: fix build warning.

v2: https://lore.kernel.org/linux-cifs/20260502095435.2969835-1-zisenye@stu.xidian.edu.cn/

The following patches from v2 have already been merged into cifs-2.6.git for-next:
  - smb/client: fix out-of-bounds read in symlink_data()

Zisen Ye (1):
  smb/client: fix out-of-bounds read in smb2_compound_op()

 fs/smb/client/smb2inode.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
2.53.0

