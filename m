Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4221ADFE4
	for <linux-cifs@vger.kernel.org>; Wed,  7 Jan 2026 04:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767760356; cv=none; b=OuyqMdMPxTKVeJXudihHN35yeNYLsCVWO2oSnfbIzlMJ3CC0gUrzKCP/nRcK2aKOmTJAUEkctWRnKbEtfbCMQdopFJNf3042uLyz4VVA4bcncEvFNQeh7Qct1UmHqFggo2Wl+hcDkfVbk5JiCmh6E3dzRzh7oYBx4JUzXv2wWmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767760356; c=relaxed/simple;
	bh=NTWHjICRKTlBE03RsjxMDEw/PUfZH4D1Vjg4yVuC0HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8g+uUx0DB2zAH93Di23Qip7wUrD42xvVmXmnvqOS9EoBuMxw122UyCm6ZkUkICTnzE03KmxRmFtlN9eh3QSmpAkLbNkzvf+dT1g6Pne92VRFxcjvRT5X6LscTWEXKlcYJ5KidDqWrV/FaqLTLTmj7gaAYS+2pYPrZJ7D/kXR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nyp6nAjK; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nyp6nAjK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767760351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jZU/GWSd6eb43Hz8owIt0yfyWHFceUggyhtzDjLPRQ4=;
	b=Nyp6nAjKnHYau2Vl8r6mXhARyLoX+f1Afc6n7eEzU61oiXmn2bAwWVvpULonJzwHmxXPqC
	SD9wQ+twiEbZWFsTJFWAO0lsQ6irmOZW2pFFI1tyIlmQhSMWdwXO4FeEF+cbyu5YSDLUWY
	XCOzOLxNxwYQqk6diVbk+03JDf77eAs=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 1/1] smbinfo: add notify subcommand
Date: Wed,  7 Jan 2026 12:31:08 +0800
Message-ID: <20260107043109.1456095-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260107043109.1456095-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260107043109.1456095-1-chenxiaosong.chenxiaosong@linux.dev>
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
  # Call `ioctl()` again

Press `Ctrl+C` to exit `smbinfo`.

Link: https://lore.kernel.org/linux-cifs/CAH2r5msHiZWzP5hdtPgb+wV3DL3J31RtgQRLQeuhCa_ULt3PfA@mail.gmail.com/
Suggested-by: Steve French <stfrench@microsoft.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 smbinfo     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 80 insertions(+)

diff --git a/smbinfo b/smbinfo
index 2e9e42d..57e8a0a 100755
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
 
@@ -905,5 +911,77 @@ def cmd_gettconinfo(args):
     print("TCON Id: 0x%x"%tcon.tid)
     print("Session Id: 0x%x"%tcon.session_id)
 
+def cmd_notify(args):
+    try:
+        fd = os.open(args.file, os.O_RDONLY)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False
+
+    thread = threading.Thread(target=notify_thread, args=(fd,))
+    thread.start()
+
+    try:
+        thread.join()
+    except KeyboardInterrupt:
+        pass
+    finally:
+        os.close(fd)
+        return False
+
+def notify_thread(fd):
+    fmt = "<IBI"
+    # See `struct smb3_notify_info` in linux kernel fs/smb/client/cifs_ioctl.h
+    completion_filter = 0xFFF
+    watch_tree = True
+    data_len = 1000
+
+    while True:
+        buf = bytearray(struct.pack(fmt, completion_filter, watch_tree, data_len))
+        buf.extend(bytearray(data_len))
+
+        try:
+            fcntl.ioctl(fd, CIFS_IOC_NOTIFY_INFO, buf, True)
+        except Exception as e:
+            print("syscall failed: %s"%e)
+            return False
+
+        _, _, data_len_returned = struct.unpack_from(fmt, buf, 0)
+        print("Notify completed, returned data_len is", data_len_returned)
+        notify_data, = struct.unpack_from(f'{data_len_returned}s', buf, struct.calcsize(fmt))
+        print_notify(notify_data)
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
+        if pad_len >= 8:
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

