Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD094439004
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 23:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764754; cv=none; b=GHMIlU2JHqwgINIZiOMILxR0xj+BwEwKCzP8tyYif9JvWhkiIVw8tw6k+HByJntF7kyT697O2VDl/oXLCh85PB1nLjyCQr2fN7X1x7g9Ed0tFoQAVQFr27FbpsrfGyTsrVK0x4nAIjM8nby7kjZ6L0B1oA+3vpsX4b4UEgRDLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764754; c=relaxed/simple;
	bh=OwG74fSwi0W2SJ/+t1vOq0YpUMqnuUrX66aNXWCUhfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KCykDvJ8O8QXyhOWTllrqcrmZ72vJyBrHJjxF2kFnpsx0N7gzoZpGbHlqkFgkc0SnNdKQcnXzNdho0CRgiTSTMqtUfM8QbRNYSaU8z1Bk6kIzEy0vbY4ZwLXCm5daIo9++AtJFg0z/lvbALKMBhH7wBSXkZgYdfKOZZeh43nb4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=q6sh7B5c; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="q6sh7B5c"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e08baf860so39888a91.2
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 16:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784764752; x=1785369552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HPTrczMIYf4GzoHkfWEvB8pWP/6KobUARwbGJd0psCo=;
        b=q6sh7B5cBC73vZXmpkc6ld7Kp6Xdr3chkQUBIzd6bAXlo9Wi7jPuEaa0mTi90YIk5E
         S19sfuxGyaaResArootKorFY8AAaQJJpvFxMoE/S+xYQ4hq4QzorfSCki008lcludzv3
         8R4faNqbIN0h6cT9OiL6Jvl5l34ezPg9BnrFePnhVTREx7rOBq7scB1EkVYMT05P17rU
         GCbjF1ygvK/F8Vl7v2cRHBbfI5kaqH14yEkMgx5CU0rOymK6swct0ktjZb4RRCvcfJGx
         UXD+WKKGflQAuMNOOX5UhDdyR1NopQ2HixP9CRzjTj3LZg24VVxEp6duN1RW6W1EOGzG
         yU3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784764752; x=1785369552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HPTrczMIYf4GzoHkfWEvB8pWP/6KobUARwbGJd0psCo=;
        b=HTSoQ2/qIxx7ph+fbUb1OlwuwrD4aGDXLP10DzFKkZnBs6eI9LaLoebPao/jAfHdmd
         93lGks1y6TGjKxcNVJ7NUlo1u8Oe+9XoX9Wpv9JywKJECqGhE+o6XYG9ajg0mF9KMqjY
         iRXKStHc8lA2J2teWM6p95wS6FZcyDGbaZ3GxEYBIkHmsAX4LA+Us+JRa/7vOuP7g4mU
         phk2PSnYRTyJJFKWCOky+EQAHVW2ILXWE/z7iDRzVHnxXWCwOqpiKHkhPExeXfkODspp
         IYD+2vjpy4ucfcVh8a6NjmHyi0RSiOzZHzThg2mKtbQ520aPbUQv0yfbIHHasyVKjX6M
         uyvw==
X-Gm-Message-State: AOJu0Yycn1gG8wNPOB/BLyZI+9GDq0YAqesMRLyud+HA9kCoBj7RhjYS
	VNSWhaGILeTkC2L98JNaP2UWvUqT2ZmTLa2SJxlSZfvSXrW/+96Ei1DO5A3gtGP1iA==
X-Gm-Gg: AR+sD10AYhJlqtdn2a/1bbZvF8M3Hf0Hgns/4uhvcn7xgZLP4toNGbsAf6dHKffoRRn
	L0IcO2Hqrnd//kJBxE5PUnma92/hO6h9E1WOoahErEuSy51pQLM8jaf6a03lzXihjp42WO+ORIY
	OG/pfw+gKZiHhYrhq2XUSbypTg+4DrP1XCoGXq4DxFBQMIjC0VDOjFhZ4mxNOvYgkq6BnEGMfeI
	2vjNygXgUJvmmUtufoWPdPnBi4jj7DkfEHZZ6I3HocZnE0f9eyZfg2+8G5NiwpNaCdVpkUM4GS6
	/NP12eRY+ulLsToF3ZL6kfqvCX39grauWkihd/bQTdNTtXY2MIfs4oWijTU5EvuaP+VuzHdLV4r
	GoWxeFwuUgyyGL7jQf5HRM4YWqMKQ5oJLyEugCRhTKeFcddr+NHLqTTA6WrysRKYo0/3OhvHg5e
	wGAOPYIkM=
X-Received: by 2002:a17:90b:2d46:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-38ec6453ea7mr799849a91.7.1784764751976;
        Wed, 22 Jul 2026 16:59:11 -0700 (PDT)
Received: from xiang.tailc0aff1.ts.net ([20.171.14.70])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130a87e9sm9343917c88.11.2026.07.22.16.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 16:59:11 -0700 (PDT)
From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>
Subject: [PATCH] ksmbd: use copied ACE count when walking DACL in set_ntacl_dacl
Date: Wed, 22 Jul 2026 23:59:08 +0000
Message-ID: <20260722235908.3564560-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_ntacl_dacl() copies ACEs from the stored, attacker-controlled DACL
into pndace but may copy fewer than nt_num_aces (it skips ACEs with a bad
sid.num_subauth and breaks on size overflow). It still passes the raw
nt_num_aces to set_posix_acl_entries_dacl(), whose dedup loop then walks
that many ACEs and, past the last one actually copied, reads
sub_auth[num_subauth - 1] from uninitialized buffer memory - an
out-of-bounds read whose offset comes from that stale byte.

Pass num_aces, the count actually copied, instead. For well-formed DACLs
num_aces equals nt_num_aces, so behavior is unchanged.

  UBSAN: array-index-out-of-bounds in fs/smb/server/smbacl.c:651:27
  index -1 is out of range for type '__le32 [15]'
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   __ubsan_handle_out_of_bounds (lib/ubsan.c:455)
   set_posix_acl_entries_dacl (fs/smb/server/smbacl.c:651)
   build_sec_desc (fs/smb/server/smbacl.c:776 fs/smb/server/smbacl.c:1078)
   smb2_query_info (fs/smb/server/smb2pdu.c:6269 fs/smb/server/smb2pdu.c:6339)
   handle_ksmbd_work (fs/smb/server/server.c:308)
   process_one_work (kernel/workqueue.c:3322)
   worker_thread (kernel/workqueue.c:3486)
   kthread (kernel/kthread.c:436)

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
---
 fs/smb/server/smbacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 67b39b4d218c..957547157ef8 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -774,7 +774,7 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 	}
 
 	set_posix_acl_entries_dacl(idmap, pndace, fattr,
-				   &num_aces, &size, nt_num_aces);
+				   &num_aces, &size, num_aces);
 	pndacl->num_aces = cpu_to_le16(num_aces);
 	pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);
 }
-- 
2.43.0

