Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793620731;
	b=IXS92J87gV8hH1u0NGo428DISBchGwINvJIlgo0ZDoEj9PyAtxCFGsHT0iifC565Et6g
	 fI7UxTfVddjRgbGMV+eymFNljuMGLXBjouTZCZRoteUBnSa3iu32B1sThqlzvqz5nBGUR
	 g1sWjru9Kt7b1LdVz8W3X9ZXAb+b0OGFE+Tfu0Ru3yTcSTLZYS0ta736OGG4nH85x6Vi7
	 RZXJMfXTAVpBWlCSLhHZqnI5iCsTByApvfzvczxDGtBxA45xhgkcEuz7l7Zk00/ijSuCi
	 ZHKoRQ7irJrjL6Hy40aJb8smu7Y2GgClg94t0q1h6h524RoFXh5/S5lUGz1wkTxWOdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793620731;
	h=DMARC-Filter:Received:From:To:Cc:Date:Message-ID:Subject:
	 Content-Type:Content-Transfer-Encoding:MIME-Version:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=oRwmwbjv+isC1HbI/R85XtYwMoWbzthgZOllaE+2e6I=;
	b=FiXZQVaL/eSJBBbkUET6kRUH42crpBaTBNk2s/3o5K+6HC1hOa+1t1mkha/Kv3IUT6Hy
	 dgsNz4efH0usuWyKFSdObSlXUsK+npvjpLO7ghVtgGGDCOfvTsuhh6A50uBgdaiS4DbNN
	 r9HbZCKNAGJmp7XOcBGjs/l4KroRLfwTzp3ccz7v1Ihe897oJbQETZSUI0HlKf6Qp9ayV
	 P6lB7fDudaOchE2RIn66U0uEiUtTvjT4BNcOb54nnASdrlvB3UVOdPedhV1XXiNISAbPP
	 dnGjYpdp0UsqM9kIVXExgLWlUu9xEtTfqF1kQGhl77BhMOuIfT6It1zFPsVd48ZGsxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stu.pku.edu.cn;
	spf=pass smtp.mailfrom=stu.pku.edu.cn;
	dkim=pass header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=FRu6Oq38;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619DC60A3804;
	Mon,  2 Nov 2026 11:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 619DC60A3804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=stu.pku.edu.cn header.i=@stu.pku.edu.cn header.a=rsa-sha256 header.s=default header.b=FRu6Oq38
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa (unknown [1.202.162.49])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5330b2353;
	Mon, 2 Nov 2026 19:58:47 +0800 (GMT+08:00)
From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
To: Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Steve French <stfrench@microsoft.com>, Ronnie Sahlberg <lsahlber@redhat.com>,
 Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 02 Nov 2026 19:58:37 +0800
Message-ID: <179362071772.29269.615878810410303214@stu.pku.edu.cn>
Subject: [PATCH] ksmbd: require NUL-terminated EA names
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-HM-Tid: 0aa19c2056a503a2kunmab045f0fe84f0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSRgdVhlLS0tOGkJDSRlOQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKVUlLSVVKTUlVT0JZV1kWGg8SFR0UWUFZT0tIVUpLSEpMTU
	NVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=FRu6Oq389OA3s5jbhDGrSZf7jv15A5+SkanJhiOD/Qoqqfwglv8/GHWndpsoigsUR6xvfpyIB7FMTFkzSJX9Uaa1EbCD7fKBJfzfgBLYzLRr+5Hctd0NhlQWSYxpKD26rgdV5fgXO5jUqM3mIPRwErfZdcRxU0MAglWDfK89/Ls=; s=default; c=relaxed/relaxed; d=stu.pku.edu.cn; v=1;
	bh=oRwmwbjv+isC1HbI/R85XtYwMoWbzthgZOllaE+2e6I=;
	h=date:mime-version:subject:message-id:from;

smb2_set_ea() verifies that the byte reserved for the declared EA-name
terminator lies inside the request, but it does not verify that the byte is
zero.  With SMB debug logging enabled, the name is passed to %s and the
diagnostic reads beyond the request allocation.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in string
  Read of size 1
  string
  vsnprintf
  _printk
  smb2_set_ea
  smb2_set_info

Reject an EA entry whose declared terminator byte is nonzero.

The patched kernel returns STATUS_INVALID_PARAMETER without a KASAN report.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
---
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5fe3cf8ba328..03c389c0348b8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3419,6 +3419,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, uns=
igned int buf_len,
 		if (!eabuf->EaNameLength)
 			goto next;
=20
+		if (eabuf->name[eabuf->EaNameLength]) {
+			rc =3D -EINVAL;
+			break;
+		}
+
 		ksmbd_debug(SMB,
 			    "name : <%s>, name_len : %u, value_len : %u, next : %u\n",
 			    eabuf->name, eabuf->EaNameLength,
--=20
2.39.5 (Apple Git-154)
