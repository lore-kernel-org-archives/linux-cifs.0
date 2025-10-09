Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F142DE200;
	Thu,  9 Oct 2025 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760010788; cv=none; b=QnBN/P7HEfyFC7MKBxz4dE7Pyf0yiB8lqImcYzfDcTOlVQlWRC4biO3A3Idte31bvXXmPeMCDP88Z/qegGwDFa1TdZryiYBOE18mMptNgDUHeycqKuC6RHbbbgCciBPEqJQ/MGhpt1FhQGNoAqnQbH6HpH9PerBo1mJGboLy950=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760010788; c=relaxed/simple;
	bh=XFgLW2YVfQHXShe5GEZdscxPjQNOWT868tf0j+b7tqk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=NXcjJhpKL//QYOzlIY/HhLqdjc4hIrE1BG1ngHQ/I9HuM2sO0N6IJA41R4AqGUHwTSPBz0RYom9vqdZ1EyFFBOP1A7wKQn/nOrW41C3WhH/pCVULa7Ud6L792c/GNdW6GbHp8mkqz+Ign5vQZVvXEZBsLgNWo/7uWYeOsNHgbKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=eiTBfEFV; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="eiTBfEFV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760010777; x=1760615577; i=markus.elfring@web.de;
	bh=mhCaTMwqWD+P4sTJnopUiW10MI+QfjpGW33Uvx7Lays=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=eiTBfEFV6YoZ4CyZhytffCDJfQPKmFSYE63fCg0SLulJxBef2338CXxCgWzdvoU/
	 fa7QbNm88EhTpIv7NLhSbNVQ94cUgPMISHUUWFATAbTho/my5AEeFiQqF/PXLbrBd
	 qMAjh9ObsvydgtNo4QfXt/23mjVzjf7odHDCdb8JxKzwoRCMz9ixhliGZJ/IJHcZ3
	 VxpL6qgzDEZ5rqrxcEcQzuSKgTiu1UVWQ/5MA4JnDWVREDzqp7eVtSfgG3hzFgfxq
	 QQBxb91skQtOkAyvDNLdjEq6D4uUAGgtyBEEt/Ki2ycU7PjAieE3xB8REaU9Ma6/h
	 Rs1yozhivBy9dTKoWA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MTfol-1uhIfs1EoX-00KCZZ; Thu, 09
 Oct 2025 13:52:57 +0200
Message-ID: <746d1756-5e07-412c-a142-985028bd954f@web.de>
Date: Thu, 9 Oct 2025 13:52:55 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>,
 Paulo Alcantara <pc@manguebit.org>, Pavel Shilovsky <pshilov@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Improve exception handling in
 smb2_setup_async_request()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:f3r2RFkxea1kXO+9pav+iA7sR3ZCZzdCjkl3KBb2oWxdr/G+oaV
 0FZzhYMHDdNvwE+j037RTQGr4laJvc6haDyk4khSWlEtW4dX6H80QGZdEcIZc5HGMDDK//S
 6r7Qevdyp52+epLzLVHGdyegpdLuimfgnpmjpIZuzl8adOHE47tGpKxlhE8leuh7XaPopbp
 lk2jFbSrjDWsgT4sfHX+w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:zDuWPWUlHvY=;dcKeMRRbrzEZ2k9IQjJWXw/fSUA
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 13:40:46 +0200

Add a label so that a bit of exception handling can be better reused
from an if branch in this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index bc0e92eb2b64..02ebd1f4ae7a 100644
=2D-- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -921,14 +921,15 @@ smb2_setup_async_request(struct TCP_Server_Info *ser=
ver, struct smb_rqst *rqst)
=20
 	mid =3D smb2_mid_entry_alloc(shdr, server);
 	if (mid =3D=3D NULL) {
-		revert_current_mid_from_hdr(server, shdr);
-		return ERR_PTR(-ENOMEM);
+		rc =3D -ENOMEM;
+		goto revert_current_mid_from_hdr;
 	}
=20
 	rc =3D smb2_sign_rqst(rqst, server);
 	if (rc) {
-		revert_current_mid_from_hdr(server, shdr);
 		release_mid(mid);
+revert_current_mid_from_hdr:
+		revert_current_mid_from_hdr(server, shdr);
 		return ERR_PTR(rc);
 	}
=20
=2D-=20
2.51.0

