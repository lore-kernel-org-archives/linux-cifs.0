Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF961AF0AF
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491176; cv=none; b=PH/nck33vLsO8xB3eDHFvqUaXYOfMc1BE2LuIHRemTdJXtkMJ3liMiZAC39ZWPoR2Bmhh59O2F/oaxRUTRqOyRtnUXlegmEx/NBC8pyB2JhMYPvuAGbflmOhDTffjPoMJfXuLH7YfZBgX4h74WCZ5adGS3o9LGcgBn2/MJFXGsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491176; c=relaxed/simple;
	bh=F8HIymgNfEhTa2f2BObW7xB3299isVlHodos7JR//9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2W7CJaX6qgcMsLx4QFPntIJuiNC3CQmuCS7rngjBzbBuKJmNq7+YN3463f8K2bUYDOM5R1aD1d8vaAetaznxUSTmKFxJLEXwQO7b3R+4F7d2mVSCnmGaPcTkP9WggvXy9hy7G8FS7McUHxebDvuo8fpzUC8fb2AuMbN2ewMZz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eUxAX2be; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eUxAX2be"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=IfEoqN+k/tgJdLVGN3c3Tn/VEWus/DrRES0UThRwqRE=; b=eUxAX2beBaIw8g+0fmA9o7FMjL
	k0TB0aqxRvILLZ53Jp/sq5dLtsS4tz5hW3A6BI3//U9qiAObx6IxmQbc+2iCY/WEUV00e0L4pfgar
	nYQXRZUMW9PMlVsJuAcIeWl33s4J3w3deyzczjxSVTPkCdZq9Q+xDf712NdC2Py0Zt0PSSgD9HG4D
	UyHjYftBdzZJm5JlnGb1YVWWkCKxo4Dg2BgUnAg1GpJWZHH7KHorB0P0DzrPsYfZhZn6rFObSknjo
	IqLXRlqR2/sPqOcSuj3Hd17CY5mhRrNtz0QDX6vFVCnQNvv52cxGmD+lV+GmN/raJ5yN9hh1HZ4xa
	az0pO97P9CmA3jjHl5FO+A943j+UEeYJGOR0DW56PCs8hbenNItF2wxDGc/9pjBoa9PBJ9AXt0cpI
	Wi9pSU7og8//YRMPR8d6eNg7OLQ50kzRVArB6iq9iLjsClVhwxvSqdf2OOcvCaj/owdfvlUODczNu
	Czlmu5cm8mWLWDzOYhHKOOwB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rso-005GRS-0E;
	Sun, 21 Sep 2025 21:46:10 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 06/18] smb: client: let smbd_disconnect_rdma_connection() disable all work but disconnect_work
Date: Sun, 21 Sep 2025 23:44:53 +0200
Message-ID: <00ade01b51673817ba5500444756d7882314c4ef.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no point run these if we already know the connection
is broken.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 73beb681ac0b..b39e60086c6a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -220,6 +220,16 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	/*
+	 * make sure other work (than disconnect_work) is
+	 * not queued again but here we don't block and avoid
+	 * disable[_delayed]_work_sync()
+	 */
+	disable_work(&sc->recv_io.posted.refill_work);
+	disable_work(&sc->mr_io.recovery_work);
+	disable_work(&sc->idle.immediate_work);
+	disable_delayed_work(&sc->idle.timer_work);
+
 	if (sc->first_error == 0)
 		sc->first_error = -ECONNABORTED;
 
-- 
2.43.0

