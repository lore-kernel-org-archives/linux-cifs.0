Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D314298CCF;
	Tue, 14 Oct 2025 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760421417; cv=none; b=JOhm5IiYwRBWZb+8baOKjPbZeatpDruZihI56+gi53HB+tGPhEP2d9uVoIiKINvxHb347k7YyrYYsEHkGSPkkW7ZT2Lx+D+5H7f7EHXUGGLcJkP/xvOUPKiJ9TukR2VApsjJcHshwpzZr7e6yKcPxVPkV2UW0xe946aBwea4+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760421417; c=relaxed/simple;
	bh=2ILMVxxg43j+NiN2Hfz6f5bN1dxCQqTdbR416iSV6F8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FipfIlySQDCLmApiFHYh+vO5jmYOT/mc6+jFrEx4Ba+D0w7vXKTGm+fvvH6JmcWfSwLbf3QeFd7kp/Hrgl1VKrytzzNiHsTS2GoWR+0ZRMoasvswaD3l5MjtWuBaNP/sXrtdulaCU1Fcj7+P5DDsZE0BW8RnuIIzdDO+cVzxzO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=VnKIIfnw; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="VnKIIfnw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760421412; x=1761026212; i=markus.elfring@web.de;
	bh=bAXWi5kY+lyrWUeha/ZMc+Q6T7lgiLCaa7Jx7Y1j58E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VnKIIfnwiHTildIdreRfF4e4bP8T+5LJma3hD2EoXMMjitTTIv2qCyLyQik6zrzM
	 iSQh2wEugZ5iXGaKr64Ks/TKRTAIAP7wzrCki5LIuXCxGlnXrmKDYJ4Ljr1DJD6ob
	 gReeiWCsOvdi4vaWYgo6Ul/SHgxc/SlEKaBZxnGaLQSOJVN+mKyVZWkXOwMuhRFfE
	 0I/mm0aJqKOF4YlvqzDKsy6O1vbdD85Zu3RHqJ3IrUQevFVgn+PZPpYorB7eKQGOx
	 VWlUo8ve1vQUaae4UJuYuBIZw02+PiTXg/qis7PyhkEfzChzdGNE/Z0k7KvG/3RpE
	 GIvQqBzncVj2mLD75g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.233]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N7xaR-1uDP1z05it-00s6qH; Tue, 14
 Oct 2025 07:56:52 +0200
Message-ID: <9cb35523-a312-41e1-ae73-048d183a7254@web.de>
Date: Tue, 14 Oct 2025 07:56:37 +0200
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
Subject: [PATCH] smb: client: Simplify conditional compilation in
 cifs_do_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0XFv1IyHuUR1LawtG1llhz1I+jgyKyk43FMJBpeG0FWzh6H/Djm
 h0BPHDohseJGRmL201IEiqkBpXwt8VYiyAYoGENZq11ovtuN+mza/IwMVQzr8CXF/JEUfa7
 tmXv4H2nj2wEx9mkBZKkfwPAfa1s457w+7jD9YUzN99OIt7BccMYd6mdo+5TUJoPr7rChib
 IBEGOiY07BWgUJF+rGqKQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kExJyNPgIMA=;b4NYDK5SReqw/jvnCyzp7D0J7gS
 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
 pldF++4jPIuejNrz0SOlXwN+bI=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 14 Oct 2025 07:48:28 +0200

Move an opening curly bracket behind the preprocessor directive =E2=80=9C#=
endif=E2=80=9D
so that an =E2=80=9C#else=E2=80=9D branch can be omitted.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/dir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 694c362740a9..cbead2cc44a0 100644
=2D-- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -402,10 +402,9 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
 	if (tcon->unix_ext)
 		rc =3D cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
 					      xid);
-	else {
-#else
-	{
+	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+	{
 		/* TODO: Add support for calling POSIX query info here, but passing in =
fid */
 		rc =3D cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb, xid,=
 fid);
 		if (newinode) {
=2D-=20
2.51.0

