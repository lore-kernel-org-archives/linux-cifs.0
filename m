Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D943226F2BE;
	Wed,  6 May 2026 03:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778039395; cv=none; b=qxdusf8/IVE3R6bCsFEHxgFmreX0mZF3l45xfhA/aapvaHL8SoAVvsDxxmApcYXM4lytJNiiicmnUSHGjGKD7PNtaso9ID4iTQe2GHeCKTLjHGNv29mhbCU8Aiu7OPPzKnjkoOXS55uCUfeAsZbla384eOCEzhW58Gt3VWKknGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778039395; c=relaxed/simple;
	bh=/puTpr/BaSc+K5SdnzJkBwDREbnRavhd6m1ONmBaDxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YRxXW79aJd4f0bSiwu/LOQqPUd6ziwFzmgW6tRA3VaTMiLnOdntsRUGuJMDtp3wk1leBWHioKQB+ne8obUSCrjyowCtyoo3onWaRW/9OMRbeWqPMzic4GjaUD4wtyMtU957rJIRqGAFEXcQSnHAMD/vcmMK87eHfli7LGQM+BEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=KSiiW4+n reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="KSiiW4+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Transfer-Encoding; bh=MJAN4BLqo0
	78I2UXhcNk6XLL+MI53W5DG/T0ZwayfvY=; b=KSiiW4+nB5cmJEHLlK6y/J6V6s
	J+5+AjWr2/cH8ynWN/5nFHTEZagJwduxdo0j9IGg+O99wuz5Gk1y5uGInHgXcN2x
	otEQQoDsegBcJKchbm6h8Wa1R0LTYbnG4leq9iplzAgLVTw2SCPjaiJTICL8m9aQ
	5g5USpU2KqqMrlAiM=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-4.icoremail.net (Coremail) with SMTP id BrQMCkDGZ7M0uvpp01juAQ--.23165S2;
	Wed, 06 May 2026 11:49:13 +0800 (CST)
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
	gregkh@linuxfoundation.org,
	chenxiaosong@chenxiaosong.com,
	stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 0/1] smb/client: fix out-of-bounds read
Date: Wed,  6 May 2026 11:49:07 +0800
Message-ID: <20260506034908.3874700-1-zisenye@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BrQMCkDGZ7M0uvpp01juAQ--.23165S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYX7k0a2IF6F1UM7kC6x804xWl14x267AK
	xVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
	A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1I
	6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr
	1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY
	62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7V
	C2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4II
	rI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCF04k20xvY0x0EwIxGrwCF54CYxV
	CY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0zED733UUUUU
	=
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAgUFEGn6CWdUJgAAsd

From: Zisen Ye <zisenye@stu.xidian.edu.cn>

v3->v4: in the loop, validate the EA list entries against the constrained OutputBufferLength.

v3: https://lore.kernel.org/linux-cifs/20260503134333.3260640-1-zisenye@stu.xidian.edu.cn/

The following patches from v2 have already been merged into cifs-2.6.git for-next:
  - smb/client: fix out-of-bounds read in symlink_data()

Zisen Ye (1):
  smb/client: fix out-of-bounds read in smb2_compound_op()

 fs/smb/client/smb2inode.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.54.0

