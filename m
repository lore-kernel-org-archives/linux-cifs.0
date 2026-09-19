Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13879397E81
	for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789820959; cv=none; b=CQ1CEH7Mvbdw8Zez66ICHwLZdDrwvAr54ZRf8AAZzye4L0EP5v+zq0ZXBm2IDUam1egyY6HxMdx0/cTpuzgpsZB/R0j0Pe+U6M0wqGKCjlZoZw9YzsKKGbW213tXSaSsHy1Am6p4dDpTPoGoCz1qqqTiwjBlHapUv51Gc3Jm0dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789820959; c=relaxed/simple;
	bh=SE232DjvIwBapucfH8zGIHI3YQXlcTJdhTbhikViymU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DJUuwfxPcyzHfLKs1Y0Zz1w/qI7YkFw4YDRBoWYcFZ+nm/cHLyYsUU2FcaW55+tuZutYjBCbB5HXlkaXUOdd4gLMtj8wuZrK5aEBf68ea9urQlVoMiWlBQdGwITWRS75LiVQC8qad2rvSCCbunrVdFFElWKmZq/tDzys8lFRrhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gbl2U9UW; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gbl2U9UW"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396cccbba92so1529987a91.0
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789820957; x=1790425757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g5bzToeT3SZK2yMWYUfD2EUwYUwmHZlA5kvYhKGfNz0=;
        b=Gbl2U9UWNSQ5DJfaBpl9zU4NHV+zZgbxG0gOy7Wdk8rnUDz6c7X5JnJxE0OdBg/H8J
         wQnO5ic5z6iltCV8iCPrAqZCfP1KHeOr8UmMYPGUvYSxuOk3rQ8NZQmJk92RRNZx582H
         hWujcfn68o7mRpWZBIUJHjdfjJhkTMmUaJlC/dBMGOVn0wHEjqFPA7E+Jqvc0M8uWyaQ
         B/sRWbYyBYY533mkt9gkR/wq9UN4rXmA0Ny1K8io7yWiYon89DbmnsutvKKRCbuMiVZW
         2Bq72PDEhRc+ZJtzeRcxLp2PnKeUmh7xLgKjLYgOVJcu8H4LsCj1qlP19ipnz0nPL0fk
         Y/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789820957; x=1790425757;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g5bzToeT3SZK2yMWYUfD2EUwYUwmHZlA5kvYhKGfNz0=;
        b=ZaHCEmMj2+JmKWgWGatzTJIqa1cxcq1av4qnIeVJSDAIjlWKIhfTId6bOsofutwPpf
         yaD1hBFdN4SO71JIEjmF/jM8e6QH2vsuW9ayGJL72X8HkH9AwMIhld930steQ2NA0hIq
         0KFv6E57EdykTGg6MMcpzFRtfW2RyxlkXMet8hPbiGyyblf6lLyuhmeaRDdJWXT8un+R
         k/aYvz8gjwt8GRql0o8R5iqRO8sMAGFYTeZOmSMAeojo/x9AYQnvOCVYX5q2YV/Fy6hM
         aiu0cwKWNhIFoBfmquUMGENGoaQ7srBh9J0dg+ACvshKsUpIFBamScQoB1Xf3QJg3hq3
         G98w==
X-Forwarded-Encrypted: i=1; AKwUvByy7f5+n6hIa4r8i+Uj4XZ6uo9NYqg2lR5dAAqdOgPO139Jjsr3/JnlL8PAnpQzSbSxjfj8Nw7KD1fR@vger.kernel.org
X-Gm-Message-State: AFuF++k4AQ9a19Kipb2I/URtA1qTsm9HcJHGBDfRJOfTM4ZVt+oi9n7u
	e0TuwZi0y+aYYjkFfhSs7RdPc/wHSMW4Xgfezcx6C8EmxyJRq0KcmAUYupfdAIx/
X-Gm-Gg: AYBFou3U/p4R1+/U+hD2G91NyFhL7L6Rush6zTkKSjwYEZT2ZUs6uNl9TKfnTlwpoNB
	wUoH7YJcW32P16Jek71vXoKS3GZBwGg/jLfWi+4mgdtSwaMbgC7mxKgR8ggf0snj76SzjI1YUwI
	qpyYq7UehEMheyjF/HZrW06dmF6Ws5Z11N7YDSI3GOo0aofj/jxvJCXeyTyRDn2S2JqK26Cvdwu
	z8stQ9kAFVO+MwteHCNpwDdygw2kK7kFkIa51JsSyApRR8Ac0C0bUJe696EJySjJCllZ6cnOhtJ
	9yZDXMYX0QpDnXKlPUr1ersLCKbda8J0sR8vW5MZtuhW7De+SGipcczctcDbiyI6EoDS2RWARNc
	7inpWvEhuNmNxNbgqQxsxfeIVagXanisCTt+kD1BEi/3tuvxfysgCHfajbzT4+vnRNry9Zk00f4
	hU016RVm0b4uHr1sFxpskjvwVK4C3bNiXgQIf1JfGTvpgUww3ps07UIdO9//nR6ntH0px+SmYwL
	EWOxb7avaRN3YsGcg==
X-Received: by 2002:a17:90b:3909:b0:39e:248e:fdeb with SMTP id 98e67ed59e1d1-39e54d10e41mr9937620a91.19.1789820957284;
        Sat, 19 Sep 2026 05:29:17 -0700 (PDT)
Received: from RyzenBox.localdomain ([137.59.96.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c331aef9bsm5978411eec.25.2026.09.19.05.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 05:29:16 -0700 (PDT)
From: Omkar Chandorkar <omkar0926@gmail.com>
X-Google-Original-From: Omkar Chandorkar <gotenksIN@aospa.co>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Omkar Chandorkar <gotenksIN@aospa.co>
Subject: [PATCH v1 0/3] ksmbd: Windows 11 SMB 3.1.1 interoperability fixes
Date: Sat, 19 Sep 2026 17:59:07 +0530
Message-ID: <20260919122910.2382-1-gotenksIN@aospa.co>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series resolves three separate protocol interoperability
defects in ksmbd that affect Windows 11 clients:

Patch 1: smb: compress: relax trailing flags in chained decompression
Windows 11 leaves residual uninitialized bits in trailing compression
chunk headers during chained writes (e.g. copying .vhdx files).
smb_decompress_chained() previously rejected any trailing header whose
flags did not equal 0x0000, causing connection drops (ECONNRESET) and
Windows error 0x8007003B. Relax this check to accept non-chained trailing
payloads while preserving validation on segment lengths and bounds.

Patch 2: ksmbd: fix compound CREATE and CHANGE_NOTIFY response handling
Windows Explorer opens directories using compound requests chaining
SMB2_CREATE with SMB2_CHANGE_NOTIFY under SMB2_FLAGS_RELATED_OPERATIONS.
smb2_notify() checked for all-ones sentinel FileIds before resolving
compound handles, misclassifying the request as a macOS Time Machine
sentinel and dropping the preceding CREATE response buffer when setting
send_no_response = 1. This left Explorer hanging for 60 seconds.
Fix by resolving compound handles first and immediately dispatching
the completed prefix CREATE response before deferring CHANGE_NOTIFY.

Patch 3: ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling
When querying the share list (e.g. browsing \\server or running
'net view \\server'), Windows 11 issues NetrShareEnum over \PIPE\srvsvc
using SMB2_IOCTL with FSCTL_PIPE_TRANSCEIVE. Named pipe handles exist in
sess->rpc_handle_list rather than the regular file table. Because
FSCTL_PIPE_TRANSCEIVE was omitted from the no_fileid_ioctl check,
smb2_ioctl() failed the file lookup with -ENOENT and returned
STATUS_OBJECT_NAME_NOT_FOUND (0xc0000034), causing Windows to report
RPC_S_CALL_FAILED (error 1726).
Fix by validating the RPC handle under rpc_lock and bypassing the
regular file lookup for pipe shares.

Tooling and AI disclosure:
AI tooling (GPT-6 Astra / OpenCode) was utilized to assist in protocol
trace analysis, specification cross-referencing ([MS-SMB2], [MS-SRVS]),
and initial drafting. All changes were manually audited, static-checked,
compiled, and verified on physical hardware against live Windows 11
clients.

Omkar Chandorkar (3):
  smb: compress: relax trailing flags in chained decompression
  ksmbd: fix compound CREATE and CHANGE_NOTIFY response handling
  ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling

 fs/smb/common/compress/compress.c |  17 +++-
 fs/smb/server/smb2pdu.c           | 150 +++++++++++++++++++++++++++++-
 2 files changed, 158 insertions(+), 9 deletions(-)

-- 
2.55.0

