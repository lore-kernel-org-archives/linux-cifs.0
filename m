Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE62ADDA1
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 08:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="puMPrR9D"
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 895A81A7;
	Wed,  8 Nov 2023 00:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=DNa7L
	H56wAhlEmBNaLTZq2QQGSvrhRVWt0Zl+fK9rmg=; b=puMPrR9DocoGOuh3RNJyi
	QI9b/EnI0/XccNLB68lLhDMUNenoCxugHPnVxXA7Vbm/Scb31SazRcccxdz1S4Ri
	MWZ72Mt3Cl3QMVDkXlSSCEAGuDuhqh7SwP5zMrmqZj/aI36LiH4kpJlyZyRRIz8w
	fnIjmvDD4tsh51sL/4r5i0=
Received: from thinkpadx13gen2i.. (unknown [111.48.58.12])
	by zwqz-smtp-mta-g5-4 (Coremail) with SMTP id _____wDX7o2aQ0tl2c3RAA--.1445S2;
	Wed, 08 Nov 2023 16:15:23 +0800 (CST)
From: Zongmin Zhou <min_halo@163.com>
To: linkinjeon@kernel.org,
	sfrench@samba.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zongmin Zhou <min_halo@163.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Zongmin Zhou <zhouzongmin@kylinos.cn>
Subject: [PATCH] ksmbd: prevent memory leak on error return
Date: Wed,  8 Nov 2023 16:15:02 +0800
Message-Id: <20231108081502.3113828-1-min_halo@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX7o2aQ0tl2c3RAA--.1445S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gw15Gr4UtFyrAryUCr4rXwb_yoWDJFg_CF
	y5Za18Wr98tayDJw15Wr1Yk3saqw4kZFy0gFyftF17Ga1UGr13Grs5Z3s5Xrn3urWkurZx
	GwnrurnxKw17XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRXFxj7UUUUU==
X-Originating-IP: [111.48.58.12]
X-CM-SenderInfo: pplqsxxdorqiywtou0bp/1tbisAMhq2NfyobSowAGs+

When allocated memory for 'new' failed,just return
will cause memory leak of 'ar'.

Fixes: 1819a9042999 ("ksmbd: reorganize ksmbd_iov_pin_rsp()")

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311031837.H3yo7JVl-lkp@intel.com/
Signed-off-by: Zongmin Zhou<zhouzongmin@kylinos.cn>
---
 fs/smb/server/ksmbd_work.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index a2ed441e837a..dbbef686e160 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -123,8 +123,10 @@ static int __ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len,
 		new = krealloc(work->iov,
 			       sizeof(struct kvec) * work->iov_alloc_cnt,
 			       GFP_KERNEL | __GFP_ZERO);
-		if (!new)
+		if (!new) {
+			kfree(ar);
 			return -ENOMEM;
+		}
 		work->iov = new;
 	}
 
-- 
2.34.1

