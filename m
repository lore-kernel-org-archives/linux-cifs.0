Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6534D385
	for <linux-cifs@vger.kernel.org>; Wed, 17 Dec 2025 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765979177; cv=none; b=cUBfq/RWCY0s3mLSOmBL7ZR0EmM6et7pAk3xjqWgmKjmLqAVwqNXODOUwvFK/GadV4Zs+up2DtyodVy0ynSzp8sj8tcImGBLYaESVqO3qYT2oKqMesYqvQMztOSpRk569jB/OfNvNoUpMX2CRS5H0WYgr0lMUTVPVT8eUwiA2kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765979177; c=relaxed/simple;
	bh=VEkg/V5oSVgx+3EfEekjGYOSSqZEb77Q/qbldjVi0As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR4oCpugN3GrJFLuG0nHg0UHacNhG/8q3zG/1zkwtvVoT0uvJz2qgpwdbanEk6WMvPeAj9ja9csSwKbw6/nkgPX5Q4zU2iQukj0PBU9ambSPJ8bDk9stC36b7EWZKUpEDqEusTQAUmPpEG7xp9g6rR3EFtdJioop9YR3LBqvUH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DRagxY4G; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DRagxY4G"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765979173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8pl6rlSZOCulCyW7BJBDkso7j9C6ZnAZqianP6s1Vw=;
	b=DRagxY4GBnPfZJJOTxyu4QyWYI8u4uZ2AjTa4k1Fd5DjgayUuupaNbYEF8GBpFJkdxtRVI
	jwdJ+7JxjurWVdKqL2EeeYjsWyzeTMP+G10X+J+0aiQSISUXZR5I6kI32Vc5Q+c3mTm/rG
	usJiErJvrgQHSOxbNZ7jASQL2urKgUI=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH RFC cifs-utils 1/1] smbinfo: add notify subcommand
Date: Wed, 17 Dec 2025 21:44:56 +0800
Message-ID: <20251217134456.16735-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251217134456.16735-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251217134456.16735-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add `notify` subcommand to query a directory for change notifications.

Example:

  ./smbinfo notify /mnt/dir
  # Then create a new file `/server/export/dir/file` on SMB server
  Notify completed, returned data_len is 20
  00000000:  00 00 00 00 01 00 00 00  08 00 00 00 66 00 69 00  ............f.i.
  00000010:  6c 00 65 00                                       l.e.

Link: https://lore.kernel.org/linux-cifs/CAH2r5msHiZWzP5hdtPgb+wV3DL3J31RtgQRLQeuhCa_ULt3PfA@mail.gmail.com/
Suggested-by: Steve French <stfrench@microsoft.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 smbinfo     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 71 insertions(+)

diff --git a/smbinfo b/smbinfo
index 2e9e42d..2be2395 100755
--- a/smbinfo
+++ b/smbinfo
@@ -27,6 +27,7 @@ import struct
 import stat
 import datetime
 import calendar
+import threading
 
 VERBOSE = False
 
@@ -36,6 +37,7 @@ CIFS_ENUMERATE_SNAPSHOTS = 0x800ccf06
 CIFS_DUMP_KEY            = 0xc03acf08
 CIFS_DUMP_FULL_KEY       = 0xc011cf0a
 CIFS_GET_TCON_INFO       = 0x800ccf0c
+CIFS_IOC_NOTIFY_INFO     = 0xc009cf0b
 
 # large enough input buffer length
 INPUT_BUFFER_LENGTH = 16384
@@ -294,6 +296,10 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_gettconinfo)
 
+    sap = subp.add_parser("notify", help="Query a directory for change notifications")
+    sap.add_argument("file")
+    sap.set_defaults(func=cmd_notify)
+
     # parse arguments
     args = ap.parse_args()
 
@@ -905,5 +911,68 @@ def cmd_gettconinfo(args):
     print("TCON Id: 0x%x"%tcon.tid)
     print("Session Id: 0x%x"%tcon.session_id)
 
+def cmd_notify(args):
+    thread = threading.Thread(target=notify_thread, args=(args,))
+    thread.start()
+
+    try:
+        thread.join()
+    except KeyboardInterrupt:
+        return False
+
+def notify_thread(args):
+    # See `struct smb3_notify_info` in linux kernel fs/smb/client/cifs_ioctl.h
+    completion_filter = 0xFFF
+    watch_tree = False
+    data_len = 1000
+
+    fmt = "<IBI"
+    buf = bytearray(struct.pack(fmt, completion_filter, watch_tree, data_len))
+    buf.extend(bytearray(data_len))
+
+    try:
+        fd = os.open(args.file, os.O_RDONLY)
+        fcntl.ioctl(fd, CIFS_IOC_NOTIFY_INFO, buf, True)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False
+
+    _, _, data_len = struct.unpack_from(fmt, buf, 0)
+    print("Notify completed, returned data_len is", data_len)
+    notify_data, = struct.unpack_from(f'{data_len}s', buf, struct.calcsize(fmt))
+    print_notify(notify_data)
+
+def print_notify(notify_data):
+    if notify_data is None:
+        return
+
+    data_size = len(notify_data)
+    if data_size == 0:
+        return
+
+    BYTES_PER_LINE = 16
+    for offset in range(0, data_size, BYTES_PER_LINE):
+        chunk = notify_data[offset:offset + BYTES_PER_LINE]
+
+        # raw hex data
+        hex_bytes = "".join(
+            (" " if i % 8 == 0 else "") + f"{x:02x} "
+            for i, x in enumerate(chunk)
+        )
+
+        # padding
+        pad_len = BYTES_PER_LINE - len(chunk)
+        pad = "   " * pad_len
+        if (pad_len >= 8):
+            pad += " " * (pad_len // 8)
+
+        # ASCII
+        ascii_part = "".join(
+            chr(x) if 31 < x < 127 else "."
+            for x in chunk
+        )
+
+        print(f"{offset:08x}: {hex_bytes}{pad} {ascii_part}")
+
 if __name__ == '__main__':
     main()
diff --git a/smbinfo.rst b/smbinfo.rst
index 17270c5..91b8895 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -98,6 +98,8 @@ the SMB3 traffic of this mount can be decryped e.g. via wireshark
 
 `gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
 
+`notify`: Query a directory for change notifications.
+
 *****
 NOTES
 *****
-- 
2.43.0

