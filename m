Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF9C44C77
	for <linux-cifs@vger.kernel.org>; Wed, 20 Nov 2024 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118530; cv=none; b=OrUM4FsmsqqrAcuZLEPdSdH6bL/u1xMNh+pnzClB4bNURD/8agIyFGj2oX+EBNRM5Q0HIfQz4Nh9hWw60x47k7Sy1rSDyREbEZ3Mo3atK8DtDEmOPvaiUfoJpzlE2wqgQykzoUaKTwvfpFmRC8kZhsZiG6XYi1V3nktAN1l7xlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118530; c=relaxed/simple;
	bh=ybY21A8h8wa/pjo5YRNqWpHepqipAX1vNceK039T4zc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VolCVow8cusWErxidbvED4wjiV7vwg/goswjBOG8DGSiH4nmG6RYd9bp4HV6ZM5JONe14MvsEDrgcsOrcbQD3nLNPigSfNgQC/L8eUEJkKW8jEG3YsP2bUYyYnM4evQzBk/649g5+Q0fuGPn5Pw2RwzXMQdprKOzCZPmvv/CCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=MQ1mDZyP; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=dK9cNn7n; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="MQ1mDZyP";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="dK9cNn7n"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1732118522; h=from : to : cc : subject : date : message-id :
 mime-version : content-transfer-encoding : from;
 bh=73WuamBai3H1cJT+txLWpLWnXS9RXcL8a/CoxdVda+w=;
 b=MQ1mDZyP3oTlub31HknPqjEgu/bLH1Po5Dm5B3DxX+IwtpEPrASU0Qqt0iOnbztTOu82n
 ny6cPQeLmVOjiePDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1732118522; h=from : to
 : cc : subject : date : message-id : mime-version :
 content-transfer-encoding : from;
 bh=73WuamBai3H1cJT+txLWpLWnXS9RXcL8a/CoxdVda+w=;
 b=dK9cNn7nraCk4BDJJdsdPrpTLP3ZllcFbABj0CyYucnCDgDOP1F60eGZ4jcgP1nK17Gcm
 jidUajtsTNlMg2qSchu57+P8kXgtDcFDp8Jp7VwzTAN9BsHBZhZ2Xv70fFfJ1N8E/5Lplvh
 EG3iO5z2Qw33dUnoYKVwKtJ9W58T+5N4/Aa2uuHjHVxXBbfj3DfwLQ2+wPbPX5uaMiNnQTF
 tX/ssOBE+ybNVACPRJlm/gqXNaACnC9bzVM8G8tiabctLLAGgvNhiRbXj3adQavUFBW1ldl
 K0F0uiVLTMISDEwLDsjtpZx1EXMvIufzFKL+nVBDxoUcqZrWBQpU7Apk44oA==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id CC12C82FA;
	Wed, 20 Nov 2024 08:02:01 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Ruben Devos <rdevos@oxya.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] smb: Log an error when close_all_cached_dirs fails
Date: Wed, 20 Nov 2024 08:01:54 -0800
Message-ID: <20241120160154.1502662-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Under low-memory conditions, close_all_cached_dirs() can't move the
dentries to a separate list to dput() them once the locks are dropped.
This will result in a "Dentry still in use" error, so add an error
message that makes it clear this is what happened:

[  495.281119] CIFS: VFS: \\otters.example.com\share Out of memory while dropping dentries
[  495.281595] ------------[ cut here ]------------
[  495.281887] BUG: Dentry ffff888115531138{i=78,n=/}  still in use (2) [unmount of cifs cifs]
[  495.282391] WARNING: CPU: 1 PID: 2329 at fs/dcache.c:1536 umount_check+0xc8/0xf0

Also, bail out of looping through all tcons as soon as a single
allocation fails, since we're already in trouble, and kmalloc() attempts
for subseqeuent tcons are likely to fail just like the first one did.

Signed-off-by: Paul Aurich <paul@darkrain42.org>
Suggested-by: Ruben Devos <rdevos@oxya.com>
Cc: stable@vger.kernel.org
---

This could also be folded directly into "smb: During unmount, ensure all
cached dir instances drop their dentry".

---
 fs/smb/client/cached_dir.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 004349a7ab69..8b510c858f4f 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -488,12 +488,21 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		if (cfids == NULL)
 			continue;
 		spin_lock(&cfids->cfid_list_lock);
 		list_for_each_entry(cfid, &cfids->entries, entry) {
 			tmp_list = kmalloc(sizeof(*tmp_list), GFP_ATOMIC);
-			if (tmp_list == NULL)
-				break;
+			if (tmp_list == NULL) {
+				/*
+				 * If the malloc() fails, we won't drop all
+				 * dentries, and unmounting is likely to trigger
+				 * a 'Dentry still in use' error.
+				 */
+				cifs_tcon_dbg(VFS, "Out of memory while dropping dentries\n");
+				spin_unlock(&cfids->cfid_list_lock);
+				spin_unlock(&cifs_sb->tlink_tree_lock);
+				goto done;
+			}
 			spin_lock(&cfid->fid_lock);
 			tmp_list->dentry = cfid->dentry;
 			cfid->dentry = NULL;
 			spin_unlock(&cfid->fid_lock);
 
@@ -501,10 +510,11 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 
+done:
 	list_for_each_entry_safe(tmp_list, q, &entry, entry) {
 		list_del(&tmp_list->entry);
 		dput(tmp_list->dentry);
 		kfree(tmp_list);
 	}
-- 
2.45.2

