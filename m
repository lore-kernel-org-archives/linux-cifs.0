Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0122D7BF;
	Wed,  6 Aug 2025 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754486633; cv=none; b=GGl8myhNlQBpH2MnHf9PwuI8wynEzxB6epSPt65E7hw3F6B48gkzOG3deAAieVDBDEYeqbaEgC1dTXZL9lQY47HR5uofJfBJwtuEB8NPZohLTyOzPG0+sD5OExMXnR/QZtBSx6U7CROUSkgzrl3UPPyQZW8Bk8li5KfmAFNY/ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754486633; c=relaxed/simple;
	bh=yp2hRT4Xo+ztxRvI7HeplkR/VFn3RG+IanX7yIuTJKo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KKRhkrUF/tVLmoMC08Gy4x4XG39PjTTY86ag4nHlCldf5X/5jbfFIPdlcjOGTaOf2hwJ04Zeo2EUAEOLNeF0kc+IRh1YGhdZs9Gbkjh1pZrjLywaC58jNzeri6AMZwMFOUAH+PTRKHNKLEhupchR7IMxCIT1NdN5m1IBGMyxAsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24050da1b9eso8126815ad.3;
        Wed, 06 Aug 2025 06:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754486630; x=1755091430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8BaH77pTATgomb0f+TIsMr75eWE+v8rXetnzgd5rHns=;
        b=JRqntDyAcBql07+do4MoFWQVH1NlJJIfU6kESFW4l8Vlzc2z5PHdEURMS6vMcUPrgI
         ocuG97mI9CxUXduRCLTfEDw+V0LKZrAx9lDTFOy0K2qUFz5xFePlMT2zR9J/AU+hTbrd
         6/YOAIs88Anf/lTCOLVpAQfDR5pE+WiHUjtHrMvLAMztPcGqVae+z97up46hzTKt0ZIC
         5trseKk6qP8cCt4uBEgrv0wUy8R+UMWcd3gv9VPj9tLn2yncgftfEjazcqNpv/umL3qr
         /MV5dtiU+RJ6AtCkWR7fyD0Lb2uLzrzRI3xBl+Li841hlrlzzK9hD33H6gtQeoJ9aVoN
         MGLA==
X-Forwarded-Encrypted: i=1; AJvYcCUnQBmQWLOXxO4hdvtwJ0SGppBlxp8EXVw57zc2ZIH6GxlcVjB7Nr09iV4eSpddTnKzGaqQnsSfjE/p@vger.kernel.org, AJvYcCX60tHezYTcbWjhP5atqylhlZ2nqoTvK5jqtU657iIJ8IzM/cT35SZXGv0T0xhP37BZSqSKet/dCbMt1X/n@vger.kernel.org
X-Gm-Message-State: AOJu0YwvhkpwVLaIiKP+z+ofb9In38km4i24D6B8IZzKro7PguPI97U5
	CGrrW/gs9hF3n4DYK6jchtLHCtjLU54Zx8tRhNSj33vKNcGk90u1mLBC
X-Gm-Gg: ASbGncviVLl6qFrBlwCHsuMLTCbNJ3VcdAUpclTfiVAQmnOAjvrJZmpxUfkrq6TmhVq
	ZNwEBR5O4F9GEBoWDWFLSoLsLI165GmXyMLhT8imFUJ61EH9bOtfyDWkcT0BZv8urjVcFD/hRaW
	+Mq0BV8N/hgtwWbCErPxWsKV6vdcHxNexXEYu+4oiKrqlwknLfF3lEhKeyTJqMUPod9xr9VS5jo
	EOgO0Z6tAq06S6e09ShWAJzHlO7N0fg68XXgZmSicRbK+VgYjeQGiR/L+pdUEz0dzVVjh/Hvh6T
	by9emVwagnn8gnUZ57jayqsfbSF6mEnzx8SlxECzDqhszabP2XSDWKlx8gaYAAR7dIWqd9U6A5R
	kubSiBXme35ul
X-Google-Smtp-Source: AGHT+IE4TcwdrU6bM5i5hIrrZz+iLVM3raL5GuRMMILGR4J/MfMACcLYUJrF6k1kLQwalUqcEQ7tpg==
X-Received: by 2002:a17:902:c40c:b0:240:4cf6:b07b with SMTP id d9443c01a7336-2429f5c32e8mr22341975ad.9.1754486629916;
        Wed, 06 Aug 2025 06:23:49 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef7557sm158126335ad.19.2025.08.06.06.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 06:23:49 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>
Subject: [PATCH] cifs: Fix null-ptr-deref by static initializing global lock
Date: Wed,  6 Aug 2025 13:22:12 +0000
Message-ID: <20250806132211.94686-2-ysk@kzalloc.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A kernel panic can be triggered by reading /proc/fs/cifs/debug_dirs.
The crash is a null-ptr-deref inside spin_lock(), caused by the use of the
uninitialized global spinlock cifs_tcp_ses_lock.

init_cifs()
 └── cifs_proc_init()
      └── // User can access /proc/fs/cifs/debug_dirs here
           └── cifs_debug_dirs_proc_show()
                └── spin_lock(&cifs_tcp_ses_lock); // Uninitialized!

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
Mem abort info:
ESR = 0x0000000096000005
EC = 0x25: DABT (current EL), IL = 32 bits
SET = 0, FnV = 0
EA = 0, S1PTW = 0
FSC = 0x05: level 1 translation fault
Data abort info:
ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
CM = 0, WnR = 0, TnD = 0, TagAccess = 0
GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[dfff800000000000] address between user and kernel address ranges
Internal error: Oops: 0000000096000005 [#1] SMP
Modules linked in:
CPU: 3 UID: 0 PID: 16435 Comm: stress-ng-procf Not tainted 6.16.0-10385-g79f14b5d84c6 #37 PREEMPT
Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/2025
pstate: 23400005 (nzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : do_raw_spin_lock+0x84/0x2cc
lr : _raw_spin_lock+0x24/0x34
sp : ffff8000966477e0
x29: ffff800096647860 x28: ffff800096647b88 x27: ffff0001c0c22070
x26: ffff0003eb2b60c8 x25: ffff0001c0c22018 x24: dfff800000000000
x23: ffff0000f624e000 x22: ffff0003eb2b6020 x21: ffff0000f624e768
x20: 0000000000000004 x19: 0000000000000000 x18: 0000000000000000
x17: 0000000000000000 x16: ffff8000804b9600 x15: ffff700012cc8f04
x14: 1ffff00012cc8f04 x13: 0000000000000004 x12: ffffffffffffffff
x11: 1ffff00012cc8f00 x10: ffff80008d9af0d2 x9 : f3f3f304f1f1f1f1
x8 : 0000000000000000 x7 : 7365733c203e6469 x6 : 20656572743c2023
x5 : ffff0000e0ce0044 x4 : ffff80008a4deb6e x3 : ffff8000804b9718
x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
do_raw_spin_lock+0x84/0x2cc (P)
_raw_spin_lock+0x24/0x34
cifs_debug_dirs_proc_show+0x1ac/0x4c0
seq_read_iter+0x3b0/0xc28
proc_reg_read_iter+0x178/0x2a8
vfs_read+0x5f8/0x88c
ksys_read+0x120/0x210
__arm64_sys_read+0x7c/0x90
invoke_syscall+0x98/0x2b8
el0_svc_common+0x130/0x23c
do_el0_svc+0x48/0x58
el0_svc+0x40/0x140
el0t_64_sync_handler+0x84/0x12c
el0t_64_sync+0x1ac/0x1b0
Code: aa0003f3 f9000feb f2fe7e69 f8386969 (38f86908)
---[ end trace 0000000000000000 ]---

The root cause is an initialization order problem. The lock is declared
as a global variable and intended to be initialized during module startup.
However, the procfs entry that uses this lock can be accessed by userspace
before the spin_lock_init() call has run. This creates a race window where
reading the proc file will attempt to use the lock before it is
initialized, leading to the crash.

For a global lock with a static lifetime, the correct and robust approach
is to use compile-time initialization.

Fixes: 844e5c0eb176 ("smb3 client: add way to show directory leases for improved debugging")
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 fs/smb/client/cifsfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 31930b7266db..3bd85ab2deb1 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -77,7 +77,7 @@ unsigned int global_secflags = CIFSSEC_DEF;
 unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Lock */
 unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Lock */
 unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Lock */
-spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ entries */
+DEFINE_SPINLOCK(GlobalMid_Lock); /* protects above & list operations on midQ entries */
 
 /*
  *  Global counters, updated atomically
@@ -97,7 +97,7 @@ atomic_t total_buf_alloc_count;
 atomic_t total_small_buf_alloc_count;
 #endif/* STATS2 */
 struct list_head	cifs_tcp_ses_list;
-spinlock_t		cifs_tcp_ses_lock;
+DEFINE_SPINLOCK(cifs_tcp_ses_lock);
 static const struct super_operations cifs_super_ops;
 unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
 module_param(CIFSMaxBufSize, uint, 0444);
@@ -1863,8 +1863,6 @@ init_cifs(void)
 	GlobalCurrentXid = 0;
 	GlobalTotalActiveXid = 0;
 	GlobalMaxActiveXid = 0;
-	spin_lock_init(&cifs_tcp_ses_lock);
-	spin_lock_init(&GlobalMid_Lock);
 
 	cifs_lock_secret = get_random_u32();
 
-- 
2.50.0

