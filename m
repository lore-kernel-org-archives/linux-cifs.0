Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602D81871
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 04:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705637862; cv=pass; b=IAnUHMklpHGO5FY/9B+eMYp7Nc3ieglRKD4bC4HncuZ3xH7QiQ/Y0wvRDreX2Gn+vTCxkNHGgSsd6jC0XY9PRNi+bcJk0jA+g9PKQ02TPAy3k4w8ZCCOIrlhEMTTREBIVDqQX+XzoW/eSI2APW86Gd4ht8iTUTPgf+3pqIi0CtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705637862; c=relaxed/simple;
	bh=JJnLl5yzH9AqLK3/JA+hBkrA0J9TOxtW8/7KE+uai/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0RCdUik10fKGnl7CEsLodFPQ5mEniUu5q6lxV+fTEv65Swk8Zn0bNw5NJ+rntPNg4S4a1yYHC5KkAx44tuvE6RJ8fyBZR8f5yWDiSzZn2ru9b/Rr8HqwEQ+PebOH/+zoKjbMhpqVbqN3EV6AGmsQKuuOQnQJ6zEKhjZpRYxwvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=XKa6bIN7; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="XKa6bIN7"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1705637323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4rRnB6NqOgLp1m+be3/3zjog0BjTjB5PtkyR2yV4Do4=;
	b=XKa6bIN7M/jIy8oy0g1SfzUhCSpcn09NQuw+UWw0F83rp30ekAI/4V5tIdV6SPmwrk3YyQ
	B2B0itXRv/ebNk1udaXthR8OpHvfjtrE49sA4O4wqvOuMJP1+WzTEmkzlaj46XelkpiAKT
	OyB3Jqpq59K+0g/z5pWQUdNvP8iarzrCl8X3wfqqPDSN02kFUvYA0m9zN9yGmhLqfaGSKN
	qHv3L1Cf6DuxTuc7oFNTzib7dtOEh3DmPBY+wYcOkr3EKF1hy02vAu3xvAceaTph1lQ6PW
	KFwjwvkxBWVA1C1eurdDYTNVwDO4y+cSHYg8PWXIzsqrF/j0USPYDk8xd15+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1705637323; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4rRnB6NqOgLp1m+be3/3zjog0BjTjB5PtkyR2yV4Do4=;
	b=iyv/TvHukCQCHsO5mq1uiusIEmfxAr64oqMc44VXl8BoJWjxwwfRBNRcyYJy2l1WtrXOVe
	tHCSVunSRl0c+gh1yauqYQoq+sKTqm4S3+nPWN7dlFdr7vPUzAfew30nLVbnUbIy/Z/KNa
	zrKUyiIDCj4cIAxWfSrZBSnPH/NMTdXYEduyg/z+Pm+XZMLwbPOgpv0Q8o0/KjXUTO5Tz9
	q/J8uCN7N+wazsq6SuwgdpbITnoB88lu1hL2H76N8CnP6uZ6jJg+IApk042oZR4LZwqh1E
	j3TArF0u37PHfQyQnF/6SC0vMtrUlfvZhVVNIWDolvn0n1fj2bdPR1MmLJs6Yw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1705637323; a=rsa-sha256;
	cv=none;
	b=WxoGtBJ8VDuHUA93lYZsQXHLCFvM6nO+m8GK+dppJYyk938DcAm3FfLOibcqoXN1uCYxuH
	N9lSbw/8ptg6ACaaP9Yg0UOa+f3NWpX7DErn6VfyjQBdj2j5YEpEqymKmT8h0hZsJtsPnf
	we/2EwJYPHnRRRwrDH0UOGHEMgiwN0rbi+EH9zlQMfYhhfLKA949XA1ZeZ5PlQ69dJ6eaa
	Ljufxo/+Rl0Cfytp2NLz4vRz5E2R1rlUXRQNpbLyi65ePhQsZTpwiGyRbPS9Rik0P18FgF
	v0EnRST0zpTocVuAsPH/bKPR5oNsJuyRNXG2nkD07cGC/7/zBO5cBWgsrgtL3g==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/4] smb: client: don't clobber ->i_rdev from cached reparse points
Date: Fri, 19 Jan 2024 01:08:29 -0300
Message-ID: <20240119040829.18428-4-pc@manguebit.com>
In-Reply-To: <20240119040829.18428-1-pc@manguebit.com>
References: <20240119040829.18428-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't clobber ->i_rdev from valid reparse inodes over readdir(2) as it
can't be provided by query dir responses.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/readdir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index e24684112ab0..94255401b38d 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -133,14 +133,14 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 				 * Query dir responses don't provide enough
 				 * information about reparse points other than
 				 * their reparse tags.  Save an invalidation by
-				 * not clobbering the existing mode, size and
-				 * symlink target (if any) when reparse tag and
-				 * ctime haven't changed.
+				 * not clobbering some existing attributes when
+				 * reparse tag and ctime haven't changed.
 				 */
 				rc = 0;
 				if (fattr->cf_cifsattrs & ATTR_REPARSE) {
 					if (likely(reparse_inode_match(inode, fattr))) {
 						fattr->cf_mode = inode->i_mode;
+						fattr->cf_rdev = inode->i_rdev;
 						fattr->cf_eof = CIFS_I(inode)->server_eof;
 						fattr->cf_symlink_target = NULL;
 					} else {
-- 
2.43.0

