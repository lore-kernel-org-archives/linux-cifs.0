Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8771E7C19;
	Tue, 18 Nov 2025 01:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763429600; cv=none; b=dDf1d/7Roa/Ub9wedWcv0WejwzEuuvWGkmF02e3A2JJ7B8qb0P9gy6dKGH7Oo5LpoXMThEYCj8fq3KUmWOY8NWCkMz58cuKw5o2h2sr3MbXpHdfgEV6zbK2fWnglBn1piBYGokSVAHklkUsM5AkOeeIK2cbK7LrcoSVUMlCTnTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763429600; c=relaxed/simple;
	bh=nrD+5LxC6eXKZN39YsA+YUDUtRJnH0Xkjw5N7cZS/nk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FloucbZb7d/raU+pPzNoS9kYTdx53GmquAxMq6W+/TuWyd81Fi+ozA9GMTvH7CJrt/agqG1pmrBh+EUxVdOB/So5gnFBqEzy5ZorUO8uHL9GXKFASa47hVv+jxVKGieYRrpu3PM9AdSYOQFEHL7x9EYPPvBSRaZwVOqY3YLTbsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-01 (Coremail) with SMTP id qwCowABX7czQzBtpCbwbAQ--.20056S2;
	Tue, 18 Nov 2025 09:33:04 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: linkinjeon@kernel.org,
	smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] ksmbd: convert comma to semicolon
Date: Tue, 18 Nov 2025 09:32:29 +0800
Message-Id: <20251118013229.283900-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABX7czQzBtpCbwbAQ--.20056S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4rCw4kuw4kuw1xGrW3ZFb_yoWfZFcEgr
	13Xan7Cr1FqFyFgFs8A3yFyr9Yg34F9r18Jry8tanI9w4Ykrn09rs7tw1kJa13urW3Wr13
	Kr9Igr4SkFy3ujkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1lc2xSY4AK67AK6w4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0x
	ZFpf9x0JUJOz3UUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 03fd7409be79..d699fa79acb6 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -699,7 +699,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	rd.old_parent		= NULL;
 	rd.new_parent		= new_path.dentry;
 	rd.flags		= flags;
-	rd.delegated_inode	= NULL,
+	rd.delegated_inode	= NULL;
 	err = start_renaming_dentry(&rd, lookup_flags, old_child, &new_last);
 	if (err)
 		goto out_drop_write;
-- 
2.25.1

