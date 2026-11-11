Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.36
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794363968;
	b=WSup9Y64KLvH7Y9SBy6z1T/DCM/3U56KyMbIMCqOK+xkNcumrxgb4cprEWzIUy+8o8FE
	 M25Ag31MRKOYb7NWnAyNQ2GZw+HULUEmrDRCkQPz4N9LljvM6CQ0oCXuM0UWFt36jvpk1
	 x/GybELaGkrb/GggHxgFavq3DvmdGL0UhFbpeJ7h/RLaIT2vZZQWlxkTUNPNpJZiOqeVK
	 E+k9PD24GqLl9X7osh6MnbHcyWkyeHaQ4IbxKeQWqQTXW6bI/Ds9geYiwwDM5+JeiGoBZ
	 SyBJIE+CIWWBb0nuguOH5aBGFv7gxD+67d77Z8au3HhvIjiGvuCd93D2RiQ7VZ6Srpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794363968;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g0Ki1k2iXcRfauv2Fk1REdPA+yGos5z7riNTPu2Rs14=;
	b=x+69ceeOQ7GbYAWyA2bEyDMEMhku4wih2fvucztQtOv20wTApU89LjsXfwSxP5WZtZe4
	 TFk93KWQb6qOMWgCwjWdd+qtC2+yWVAnm9+2ozwPYh6MVu86IWMP3X/bXWvqy0mhCn3sC
	 gfqWNSHxqmFXc9qmTusJIHQ6eNUJ4/T5qtQD+geCj/nMenvtv6iuDT5rySHoNVdP7EzAJ
	 1nQ73qBkU8xghbx6ZvVrBpaX/FT5Ll4bXGOVAam8oaBhxfgmTQBwf4vfCCZ4jaGuOjruq
	 p+d9UyNGGP3Hlj3+b/gSyxnzdWqhOQPOyIBWi/oaieA95Et6GI3nextzIeSjXVcHNbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=mymjl4x+;
	arc=none smtp.remote-ip=91.218.175.36
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836FB606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 02:26:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 836FB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=mymjl4x+
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=urBaGQ30r4owbSbh1zAEePnquDeu7VxlIqUygtczYrI=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794363965; v=1; x=1794968765;
 b=mymjl4x+8Urr2VSrUyNKl/ZLAksGYxbX4uZZtJJ2b0zTpvFbP3zVsjI2Dfs6VZDbQVR9WVOq
 UoEkTIURYGOo5ZxoN4V8wsvvWJ1hvidUMvTi+xKFr317mqN0811qVWL0BZda19lz/cv0T3OLWCc
 Ck7z+p+lWMRkwpYylSb1DV4WYpcfOlWMAAT5WM5HuRe9Gl8Ig3s+cCE088YKQWAI5CL3URyytwg
 EvO4Cb9So8GwYoi9N1t/FLGDwzm+b5mr/xJgqhFr5GxgG3jAf04yPMiOlDghM7y6WLtTnn+Ws/B
 +TLRpJnHQhq4dId2UAf42fQIrxiifhT66cMRGIPF3llxw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b615327d779a38a1;
	Wed, 11 Nov 2026 02:26:04 +0000
X-Mizu-Trace-ID: b615327d779a38a1
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
Subject: [PATCH cifs-utils 1/3] smbinfo: show directory in notify help
Date: Wed, 11 Nov 2026 02:25:20 +0000
Message-ID: <20261111022522.406718-2-chenxiaosong@chenxiaosong.com>
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

Change the notify argument name from `file` to `directory` in the help
and manual.

Example:

  ./smbinfo notify -h
  usage: smbinfo notify [-h] directory

  positional arguments:
    directory   Directory to watch for changes

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 smbinfo     | 4 ++--
 smbinfo.rst | 6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/smbinfo b/smbinfo
index f9a8c4d..1ed1b6c 100755
--- a/smbinfo
+++ b/smbinfo
@@ -317,7 +317,7 @@ def main():
     sap.set_defaults(func=cmd_gettconinfo)
 
     sap = subp.add_parser("notify", help="Query a directory for change notifications. Press Ctrl+C to exit.")
-    sap.add_argument("file")
+    sap.add_argument("directory", help="Directory to watch for changes")
     sap.set_defaults(func=cmd_notify)
 
     # parse arguments
@@ -982,7 +982,7 @@ def cmd_gettconinfo(args):
 
 def cmd_notify(args):
     try:
-        fd = os.open(args.file, os.O_RDONLY)
+        fd = os.open(args.directory, os.O_RDONLY)
     except Exception as e:
         print("syscall failed: %s"%e)
         return False
diff --git a/smbinfo.rst b/smbinfo.rst
index 7aa3ecd..a74ce57 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -104,7 +104,11 @@ the SMB3 traffic of this mount can be decryped e.g. via wireshark
 
 `gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
 
-`notify`: Query a directory for change notifications.
+`notify directory`
+  Query a directory for change notifications.
+
+  `directory`
+    Required. The directory to watch for changes.
 
 *****
 NOTES
-- 
2.53.0

