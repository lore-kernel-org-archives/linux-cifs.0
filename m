Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113B6426ECA
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515562; cv=none; b=AMAYNAuvbHb6xiI/9pXxjO1hxepXxA5ReQiiNnpfGquffV9wBLafL2k7JuoO4DHTtJhwAT2ITj/JDINo4VxM2P7DYDm8A1FExgMYFzEWXj6qBi1UKBlNXNUdxDELamnMC6KLONZyl4Gz3aiyT5BY9C6xvmf0AiuAsI5i87xVu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515562; c=relaxed/simple;
	bh=luEjh2s90OYy4i79HDDnTId75lNGpKBGW7W0TWw2jBM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y38fis+YIMJIspE2nJH4iHbrWkSV0t7F6a52h7e+sJKLBStuT7uX67HusggaQRyUqE8fr8xPbOpcFaLSTcFlOfT1DO6Di4CHUpf4GwL2stLo6JZ6z/J3c81cXtsKxbBVbqVTNcOJYh930Pdg5u4HrX04VpzaM460aU8BCpsCIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=epjFHDia; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=b1nhPzym; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=epjFHDia; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=b1nhPzym; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="epjFHDia";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="b1nhPzym";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="epjFHDia";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="b1nhPzym"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3BEFE75E14;
	Wed,  8 Jul 2026 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783515559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RNr8UnFdrfH5bBBKEdngxADYDr9vb1+qBjT0noo836s=;
	b=epjFHDiatgk+kSEtqDqoguqJh09buRFCCW25NddjH+AZGnGyi8CQpVLGWlSadAOIKA/eSc
	WD9EvlXYkuQAl8QKPBISC6rPC5jWGXNBwkSrfMWuxWoP+xM3YotLRRBMV4WnMhm5M2QIRc
	B/K9RBXwLGsVql2oXqZrOmeaH6GxqnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783515559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RNr8UnFdrfH5bBBKEdngxADYDr9vb1+qBjT0noo836s=;
	b=b1nhPzymCvqjwThkDYO9UGv6p+MEn3ztXGZb0U/cmme2IYzUcAgktCZ15fAY0m1hVjuSPw
	i5zOGzzCB0ZDIXAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=epjFHDia;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b1nhPzym
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783515559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RNr8UnFdrfH5bBBKEdngxADYDr9vb1+qBjT0noo836s=;
	b=epjFHDiatgk+kSEtqDqoguqJh09buRFCCW25NddjH+AZGnGyi8CQpVLGWlSadAOIKA/eSc
	WD9EvlXYkuQAl8QKPBISC6rPC5jWGXNBwkSrfMWuxWoP+xM3YotLRRBMV4WnMhm5M2QIRc
	B/K9RBXwLGsVql2oXqZrOmeaH6GxqnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783515559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RNr8UnFdrfH5bBBKEdngxADYDr9vb1+qBjT0noo836s=;
	b=b1nhPzymCvqjwThkDYO9UGv6p+MEn3ztXGZb0U/cmme2IYzUcAgktCZ15fAY0m1hVjuSPw
	i5zOGzzCB0ZDIXAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC101779AF;
	Wed,  8 Jul 2026 12:59:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qz+SIKZJTmrsJwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 08 Jul 2026 12:59:18 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org,
	smfrench@gmail.com,
	tom@talpey.com,
	senozhatsky@chromium.org,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH v2] smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer
Date: Wed,  8 Jul 2026 09:59:12 -0300
Message-ID: <20260708125912.1223345-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3BEFE75E14
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,talpey.com,chromium.org,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email,suse.de:mid];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Free it unconditionally after ksmbd_alloc_user() calls.

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
v2:
- use kvfree()
- move free to ksmbd_alloc_user() callers

 fs/smb/server/auth.c             | 1 +
 fs/smb/server/mgmt/user_config.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 86f521e849d5..ffc4e1c8b287 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -436,6 +436,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 		resp_ext = ksmbd_ipc_login_request_ext(resp->login_response.account);
 
 	user = ksmbd_alloc_user(&resp->login_response, resp_ext);
+	kvfree(resp_ext);
 	if (!user) {
 		ksmbd_debug(AUTH, "login failure\n");
 		retval = -ENOMEM;
diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index cf45841d9d1b..03184a3303b9 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -26,6 +26,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
 		resp_ext = ksmbd_ipc_login_request_ext(account);
 
 	user = ksmbd_alloc_user(resp, resp_ext);
+	kvfree(resp_ext);
 out:
 	kvfree(resp);
 	return user;
-- 
2.54.0

