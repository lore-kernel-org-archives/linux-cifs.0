Received: from mail.nfschina.com (unknown [42.101.60.213])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 1707D1CBEB8;
	Tue, 15 Oct 2024 10:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728987752; cv=none; b=nVttcaao7xiLA9/jiSqbxRyIFh95qaIcayIoXiJ0Nsp453NjCS7PCwesQGkU+oib2NjqVTA193H/57wvYbMDukoMWif+Bi3sjnaLoFUHPSrhLkUi/BXcw9r3m2ItdwLLeTK94FXg74A8qTRb7WhZ+Uhm+Rzfw3q813IuIRrxX5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728987752; c=relaxed/simple;
	bh=QVTL5sQmDDnJKqDkvjK2WTHHaPiFioRFXt2lcXcPX5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=sMOIcwZme2RZi3D1/tXt13BoyGt12GHNxAvmNiaHyRDqUO2bJDldpvgHWYVQdtxzE1cQylIPxtN56MDA2VMsfiQMWQ6HH1SSJdXue99dTGD8DVWjSs3Jc2QaXosUj7XL1sk+v4QrcqiYQ4EzDlnnIwx4R2lk+4++A56t/pmbtg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id E7CCE6372B51B;
	Tue, 15 Oct 2024 18:22:23 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: dan.carpenter@linaro.org,
	sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	stfrench@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com
Cc: Su Hui <suhui@nfschina.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH v2] smb: client: fix possible double free in smb2_set_ea()
Date: Tue, 15 Oct 2024 18:20:37 +0800
Message-Id: <20241015102036.2882322-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Clang static checker(scan-build) warning：
fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
 1304 |         kfree(ea);
      |         ^~~~~~~~~

There is a double free in such case:
'ea is initialized to NULL' -> 'first successful memory allocation for
ea' -> 'something failed, goto sea_exit' -> 'first memory release for ea'
-> 'goto replay_again' -> 'second goto sea_exit before allocate memory
for ea' -> 'second memory release for ea resulted in double free'.

Re-initialie 'ea' to NULL near to the replay_again label, it can fix this
double free problem.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Signed-off-by: Su Hui <suhui@nfschina.com>
---
v2: 
- Move 'ea = NULL' near to the replay_again label.(Dan's suggestion)

 fs/smb/client/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6b385fce3f2a..24a2aa04a108 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1158,7 +1158,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	unsigned int size[1];
 	void *data[1];
-	struct smb2_file_full_ea_info *ea = NULL;
+	struct smb2_file_full_ea_info *ea;
 	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
 	int retries = 0, cur_sleep = 1;
@@ -1179,6 +1179,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
+	ea = NULL;
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
 	if (!vars) {
-- 
2.30.2

