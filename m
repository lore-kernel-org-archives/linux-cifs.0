Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1877F10;
	Thu, 26 Dec 2024 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735206027; cv=none; b=i2ejqVWUW8PaKbQwfQHjStpX3kZwr03SaGH4BEOU0ptTZq/KR4HDHZWAD/3ikZtZoSWM8DabOQGDy+CL+Bn/kIAxGAMi3imPcclr18wjhWOrrDhItY/6yzHsPwFAarJ4yEjS/kx4fmH49VrB+MmJ0E9LqM9vdLMSNm2IK8ipDek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735206027; c=relaxed/simple;
	bh=Tihhrhi2Ux00xrX4+kJKYBgLtwpvSFXFTRGw8jfJTAI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BF9tgEx8zjrv3Pu0F3uP+k/Y3ykD5Ql6xDWVgZJgkM2vm3mvMgjZiiOOA+eh7Aa0yj5qLfLl7UptcyoUMssVtxV5FwILX9mqBxmWVOdZ1/s1pEpattIKnitF/w+qGkCQoHIWsqI97HVTY6m5AcsaPA5xSMyBvLC3/ohxRTI/NzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from localhost.localdomain (188.234.32.57) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 26 Dec
 2024 12:25:03 +0300
From: d.privalov <d.privalov@omp.ru>
To: Steve French <sfrench@samba.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>,
	<stable@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>, Steve French
	<stfrench@microsoft.com>, Dmitriy Privalov <d.privalov@omp.ru>
Subject: [PATCH 5.10/5.15 1/1] smb: client: fix use-after-free bug in cifs_debug_data_proc_show()
Date: Thu, 26 Dec 2024 12:25:15 +0300
Message-ID: <20241226092516.43194-1-d.privalov@omp.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 12/26/2024 08:49:16
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 190069 [Dec 26 2024]
X-KSE-AntiSpam-Info: Version: 6.1.1.7
X-KSE-AntiSpam-Info: Envelope from: d.privalov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 49 0.3.49
 28b3b64a43732373258a371bd1554adb2caa23cb
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 188.234.32.57 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 188.234.32.57
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/26/2024 08:52:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 12/26/2024 7:26:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

From: Paulo Alcantara <pc@manguebit.com>

commit d328c09ee9f15ee5a26431f5aad7c9239fa85e62 upstream.

Skip SMB sessions that are being teared down
(e.g. @ses->ses_status == SES_EXITING) in cifs_debug_data_proc_show()
to avoid use-after-free in @ses.

This fixes the following GPF when reading from /proc/fs/cifs/DebugData
while mounting and umounting

  [ 816.251274] general protection fault, probably for non-canonical
  address 0x6b6b6b6b6b6b6d81: 0000 [#1] PREEMPT SMP NOPTI
  ...
  [  816.260138] Call Trace:
  [  816.260329]  <TASK>
  [  816.260499]  ? die_addr+0x36/0x90м
  [  816.260762]  ? exc_general_protection+0x1b3/0x410
  [  816.261126]  ? asm_exc_general_protection+0x26/0x30
  [  816.261502]  ? cifs_debug_tcon+0xbd/0x240 [cifs]
  [  816.261878]  ? cifs_debug_tcon+0xab/0x240 [cifs]
  [  816.262249]  cifs_debug_data_proc_show+0x516/0xdb0 [cifs]
  [  816.262689]  ? seq_read_iter+0x379/0x470
  [  816.262995]  seq_read_iter+0x118/0x470
  [  816.263291]  proc_reg_read_iter+0x53/0x90
  [  816.263596]  ? srso_alias_return_thunk+0x5/0x7f
  [  816.263945]  vfs_read+0x201/0x350
  [  816.264211]  ksys_read+0x75/0x100
  [  816.264472]  do_syscall_64+0x3f/0x90
  [  816.264750]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
  [  816.265135] RIP: 0033:0x7fd5e669d381

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[d.privalov: Adapt checking status ses->ses_status to use global lock GlobalMid_Lock]
Signed-off-by: Dmitriy Privalov <d.privalov@omp.ru>
---
 fs/cifs/cifs_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 53588d7517b4..c094f44fbbde 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -356,6 +356,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		list_for_each(tmp2, &server->smb_ses_list) {
 			ses = list_entry(tmp2, struct cifs_ses,
 					 smb_ses_list);
+			spin_lock(&GlobalMid_Lock);
+			if (ses->status == CifsExiting) {
+				spin_unlock(&GlobalMid_Lock);
+				continue;
+			}
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
 				(ses->serverNOS == NULL)) {
@@ -375,6 +380,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->capabilities, ses->status);
 			}
+			spin_unlock(&GlobalMid_Lock);
 
 			seq_printf(m,"Security type: %s\n",
 				get_security_type_str(server->ops->select_sectype(server, ses->sectype)));
 
-- 
2.34.1

