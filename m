Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E2179D2
	for <linux-cifs@vger.kernel.org>; Mon, 30 Jun 2025 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751309603; cv=none; b=reL3UW2RM0drZM98+XAEud31Qa3kqb9Lp8BiDUUl7bP0/uSPBYD/jl1wo6tzJgZHsiowWQO9Hd7D5BiyeQu3H63UrjloAtwfpUN+DcWFYfk1O15xVLLmScubB/gQrPfpWzEBOhxb4rAcUKfSehqO1iezdWU0SHhRpoz8uf/JleY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751309603; c=relaxed/simple;
	bh=JTrvvq+lyhU7+6tbBa+Tp3DFouRUbOsZqXYyH0FBhzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mS8nbavsK/kgLJkwr+YGFdXT+FGPDdC18chvOA8ejriHrbItO3wtBd+YjD/xbXs+I1IZl0Uo9Mfg8itdb6qhyUcsiMnGI/RM9fEbMWsuYkvqxWf8NxVi0B1LRwuCBI0yYiAUICUBRHSGEqXchW4lMMba4rUWSVpn8I11NpDMe1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MbjHok7V; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MbjHok7V"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3137c2021a0so3990363a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jun 2025 11:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751309601; x=1751914401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o+c6ngOpScORn3BZS9rOSliAOsMNbn2rVxrNQRtEXMo=;
        b=MbjHok7Vrco5lZkZ9Xny20Ar4qSnog6tS7D0e8TCJ0AdKgCOPxXCpVXN4yByspvRjm
         GDOsPU4RSvUgHr7zS2SmO4A1w/EHTMLrrA+CbBAKtAoZlV5IeDiB0N0CChtByjtjsXI4
         wHln8TK6Arqdo4Thi9O9bfGX5KywVWz5K9V8crD6SKlJOtXdPUieX3NP6aFrNb0oS/+n
         KxFxDnegIygrudlhYNdDkWyMRw2xiPXOY2GV1nozf5KalOc1M9u2F6823XwSAGHEtZ3a
         PwA8PQrqYNLA/7XIudj1sJeEmbIS5xXOCOh9QGRSTXFNQDlLa9EsktEs7ehTtafyiUQU
         Nd9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751309601; x=1751914401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o+c6ngOpScORn3BZS9rOSliAOsMNbn2rVxrNQRtEXMo=;
        b=cTfdkfJxV9LK+rUSUqdiBYmQbes5vXLw79T1hGeI40M1x5hhR0XvMPvvfQuiVdmdYC
         w9LK6wwugRyH1/YZG0ijdh9ONoif4te2/rLrbgmFA+cB3uYyl7UE/aFTSIv/1XgtccTQ
         eb7fSvxF8REkc1O4UCjCIudiPV5UJVkqzxfATLAy+KFi6hQKhdYi9Wn6MZ3cDUB6yuYs
         +uekiItjQD7a6ULP72+nV4rOVZeOn0E7p1cWWf21DZi2AcjsaFasoAwFI6tFZYcz1P3Z
         77jaGHpk08DiWV3TTSXjDpsz2HyucfGOExWtk30Xd+aL6YIVDamEcW8oZGXUOv3SdFjI
         OgAQ==
X-Gm-Message-State: AOJu0Yyg5cAhyFbRUI5usNonXklXoCrqcAOO3XB+4n5hfo3kt0WoTnhS
	VgpB2WsxeS8779LWNsjG8OTgZecXqo63E4IUSCF/xmSu5jSl46u3DgdMSvQg7c5K
X-Gm-Gg: ASbGnctB8W5gyTxf3cveUzSd12wU1fP+YI994BYgSzhu80H5MNelCvSeTlX6TQ1+rBe
	rhbG47gxU20Te4TM1BL6Nij5r30lFkGFYsc11RbxJP5IhwMQYsIKWyKU0zxOdVdkOzcE3ksycon
	uJ0Abe19OQutxWX73cBFPOMWnxitAk5lIzsYigMc8DomW2wv6/sJyd2P1NlC5Duj1zZA9k0Yda4
	wRyazeebTb6k/VMq6H3E8NX/N3BtCDsFTs6OHC5NPJXH39RW1DiwJ+bl4JEKGceqyg9HW1RmSZx
	nRKYgn7MfMAXxPHsdebZ4qAz2eH6FlQgq8bgVlRwfOGTm+GjFNTQeVUsdHGymWkcTepL7EnmvKq
	TKeVEudAO34y4
X-Google-Smtp-Source: AGHT+IG/vd3KzIR/IDOHToxHKuXg/RHaddy6nba//fJtfmi60tdYXkQ2Tq7NAghAXn6r7glMaRTJzQ==
X-Received: by 2002:a17:90b:2c90:b0:312:ec3b:82c0 with SMTP id 98e67ed59e1d1-318c9314d79mr20637811a91.29.1751309600299;
        Mon, 30 Jun 2025 11:53:20 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.2.189])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-318c139299asm9844516a91.3.2025.06.30.11.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:53:19 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	sprasad@microsoft.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 2/2] smb: invalidate and close cached directory when creating child entries
Date: Tue,  1 Jul 2025 00:23:03 +0530
Message-ID: <20250630185303.12087-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a parent lease key is passed to the server during a create operation
while holding a directory lease, the server may not send a lease break to
the client. In such cases, it becomes the client’s responsibility to
ensure cache consistency.

This led to a problem where directory listings (e.g., `ls` or `readdir`)
could return stale results after a new file is created.
eg:
ls /mnt/share/
touch /mnt/share/file1
ls /mnt/share/

In this scenario, the final `ls` may not show  `file1` due to the stale
directory cache.

For now, fix this by marking the cached directory as invalid if using
the parent lease key during create, and explicitly closing the cached
directory after successful file creation.

Fixes: 037e1bae588eacf ("smb: client: use ParentLeaseKey in cifs_do_create")

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/dir.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 1c6e5389c51f..f2c87515dadb 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -190,6 +190,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	int disposition;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
+	struct cached_fid *parent_cfid = NULL;
 	int rdwr_for_fscache = 0;
 	__le32 lease_flags = 0;
 
@@ -313,10 +314,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
+
 retry_open:
 	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
-		struct cached_fid *parent_cfid;
-
+		parent_cfid = NULL;
 		spin_lock(&tcon->cfids->cfid_list_lock);
 		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
 			if (parent_cfid->dentry == direntry->d_parent) {
@@ -327,6 +328,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 					memcpy(fid->parent_lease_key,
 					       parent_cfid->fid.lease_key,
 					       SMB2_LEASE_KEY_SIZE);
+					parent_cfid->dirents.is_valid = false;
 				}
 				break;
 			}
@@ -355,6 +357,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		}
 		goto out;
 	}
+
+	if (parent_cfid && !parent_cfid->dirents.is_valid)
+		close_cached_dir(parent_cfid);
+
 	if (rdwr_for_fscache == 2)
 		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
 
-- 
2.43.0

