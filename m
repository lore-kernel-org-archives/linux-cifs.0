Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499A1494AC
	for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727372780; cv=none; b=Og668KBt/3wuwjX2fJHXlR1gRSFFVaNuG86hS6zSBlswO4w8gT33MTSRSD497bS1x0FABz0QpU4jO09Bv9g7lY+8MnFix94S0qQmOOQv87I811P6aWx69tAmwXb6BXTTABdSMRnhtEBqqYv5U6Yw1slcdVSh51czYcMO8iZPGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727372780; c=relaxed/simple;
	bh=f544dVV5d79EXnv3h8h/dASt9ZcKzoE57vlmNbkqrws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ie0GzdsRJzhcPHJU35jVaxcMg8dVF5koI3rkNnDhofVycmirKG6fgMpW8BdJtbOzcfqwS2Xk9Q17bi5e2q819LVc6UfE6ekkgno7zM0S37CvWiAaA45FBdk3KOtnB95pGlRMGP8uLo4SlbU1ipxZy4pxVEUe0b5okVPkjyIym7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e47I9Fel; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yR69vRDJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=e47I9Fel; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yR69vRDJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e47I9Fel";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yR69vRDJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="e47I9Fel";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yR69vRDJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D005A1FCFB;
	Thu, 26 Sep 2024 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727372776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=euKuAXdJjfJT1ckQO0rUhjy0kHgg5Q/054LotC5NyYo=;
	b=e47I9Fel3UPLJsREo3FnA+q7OnFJUNSTdNpVN32QfHSuC0L5J3uzj05YkcMLaAMy9hsjIU
	ZTSsfcggNJ+omKPFdsKK+kC5f8J6TF8tKdttfU32A+2ePN5hLjiSMINB5apCMxhPvsBCb3
	HBAR+4NP0w04o156tnVwIKfLeE/LQsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727372776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=euKuAXdJjfJT1ckQO0rUhjy0kHgg5Q/054LotC5NyYo=;
	b=yR69vRDJ39ASu9ssl8dSP7avKusK2Ez4MAp3KHcY1WlXhMKOH4Y01wJGlaZXU8qPJlCTO2
	kgK6iihc9hvjWiCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727372776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=euKuAXdJjfJT1ckQO0rUhjy0kHgg5Q/054LotC5NyYo=;
	b=e47I9Fel3UPLJsREo3FnA+q7OnFJUNSTdNpVN32QfHSuC0L5J3uzj05YkcMLaAMy9hsjIU
	ZTSsfcggNJ+omKPFdsKK+kC5f8J6TF8tKdttfU32A+2ePN5hLjiSMINB5apCMxhPvsBCb3
	HBAR+4NP0w04o156tnVwIKfLeE/LQsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727372776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=euKuAXdJjfJT1ckQO0rUhjy0kHgg5Q/054LotC5NyYo=;
	b=yR69vRDJ39ASu9ssl8dSP7avKusK2Ez4MAp3KHcY1WlXhMKOH4Y01wJGlaZXU8qPJlCTO2
	kgK6iihc9hvjWiCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56B8D13793;
	Thu, 26 Sep 2024 17:46:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eTzsB+id9WYdMQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Sep 2024 17:46:16 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 0/4] fix async decryption + some secmech cleanups
Date: Thu, 26 Sep 2024 14:46:12 -0300
Message-ID: <20240926174616.229666-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -2.80
X-Spam-Flag: NO

Hi,

Patch 1/4:
Fix a use-after-free in the crypto API when using the same TFM in parallel to decrypt SMB2
messages. 'parallel' meaning only when 'min_enc_offload/esize' is > 0, so smb2_decrypt_offload()
is called.

Patch 2/4:
We store crypto keys in cifs_ses and we find them on every crypto operation by the Session ID.
Using a crypto TFM with the crypto keys set right after session setup would be ideal, but would
require a non-trivial redesign of the module.  So, instead, allocate a TFM on the primary server
only, and keep finding/setting the keys on a per-usage basis.

Patches 3 and 4/4:
HMAC-MD5 and SHA-512 TFMs are only used on Session Setup and each contained in a single function.
The allocated memory size doesn't hurt, but makes no sense to keep them around when they're not
going to be used again so soon (or at all).

Reviews appreciated.


Cheers,

Enzo Matsumiya (4):
  smb: client: fix UAF in async decryption
  smb: client: allocate crypto only for primary server
  smb: client: make HMAC-MD5 TFM ephemeral
  smb: client: make SHA-512 TFM ephemeral

 fs/smb/client/cifsencrypt.c   | 151 ++++++++++++++--------------------
 fs/smb/client/cifsglob.h      |   2 -
 fs/smb/client/sess.c          |   2 +-
 fs/smb/client/smb2misc.c      |  28 +++----
 fs/smb/client/smb2ops.c       |  47 ++++++-----
 fs/smb/client/smb2pdu.c       |  10 +++
 fs/smb/client/smb2proto.h     |   2 +-
 fs/smb/client/smb2transport.c |  30 +------
 8 files changed, 116 insertions(+), 156 deletions(-)

-- 
2.46.0

