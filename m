Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4263DB629
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675051; cv=none; b=ovrsGPMh3UPmgx5j/ppMtJI0KQMmedJna3sHTJ0SQqG55nXz+YTczwpDMHvOPrGG6GTXXiONpV8RsanrQOPG171fF8X/hMNW2oPdQQd7UerTWsqjhX2TSfTQ79wg7p0mXViBgy7EKFCQBLyLNAdGjSpu32UM/N7qmlWN3iRKxgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675051; c=relaxed/simple;
	bh=xDzfwpOwn0pZ+bS0yCJuJhoQ2IX6y6qMo1q0zGJQ+1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITv8VvrlOgaiX7t9EvCF5glx+BPox658f3oduMDBPHT6qPME1ZZwLaplJdzWgN2ZwwlfVPVSq+Fsc6wr4ycZBc4Xbt1I99fALbMUFD1BmK0ee7ertFgGtRwEPNAXbQ4nhQZ0OlYoDPx4/wwZEn1N8frfFs7iNdaiZs35B4NJj9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D672763FB;
	Fri, 10 Jul 2026 09:17:02 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3368779BE;
	Fri, 10 Jul 2026 09:17:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4E7tJI24UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:01 +0000
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
Subject: [PATCH 07/18] smb:client: Fix printf format string
Date: Fri, 10 Jul 2026 11:16:26 +0200
Message-ID: <20260710091637.58873-8-scabrero@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710091637.58873-1-scabrero@suse.com>
References: <20260710091637.58873-1-scabrero@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 4D672763FB
X-Rspamd-Action: no action

It was printing a signed integer as unsigned.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index a33caaf4aaf0..877272788399 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -689,7 +689,7 @@ void cifs_swn_dump(struct seq_file *m)
 	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
 		seq_printf(
 			m,
-			"\nId: %u Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: '%pISc'%s",
+			"\nId: %d Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: '%pISc'%s",
 			id, kref_read(&swnreg->ref_count), swnreg->net_name,
 			swnreg->net_name_notify ? "(y)" : "(n)",
 			swnreg->share_name,
-- 
2.54.0

