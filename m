Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792706132;
	b=UBflJRgu/LxXbIwWYR2og/ByGluDFlVTAZWrL1oGzfqwp6yIFX7JYTg9Y/OsJOOdT/Yr
	 dcXiaZo0jRwo8FHSqrvBYQZ8WaqezZEtg81n6SjByTRbklwl17vTL76X8paWfFPFH3+AI
	 YDsTLdVGFQ6FJ1xQfDa1oAQ0hnSqU/D5Ggjqq5cih76LyZJN7lVv/IKGEubmldBGjwEaz
	 Yw1gSBXqxxj3g6mU4efNrxiRha+c1jB0w8D4t5bJLPDy6OecS+PfK42F3ImDfcR0MHsxu
	 shxeNeR8Wlb42Qvit/u0vV0ZLFKuDpfwnkO98ySaSez9sKjqHNSBc5eZJPt2qv8t1/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SzoGWciH1854vjZQ3Vt63hGrJ+4BEttHwlTqTi2zQY0=;
	b=vcrVQ/QCtPewiHRqQHHyL9uvZoyTc+SnP0tbgQ7xGfM8dqh1osCl8FqG9IEdF2Xwp/Qg
	 krQAaVB1S4sNREoHZA48oj7b5fK6uW8m6Scef8ji85APuz3/3Mr1XLnkulYitGx1oC0cM
	 5RZ7bqHxSSJ2Iv+atwNvXKchgjlfutixZIP3IzDvD1xKG/Td7P7T0e2hVjiBmILfm2HCy
	 qXbuRWjm49dsVjVy9DuXq1vnhXCDJrbBPIg4S4Vf7SQ5VRifw/x5tPK/ob5TauiPtGfth
	 i3ubib3hIohUvWavdg4dm42j///RWWM9bMTR1LQ8NnpsTYqb4+MhlxF1uEGiYezytLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OsIexivg;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B30A606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 21:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B30A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OsIexivg
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-18cdcfc05ffso291572c88.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 14:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792706131; x=1793310931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SzoGWciH1854vjZQ3Vt63hGrJ+4BEttHwlTqTi2zQY0=;
        b=OsIexivgMP4q+ddjNJRpFpgOTZjKclTzttgQkfLhxe0+EOqTF/BhpMr94cPqJPMICe
         CA3Ng9hd8gyGSWKRVcD7nPRVwoqcva6zkfdom3B+aPZz2WDWzXhY5/4nVeYI7/T3V1V6
         wilPOXYjPq/pw43IHcjZwya8LyIAqdTf53AKzCV7YSIxh/t7uKIvky05tYX/fl3ouIQC
         OkGU0m/mRpTCYlIWzpRw7m7QSjls8NiOQHVDA0V3I6GS0oYxe9KVg41TcydhqFluYWiY
         HBrbamfK3FZ8/KxU//DlcpfRfq8apv8KTfN0GlsRI5NqUL7X6TTR8Wx6IQxhR14pchnT
         rqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792706131; x=1793310931;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SzoGWciH1854vjZQ3Vt63hGrJ+4BEttHwlTqTi2zQY0=;
        b=USjhIrL7Z1Y/7fNccp+Md/xiLdhND1ipNx7cSkc3NSkPjmMREcpkEHtY7YoF7Igugf
         aEsOTT3J9njmN0B703m669qsNTIrbXQNOO2uxNXMYMCkFsP92oVanQql+2xazcqxmEeM
         s+VZRqQUJk4gU6WXpiUULV3vBxtyLe/mAAO99BYkcPAeqqkkqgH1ZNOdMeGW1IvRvoGM
         KH2A5myzEy8aFEROzHNL5k+xneKLJGV90I2r/Tx7086LycVMfPqJqEoGqjurvX9lShpK
         wbtwVHxhps9VR+q3s+R02XNWxNDoX14xaB9NCJFEZLcfAeuQepC/QQwCb7+ft9sleiWV
         MoeA==
X-Forwarded-Encrypted: i=1; AKwUvBzRXGdpNKYGZ6igi7i7v56NHtX/YbrsMceYoayyLDHfJgYyp2UOLtYHILMNfpVdF48jyjANNKI7GVYA@vger.kernel.org
X-Gm-Message-State: AFq9FYImVMwQXNr/ZAEsSc7liqsITLEP3zjwI4f83F814Ffj9XENB4+0
	b0PL+VpFzm4hPDDRgDfqY+N27lpvJpVAGK4TcWgIjtqL0jWkqufa5qPe
X-Gm-Gg: AYBFou1GYJppn0yYttEzTRcOWn8VdhJA0touqiCnqC4CVlLYGK4Lx5A0MF/inh+414/
	Jx/1oPLTWCKdBJgWxYnQ+FSha5kUdqVvbMWpgnpuK5lM6WJjOLkIK9bXSiIKJbmlRpNrhOwJB9G
	oJ8Qa/v1isOw9pLCL7esNrZmaQTtz7quKnDPSmsTQ0xwwhP2iY2Ajy102wq4CyQsdu2YXS4Npu6
	AzSRSVvuSgpmK0S7r3zBtQ4vA8Sby3lrM5HpqxIXOqF8XsH97c7P9mm+WEqo/6iZ1Yq1NMRC/8v
	P4xHmZe+olpaZDMVp1FerEF51M0MQX1RwF7ZsGJ8Ja0KNEmAQZ8Uf8o+LlIg+qvaRt7ylXUW8ar
	cu6+ycmpvGLRDXwpc0K5gsnuPwgdNyDztHIij8F5awl9Qp2oAYqEvnlKVJBfcEDOkPmVV28CoWj
	m8W5IOJcwKxoq7VtOu34XcJK+NCWLSp8aLs5lQfEiHp90boB4veyraDxt1fHGwZh4wbv62O3t0o
	vApgCeQJnOTZAKhpIiSTPYbe7Od/qwcc7UJ1eZFeN6kZ1L9ctUdHlGhXvNQiKjuc6XKq7UZ76Vx
	ulg4/03nE5so6UHPGvJas9tZeAAUOlyWPmm6mwMoPQ==
X-Received: by 2002:a05:7022:3a08:b0:160:a80f:3ed2 with SMTP id a92af1059eb24-195c44b9d5amr665757c88.10.1792706130183;
        Thu, 22 Oct 2026 14:55:30 -0700 (PDT)
Received: from fred-server.tail1cd3ef.ts.net ([166.198.37.113])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195e9e9c4c7sm1006434c88.4.2026.10.22.14.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 14:55:29 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: fix early procfs exposure race
Date: Thu, 22 Oct 2026 21:55:06 +0000
Message-ID: <20261022215506.31619-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
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

Currently, init_cifs() calls cifs_proc_init() near the beginning of
the function, before INIT_LIST_HEAD, leading to a momentarily
uninitialized, but exposed, procfs. If a userspace process reads this
empty procfs, iterating over a zeroed list_head leads to a NULL
pointer dereference and a kernel oops/panic.

For example, if a delay is added between cifs_proc_init() and
INIT_LIST_HEAD, and a userspace process is polling
/proc/fs/cifs/DebugData, the following oops occurs:

BUG: kernel NULL pointer dereference, address: 0000000000000608
PGD 0 P4D 0
Oops: Oops: 0000 [#1] SMP PTI
CPU: 0 UID: 0 PID: 3477 Comm: cat Not tainted 7.3.0-02212-g4df4d2a577db-dirty #6 PREEMPT(lazy)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 2025.11-3ubuntu7.3 09/23/2026
RIP: 0010:cifs_debug_data_proc_show+0x103/0xd80 [cifs]
Code: 00 31 d2 eb 25 48 89 df 48 c7 c6 4b d4 67 c0 e8 a3 12 f5 cb 48 8b 54 24 28 48 8b 6d 00 48 81 fd 28 3b 60 c0 0f 84 34 0c 00 00 <48> 83 bd 08 06 00 00 00 75 e5 ff c2 48 8b
4d 38 48 89 df 48 c7 c6
RSP: 0018:ffffb603c03c7c38 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff950240d3f2a0 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffffc0672ab7 RDI: ffffffffc0603ad8
RBP: 0000000000000000 R08: 737265767265530a R09: 203a737265767265
R10: 6552205346562065 R11: 203a737473657571 R12: 0000000000000000
R13: ffffb603c03c7d68 R14: ffff950240d3f2a0 R15: 0000000000000001
FS:  00007fdae19d9b00(0000) GS:ffff95032d4bb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000608 CR3: 000000010638e001 CR4: 0000000000370ef0
Call Trace:
<TASK>
 ? seq_read_iter+0x86/0x400
 ? seq_read_iter+0x86/0x400
 seq_read_iter+0x183/0x400
 proc_reg_read_iter+0x62/0x90
 copy_splice_read+0x215/0x310
 splice_file_to_pipe+0xec/0x1c0
 do_splice+0x4b8/0x780
 __se_sys_splice+0x18f/0x250
 do_syscall_64+0x109/0x330
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
</TASK>

Fix this by moving cifs_proc_init() down in init_cifs(), ensuring it runs
only after all internal lists, locks, counters, and workqueues are fully
ready, but before registering the filesystem. Update the error cleanup
ladder and exit_cifs() to maintain proper LIFO order.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/cifsfs.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 576155caf888..1880d5134b1e 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2019,7 +2019,6 @@ init_cifs(void)
 	if (rc)
 		return rc;
 
-	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
 /*
  *  Initialize Global counters
@@ -2069,8 +2068,7 @@ init_cifs(void)
 				     WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_PERCPU,
 				     0);
 	if (!cifsiod_wq) {
-		rc = -ENOMEM;
-		goto out_clean_proc;
+		return -ENOMEM;
 	}
 
 	/*
@@ -2162,19 +2160,22 @@ init_cifs(void)
 	if (rc)
 		goto out_cifs_swn_init;
 
+	cifs_proc_init();
+
 	rc = register_filesystem(&cifs_fs_type);
 	if (rc)
-		goto out_init_cifs_idmap;
+		goto out_clean_proc;
 
 	rc = register_filesystem(&smb3_fs_type);
 	if (rc) {
 		unregister_filesystem(&cifs_fs_type);
-		goto out_init_cifs_idmap;
+		goto out_clean_proc;
 	}
 
 	return 0;
 
-out_init_cifs_idmap:
+out_clean_proc:
+	cifs_proc_clean();
 	exit_cifs_idmap();
 out_cifs_swn_init:
 #ifdef CONFIG_CIFS_SWN_UPCALL
@@ -2210,8 +2211,6 @@ init_cifs(void)
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
-out_clean_proc:
-	cifs_proc_clean();
 	return rc;
 }
 
@@ -2221,6 +2220,7 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
+	cifs_proc_clean();
 	cifs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
@@ -2243,7 +2243,6 @@ exit_cifs(void)
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
 	destroy_workqueue(cifsiod_wq);
-	cifs_proc_clean();
 }
 
 MODULE_AUTHOR("Steve French");
-- 
2.53.0

