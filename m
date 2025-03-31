Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145CD1DB12D;
	Mon, 31 Mar 2025 08:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409426; cv=none; b=R1GDqqoquI14KoRUyixmWrFASLrN6j6dZ0srXvbFHnYJf2DDotdmirlNaP8PVAqhq3jSwyL0z2YW3I/wWQUPDMVdax+U+ELK6pbAg34trYcfagsTVuClbRSyMNeGTOykMGsZ7NFugWijN4/pOYUOcGqvCvsz/P/XeZyGeKI1Ygw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409426; c=relaxed/simple;
	bh=6xZI7M/xMltiZq1WTRGYM2XVR9GGLoDnoskC5hcPgWc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dWlpK/kx1QEVG4i9y2KeAI6ZhpJTa7I+0OCC0kGG6MBviUJXSBqkhO+K72Uf1yYe6VdbFX9fh1pOEVIlZqf/h3kMNPvTyWNG44D2iIPxSa0RPSvrN9x0/vAmmh7z9QcoXaXFHA77MYPdFe/QJ7YyReU3WRmSEPGUmUAJqsCJ/y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from inp1wst083.omp.ru (81.22.207.138) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Mon, 31 Mar
 2025 11:23:29 +0300
From: Roman Smirnov <r.smirnov@omp.ru>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>
CC: Roman Smirnov <r.smirnov@omp.ru>, Sachin Prabhu <sprabhu@redhat.com>,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH 2/2] cifs: remove unreachable code in cifs_get_tcp_session()
Date: Mon, 31 Mar 2025 11:22:50 +0300
Message-ID: <20250331082251.123381-3-r.smirnov@omp.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250331082251.123381-1-r.smirnov@omp.ru>
References: <20250331082251.123381-1-r.smirnov@omp.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 03/31/2025 08:06:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 192231 [Mar 31 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: r.smirnov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 51 0.3.51
 68896fb0083a027476849bf400a331a2d5d94398
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 81.22.207.138 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 81.22.207.138 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1;127.0.0.199:7.1.2;inp1wst083.omp.ru:7.1.1;81.22.207.138:7.1.2
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 81.22.207.138
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/31/2025 08:08:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 3/31/2025 5:23:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

echo_interval is checked at mount time, the code has become
unreachable.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
---
 fs/smb/client/connect.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 73f93a35eedd..84efcb541ab2 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1729,12 +1729,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 */
 	tcp_ses->tcpStatus = CifsNew;
 	++tcp_ses->srv_count;
+	tcp_ses->echo_interval = ctx->echo_interval * HZ;
 
-	if (ctx->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
-		ctx->echo_interval <= SMB_ECHO_INTERVAL_MAX)
-		tcp_ses->echo_interval = ctx->echo_interval * HZ;
-	else
-		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
 	if (tcp_ses->rdma) {
 #ifndef CONFIG_CIFS_SMB_DIRECT
 		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
-- 
2.34.1

