Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.77
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794363978;
	b=a8sp05xdoGsUKIpqIZBrD+HV4ys25eDMCpSy0hvYztxC6Yao+C60nL23+eSWbZ2AODl6
	 iHgCH5W1KzealiUqNWh96k7KAWx6HPLlEGKB2jCog+7R0ziiStvqPdSElssziQVvDw+21
	 MpAZud/eNnEUgv5yj/WsLGIX5EgidvuheUsk3JV6uYEMtJDPn6pM3ghyDXfvnaBDpB9ib
	 lGtX9N+2k1O/OK6nW0MyAIMRLuLIh+Xshg7SUiFxWwaS3ewkJwUWm1FxJknNNKzo6VyjG
	 2L5weBvxHyh3ZYAdXQ4Ax1JQ6NrTqfBqut2ozCcyEMzJiozxizJPpNOzHpg0LTjCUlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794363978;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TiLbzWRBJGop49l3zrWMVWG2BCfcGZTfnN4QXABYfcc=;
	b=UM/fRtaUy3cqVMEZEdyEZ/OX4LbImPaiFd3IoBsOcm1nKib+3jF8YqjUnxDPpD3WsytK
	 k1/OlmoNFzCQ+r6H94UAQ/ksvoJWE0+zcSsk6KTD07CYvC7MNjmCWziku1H1Xi7RNmsDR
	 6cirMUZRT1GC3u4j2TtFl8Ed9HPPR1olxraEG6QqzLZM/s3IANRdwd5/0uq+mCBITbArF
	 gKL9x4Y9mDQ2qCUgqZR4aCtEqgPfaiUP9zujUtX8m3ZbJJJz39nS5DoLkfeeW5HBYYmyM
	 J2hKm+dS6B5q8ANF5v19Bm7WFa3dmugYnQKNaKmjxwS6pnC+jNt8YnpTREfVPt7xlJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=ICbL3VFp;
	arc=none smtp.remote-ip=95.215.58.77
Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DD5606A326
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 02:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84DD5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=ICbL3VFp
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0RgCHKH1JgWrawGj5Y76ReRussSkGvoJV6kh1clT1SU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794363975; v=1; x=1794968775;
 b=ICbL3VFpvSOREMUEsj98dYLrOOdva5++9cdTHOYskCVY+8bPX5KdjueyEm2qkMCUHLiO4KR3
 e6dVONIcK25Fa0Xwtf43haKXzvyjSoNe1PQk9NQIc0PUO2wEoFHVSlYz70uY5Rc8/tfAp+hMkVF
 pTA1NmttKo7Uvs5c0RSn6PdSbhPFIPdhGktPdaEGMpmud5wJWP7Vegea0+S+/blmATpIbkGT4Cm
 rAgBtA2ox6uoQXF6io+wJWjFYTAABZCh6qwffb94d3ZT1VfSzN/NWZK6y+lo9jy8tyFwcCGnhKR
 rKMUU1NJUT64zTKSjPW3jZaljwkjM50B5TGLYYIzlgRaA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8ab63200f093323f;
	Wed, 11 Nov 2026 02:26:14 +0000
X-Mizu-Trace-ID: 8ab63200f093323f
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
Subject: [PATCH cifs-utils 3/3] smbinfo: make notify subtree watching configurable
Date: Wed, 11 Nov 2026 02:25:22 +0000
Message-ID: <20261111022522.406718-4-chenxiaosong@chenxiaosong.com>
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

Add an optional `watch_tree` argument to make debugging easier.

Example:

  ./smbinfo notify -h
  usage: smbinfo notify [-h] directory [completion_filter] [watch_tree]

  positional arguments:
    ...
    watch_tree         Watch subdirectories: True/1 or False/0 (default: True)
  ...
  Example: smbinfo notify /mnt '0x1|0x2' 0

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 smbinfo     | 18 ++++++++++++++----
 smbinfo.rst |  9 +++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/smbinfo b/smbinfo
index e2faeb3..2c966d7 100755
--- a/smbinfo
+++ b/smbinfo
@@ -342,13 +342,16 @@ def main():
         formatter_class=argparse.RawDescriptionHelpFormatter,
         epilog="completion_filter flags:\n" + "\n".join(
             "  0x%08x  %s"%(value, name) for value, name in NOTIFY_CHANGE_FLAGS
-        ) + "\n\nExample: smbinfo notify /mnt '0x1|0x2'")
+        ) + "\n\nExample: smbinfo notify /mnt '0x1|0x2' 0")
     sap.add_argument("directory", help="Directory to watch for changes")
     sap.add_argument(
         "completion_filter", nargs="?", type=parse_notify_completion_filter,
         default=NOTIFY_CHANGE_MASK,
         help=f"Filter mask from 0 to 0x{NOTIFY_CHANGE_MASK:X}; supports '|' "
              f"(quote expressions in the shell; default: 0x{NOTIFY_CHANGE_MASK:X})")
+    sap.add_argument(
+        "watch_tree", nargs="?", type=parse_notify_watch_tree, default=True,
+        help="Watch subdirectories: True/1 or False/0 (default: True)")
     sap.set_defaults(func=cmd_notify)
 
     # parse arguments
@@ -1024,6 +1027,14 @@ def parse_notify_completion_filter(value):
         "completion_filter must contain integers between 0 and "
         f"0x{NOTIFY_CHANGE_MASK:X} separated by '|'.")
 
+def parse_notify_watch_tree(value):
+    value = value.strip().lower()
+    if value in ("true", "1"):
+        return True
+    if value in ("false", "0"):
+        return False
+    raise argparse.ArgumentTypeError("watch_tree must be True, False, 1 or 0.")
+
 def cmd_notify(args):
     try:
         fd = os.open(args.directory, os.O_RDONLY)
@@ -1032,7 +1043,7 @@ def cmd_notify(args):
         return False
 
     thread = threading.Thread(target=notify_thread,
-                              args=(fd, args.completion_filter))
+                              args=(fd, args.completion_filter, args.watch_tree))
     thread.start()
 
     try:
@@ -1042,10 +1053,9 @@ def cmd_notify(args):
     finally:
         os.close(fd)
 
-def notify_thread(fd, completion_filter):
+def notify_thread(fd, completion_filter, watch_tree):
     fmt = "<IBI"
     # See `struct smb3_notify_info` in linux kernel fs/smb/client/cifs_ioctl.h
-    watch_tree = True
     data_len = 1000
 
     while True:
diff --git a/smbinfo.rst b/smbinfo.rst
index 924a37b..9131d30 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -104,7 +104,7 @@ the SMB3 traffic of this mount can be decryped e.g. via wireshark
 
 `gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
 
-`notify directory [completion_filter]`
+`notify directory [completion_filter] [watch_tree]`
   Query a directory for change notifications.
 
   `directory`
@@ -117,7 +117,12 @@ the SMB3 traffic of this mount can be decryped e.g. via wireshark
     zero. Run ``smbinfo notify -h`` to list the flags and their hexadecimal
     values. Quote bitwise OR expressions in the shell, for example::
 
-      smbinfo notify /mnt '0x1|0x2'
+      smbinfo notify /mnt '0x1|0x2' 0
+
+  `watch_tree`
+    Optional. Controls whether subdirectories are also watched. Accepts
+    `True` or `False` (case-insensitive), or ``1``/``0`` respectively, and
+    defaults to `True`. To specify `watch_tree`, also supply `completion_filter`.
 
 *****
 NOTES
-- 
2.53.0

