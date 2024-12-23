Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D718182BC
	for <linux-cifs@vger.kernel.org>; Mon, 23 Dec 2024 15:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734968237; cv=none; b=kdjz87mem1vXQcdp/+2gXM9XTf/V9gF5T/0lJHIX8iPEBX4+cxQaV+nAAcCg+dQTKzcmk+zu7FVN221pNgApoImpHR5TIRYb8uyOoz8G9nlgnewwaZIuNL3pJoA8vmaRxUmYB1L7z/YRe9klgXpUOcrmkv14EEpzKmd5UQctZcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734968237; c=relaxed/simple;
	bh=0Yi3Jm176jAS/DeNtn6HzbFjxeU9/1nCs3h5jLVsq/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dl1zL25O83SC9gXX7i+8aZRYU2Cy+vHykquyma6fw1slHMg3CpVptqQXhgFca3hI6RLub/hSk8XI3qvzMLqzcBh3rmCQeVXv/1MX3eNj/xSS4l2VY7AtfysGtEzGtfEfMUusjuAOUM/FeQ7uKBZhsxqRO8RY1KMs762WwSsefo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-05 (Coremail) with SMTP id zQCowAA3F9BYgmlnsKltAw--.22233S2;
	Mon, 23 Dec 2024 23:31:42 +0800 (CST)
From: Wentao Liang <liangwentao@iscas.ac.cn>
To: stfrench@microsoft.com,
	linkinjeon@kernel.org,
	chenxiaosong@kylinos.cn,
	thorsten.blum@linux.dev
Cc: liangwentao@iscas.ac.cn,
	linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: fix a missing return value check bug
Date: Mon, 23 Dec 2024 23:30:50 +0800
Message-ID: <20241223153050.332-1-liangwentao@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3F9BYgmlnsKltAw--.22233S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WrWkuFy7Ar4rGrWkKryfJFb_yoW8JF4Dpr
	4YgFy0kws8Xw1xGr4DJry5uw1Yk3yjgr1jkrsFvwnF9rZ3Jw1Uu3Wkt3Z0g395Ca1rGa1I
	vw4jv3y29as5AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU8miiUUUUU
X-CM-SenderInfo: xold0wxzhq3t3r6l2u1dvotugofq/

In the smb2_send_interim_resp(), if ksmbd_alloc_work_struct()
fails to allocate a node, it returns a NULL pointer to the
in_work pointer. This can lead to an illegal memory write of
in_work->response_buf when allocate_interim_rsp_buf() attempts
to perform a kzalloc() on it.

To address this issue, incorporating a check for the return
value of ksmbd_alloc_work_struct() ensures that the function
returns immediately upon allocation failure, thereby preventing
the aforementioned illegal memory access.

Fixes: 041bba4414cd ("ksmbd: fix wrong interim response on compound")
Signed-off-by: Wentao Liang <liangwentao@iscas.ac.cn>
---
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 599118aed205..6683ed3b7f18 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -695,6 +695,9 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	struct smb2_hdr *rsp_hdr;
 	struct ksmbd_work *in_work = ksmbd_alloc_work_struct();
 
+	if (!in_work)
+		return;
+
 	if (allocate_interim_rsp_buf(in_work)) {
 		pr_err("smb_allocate_rsp_buf failed!\n");
 		ksmbd_free_work_struct(in_work);
-- 
2.42.0.windows.2

