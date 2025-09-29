Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129382FE599
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 13:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759152509; cv=none; b=Pp4hBBG3l+UvRda+yyzXDu/wyt1+9Zrh1LazmhUXMFXe5Yr5eRBIv8ysP3qyalfZSDjd1WqeC6HtxsQefw7ZGp10SPi5RDW2/Hnz6xUYhvBZu0QUbrmtMnS2oHZKZlAAJ+wgzKkhXrQvk8TSVcYTcnGwwq/NPNK9o0CJD2PTFSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759152509; c=relaxed/simple;
	bh=kWl9jbySe0iP/8r+SWw0PJfeCTxa8gWgAw3XFsKLwQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DvQn/wfU0T9CyOwI9tnxl3kbOdR1fzNCnt5A9+LMmTfmf4NDYEJ/5njgc0RegRY08NRihE//Pd9amSlmGmtg3GvIsyIJIRfQMEhqG2/QbzU9zwAwpvMwW88WMcBGumQdrFreWg1rbarUUwonTTOH1MJm6KDfxeS4lkWd5rQ+2Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AHo9ciMM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tva9F0Y0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AHo9ciMM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Tva9F0Y0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AHo9ciMM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tva9F0Y0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AHo9ciMM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Tva9F0Y0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 820FC2DD92;
	Mon, 29 Sep 2025 13:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q7uzmjqAYyXfplVIELtGK1J68zWLHWmHuFbS0UL264g=;
	b=AHo9ciMMrzPhnEniKXi+9AU6zPBPzptZZM/j6VvCGUQsSA//LRiqX9ID2njBbqVrSrsKDI
	/qiSaKTayqFBQecGNHXVcWCqq6hQI60gKWyl8+r/f7vHyKrGpq9idkXtRDbp7RAP1xI5rO
	3WaEbep7O1XJf7dDn0FLBDVcfOHR6P0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q7uzmjqAYyXfplVIELtGK1J68zWLHWmHuFbS0UL264g=;
	b=Tva9F0Y0QJQXTjK1xYc9EQmQFV40QivUpMiDeai0IN9G5ZyDOCfiz6uLfpMDdlFdUM5Zsb
	YQNHV2pT6sOyovDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759152504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q7uzmjqAYyXfplVIELtGK1J68zWLHWmHuFbS0UL264g=;
	b=AHo9ciMMrzPhnEniKXi+9AU6zPBPzptZZM/j6VvCGUQsSA//LRiqX9ID2njBbqVrSrsKDI
	/qiSaKTayqFBQecGNHXVcWCqq6hQI60gKWyl8+r/f7vHyKrGpq9idkXtRDbp7RAP1xI5rO
	3WaEbep7O1XJf7dDn0FLBDVcfOHR6P0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759152504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q7uzmjqAYyXfplVIELtGK1J68zWLHWmHuFbS0UL264g=;
	b=Tva9F0Y0QJQXTjK1xYc9EQmQFV40QivUpMiDeai0IN9G5ZyDOCfiz6uLfpMDdlFdUM5Zsb
	YQNHV2pT6sOyovDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E64713782;
	Mon, 29 Sep 2025 13:28:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gzezMXeJ2miNGwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 29 Sep 2025 13:28:23 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 00/20] smb: client: cached dir fixes and improvements
Date: Mon, 29 Sep 2025 10:27:45 -0300
Message-ID: <20250929132805.220558-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

Hi,

This patch series aims to refactor cached dir related code in order to
improve performance, improve code maintenance/readability, and of course
fix several, existing and potential, bugs.

Please note that the below only makes sense to the whole series applied.

Semantic fixes:
- cfid->has_lease vs cfid->is_open: when opening a cached dir, we get a fid
  (is_open) and a lease (has_lease), however, has_lease is used differently
  throughout the code, meaning, most of the time, that the cfid is 'usable'
  (fix in patch 11)
- refcounting also follows has_lease, up to a point, when we need to
  'steal' the reference, then we might have a cfid with 2 refs but
  has_lease == false (fix in patches 1-5)
- cfid lookup: currently done with open_cached_dir() with @lookup_only arg,
  but that is not visibly good-looking and also highly inflexible (because
  it only works for paths (char *).


Technical fixes:
- due to the many "Dentry still in use" bugs, cleaning up a cfid has become
  too complex -- there are 3 workers to do that asynchronously, and the
  release callback itself.  Complexity aside, this still has bugs because
  open_cached_dir() design doesn't account for any concurrent invalidation,
  leading sometimes to double opens/closes, sometimes straight UAF/deadlock
  bugs (examples upon request).
  (fix in patches 1-11)
- locking: the list lock is not used consistently; sometimes protecting only
  the list, sometimes protecting only a cfid, sometimes both.
  cfid->fid_lock only protects ->dentry, nothing else.  This leads to
  inconsistent data being read when a concurrent invalidation occurs, e.g.
  cached_dir_lease_break() (sets ->time = 0) vs cifs_dentry_needs_reval()
  (reads ->time unlocked)
  * also, open_cached_dir() always assume it has >1 refs, but such
    assumption is proven wrong when SMB2_open_init() triggers
    smb2_reconnect(), and kref_put() is ran locked in the rc != 0 case,
    leading to a deadlock because the extra ref has been dropped async
  (both fixed in patch 19 and others)

Improvements:
Having all above fixes and changes allows a cleaner code with a simpler
design:
- code readability is improved (cf. whole series)
- usage of cached dirs in places that weren't making use of it (cf. patches
  12-18)
- patch 19 (locking) not only fixes the synchronization problems, but RCU +
  seqcounting allows faster lookups (read-mostly) while also allowing
  consistent reads and stability for callers (prevents UAF)
- because a directory is always a parent, bake-in support for when opening
  a path, ParentLeaseKey can be set for any target child (cf. patch 12)


Cheers,

Enzo Matsumiya (20):
  smb: client: remove cfids_invalidation_worker
  smb: client: remove cached_dir_offload_close/close_work
  smb: client: remove cached_dir_put_work/put_work
  smb: client: remove cached_fids->dying list
  smb: client: remove cached_fid->on_list
  smb: client: merge {close,invalidate}_all_cached_dirs()
  smb: client: merge free_cached_dir in release callback
  smb: client: split find_or_create_cached_dir()
  smb: client: enhance cached dir lookups
  smb: client: refactor dropping cached dirs
  smb: client: simplify cached_fid state checking
  smb: client: prevent lease breaks of cached parents when opening
    children
  smb: client: actually use cached dirs on readdir
  smb: client: wait for concurrent caching of dirents in cifs_readdir()
  smb: client: remove cached_dirent->fattr
  smb: client: add is_dir argument to query_path_info
  smb: client: use cached dir on queryfs/smb2_compound_op
  smb: client: fix dentry revalidation of cached root
  smb: client: rework cached dirs synchronization
  smb: client: cleanup open_cached_dir()

 fs/smb/client/cached_dir.c | 946 ++++++++++++++++---------------------
 fs/smb/client/cached_dir.h |  74 +--
 fs/smb/client/cifs_debug.c |   7 +-
 fs/smb/client/cifsfs.c     |   2 +-
 fs/smb/client/cifsglob.h   |   5 +-
 fs/smb/client/dir.c        |  27 +-
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/inode.c      |  38 +-
 fs/smb/client/misc.c       |   9 +-
 fs/smb/client/readdir.c    | 146 +++---
 fs/smb/client/smb1ops.c    |   6 +-
 fs/smb/client/smb2inode.c  |  48 +-
 fs/smb/client/smb2misc.c   |   2 +-
 fs/smb/client/smb2ops.c    |  49 +-
 fs/smb/client/smb2pdu.c    |  99 +++-
 fs/smb/client/smb2proto.h  |  10 +-
 16 files changed, 733 insertions(+), 737 deletions(-)

-- 
2.49.0

