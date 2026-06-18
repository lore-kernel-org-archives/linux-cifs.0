Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7EC3F484B
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785646; cv=none; b=eUhtuJe2vB13hEeylwKK2jCl1YYTUyXKpJ97y0hJ0x6yT61qPgNHA4CDUyn0px+Lqz8GVwiAS+xK1I2F2d9EelUrMOyxYSOPpDz2Khm6/h2EkvmKcWbknLHc2nfHgPkw8O+VtrXpSe5wNkMu6jspZmjidRHi5jyjNK1GZwCIYyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785646; c=relaxed/simple;
	bh=uWPx9UEhg+X6uCnmB2u/Zw0vwcTyQKhsuPRks1qZTao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gGSBTsfl6U6Ar0ZxAg6I3+/SOJHUg1LbI3kvvkd0L7reyKIDe0lK7Nutz4cjge1M+e+t2mBEqgxEMEc/U+i+m2YnEQGL7m8yLdgwmr5JyLAgeTIXTK3rPDfcHIoCl2Ilu37QlP/+P0mw6TkBuURrIQEwTyQJSp+CbmaeBGjVFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=k90udkPq; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="k90udkPq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1781785640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kF+BelXPHonJclSYlovCIT3jXh1mzkN0Bk7d/ar54zo=;
	b=k90udkPqBHyzL0f6KxJYEYIR4NXdbM0PC+ilrMAXFZ0scYTnVYzd6c65ILpQt0deVk0hL/
	PbXHW62U51k5u56Dn3PieITDHtd6SDNLfUPbHZjYcVrPKXHQGCjlkOq3tgZtiMhbfQ+OEo
	Z9QPROGMrWq1UqbmekMnBNnLr4E8LOq7OHXtN/45vWSQg+9sb3oVPs+Xn8OCDavIxSM4L4
	0/s+3hmTf5GBis/tznwBfSa09A4cPaFY8CU6dbWzAQ0bFeStUZG0q/OJHPTRFZc6DWhmRQ
	gIKD5ShLJJL+hDvuC0bIaG8MFjTg5sbHXv5PzUFxt3rlaUwR3BAHNzdvQt9Hgw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH cifs-utils] smbinfo: parse action and filename from change notifications
Date: Thu, 18 Jun 2026 12:26:55 +0000
Message-ID: <20260618122655.232479-1-chenxiaosong@chenxiaosong.com>
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

  ./smbinfo notify /mnt
  # server: mv /export/file1 /export/file2
  Notifications received, returned data_len is 48
  Action: 0x00000004, FileName: file1
  Action: 0x00000005, FileName: file2
  ...
  Notifications received, returned data_len is 24
  Action: 0x00000003, FileName: file2
  ...
  Notifications received, returned data_len is 24
  Action: 0x00000002, FileName: file1
  ...

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 smbinfo | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/smbinfo b/smbinfo
index d6c30f1..5c1a812 100755
--- a/smbinfo
+++ b/smbinfo
@@ -979,17 +979,17 @@ def notify_thread(fd):
             return False
 
         _, _, data_len_returned = struct.unpack_from(fmt, buf, 0)
-        print("Notify completed, returned data_len is", data_len_returned)
+        print("Notifications received, returned data_len is", data_len_returned)
         notify_data, = struct.unpack_from(f'{data_len_returned}s', buf, struct.calcsize(fmt))
+
+        if len(notify_data) == 0:
+            continue
+
+        print_notify_parsed(notify_data)
         print_notify(notify_data)
 
 def print_notify(notify_data):
-    if notify_data is None:
-        return
-
     data_size = len(notify_data)
-    if data_size == 0:
-        return
 
     BYTES_PER_LINE = 16
     for offset in range(0, data_size, BYTES_PER_LINE):
@@ -1015,5 +1015,34 @@ def print_notify(notify_data):
 
         print(f"{offset:08x}: {hex_bytes}{pad} {ascii_part}")
 
+def print_notify_parsed(notify_data):
+    # See `struct file_notify_information` in linux kernel fs/smb/common/fscc.h
+    FILE_NOTIFY_HEADER_SIZE = 12
+
+    data_size = len(notify_data)
+    offset = 0
+
+    while offset < data_size:
+        if offset + FILE_NOTIFY_HEADER_SIZE > data_size:
+            print("notify data truncated at offset %d"%offset)
+            break
+
+        next_offset, action, name_length = struct.unpack_from('<III', notify_data, offset)
+
+        if offset + FILE_NOTIFY_HEADER_SIZE + name_length > data_size:
+            print("notify entry truncated at offset %d"%offset)
+            break
+
+        filename_bytes = notify_data[offset + FILE_NOTIFY_HEADER_SIZE:
+                                     offset + FILE_NOTIFY_HEADER_SIZE + name_length]
+        filename = filename_bytes.decode("utf-16le", errors="replace")
+
+        print("Action: 0x%08x, FileName: %s"%(action, filename))
+
+        if next_offset == 0:
+            break
+
+        offset += next_offset
+
 if __name__ == '__main__':
     main()
-- 
2.54.0

