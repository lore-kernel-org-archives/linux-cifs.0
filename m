Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0BB35E1A9;
	Thu,  2 Jul 2026 11:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992008; cv=none; b=Ngb9FJRjMuCUZ86zCq1TE608Icwc2Ql9VZy+3evRRC2aIB0oaqiyqNOOWrQMnBVLkkF+/TWYjzNGK7WVfAqunisuXpsRYovXiIOavlcQjiq/EfQwEOsPPdDw+OhlwkGC1m9K539p9PdC/Ajx5ICGee8S4C9YDvvn6FLPSq/kMIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992008; c=relaxed/simple;
	bh=DSiLEAn5xPmd6cvduTjLn/orcK4idVtMJbh8dY0obRI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ct9iUuF/Gdax7tzt/YNlzG7G4hGe4DEjFg3JwBxTseulIWMt2LNGXeLFdgYnbiw3p7QZviK7NPXFOA9Ez1xshIRRT04DymMPj0FWW4ZVEv52HGjqGQ/VbP7xoYo4SIdXrzELE9FPKq4djokjuEqksbi/WbdNlXffZMXuYSZZiD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ZAw1jAUh; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ZAw1jAUh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782991976;
	bh=vcTdDoubVIbYNczx1/biUey51SEWq1ldwdWLBW13qs8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ZAw1jAUhXhrwxMQiAdRx/X1N41lH8H35oaOgZszN1XTXsWcDJsQaVWq0XBUlS29YR
	 +sEMv5HMgHGSLJbILOZFXaUlRSBbRXmFq/monvdOZQ2CqOW/1gd6XWZevfACC7H6tP
	 3WZTDw8k2opURkEQ7SeHxdSWiRCRsoxp6OPcEodY=
X-QQ-mid: zesmtpsz9t1782991970ta665f6a2
X-QQ-Originating-IP: NOClrfKYjb16CBrXfyUYZuIokmrndgP0NGeZvFRimTo=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 02 Jul 2026 19:32:27 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4999534152803471521
EX-QQ-RecipientCnt: 7
From: Wentao Guan <guanwentao@uniontech.com>
To: linkinjeon@kernel.org
Cc: smfrench@gmail.com,
	tristan@talencesecurity.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Guan <guanwentao@uniontech.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: restore DACL size on check_add_overflow() to avoid malformed ACL
Date: Thu,  2 Jul 2026 19:32:22 +0800
Message-Id: <20260702113222.228413-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OcJU98wqb2KeoOV3oMoLJR0sj3W88Gawa9ODU6AJi/b/TytwkM1igxSV
	vvBDhg0b1Z50EBL33n0lPc1J6wIwOWM0vn2UhFl2ozJt+bMrSFWb5fSZINGoBvoWBrZ6MUp
	L2PQLLXcN4alKP4dmUVm6417x0wrBm83wZwNQxQCAIbd5WE+ynUcYR9sc/Ay/xGAzi3Ssfz
	i8yhZgllcRbAXcM+S+lToh1qnjCpLo+I+mdsrm39zULOzoMFbEEc+jDpPsxnCgDyw1TVLI4
	2xbBF42+3kdUzfuP/ZdLlfaoWA6Ym1nWfXAVekpJr/Q8w+Wp8QTVnOZFmX5iRrIUqV7QHik
	G0Syg4iHs0nf6RNevCY7uInAI+5PcPYGxqUlmXGXeaqFT/+RFGlLgUnrmpgRBRWDiP6G40j
	OHanLe9Lr1zhaqJonCMtXAUtl8m4bE/mmu4lZnuSrJnvpYlKTuHO7N9P7i+iNXu8yW0ZYwl
	tlYXppUDp6t5mkAcBlhhxFewPJ9x7a3t6Lzw/3rBEzqcJ5Qzktka2rvKsPT0CUGAGXu4/jj
	mLX3UrGVczni8g4AEpHA3/3cj0HPEX2XU7Bv0ySwRulQPAP0Hl4GNjdhOV72mWG1C8BLFhx
	1SHlkENPFO24GpPNXSh9puYOP7wWyTJ2wdrRg8izv9m9RfdhgigVPHFCtqAq/xMFQbpp8e/
	Zi6+1JxCAm4nWPGRnukrlNf0AQtvTfE9EcYRNqA4XSJGu6ufFS6QlB9vnHcE4yxAo4BVVFx
	JL91bOKCN/PSpDce3ldNVOmF1E5nnvBbgDMe/s1lqhDle7EwJHi/pK9wQNbO7fGrI5rxkKm
	sSVHuXzcxAMnN4rQRxfBKCSqKZDeq1sT/DCbu72BotXbuYWf03ZwJm76ArHDc6TYUAJL1zh
	hmygS81RH9vZ9GxKQ8H8xulLQ5x33nYzQSPycpJwxJGfx0zvLzBNrPRoP1WUvlXa6QxkkMv
	qgaE1a7wDFOmcxhN8ZRNBH/bbRePbQYvCYNMZ2LjwWpno3e6AKovnNj0664f9FGeG7TC8XY
	1kMyvIqRSKH0AIkaR6Qb3ZrEZzLK8MoSVwXlc2O+J4qwwOeyF1b7dWSpQ6EphNYrDpphtm6
	rS05172Hxjg
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

check_add_overflow() unconditionally writes the truncated sum into *d
even on overflow, per its contract in include/linux/overflow.h.
The four check_add_overflow() guards in set_posix_acl_entries_dacl()
and set_ntacl_dacl() break out of the ACE-building loops on overflow,
but the truncated *size is then consumed downstream at the end of
set_ntacl_dacl():

    pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);

This produces an on-wire NT ACL whose pndacl->size under-reports the
bytes actually written by the preceding fill_ace_for_sid()/memcpy()
calls, yielding a malformed ACL that can trigger out-of-bounds reads
when re-parsed by clients or ksmbd itself.

Restore *size to its pre-addition value on each overflow branch (via
`*size -= ace_sz` / `size -= nt_ace_size`) so that after the break,
*size once again holds the cumulative size of the successfully-written
ACEs. The committed ACL is then truncated-but-self-consistent rather
than malformed.

The ksmbd DACL builders are the only check_add_overflow() sites found
where an overflow path breaks out of a loop and the destination value
is consumed afterward. The other nearby break-style cases either
return -EINVAL on overflow (transport_ipc.c) or break without
consuming the overflowed destination value afterward (buildid.c).

Assisted-by: atomcode:glm-5.2
Assisted-by: Codex:gpt-5.5

Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL size overflow")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
 fs/smb/server/smbacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664b1b4a3233d..943fde8300a01 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -644,6 +644,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
 				pace->e_perm, 0777);
 		if (check_add_overflow(*size, ace_sz, size)) {
+			*size -= ace_sz;
 			kfree(sid);
 			break;
 		}
@@ -658,6 +659,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
 					0x03, pace->e_perm, 0777);
 			if (check_add_overflow(*size, ace_sz, size)) {
+				*size -= ace_sz;
 				kfree(sid);
 				break;
 			}
@@ -703,6 +705,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
 				pace->e_perm, 0777);
 		if (check_add_overflow(*size, ace_sz, size)) {
+			*size -= ace_sz;
 			kfree(sid);
 			break;
 		}
@@ -741,8 +744,10 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 				break;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-			if (check_add_overflow(size, nt_ace_size, &size))
+			if (check_add_overflow(size, nt_ace_size, &size)) {
+				size -= nt_ace_size;
 				break;
+			}
 			aces_size -= nt_ace_size;
 			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
 			num_aces++;
-- 
2.30.2

