Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794841471;
	b=iR/OPI4lRpxnUwDRT4laVSyvdwQMIkJW7GdImmLIKrsIUKbOp6Yjp0vVPuACeAA7pKIo
	 olSznz0KArheWt1yE3NhG1jOcW24UOJrQmkaR3AcfInENlgvXq7M8vvE9Ih21mYj0t9jy
	 Za01eAfMbq0KHAIjjCTekjRRHngUBEjxkOjaUKiFtdycUyvtHhohZqWsCu0y6gxqgja8G
	 iL1s8F0LnbG2V5O14buy77MaytmC/2dPjGKyE1p/CInrZHvHDmZ9WPKC65VZY03e6DfHV
	 cL+U2JXnNZVzPWI+9hGUiNsNIwVV4xJQqDTBI+wfkx+ZyllV0xpnu+iO613iGN4AdYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794841471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MvTRqL1mdtM+813rBnpKCpEGBrHo1i50Gwhh8qIKRW8=;
	b=TofH/+cBJvJ7qsnrN7SH/a/CQFuqGkGNbWk/YKz9draH8WMrNoAyUE6srsGlXdI+OOEk
	 nnzIJ2iq0O/oLuWdCfbtijNMoQg4GpXUBZN4sj27ClUcHMZscWCmrB+Bh2SJCcn5142yz
	 WnHP0kcBQrH9IqMbkefHQyecp18XWm3YS4s8YSRG56BSo7HxQoKKejD2yp20RAxpztrpj
	 aVBa1rAC+Hb1eQkSi7t368rqFAxCBMN/PSO2AxNL9IM2joJnoOmZWjZyi8bPxSmGd8FI2
	 cxzVlOTDi9SqzsLe2EP1EbNZCDLupqEWgL9Xjvrpr5YmKkOTJcLajDKHDyY7tKfOViQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w6wz4DzJ;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7895606A88B
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 15:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7895606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w6wz4DzJ
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36dbde64409so5183993eec.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 07:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794841467; x=1795446267; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MvTRqL1mdtM+813rBnpKCpEGBrHo1i50Gwhh8qIKRW8=;
        b=w6wz4DzJ/F/IIzt0So0o/kHRzp5pszNlPly2C1qgvQJqxUvtvJ2oG6GdouS1L1wY36
         X68f4CN1XT0294VaGFL+8fYBxwe+dyWG+ciakFNSRbD9YRL7vGMwwXOoign2edE150+i
         0oRYSsDNgPvCYF3apJ38dM2bH9FlK16fNxfKchmjvNlfwnOH8aQSVOb/Vobm7G/AIbyY
         PYGtR9jpc5tpbNl94iruCWA/zAWjPQzlP/lYsLK1iwiEGYSEi0XnO9yUu8VY0n9aJ1uo
         1ULcIEcOKquvSqs4wOm3PBI164S6OZBfVKtar5ZvxcR4Gs7+zoKILtg6Mm3Ckj58PcrD
         FhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794841467; x=1795446267;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MvTRqL1mdtM+813rBnpKCpEGBrHo1i50Gwhh8qIKRW8=;
        b=Rj5nWfkmDUzQ19rH2u8dMDOF4Q+3OEcZZlynsYshNXEAjzi/5PtXaVuUIbE6j2/0Kd
         vSi0BTBRRlf5LT67iClfOldAT+4DDPVbk0/iDtLvLig1VwOYYzNL+tjVPGRcirxKWXSE
         uwh/ex+BrNl+BhLncNdR/0iXMLLz1amghIjJc5MLaP8qg1UXw2qbLcielVqsaGw17bfY
         CFRePNS3iA30BbRIp/XMDhLMVpe1Tb31whZVDzHMte6kkh8G1vzyFgRhckl3vR1wjM9f
         qf3LJATAMTMSJfyJfzTqI6KrJjNJCTrrAMi4qeOnTSRYnAcGk37DcVdNGINEqUPhW06o
         6SIw==
X-Forwarded-Encrypted: i=1; AL+hErHlas853/B8It041PqSIf6ofgX0Xt7Z9ypExrl2R3j/pugky6swNVMuYvNDIGd6CDPXtlBtlBGF6Mv3@vger.kernel.org
X-Gm-Message-State: APuU4Z9KQa6bYJsiXcNhMX4E/kcoyWh/lymzxhwp6+CsMIdXUkCzRtrc
	molZAD4YndtRPaffe5Id+BA4cAAXC1tV9GsNUgXYWiDzdbmyWZT9cjNB
X-Gm-Gg: AZFdTZewGg84pMLhfTQJwuGxzWCRp63JkawAlt2NwDQJW/1i4OkNucZpLNR5QgtIlme
	q6dwUYzuvpSKfuLKwwBTOUpscP3iZgIVpl67EgV22HX67XaHBjTSRPiPE3sXgNtPg9UrVo3vOo1
	Wrj9/oSaCkYj10znYbx4+sQfV6UgHznIsuzh+YAx/ZihyiAdeKhqEI7AAkF0m/SIn6IlyQlaAnM
	8/HMicfjAhC1d3LrIg+rKLLFMpz22dG8wkSdn7gvl2nSY1KVk2lx4jre6+aeV/soEvEO3RvZ4LM
	Gc5gtBzT5scLT6Rh3c9nTsngYmTLhRo7nYhv02+fvxCDlX1C93cRkl4+LuMFTusQcUy8xVg1dZO
	JnsQrMf2S5L90Mtz3P27imS8LSgOgYyd+e/fuoC1KZCPfomuNn41aiHnYS8iqBx9COnTdZmeQH+
	YvD5Tehk5O42nup101NVoKPXWQ+AtyGibML7xPn2gxtGz4Lk3XEtr4O5WQ8NvonjSqL+c9+IZtU
	m0sQv0vESV89lhFjz4V8zyuRCsfnV27legn0P+CgnRKySNjjM91MKbfPsH0+P3RHyCJ+GS++3iz
	9ft1y/TuZTOZK6CraKHpS47qifibjJmV283dWO5qejq8C8sNatGiwxW3Ykh/nYTzNih9KUIyfIA
	RDA==
X-Received: by 2002:a05:693c:8108:b0:376:5b99:a7e3 with SMTP id 5a478bee46e88-37963660626mr10679088eec.3.1794841466625;
        Mon, 16 Nov 2026 07:04:26 -0800 (PST)
Received: from dell (ec2-13-229-224-160.ap-southeast-1.compute.amazonaws.com. [13.229.224.160])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bb0c40sm37141083eec.28.2026.11.16.07.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 07:04:21 -0800 (PST)
From: Yuansheng Yang <0xbeac@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: pin parent dentry in maximal access check
Date: Mon, 16 Nov 2026 23:04:11 +0800
Message-ID: <20261116150411.321076-1-0xbeac@gmail.com>
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

ksmbd_vfs_query_maximal_access() reads dentry->d_parent without holding
a reference to the parent.  smb2_open() calls it after path lookup has
returned without the parent inode lock.  The AppInstanceId takeover
path also calls it on the old handle's filp->f_path without holding
that lock.  A reference to the child dentry does not pin its old parent
across a rename.

A concurrent rename can therefore move the child to another directory
and drop the last reference to the old parent.  If the old parent is
then removed and freed, d_inode(parent) reads the d_inode field of a
freed dentry.  If the sampled parent has become negative, passing its
NULL inode to inode_permission() can also cause a NULL dereference.

KASAN caught the following on an x86_64 QEMU guest with a test-only
100 ms delay between reading d_parent and d_inode:

  BUG: KASAN: slab-use-after-free in ksmbd_vfs_query_maximal_access+0x2ba/0x300
  Read of size 8 at addr ffff8881100f0830 by task kworker/2:1/81
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   ksmbd_vfs_query_maximal_access+0x2ba/0x300
   smb2_open+0x60d5/0xec30
   handle_ksmbd_work+0xad4/0x2110
   process_one_work+0x745/0x10f0
   worker_thread+0x511/0xc80
   kthread+0x330/0x410
  Allocated by task 319:
   __d_alloc+0x35/0x860
   d_alloc+0x46/0x1f0
   lookup_one_qstr_excl+0x171/0x250
   filename_mkdirat+0xba/0x4c0
   __x64_sys_mkdir+0x6a/0x90
  Freed by task 81:
   kmem_cache_free+0xb8/0x3b0
   rcu_core+0x549/0x17d0

The read is 48 bytes into a freed 192-byte dentry, which is exactly the
d_inode member.

Commit 2e450920d58b ("ksmbd: move oplock handling after unlock parent
dir") released the parent lock and reference before the final MXAC
query in smb2_open(), leaving this helper's bare d_parent access
unprotected.  Commit 4e45cca31d4e ("smb/server: add
ksmbd_vfs_kern_path()") later switched the earlier open path to an
unlocked lookup, exposing the MAXIMUM_ALLOWED query as well.

Commit 0383a66dabd7 ("ksmbd: pin parent dentries in SMB2 CREATE ACL
path") fixed the same race class in smb2_open() and smb_inherit_dacl(),
but did not cover this helper.

Take a parent reference with dget_parent() and hold it across the
permission check.  If the parent has no inode, leave FILE_DELETE unset.

OpenAI Codex assisted with reviewing the fix and revising the changelog.

Fixes: 2e450920d58b ("ksmbd: move oplock handling after unlock parent dir")
Cc: stable@vger.kernel.org
Signed-off-by: Yuansheng Yang <0xbeac@gmail.com>
---
The parent lease break sites in oplock.c are covered by a separate fix.

Testing used an x86_64 KASAN QEMU guest based on 7e1392a42ea2 with
0383a66dabd7 applied.  An SMB client issued MAXIMUM_ALLOWED opens while
a local process in the guest repeatedly renamed the child and removed
and recreated its old parent directory on tmpfs.

A test-only mdelay(100) between reading d_parent and d_inode triggered
the UAF within three open attempts.  With the fix, the same delay was
placed after dget_parent(): 789 open attempts completed, including 561
successful opens, without a KASAN report.  The delay is not in this
patch.  Without the delay, the unfixed kernel did not reproduce the
issue in 67,381 open attempts over 300 seconds.

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7c3edbe6cb77..0f68500183d7 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -124,6 +124,9 @@ static int ksmbd_vfs_path_lookup(struct
 void ksmbd_vfs_query_maximal_access(const struct mnt_idmap *idmap,
 				   struct dentry *dentry, __le32 *daccess)
 {
+	struct dentry *parent;
+	struct inode *parent_inode;
+
 	*daccess = cpu_to_le32(FILE_READ_ATTRIBUTES | READ_CONTROL |
 			       SYNCHRONIZE);
 
@@ -139,8 +142,12 @@ void ksmbd_vfs_query_maximal_access(cons
 	if (!inode_permission(idmap, d_inode(dentry), MAY_OPEN | MAY_EXEC))
 		*daccess |= FILE_EXECUTE_LE;
 
-	if (!inode_permission(idmap, d_inode(dentry->d_parent), MAY_EXEC | MAY_WRITE))
+	parent = dget_parent(dentry);
+	parent_inode = d_inode(parent);
+	if (parent_inode &&
+	    !inode_permission(idmap, parent_inode, MAY_EXEC | MAY_WRITE))
 		*daccess |= FILE_DELETE_LE;
+	dput(parent);
 }
 
 /**

base-commit: c710c654b8a3c92b34e38740dc17c29daf5b222e
