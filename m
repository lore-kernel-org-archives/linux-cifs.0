Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5632078F3A
	for <linux-cifs@vger.kernel.org>; Sun, 21 Dec 2025 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766330656; cv=none; b=p21euN+XEbCCWVnIXVCJQiMgmQ553c0gDukymYMqV01exo4Vvm1q/6W+F7XcyzDWPYaawHshTLak8SxoT4BX89WflzIirwoqDeCDw/+NPQ2wOdY8kfiXkiFsw/aYDym4GVYHQ3vljQgQO3piYRnTT6q5LOSn2jejzuqlH741+TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766330656; c=relaxed/simple;
	bh=0ViiMOnsMt/hI388+uR5y4+uz639TSeElsiJ7/5oyjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yxl3EjcsEOG4rYcHz4yViVEkN3AgxcZ27SdtkZVCVXyRoywFtI87njxhnV65TVvK4C7sekVxF+stn+lB/rW3Iwkc/499/hOU2y5JPoG+rlb26ohzVdWZ66tNa8RklUkiHob79+0zddGIgFWUUTJvN7AI6t0ozgffEriJna7bcKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tb6GzkVn; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tb6GzkVn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766330648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bpzh6YEvNT0ov9T9FsbcBIrEVD43U5VzEDLG/o/b8dw=;
	b=tb6GzkVnyuN3pTfjQ9ryZbw71kYqGWAchYlL9F1/0fHPFXOq7J0jwE7Ta6hgYRDjtN7z0A
	Ic6GFZuE1AepDPBfTZOJpAZ7zxgOzZradcHn2VZ0/thpJMpyGDbyQS4op5SfXs3ViifUHK
	cumX5F/1DuoB9srwqN33PgdgP6h7/lU=
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
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [RFC PATCH cifs-utils v2 1/1] smbinfo: add notify subcommand
Date: Sun, 21 Dec 2025 23:22:16 +0800
Message-ID: <20251221152216.363567-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251221152216.363567-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251221152216.363567-1-chenxiaosong.chenxiaosong@linux.dev>
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
 smbinfo     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 77 insertions(+)

diff --git a/smbinfo b/smbinfo
index 2e9e42d..381f318 100755
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
 
@@ -905,5 +911,74 @@ def cmd_gettconinfo(args):
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
+    fmt = "<IBI"
+    # See `struct smb3_notify_info` in linux kernel fs/smb/client/cifs_ioctl.h
+    completion_filter = 0xFFF
+    watch_tree = True
+    data_len = 1000
+
+    try:
+        fd = os.open(args.file, os.O_RDONLY)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False
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

