Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1535021ADA4
	for <linux-cifs@vger.kernel.org>; Sat,  2 May 2026 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777715713; cv=none; b=TiNLpLfs6QUTChRJn4OWrN+os3eNIPQiPLINX/yheSG76cs3GsGjqGrHXbs7sFyXX29Hwa5YOBQ7TDhniQLnfftJk7qfuD4+MDAYAQNLLtYAc9Q3mVlMG0rHavfBpHgYAV+Sv2JwNEM/GlBK5g+hTyWlkZm9SMpHdsCfyViMjLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777715713; c=relaxed/simple;
	bh=JfXiqEvHKoEnaCInhzXp7WDEmQxEgFowon3P6ng2NWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kts0h02xKNAsq8neI/dYAhIfDnW5l8CBKKL5JoddrlxHNdFJHTC1WNCbQg0CY+xSvHa3WExOKH4PY9h4QJWivD06V3VmdB6gV8RLnmDlqUOxct8osVBcYTs46a3nj8KBCMueD+12lKUnuHVn5ugmPYcKMlmYgezkysff5G94y9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=mNhJ8fQS reason="key not found in DNS"; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="mNhJ8fQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Transfer-Encoding; bh=mv2IgUg2yt
	bhmBCyB1p37H6wKCI69Z41fPFpoo8M7uU=; b=mNhJ8fQSIFIWYRbnPksgI59FJP
	8+Hl5g731Jb7VVTBy5Sjvbxz1lbUSky+qyoDeSl1H18Gk5oxemS780lmAjgVU7E/
	dxq56sdaEtcxHjtzOubODBSSzuIfYvah4POybSyJaB/7HE/5fFkAQ6AUMBLaxDF4
	XBNWDHbRk5dhKeFtk=
Received: from Jason.localdomain (unknown [113.200.174.116])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkB2ljDcyfVpb3HiAQ--.41180S2;
	Sat, 02 May 2026 17:54:51 +0800 (CST)
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
Subject: [PATCH v2 0/2] smb/client: fix out-of-bounds read
Date: Sat,  2 May 2026 17:54:33 +0800
Message-ID: <20260502095435.2969835-1-zisenye@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkB2ljDcyfVpb3HiAQ--.41180S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYm7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx
	8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7
	AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
	3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIx
	AIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAI
	cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2js
	IEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: ysvqjiqsrsjkus6v33wo0lvxldqovvfxof0/1tbiAQUBEGn0w9pb7wAAsl

v1->v2:
  - Add Fixes tag.
  - Cc stable.

Zisen Ye (2):
  smb/client: fix out-of-bounds read in smb2_compound_op()
  smb/client: fix out-of-bounds read in symlink_data()

 fs/smb/client/smb2inode.c | 3 +++
 fs/smb/client/smb2misc.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.53.0

