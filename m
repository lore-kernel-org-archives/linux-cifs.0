Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4611547EA;
	Thu, 22 Aug 2024 08:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315022; cv=none; b=gTaadQ9equKi42zXIMAGJPg0QeajHXast+C1glDRz+GWdw4/YPPKsJejq9O+Ulmt1yy87GdvF/lf3cuGA2wXSswNvyvJ3SJ4ERR0+9dpvHx+t6MoMlfJeOzezZVr3t190jdzPHem8XX3IOQvuMgG+M2e4sjd6zqp0gpmI6z4y5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315022; c=relaxed/simple;
	bh=cggZrPPIPDSdbal5eB+++HPQTvoZGLAhpaMSzC1W9s8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VTkidGz2ZlVPJf6iBC4h9kxO+svtyCy+JxnT+BNSZdx3fL+h85oCp7tKIMbZMJXKXb/pMnI6PB/aFKbGgHCOR3vZgh+TFUjLwphHSINYErcICQckgkklDC+NI8oROS9lPu/o4FEF4BhMpGw9Q7m0pGTFm18ohpdL4hXQNAsF2H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp78t1724314925tygia7b5
X-QQ-Originating-IP: SexwOzBkYBdEkaBF7QUlUdx98Te5uGKGCs6WB38MuxE=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 16:22:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3221063613271520173
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com
Cc: chenxiaosong@kylinos.cn,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	chenxiaosong@chenxiaosong.com
Subject: [PATCH v2 03/12] smb/server: remove useless assignment of 'file_present' in smb2_open()
Date: Thu, 22 Aug 2024 08:20:52 +0000
Message-Id: <20240822082101.391272-4-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The variable is already true here.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 154bc27d1db8..db84c7d0c278 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3093,7 +3093,6 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out;
 		}
 
-		file_present = true;
 		idmap = mnt_idmap(path.mnt);
 	} else {
 		if (rc != -ENOENT)
-- 
2.34.1

