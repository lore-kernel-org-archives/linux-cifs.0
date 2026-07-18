Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B65F4D8CE
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 00:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784334094; cv=none; b=svP7qgVrSBx30MIrMc2s/yBqoXckWKGf7xM1bpfdXjGaALaj8CA/Tdw96yXbUGoDfn5NnQXHoeJFd+5MYIfgTsvZfgmEZfKUpXogbJi2vq43Ak9Bh3OQ3bz/0WfazHzzJWwrG4agaHU4AYtw5KX/9iNqEZsqITHXB9ST3viynlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784334094; c=relaxed/simple;
	bh=2hTqbl2nmK3iQi785rYhFhyc/sNiduJ1yowKNrGBJ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RLiw71XjNu5xzKU9fjGNR9KayYU8mhwLYp866P8xPxvr6ldSAI+Pa+IbQS5MBnjpvdOfAHqQDWQcKbugjp6DjKKf76bZxhpXBbPngq7DAqsIBx2KCxgMZo0Rb9QobhSTlsVe+x27qyKZmyXpx7tfxxz2ruE6ZMVAo244/1bZcIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com; spf=pass smtp.mailfrom=artiphishell.com; dkim=pass (2048-bit key) header.d=artiphishell.com header.i=@artiphishell.com header.b=aBkl6MhL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=artiphishell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=artiphishell.com header.i=@artiphishell.com header.b="aBkl6MhL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ceae1ed204so61148205ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 17:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=artiphishell.com; s=google; t=1784334090; x=1784938890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8uLK8YR1msEi6equJYkUjd7anLC80xXw6SAB94F6up4=;
        b=aBkl6MhLHgZ7Wj/r1r5wGQXFRYW5D/728f+QjaLSljFV77okndCT2zkG7LDkxgp4hu
         wz1brSs/1VDJBugcUMLsK9vEM4ai24C1GVpvpO+huCGrPhcfGmbFbeq/tGseBSiE2hK1
         Qw3iaPPSjRbD7n+yeY3SpQLI3QhEOVQW1IVKBZwOC/bkI9SyNND8N9PPRjxPruf7gqER
         usA88hK6G5yzM/jNJmnU3h8bXovRUdzW4OSMlT0dGdbGL7ilI/JnBf4rAJ7zG47InBzw
         de7ktNvzuZPMDi4qeC5oSUv3dP8IpknwNEUhnPxQd5FfPI5FIPy18z2D5LrQEd9Fzz8p
         suYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784334090; x=1784938890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uLK8YR1msEi6equJYkUjd7anLC80xXw6SAB94F6up4=;
        b=OzJaO+5JLIPWs08hfI1OqTFas4mcisKNlCyviLzxPZSoxgFEoqX590Vrv/DjdM3XWP
         SEQYxGdkKVwaxaNtkKSvccJck28ecrmQIzGrZ2T/6XUlqvhuKvzpY1qPGy/pVA5LQLqj
         SyCLPJ729tknI5MMX6Bzzu+DxWhU0EOOY9XRa+9YSVdsPgsHbAT5du6U37it62qZO4cv
         d158J2cGmoJRVTEq3bipuGVoV2szR86ahlq8HIQWoALYtoZPqFO91GXkCRznfMG7Skn1
         8J0q0NpIJtnTwy7V4nfGL1TrJjfKV0yzZiK3ytrm8WJBNj6XRN9tuusm55gm3ZTg9Mlo
         MCtg==
X-Forwarded-Encrypted: i=1; AHgh+RqSbnUnyLVNaTJqRzOb8c+k3+nt7SjqSvwXVICfWMHz13ivngRyYRpxPAehHbFt0uAtnc1hdlkCRLPF@vger.kernel.org
X-Gm-Message-State: AOJu0YxzV8U4h39X1LCLnbVy3kNhn6eJyh77hBT3KFPV+XLG1ZKmtrhG
	LJdCAQetav51hCv5yP8sZ3JvuJAVkmbQK6wIa661tIxyjjnuFrSjqyT5jNY0kM+vChWAvmVWVuO
	2nPPngqq0
X-Gm-Gg: AfdE7claA50Vp3rCL9adSdY1+rG8w5Fs+u3HxQugSSJaKWrOFpIGqsM3YOzR8pCq6rw
	61uChTRQySRl5t7wLbr4/eXpBlAKfCYM+CplW29OfTjb5szdxcTdyf9dx9thmpXLZX4Oug4cyl3
	HbNwDLQhVeXn8nxW3eORM0JN/4O1Xii+xHQBPYrE4qYcPiBUZWe9ttlAUrcR1Q5u2ZPmIHfZlO2
	vI1M20N45iaVa7J3Db0JX+1eeWfdzqYaePJSSqklnjBu+kzY0zbL9h9XD6VIwEYOfJsnkqVzfLY
	ccJqxYw2sPVqJgKp3uNj8XU/uGKPunEmdTCtIWFR4hCF1loz23Mlf8jlWj6uc7lOIbdrzm2+qeS
	VibscpDEhBbVvUyf2JcHX9gE9IFrzF59fOgEPFhHBvtxqvjvROrepTr2XslVU9jXqjOFvYiT64f
	cFyIUY
X-Received: by 2002:a17:90b:55d0:b0:37f:9ce1:735a with SMTP id 98e67ed59e1d1-38e4b505f8amr5083639a91.27.1784334090406;
        Fri, 17 Jul 2026 17:21:30 -0700 (PDT)
Received: from nixos ([2001:579:62a8:47:d0f5:3653:252e:1041])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429fdbd45sm10840068eec.12.2026.07.17.17.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 17:21:30 -0700 (PDT)
From: Jay Vadayath <jay@artiphishell.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Jay Vadayath <jay@artiphishell.com>
Subject: [PATCH] smb: client: bound dirent name against end of SMB response in cifs_filldir
Date: Fri, 17 Jul 2026 17:21:22 -0700
Message-ID: <20260718002124.90753-1-jay@artiphishell.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_filldir() copies the entry name out of an SMB1 TRANS2_FIND_FIRST /
FIND_NEXT response using a length (de.namelen) supplied by the server.
The kmalloc'd SMB response buffer is bounded, but nothing checks that
de.name + de.namelen still lies inside that buffer before the eventual
filldir64() -> verify_dirent_name() -> memchr() reads namelen bytes.

A hostile SMB1 server that returns an oversized FileNameLength in a
directory entry therefore causes memchr() to read past the end of the
response slab buffer. Reachable from any user who can list a directory
on a CIFS mount served by an attacker-controlled server (getdents64()
on the mounted directory):

  BUG: KASAN: slab-out-of-bounds in memchr+0x71/0x80
  Read of size 1 at addr ffff88800e0640cc by task poc/115
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xce/0x620
   kasan_report+0xec/0x120
   memchr+0x71/0x80
   filldir64+0x4c/0x6a0
   cifs_filldir.constprop.0+0x9bb/0x1e00
   cifs_readdir+0x2101/0x3380
   iterate_dir+0x19c/0x520
   __x64_sys_getdents64+0x126/0x210
   do_syscall_64+0x107/0x5a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Pass the end-of-response pointer down to cifs_filldir() and reject
entries whose name would extend past that boundary.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace reproducer (an emulated hostile SMB1 server plus
a getdents64() client) that reliably triggers the KASAN report on an
unpatched kernel. The fix below was drafted with the Claude coding
assistant; a userspace reproducer is available on request.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Jay Vadayath <jay@artiphishell.com>

---
 fs/smb/client/readdir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -952,7 +952,7 @@
 static int cifs_filldir(char *find_entry, struct file *file,
 			struct dir_context *ctx,
 			char *scratch_buf, unsigned int max_len,
-			struct cached_fid *cfid)
+			char *end_of_smb, struct cached_fid *cfid)
 {
 	struct cifsFileInfo *file_info = file->private_data;
 	struct super_block *sb = file_inode(file)->i_sb;
@@ -973,6 +973,11 @@
 			 de.namelen);
 		return -EINVAL;
 	}
+
+	if (de.name + de.namelen > end_of_smb) {
+		cifs_dbg(VFS, "search entry name extends past end of SMB\n");
+		return -EINVAL;
+	}

 	/* skip . and .. since we added them first */
 	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
@@ -1194,7 +1194,7 @@
 		 */
 		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
-				  tmp_buf, max_len, cfid);
+				  tmp_buf, max_len, end_of_smb, cfid);
 		if (rc) {
 			if (rc > 0)
 				rc = 0;
