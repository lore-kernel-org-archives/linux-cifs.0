Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B84E4DDB4F
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607856; cv=none; b=BxYKbmtn+5g/L4QZ1F6JvCnRArRB9fFvLbkeettx/iynQybbP1Bv191f00hmpGbDo9yWfWPkCGViaLt5iync3b2h08u/62SsR4lOzvEmQoclLQwowVngEf7EvtZnTm3p2flA+s5QDHireuCgy7e92JnDLsfYAqtAwpI6r65hv60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607856; c=relaxed/simple;
	bh=T7XtHqtCtO+PXW7C5qLUlB3/u0AC2R6ckd6PP/x7Yec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c1SsebbQrSHBmRItguUfgKo7F4lwbSpgegWGzFjxVUF2HseW7qlkmCwH2DPJYIfIEkCLGG1EfFwTH/RDU+eJUdljPdQbqUFo+IvRk5fdB9qQ0VSGaVXwUACS9VjH1k6+gVa6f+9RUhpmYXPjwN2B5qi7284s8a4Kym5/qLemM2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0v2gyYea; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k2v4ZoH6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VSdqD/wr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1IEKmTBB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0v2gyYea";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k2v4ZoH6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VSdqD/wr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1IEKmTBB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE1B521A29;
	Mon, 28 Sep 2026 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790607849; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BI1ft0xTg8Lmqg32678wCH/A/3ZpYGvXnV599mnIals=;
	b=0v2gyYeaAVrn4rPWL8dWSSu34musUtwRqPA3ZIcGzEiMxLqZQp9C+ls3iU1zriLazBRZdH
	HFO/P39X+D45a4vOwYneaKYF7NbMYknPbwvsLSURAIOftMU3HnT90ATaTXGc7FpgHi+NW7
	1HAA6N/BrOfLI0cNTsRi8NdixpY2R54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790607849;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BI1ft0xTg8Lmqg32678wCH/A/3ZpYGvXnV599mnIals=;
	b=k2v4ZoH6ZWU64WIiK0pqkegBm1DY4vZv247pFzDwrfwNIAuur3csNLmGjEfysL6Sr1esqM
	ZWa4nsiC4TbkfQDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="VSdqD/wr";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1IEKmTBB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790607844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BI1ft0xTg8Lmqg32678wCH/A/3ZpYGvXnV599mnIals=;
	b=VSdqD/wrkurn31KhozdUHxWhlFHgfIQ4m0qE2rPrBctWClfP0t6zLu9HCq5uoh4I+F0Qi6
	RJs1V+A5Ql0iZ4AENrvhY7p3rJTqK9CZagEKnPSFRhnaloB3yE6G6ZGS1697wDjgdGX8Kc
	kzMcg07ziebPqt+4i7H/2Ug2Vs+TQ8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790607844;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BI1ft0xTg8Lmqg32678wCH/A/3ZpYGvXnV599mnIals=;
	b=1IEKmTBBIhuOkPc8Pd0puWEjG21VzGEs411NW3ijozeobrNrXSALSKyuMD8AIPdFdkT89y
	bqXzchcVKRGDmiAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E704133F1;
	Mon, 28 Sep 2026 15:04:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FoWTNOOBumpOIwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Mon, 28 Sep 2026 15:04:04 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH v2 0/2] reconnect fixes and improvements
Date: Mon, 28 Sep 2026 12:03:53 -0300
Message-ID: <20260928150355.850472-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DE1B521A29
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[manguebit.org,kernel.org,gmail.com,microsoft.com,talpey.com,suse.com,suse.de];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.de:dkim,suse.de:mid];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Hi all,

Sending v2 to address the issues found by sashiko
https://sashiko.dev/#/patchset/20260925202003.618856-1-ematsumiya%40suse.de

Please refer to the original cover letter for rationale and reproducer
https://lore.kernel.org/linux-cifs/20260925202003.618856-1-ematsumiya@suse.de/


Cheers,

Enzo Matsumiya (2):
  smb: client: fast fail sends if need to reconnect
  smb: client: prevent premature discard of requests if reconnecting

 fs/smb/client/cifsglob.h  |  4 ++
 fs/smb/client/connect.c   | 58 ++++++++++++++++++++-----
 fs/smb/client/misc.c      | 91 +++++++++++++++++++++++++++------------
 fs/smb/client/transport.c |  8 ++++
 4 files changed, 124 insertions(+), 37 deletions(-)

-- 
2.55.0

