Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A464B0488;
	Thu, 17 Sep 2026 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649351; cv=none; b=sYCeP2gMKl5bpFOLxGkUqbn22aU1biz5kosiSc9inCkmPDD4CK2XhYDjosOVBa5Pw0on7LCtS5aFjjF0NLtWSGw0B8OlEXr+Ah/pKve1+4uQpyXPm8p0FAkqNyhOGBgg7Zc8aVk2wAykysSli+MRMTTuhAFn+9XBUzlCsAiGXys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649351; c=relaxed/simple;
	bh=BeHhmtlQGqLMuqLD7LV08ps+39aN0jvsHuUwVIurisw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isLEVkv2lbro1Yjneh9RSOSIvGbDj+hfdHKS0AS2Nks0B0KgWRxko5iDNu5Do1M4pSXlaHR8GuejJNr2/oHbHNH7l8RdQhS/ioxMuNgo9lnuOkHDulf0XOMmLzBvqe+Rde0cKOfrDrQQJxyR/MCmcT/WW2LtSM3huc5LOKfIHuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mv7SHeti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mv7SHeti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903271F000FF;
	Thu, 17 Sep 2026 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789649339;
	bh=w/ZpxzP97FnralLubsMUeeWAjxaK4oiT2d3z39Cm/rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mv7SHetixqzv3eYG8UJupvgZG9ZeJvZRABvLXUPUhjm3Ow+gaeMG9rln11oD79Sy8
	 4VAPS3VFwx+UaP1Vv755a3GcAXNLRStAHyMihuLNc2DHTp0fxWLhFhGx3EEv1mCh36
	 33zeCBz01i/YVl1DhRkJfEBk5fpZo+E5z1Of7nPJhZZ3JZHdIPmUp2Iv9rnylu77im
	 5pvk1WnXXdzfrsJyv5zfLlrvRExgbpHlfk+36hLxjMlHSfM+LK6sM3oZPQGk9n88nl
	 BvycAG90OvlXe98Mmam9+XMdZTNgBjgVsn/Vx/vkAXetIhs/QhngoWNGvSxZSoTATY
	 1vRsyM3kMwx+w==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 1/3] cifs: Scripted clean up fs/smb/client/fscache.h
Date: Thu, 17 Sep 2026 08:48:55 -0400
Message-ID: <20260917124857.223602-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026091652-frantic-unexposed-7b62@gregkh>
References: <2026091652-frantic-unexposed-7b62@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit bc3de356aae666de5d8b5131545be87cf7754431 ]

Remove externs, correct argument names and reformat declarations.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cd2b2b57921d ("smb: client: fix WSL reparse point uid/gid override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fscache.h b/fs/smb/client/fscache.h
index f06cb24f5f3cf..b6c94db5edb94 100644
--- a/fs/smb/client/fscache.h
+++ b/fs/smb/client/fscache.h
@@ -38,12 +38,12 @@ struct cifs_fscache_inode_coherency_data {
 /*
  * fscache.c
  */
-extern int cifs_fscache_get_super_cookie(struct cifs_tcon *);
-extern void cifs_fscache_release_super_cookie(struct cifs_tcon *);
+int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon);
+void cifs_fscache_release_super_cookie(struct cifs_tcon *tcon);
 
-extern void cifs_fscache_get_inode_cookie(struct inode *inode);
-extern void cifs_fscache_release_inode_cookie(struct inode *);
-extern void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update);
+void cifs_fscache_get_inode_cookie(struct inode *inode);
+void cifs_fscache_release_inode_cookie(struct inode *inode);
+void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update);
 
 static inline
 void cifs_fscache_fill_coherency(struct inode *inode,
-- 
2.53.0

