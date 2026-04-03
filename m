Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB4D61B4223
	for <linux-cifs@vger.kernel.org>; Fri,  3 Apr 2026 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775221973; cv=none; b=cHPGl+eBJOIjonw6NvWGrcidG934JlH1exx8cEhAofCzJwGp9/kO8VrpBSusRUg739uXWRC5IlcahKKmFT/FWlrhE4UIDL/H0u4v+e+EqD7mNyuwyclHOvRVst3hPMHAnInrrA0pTFcVqiBNXw/VgmXwrlKpsiSKa5l1Ruh15T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775221973; c=relaxed/simple;
	bh=UnKYD5pjE/ju1IykVnEawDykDVkl1bsXYYIn9AgG6V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGp71z+gERBqy+94T2m0frs3WptkeTWJKkcQV4BmmsGOKN+Z+ZLXQEgQo9TTaFxlhVGBgtsiMajQnWFVMlp9Ha2VHooqDK/WZ0x7OvZ7jzqq7mhc0UITkauGPHn91/OSTqtquEz03wiqUJtOyYiw9edg9F2FNeHGEk1tDR2/7lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn; spf=pass smtp.mailfrom=stu.xidian.edu.cn; dkim=fail (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b=XhnjRuAe reason="key not found in DNS"; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.xidian.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=stu.xidian.edu.cn header.i=@stu.xidian.edu.cn header.b="XhnjRuAe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=CRO8yr7TDYcNtRsjhgqtjtGK9vJ7PYbZcW
	MbP2Nqin4=; b=XhnjRuAeyOOBqd16QUNK0lF1lxMS6CUU9gAEQIP+VHWF/WSt1J
	ZaNCfQsBYHpS0rblkwIEY3+DLPEc73P/Y1qWBFVQz06wTVB+8ndAk3RE2KHskK6J
	NhH7Qs7FH0TewdxEh/e4acmPqvcSkTIrruUlqNQxrxB/fZCbmEKkhZmBk=
Received: from Executor.localdomain (unknown [113.200.174.48])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkDG6DKtvM9pl8MpAQ--.31539S3;
	Fri, 03 Apr 2026 21:12:27 +0800 (CST)
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
Subject: [PATCH v2 1/1] smb/client: avoid null-ptr-deref when tests fail in test_cmp_map()
Date: Fri,  3 Apr 2026 21:12:05 +0800
Message-ID: <20260403131206.4716-2-24031212195@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403131206.4716-1-24031212195@stu.xidian.edu.cn>
References: <20260403131206.4716-1-24031212195@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkDG6DKtvM9pl8MpAQ--.31539S3
X-Coremail-Antispam: 1UD129KBjvdXoWrurW7XrWDXw17JF48Kry8Krg_yoWkuFc_Ar
	1UKwn7ur1UCrnIk3W8Zwsaqr17Jw1UGaykZ3sa9F1YywnrAr9rt3y7Zw4ftws09wn09rW3
	trnagr9akw17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbpxFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
	0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
	x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
	nxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4
	CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvj
	eVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I
	1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	fU8ID2UUUUU
X-CM-SenderInfo: ysuqjiysrsimuv6v33wo0lvxldqovvfxof0/1tbiAQULD2nOiFUSkQACs7

From: SunJianHao <24031212195@stu.xidian.edu.cn>

Use KUNIT_ASSERT_NOT_NULL() to abort the test cases on failure.

Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: SunJianHao <24031212195@stu.xidian.edu.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2maperror_test.c b/fs/smb/client/smb2maperror_test.c
index 8c47dea7a2c1..8c4f168c8e99 100644
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
2.53.0

