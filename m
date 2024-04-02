Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660EB15B96C
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086498; cv=pass; b=dJjSHGrGWqE6V1L2dcL4nKZ74dcPAzJKPrfQVMSmQQBfNxXShpGX2wdu9sxTGwfQQK2kTmEFAHhF49Vdy88mwOVc2BB9An7zrAWMO3O7G0wblxB96NwMFNCXbkaLOoooA1Nm3a1xfwUelzBWgKy8H52M9pn+ACHz/mpoqdSNxmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086498; c=relaxed/simple;
	bh=AQ0hBbey6g2ZuMltlKwO6WXNpqbiL6yMc7BbdI2hT0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3K5HwuXM2JK8ePCEFbG21hcPi9t34/Y3X7ERmz03wARClnT9A4uWROlaYawqft4vjj3cIexlxGgidXvnhGXlgdxGugWf1EAyaVFJp6YJQ3v2H9rx1EZ99GU3MAm2H8BsqhGJw6QXcwl+AJqQArK2YTIUn6xlOQzMwE8TaUy1+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=iCy2+rfw; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="iCy2+rfw"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JnsGhXFpWTFCEOvj33KAiKhRnkc15SwS4zHKFOTrOsQ=;
	b=iCy2+rfwUPIG7gp6M4tuIcRD0ejGg9fgKyq1bT2QSrlMvrCDakQLq7CgcFVx2nkDGATQUr
	andIu7P5DM3R+vRnxIlEiv+lw+FRU7MEW54krQ9rdFakmjOa9pdMDRkdY/zfWcc3JY9bmR
	P1qlXRHfOSIHf9mIyq12ctPxkv3Htvu4nR9noPX3GP7ZSi/13iT4uSQgIUYn4QW9N0Szbc
	cXpvVCwgxFKmzNfqy1IXb9asjWFVB98xOLkp9sd1VIMvna0mSoxZXUpZA1F0Q/QfX9jP0p
	5No3EpRrVXUQPYE1D0OeMLt8oLq4E12tFyesEPbuobQ5tvYfEb9Qt85dvwUT5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086495; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JnsGhXFpWTFCEOvj33KAiKhRnkc15SwS4zHKFOTrOsQ=;
	b=kEX1C/ZLntcKmDQpEjPYjN7p76UL2f2zbP57U4kLsLdwLMtQExnWQyDUDFTKisgDP9hicH
	J5ak9EohuS+Cjs7serspbI8nSrPspyKClpcwMCK9Bguna0tpaPXZYbXg3WJuYhryyadWRd
	25ikLiWShms3baperDWrxDtFaqIvlYMjlKOFED7hboXhg+2AGKofRBakWf1EpCKnBaZyDU
	lRoFU6buLaWWJ30JydT1/PyDIMRxeTPz5oPCBNsZyQJHCKi1Sv0GHDLrnXoROb71tOpjzL
	VmjoaKFUlwflUa1CBRYqgrl06e45D0rT4Z4kR8+64YyrdvnCkfpmz/XJH6wU5g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086495; a=rsa-sha256;
	cv=none;
	b=GAd+5Ncs3tKPJRi72Ko59bSziIl9gJY/rp4YHt04iepUg2NU4SooqAsuz16dvNgk20Y3hw
	o5NdhMrk+HCShS+2hufNb3ASF7zQKeiaAT3SPehrZduhJkRjsio2oVUM5bP5NCFameag+L
	idfT1ve8nsrgaId4i1GzvYmqXugin7r4EYF5ejKHpdMaiL/W/pT/zUfvHAcYsecLmK35lr
	/mFyhM4uU8QM0/y1Hmsd9q1bXOa6jjE/r6EB8iTxv2C5ZfXV7u8d3jk/XCf9LkLQEy2q6v
	iQNVd2OjDYqwRGvLtOS58O1liH1rE4JHz0PKSxxitCJyYImQYX5d+ODMijpjxg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 10/12] smb: client: fix potential UAF in smb2_is_network_name_deleted()
Date: Tue,  2 Apr 2024 16:34:02 -0300
Message-ID: <20240402193404.236159-10-pc@manguebit.com>
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
 fs/smb/client/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 35bf7eb315cd..1506a0eb10ba 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2480,6 +2480,8 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				spin_lock(&tcon->tc_lock);
-- 
2.44.0

