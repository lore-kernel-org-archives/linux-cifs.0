Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42622209F43
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 08:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777711253; cv=none; b=UlIyfP8eAzSNCEjuq+XtKtrXA1P2AhGJRflD27AQojXPXYH0E69isHvrH0EHTcq/mualCTs/upYBsVgxKKMnhXA8CPBCgM72ZqrPAHpS0vQi/FUzdwIjatM3m1GN2gmSNskhrxMM4u5QWZ8bzZycOKsUsyOscHZ+xalpsOZIwcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777711253; c=relaxed/simple;
	bh=JyiN2/Y+rhnRT6uD7PqQaAwhkAjO5n3bmc204rERQbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L/K2sIWEG4zCn60vARL7fM7Qm7wfj586RQlO/BUVk5z/Aoz3TRI3McHa9c47fYt7hkuGauNkoGe+/zzQwDlkwfEf3rzOoGzCeP9uj4JwdoG+MnXu/5IfK9G9VEjrvH3TbVrE+rxej9xmMrjMUys++eVJGsHvqBo0YgRW4CbZdrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=OPlomwb/ reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="OPlomwb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Transfer-Encoding; bh=k1z/UPhzOq
	Yyco3Gsorp0u1l/XoQpJwoRHSjatMUSJk=; b=OPlomwb/arBwG6wXdeT/xALVAf
	Np8kohEho6kQy+stbzeWC6eXhWJiVwTtNCs/3Fwdmil1zQSd4BccfIVytQMk2+LT
	V4phaEpFc+rk71hG9rE5miSAs5NuQ0oS6fJ4J4MD30PH4rEmZDb8r0G0xKXWT6PJ
	+WhRfwMT8gRGzkjnI=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkDG7TcQt_VpG0ziAQ--.40690S2;
	Sat, 02 May 2026 16:40:10 +0800 (CST)
From: Zisen Ye <zisenye@stu.xidian.edu.cn>
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
Subject: [PATCH 0/2] smb/client: fix out-of-bounds read
Date: Sat,  2 May 2026 16:34:20 +0800
Message-ID: <20260502083422.2955909-1-zisenye@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkDG7TcQt_VpG0ziAQ--.40690S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYB7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aV
	CY1x0267AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	FIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI
	0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAQUBEGn0w9pVBwAAsD

Zisen Ye (2):
  smb/client: fix out-of-bounds read in smb2_compound_op()
  smb/client: fix out-of-bounds read in symlink_data()

 fs/smb/client/smb2inode.c | 3 +++
 fs/smb/client/smb2misc.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.53.0

