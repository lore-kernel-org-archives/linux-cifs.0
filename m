Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99169374A19
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454152; cv=none; b=hqEk45JPPTAz+ZdkogYa5FVlH1675uynlXNRfPNe98qOzy2Jfojvs0TxlY9UQoTGlnbmgMumVXUPF6wJQ8J/dp74UaPdhRmiwTSCkEi+TdjWxYWWAZYgSy/Mig7zv3PqDvejQ+NQ0IVInYAY/ovsrFq0T5B4xoPB/LQyWnXqEwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454152; c=relaxed/simple;
	bh=PEwV3rhL5ayNbgbZJc6/4DE2Pz03Jju++A8OhlXMZYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtkHeeAqr5vBvkxgOXQrSlKSAgvTWOD7BE/uZi/HX15/lEWQyAyqXpmVFt+9XN3MPvfZuMH7BCQsl20oiVcjH7D60KPgUbQAEhnjiaSYJSKDyClKHYa6Zc205jzVOCwFmQQ9aEfVBEk+oxdVgvH6ZT50ehQP6/aS4V8zhmKHlNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=LjlDz/au; arc=none smtp.client-ip=91.218.175.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="LjlDz/au"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PEwV3rhL5ayNbgbZJc6/4DE2Pz03Jju++A8OhlXMZYM=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454146; v=1; x=1790058946;
 b=LjlDz/au3f1XxhnQRCp/G6MUlHw+vwehdCtk3E2iPAoL9mdEGw31j7ivTC+Xq/mHTF8ZB/lQ
 uDBdmZC3WjRMnxWXJ+ek/Opblr9DS32to5ObQyox1o/3RnJ3bQO9XQ4Nqa8zaRELgS0ApJIg0Hn
 j4eWS9jHf+/fP3U2fVS3EpUJVK+5xOnd1YFvhEeecEfiipGWerK3SrXjKeayovSRbfs9SRVHrwK
 qGV/XxATooJFSV/YG1IibnT45n1xD/BrLJUj5s5GxVeD3mZ2aH+z5BYKDlJqZd0MxpQ0EwT3LoD
 7CW+p2B07elel2zmttu2infRAxXGR+u1XMlgvTFd+EYjw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 923ead984aaa781e;
	Tue, 15 Sep 2026 06:35:46 +0000
X-Mizu-Trace-ID: 923ead984aaa781e
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	metze@samba.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH cifs-utils 2/2] smbinfo: add filenormalizednameinfo subcommand
Date: Tue, 15 Sep 2026 06:34:29 +0000
Message-ID: <20260915063429.110017-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915063429.110017-1-chenxiaosong@chenxiaosong.com>
References: <20260915063429.110017-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Example:

  1. touch /mnt/dir/long-file-name
  2. ./smbinfo filenormalizednameinfo /mnt/dir/long-file-name
     Normalized Name: dir\long-file-name

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 bash-completion/smbinfo | 3 ++-
 smbinfo                 | 9 +++++++++
 smbinfo.rst             | 2 ++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/bash-completion/smbinfo b/bash-completion/smbinfo
index 54e2ff5..06478c6 100644
--- a/bash-completion/smbinfo
+++ b/bash-completion/smbinfo
@@ -14,6 +14,7 @@ smb_info()
 	      filefsfullsizeinfo
 	      fileinternalinfo
 	      filemodeinfo
+	      filenormalizednameinfo
 	      filepositioninfo
 	      filestandardinfo
 	      filestreaminfo
@@ -33,7 +34,7 @@ smb_info()
 			;;
 		'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filealternatenameinfo'|\
 		'filebasicinfo'|'fileeainfo'|'filefsfullsizeinfo'|'fileinternalinfo'|\
-		'filemodeinfo'|'filepositioninfo'|\
+		'filemodeinfo'|'filenormalizednameinfo'|'filepositioninfo'|\
 		'filestandardinfo'|'filestreaminfo'|'filecompressioninfo'|'fsctl-getobjid'|\
 		'getcompression'|'setcompression'|'list-snapshots'|'quota'|'secdesc'|'keys'|\
 		'gettconinfo'|'notify')
diff --git a/smbinfo b/smbinfo
index 1f1f3c4..f9a8c4d 100755
--- a/smbinfo
+++ b/smbinfo
@@ -37,6 +37,7 @@ SMB2_O_INFO_FILE        = 0x01
 # QUERY INFO levels
 FILE_ALTERNATE_NAME_INFORMATION  = 21
 FILE_COMPRESSION_INFORMATION     = 28
+FILE_NORMALIZED_NAME_INFORMATION = 48
 
 # ioctl ctl codes
 CIFS_QUERY_INFO          = 0xc018cf07
@@ -262,6 +263,10 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_filemodeinfo)
 
+    sap = subp.add_parser("filenormalizednameinfo", help="Prints FileNormalizedNameInfo for a cifs file")
+    sap.add_argument("file")
+    sap.set_defaults(func=cmd_filenormalizednameinfo)
+
     sap = subp.add_parser("filepositioninfo", help="Prints FilePositionInfo for a cifs file")
     sap.add_argument("file")
     sap.set_defaults(func=cmd_filepositioninfo)
@@ -457,6 +462,10 @@ def cmd_filealternatenameinfo(args):
     return cmd_filenameinfo(args, FILE_ALTERNATE_NAME_INFORMATION,
                             "Alternate Name")
 
+def cmd_filenormalizednameinfo(args):
+    return cmd_filenameinfo(args, FILE_NORMALIZED_NAME_INFORMATION,
+                            "Normalized Name")
+
 def print_filenameinfo(buf, label):
     name_length = struct.unpack_from('<I', buf, 0)[0]
     name = buf[4:4 + name_length].decode("utf-16le")
diff --git a/smbinfo.rst b/smbinfo.rst
index 8356617..7aa3ecd 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -63,6 +63,8 @@ COMMAND
 
 `filemodeinfo`: Prints the FileModeInformation class
 
+`filenormalizednameinfo`: Prints the FileNormalizedNameInformation class
+
 `filepositioninfo`: Prints the FilePositionInformation class
 
 `filestandardinfo`: Prints the FileStandardInformation class
-- 
2.55.0

