Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9A4EEDE
	for <linux-cifs@vger.kernel.org>; Mon, 26 Feb 2024 04:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708923032; cv=none; b=tb7abjH3Z1qgvn9txwuHIVuzHd9VwAnzyPZtDW7hbe7ltDlhlkr0kL+4kWhj2iFxD5AQd2CZo4et75Y3O9oZFlNl7js0A9QaTt/V93Jok4KaaY7E2vGuKIGLOuKIP7Jbqu0VmhCro7Z9/t2Rp1xXp+4N9QhTgYgbYwWsB7t6Ak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708923032; c=relaxed/simple;
	bh=QERqCXSGr4xPyF1wOXxkecBp0Zzgeav9P0hNSt9YmW4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=jFGZwkj0S+qeonqI9RWBt6cdAdaVtRd6aSvyrvNFWvKoHVnsAP8WPzU9b4mo3abLR5gKd+JlHJ65yx+pYeGdhFfji7DOaE/7t9j1OkxSKckgXAMPTJUlorO2HIMYQJqr3lbGOHW/BWaZsdCYOpd0X9ymOBSWKv40IfGSN2GEtGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpEKxV8Q; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpEKxV8Q"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e4c359e48aso1516137b3a.1
        for <linux-cifs@vger.kernel.org>; Sun, 25 Feb 2024 20:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708923030; x=1709527830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y+VMceEnLUvEVfNYCJp1NC9eyGJ2RmM5wM0EEaHCuU=;
        b=kpEKxV8Q6amU57S87wd2FYlkkl2pb39QGIIHMhdX7rGwpKo3lVSBI7KaiAM5kaKRmf
         cIfjRr/ES5hWHfsK8GExkTTa4m3aZfNTEDGR28Ayjfzn1Km1icoFpxcioGyRa+LPVHlv
         2dw8S85dV9unl62Z8GGPCGrm38CasKDJJVcaf07X2xzSozXhc66pvTDBVbwwjD/vbE5S
         wI3xtCj+LEZ2FXrGgHve7eqUsaqO0ZUoTMXtvlLP2U07r+hjqb5t+xt291JO07oci2Z3
         vYJrwM+AE6CuNlcTpwP+3/Gw8M5Aga5D5tkOUh92irIR84cQBXXFaMtTkihlgEpPTq44
         C8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708923030; x=1709527830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y+VMceEnLUvEVfNYCJp1NC9eyGJ2RmM5wM0EEaHCuU=;
        b=dSoupfa8bY/yEafwSj5S7vDJd89mn8FBC4JxMdoXCBRzE49ifCfffp3EkDjq/NKzcu
         JXf5zFQxBZKi6pe7PL7kPJHM4J9JxqUSh0T8zmj4T8NFq0zmJYMpTKVkPqcOWJfesBk3
         Niy1UHd9LqTQfrgIoKvnp+tdA8sm8rfRofix9slTC4PgYdBES89xLykHQEhXCteXPpKv
         Dzd40h10IFspDjTNtszIO4p0FQjDm/zuf6WGPNYQTVdK1EH9xJHHcY2vexqtrU6A0g7P
         FaQOhpVLT2NyZjurXjataYGRvJ2T0rREtyG3skk053f++4YuXOGhpbUB8F5j5xlTyUdA
         mnPw==
X-Forwarded-Encrypted: i=1; AJvYcCXzyiZgjc0FtWuMpS9U6RADzv8+vLQOE89ciCrqcHD+Quc/cHdivXzWMzw/Q9qH2gMot9W9AuHYr27vRAlAajCgx4rmOoNqVYFD8A==
X-Gm-Message-State: AOJu0Yy/etpM5zcVeY+JbX3eOeZ2qsrhufPuCFwqbGGS4jF9Zk/i5AvO
	GhWDrNanmHAlL29RVYKI2phj3Q3MgYlSJ5i5+DAW8aGiq/5DAcjP
X-Google-Smtp-Source: AGHT+IGPa9zqmM/g76KnJuACq6dIhAbbEltCKfD4xmlog934SDKOj33R5iZfGb3jZPoNV5MP7i1fnA==
X-Received: by 2002:aa7:814e:0:b0:6e3:90c5:17ec with SMTP id d14-20020aa7814e000000b006e390c517ecmr7197546pfn.18.1708923030056;
        Sun, 25 Feb 2024 20:50:30 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([167.220.2.189])
        by smtp.googlemail.com with ESMTPSA id s188-20020a625ec5000000b006e46672df97sm3238039pfb.75.2024.02.25.20.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 20:50:29 -0800 (PST)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: pc@cjr.nz,
	sfrench@samba.org,
	nspmangalore@gmail.com,
	lsahlber@redhat.com,
	smfrench@gmail.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	bharathsm@microsoft.com
Subject: [PATCH] cifs: prevent updating file size from server if we have a read/write lease
Date: Mon, 26 Feb 2024 10:20:10 +0530
Message-Id: <20240226045010.30908-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cases of large directories, the readdir operation may span multiple
round trips to retrieve contents. This introduces a potential race
condition in case of concurrent write and readdir operations. If the
readdir operation initiates before a write has been processed by the
server, it may update the file size attribute to an older value.
Address this issue by avoiding file size updates from server when a
read/write lease.

Scenario:
1) process1: open dir xyz
2) process1: readdir instance 1 on xyz
3) process2: create file.txt for write
4) process2: write x bytes to file.txt
5) process2: close file.txt
6) process2: open file.txt for read
7) process1: readdir 2 - overwrites file.txt inode size to 0
8) process2: read contents of file.txt - bug, short read with 0 bytes

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index f2db4a1f81ad..e742d0d0e579 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 	if (!cifsInode)
 		return true;
 
-	if (is_inode_writable(cifsInode)) {
+	if (is_inode_writable(cifsInode) ||
+			((cifsInode->oplock & CIFS_CACHE_RW_FLG) != 0)) {
 		/* This inode is open for write at least once */
 		struct cifs_sb_info *cifs_sb;
 
-- 
2.34.1

