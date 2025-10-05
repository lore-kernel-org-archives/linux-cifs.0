Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31B9374EA;
	Sun,  5 Oct 2025 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759684220; cv=none; b=Oh8oW9C5ARIlnU4hpDrfL00vBqDo7WTmMupzD37byZVWLyfVZ3QTgm0mPNjhH+MI1FpoVX+MkMzsKhwL7ZtE306cuLVmzfCNp46fIRbTgq+7fLM+mqfvqfc6EjMXRRXQgvrxbGSA2l7nR2xBffBG0e0mV3xFirf5WmhHcQdMRsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759684220; c=relaxed/simple;
	bh=78VLSqJHGDt3CuElr07tCuiXpQWE0Ikl1ZXwzBI5sJU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=VWl74OXb4K5VMzEhgzuMVo458aqJ1FPzIYZ8PDultWGajYo480ifbIZ55RXblOOMaodCx6U7P25XTWZwKw8C04z5+UCpzm2HS2Hul+a9rHHStF1VP41u7MGxSFV0nM8t405wVvuaQ+8nDavWAj9BPki4TmeEWr03B3RmsGSmG+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=pewXyRD4; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="pewXyRD4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759684215; x=1760289015; i=markus.elfring@web.de;
	bh=aVtwqe7EjJC6P1zSenGQlU2z5qSVomRSPHiziOB9PrM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=pewXyRD4huOQORn6dSX4LCdp8fbcMDCSmaBk4FztxINysOkiitETPsETZCJPp/ft
	 lwNlGt4Zqy2mNirGe3jmqfBCdl3DkfKEQx0ZllN9VfJ9zcT6KDfOyiX4neSCzjpMU
	 M3rnQqRj1BQSlCDeEwlLzYFw92rmRA6lQ8+k5535l6eEcv0OLH8p/9Mrjar2iPA5r
	 NRx5G9D2ozNelb1CEyCg+cg8QD7z1lE7eZr1LR3wPxJ9EZbq4VLYBnc01CngEDPBN
	 RA0tqARKpFd487UQ7uvO2aAgLWX2d3WKoyLBU+7167tm9KznaTGj0q0a/KDSCTf6c
	 ssLRVSiYK6eZZezuVQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.233]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Myf3v-1uMaQU36ab-013nAN; Sun, 05
 Oct 2025 19:10:15 +0200
Message-ID: <468cf96a-5dd9-4aa5-a8ce-930cf16952b3@web.de>
Date: Sun, 5 Oct 2025 19:10:13 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French
 <stfrench@microsoft.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Reduce the scopes for a few variables in two
 functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NL+/WpKQl/w6ngMo0t5w+1qAJuL8KD1lDFbQKV4Svj6deZm+CgQ
 eSgi02X2EkR5KimQBXPGZ0BTcN5psBwk0evds3FHyynV+AaD9pl/C3LQFCU2o5XR1YKTkif
 34Vximv8VdW2JMHz+BTI7FN3Dj6QmlKPxFPPn5aOjS0LLzYE04VyeWsUIoPYpKVh1UvOZo3
 7oIhZNE8Qp+HAU493Zanw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:q0GY215HKw8=;SmD3eBlLgnOR5XEffoDF+dmosJv
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 5 Oct 2025 19:01:48 +0200

* cifs_lookup():
  Move the definition for the local variable =E2=80=9Ccfid=E2=80=9D into a=
n else branch
  so that the corresponding setting will only be performed if a NULL inode
  was detected during lookup by this function.

* cifs_d_revalidate():
  Move the definition for the local variables =E2=80=9Cinode=E2=80=9D and =
=E2=80=9Crc=E2=80=9D into
  an if branch so that the corresponding setting will only be performed
  after a d_really_is_positive() call.

  Move the definition for the local variable =E2=80=9Ccfid=E2=80=9D into a=
n else branch
  so that the corresponding setting will only be performed if further data
  processing will be needed for an open_cached_dir_by_dentry() call.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/dir.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index fc67a6441c96..7472fddadd4f 100644
=2D-- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -678,7 +678,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct den=
try *direntry,
 	const char *full_path;
 	void *page;
 	int retry_count =3D 0;
-	struct cached_fid *cfid =3D NULL;
=20
 	xid =3D get_xid();
=20
@@ -717,6 +716,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct den=
try *direntry,
 	if (d_really_is_positive(direntry)) {
 		cifs_dbg(FYI, "non-NULL inode in lookup\n");
 	} else {
+		struct cached_fid *cfid =3D NULL;
+
 		cifs_dbg(FYI, "NULL inode in lookup\n");
=20
 		/*
@@ -785,15 +786,13 @@ static int
 cifs_d_revalidate(struct inode *dir, const struct qstr *name,
 		  struct dentry *direntry, unsigned int flags)
 {
-	struct inode *inode =3D NULL;
-	struct cached_fid *cfid;
-	int rc;
-
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
=20
 	if (d_really_is_positive(direntry)) {
-		inode =3D d_inode(direntry);
+		int rc;
+		struct inode *inode =3D d_inode(direntry);
+
 		if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(inode)))
 			CIFS_I(inode)->time =3D 0; /* force reval */
=20
@@ -836,6 +835,7 @@ cifs_d_revalidate(struct inode *dir, const struct qstr=
 *name,
 	} else {
 		struct cifs_sb_info *cifs_sb =3D CIFS_SB(dir->i_sb);
 		struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
+		struct cached_fid *cfid;
=20
 		if (!open_cached_dir_by_dentry(tcon, direntry->d_parent, &cfid)) {
 			/*
=2D-=20
2.51.0

