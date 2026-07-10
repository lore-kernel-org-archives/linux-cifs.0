Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187903A1A58
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675020; cv=none; b=dcl2WuV46RP2S+Qf2IuJhS/6JAlpeGTSUSgYNX6mv04m1nYjluj97OtFJDmbdEXfaPRqj36LIgdPEBJWvyfOieBPgWL5joPBZYc8oXiQPTwCpl/azCmVqgbO0sjr5yzNJUXF+Dly98qmzQgF8LiULDtRg89ko50/z1gEikzkBx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675020; c=relaxed/simple;
	bh=byISMcqXKuxYVndjY/uCTt906RZUFC0feV7cY8dvB8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QwbKBs89QvPYPlcjRqs8u10RCwod0tHy0equUAyrM3aoc8C7760QPJJiCK19fOiB9cRPxxklY5dABu1ZHUPTS8FHGpdpKh6yC3bFRPQ/LVrdtYx/0LonPkt7ZKjgR+MqSwkcwG1croe7M9JnVv3Irs2Cu/9fi3Sn2lx5YLNBJrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ATa2/qha; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ATa2/qha; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ATa2/qha";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ATa2/qha"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70096766EA;
	Fri, 10 Jul 2026 09:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oNgEkDJIpVIoVNUnKS9Cy/3JB2amOKbt952TsQuEmSg=;
	b=ATa2/qha+BxpJUKVmpIIn53fGmFdowC9WP1GJSLeyR9gxMV6d0fuSnJ4nJT7qltHhui3NM
	2dWQBiab82UyXZHW+qHREDBz4JN+0VeXoLKeZVrlNQk+fH37O7dRRM3DOuIEYN2u+kthOI
	9kbZZsWuhW9SnBSlNFmKEQ1hf08RUYQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oNgEkDJIpVIoVNUnKS9Cy/3JB2amOKbt952TsQuEmSg=;
	b=ATa2/qha+BxpJUKVmpIIn53fGmFdowC9WP1GJSLeyR9gxMV6d0fuSnJ4nJT7qltHhui3NM
	2dWQBiab82UyXZHW+qHREDBz4JN+0VeXoLKeZVrlNQk+fH37O7dRRM3DOuIEYN2u+kthOI
	9kbZZsWuhW9SnBSlNFmKEQ1hf08RUYQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF04D779BD;
	Fri, 10 Jul 2026 09:16:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JB6eL4i4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:16:56 +0000
From: Samuel Cabrero <scabrero@suse.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de,
	Samuel Cabrero <scabrero@suse.com>
Subject: [PATCH 00/18] SWN: Decouple witness registrations and tcons
Date: Fri, 10 Jul 2026 11:16:19 +0200
Message-ID: <20260710091637.58873-1-scabrero@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -2.80

This patches removes the cached tcon pointers from the witness
registrations.

First patch in the serie reverts the current approach based on snapshots
that fixes a race while processing a received notification. This
patchset implements a different approach based on reference counting and
fixes other races that could occur with concurrent
register/unregister/notification processing.

The witness registration stores now all required information to issue
register/unregister DCERPC calls (like auth info and target address),
and when a notification is received it applies it to all matching
witness-enabled tcons.

Each witness registration has its own task to enforce the registration
in case the userspace daemon is started after mounting the share,
instead of overload the echo task for this purpose.

Samuel Cabrero (18):
  Revert "smb: client: resolve SWN tcon from live registrations"
  smb:client: Adjust witness notification request
  smb:client: Rename variable to match the rest of the code
  smb:client: Split idr remove and release functions
  smb:client: Add a specific task to refresh witness registrations
  smb:client: Store the tcon dstaddr in the witness registration
  smb:client: Fix printf format string
  smb:client: Save memory allocations
  smb:client: Use the correct return code
  smb:client: Improve tcon matching logic
  smb:client: Pass the tcon to cifs_swn_send_register_message
  smb:client: Pass the tcon to notification handlers
  smb:client: Introduce swn_notification struct
  smb:client: Cache auth info
  smb:client: Do not store the tcon reference, find a matching one
  smb:client: Simplify registration creation
  smb:client: Improve registration network and share names handling
  smb:client: Avoid witness re-register if the address did not change

 fs/smb/client/cifs_swn.c | 1179 ++++++++++++++++++++++----------------
 fs/smb/client/cifs_swn.h |    3 -
 fs/smb/client/connect.c  |    3 -
 fs/smb/client/trace.h    |    4 +-
 4 files changed, 682 insertions(+), 507 deletions(-)

-- 
2.54.0

