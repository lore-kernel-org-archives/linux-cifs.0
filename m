Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C2F352022
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 06:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454146; cv=none; b=fmEfUjbIvAeIMHztAWDNarF2bAbeFaF/y8Rjyk1394Axz0mstlFZTHwnIaE7ektsEPJ+cdkupp0wweIiIFCy74l3rno+Y8CneQUuixgCzjGxKh1D7uSDm+RKDly2/FcU+3ggSDzm2pSS7EJQgLi9oZ3Gsf/i5dy5basNW1LZnro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454146; c=relaxed/simple;
	bh=0fTjX7497KEvfVrU04xOLsNMQBlw82BAkl9B7nftdo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u323i0ZbOW4jg/cpqHKyE6pzbS00S3I/ldk6BFYlfghhIlzPKfb0BByWmNiLE58VeM6WV3TffYEXFUMLgohc34Dq12vB/62LCQhkrYl1muBemyLdeWYPHmdF8X5reFXNRu+TclsxCW017iztyFzKX7eXRPlbU213Y8alCocHz6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=K+qJ3fvD; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="K+qJ3fvD"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0fTjX7497KEvfVrU04xOLsNMQBlw82BAkl9B7nftdo4=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454141; v=1; x=1790058941;
 b=K+qJ3fvDju1JQzz+IFcxQmXRAeY5hFPm2PxN9oAetuJ9C5ws+4M3c1IYeU+buYuF/+AztB9E
 sNiZKSeGN0m+KWW5IwF3ouJLkSrbeg1CBuJkdMUOr2vZqhFubuWQSYQR7eY0oS693/6z/RqoksD
 T5Fj5yD3MMuLURqie3sHJMq1exd6UKTmgp0OqVZ9GgGlsp/SB+Vet9VoY/JZlxX5keGs6ktXUxx
 wxZ0C4bjuSc1cqPESYogWGNYQNSisDCwtIKYuj3zMGY3U6NNoQlDJumCHbkUiez8uOOJyfCzfui
 8u6I7C3R1MBfeJh1M+Cy+0QGTn/kJJasglVfVw0jG5JGQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a4bcc5e80bad12c2;
	Tue, 15 Sep 2026 06:35:41 +0000
X-Mizu-Trace-ID: a4bcc5e80bad12c2
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
Subject: [PATCH cifs-utils 1/2] smbinfo: add filealternatenameinfo subcommand
Date: Tue, 15 Sep 2026 06:34:28 +0000
Message-ID: <20260915063429.110017-2-chenxiaosong@chenxiaosong.com>
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

  1. Mount on Windows 11 Server
  2. touch /mnt/dir/long-file-name
  3. ./smbinfo filealternatenameinfo /mnt/long-file-name
     Alternate Name: LONG-F~1

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 bash-completion/smbinfo |  6 ++++--
 smbinfo                 | 27 +++++++++++++++++++++++++++
 smbinfo.rst             |  2 ++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/bash-completion/smbinfo b/bash-completion/smbinfo
index 3f1f9f6..54e2ff5 100644
--- a/bash-completion/smbinfo
+++ b/bash-completion/smbinfo
@@ -8,6 +8,7 @@ smb_info()
 	OPTS="fileaccessinfo
 	      filealigninfo
 	      fileallinfo
+	      filealternatenameinfo
 	      filebasicinfo
 	      fileeainfo
 	      filefsfullsizeinfo
@@ -30,8 +31,9 @@ smb_info()
 		'-v'|'-h')
 			return 0
 			;;
-		'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filebasicinfo'|'fileeainfo'|\
-		'filefsfullsizeinfo'|'fileinternalinfo'|'filemodeinfo'|'filepositioninfo'|\
+		'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filealternatenameinfo'|\
+		'filebasicinfo'|'fileeainfo'|'filefsfullsizeinfo'|'fileinternalinfo'|\
+		'filemodeinfo'|'filepositioninfo'|\
 		'filestandardinfo'|'filestreaminfo'|'filecompressioninfo'|'fsctl-getobjid'|\
 		'getcompression'|'setcompression'|'list-snapshots'|'quota'|'secdesc'|'keys'|\
 		'gettconinfo'|'notify')
diff --git a/smbinfo b/smbinfo
index 5c1a812..1f1f3c4 100755
--- a/smbinfo
+++ b/smbinfo
@@ -35,6 +35,7 @@ VERBOSE = False
 SMB2_O_INFO_FILE        = 0x01
 
 # QUERY INFO levels
+FILE_ALTERNATE_NAME_INFORMATION  = 21
 FILE_COMPRESSION_INFORMATION     = 28
 
 # ioctl ctl codes
@@ -237,6 +238,10 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_fileallinfo)
 
+    sap = subp.add_parser("filealternatenameinfo", help="Prints FileAlternateNameInfo for a cifs file")
+    sap.add_argument("file")
+    sap.set_defaults(func=cmd_filealternatenameinfo)
+
     sap = subp.add_parser("filebasicinfo", help="Prints FileBasicInfo for a cifs file")
     sap.add_argument("file")
     sap.set_defaults(func=cmd_filebasicinfo)
@@ -435,6 +440,28 @@ def cmd_fileallinfo(args):
     print_filemodeinfo(buf[88:])
     print_filealigninfo(buf[92:])
 
+def cmd_filenameinfo(args, file_info_class, label):
+    qi = QueryInfoStruct(info_type=SMB2_O_INFO_FILE,
+                         file_info_class=file_info_class,
+                         input_buffer_length=INPUT_BUFFER_LENGTH)
+    try:
+        fd = os.open(args.file, os.O_RDONLY)
+        buf = qi.ioctl(fd)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False
+
+    print_filenameinfo(buf, label)
+
+def cmd_filealternatenameinfo(args):
+    return cmd_filenameinfo(args, FILE_ALTERNATE_NAME_INFORMATION,
+                            "Alternate Name")
+
+def print_filenameinfo(buf, label):
+    name_length = struct.unpack_from('<I', buf, 0)[0]
+    name = buf[4:4 + name_length].decode("utf-16le")
+    print("%s: %s"%(label, name))
+
 def win_to_datetime(smb2_time):
     usec = (smb2_time / 10) % 1000000
     sec  = (smb2_time - 116444736000000000) // 10000000
diff --git a/smbinfo.rst b/smbinfo.rst
index 7f5bb4d..8356617 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -51,6 +51,8 @@ COMMAND
 
 `fileallinfo`: Prints the FileAllInformation class
 
+`filealternatenameinfo`: Prints the FileAlternateNameInformation class
+
 `filebasicinfo`: Prints the FileBasicInformation class
 
 `fileeainfo`: Prints the FileEaInformation class
-- 
2.55.0

