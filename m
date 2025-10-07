Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBB145C0B;
	Tue,  7 Oct 2025 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759860626; cv=none; b=ewHBPyOIye1ohmzxw2CKGYMdUbSjeIFFgV+dYmSulB71pG4chR9mzOamJzm50tezf7zqdh3+6eaV5FeefwIQBiwKwnmVMIZNc2/SCn1jDAUvfQyeMIKKuMb6VwbAgYFr7cDc2bkbeMeaBf/8LznNPfBAIMkrQkuGbJvL2pDGtuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759860626; c=relaxed/simple;
	bh=PU1UcClLwbar1Zk/rbgFgXIjPB2mQdwsCi6FEpoHdV8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cbsK/CJZoWP/NqChexFnalmGi/i2vcqr/mEIdFMivwY5I3LSShJzwuW1scB3lBPfu2IbvxQ1EJf0APx2qnlJDONHy6QBvmfMCj8X8L7PBHujkQy6Vh6imap7KSvH3WNWdhvFowouNaP9HBUGH8+kpEC6Bcr6aEUc/aHMMD49phY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=etPuZK4R; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="etPuZK4R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759860612; x=1760465412; i=markus.elfring@web.de;
	bh=SZob4jle2xeFF73UScJ33u2dZTmyY6LJz873tKKHCX4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=etPuZK4Rsm6+AEA7+ifqGuNi0cinBqQTvoQTsbv+O7zUoOcfa84tyczo+jmCYM41
	 Kt/1uAHhMEPTGPgPcyfAbPBsnb5IuQON9QsOwEHBDLmLQKCD1uOadkEKeoJc8W2tP
	 ItbntD9BxR59AHm9AoVv9waQvSSwvXimMgkO0gJyTk5Q+BD7P9jPGDGU07gcLQoiE
	 jE+7Bx6TLuk3VK1Q1F9+AZpW3ZZGZ+Rc6OaOgKPyPfaKI/OPfBLxciGcGzxp/TiNi
	 fJ97/+m+gRbiuFDofDyzIzDwJ6uV43FF4boK8U96WqcL+QXbjemyWD9wGIOX/itIf
	 2XiFUVHGUKBLWCcPaw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.202]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MJFhX-1ur0XI2kRP-00KNLq; Tue, 07
 Oct 2025 20:10:11 +0200
Message-ID: <94f70136-c57c-4c4c-9e5d-5044e7e01b67@web.de>
Date: Tue, 7 Oct 2025 20:10:10 +0200
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
Subject: [PATCH] smb: client: Use common code in cifs_acl_to_fattr()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:s1D/5YgA3K4NY7KAYljGwc71olT/uwj2exOW68vK95JtC5jbRV8
 IfJIRvTnu7788jvO8iexmVDcaArhGKgWMzwQbWajj0/HSSsNqTCPggoOWrHH36SzbyXiXyE
 Nyab+MpAJOXncrZk94FIgMQNqJli7469hySQR+NBBMsdFqIqsFBs0q820fkNtYYfE9P99dh
 4U++Gft4VnY8buuT14PXw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3kFh9P619KU=;VBxxE5BpJV872eo7AX+5sQqm1MH
 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
 TurKhzJP2YuPqAo7bCk1/24MAM=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Oct 2025 20:00:18 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifsacl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 63b3b1290bed..ca89f22a72c4 100644
=2D-- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1579,8 +1579,8 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, stru=
ct cifs_fattr *fattr,
 	else if (ops->get_acl)
 		pntsd =3D ops->get_acl(cifs_sb, inode, path, &acllen, info);
 	else {
-		cifs_put_tlink(tlink);
-		return -EOPNOTSUPP;
+		rc =3D -EOPNOTSUPP;
+		goto put_tlink;
 	}
 	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
 	if (IS_ERR(pntsd)) {
@@ -1596,7 +1596,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, stru=
ct cifs_fattr *fattr,
 		if (rc)
 			cifs_dbg(VFS, "parse sec desc failed rc =3D %d\n", rc);
 	}
-
+put_tlink:
 	cifs_put_tlink(tlink);
=20
 	return rc;
=2D-=20
2.51.0

