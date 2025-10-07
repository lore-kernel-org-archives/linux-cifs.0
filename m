Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF40CCA4B;
	Tue,  7 Oct 2025 17:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759858550; cv=none; b=mvOcyF5PWosKDwShbpzqMHEeJ92JHJo5SfoeYSby6dSZ8qSxgWd0GY1k77cV85fHf2VkEIA/SJvM12Ipv4Doq+wsF+SdEesyempVPwj9MPivMgln+85fCDYVi2l9cYAQRXs49KJZWlCmzisA4nMLnPG0RUEH6CEBQfzCFuWzLXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759858550; c=relaxed/simple;
	bh=pYYfCOCjloA5ryxqVCb6Y/OUl61RfWTHylT1GwtlTXc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=eCHABMVHk5Qz9kIS6myjsp9iy2k98LbFjq1SSJlnOQo+ZFAWJFMTmDasCntqtEYCy1MptUn2qfrSJRzon4qSLYs5/Dq4Cj0X/2XCC5tqAhiBJ4CMbg4pQRhLFxi8HpR+syzhjoURppDoUEBq+bUhWD0F2H1KHP55OIFqF2z4vHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=n86i1fzo; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="n86i1fzo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759858539; x=1760463339; i=markus.elfring@web.de;
	bh=KLA5t3CNpNdJy94EAukm5HxxE32FxTDcwVAoRUgB5Ho=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=n86i1fzocttJgI5C2x4v0+ShepUPp7sY+WCpxWFqxOsT0GlnTIQeJ9Bm7rwfvKf1
	 1GeuCPMdXDStbubxYwAKlVdikIMPEFGLD3WrCN3A+qwLF4W6T+wcDOh8xzlWKhEIc
	 ok8QcVgnC9M3pXWQh9MKG75XNEekSKv4BNDrCuUY5EbS2L54kF92cocZxvkN+AXHT
	 hBXtDLd6ySYCmhqp6oIh1Jy1PjpmRU1Q3PwJMBxxv1VjLzoFCLcuirQU2l7v7k5VO
	 IxeNLlLdkDGAk2sRw/ZhSi4DIhhLUniyaZpxxogeH0Iny7lw5rsDx9dAtuQj8S7I3
	 UFkX2r86I4GDQAIqWQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MkVsg-1uPzoS41iY-00mOO9; Tue, 07
 Oct 2025 19:35:39 +0200
Message-ID: <1ef9c72a-fe8a-4d7c-a1ad-58c2748d0076@web.de>
Date: Tue, 7 Oct 2025 19:35:37 +0200
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
Subject: [PATCH] smb: client: Use common code in id_mode_to_cifs_acl()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:07nyEPTyk43y2qMQlDzU+xcnKAfdgo2veGDx4WP6LpZKe2ukDip
 JxXasdAUM8+Ti1F7Yo00RSzDe/TPWkd6F6tRgS7ae7xRPDrPHCPLZbgwjqlmlM41QpD6sIV
 EFMDY+BHHRVIEWeBkDN/9MVCwcC5p6GKNQrCFBwccpBkAUHp7037vXs7hOeMbdvwc1Nz2nJ
 wDyExVBThx/qSMqA+IQVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LBO6VwZtwEk=;e6R6CSPrpWBklw18w0GPOd5z0sQ
 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
 2Oi0uyIVB0sFiFbVtaEzjfeEho=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 19:24:09 +0200

Use two additional labels so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifsacl.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 63b3b1290bed..195eb578d219 100644
=2D-- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1634,16 +1634,15 @@ id_mode_to_cifs_acl(struct inode *inode, const cha=
r *path, __u64 *pnmode,
 	/* Get the security descriptor */
=20
 	if (ops->get_acl =3D=3D NULL) {
-		cifs_put_tlink(tlink);
-		return -EOPNOTSUPP;
+		rc =3D -EOPNOTSUPP;
+		goto put_tlink;
 	}
=20
 	pntsd =3D ops->get_acl(cifs_sb, inode, path, &secdesclen, info);
 	if (IS_ERR(pntsd)) {
 		rc =3D PTR_ERR(pntsd);
 		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
-		cifs_put_tlink(tlink);
-		return rc;
+		goto put_tlink;
 	}
=20
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)
@@ -1687,9 +1686,8 @@ id_mode_to_cifs_acl(struct inode *inode, const char =
*path, __u64 *pnmode,
 	nsecdesclen =3D max_t(u32, nsecdesclen, DEFAULT_SEC_DESC_LEN);
 	pnntsd =3D kmalloc(nsecdesclen, GFP_KERNEL);
 	if (!pnntsd) {
-		kfree(pntsd);
-		cifs_put_tlink(tlink);
-		return -ENOMEM;
+		rc =3D -ENOMEM;
+		goto free_pntsd;
 	}
=20
 	rc =3D build_sec_desc(pntsd, pnntsd, secdesclen, &nsecdesclen, pnmode, u=
id, gid,
@@ -1705,10 +1703,12 @@ id_mode_to_cifs_acl(struct inode *inode, const cha=
r *path, __u64 *pnmode,
 		rc =3D ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
 		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
 	}
-	cifs_put_tlink(tlink);
=20
 	kfree(pnntsd);
+free_pntsd:
 	kfree(pntsd);
+put_tlink:
+	cifs_put_tlink(tlink);
 	return rc;
 }
=20
=2D-=20
2.51.0

