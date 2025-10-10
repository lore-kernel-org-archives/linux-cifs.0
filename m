Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119551F03D8;
	Fri, 10 Oct 2025 19:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760125629; cv=none; b=aeRuTZew/EXBbNseoxlBf0nITmNObeUtP1F26di2/YNGLH15TznVyvHpt+KZBPqAgJh9TKl5GK3EJRQpTl8uj74cV8GbVl7QrafqVncVIJQbP0IAHZHF+tvK2o/5119fWIP4U+VYSb7bn99Y2epJ/i8SloLqn7/n8iENzaSU4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760125629; c=relaxed/simple;
	bh=a7m0HEHOFJGnjw8uK9F5NjE8aD0nGLe0Yy7SY/rAftU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=jeovZl2Gw94XHqIQEZTFI1qqiunKVNcP9zzSiTqQ4YEOWDKuSLTl6R5x0HbXVgaJeFQVR2KCnaZ+mWM3kHvnyBN9UQHqveD5sv6xdkOYh6ssW8UHGVAFbljKOH1znMDTqdUhXd6QZrUgqP93319VZ9oIlh6VmeSRppXRWZ7FR6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=YZPhumVG; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="YZPhumVG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760125618; x=1760730418; i=markus.elfring@web.de;
	bh=zCCZYFNBnz2tFy30vL20NvBcKa+lVJCx6gQTdRcwE6M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=YZPhumVGiAMqDd0FEEGZKxq/qEHAuzVyoIDNp22ZJIzNvrIgNjqn4AhHLnkEgLFJ
	 8Lm0M/maqX5C+XOjRNZBiBxzaTyNSpdnqQAiJUoSVseW+gHBSKz2GAKvaO0t5TbQZ
	 r0737uVC8UD09cQJV6qBu/VnwHpLIAHkXRjWHJPJaDEfzxlVWxWxbB1K8fR/ptbao
	 VXsFszifE/OAJtcyINwaK1NBH0NKO1MRlaEEYfX7zKVYVrZyV2+NvcdKe0OcLp/6A
	 FYTnZgBZpSE+Vjra+FWxngh/Dw+4DKoL7vPqJxqRJjEOV7ooNJPQo19zwXEr08xG7
	 I413iS96pVcE7m4o9A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MhWkj-1ucw8P1BEB-00pbPD; Fri, 10
 Oct 2025 21:46:58 +0200
Message-ID: <4f2e37f8-09f7-4ba4-bd3a-bd5f62e98c52@web.de>
Date: Fri, 10 Oct 2025 21:46:56 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Jeff Layton <jlayton@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Pavel Shilovsky <pshilov@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Simplify a boolean value determination in
 sid_to_id()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BxraPJBGxG7c6xz4hT7cvxIyf5rnc40TwvLUnXDaj/uUkrfZxQ/
 O5v56KkJ2tNBWF3BxqVGPB4YCniBSIIOCDJswFLKRvg8d02ffzZxssLg5HqPTHomVDu8fYE
 6IT27GJdgZt0qTOB0b9zQWQYtIZ3EBDc/3u7u77gQGT0DMos+C3Y/cdm+8muJXUdRlddWLd
 SEv/DUv1ajoBOH+ih25KQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dZf9Hrwknns=;0YHOeevUguGV0rx3XgaqaPEuHFc
 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
 Q1J5/xex6L6fn1fXl6xfXhgE4A=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Oct 2025 21:37:59 +0200

Use the result of a condition check directly for the initialisation
of the local variable =E2=80=9Cis_group=E2=80=9D instead of assignment sta=
tements from
if/else branches.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifsacl.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 63b3b1290bed..2fd7841fdc8a 100644
=2D-- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -359,12 +359,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_si=
d *psid,
 	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) ||
 	    (cifs_sb_master_tcon(cifs_sb)->posix_extensions)) {
 		uint32_t unix_id;
-		bool is_group;
-
-		if (sidtype !=3D SIDOWNER)
-			is_group =3D true;
-		else
-			is_group =3D false;
+		bool is_group =3D sidtype !=3D SIDOWNER;
=20
 		if (is_well_known_sid(psid, &unix_id, is_group) =3D=3D false)
 			goto try_upcall_to_get_id;
=2D-=20
2.51.0

