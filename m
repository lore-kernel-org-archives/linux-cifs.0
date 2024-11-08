Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672441EABC5
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731105297; cv=none; b=TA/2kYUPidRwk6WNDk7rALJv0Z30GWPRt7NtAEtJM1cBy4EasSxtqE8pqJ+gIbovtMTJkHLA42Y654aojMBPOFlijkPksWDqhvL0nw2vMYGzbTQK2PcyHIqyGtXENQ+rnJQyG2voyl5iY68mIS0HYJQe1uIqMk9TIxu0BBBAKzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731105297; c=relaxed/simple;
	bh=znzbX3p5s9vcdK8bq6VtwdZcpCKYYmpmaZAq7QygsTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9G6AgFrmIrHM24IoQf4olVP5DFg2SH2Zr7rmg1bcgFZvdCd4Y/AHq3iJONeJj4NT/QmFOTkKC42Tng0M9CKxp08P/qTi7FVsBtjRsjvpbiMktAbCY73SUQLJgOKZE7vr/JmfHKkeVpoRsaZxdf7VVOBtQDBkEJIxFqWRaiRMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=kO2kXpkV; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=e69oHUuL; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="kO2kXpkV";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="e69oHUuL"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1731104985; h=from : to : cc : subject : date : message-id :
 in-reply-to : references : mime-version : content-transfer-encoding :
 from; bh=EP2nuxDTEwU74gnPAI7Obz0KDEiSNBKt2axt003MCHk=;
 b=kO2kXpkV9BB3P39Xn0MmB4MuFW7TOcDcch87QoJK7WXP0xNiR6uBOF6j0hmnrR8QZZFzH
 TeIHdTti2A21dANCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1731104985; h=from : to
 : cc : subject : date : message-id : in-reply-to : references :
 mime-version : content-transfer-encoding : from;
 bh=EP2nuxDTEwU74gnPAI7Obz0KDEiSNBKt2axt003MCHk=;
 b=e69oHUuLSIYeSDtxZoSm+udNisizt4HNXQEhApX3sNx2wTRHj7bM4hbuhYg4T8rDYrGrS
 1JXIX9ELXCtEUyF0r2d638Xei29TB1ADWQqCdvAF2gCkUmEXyCoUeW+G/p/M0Yq6zw/VAJj
 VP4AZ+guLz0qx8YcHFh8orpXpPh7DrtS/gPKKKz8BK1BbaMeT7A7136GSMpyIgRya4T3Gx7
 DdIW/fqnUBktCKVLatv68aqbWfJJgac2AbOUXzrEMg40g4VdSmH50ULl+XpJCc9KwxoTeZM
 BUGLmPqAUsn5rAFyv1qq0rBdtU58urQErWwKjRJwSu15qw8paX2o0oGFnH5Q==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by o-chul.darkrain42.org (Postfix) with ESMTPSA id 5C1E58152;
	Fri,  8 Nov 2024 14:29:45 -0800 (PST)
From: Paul Aurich <paul@darkrain42.org>
To: linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>
Cc: paul@darkrain42.org,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 1/5] smb: cached directories can be more than root file handle
Date: Fri,  8 Nov 2024 14:29:02 -0800
Message-ID: <20241108222906.3257172-2-paul@darkrain42.org>
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

Update this log message since cached fids may represent things other
than the root of a mount.

Fixes: e4029e072673 ("cifs: find and use the dentry for cached non-root directories also")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 0ff2491c311d..adcba1335204 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -399,11 +399,11 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 		return -ENOENT;
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (dentry && cfid->dentry == dentry) {
-			cifs_dbg(FYI, "found a cached root file handle by dentry\n");
+			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
-- 
2.45.2

