Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC7F193
	for <linux-cifs@vger.kernel.org>; Sat, 31 Aug 2024 00:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063029; cv=none; b=mqUsicNq9rWA2ow3n0I0uHdwueOAbvpuBsmDSpULmtB/54RQ7BwYqqERlFpEix0zBlvhfdqYkJ64mMc1DY3ZGKjJo0eMEAj/dGEhCwUD0Wc+2tw+MSCLTl2dnhsziDxjbZLVy1v3k4E/Vkv4YCYjgJTSNqsTQPVyF3xuGkJoqKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063029; c=relaxed/simple;
	bh=ok0ehTdJtbaeDlUX+5bgEePesENtD+zJTE1GUIU11fc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HxZkmeE84adSeo+fiGWDKpJoz+6oa4mY7DhHh+sEQJ04Lo+FWgb3AViwDGKNq5W4kkSSZTyT6QNqsZxtYKyQxGIoS48cAYYo4Tkd1KQrt4V/TCcK7Fiaj0V63InK/pAtZE+UPoHvK0yxAAPX2tyy55yCKhzKy/vb7sVws43X7oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=m1iky1xM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PMoYcOZy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1DW7lXhH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RVP/4eE0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="m1iky1xM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PMoYcOZy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1DW7lXhH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RVP/4eE0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E61881F7FC;
	Sat, 31 Aug 2024 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725063026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qpbhKcL5DUv4Hj0EOM8MtjKHgAA+YByIVk6rfdgGHGY=;
	b=m1iky1xMZbKopgbquPoJ0rbrXx+56ymFNXpf5myByWL8eusDFB8JjN3QdB9sxOoK4ErokC
	k95f8+OykdjTSEoMrsv+CjRlJYxK2kwga9XuoHhx1hu9ohPPvTfPx5UyZg/Qo3/41/0ePw
	lnuc//k6CqYLqniLISGvSqjdWroYYvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725063026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qpbhKcL5DUv4Hj0EOM8MtjKHgAA+YByIVk6rfdgGHGY=;
	b=PMoYcOZytAe68O2/5EM+s7vRslVZxxLN5F3ffPJHr1+BLa5MuvrIOHerj2ofNuVkWCSFmT
	04bLr2nwkZ/WDoBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1DW7lXhH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="RVP/4eE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1725063025; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qpbhKcL5DUv4Hj0EOM8MtjKHgAA+YByIVk6rfdgGHGY=;
	b=1DW7lXhHeW3V8w+yzadpqrZUi9C3i369/6r3ZILgYU1ocp+qOFlYEEY9V/k8kEOQElPaRQ
	acFPMRUO6vc8KnVvILNOcTEjud6Ga3EMydEdfYSO0b9B3yBgfcaZodNfkjtzbmeFDIawju
	9qKtXXZOGe4ph1pN9s6LRNMoVtCrO9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1725063025;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qpbhKcL5DUv4Hj0EOM8MtjKHgAA+YByIVk6rfdgGHGY=;
	b=RVP/4eE0p0YZuMea7Dr0tCJDevNfuHA05x6bNNwXWmpXlzk02U2PwMxC15Azw2D71uiB+u
	WeqqmOU51SfMa8Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7040A139D4;
	Sat, 31 Aug 2024 00:10:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CwlODnFf0maNAgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Sat, 31 Aug 2024 00:10:25 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [RFC PATCH] smb: client: force dentry revalidation if nohandlecache is set
Date: Fri, 30 Aug 2024 21:09:37 -0300
Message-ID: <20240831000937.8103-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E61881F7FC
X-Spam-Level: 
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -5.51
X-Spam-Flag: NO

Some operations return -EEXIST for a non-existing dir/file because of
cached attributes.

Fix this by forcing dentry revalidation when nohandlecache is set.

Bug/reproducer:
Azure Files share, attribute caching timeout is 30s (as
suggested by Azure), 2 clients mounting the same share.

tcon->nohandlecache is set by cifs_get_tcon() because no directory
leasing capability is offered.

    # client 1 and 2
    $ mount.cifs -o ...,actimeo=30 //server/share /mnt
    $ cd /mnt

    # client 1
    $ mkdir dir1

    # client 2
    $ ls
    dir1

    # client 1
    $ mv dir1 dir2

    # client 2
    $ mkdir dir1
    mkdir: cannot create directory ‘dir1’: File exists
    $ ls
    dir2
    $ mkdir dir1
    mkdir: cannot create directory ‘dir1’: File exists

"mkdir dir1" eventually works after 30s (when attribute cache
expired).

The same behaviour can be observed with files if using some
non-overwritting operation (e.g. "rm -i").

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Tested-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index dd0afa23734c..5f9c5525385f 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2427,6 +2427,9 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	if (!lookupCacheEnabled)
 		return true;
 
+	if (tcon->nohandlecache)
+		return true;
+
 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
 		spin_lock(&cfid->fid_lock);
 		if (cfid->time && cifs_i->time > cfid->time) {
-- 
2.46.0

