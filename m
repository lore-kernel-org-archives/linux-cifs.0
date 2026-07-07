Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778C43BC69C
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 20:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783456439; cv=none; b=rMqWLy8Efn0Xkzema8ZzJdvfAu1a2QHH7aHdTkbkYf8UjmVN3kQHYlSR4UePsgq/4tkCT1CfUj8uCiKf64gFJXaIpHVnHSi/bQm4Z3aX2C8ZYb+EHINJP9Mjxsou4fkCIlqDAAyixmRmHTaeNcXkjFZ71QC3zz0cE6C/hQMhnfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783456439; c=relaxed/simple;
	bh=XBhrL4eKKeN61H41DRoiP0TSHWxeeDT9iCac2JHi1lE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DfzYRODK0iosmUNc6HU6x1DZ+qhE3Qs82GRjaI6X7P0qXG0bDdE8kIE1dNoDi49eSQv3RAUp0nrMjQvu7t+fbNlrvEXwMV50zErq+msSC5X+MI88bMczHv1qvC2ETtgSqh5TFXPAKYXdnt7x2s2QqKPRRYGs9/FmjpVpUEHhx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ix26tRX2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jiydXQQP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ix26tRX2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jiydXQQP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ix26tRX2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jiydXQQP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ix26tRX2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jiydXQQP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78B56743E9;
	Tue,  7 Jul 2026 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783456436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=etqDneNUDFiv0Dz767zbhDVqNqDfnHZcOP82UjDxOdA=;
	b=ix26tRX2pJ5XJ8vBBq2piHpSkpMuTsfBzJJb5kKFCA9vBdTFR90t3MZaC1He1uuePvFKzb
	gW3jFrISwFv88pAWzXmjl2Fq2B9KtMxsjJHHT7MxPYNsc77eRC0lfAHUrC4/NhoEeqyKzu
	4npuXv+gQ7oBCxsytkfP4iIo5GxFHWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783456436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=etqDneNUDFiv0Dz767zbhDVqNqDfnHZcOP82UjDxOdA=;
	b=jiydXQQPday3EVSySgqQGbq2zP+uclIfF+LmEIY6UgTso4VAjnYxRh8A7w9CUmDcnuPhl7
	tlxHC0KT8v+C3eAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783456436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=etqDneNUDFiv0Dz767zbhDVqNqDfnHZcOP82UjDxOdA=;
	b=ix26tRX2pJ5XJ8vBBq2piHpSkpMuTsfBzJJb5kKFCA9vBdTFR90t3MZaC1He1uuePvFKzb
	gW3jFrISwFv88pAWzXmjl2Fq2B9KtMxsjJHHT7MxPYNsc77eRC0lfAHUrC4/NhoEeqyKzu
	4npuXv+gQ7oBCxsytkfP4iIo5GxFHWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783456436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=etqDneNUDFiv0Dz767zbhDVqNqDfnHZcOP82UjDxOdA=;
	b=jiydXQQPday3EVSySgqQGbq2zP+uclIfF+LmEIY6UgTso4VAjnYxRh8A7w9CUmDcnuPhl7
	tlxHC0KT8v+C3eAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02F71779AE;
	Tue,  7 Jul 2026 20:33:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qbBiLrNiTWrhSwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 07 Jul 2026 20:33:55 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	smfrench@gmail.com,
	tom@talpey.com,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer
Date: Tue,  7 Jul 2026 17:33:34 -0300
Message-ID: <20260707203334.1164183-1-ematsumiya@suse.de>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,talpey.com,chromium.org,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -2.80

Free it in ksmbd_alloc_user() (the only function that uses it).

kmemleak splat:
  unreferenced object 0xffff888103b83540 (size 192):
    comm "pool-0", pid 16970, jiffies 4377290937
    hex dump (first 32 bytes):
      00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace (crc 408ccc66):
      __kvmalloc_node_noprof+0x730/0x920
      handle_generic_event+0xec/0x1a0 [ksmbd]
      genl_family_rcv_msg_doit+0xe0/0x130
      genl_rcv_msg+0x181/0x290
      netlink_rcv_skb+0x4f/0x100
      genl_rcv+0x28/0x40
      netlink_unicast+0x1e6/0x2c0
      netlink_sendmsg+0x20a/0x450
      ____sys_sendmsg+0x2e8/0x310
      ___sys_sendmsg+0x78/0xc0
      __sys_sendmsg+0x63/0xc0
      do_syscall_64+0xa1/0x670
      entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/server/mgmt/user_config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index cf45841d9d1b..2319c6cc67da 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -66,12 +66,14 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		ksmbd_debug(SMB, "supplementary groups : %d\n", user->ngroups);
 	}
 
+	kfree(resp_ext);
 	return user;
 
 err_free:
 	kfree(user->name);
 	kfree(user->passkey);
 	kfree(user);
+	kfree(resp_ext);
 	return NULL;
 }
 
-- 
2.54.0

