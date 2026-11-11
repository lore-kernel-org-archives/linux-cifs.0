Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794363980;
	b=Eij2DXi0KUYX1IdHICqF+cf0jzLbs25dhgp4oD7dNrb9Z4SJA5XtorD+eOad2uvLuJ/I
	 1athM3MBi/dKQeufvi8kzc792spMh6h86ZxSErjDo0IlKP9kIV4xSfPeBoltSpCYaKbfO
	 Bqre4EE+s+cXHaQKDz2JVfdze7e4Sn/I1LA5vRpR67oCcoE8mTB5jSWhuL3T9e0hwuxK4
	 Kv2qsqflQUG4a9h+2pv1Sv8bKBzpi5paABaa+rybl0QDr7HwGp67E3jLIThPVSXVsM8k7
	 ZLqvC7MN2j4Fmc/wTpeYANltatUW0B7F/YSFJqDU1SB99Xa57XbvKTopKxkUILC7kJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794363980;
	h=DMARC-Filter:X-Envelope-To:X-Envelope-To:Received:X-Mizu-Trace-ID:
	 X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=prqmqzyrMaeekz8REKgUfnX2h5LuRUkhTwANv/yqxbM=;
	b=PW+WPkq52KQiIJIkoMlbEuyBWk1BIwBzo/bNMSktMJsuGeU4WfpEkyUMLPGB3x/aXGSi
	 GuO+vKY68BrWe6E9QHQ/yaTxqSKgJPWRtmrWrNDxXMJnjiFx//izMnP4m6hUxklTgzgkq
	 hjQm/n0nWatRdsmG7CWy6dKHwk2/SghfqxIBv1dNem5//dP6mSP11AfDbpykYNSJwEa8c
	 6DUJQ3oBEWJmd80kjhJ+h+p9nF8lpmGY54qB8fSUxyDvNO8cuGXkrCkwl1lGhXFF2jXlL
	 yRpCTRQRQD4fplCC1qjkn1U857qCKTBHxsYEasr5HQNCqL/0hvMjdNeVMsVoWrGlQaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	arc=none smtp.remote-ip=91.218.175.41
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BFD606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 02:26:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69BFD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-Envelope-To: linux-cifs@vger.kernel.org
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b03614adcc116f48;
	Wed, 11 Nov 2026 02:26:10 +0000
X-Mizu-Trace-ID: b03614adcc116f48
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
Subject: [PATCH cifs-utils 2/3] smbinfo: make the notify completion filter configurable
Date: Wed, 11 Nov 2026 02:25:21 +0000
Message-ID: <20261111022522.406718-3-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111022522.406718-1-chenxiaosong@chenxiaosong.com>
References: <20261111022522.406718-1-chenxiaosong@chenxiaosong.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add an optional `completion_filter` argument to make debugging easier.

Example:

  ./smbinfo notify -h
  usage: smbinfo notify [-h] directory [completion_filter]

  positional arguments:
    ...
    completion_filter  Filter mask from 0 to 0xFFF; supports '|' (quote expressions in the shell; default: 0xFFF)
  ...
  completion_filter flags:
    0x00000001  FILE_NOTIFY_CHANGE_FILE_NAME
    0x00000002  FILE_NOTIFY_CHANGE_DIR_NAME
    0x00000003  FILE_NOTIFY_CHANGE_NAME
    0x00000004  FILE_NOTIFY_CHANGE_ATTRIBUTES
    0x00000008  FILE_NOTIFY_CHANGE_SIZE
    0x00000010  FILE_NOTIFY_CHANGE_LAST_WRITE
    0x00000020  FILE_NOTIFY_CHANGE_LAST_ACCESS
    0x00000040  FILE_NOTIFY_CHANGE_CREATION
    0x00000080  FILE_NOTIFY_CHANGE_EA
    0x00000100  FILE_NOTIFY_CHANGE_SECURITY
    0x00000200  FILE_NOTIFY_CHANGE_STREAM_NAME
    0x00000400  FILE_NOTIFY_CHANGE_STREAM_SIZE
    0x00000800  FILE_NOTIFY_CHANGE_STREAM_WRITE

  Example: smbinfo notify /mnt '0x1|0x2'

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 smbinfo     | 52 ++++++++++++++++++++++++++++++++++++++++++++++++----
 smbinfo.rst | 11 ++++++++++-
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/smbinfo b/smbinfo
index 1ed1b6c..e2faeb3 100755
--- a/smbinfo
+++ b/smbinfo
@@ -133,6 +133,27 @@ FILE_MODE_FLAGS = [
     (0x00001000, "DELETE_ON_CLOSE"),
 ]
 
+# See notify completion filter flags in linux kernel fs/smb/common/smb2pdu.h
+NOTIFY_CHANGE_FLAGS = [
+    (0x00000001, "FILE_NOTIFY_CHANGE_FILE_NAME"),
+    (0x00000002, "FILE_NOTIFY_CHANGE_DIR_NAME"),
+    (0x00000003, "FILE_NOTIFY_CHANGE_NAME"),
+    (0x00000004, "FILE_NOTIFY_CHANGE_ATTRIBUTES"),
+    (0x00000008, "FILE_NOTIFY_CHANGE_SIZE"),
+    (0x00000010, "FILE_NOTIFY_CHANGE_LAST_WRITE"),
+    (0x00000020, "FILE_NOTIFY_CHANGE_LAST_ACCESS"),
+    (0x00000040, "FILE_NOTIFY_CHANGE_CREATION"),
+    (0x00000080, "FILE_NOTIFY_CHANGE_EA"),
+    (0x00000100, "FILE_NOTIFY_CHANGE_SECURITY"),
+    (0x00000200, "FILE_NOTIFY_CHANGE_STREAM_NAME"),
+    (0x00000400, "FILE_NOTIFY_CHANGE_STREAM_SIZE"),
+    (0x00000800, "FILE_NOTIFY_CHANGE_STREAM_WRITE"),
+]
+
+NOTIFY_CHANGE_MASK = 0
+for flag, _ in NOTIFY_CHANGE_FLAGS:
+    NOTIFY_CHANGE_MASK |= flag
+
 ALIGN_TYPES = [
     (0, "BYTE_ALIGNMENT"),
     (1, "WORD_ALIGNMENT"),
@@ -316,8 +337,18 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_gettconinfo)
 
-    sap = subp.add_parser("notify", help="Query a directory for change notifications. Press Ctrl+C to exit.")
+    sap = subp.add_parser(
+        "notify", help="Query a directory for change notifications.",
+        formatter_class=argparse.RawDescriptionHelpFormatter,
+        epilog="completion_filter flags:\n" + "\n".join(
+            "  0x%08x  %s"%(value, name) for value, name in NOTIFY_CHANGE_FLAGS
+        ) + "\n\nExample: smbinfo notify /mnt '0x1|0x2'")
     sap.add_argument("directory", help="Directory to watch for changes")
+    sap.add_argument(
+        "completion_filter", nargs="?", type=parse_notify_completion_filter,
+        default=NOTIFY_CHANGE_MASK,
+        help=f"Filter mask from 0 to 0x{NOTIFY_CHANGE_MASK:X}; supports '|' "
+             f"(quote expressions in the shell; default: 0x{NOTIFY_CHANGE_MASK:X})")
     sap.set_defaults(func=cmd_notify)
 
     # parse arguments
@@ -980,6 +1011,19 @@ def cmd_gettconinfo(args):
     print("TCON Id: 0x%x"%tcon.tid)
     print("Session Id: 0x%x"%tcon.session_id)
 
+def parse_notify_completion_filter(value):
+    try:
+        completion_filter = 0
+        for flag in value.split("|"):
+            completion_filter |= int(flag.strip(), 0)
+        if 0 <= completion_filter <= NOTIFY_CHANGE_MASK:
+            return completion_filter
+    except ValueError:
+        pass
+    raise argparse.ArgumentTypeError(
+        "completion_filter must contain integers between 0 and "
+        f"0x{NOTIFY_CHANGE_MASK:X} separated by '|'.")
+
 def cmd_notify(args):
     try:
         fd = os.open(args.directory, os.O_RDONLY)
@@ -987,7 +1031,8 @@ def cmd_notify(args):
         print("syscall failed: %s"%e)
         return False
 
-    thread = threading.Thread(target=notify_thread, args=(fd,))
+    thread = threading.Thread(target=notify_thread,
+                              args=(fd, args.completion_filter))
     thread.start()
 
     try:
@@ -997,10 +1042,9 @@ def cmd_notify(args):
     finally:
         os.close(fd)
 
-def notify_thread(fd):
+def notify_thread(fd, completion_filter):
     fmt = "<IBI"
     # See `struct smb3_notify_info` in linux kernel fs/smb/client/cifs_ioctl.h
-    completion_filter = 0xFFF
     watch_tree = True
     data_len = 1000
 
diff --git a/smbinfo.rst b/smbinfo.rst
index a74ce57..924a37b 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -104,12 +104,21 @@ the SMB3 traffic of this mount can be decryped e.g. via wireshark
 
 `gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
 
-`notify directory`
+`notify directory [completion_filter]`
   Query a directory for change notifications.
 
   `directory`
     Required. The directory to watch for changes.
 
+  `completion_filter`
+    Optional. Accepts integers in decimal or with a ``0x`` prefix for
+    hexadecimal, optionally joined by ``|``. Its default and upper limit are
+    the bitwise OR of all ``FILE_NOTIFY_CHANGE_*`` flags; the lower limit is
+    zero. Run ``smbinfo notify -h`` to list the flags and their hexadecimal
+    values. Quote bitwise OR expressions in the shell, for example::
+
+      smbinfo notify /mnt '0x1|0x2'
+
 *****
 NOTES
 *****
-- 
2.53.0

