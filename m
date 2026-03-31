Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45D31AF2D
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 01:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774920334; cv=none; b=K6DBQi8UGQ4HCC+KZD7tlzmQ3wlnbz/Q+/PE3wyOiPYx0NKpbtevzmbxD5dcxopfa80P/n1cVnEj7CeNCC9CIdlfkvy26zmtpkmp5JzQg/tOxnnNi3qUKVsfF84PCyx/dFHYipG9kXTRL5OEy7qH7OCiVX/AfbYxWO4fxSnmqyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774920334; c=relaxed/simple;
	bh=kzpZhI+Ncv0/e42qPalL8ozoiLD7ewzW3TpRaQDhhoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r4Xgslw8LIWBrp0cKGeE5c+suO9iuRiuLVGdUclPiLFhUY89koR3x7cRKjC5tEkw7rfECYnCH7eBgGhXGfSGdNWIh7Z4eS/da07B+DW8yvsTRuDzGN44g+lBIU/rZ5awwvo8Kk03OwL2DZ5fSeNA3+r9kcWvKFqmlgkcdmMMJmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kdTUIOUB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2fb9Rhe9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kdTUIOUB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2fb9Rhe9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kdTUIOUB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2fb9Rhe9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kdTUIOUB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2fb9Rhe9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAF615BE52;
	Tue, 31 Mar 2026 01:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774920331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IWIelUY2BJnOxBiRWb8fmYCCjnCrJwlxzVPbuC9V8MU=;
	b=kdTUIOUB7Rl1QLjpvhMLCP0G6ei8LAjvSGhLdKb2pHtofzqc0sMuuWCS5rJWNA6yKUtWas
	pubKX+Hr75lPbkXMddveLPnLRsiiSIwlFDPYBzDUf0x0QlMFUY8FpMyop6veuYVE0mvymO
	FyMYCHg3fjf1T57Rmjvsm9XEQhlsXA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774920331;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IWIelUY2BJnOxBiRWb8fmYCCjnCrJwlxzVPbuC9V8MU=;
	b=2fb9Rhe9IFLtmFxygNZUcXymb+6uil38p8QP76iyWi2UyeoRBrENkgH2mVTqisruYpBUnS
	5azsXAkC0B7SE3Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774920331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IWIelUY2BJnOxBiRWb8fmYCCjnCrJwlxzVPbuC9V8MU=;
	b=kdTUIOUB7Rl1QLjpvhMLCP0G6ei8LAjvSGhLdKb2pHtofzqc0sMuuWCS5rJWNA6yKUtWas
	pubKX+Hr75lPbkXMddveLPnLRsiiSIwlFDPYBzDUf0x0QlMFUY8FpMyop6veuYVE0mvymO
	FyMYCHg3fjf1T57Rmjvsm9XEQhlsXA8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774920331;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IWIelUY2BJnOxBiRWb8fmYCCjnCrJwlxzVPbuC9V8MU=;
	b=2fb9Rhe9IFLtmFxygNZUcXymb+6uil38p8QP76iyWi2UyeoRBrENkgH2mVTqisruYpBUnS
	5azsXAkC0B7SE3Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88C014A0A2;
	Tue, 31 Mar 2026 01:25:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id il9SD4oiy2mpbgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 31 Mar 2026 01:25:30 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>
Subject: [PATCH 0/3] mount.cifs: minor buflen tracking cleanups
Date: Tue, 31 Mar 2026 11:37:50 +1100
Message-ID: <20260331012508.17410-1-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

These changes are minor cleanups to go atop the bugfix
"mount.cifs: fix buffer overrun in set_password"
https://lore.kernel.org/linux-cifs/20260331000911.16062-1-ddiss@suse.de/T/#u

David Disseldorp (3):
      build_assert: add ccan build_assert.h header
      mount.cifs: adjust get_password_from_file() buf size
      mount.cifs: remove runtime pass_length calculation

 build_assert.h | 40 ++++++++++++++++++++++++++++++++++++++++
 mount.cifs.c   | 18 ++++++++----------
 2 files changed, 48 insertions(+), 10 deletions(-)
 create mode 100644 build_assert.h

