Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690783;
	b=PNSFkTQOe5M3xvOqMAyXx5iEneqh6YBBixjFyRdAE/f1yY28I+T20mp6Huvzly3CXGFb
	 tsEekYXhMglQsMmZFcHEDbNLCT7IPTInmnCPxqoa0aZJXjE4Yng3oPyJ5vhRvfk8qbNGN
	 4g7GrWReynqaHggYse1qXFZcXevREQzDv/NjOIxs/3e6rZ8d/VNho4KDsF37AnMo59+5x
	 4acY9FWd63rSRAuXa8G7rJW8UxQ2ryHu67kBtB804xqhyVWPMzPGNCFqMmPpTKTOz2jip
	 I4MOHunAuaCWKSbN2D4N8zvpyryH/z/InACkYAz5+dYphUTiUsXYOjlBCf3v1G68RbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690783;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=i/noOztbS2t6WZeL5Ffb7JJaj+8g0AIhxEQ+LUXgBF4=;
	b=Qz0Od3GoeQmiVHZSM1kjWPN3N7P04ri41ErOpOi3CAufJUWl5h80kz/k6F9bzLwTiWuh
	 rcdJn40PBbZcpOJEt3MLsKgol6sw0pn7OKGP/+GL1Rg9+gRAIXAhuTS2vCQyEFiASK0TM
	 zWFvx4w5ZyTbO9PHIJTxb+pASCfQhiTCXD3X1X2Fze5ZqDo5+6HmTEf54hO07M0z3Vpi6
	 /60+Y1018UeJGvKpXxQw3myhCOl0Is2+m1iMoZchFlcS6RyNNlJzFZpOYeXEO00Fxbok0
	 ggZ7ZyF5SlgDJRs8p4mdhScTqlOBVzbH8j+i+58LUPCh1CpRJz5lySBQ4ofoHlpmX6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=r9foKYqO;
	arc=none smtp.remote-ip=74.125.227.138
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55169606A31F
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 17:39:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55169606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=r9foKYqO
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2e934c6c1c8so25535ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792690781; x=1793295581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i/noOztbS2t6WZeL5Ffb7JJaj+8g0AIhxEQ+LUXgBF4=;
        b=r9foKYqOLCGeFTWsNvX1SY7qNK0YpcGUhWiUzillccvc067Z5eH6LNl1BhiJzf5SNl
         zXBGTeEhMW4lJVEw2Mt3BH8S2TjxK3PUm8ID7dH78sVgcw3V3MuoJ6y8aBUSOrxHXHGH
         2tvIdn4LUOeB6tjGY/3DNzq8GgSw9KXRIuH0On/gjKlU2OnvpwfBO1AYGXehQPx9YMvK
         x1lWssudXhYG9jZJpALKTl/+K/E8M/pTBiKYjObzYiQnf/cmQPZ/bENQEY7lNruaOHIL
         iLVL8L8dYgmID8Cfr9KkA0JmxitOA693A5HtpscmxuLcNrjMkuDYsmMiUtZkYvR+l4dA
         iCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690781; x=1793295581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i/noOztbS2t6WZeL5Ffb7JJaj+8g0AIhxEQ+LUXgBF4=;
        b=PRHxc9r3MvPB/Llp48sVjOC7tcuUBjhoS7VyBVFS0V1IL1sGq3Bvz6b41ZZjO2dr1e
         vdZQhppK2HQa9BNXbTmj2qUNL90wvQvgJyqS+Nf//ntMuDrCI6DDKq+xoAzDQAQXJUqz
         tD28u0KHZAoknuQieNjGki2I7Tq4x8Ky9732EQtr1RIeY63RvAl5x+Wi6jAJhsnz+PZY
         HS28VEr9HtCG3vtJonoWnfoT1cD36kYAB2ZbHgakLJCfnQpkxigjL9fPKCsDzeHLFEuB
         FazvMRA4mWZFcR3WqgQxb2BAj+jvc9AfYRAmjEIkgT081bG7s39NZC1/pDuOSwYtOGqf
         Vv2A==
X-Forwarded-Encrypted: i=1; AKwUvBx0dXM4vKzhVziRHPEqJ2vmc5H4pyTokuIudr9Uyya7uqOt8dlZcP1wTHL9Wdz8f+pqnvoCdKGvwHfa@vger.kernel.org
X-Gm-Message-State: AFq9FYJuOaVaCMYtDcmgBi/IUbxpBqsYjFy5ARTPM/OfYOzPcbJqnqqu
	z3oJDEvdHXu8HuTZ4gKXBkfZO5y0e2MGUUOBCmm6DqHRPvnRAVal11qE
X-Gm-Gg: AYBFou1GWPvLZ+X2FYx38g8ojdgPXL0UpenuWEacx87kI1afxkuLDBHZKQtISbXDEfN
	w/G7t2BVbxhhimZCWFCPsjDgubElkAmvU3h3l+0D200YQv0YJqbKDDuriynf1b3uoDUbGfG2hJB
	O8jX0vCXw2u2wC+gwX+r0KhbUUHFKyio5/RO3NccceQlZ4FL6ltO5EMEMBrckzTyF8I3o2p9TqL
	4KuyecxXTMYWhlPyxxkKxZrx/Nfyukhc/8ON0FMMJWHZsYTxXgC3yZGSIgozKLdxwC40yNEMjMD
	KzjzWDN8kgz5Cm0G+D1PfILeWKkZYr4ExmVgTs51/4qcK/8OWgQqDqmJAyt3C2PMLbDMQs/ttag
	y9dwloxy0k5rHaP61hO9g70nGLQcKkLSG7kr6f576gVRQ6Wqo9z4ENRqte/abcgH8gcDzj/aPUK
	4WdtbNBQ4+Y+zxgVfvAdTLsQbCa92PFqvDRRIfYcb2IOnsl8KQsysv2sCwyzOobph94TNqrLTH4
	lJLkvV0+Twsn0Y/k5G8xuHkC2TxF2/nlq8yM5L9PhV9fc7WE/ZFPJOCIBnxZWK05aiBUHMVWY8d
	XFjk
X-Received: by 2002:a17:903:4b0e:b0:2e9:a166:f7fe with SMTP id d9443c01a7336-2ea440a4ec4mr51883235ad.62.1792690781547;
        Thu, 22 Oct 2026 10:39:41 -0700 (PDT)
Received: from localhost.localdomain ([121.128.174.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7b3d15ffsm1483045ad.56.2026.10.22.10.39.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 10:39:41 -0700 (PDT)
From: Yongjun Gwon <d3bugee@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: serialize directory emptiness checks with readdir
Date: Fri, 23 Oct 2026 02:38:32 +0900
Message-ID: <20261022173832.14696-1-d3bugee@gmail.com>
X-Mailer: git-send-email 2.55.0
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

SMB2 QUERY_DIRECTORY holds fp->readdir_lock while it calls iterate_dir()
on fp->filp. An SMB2 SET_INFO request with FILE_DISPOSITION_INFORMATION
can resolve the same FileId and call ksmbd_vfs_empty_dir() on the same
filp without that lock.

iterate_dir()'s inode read lock permits concurrent readers and does not
serialize per-file iterator state. ext4 stores its dx readdir cursor and
fname RB tree in file->private_data. Concurrent reset or refill can
therefore free a fname node while the other worker still traverses it or
retains its RB-tree link, resulting in use-after-free accesses.

An authenticated SMB client with list and delete rights on a directory in
a writable KSMBD share backed by ext4 can trigger this when the directory
takes the dx readdir path. The client overlaps an SMB2 QUERY_DIRECTORY
request with an SMB2 SET_INFO request carrying FILE_DISPOSITION_INFORMATION
on one live FileId.

In one x86_64 SMP KASAN multi-shot guest using ksmbd-for-next at
171df27077fb, the unmodified kernel reported a cross-worker use-after-free
before a panic. The first report's access and free stacks show the two
request paths directly (trimmed):

  BUG: KASAN: slab-use-after-free in ext4_htree_store_dirent+0x488/0x550
  Read of size 8 by task kworker/2:0/29
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   ext4_htree_store_dirent+0x488/0x550
   htree_dirblock_to_tree+0x535/0x990
   ext4_htree_fill_tree+0x319/0xba0
   ext4_readdir+0x175a/0x2f40
   iterate_dir+0x1b6/0x630
   smb2_query_dir+0x1003/0x1cc0

  Freed by task 279:
   free_rb_tree_fname+0x67/0xc0
   ext4_readdir+0x13a9/0x2f40
   iterate_dir+0x1b6/0x630
   ksmbd_vfs_empty_dir+0xa2/0x100
   smb2_set_info+0x2ffa/0x45d0

Take fp->readdir_lock across the entire emptiness check. This places both
iterators over that handle's filp in the same lock domain while
preserving the disposition status handling. The exact code change
completed a warning-free x86_64 KASAN bzImage build. Tracing three request
pairs showed that the two iterate_dir() calls no longer overlapped and the
expected statuses were preserved. A further 1,600 reproducer iterations
completed with expected statuses and no KASAN report, Oops, or panic.

The reproducer and complete guest configuration are available privately
to maintainers on request.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Yongjun Gwon <d3bugee@gmail.com>
---
 fs/smb/server/smb2pdu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da82d80..f5fe3cf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8918,6 +8918,7 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
+	int err;
 
 	if (!(fp->daccess & FILE_DELETE_LE)) {
 		pr_err("no right to delete : 0x%x\n", fp->daccess);
@@ -8932,9 +8933,13 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 		if (ksmbd_has_stream_without_delete_share(fp))
 			return -ESHARE;
 
-		if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp) &&
-		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
-			return -EBUSY;
+		if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp)) {
+			mutex_lock(&fp->readdir_lock);
+			err = ksmbd_vfs_empty_dir(fp);
+			mutex_unlock(&fp->readdir_lock);
+			if (err == -ENOTEMPTY)
+				return -EBUSY;
+		}
 		smb_break_all_levII_oplock_for_delete(work, fp);
 		ksmbd_fd_set_delete_pending(fp);
 	} else {

base-commit: 171df27077fb49b4af2c53ad2cedcd0e39664fe8
-- 
2.55.0

