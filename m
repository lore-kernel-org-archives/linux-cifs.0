Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F8D37B00E
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 02:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232473; cv=none; b=Q6gBUo8wDiSiLf/6NK6x9OLv63ZLEq2ap6C+nNCxJn2+R/yU3Yx2i01HLo0n/o3/g3+k1YuxlEs0if2cQa+9IG0gafw8kLu0lB7bTx/z1ycW6wLd4ekq04cFnOMkIHrCh2ias/tDV2bEptZRPQ3bJRaUmuB4r5qD8ybdgAGANeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232473; c=relaxed/simple;
	bh=sKy/CzzrUlP//g0pbFsi+xEpmvcQwVNHzV+uDHju8u0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TPMSANURAZPGX6/+VLMw3MlxxOQpzOWNX9plHg5+v20txSZAmSzUuPE7Sn2xqkAcWgZdogW2mTROVGYBNJV7iXVnFu5Kq/PIyPM8dgJkIthdGg6/+INtRhBWcUwT5E8qUnY1ryw0SdB6BJMPLMVAm59QJj9KOvk0U7iWCPSJDn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=bIacbeel; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="bIacbeel"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781232466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Qn5qakCqPMw0n60pmBTZBd94TIMNJIaujYX3w6mf1D8=;
	b=bIacbeelA/+pIr4e/M0uAADEcZKlXMgd/LmkJD8G8GbIfkvR5kA9lROOoJeay9tej/NYhX
	1zLFI7zuzLvbRrwu3k/GmQla0yTcudogq93S4wZ9RSGdfr0WygmOAdVcSvcg85OB6OTXnC
	hfUfYYsapGREMRyCpzkjBz9GXszl8yte5GOGuFjtjgjnpypdvxdcbr0zaknmR2JwRwxRSk
	CZk5EuF0PuaXCQ+WDrMYpqxNZVUq5TfcrmAnkhQN0bPa2WVKSrBjeoW8Nm5dcys89vjNb5
	1aaNCWxVBuyzUlG/1anF2FwNtfsJpEiVZkwD5IZjr8NMpUNBQ2TAmsqIcTo7XA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH cifs-utils] smbinfo: update notify subcommand
Date: Fri, 12 Jun 2026 02:46:47 +0000
Message-ID: <20260612024647.656382-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add the `notify` subcommand to bash-completion.

Fix the following warning:

  ./smbinfo:963: SyntaxWarning: 'return' in a 'finally' block
    return False

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 bash-completion/smbinfo | 5 +++--
 smbinfo                 | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/bash-completion/smbinfo b/bash-completion/smbinfo
index 52e6821..3f1f9f6 100644
--- a/bash-completion/smbinfo
+++ b/bash-completion/smbinfo
@@ -24,7 +24,8 @@ smb_info()
 	      quota
 	      secdesc
 	      keys
-	      gettconinfo"
+	      gettconinfo
+	      notify"
 	case $prev in
 		'-v'|'-h')
 			return 0
@@ -33,7 +34,7 @@ smb_info()
 		'filefsfullsizeinfo'|'fileinternalinfo'|'filemodeinfo'|'filepositioninfo'|\
 		'filestandardinfo'|'filestreaminfo'|'filecompressioninfo'|'fsctl-getobjid'|\
 		'getcompression'|'setcompression'|'list-snapshots'|'quota'|'secdesc'|'keys'|\
-		'gettconinfo')
+		'gettconinfo'|'notify')
 			local IFS=$'\n'
 			compopt -o filenames
 			COMPREPLY=( $(compgen -f -o dirnames -- ${cur:-""}) )
diff --git a/smbinfo b/smbinfo
index a6095e1..d6c30f1 100755
--- a/smbinfo
+++ b/smbinfo
@@ -306,7 +306,7 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_gettconinfo)
 
-    sap = subp.add_parser("notify", help="Query a directory for change notifications")
+    sap = subp.add_parser("notify", help="Query a directory for change notifications. Press Ctrl+C to exit.")
     sap.add_argument("file")
     sap.set_defaults(func=cmd_notify)
 
@@ -960,7 +960,6 @@ def cmd_notify(args):
         pass
     finally:
         os.close(fd)
-        return False
 
 def notify_thread(fd):
     fmt = "<IBI"
-- 
2.54.0

