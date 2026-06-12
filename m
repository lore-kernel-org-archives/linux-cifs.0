Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45BE218EB1;
	Fri, 12 Jun 2026 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781285961; cv=none; b=KhoJuZ1P6qzU5m580+Jo483cIuVmsrAX+R3L5/2+8OJGVQaYw7GM92UW9ePd4jjg09fCykHvELYuctRB1jjOQC0GbpTp2OiFagUzAcZlTOjlmxiJZmnOvlNpwKyAnskEQvjVApc0K/MSH37mhSX/56oPuszcZz8rZc38Pq2mvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781285961; c=relaxed/simple;
	bh=GcOQ1BfJCrdgO/Qxw1eoi9krlAY2ASEk2WTmZb3kce0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=KRhSDbWtEtm3TrelYlJTd1mVN1UG6DwUFnRuN0e1Wff00WNBKZ1g4PAGgvGsxdc6GqGHyLkheFDEQ54b6c6bacNyIW/u1z9ptcT56gAGsfC+fWcXkLjSfcn/vswkXheMvJpMi4ekm1k+2Ghb58PutNls63HbBO8LKpwT4wMq+To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Bfp9qZmT; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Bfp9qZmT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1781285943; x=1781890743; i=markus.elfring@web.de;
	bh=zHEy9j+ImtU6O38k+TlpUursi38ekE+uSX8COFEaDn4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Bfp9qZmTjrImdV1kBnx1nB6AYxiXekj2WODAWpJqMtN/Rj/ERCX2XeYmoJUeMSdt
	 qXOJX9jTlk7Gfm0/5olBG/1pmZOGJJf/wIRGsZzq72dKToGMm/LsB+LSFxUqMYec8
	 BM+l3B8nB/xw43+wtzG/0i7uN8OAQo2QG2OB48h1M0Pq5WG/w0IjvO1jfqvW9eJkM
	 ODQJK1rfNHATf+VrIa7MIgiCcUkosr/YD8/KPeYlthtipxjpCTrBuAPeIjp5zZWAH
	 eJJBy9jTXtqEkj+rz6OTA3IFD4C9IrrVzWYiyLtZ4cPK+tFKdPZJUOwwHm9GDEA15
	 05KFCCdCVe72mDfFIA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MTfkf-1wdq5C2ezN-00Wzdt; Fri, 12
 Jun 2026 19:39:03 +0200
Message-ID: <6e9c0200-9539-49e2-b667-eeb2b4906d45@web.de>
Date: Fri, 12 Jun 2026 19:39:01 +0200
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
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 David Howells <dhowells@redhat.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Simplify conditional compilation in
 __cifs_do_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kwUxKYWDZfnJVDE6Y/mtt6UUvy1AAK061xGl9srdQIOavb6kiyO
 F6lPqWflw91gfwXiuSuKXufBJcbGl21ZGakCFVedo7wMY4z3BI1A1O6Z47xFP+tYLdAqfL0
 W9DONSFAImDaN0wvT9veP0MZ0gop+GfyR3dX0m9647/IsNebZOxj/cgBboI1cL0w/JTTUQk
 LHBqxIXkGqjXq40CeJL/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wJ/l/f+oONQ=;CnTwiggq8IcGwQNzAaVXbnjdYd/
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 12 Jun 2026 19:24:14 +0200

Move an opening curly bracket behind the preprocessor directive =E2=80=9C#=
endif=E2=80=9D
so that an =E2=80=9C#else=E2=80=9D branch can be omitted.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/dir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..1e747e8c51e5 100644
=2D-- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -432,10 +432,9 @@ static int __cifs_do_create(struct inode *dir, struct=
 dentry *direntry,
 	if (tcon->unix_ext)
 		rc =3D cifs_get_inode_info_unix(&newinode, full_path, dir->i_sb,
 					      xid);
-	else {
-#else
-	{
+	else
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+	{
 		/* TODO: Add support for calling POSIX query info here, but passing in =
fid */
 		rc =3D cifs_get_inode_info(&newinode, full_path, buf, dir->i_sb, xid, f=
id);
 		if (newinode) {
=2D-=20
2.54.0

