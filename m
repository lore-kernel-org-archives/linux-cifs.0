Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221931E2308
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104993; cv=none; b=rK3WuAKrwc4oxhayXDU7a0VOXXGmoqrsC24MyTt8NFg6Y/Eaa94vcpQZ519jHszdiO8C4L77JwCsKP2W/yRIOFASnOccGhcCZcoIG8kG2GqHOVmzt6MUDxOtwWnR0CS6xk6MdVSv1U2x+DUrNOMhEF2kbmkQ7lhTYk6gbTv14Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104993; c=relaxed/simple;
	bh=3JV4XBhVZZ5+lWIhTKvzXA3OSgZKpB0+es83cgTgyNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cyl7MMQ3HafANkRhF51jz3PHBzAVCxAb8Ikg79tCL6HKdlqplEl97dX4U9g21wPkPIlcfaEOVWB35HE+cNVgPysC3KTi3iDf8iFi7EJSef3Ppdr3SKOnmcSDYy4u5nixbgWUXU689VRzm+On8WlvDYwpXd7oGPAeoTpGGfr4PqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=/wDSLqYz; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=dW2Ypar0; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="/wDSLqYz";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="dW2Ypar0"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731104987; h=from : to : cc : subject : date : message-id :
 in-reply-to : references : mime-version : content-transfer-encoding :
 from; bh=ggHGn8vOR722aSNA2nPvVAMdptwhOaRM26WFsctR9Jo=;
 b=/wDSLqYzxLWOBsiCyEZiDK9QcG7J3gw1s9BFeeMYyDsxd1KaD5picIYvIdOBKYvqBoIqI
 BOlSX8d9CiTXiGDAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731104987; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 mime-version : content-transfer-encoding : from;
 bh=ggHGn8vOR722aSNA2nPvVAMdptwhOaRM26WFsctR9Jo=;
 b=dW2Ypar0gTDpYFrtLPCmTRK9Nuqqdq67sYcwRLh9y7WclGGneoDjzmGXs5XtEn+B+utrs
 UNRD5KViAlS4vEH7blJ90mo0K1FahCt7jl2U37BqYiLxg9g1FURQWUCDzRKzDNmyLXZxo9N
 nEpMCM0NXsezhzaOE1TspYPDFGcwcm4v/GF6/G/maDB8vKp/VI/kVw8hPVPCr/yT6tVH4mL
 mg+BuVZvv0TJmQcDZxdcyJ2w+2S8dQM5KjaCJyUpC7Mklxg+v1oE6Nfvpe5fywUFMJVmh/K
 OoYXwt8Ed5hHaY9ejY0N6tCPksT32Rvw30Ld0ry+ZUu2VKc9CjIKs3uklLdA==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id D1494826F;
	Fri,  8 Nov 2024 14:29:46 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 5/5] smb: During umount, flush any pending lease breaks for cached dirs
Date: Fri,  8 Nov 2024 14:29:06 -0800
Message-ID: <20241108222906.3257172-6-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241108222906.3257172-1-paul@darkrain42.org>
References: <20241108222906.3257172-1-paul@darkrain42.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

*** WORK IN PROGRESS ***

If a lease break is received right as a filesystem is being unmounted,
it's possible for cifs_kill_sb() to race with a queued
smb2_cached_lease_break(). Since the cfid is no longer on the
cfids->entries list, close_all_cached_dirs() cannot drop the dentry,
leading to the unmount to report these BUGs:

BUG: Dentry ffff88814f37e358{i=1000000000080,n=/}  still in use (2) [unmount of cifs cifs]
VFS: Busy inodes after unmount of cifs (cifs)
------------[ cut here ]------------
kernel BUG at fs/super.c:661!

Flush anything in the cifsiod_wq workqueue in close_all_cached_dirs.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/smb/client/cached_dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index de1e41abdaf2..931108b3bb4a 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -482,10 +482,13 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		list_for_each_entry(cfid, &cfids->entries, entry) {
 			dput(cfid->dentry);
 			cfid->dentry = NULL;
 		}
 	}
+
+	/* Flush any pending lease breaks */
+	flush_workqueue(cifsiod_wq);
 }
 
 /*
  * Invalidate all cached dirs when a TCON has been reset
  * due to a session loss.
-- 
2.45.2

