Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FEF3A5431
	for <linux-cifs@vger.kernel.org>; Sun,  6 Sep 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788710309; cv=none; b=WBd4TfcAU/4x7+MuDXLbpqIVRK7bhYqL3/szGNIptpb6xuYmStLJtixhopQEFJ3GHi7CUJj+lRObRMO4kirZuaYd3ZVZfMnhexBrFmuIIpPB4W87kHRT1w5rBNy3EZPkr44m1eyNU5dsbXdK4Z5Hg6k7nDXJXYZgVxt4BGzRRJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788710309; c=relaxed/simple;
	bh=bJ4uIQ/nHwManMZCcFP/S6KtjdAgB/o2k2AP/fnVKJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NH9g1KZTFhTXGFBNlwbZVXLeFxkUf+OKtfCMpSzpAi4ACDsGM8bj28aQeeKTa8RGSYLmTgyZlgjtFuZ4w5Wkti/Y5VIuE/5/9wsTh/6kr2XM79miBoQzv1TnYySaXN0sKPpevxkfwIUReBUfskpp8jINumrSUEKAfMhoreW+O+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=OUHWoulk; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="OUHWoulk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=PJswzYrzR0LFCBHR8yEBoqVEkvKq2Po8yDui8WkHQbk=; b=OUHWoulkKTRYGJaDowxM7jWmAS
	suTmt6HzAdT+9f/Q7Tze30eMtM0Kii3CZ3OP4ctfLSTnazhv3G2XxowvNfZhRbPNQxzU3Mdz46lIg
	RHbBcQMr7LUjtiYka4znKVZk6AIyISc64v0NeNrxJrxOez4oOcj1Urc04xllei5zz7mFKWtaP89VD
	PUs0CvklX0WKZ5ZEN41O44BPeAyFgwLHXM/IHGvj4Y61mepN0wf+3K7uMS8UqvKFBerq8MiQYpEz+
	0AHEn4Y30Zdxgp4hX7ninUBlIX31iB2FxKM/ka7DsAbCrs6xjiUMajeJHB6wjezYT/YJKV9sj2Htz
	G2iCgZ/Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3FG5-00000000nbi-2GdO;
	Sun, 06 Sep 2026 12:58:17 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Arthur Lesuisse <arthur.lesuisse@ulb.be>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: client: fix uid/gid override in getattr with posix extensions
Date: Sun,  6 Sep 2026 12:58:16 -0300
Message-ID: <20260906155816.603278-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mounting with 'multiuser,posix' options, cifs_getattr() overrides
the server-provided uid/gid with the current process's fsuid/fsgid.
This is because the condition only checks for unix extensions
(tcon->unix_ext) but not posix extensions (tcon->posix_extensions).

With SMB3 POSIX extensions, the server provides real uid/gid values
just like with unix extensions, so they should be preserved rather
than replaced with the caller's credentials.

Add a tcon->posix_extensions check to the condition so that uid/gid
from the server are properly reported in stat results.

Reported-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Closes: https://lore.kernel.org/r/DB9P190MB2012266F6B8DECBE5D26A1798DB52@DB9P190MB2012.EURP190.PROD.OUTLOOK.COM
Suggested-by: Arthur Lesuisse <arthur.lesuisse@ulb.be>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 12ed8db10e00..49f9993ad567 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2992,14 +2992,14 @@ int cifs_getattr(struct mnt_idmap *idmap, const struct path *path,
 		stat->attributes |= STATX_ATTR_ENCRYPTED;
 
 	/*
-	 * If on a multiuser mount without unix extensions or cifsacl being
-	 * enabled, and the admin hasn't overridden them, set the ownership
-	 * to the fsuid/fsgid of the current process.
+	 * If on a multiuser mount without unix extensions, posix extensions
+	 * or cifsacl being enabled, and the admin hasn't overridden them,
+	 * set the ownership to the fsuid/fsgid of the current process.
 	 */
 	sbflags = cifs_sb_flags(cifs_sb);
 	if ((sbflags & CIFS_MOUNT_MULTIUSER) &&
 	    !(sbflags & CIFS_MOUNT_CIFS_ACL) &&
-	    !tcon->unix_ext) {
+	    !tcon->unix_ext && !tcon->posix_extensions) {
 		if (!(sbflags & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
 		if (!(sbflags & CIFS_MOUNT_OVERR_GID))
-- 
2.55.0

