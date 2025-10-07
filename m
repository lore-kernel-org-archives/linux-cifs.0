Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9652E889C
	for <linux-cifs@vger.kernel.org>; Tue,  7 Oct 2025 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759858997; cv=none; b=mxBUHwupg/fhgYBpVzpdgiE3UczmnTK9ePoRR0zeiRshzxxbMz5gSjivNn4zEIBc2DZ8EmN6PakympBydfMMSOSeQP5X93ZGd1OHcm3K6BIiNN+/eiu1ZiRB/YV1sn7G0kuwn7Fj/6FASlePMVh7bSmIsHyJRwCSwxl0t2eQAuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759858997; c=relaxed/simple;
	bh=pqt25CC84V2YDyTH9aYJEWPwz27BrqFbVflGAeBPFHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S0WriDfsWuRp7B3OI5K0iOXh8quy2RPMTpWIScJF7FEMtZDhqklCaKAGy4u3Yx4COSHWev7RH1GWBMGVyDKAa501KKGgBqyW54yVP8B1HE4vUninl9kJGr8xJkExDS+uvYoSpORsoijO7TfkdA2S6l4MARYBHIC0F380a1L/IAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NzJ9Fby3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FG31sljD; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NzJ9Fby3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FG31sljD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NzJ9Fby3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FG31sljD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NzJ9Fby3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FG31sljD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2B9820AAD;
	Tue,  7 Oct 2025 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759858993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kbxGZ3w4od6AnNpyeDQTt1XaERTQ/7yciIWaxS8rZLw=;
	b=NzJ9Fby3ULK29C/rKl3kDexXdIHibPlh6XN6sTnqYI1PlXwcLRZZ+GlFAQHzipQlgQmenE
	rpE38Fwj+zKb2ObEJTfdscwbtzCPKEdnR2x1c7cAQR8IP75jeO5FGPC8GMLRHwi493SI/0
	tn98kQ7obVEVDW+mHT8npzik03ZCxN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759858993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kbxGZ3w4od6AnNpyeDQTt1XaERTQ/7yciIWaxS8rZLw=;
	b=FG31sljDWmL+OjuiUWKJMwkFCPbYu5M0tKW4iSgDVHjfP0sOBWQcbgscYpF2uFYEdkV44z
	WpZFx0PSZXmXKTBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NzJ9Fby3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FG31sljD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759858993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kbxGZ3w4od6AnNpyeDQTt1XaERTQ/7yciIWaxS8rZLw=;
	b=NzJ9Fby3ULK29C/rKl3kDexXdIHibPlh6XN6sTnqYI1PlXwcLRZZ+GlFAQHzipQlgQmenE
	rpE38Fwj+zKb2ObEJTfdscwbtzCPKEdnR2x1c7cAQR8IP75jeO5FGPC8GMLRHwi493SI/0
	tn98kQ7obVEVDW+mHT8npzik03ZCxN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759858993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kbxGZ3w4od6AnNpyeDQTt1XaERTQ/7yciIWaxS8rZLw=;
	b=FG31sljDWmL+OjuiUWKJMwkFCPbYu5M0tKW4iSgDVHjfP0sOBWQcbgscYpF2uFYEdkV44z
	WpZFx0PSZXmXKTBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F88613693;
	Tue,  7 Oct 2025 17:43:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JSoREjBR5WjbdwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Oct 2025 17:43:12 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2 00/20] cached dir fixes and improvements
Date: Tue,  7 Oct 2025 14:42:44 -0300
Message-ID: <20251007174304.1755251-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: F2B9820AAD
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01

Hi,

Sending v2 of this series.  Please refer to v1 cover letter for details.

Cheers,

Enzo


v1 -> v2:
- rebased on mainline (previously based on cifs/for-next)
- already includes the fixes sent individually for patches 12 and 19
- fixed issues reported by kernel test robot for patches 13, 16, 19
- ran smatch locally with whole series applied (all good)

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
  smb: client: skip dentry revalidation of cached root
  smb: client: rework cached dirs synchronization
  smb: client: cleanup open_cached_dir()

 fs/smb/client/cached_dir.c | 985 +++++++++++++++++--------------------
 fs/smb/client/cached_dir.h |  81 +--
 fs/smb/client/cifs_debug.c |   8 +-
 fs/smb/client/cifsfs.c     |   4 +-
 fs/smb/client/cifsglob.h   |   5 +-
 fs/smb/client/dir.c        |  64 +--
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/inode.c      |  35 +-
 fs/smb/client/misc.c       |   9 +-
 fs/smb/client/readdir.c    | 147 +++---
 fs/smb/client/smb1ops.c    |   6 +-
 fs/smb/client/smb2inode.c  |  57 ++-
 fs/smb/client/smb2misc.c   |   2 +-
 fs/smb/client/smb2ops.c    |  44 +-
 fs/smb/client/smb2pdu.c    |  76 ++-
 fs/smb/client/smb2proto.h  |  10 +-
 16 files changed, 777 insertions(+), 758 deletions(-)

-- 
2.51.0

