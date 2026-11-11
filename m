Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794405206;
	b=p3Bj4FUtJdDmeANl/rDcA5oda5K/Af6i+BYVTh2qhjNTV/Wm6l5s/rIQ3ZM8k2Z4D4F5
	 7huA4yvS3inNHzeSzdpZCDcZ+GW2arwqlc03Lj4Al0HogvyiscPoU1cear8w2IceAgELv
	 GzBzP4n/44N9LK6VE+A6o0Sfxdy7IHCbP0zANu/8074bv2631NWYiyceyP8A8gDyD8Zfx
	 CHLDLVNC6zhdHeNRedQksE17R0WOi3/4O0mZ3MYbdGU2aVoMMHN9iqcW4df1tfXZTn72B
	 r1A0WPi5cPWmzYdd6Z1Kw34m2iYbZIBp/+Vi/DjoHpKxiSvhn/Sb3wEOFKXPfgeLNyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405206;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WnQ7kTS4QK4Y1l5HtlODrVojIq3DfhLWtwgbnMgLq9M=;
	b=Tgwq5GQE84fYYFCDvZaX55L0bB+F3ydlB70K/3ofAZAobWi+f7N3jAkqYkkgPm5opKIf
	 DiIGpf7zopyV8SAwJdV1muO04hgErZz6+SXrOd6ZnaMkFNdVhOB6xPCZsULaWYEzekd6n
	 DSnB5BBlrX4h1Q4eVTCYJKbnwXxFxOXXim5UyFKDkZyXtNoAvKyn/Ax5rPHxeSO5M5Vhs
	 IiALF9Wt8svenOl4YbBNuZ2t9TO0w5K0Btt7fV6YtyEXrfHR3oiY3ZLcs0cihgUP7sFNZ
	 DdmAuXI+yWvaJdzrolutt4GEVrCxBweGLIDZUyZPPg6ahlXEC68iZ8EmMw11s5GFG2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=35XvWiev;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBE606A321;
	Wed, 11 Nov 2026 13:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91FBE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=35XvWiev
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=WnQ7kTS4QK4Y1l5HtlODrVojIq3DfhLWtwgbnMgLq9M=; b=35XvWieva8+waarRxLUeXbh7QS
	+8v91od8S56rByhoOqe2PL0uVaje3rdl94Bru5TS0ksjdNInlku182Jcnq1Ycs6Ch/Athkp9zM4we
	R5ZRpjUiUEP1M6/5Qz6k4y+MfRyWkGhf0KawgyRkEWLwTe4RIbqPZTELSiVbmwtS0g6C6iAcjMne1
	MFSfE/iTJJGTEKcRBVcqLf3tFhnGS0xXROFOgByoLZJ1GhvDtSyej9OaLTqOxmzZufvGyiDNUJnT5
	RIomQnoOi2w8veh6PNE8hNCh+GhCBKSRjV7L+6wX5rAYi6vGy42ZiD/i0g5YPBg2Lcv0o6vq02eb1
	WMMAd6Xg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xR8lP-00000001SwZ-2dLu;
	Wed, 11 Nov 2026 10:53:24 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] smb: client: flush deferred handles of other names before a hard link open
Date: Wed, 11 Nov 2026 10:53:24 -0300
Message-ID: <20261111135324.4028153-2-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111135324.4028153-1-pc@manguebit.org>
References: <20261111135324.4028153-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_open() flushes an inode's deferred closes before opening a different
name (hard link) of it, so the open can take a fresh lease rather than be
reissued without one (see "smb: client: retry a hard link open without a
lease").  cifs_get_hardlink_path() only triggered that flush when a cached
handle had the same open flags as the new open, so a differently accessed
name - written then read, say - skipped it and opened without a lease.

Match on the name instead: flush when a cached handle for another name of
the inode is open, so those opens keep lease caching too.

Fixes: 262b73ef442e ("smb3 client: fix open hardlink on deferred close file error")
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
---
 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1247d73740a0..f51653cb6432 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2737,7 +2737,7 @@ cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
 	spin_lock(&cinode->open_file_lock);
 
 	list_for_each_entry(open_file, &cinode->openFileList, flist) {
-		if (file->f_flags == open_file->f_flags) {
+		if (open_file->dentry != file_dentry(file)) {
 			rc = -EINVAL;
 			break;
 		}
-- 
2.56.0

