Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB1C15A4BF
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086495; cv=pass; b=ALrtJFWshrt82AmWybL/JqB0xaOGjw7Q8+WwEBYnftUHhWmJpIhCkpgg7TZE+T/QySiW2xAor6X67dY56zZANjsZCC5Dv+AFBGxLLgc8zkftaPcW7e0EjNb6g0Gx0H0Sx3apoj5sCccRW+SMDtbVVPY5YppwqkqwHC75IJbFXGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086495; c=relaxed/simple;
	bh=kyzZ7HR2RJzLxuqa+nE58pDMF3ApahgTgPkQC2Ajg1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et1mW+VokJh8tq7hiMD3983yv+hPgpW8yFwG12O0SoXEdEVrUAk6IoU1KBanLu83lACG7Ef5PbuFc5bpgoK0tKtYRCBILbIxXo1vvkWVbXPGQwRdi2p7avLJ9EBbu56LqeSFkTUihKwKXBOKv4VSuLyp0o4q5cgdOfsI8u2r9xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=f767EbvI; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="f767EbvI"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZylG5CEM3g+liasZTieaviSHvloHrssy9SB/Amcs9Dg=;
	b=f767EbvI1ia4aNLcBFH5NhkldT966zlsQO613iQyKqq79HQINx9pEh5CDfY2CojTNXzPTl
	txJSGdnP4WRvLXw750Akpu6aICSNiroBlGhYAclbpc1aa8AOuvJ74WzzOAhCDk8StaailC
	4sPleeChcJoW7X6eGfWigTyDebDCW95ZhHeBjg/NgPez+oyb61+PX3T43ugUJnnkCDC5zA
	T0auzXn5A2JgrVkIkpgdFsghpzqG5TZSdD0Fk8/SNDFPdIL2mTrT36Vo0RW0SlhOWdG9dk
	oCKZa0GKAmgcZavdszrCb5ingRIhdoK8YrzPITljppurHtsxgOSLofy4ri71Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086492; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZylG5CEM3g+liasZTieaviSHvloHrssy9SB/Amcs9Dg=;
	b=ebCrcfdauF9H0GbEMgEUrRPKLdHTCgRLFPZAepXwYB04yMrke/RIRfkarI33p9L0zwPNuX
	mJrruRT2JWoV4pK2oLR8BPHcv68uvXLfCjdEufvHoh7KF+YgfpwQyVq9PivNz9oxLa8lAL
	vf3M3tjkgdzpP2BHxSCF1SvbF5PaDRCGXUThxJkI9xKRY3JpqM8jrN8Id1iULz3NhJp+qS
	rSFDOuPyuQpyDx2DfzIADf1Qs9zBxrHRcHb0lGDWXMlbL9FwABf5+7KCFhMIbaviXeaE/L
	+R/im936YNVAy5DlYIoOw3NFwbnSzm7tnjk4By0ANWurZbl7TOtNcQcglD8VTA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086492; a=rsa-sha256;
	cv=none;
	b=bZ6eLhEo9vRZV6/x8O+C53T0BZOZl1FVw2EeoUSdZtHUSqToEu/CHhfkIwQAji1J/Ti5T6
	NOYzhAZNDIvGNk0kOPa18BS8nz8Hgvs2kS55dtbmPoEspLorEvp+laFmctIXzrp7aE+OVD
	EtWsrPNqzSQVGSd6G0Bz15V1PkKttx8Z3A8P/eAZ8JC4bWYyh5MZp1Dh7BHk3vYnnM6/dw
	qMYt4CKEuXjhu+ZySgm+OMtn196NQQWnDak/IYwE4p7B29L5CUlH+tuYO0nmr2HuvydWeZ
	CTfEoEkPE/GI7rirwnN1A1vvj/MQhT/KKWHjvIoMwZheb0xoW0ZPToBaILcfpA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 08/12] smb: client: fix potential UAF in is_valid_oplock_break()
Date: Tue,  2 Apr 2024 16:34:00 -0300
Message-ID: <20240402193404.236159-8-pc@manguebit.com>
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
 fs/smb/client/misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 1ea22b3955a2..33ac4f8f5050 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -481,6 +481,8 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid != buf->Tid)
 				continue;
-- 
2.44.0

