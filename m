Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD2F1624C0;
	Thu, 11 Jun 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781193312; cv=none; b=PO/3A/kWDXji8SNTryXbHW0LYLSBrV5mAvozqA/0slj4X/bM/wz1kSEwCyXOWDNKVaAXUJgd2CTTd132zmpPpio/CNDUMT+j9QhI9v0ce8UwakT3Yyf0cwdnsNBzgU/OciM2hDMLfkVF97+IjKL75EOkw07QLs47iCB9/O0xD7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781193312; c=relaxed/simple;
	bh=pJPz4Q++TgGVQ2L6ETh/zhmgiC++tx7flyeXPRWjUCY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tCy0SbjS83/+XBs85UPgbulZCkA24/YbOe1g8shXVdG3vBRrgkhHO8UKaNbo8CIGK4JSZi9Naju8tt6OvqsVhRL+2qO9KvnKZ2Kh48Baz7NBfYEmmKl6QlyuudxVCYqZVjgjCpAfoAtGTQke4FBtXrBtHyi4wEi0Ix4VpUL7VoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.76])
	by APP-05 (Coremail) with SMTP id zQCowAD3Z+tV2ipq2jAZEw--.25771S2;
	Thu, 11 Jun 2026 23:55:02 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] fs/smb/server: fix refcount leak in oplock_break()
Date: Thu, 11 Jun 2026 23:54:59 +0800
Message-ID: <20260611155500.95075-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3Z+tV2ipq2jAZEw--.25771S2
X-Coremail-Antispam: 1UD129KBjvJXoW7trWktr47Kr1DtF1rtrWfAFb_yoW8GFyUpr
	4jy3s0kF45Jw1xZwn8AFWvka1jvw1UC398Crs5Ww17Xr9xXws3Xr4FywnF9rWI9F1fJ34Y
	q3y29w4vv3W8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
	IxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvXd8UUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRAPA2oqzrsjxgAAsF

In oplock_break(), when handling a lease oplock, the breaking_cnt
refcount is incremented with atomic_inc() before calling
oplock_break_pending(). If oplock_break_pending() returns a non-zero
error (1 when another break is already pending, or -ENOENT when the
oplock is closing), the function returns immediately without
decrementing the refcount, leaking a reference. The leak can
eventually lead to resource exhaustion, though in practice it may be
masked by a timeout in wait_lease_breaking().

Fix this by adding an atomic_dec() on the error path before returning
early, restoring the refcount.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 fs/smb/server/oplock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index b193dde4810d..cae756efa8cf 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -898,8 +898,10 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 
 		atomic_inc(&brk_opinfo->breaking_cnt);
 		err = oplock_break_pending(brk_opinfo, req_op_level);
-		if (err)
+		if (err) {
+			atomic_dec(&brk_opinfo->breaking_cnt);
 			return err < 0 ? err : 0;
+		}
 
 		if (brk_opinfo->open_trunc) {
 			/*
-- 
2.50.1 (Apple Git-155)

