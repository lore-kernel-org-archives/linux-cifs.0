Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6EA135417
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 20:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720212266; cv=none; b=nwkns03ok3RuftDge+hz9LNCwaqCZhbb4PSbBk5i1JK4eOmGVPEKdz6AqROAFGGbbQIlK1y3493kYeflNBH4xaemnzHPuDTT22FTrfuNDu5hw4rnhlY61o6N5lG5TH04QHNY4avDiN6yg+O3/pLXUCl5a8af+EvvxW34wWaTA8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720212266; c=relaxed/simple;
	bh=rb0oMoLUwhzEbuknQFF3vGm/FhK1Pt1vnQOymGzylyE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BCjYwak2UKcUepHp86ZzmFUXssJi6YSCn+b5fNbBumO4i0H10S0ZkANNUpQ2JikPKV5+7bQ4yZCWGQLKq3MSQKfzp7iPK+XhudadCgSvnhGilDJZdnpHdz9o/2jsqkh0lvxZE/r2DbjDCHNnqNz52yrvEi8OG7pUa1BV0AuvCWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enlXzjaI; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enlXzjaI"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-79eff64a066so29057685a.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2024 13:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720212263; x=1720817063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=69YO7nlBXtqQBZAAUoHMQkjINV6greLmBydp541j2+M=;
        b=enlXzjaIRJa786HKxaWfDILeyxf5h9dA7Lh09iC4fS2dPtwyryZrKQTVVHb8xNFybE
         9uBU9Dqh7bJ9UMCjq84bnAi516YYQXIOEL8mU323IEG0AOhHpKsdZbAtvy0KZ4i23RW+
         zkTGZy4q/qAbD901kKJr4eAJ5HHxfU5L5j64OQbg/w3+ocQXMb80DnJZjD0/qKd4EGbi
         N5HPGPHrRIcjSWYiv8YShm63m2vtLIBggPXZ5Nelw+bMAKD5+0rl/B2nKlyjLt6ml2QY
         WcpT4Ln5ajFxkTKPSaTjrr18eMLrtqSdJxJfHZxXM4hXa5HlK7ZN9PAwv7wWjO5reGSA
         54Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720212263; x=1720817063;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=69YO7nlBXtqQBZAAUoHMQkjINV6greLmBydp541j2+M=;
        b=UtMKzMmdTjnC2YMB4T/qvsRA6jNXaWuEKZWgQnZi1zd+MothBHrkvVRZb0FAtpOgcZ
         80l8B1pVSFcrOxfyxnoyjjADBDFaK/FZKRI3sue1+JgGPSJKmtWLebtvI/nJW9tzjd3U
         ksMrtfyxj28OOl8ZLafcrZ3zfPMGVWFu1veWFA6N37GNfkkhv52LP1aht5cgrfq/53ml
         UaIskXnydj42X5dmmkZiE2RF589QuvGfx3FToD3fGydBUFrip4+NwwZf93IKI+n62FKN
         2XR8c1iJOt/UdIuxqODmqWqWKV9DdV28kZkgs2HZXGzN1dlfWZr2b/0wRYR2QiHL+Lgz
         GghQ==
X-Gm-Message-State: AOJu0YycBUDj2RokFqkIfYnZOxgz+G/jxmEGmtsQTRYdWek/87w4gNXD
	2DHp69iiqiWLKS5RJSEKb3/0f/mzVhEJH1JjuuIVtrxl2bcbGSO58DLyYN1e
X-Google-Smtp-Source: AGHT+IH1u4QckirpF2r0nmR9fVVFRdbHxnrlPeixINxZ9YMwZg6Be9m8zpk5jwqtglgOD+VjtFYtHA==
X-Received: by 2002:ac8:7d8b:0:b0:447:df1a:d973 with SMTP id d75a77b69052e-447df1adbafmr8999041cf.38.1720212263457;
        Fri, 05 Jul 2024 13:44:23 -0700 (PDT)
Received: from nandaa-lx.mshome.net ([20.39.63.7])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-447dd3b75acsm3575851cf.64.2024.07.05.13.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 13:44:23 -0700 (PDT)
From: Anthony Nandaa <profnandaa@gmail.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	sfrench@samba.org
Cc: samba-technical@lists.samba.org,
	Anthony Nandaa <profnandaa@gmail.com>,
	Pavel Shilovsky <pshilovsky@samba.org>
Subject: [PATCH] cifs-utils: smbinfo: add gettconinfo command
Date: Fri,  5 Jul 2024 23:43:52 +0300
Message-Id: <20240705204352.975013-1-profnandaa@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a follow up on the patch on Linux: de4eceab578e
("smb3: allow dumping session and tcon id to improve stats analysis
and debugging") [1]

Add `gettconinfo` command to dump both the TCON Id and Session Id of
a given SMB mount; to help with correlation in cases when multiple
mounts are to the same share.

Example run:
```
./smbinfo gettconinfo /mnt/smb_share
TCON Id: 0x1
Session Id: 0xa40000000001
```

[1] https://github.com/torvalds/linux/commit/de4eceab578ead12a71e5b5588a57e142bbe8ceb

Cc: Pavel Shilovsky <pshilovsky@samba.org>
Cc: Steve French <stfrench@microsoft.com>
Signed-off-by: Anthony Nandaa <profnandaa@gmail.com>
---
 smbinfo     | 29 +++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 31 insertions(+)

diff --git a/smbinfo b/smbinfo
index 73c5bb3..3467b0b 100755
--- a/smbinfo
+++ b/smbinfo
@@ -35,6 +35,7 @@ CIFS_QUERY_INFO          = 0xc018cf07
 CIFS_ENUMERATE_SNAPSHOTS = 0x800ccf06
 CIFS_DUMP_KEY            = 0xc03acf08
 CIFS_DUMP_FULL_KEY       = 0xc011cf0a
+CIFS_GET_TCON_INFO       = 0x800ccf0c
 
 # large enough input buffer length
 INPUT_BUFFER_LENGTH = 16384
@@ -289,6 +290,10 @@ def main():
     sap.add_argument("file")
     sap.set_defaults(func=cmd_keys)
 
+    sap = subp.add_parser("gettconinfo", help="Prints TCON Id and Session Id for a cifs file")
+    sap.add_argument("file")
+    sap.set_defaults(func=cmd_gettconinfo)
+
     # parse arguments
     args = ap.parse_args()
 
@@ -876,5 +881,29 @@ def cmd_keys(args):
         print("ServerIn  Key: %s"%bytes_to_hex(kd.server_in_key))
         print("ServerOut key: %s"%bytes_to_hex(kd.server_out_key))
 
+class SmbMntTconInfoStruct:
+    def __init__(self):
+        self.tid = 0
+        self.session_id = 0
+
+    def ioctl(self, fd):
+        buf = bytearray()
+        buf.extend(struct.pack("=IQ", self.tid, self.session_id))
+        fcntl.ioctl(fd, CIFS_GET_TCON_INFO, buf, True)
+        (self.tid, self.session_id) = struct.unpack_from('=IQ', buf, 0)
+
+def cmd_gettconinfo(args):
+    fd = os.open(args.file, os.O_RDONLY)
+    tcon = SmbMntTconInfoStruct()
+
+    try:
+        tcon.ioctl(fd)
+    except Exception as e:
+        print("syscall failed: %s"%e)
+        return False
+
+    print("TCON Id: 0x%x"%tcon.tid)
+    print("Session Id: 0x%x"%tcon.session_id)
+
 if __name__ == '__main__':
     main()
diff --git a/smbinfo.rst b/smbinfo.rst
index 1acf3c4..17270c5 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -96,6 +96,8 @@ COMMAND
 the SMB3 traffic of this mount can be decryped e.g. via wireshark
 (requires root).
 
+`gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
+
 *****
 NOTES
 *****
-- 
2.34.1

