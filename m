Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE7C2E7399
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 09:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780910923; cv=none; b=W6zgsXJ51yX1zAJkm+nEHHFJ+1956n0aIxbZkNEn9HURM/5aKJBg/Ubb5V9XzH9Kuk6kz3H3mVTYrhIxRf/HGjpsp6DFzrbXbNS5ivlYX2BlcbUirJ8EC9WaqNxWQnMFrAGNB7EbtbRK1yadSg8kig8yIWQ8SuOh15zmAhl2Br8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780910923; c=relaxed/simple;
	bh=Omrh3T77Z7qONtzuf7ZDFbyIwhecvcKXFbyKejon7u0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EfA58r9MT8ZWfz4tasATt/ix5CVpFemcAnxIwDa9JWSPJU08pYFwdiVMsdoL/XeDdqPoNJRKMKmFIpMiIL24N08fSWYXBgOszTgXa2Bzw+u+ffTgcr+m9VfAM3rFPr16J/guFd4yMjjsDyd9G2El+WzzDONl7DNpqes6M/Qghc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=WYymBdFS; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="WYymBdFS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780910917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fy6A0wJ3rYooVYdnQVtAoNTY7FseGJ33vfHaX14XBBc=;
	b=WYymBdFS7lWQDE52UrzF/0l5f4n12fFx4kgR39GwIIcylyqxQWI8a3jRY9Aj8QQB45fQ4J
	E3z/GbezjUqh69uJr8587fvYGD3pdCGwyC75+HSiwJddef7MMZt9PMKp+B5nmLmkHkNLJn
	wDOp/PDQ3dmNXcs5AqhvrN85j80qY3Pl6Elrpc44t3BgF2va3NPM608YN6d9TuDPl69hkU
	nrDFNodIgN0+UoreRKfOqIVX106oZrbrXufLf/hv+ptEysVjrIBLRjcjnbCu79idStrj0V
	UHFMFntqOIK/YJhKfeJ6O1+aAivKEvchIAkQCvbUWYDAaS05+jgKo574zfybRQ==
From: chenxiaosong@chenxiaosong.com
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH cifs-utils] smbinfo: add filecompressioninfo subcommand
Date: Mon,  8 Jun 2026 09:27:36 +0000
Message-ID: <20260608092736.349257-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Example:

  ./smbinfo filecompressioninfo /mnt/file
  Compressed File Size: 104857600
  Compression Format: 2 (LZNT1)
  Compression Unit Shift: 0
  Chunk Shift: 0
  Cluster Shift: 0

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 bash-completion/smbinfo |  9 ++++++---
 smbinfo                 | 33 +++++++++++++++++++++++++++++++++
 smbinfo.rst             |  2 ++
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/bash-completion/smbinfo b/bash-completion/smbinfo
index ec0d8a4..52e6821 100644
--- a/bash-completion/smbinfo
+++ b/bash-completion/smbinfo
@@ -16,6 +16,7 @@ smb_info()
 	      filepositioninfo
 	      filestandardinfo
 	      filestreaminfo
+	      filecompressioninfo
 	      fsctl-getobjid
 	      getcompression
 	      setcompression
@@ -28,9 +29,11 @@ smb_info()
 		'-v'|'-h')
 			return 0
 			;;
-		'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filebasicinfo'|'fileeainfo'|'filefsfullsizeinfo'|\
-		'fileinternalinfo'|'filemodeinfo'|'filepositioninfo'|'filestandardinfo'|'filestreaminfo'|'fsctl-getobjid'|\
-		'getcompression'|'setcompression'|'list-snapshots'|'quota'|'secdesc'|'keys'|'gettconinfo')
+		'fileaccessinfo'|'filealigninfo'|'fileallinfo'|'filebasicinfo'|'fileeainfo'|\
+		'filefsfullsizeinfo'|'fileinternalinfo'|'filemodeinfo'|'filepositioninfo'|\
+		'filestandardinfo'|'filestreaminfo'|'filecompressioninfo'|'fsctl-getobjid'|\
+		'getcompression'|'setcompression'|'list-snapshots'|'quota'|'secdesc'|'keys'|\
+		'gettconinfo')
 			local IFS=$'\n'
 			compopt -o filenames
 			COMPREPLY=( $(compgen -f -o dirnames -- ${cur:-""}) )
diff --git a/smbinfo b/smbinfo
index a168186..a6095e1 100755
--- a/smbinfo
+++ b/smbinfo
@@ -31,6 +31,12 @@ import threading
 
 VERBOSE = False
 
+# InfoType values
+SMB2_O_INFO_FILE        = 0x01
+
+# QUERY INFO levels
+FILE_COMPRESSION_INFORMATION     = 28
+
 # ioctl ctl codes
 CIFS_QUERY_INFO          = 0xc018cf07
 CIFS_ENUMERATE_SNAPSHOTS = 0x800ccf06
@@ -263,6 +269,10 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_filestreaminfo)
 
+    sap = subp.add_parser("filecompressioninfo", help="Prints FileCompressionInfo for a cifs file")
+    sap.add_argument("file")
+    sap.set_defaults(func=cmd_filecompressioninfo)
+
     sap = subp.add_parser("fsctl-getobjid", help="Prints the objectid of the file and GUID of the underlying volume.")
     sap.add_argument("file")
     sap.set_defaults(func=cmd_fsctl_getobjid)
@@ -809,6 +819,29 @@ def print_filestreaminfo(buf):
 
         offset+=next_offset
 
+def cmd_filecompressioninfo(args):
+    qi = QueryInfoStruct(info_type=SMB2_O_INFO_FILE,
+                         file_info_class=FILE_COMPRESSION_INFORMATION,
+                         input_buffer_length=16)
+    try:
+        fd = os.open(args.file, os.O_RDONLY)
+        buf = qi.ioctl(fd)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False
+
+    comp_size, fmt, unit_shift, chunk_shift, cluster_shift = struct.unpack_from('<QHBBB', buf, 0)
+    print("Compressed File Size: %d"%comp_size)
+    fmt_name = "UNKNOWN"
+    for val, name in COMPRESSION_TYPES:
+        if fmt == val:
+            fmt_name = name
+            break
+    print("Compression Format: %d (%s)"%(fmt, fmt_name))
+    print("Compression Unit Shift: %d"%unit_shift)
+    print("Chunk Shift: %d"%chunk_shift)
+    print("Cluster Shift: %d"%cluster_shift)
+
 class KeyDebugInfoStruct:
     def __init__(self):
         self.suid = bytearray()
diff --git a/smbinfo.rst b/smbinfo.rst
index 91b8895..7f5bb4d 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -67,6 +67,8 @@ COMMAND
 
 `filestreaminfo`: Prints the FileStreamInformation class
 
+`filecompressioninfo`: Prints the FileCompressionInformation class
+
 `fsctl-getobjid`: Prints the ObjectID
 
 `getcompression`: Prints the compression setting for the file.
-- 
2.54.0

