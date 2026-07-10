Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115073A1A58
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675039; cv=none; b=tYKu9aCC/EMiIODcytaye/d2m85QGgmnxC/wblavjsjvS4h3il5qmXMBk4osQA40t4DhLh4KJJBsxwaYyyGsn4bpa6x+5Dn2qAGy79EXItZezNUAxm0oALIggTB5c6po3nbzJdXNzc6Un7EcGDF6dxYW4mHEOMzGM8z1X4w5S0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675039; c=relaxed/simple;
	bh=uYsaWgdrNJVWhM7ehBy98k7rbs3GRo7iTtB5MVz8ez0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrM8b3AINf/BNlAbr4xpcuZFFjneVMAG9IT75W/9wZ7CusQN651WbmtmlcoSHOwESzscfBKV7Qces88L6zM1mTRicfehBA66z+/tDjP9RbiZRNF1shd7xQARQ2bfCZyY8FY58VuO50aezsKWDBHraCTTzyI2YdNhaK2Oi/bDtL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WCoNR+jS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WCoNR+jS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WCoNR+jS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WCoNR+jS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 31D87763F5;
	Fri, 10 Jul 2026 09:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98DMsuQMvXvR01UD0K/0J52niOolG3qdjjmn5sJP3aM=;
	b=WCoNR+jSNPXzNj3MaOkFYzRHOtPA+m+dCNtFI7rkQy+j+ZIS9HqA6aAsWFR3xDYATqSFBK
	z27nfkbuTZD5Sl45xx9yW0z5CF0N3sn/0Ri3fdwqUDu+NgcahJZ+46DgUvWBFxW7COlS2Z
	6+2IPHDSUvtWG4N/j/lfQsDW23jiWDw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=98DMsuQMvXvR01UD0K/0J52niOolG3qdjjmn5sJP3aM=;
	b=WCoNR+jSNPXzNj3MaOkFYzRHOtPA+m+dCNtFI7rkQy+j+ZIS9HqA6aAsWFR3xDYATqSFBK
	z27nfkbuTZD5Sl45xx9yW0z5CF0N3sn/0Ri3fdwqUDu+NgcahJZ+46DgUvWBFxW7COlS2Z
	6+2IPHDSUvtWG4N/j/lfQsDW23jiWDw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92D87779BD;
	Fri, 10 Jul 2026 09:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sBX7IIu4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:16:59 +0000
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
Subject: [PATCH 04/18] smb:client: Split idr remove and release functions
Date: Fri, 10 Jul 2026 11:16:23 +0200
Message-ID: <20260710091637.58873-5-scabrero@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_SEVEN(0.00)[10];
	R_RATELIMIT(0.00)[to_ip_from(RLsmepzun9ugcn3tumbc3b9wxd)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

Sending the unregister netlink message can sleep, send it after releasing
the mutex.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 0afb69b2eed2..fe032ae9c413 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -366,26 +366,24 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	return ERR_PTR(ret);
 }
 
-static void cifs_swn_reg_release(struct kref *ref)
+static void cifs_swn_reg_release(struct cifs_swn_reg *swnreg)
 {
-	struct cifs_swn_reg *swnreg = container_of(ref, struct cifs_swn_reg, ref_count);
 	int ret;
 
 	ret = cifs_swn_send_unregister_message(swnreg);
 	if (ret < 0)
 		cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n", __func__, ret);
 
-	idr_remove(&cifs_swnreg_idr, swnreg->id);
 	kfree(swnreg->net_name);
 	kfree(swnreg->share_name);
 	kfree(swnreg);
 }
 
-static void cifs_put_swn_reg(struct cifs_swn_reg *swnreg)
+static void cifs_swn_reg_idr_remove(struct kref *ref)
 {
-	mutex_lock(&cifs_swnreg_idr_mutex);
-	kref_put(&swnreg->ref_count, cifs_swn_reg_release);
-	mutex_unlock(&cifs_swnreg_idr_mutex);
+	struct cifs_swn_reg *swnreg = container_of(ref, struct cifs_swn_reg, ref_count);
+
+	idr_remove(&cifs_swnreg_idr, swnreg->id);
 }
 
 static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
@@ -612,11 +610,14 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 		mutex_unlock(&cifs_swnreg_idr_mutex);
 		return PTR_ERR(swnreg);
 	}
+	if (kref_put(&swnreg->ref_count, cifs_swn_reg_idr_remove)) {
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		cifs_swn_reg_release(swnreg);
+		return 0;
+	}
 
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
-	cifs_put_swn_reg(swnreg);
-
 	return 0;
 }
 
-- 
2.54.0

