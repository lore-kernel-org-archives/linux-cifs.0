Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02083A932;
	Sun,  5 Oct 2025 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759680341; cv=none; b=ozNpR56vBiwdyL0AIJyZeMmOx5EPH48GyPMIXZW7Wil7hfH+6gxIEjCB4RcyvXTTJQ0ozuQL1oq/mXKoXkEBVu8AH0HURAOr7LCRGukbFJffJRMqZn39b53i0w4MW4k/vSkZgi2t5paHKzL6fnQtEZNXwDMyZjyoZmj68/Mo4i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759680341; c=relaxed/simple;
	bh=YcznL6tXwybx+vFfQozUR6A4ZbTyLJIRnKI05eRDF0s=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=puqS9912uhkz76wd+Rmzb024zuHWwmueOMksMsviLO/F38PnrNbbBGQ50lxOY59EhKCswYvmQ9rnqr9DU1dBV2DqbQWyLUzwu3kW9OSbSsxKYSRty7KZ3ct+QsPMd02DbpUL8ggVuhF7yxGZywutjXE0Frs6LlipERsumJ8Rpik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=wCe4tozZ; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="wCe4tozZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759680330; x=1760285130; i=markus.elfring@web.de;
	bh=OS9ym8vgVaKLP6KbzTtgd+BWbOXGzS2Yn98lRVYxjoE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=wCe4tozZmK08Pv42uSagYd2q9gvx5ag3WYzRqlMM/yXxnOOoNraPeXYqUcrpkLgb
	 CV/iHJNfpc14gtuyHgJaDcKiWRpDQDkQ+CJAniNZOohEhjFCUXt9/3J2EnKnPg4fg
	 EEH6flyqF35h+2fzNpHTpaW0eTjiRjnpB8KpbpQWgNTO0YIib+jvSd/qyeHBRLMbz
	 d8pVGtPrjaXSI+z1Ng5PgzCts0Y2OUG9Rp2IXNVqqU3ZISKsNGNcZfTxfigPjbQhY
	 kt6PKIF9nTVelm8dIGYvShuGWwWXL7EwAp2AYpJLtzmqC1NFFDDSOFKPJVcpaCIug
	 InC2hgdbSlLzHakTDw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.233]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MY5bT-1un6U30Kk9-00KOmG; Sun, 05
 Oct 2025 18:05:30 +0200
Message-ID: <7811a101-2d81-4f4b-8e33-db3154c6137a@web.de>
Date: Sun, 5 Oct 2025 18:05:26 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>,
 Henrique Carvalho <henrique.carvalho@suse.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Use common code in cifs_lookup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3Qas8uFsQGHQw30nTw22fp+9hQFviekb0mtlafljoGFcrH28R+E
 KmKPw66NYkEJHuHtONgX+jbvRZQjgxn73UKAyu0FjVMM2EtLgPdT2DSuLNE7o+MuC2Mkatj
 SVbG0/U5pdlS3rg/9L3L+8hNNcSAx86NmczIgjqMxAA1qV1LbdouwuAJVccpKhm7iJNPDab
 ITdJ6OiXfCCPIk6BArRqw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rnD//6WleFs=;PS08nGKGSwkZ3b6BSpK4L7dztVJ
 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
 RI0eHZmIX3FMRI2Xw=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 5 Oct 2025 17:44:20 +0200

Use three additional labels so that another bit of common code can be
better reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/dir.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index fc67a6441c96..694c362740a9 100644
=2D-- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -679,6 +679,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct den=
try *direntry,
 	void *page;
 	int retry_count =3D 0;
 	struct cached_fid *cfid =3D NULL;
+	struct dentry *de;
=20
 	xid =3D get_xid();
=20
@@ -690,16 +691,15 @@ cifs_lookup(struct inode *parent_dir_inode, struct d=
entry *direntry,
 	cifs_sb =3D CIFS_SB(parent_dir_inode->i_sb);
 	tlink =3D cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink)) {
-		free_xid(xid);
-		return ERR_CAST(tlink);
+		de =3D ERR_CAST(tlink);
+		goto free_xid;
 	}
 	pTcon =3D tlink_tcon(tlink);
=20
 	rc =3D check_name(direntry, pTcon);
 	if (unlikely(rc)) {
-		cifs_put_tlink(tlink);
-		free_xid(xid);
-		return ERR_PTR(rc);
+		de =3D ERR_PTR(rc);
+		goto put_tlink;
 	}
=20
 	/* can not grab the rename sem here since it would
@@ -708,10 +708,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct de=
ntry *direntry,
 	page =3D alloc_dentry_path();
 	full_path =3D build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
-		cifs_put_tlink(tlink);
-		free_xid(xid);
-		free_dentry_path(page);
-		return ERR_CAST(full_path);
+		de =3D ERR_CAST(full_path);
+		goto free_dentry_path;
 	}
=20
 	if (d_really_is_positive(direntry)) {
@@ -775,10 +773,14 @@ cifs_lookup(struct inode *parent_dir_inode, struct d=
entry *direntry,
 	}
=20
 out:
+	de =3D d_splice_alias(newInode, direntry);
+free_dentry_path:
 	free_dentry_path(page);
+put_tlink:
 	cifs_put_tlink(tlink);
+free_xid:
 	free_xid(xid);
-	return d_splice_alias(newInode, direntry);
+	return de;
 }
=20
 static int
=2D-=20
2.51.0

