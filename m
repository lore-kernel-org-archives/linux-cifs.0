Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A893E5EF8
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.175.55.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775151266; cv=none; b=lkO+1/RtdN6Pg7nt4YzliTZxHV3OhlrOIx/dj3wuo1Npaq465vBwEb5J9Lh6GZJNzg02jkRsprU8/CwuohAMkBMpXDtEfbmZInptXbo/QveoMBcAuAVQ1KCnAMiAg9KllvmbwZMaLsogZhyemQNccKvIVd1jKl0KM6Waxhv38+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775151266; c=relaxed/simple;
	bh=J9nzu6WwttpbR6PgnoqjSe4hNJKJsoTSyAgysQ62oX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eU+oakEenvZ7ybOFQiC7/2ne8fYpphWM+vJXWEluehsu/IzAYe6IjnWpawdjr1l1hHl2cNz6k+EbuZpGc8lncNZ38UhVWQtgBcdax1beN8Rx40PIeDw+lUBS/UAVPHg1ZPELSC1Qv4JZZJ8zHOUdWREGVABbehMDzNjOR7H95NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=0JqPCi3J reason="key not found in DNS"; arc=none smtp.client-ip=52.175.55.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="0JqPCi3J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:MIME-Version:Content-Transfer-Encoding; bh=iFAhU/3kvB
	DswV81uh3RJK5T3Tm2rqUla6Vor4RIdVE=; b=0JqPCi3JKKk11p9vO2srS1uBUW
	63W454jkTUNcARddJEy5bEziitGk6hr5uTOU+hvHox+NI0AOT8leSa2b3Ku49AxG
	u7sG8NlNIKDq4hXMvqlpbQ2oSNUtLP2nVviOUhboywv6PdwWOhnEx1kYg5jSo41A
	Ilj7a4RfiISKhF3No=
Received: from Executor.localdomain (unknown [113.200.174.48])
	by hzbj-edu-front-4.icoremail.net (Coremail) with SMTP id BrQMCkCGK7eAqM5pHdwlAQ--.27365S2;
	Fri, 03 Apr 2026 01:33:53 +0800 (CST)
From: dustball <24031212195@stu.xidian.edu.cn>
To: linux-cifs@vger.kernel.org
Cc: dustball <24031212195@stu.xidian.edu.cn>
Subject: [PATCH 1/1] smb2: maperror: use KUNIT_ASSERT_NOT_NULL instead of KUNIT_EXPECT_PTR_NE with NULL
Date: Fri,  3 Apr 2026 01:33:38 +0800
Message-ID: <20260402173338.11806-1-24031212195@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BrQMCkCGK7eAqM5pHdwlAQ--.27365S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jr1UXr1DGF4rtrWDZF1UZFb_yoWfZwb_AF
	1UKwn7Cr13CrZIkF18AwsavasrJw1xuaykua9Y9FyYywnrAr9Fy347Zan3ta1ruw1Y93y3
	trnagr9Ykr1UWjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbIAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr
	1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7MxkIecxEwVAFwVW8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280
	aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyT
	uYvjfUbvtCUUUUU
X-CM-SenderInfo: ysuqjiysrsimuv6v33wo0lvxldqovvfxof0/1tbiAgULD2nOh+ASGAABsI

Signed-off-by: dustball <24031212195@stu.xidian.edu.cn>
---
 fs/smb/client/smb2maperror_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
index 8c47dea7a..8c4f168c8 100644
--- a/fs/smb/client/smb2maperror_test.c
+++ b/fs/smb/client/smb2maperror_test.c
@@ -21,7 +21,7 @@ test_cmp_map(struct kunit *test, const struct status_to_posix_error *expect)
 	const struct status_to_posix_error *result;
 
 	result = smb2_get_err_map_test(expect->smb2_status);
-	KUNIT_EXPECT_PTR_NE(test, NULL, result);
+	KUNIT_ASSERT_NOT_NULL(test, result);
 	KUNIT_EXPECT_EQ(test, expect->smb2_status, result->smb2_status);
 	KUNIT_EXPECT_EQ(test, expect->posix_error, result->posix_error);
 	KUNIT_EXPECT_STREQ(test, expect->status_string, result->status_string);
-- 
2.43.0

