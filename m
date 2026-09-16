Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3D15E8B;
	Wed, 16 Sep 2026 07:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789542086; cv=none; b=pgXvIR4lhz0DS892KGWlhWX4jSDl4f8Aj/Y/IMq8MCHoy0J/NLnOSeYjwnLWL7k1vBKCalxqH4nsbF/BobBGhAl0Q6iaGrYwejWnengH3dBQR/wE6H0UoZUrYD302icHuDBJdkbARQ396JUd5BhCxfUZnyRxFPN9i3XNHVTr298=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789542086; c=relaxed/simple;
	bh=pmLEoq9TBqrQ0DOPtgGuj1Al3Q4bHVrpXpLGR414To8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XwsHse1uKlJII12336LfS7vzNNQi+dqgb2grTZjfVjilwEUvALvotcKzwtlkq0Q6CgvWrpIefKYvOWerqSP0Da01vXr8Uug0HnTf4OKScsPvP+dVBDH8ruefpI6ANWedRs90uYWTu6y5881rGU8X2UG5wpycsG6oU4QfBDZomNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADX4D6pPqpqBN3eBw--.40275S2;
	Wed, 16 Sep 2026 15:00:57 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	pshilov@microsoft.com,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	sprasad@microsoft.com,
	tom@talpey.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 01/20] cifs: Fix MID entry leak in receive_encrypted_standard()
Date: Wed, 16 Sep 2026 07:00:29 +0000
Message-Id: <20260916070029.1965124-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADX4D6pPqpqBN3eBw--.40275S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFWrWw43uFW8Kw4Dtw13Arb_yoWDurg_Jr
	18Zr18Xry5JFnFkw12yr10qrW3Cw4rA3y09a1qyFs8Aay5Ar43t3srJ3Z5Jr4xurZaqrZ5
	CwsF9398uFn3WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUKdgAUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMMA2qqBo7c1QACsW

In receive_encrypted_standard(), mid_entry is obtained from
smb2_find_mid(). When the compound PDU count exceeds MAX_COMPOUND,
the function returns -1 without releasing the acquired mid_entry
reference, resulting in a resource leak.

Release the mid_entry before returning error when *num_mids exceeds
MAX_COMPOUND.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/smb/client/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 61b60114e4b8..7208f6c84e34 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5122,6 +5122,8 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");
+		if (mid_entry)
+			release_mid(server, mid_entry);
 		return -1;
 	}
 	bufs[*num_mids] = buf;
-- 
2.34.1

