Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42D540F8C3
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782901535; cv=none; b=vArSTSSYjVSThZlZQqehxEwuQY5G7Q6A5WX2ly0J0XJeQow363ztu4Y2oJvSOC82zPeUGEtsVtBd5zvKXXjjsU8Kx5SzCGjdZ5thYi7wOsbS2NeVaSQ/0ZxWaew6QuqUh9YBNFDPMvNDr6pqIHxz3/a/p1hb3yWDPX/IK5NRw7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782901535; c=relaxed/simple;
	bh=EO4ngrMsVdbhqBqB0CI8DLrC0yDJaUk1yP2yfmLDp30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv7pgCRiD3bZ0spmkPVMtmzeIubAXbOOucr5OC2qRUQtH2dtB59a0ZGrEWQZLob+wPLC0GHS1X+8m73eypWl5KzFmf3icNCcNRq32p+PwdIvJ3eAQ055xn/j7lMHgxNUc4P1EUj5pHin6bXE6t87NtYJFgCP3isrHjf99EdXERY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [123.114.53.210])
	by app1 (Coremail) with SMTP id ygmowABnicOq6kRqaUnOAA--.38360S5;
	Wed, 01 Jul 2026 18:23:53 +0800 (CST)
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
Subject: [PATCH 3/3] smb: client: use unaligned read for POSIX info name length
Date: Wed,  1 Jul 2026 18:23:23 +0800
Message-ID: <d1893e4279c8c53777eeb1bbc018b0bdbb36f471.1782898568.git.xizh2024@lzu.edu.cn>
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
X-CM-TRANSID:ygmowABnicOq6kRqaUnOAA--.38360S5
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1xZFyxXF47JFykZFWDJwb_yoWDCrg_t3
	48uF4kWa4UXFW7Kr1FyFZYvF1avw18GrnxuF1qyFn3CrW5CFW2v3srG3ZxZFZagw45ur45
	WwnrXr95Cry29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbSxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
	wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
	vE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1s
	IEY20_GrWl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUobyZUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQAPCWpEzdUDTgAAs8

From: Zihan Xi <xizh2024@lzu.edu.cn>

posix_info_parse() reads the trailing name length via an aligned le32
cast at beg + total_len. Owner and group SID sizes are variable, so
that offset may be misaligned on strict-alignment architectures.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ed782d219d55..43d514ee555d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5450,7 +5450,7 @@ int posix_info_parse(const void *beg, const void *end,
 	/* check name len */
 	if (beg + total_len + 4 > end)
 		return -1;
-	name_len = le32_to_cpu(*(__le32 *)(beg + total_len));
+	name_len = get_unaligned_le32((u8 *)beg + total_len);
 	if (name_len < 1 || name_len > 0xFFFF)
 		return -1;
 	total_len += 4;
-- 
2.43.0

