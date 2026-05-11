Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA9394471;
	Mon, 11 May 2026 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778505515; cv=none; b=DYSKryORyStFXQl7RMn336OR7SM8lwMl9uHn8i0ZxYs/1h2FiCr8iID9ANuQSvqqUjAC+brGR7gyb5To3m8QMXBkrSc7eod5viRt0dvpUMu8nKA1/YupTpHlQoAWdFxIrNBZfzfUcLNjWKedPHgfcPcErW7FDSH1kMeUBRGCaGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778505515; c=relaxed/simple;
	bh=tSxu3v1zFVmz1Ow1glgROXhvIIbM5P+KMcZs43VSTrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bHdGz27IbQupPfYauEGCefjz/ayIuF823R0g+JYozcMSjaVHy/mqQr84g0AEoioAzCjNxPpQo5n6Nhgqt1LCLaIeSvaZqkH4QlO0i1WzoxUXG2WV1kiVSadQTnzQRnCCX6dOGG0/oIvZs3mrY6ky77r3nBIGYLlRzTX7NqzRiCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ITKhP3HM; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ITKhP3HM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778505506; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=qMTukbhOsh4wTjLAvEST29FKEUGQSBkjs6AvGD3bNxM=;
	b=ITKhP3HM+6/6dIioCD3Y4siAI3nDphv/tA1FBQrQWZ51ednKoLEjKlMN0yluNOKkN8U0AEIT25VeVe/aOw6L9FB2IPLSw0X2rHrKwyXXLz44Pfr3zUOUBjzgIUV4xMXzzOzCEbP8EBBAAWBahKSLKQSK04fdHIDGRktY3ZxhTw0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X2kmh0a_1778505499;
Received: from localhost(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0X2kmh0a_1778505499 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 May 2026 21:18:26 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH] ksmbd: fix SID memory leak in set_posix_acl_entries_dacl() on overflow
Date: Mon, 11 May 2026 21:18:16 +0800
Message-Id: <20260511131816.93314-1-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16
DACL size overflow") added check_add_overflow() guards that break out
of the ACE-building loops in set_posix_acl_entries_dacl() when the
accumulated DACL size would wrap past 65535.

However, each iteration allocates a struct smb_sid via kmalloc_obj()
at the top of the loop and relies on the kfree(sid) call at the end
of the loop body (the 'pass_same_sid' label in the first loop, and
the explicit kfree at the tail of the second loop) to release it.
The newly introduced 'break' statements bypass those kfree() calls,
leaking the sid buffer every time an overflow is detected.

A malicious or malformed file with enough POSIX ACL entries to trip
the overflow check will leak one or more struct smb_sid allocations
on every request that touches the file's DACL, providing a trivial
kernel memory exhaustion vector.

Free sid before breaking out of the loops to plug the leak.

Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL size overflow")
Cc: stable@vger.kernel.org
Signed-off-by: Ferry Meng <mengferry@linux.alibaba.com>
---
 fs/smb/server/smbacl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c1d1f34581d6..9161e9d7ed24 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -643,8 +643,10 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		ntace = (struct smb_ace *)((char *)pndace + *size);
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
 				pace->e_perm, 0777);
-		if (check_add_overflow(*size, ace_sz, size))
+		if (check_add_overflow(*size, ace_sz, size)) {
+			kfree(sid);
 			break;
+		}
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
 			ntace->access_req |=
@@ -655,8 +657,10 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 			ntace = (struct smb_ace *)((char *)pndace + *size);
 			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
 					0x03, pace->e_perm, 0777);
-			if (check_add_overflow(*size, ace_sz, size))
+			if (check_add_overflow(*size, ace_sz, size)) {
+				kfree(sid);
 				break;
+			}
 			(*num_aces)++;
 			if (pace->e_tag == ACL_USER)
 				ntace->access_req |=
@@ -698,8 +702,10 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		ntace = (struct smb_ace *)((char *)pndace + *size);
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
 				pace->e_perm, 0777);
-		if (check_add_overflow(*size, ace_sz, size))
+		if (check_add_overflow(*size, ace_sz, size)) {
+			kfree(sid);
 			break;
+		}
 		(*num_aces)++;
 		if (pace->e_tag == ACL_USER)
 			ntace->access_req |=
-- 
2.43.5

