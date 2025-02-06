Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AC1224B11;
	Thu,  6 Feb 2025 06:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824683; cv=none; b=uKVmTW6iLybq4XX7fYIMyhsHX3OrtRFQu613/x7xPglZX11Hb8UfmGNRMjBgPGeFBbyfI0I6pQmZOJ41Yw4RsFEDU3+DH3AuK3MjVnUmspRqrM2E/cnzA4uZQux7sAz+7SBhruhnJs51ONOPlt3MjxsjRcitRKCTsOZMEs15aP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824683; c=relaxed/simple;
	bh=5t4pD++FIUBRhevJEgQhxO4DCEgmbbjaRi+ijsLsYSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHOoax8HQy+QFltXf+DWiNwTt3IGCn4DlzJ5xn5rJW69TFq3J4+JzPEkB0kds5iQR2HGA0aPHrXpJN7yMs0zDczgVqtj1yqwVHV913KnYlvcHlnv2FPy4Mv3fuLw0n2Ii8V6z4QiCfTZNWzWYX9p+bP4Mpkk4zgk4lk8VSoiaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlSAoDhU; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlSAoDhU"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21f01fe1ce8so7300605ad.2;
        Wed, 05 Feb 2025 22:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738824681; x=1739429481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1ZPERiXTvyy/qhoukN8QH2XZfgHgV1gu41RDzcz0Ro=;
        b=IlSAoDhUo//oYFqUtOtG+JhtthAmvToes+wpO6OtlJFWx5y9GtJw1I5p1syzg6BSEu
         o187p9Iizfpk/Fu3vNfFh9fa7KJjwJt+cjHhJZfj8ekEf6m9MtQTuOLo/iD3fVhlEzmL
         XDpTwRlycQX7TxXtxEwN0hXVrzXNTHZeiiAK7K+02AS8CRGYH20CUr68CtwKcG1XGLAP
         N6VpimUihwLdk0K3lgp1D6aqB1ICMgFPYzcbLBwg35Y58AUHnQwE52cJyHxI5lAX442f
         i4Z8UZv+VezJEX5JrBhN0yRFsdxt4pspvdz5MSW7FqhR+CQJ0g5FjrNBAFQ/HMKqn/Rq
         Cfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738824681; x=1739429481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1ZPERiXTvyy/qhoukN8QH2XZfgHgV1gu41RDzcz0Ro=;
        b=h2n82/SfKMpvcJyG8v1kmNl5FizEz+luSrlfJHq9ovnqxNYbVFAyq0MVa4rS3oZO88
         Gakz0n1lIGXtwilRKkqWQT1s0iwVe/mkyKLKcpajCNF4cSBLpcM9nWLMd90bhMUdvDrD
         zitet0Q5TEQQsqLEY4WJgMypVTwm0Vo38Z1yNpSs+7boaJfaSBeDtjGVgwAr1xFKvDDP
         MBTS2GQX7p5eskXiBCX8vOn1xL22cJbpraMT1atVBhGgfdSZLugBwp0KD6jXTOFC82Oy
         ZAzrLr6xCpwIgkfY9Hdg7eYJ1xnzn1KWkzpzWJBurj/jgXy3235YP4zA0Gr59Bu+r4km
         gUXw==
X-Forwarded-Encrypted: i=1; AJvYcCU+VybwuKFdNJ5Xj48m4xD3Y2qtpG0sOk1haVNFg+ks4D8H5EZKF5+KPOg8JNcxfNCe55n5lab9JVTXfK2y@vger.kernel.org, AJvYcCVslh8Gr3elw4Tl26VxZGX3XcPBTxR+k1CZQQgZDDWBSkcA/zOCMpI/KNEqj8pLvM62DDMKxsID@vger.kernel.org, AJvYcCXq3P5un4r17G/4HWC6APRhppQBFxT4o7LpoU8+Rt1BMMFl9s0WeB9ClY5HJlpJ25op9nzkeqDBfVJa@vger.kernel.org
X-Gm-Message-State: AOJu0YzYHLNqqs7TqqfRriqWV7VNbTaGLgrH/XTr2KH0Saon7rP5ioCE
	Dd6tJYbHCcuB+zLjOTEzf1HY8GVbGj3MOO86pBxPeNgfeiV5/lMm
X-Gm-Gg: ASbGnctPofF43hkZA9VvorT48fFzMKI5DURjVvobl/115GGqShRN3gi/g3iJYQ+0lOg
	imSbeScDj70e4vi4oNla5YlIi548P2h5tx6enOlvev5zi7Bx/bQhBHi0QWwbhZnpFhvttCdnnCw
	7eIaOyCOqR/I7lL0ghT51AeHoMwBgoXWkW5edCJ5K2wnZPPrrS/yTfyfG3oe1XgLfSgieN4+Ozb
	WnQOQPvT0sTrGVg15+kRmXzTKJIWHillgUa9dwwCq6vrXj+UYB11hr1eNktC8gjrD2Z2IO6geLW
	BTkpWFsYsXiTZkrhQC7+YqXNAjB4kZxfhxCYfRc6VQ==
X-Google-Smtp-Source: AGHT+IG52XZdhX3IxbkzDZ9p+u5dZdN217DgHo317D/GnO15B3g2cOhJiV2xNd73l5tV8bXaRM7itg==
X-Received: by 2002:a17:902:e54c:b0:216:3436:b85a with SMTP id d9443c01a7336-21f17f31f08mr92114915ad.52.1738824680693;
        Wed, 05 Feb 2025 22:51:20 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.159.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f36538c26sm5169325ad.55.2025.02.05.22.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 22:51:19 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	nspmangalore@gmail.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org,
	bharathsm.hsk@gmail.com,
	bharathsm@microsoft.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] smb: client: make lease state changes compliant with the protocol spec
Date: Thu,  6 Feb 2025 01:50:42 -0500
Message-ID: <20250206065101.339850-2-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
In-Reply-To: <20250206065101.339850-1-meetakshisetiyaoss@gmail.com>
References: <20250206065101.339850-1-meetakshisetiyaoss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

MS-SMB2 section 3.2.5.7.5 specifies that client must evaluate
delta_epoch to compare the old and new epoch values. This delta_epoch
takes care of lease epoch wraparounds (e.g. when the server resets
the epoch from 65535 to 0). Currently, we just check if the old epoch
is numerically less than the new epoch, which can cause problems when
the server resets its epoch counter from 65535 to 0 - like causing
the client (with current epoch > 0) to not change its lease state.
This patch uses delta_epoch based comparisons while comparing lease
epochs in smb3_downgrade_oplock and smb3_set_oplock_level.

Also, in the current code for smb3_set_oplock_level, the client
changes the lease state for a file without comparing the epoch. This
patch adds the delta_epoch comparision before updating the lease
state, so that when the change in epoch is negative, the new lease
state is invalid too. This can protect the client from having an
inconsistent lease state because of a stale lease state change
response.

This patch also adds additional validations to check if the lease
state change is valid or not, before going through
smb3_set_oplock_level.

Cc: stable@vger.kernel.org
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  6 +++
 fs/smb/client/smb2ops.c  | 95 +++++++++++++++++++++++++++++++---------
 2 files changed, 80 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 2c1b0438fe7d..4417fa46885f 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1558,6 +1558,12 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
 #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
 #define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
 
+#define IS_SAME_EPOCH(new, cur) ((__u16)new == (__u16)cur)
+#define IS_NEWER_EPOCH(new, cur) (((short)((__u16)new - (__u16)cur) <= (short)32767) && ((__u16)new != (__u16)cur))
+
+bool validate_lease_state_change(__u32 old_state, __u32 new_state,
+				__u16 old_epoch, __u16 new_epoch);
+
 /*
  * One of these for each file inode
  */
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ec36bed54b0b..6e0ce114fc08 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3922,7 +3922,7 @@ smb3_downgrade_oplock(struct TCP_Server_Info *server,
 	__u16 old_epoch = cinode->epoch;
 	unsigned int new_state;
 
-	if (epoch > old_epoch) {
+	if (IS_NEWER_EPOCH(epoch, old_epoch)) {
 		smb21_set_oplock_level(cinode, oplock, 0, NULL);
 		cinode->epoch = epoch;
 	}
@@ -3998,39 +3998,92 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		 &cinode->netfs.inode);
 }
 
+/* helper function to ascertain that the incoming lease state is valid */
+bool
+validate_lease_state_change(__u32 old_state, __u32 new_state,
+				__u16 old_epoch, __u16 new_epoch)
+{
+	if (new_state == 0)
+		return true;
+
+	if (old_state == CIFS_CACHE_RH_FLG && new_state == CIFS_CACHE_READ_FLG)
+		return false;
+
+	if (old_state == CIFS_CACHE_RHW_FLG) {
+		if (new_state == CIFS_CACHE_READ_FLG || new_state == CIFS_CACHE_RH_FLG)
+			return false;
+	}
+
+	// lease state changes should not be possible without a valid epoch change
+	if (old_state != new_state) {
+		if (IS_SAME_EPOCH(new_epoch, old_epoch))
+			return false;
+	} else {
+		if ((old_state & new_state) == CIFS_CACHE_RHW_FLG) {
+			if (!IS_SAME_EPOCH(new_epoch, old_epoch))
+				return false;
+		}
+	}
+
+	return true;
+}
+
 static void
 smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		      __u16 epoch, bool *purge_cache)
 {
 	unsigned int old_oplock = cinode->oplock;
+	unsigned int new_oplock = oplock;
+
+	if (!validate_lease_state_change(cinode->oplock, oplock, cinode->epoch, epoch)) {
+		cifs_dbg(FYI, "Invalid lease state change on inode %p\n", &cinode->netfs.inode);
+		return;
+	}
 
-	smb21_set_oplock_level(cinode, oplock, epoch, purge_cache);
+	/* if the epoch returned by the server is older than the current one,
+	 * the new lease state is stale.
+	 * In this case, just retain the existing lease level.
+	 */
+	if (IS_NEWER_EPOCH(cinode->epoch, epoch)) {
+		cifs_dbg(FYI,
+			 "Stale lease epoch received for inode %p, ignoring state change\n",
+			 &cinode->netfs.inode);
+		return;
+	}
 
-	if (purge_cache) {
+	if (purge_cache && old_oplock != 0) {
 		*purge_cache = false;
-		if (old_oplock == CIFS_CACHE_READ_FLG) {
-			if (cinode->oplock == CIFS_CACHE_READ_FLG &&
-			    (epoch - cinode->epoch > 0))
-				*purge_cache = true;
-			else if (cinode->oplock == CIFS_CACHE_RH_FLG &&
-				 (epoch - cinode->epoch > 1))
-				*purge_cache = true;
-			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
-				 (epoch - cinode->epoch > 1))
-				*purge_cache = true;
-			else if (cinode->oplock == 0 &&
-				 (epoch - cinode->epoch > 0))
+
+		/* case 1: lease state remained the same,
+		 * - if epoch change is 0, no action
+		 * - if epoch change is > 0, purge cache
+		 */
+		if (old_oplock == new_oplock) {
+			if (IS_NEWER_EPOCH(epoch, cinode->epoch))
 				*purge_cache = true;
-		} else if (old_oplock == CIFS_CACHE_RH_FLG) {
-			if (cinode->oplock == CIFS_CACHE_RH_FLG &&
-			    (epoch - cinode->epoch > 0))
+		}
+
+		/* case 2: lease state upgraded,
+		 * - if epoch change is 1, upgrade
+		 * - if epoch change is > 1, upgrade and purge cache
+		 * we do not handle lease upgrades, so just purging the cache is ok.
+		 */
+		else if (old_oplock == (new_oplock & old_oplock)) {
+			if (IS_NEWER_EPOCH(epoch-1, cinode->epoch))
 				*purge_cache = true;
-			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
-				 (epoch - cinode->epoch > 1))
+		}
+
+		/* case 3: lease state downgraded,
+		 * - if epoch change > 0, purge cache
+		 */
+		else {
+			if (IS_NEWER_EPOCH(epoch, cinode->epoch))
 				*purge_cache = true;
 		}
-		cinode->epoch = epoch;
 	}
+
+	smb21_set_oplock_level(cinode, new_oplock, epoch, purge_cache);
+	cinode->epoch = epoch;
 }
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-- 
2.46.0.46.g406f326d27

