Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAFB3242A4
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 01:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774920349; cv=none; b=ZedUfYT3tX1MrMJxI3h3oz5D6K8ZhHM/SMFP7jRrPRe5q2Jv7ZElt0GftvV/sbf43oxcj7y1AOaZw5p9MLMzUhynTlJske0oZFJPTt6aeX9pjPG4ACDe9QVGTbksgwBc/7BGhdWVxPvc8mW3MfMdus5Lx6CLdvMJxtfEs9zlttE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774920349; c=relaxed/simple;
	bh=jgEcLYP4Brg5vgVfJ3TKRi2QxgNPg8QApWRhtjw2bec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9f6YfvywfGi4RJncOljhWWs0QWBqIIJxh0RX9x9pUO+0O1EyMVJ5c65CdqKkDZIbFZWf+s/Va+b2S2/gUlD1+ba/MIWclkR8lrhdOhWaiePkaVjwZafyxkOepw0DbyGaC0PviGQVhL3t8FkYihPHiaql4/ByveUHynPKVeB1UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t/BWHn3P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zYZdv7xi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=t/BWHn3P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zYZdv7xi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t/BWHn3P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zYZdv7xi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="t/BWHn3P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zYZdv7xi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CCC74D538;
	Tue, 31 Mar 2026 01:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774920338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUGJDaIHBSudwJeNXs9l7MlISSCK517Lrj/5Qy5O+78=;
	b=t/BWHn3PyzSxQMwZ1+r16RU3k0xdsGF1/+NFZtEqtvaCYh8iKod/jVEX4a1w3oqfLXZ2+T
	nnsXgeOHQahOCC3V2WUKwqH1ptk2kzAVT/VBQ3Dm7Wj8VosjXlavfscnNz4Y1Lxy+RinOz
	WVijqbEN8RsBEnMSKIMRtILL42fk7v0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774920338;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUGJDaIHBSudwJeNXs9l7MlISSCK517Lrj/5Qy5O+78=;
	b=zYZdv7xirxGY7CxIg5z/Eye5My5QPN2HDJcSXl0W+ClyQ7PMclhaR/sqz0UeuP/Km8T4aU
	DyNjbMiBO5yEnfBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774920338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUGJDaIHBSudwJeNXs9l7MlISSCK517Lrj/5Qy5O+78=;
	b=t/BWHn3PyzSxQMwZ1+r16RU3k0xdsGF1/+NFZtEqtvaCYh8iKod/jVEX4a1w3oqfLXZ2+T
	nnsXgeOHQahOCC3V2WUKwqH1ptk2kzAVT/VBQ3Dm7Wj8VosjXlavfscnNz4Y1Lxy+RinOz
	WVijqbEN8RsBEnMSKIMRtILL42fk7v0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774920338;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aUGJDaIHBSudwJeNXs9l7MlISSCK517Lrj/5Qy5O+78=;
	b=zYZdv7xirxGY7CxIg5z/Eye5My5QPN2HDJcSXl0W+ClyQ7PMclhaR/sqz0UeuP/Km8T4aU
	DyNjbMiBO5yEnfBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4C114A0A2;
	Tue, 31 Mar 2026 01:25:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +PgqFpAiy2mpbgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 31 Mar 2026 01:25:36 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>,
	David Disseldorp <ddiss@suse.de>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 3/3] mount.cifs: remove runtime pass_length calculation
Date: Tue, 31 Mar 2026 11:37:53 +1100
Message-ID: <20260331012508.17410-4-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260331012508.17410-1-ddiss@suse.de>
References: <20260331012508.17410-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.de,microsoft.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

The parsed_mount_info.password and parsed_mount_info.password2 arrays
are both the same length, so drop version-specific length calculations
and use a build-time assertion to avoid future breakage.

Cc: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 mount.cifs.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 945196f..836a060 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -63,6 +63,7 @@
 #include "mount.h"
 #include "util.h"
 #include "resolve_host.h"
+#include "build_assert.h"
 
 #ifndef MS_MOVE 
 #define MS_MOVE 8192 
@@ -343,14 +344,12 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
 {
 	int is_pass2 = which_pass == OPT_PASS2 || which_pass == CRED_PASS2;
 
-	char *dst = is_pass2 ?
-				parsed_info->password2 : parsed_info->password;
-	unsigned int pass_length = is_pass2 ?
-					  sizeof(parsed_info->password2) : sizeof(parsed_info->password);
+	char *dst = is_pass2 ? parsed_info->password2 : parsed_info->password;
 	unsigned int i = 0, j = 0;
+	BUILD_ASSERT(sizeof(parsed_info->password) == sizeof(parsed_info->password2));
 
 	while (src[i]) {
-		if (j + 2 >= pass_length) {
+		if (j + 2 >= sizeof(parsed_info->password)) {
 			fprintf(stderr, "Converted password too long!\n");
 			return EX_USAGE;
 		}
@@ -362,7 +361,8 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
 	if (is_pass2)
 		parsed_info->got_password2 = 1;
 	else
-	parsed_info->got_password = 1;
+		parsed_info->got_password = 1;
+
 	return 0;
 }
 
@@ -681,10 +681,8 @@ get_password_from_file(int file_descript, char *filename,
 			   const int which_pass)
 {
 	int rc = 0;
-	int is_pass2 = which_pass == OPT_PASS2;
-	unsigned int pass_length = is_pass2 ?
-					  sizeof(parsed_info->password2) : sizeof(parsed_info->password);
-	char buf[pass_length];
+	char buf[sizeof(parsed_info->password)];
+	BUILD_ASSERT(sizeof(parsed_info->password) == sizeof(parsed_info->password2));
 
 	if (filename != NULL) {
 		rc = toggle_dac_capability(0, 1);
-- 
2.51.0

