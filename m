Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38115B96C
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086496; cv=pass; b=Jcl1Vrg3v6IVLTtYRhsC8fBew/2N0um4jSLiB2Lp3/rP45mTd8Jb9ercZ+jVNACVUcbKv7B4Bx+bzQmgM4B+9pNSvY2FlFq+dkeb3jBO9M4IqBlJYDhkM6PKVxb4lXmyOLHZVmf9UaN8YIpF4el+z5ek/PzIUS29vJxTjTTAnpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086496; c=relaxed/simple;
	bh=NhgWS1jZsu0CFc0kJkeGyOm2zWtokA5d5yjWQj7qROY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4TN2tKhS/6FTivl2wjjnPDjsWPyJOoxrqwH2tTp/iRsiZXThQAplLqeSHUrAHSJMGSl5yqPlQ6PXEeHK4MnbNYq9KEAtOxfXJkrABdC8X/x8s94nwzleNwt4+H7DHMAgm4V4TO38D69cr7q5mUzoHy5Qx1pRx1/XANp95VzJ9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ik8hz4bH; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ik8hz4bH"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8sN8ymJQec6eq4M9tonpwPh+itjxLzglCu7JZ1QbByQ=;
	b=ik8hz4bHXKxDupwkRRiFugzVGxJLE7N05Hax7zzxBIvxMQ5W81ZcPERqPErVtJlxA1kTWq
	YIuxtnkf6nkWdCOHfGU9LKW2oFbNRjkj2leVRhqfVST74+RJQ9fzjDx0Nw1dT4ZOtWdvF/
	DhSiuUvbuQylPdMz4O8Zkm/zvpcJiClL7/U5DuLDP4QMaa/shn5DTtmtyp+KNSgUZ5hjIy
	PX0WftqBIwPcErGy4xN4VfJ7JpA4IvuVAtrmcAsEZ6juWVc6qCXbvUwHfVZt2wXL+TiKxG
	dzQ518pMMrQbdohiWpX6cGPAX4rpW1At1y4UqJYwqWdEU1PhPKq3pkCLvQzAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086493; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8sN8ymJQec6eq4M9tonpwPh+itjxLzglCu7JZ1QbByQ=;
	b=DOJ5Jarsk6rsZg3NusDJqg0acyJIIeVQ/qtlcF9fZglxxWIhmlOBLTJJW1tC2BFO31mozZ
	Tftvjg3YZqARlfOpT6fcY4246FpoAXrzTi38I8ly4VFp0AO4dUjyCNS5KKPU6JuH8j9dKz
	QoSXGQMMMr3Vvik1jCJVm0oMc9mswO6c5a2t3tucNe4RzviwNALo1MHPozUgOByUUxmD4c
	ghQCp0Jl+aOz1mV+XNTs//5lkZudhz+8VuqtjVFX6WKK9ovKYBz2kjHd6+JqxP3FjRAP0l
	orJn0V5mJSjxyBBNPn4MrkRLiDsJN+ta8aQxy3enAwyaM3vc66xGhiK/srxMvg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086493; a=rsa-sha256;
	cv=none;
	b=oWa0s+yoauLu8g72+/f+8x0zg50cCtVBbwFL3zJhf2NIUI5FKSaHIvTAHwN8EuUx5eg3Mw
	EZgxNWxJL9+LgP0XZfq95Nf4eXBSB0wKfDrazx+HtT/8lFk6TKON1m7znrbjutvOIiVZJ6
	X7Pl54aGPP4XKwbMoMGY4PMCa0Fnz0JlN6/j3a0akiaIA4+4K42HsKFWAupTNMaSeLMcBS
	EqrVkNZ8OvMbXbClmykWYGwQAwzZpZpNN4EXvTzz4urnACbjb/2QQxAemdNNGu+TchsN4e
	qy4xV5ESlXWIc4DTVT6fuv7VSVIIufdHj24eYyXoRavyed+lpuyY9niqimRrSw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 09/12] smb: client: fix potential UAF in smb2_get_sign_key()
Date: Tue,  2 Apr 2024 16:34:01 -0300
Message-ID: <20240402193404.236159-9-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 1d6e54f7879e..400175b9ef47 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -89,8 +89,10 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
-		if (ses->Suid == ses_id)
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status != SES_EXITING && ses->Suid == ses_id)
 			goto found;
+		spin_unlock(&ses->ses_lock);
 	}
 	trace_smb3_ses_not_found(ses_id);
 	cifs_server_dbg(FYI, "%s: Could not find session 0x%llx\n",
@@ -99,7 +101,6 @@ int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 	goto out;
 
 found:
-	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
 
 	is_binding = (cifs_chan_needs_reconnect(ses, server) &&
-- 
2.44.0

