Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5EE31D371
	for <linux-cifs@vger.kernel.org>; Fri,  3 Apr 2026 13:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775221972; cv=none; b=J35zUSNnLHwgNLpnCHbqKXcfedV+Rd8eYXrTWQhZ0YHp9uvdUCQj24Jl69L/iYCaSse0JNPmwdVfHXXSrp3VxBLCP4TLUICu5WMGRO9EMMQYsI1QJLPsYrP4i8v4rAcSA+aJq3cpr6VWL3OQTwrlQJ+w8tBP/IoNznw0++yzfgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775221972; c=relaxed/simple;
	bh=sCCAepdUJ7e4fWVB3JUZ3XT3//bzAVxaVbp0t8658vg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ta+dc9nkCZrwJm+N3MUSLDoh3QVtWKhSlR3ZcMkXqeMSGbTLKvLyNOp2oOy2/LdU1fW3gnxu/btv0YYBX2/1pNcv8zGJhr/KUDJaXGDerxMn11i0vqylWnig3nWZTKVbPij3xmGq1ZnrcWjixsjFXkdHJlBfLyNj+urz1/XH4F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=muERYRwd reason="key not found in DNS"; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="muERYRwd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Transfer-Encoding; bh=7nnGRHqwI9
	fcSAlH3w4X2ft4twtt+NMN8iiuqmtEx7o=; b=muERYRwdkFSVUeLJPwxnCbPPOA
	kB7iSgRE8pnUT7XBUdK8Us/BYb8vb2VJXwMBEakyNkUYyuhRGrXyzG7D+hofNk5R
	jovFqEZSYtfR8F8cqDIDCft/KKlkaGl45PRqTJiLdjk9gGExSL2UQ0ICfdzuG4M8
	Mpr5NjNOJIiIa7pAI=
Received: from Executor.localdomain (unknown [113.200.174.48])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkDG6DKtvM9pl8MpAQ--.31539S2;
	Fri, 03 Apr 2026 21:12:15 +0800 (CST)
From: dustball <24031212195@stu.xidian.edu.cn>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	SunJianHao <24031212195@stu.xidian.edu.cn>
Subject: [PATCH v2 0/1] smb/client: avoid null-ptr-deref when tests fail in test_cmp_map()
Date: Fri,  3 Apr 2026 21:12:04 +0800
Message-ID: <20260403131206.4716-1-24031212195@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkDG6DKtvM9pl8MpAQ--.31539S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY_7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26r4UJVWxJr1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28I
	cVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx
	0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwAC
	jI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
	vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuY
	vjfUOlksUUUUU
X-CM-SenderInfo: ysuqjiysrsimuv6v33wo0lvxldqovvfxof0/1tbiAgUMD2nOh+CjiwAAss

From: SunJianHao <24031212195@stu.xidian.edu.cn>

v1->v2: Update the patch description

v1: smb2: maperror: use KUNIT_ASSERT_NOT_NULL instead of KUNIT_EXPECT_PTR_NE with NULL: https://lore.kernel.org/linux-cifs/20260402173338.11806-1-24031212195@stu.xidian.edu.cn/

SunJianHao (1):
  smb/client: avoid null-ptr-deref when tests fail in test_cmp_map()

 fs/smb/client/smb2maperror_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.53.0

