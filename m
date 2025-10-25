Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A89D31CA7F;
	Sat, 25 Oct 2025 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409676; cv=none; b=FLwlPG6aXafzPQHlaXRrvh5STarlcvi+Y4gKgOXrGRi8uDvQpkFUdOGMxg8TLUNLvs7Dt2RE4+eouO2J/nW6r12SSYSibM0YxTWWNIJS2cjDvMLijpRIxAYPKjus8l1jkSkBaULOuznvN/hB+J8860DjwuLK3R/oY9lWtE3M6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409676; c=relaxed/simple;
	bh=oCUzzgOGKSchd6M+4cdjAUBUXeTVr9m3TjFEbU6btew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ppnnERA25HUvDU62X7oBb/KGO6F4xk0UpKalH9Z4zLA2kGnl/QQv0ZsN0/XGbPR+ExppqJjf/T7Pt920tssu9Ufb+YneV1HCkQOCqzOvp8T4ORRd7btAYmnoOSgpAtFiEme8nOevzTa8LWU006/40NUIknTX5QTazmmizab1DOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upKNEyMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upKNEyMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C985C4CEFB;
	Sat, 25 Oct 2025 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409676;
	bh=oCUzzgOGKSchd6M+4cdjAUBUXeTVr9m3TjFEbU6btew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upKNEyMC68hREEmp3TKMhG+241XBXSUFGqAMsDCov717irrGdk/exlZ5juKut6nbA
	 PlXLt5IOe/f6rVjBILz9wOrDJKrXJvbFYgPVt75LiPPDZkGbyMjN6kuog+55OB6EX5
	 FTKksyLbMWWfyci27KgUTRA6QVV6F2BJGmoyiaA+uAHa4lZ6B2LYbcGJSE2TlgANH2
	 L9E3oIYVPpQQ/Ab0/7KmnUeM9c0Sx2s2qNKoa3oToZqLjRrkRGYQq6mjTJGj51/2/7
	 BObJnf+TVZ/cKd0Ii9T4X+T+3aL3gIn1PBqp1Ne9ea4uokpsbbFrnUJ2vVtJ+9jmiO
	 kCrshas2ETziw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.17] smb: client: update cfid->last_access_time in open_cached_dir_by_dentry()
Date: Sat, 25 Oct 2025 12:00:48 -0400
Message-ID: <20251025160905.3857885-417-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit 5676398315b73f21d6a4e2d36606ce94e8afc79e ]

open_cached_dir_by_dentry() was missing an update of
cfid->last_access_time to jiffies, similar to what open_cached_dir()
has.

Add it to the function.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The change makes `open_cached_dir_by_dentry()` refresh
  `cfid->last_access_time` just like `open_cached_dir()` already does,
  so cached handles looked up by dentry stay marked as recently used
  (`fs/smb/client/cached_dir.c:430`, compare with
  `fs/smb/client/cached_dir.c:197`). Without this, directories accessed
  through this path age out after the default 30 s timeout
  (`fs/smb/client/cifsfs.c:120`) regardless of activity.
- Eviction is driven by `cfids_laundromat_worker()`, which examines
  `last_access_time` to drop “stale” entries
  (`fs/smb/client/cached_dir.c:747-759`). Because lookups and
  revalidation frequently reach the cache via
  `open_cached_dir_by_dentry()` (`fs/smb/client/inode.c:2706` and
  `fs/smb/client/dir.c:732`), the missing update causes active
  directories to be torn down prematurely, forcing unnecessary reopen
  traffic and defeating the regression fix that introduced the field.
- The bug was introduced when `last_access_time` was added
  (`3edc68de5629`, included in v6.17), so affected stable trees already
  carry the infrastructure this patch relies on. The fix itself is a
  single assignment under the existing spinlock, so the regression risk
  is negligible and no additional prerequisites are required.

 fs/smb/client/cached_dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b69daeb1301b3..cc857a030a778 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -423,6 +423,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
+			cfid->last_access_time = jiffies;
 			spin_unlock(&cfids->cfid_list_lock);
 			return 0;
 		}
-- 
2.51.0

