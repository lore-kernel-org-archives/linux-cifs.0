Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620471A9B5C
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105298; cv=none; b=Fl6NFQp/AiBaydbKW73D0zKX6OAYdYSm4Spg5SFkuzn2XS5HGv85GLKs4HbqvmuEIgMJ1rgk3lXzGNB2WCZ+gVZIgLuMjgTjofu/QzEJtPijzWWjgOgZDeLlwIC3g0DA0Tt+oluUEstqCvGy5bAxPrFDEUs79BqTUnC5tOHlCWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105298; c=relaxed/simple;
	bh=Ijl5o91jm/90iRlY2OLGTMCo/Ssq17wd1yrvoKEiW+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhySwYOC6U/YjVVmsQbHgB3Nt3yMoZuzGwD7/Rs8UPvJrVT2D82AMqr5JRRpI9l2PhTTQkOxAV5A6bRfB+gxvh0AN3NOt/Xa9KWGGqMdBUTMajS+HGJFn/H9oU1wqFQAtbGVqVZXCLpGOSVXNAoTqBCOe4UEf2r3Z42F/x1ySug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=lU/vcCb4; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=l9mXkH+r; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="lU/vcCb4";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="l9mXkH+r"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731104986; h=from : to : cc : subject : date : message-id :
 in-reply-to : references : mime-version : content-transfer-encoding :
 from; bh=CtwbfSNsg+RRz0+u2V3E2W4jVDzVn1IzjVjE74UL+sg=;
 b=lU/vcCb4SH/Itm/7byD7JNyU1WbOcxe2rdVLVt24Pjyp0YPMiVnjD76PRBkRGnoz1EYmd
 DB/HxEmT9vT8o6fBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731104986; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 mime-version : content-transfer-encoding : from;
 bh=CtwbfSNsg+RRz0+u2V3E2W4jVDzVn1IzjVjE74UL+sg=;
 b=l9mXkH+r9yU53KJ0uTsGlrfOARsuOYZLbJW9rfoiBaf9wvsk0+WeUbQcttbpF4sEV5LlT
 PYZFg+gS/bpMUJ2WU4YRVwWZ2KEGrHcXU8hYXeINtrxainJpnfJAL5uVXPLCeweYi/PkAZL
 avIYDPcvxwXO/8TB5wJP1BQ3oiF/2piFFcksjfkcwTSl/wo/Wwkck2zBLJIKYP5ydITErh9
 FEG+zzuCmvkfPJPVO2BoX/44KgtDWssGV3BAIOBmFuLwhZP5TNovkFt4G6vyR5vHP0l7Iis
 YqK4UGzXQhJJ92bAFVV9EPxh3/IGXZa5hzbu5NnWyW/dHEFrla9Ll5MO2sLg==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id 76B5581F3;
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
Subject: [PATCH 4/5] smb: No need to wait for work when cleaning up cached directories
Date: Fri,  8 Nov 2024 14:29:05 -0800
Message-ID: <20241108222906.3257172-5-paul@darkrain42.org>
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

It isn't possible for cfids_laundromat_worker(),
invalidate_all_cached_dirs(), and cached_dir_lease_break() to race with
each other. Each holds the spinlock while walking the list of cfids, and
removes entries from the list. cfids_laundromat_worker() and
invalidate_all_cached_dirs() will never see a cfid that has pending
work.

Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/smb/client/cached_dir.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 06eb19dabb0e..de1e41abdaf2 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -516,11 +516,10 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
-		cancel_work_sync(&cfid->lease_break);
 		/*
 		 * Drop the ref-count from above, either the lease-ref (if there
 		 * was one) or the extra one acquired.
 		 */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
@@ -594,10 +593,12 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 static void free_cached_dir(struct cached_fid *cfid)
 {
 	struct cached_dirent *dirent, *q;
 
+	WARN_ON(work_pending(&cfid->lease_break));
+
 	dput(cfid->dentry);
 	cfid->dentry = NULL;
 
 	/*
 	 * Delete all cached dirent names
@@ -640,15 +641,10 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
-		/*
-		 * Cancel and wait for the work to finish in case we are racing
-		 * with it.
-		 */
-		cancel_work_sync(&cfid->lease_break);
 		/*
 		 * Drop the ref-count from above, either the lease-ref (if there
 		 * was one) or the extra one acquired.
 		 */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
-- 
2.45.2

