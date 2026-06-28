Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFC0221FCD
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 09:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782638437; cv=none; b=mUcuHGeKPrmTj4g0maAaz7OuGlFJlbpnfmLk32jMv88Y66uV4OycX3rw5ZpstY5VCdxpQCTlUF4tQ9x2tDqqjg1WNAFzY4WQWfwqkvG8I/f3SPpGOEtUpsKPzkFM/Xh7MfB1gdCOtQsI/2203wvF/Y+G1oaa3nKlHDVC1Q8BGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782638437; c=relaxed/simple;
	bh=qL8yXWJzjVUwWdde9mIOnKMt/Uo6Bus2ZpzsmPumGls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsW1Kk423mT3VpCRWloh0gsa3C4uDY9LFDLSnQAzCMePjQE3fU0Mxq/uCjUYYz6YDnk7J6MLRV/xJ29zMTnVm+gfE+3AfBIO7UGLWqnP7WoICjiNf2858cAg9Qsv7s9Jn3rmHsPkelr8MKCd453DoPp7sOyVUPKSIlmoTGm5kfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAC31L4t50BqTo2+AA--.53613S4;
	Sun, 28 Jun 2026 17:19:49 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilov@microsoft.com,
	aaptel@suse.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	xizh2024@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH 2/2] smb: client: harden POSIX SID length parsing
Date: Sun, 28 Jun 2026 17:19:24 +0800
Message-ID: <742ae249b35c898a2c4f3d08489658a24c04306d.1782579150.git.xizh2024@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782579149.git.xizh2024@lzu.edu.cn>
References: <cover.1782579149.git.xizh2024@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAC31L4t50BqTo2+AA--.53613S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1xCFWDJF47ur18try8AFb_yoWktrg_Xa
	48ua1ku3yUZFsFyw1qvFsYgF17Za1rJFs5Zw1UJ3Z7Aw4UCrZav3yDWanIqF1Igr4xurZ8
	GwnrW3Z8Kry3ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfkFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
	wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
	vE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8V
	W8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsMCWpA2VUAlQAAs8

From: Zihan Xi <xizh2024@lzu.edu.cn>

posix_info_sid_size() reads sid[1] to obtain the subauthority count,
but its existing boundary check still accepts buffers with only one
remaining byte. Require two bytes before reading sid[1] so all client
paths that reuse the helper reject truncated POSIX SIDs safely.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 840bc81718da..de990df52455 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5385,7 +5385,7 @@ int posix_info_sid_size(const void *beg, const void *end)
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);
-- 
2.43.0

