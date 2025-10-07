Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33C71A267;
	Tue,  7 Oct 2025 19:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759866344; cv=none; b=AZlA3pj30kvfVtlih/l5ozdgfhYUOCuuCTwiPclaE1tI2mR9BFTDQeOMy29cKoqHlteVnf2cmlwtNnJ282t+h+yeqxBlp0CCmQu1/10bkxVQZrN8nZ5Lu4BL80pbUvlba/c7XnlVmeK/0ddH3Mf+9RHAmE44UYS1jyFvm+BH9G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759866344; c=relaxed/simple;
	bh=kq/+ai7eaI+xs+SQ3Kpvylx9911pdxsqYTHch4jeCzw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=g/8HY67PxHl8NPOCEK/wBVFl7PCUhbmUL3zrpupJQejVqJ4hTHYmptqSJu/yYwPChzpTw0TnbrfRgZCu+my5DYswfC9KshouZIqCGZ6Vy6iJmS3nOKOuu1NT6LflVKcDUtFL9X/eIQX9/FYgdnKe7sqmijbm2iARPm4TAaOMMc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=N2gXkEaU; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="N2gXkEaU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759866335; x=1760471135; i=markus.elfring@web.de;
	bh=nHxGcVyoMz80gSBeu065Qiu4WFZZoPGdHL0N5KXsfk8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=N2gXkEaUhryE+YiHJBDnxi0dZqCXeyUewDlj6iGW5Ph+SYRpLLfnAH9ZuTmqgjHl
	 0d/4iPiNbdxdsUkGnWekfqqhzPOBo4KfOKxSGtzaNd9jL7LJqOPlK51apH+cbbpVz
	 p/o17vvST2rAzjlrOGSc3PbTDsJjtPzfyLuzpTVug3YY8GwKdxJhU44hWlP4gfOiR
	 4ti3QDr/qQa4LlL2MMWBEkXyXoo6LsRCuyW4dlsjV1mznHcQ85FvY0qFVQQ3lEsal
	 xBXJ3Ehfb+KXLtRq88UMMtSeKMuZN9+ZDfZbnI/xPcDWcxa80G3O/DgN6mb3uS0kZ
	 Mo9OrrVgQ40xu1cPbw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mx0N5-1uMNGO0WDr-00y5uI; Tue, 07
 Oct 2025 21:45:35 +0200
Message-ID: <6396d7d3-ef88-4b81-8d8e-f7f81a80ca0f@web.de>
Date: Tue, 7 Oct 2025 21:45:33 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Use common code in smb2_push_mandatory_locks()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O+PfjrkT0ZySx22WnxF5wIK3HQiRQZ5zbkCL1wbjyW764zaqJkM
 YPb3546q/faBo6x/3qe7DbbuPc2DRHGfR9AWF3L6/uRxBgYxl2Zenyn0a2dONTJwyVlbnfR
 G36Iy9fBtTu8O6+ENqnQegpSmUfQLfg1irdmNxK1GiNE4bl2elgC3DZJtrCDC8QCcYqdEQm
 c8xkF+O9lRNaX2FoyUzKw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mWzMGXDE9Xg=;2jSzE7ZhCPY74/0pVGPEXhiLdtI
 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
 YZsBwtx7/jysvJRgw=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 21:37:18 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2file.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index a7f629238830..42ac00f7e728 100644
=2D-- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -413,8 +413,8 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	 */
 	max_buf =3D tlink_tcon(cfile->tlink)->ses->server->maxBuf;
 	if (max_buf < sizeof(struct smb2_lock_element)) {
-		free_xid(xid);
-		return -EINVAL;
+		rc =3D -EINVAL;
+		goto free_xid;
 	}
=20
 	BUILD_BUG_ON(sizeof(struct smb2_lock_element) > PAGE_SIZE);
@@ -422,8 +422,8 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	max_num =3D max_buf / sizeof(struct smb2_lock_element);
 	buf =3D kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
-		free_xid(xid);
-		return -ENOMEM;
+		rc =3D -ENOMEM;
+		goto free_xid;
 	}
=20
 	list_for_each_entry(fdlocks, &cinode->llist, llist) {
@@ -433,6 +433,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	}
=20
 	kfree(buf);
+free_xid:
 	free_xid(xid);
 	return rc;
 }
=2D-=20
2.51.0

