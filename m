Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427B93595D;
	Thu,  9 Oct 2025 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760022740; cv=none; b=JSXyPfmcjINUa7c4/8ReR6+rPInnunRvue855DwnyfHib9dIknjY5YjBxWtmHjCvfBQqPkbHHvTdOHUlRamqlWc0ETBRKChhgslseDfl6F9fNvc/+cV0C8Qa27qkt/O59iMKS6D+qF1KbKfXbYgBjZZsThDSt0XhnP3nMKc6WCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760022740; c=relaxed/simple;
	bh=Up06PVdFR0VkmhgjCawzflGEWVdlLNjhQCbISASpf0c=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=YGKn1fi/IACmYUmiEef4nN4GLvIr61QGIEt56CEkYObOmHHGnbFdz+2TFMQ/Ov6aoPkYrM4WCnDSlSXSmlkRv++WTfXZxcXK5FaOpl8l+HWWJoGft41Pos68MMObHPjuWWM3ENQkXpSNPVs16I+/29vqiMo1jyFrgFSlngq/MDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kq/wb+MW; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kq/wb+MW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760022736; x=1760627536; i=markus.elfring@web.de;
	bh=9md8nsbwqWiqTzM0WmTyICgs+08cI6HLlknuBfaQFU0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kq/wb+MWn7YzudMn0TX9mNjNI60IpI6Xc+s5upt9k5Y1iuSmdppAxtAnXip77+ma
	 5RVekuh7ed+RWeqR5A5Jm2liAX0ZOr6B9YpOlQhaiDI7DIoPYVFQuWVFrZhhFaKPd
	 jOvjOJhDxNedFgoM63tPIh3DITcTH2AcPBvQNR47dXLp41tz9HNv54OHQLI00Er+3
	 50NGLu64FRYqEFpVuX8Jr+ole1B66EQ/JwDYGkR8M3bdupxaxVvgEl8E4/o3z5u7y
	 rbGDzuEK2g2wfdBrkyK230Sj38oi/NO94zZqH3pjfSZy5E05LdQ6faQFzwthwYeBh
	 LOmIQY5XIxeALLQAtA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N14pE-1u8lcg0ShG-00uug4; Thu, 09
 Oct 2025 17:12:16 +0200
Message-ID: <7a5c4b6d-f15e-4071-8a82-dca6b71b6b4b@web.de>
Date: Thu, 9 Oct 2025 17:12:14 +0200
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
 Sachin Prabhu <sprabhu@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Omit an if branch in smb2_find_smb_tcon()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9m32y8nvXnXWRxBcSLTbJYpxjT7ayX+ZS8vGeFWO+AyEhYrG9BP
 5s8FyCkDL4QZiu+s0ot/RvAycgmSj+2ghXhPeZ6kBzM4zUe5MU7ZdfCLjndDYgJBDaQfFkI
 HWNQfjiOV5mhT0RktjWK5bTeOZTdh+jZY6gK+EslmW4t8QhMRahnTL66pArL3oFgYM5/M5R
 H0mp3xAkxq0mN67d46g5w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:0AqO+av7KoE=;80gaQw/f6R2GZW4LohDh6JQl0Ur
 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
 92B+73ALCdQsYvKDKkW9SOvvb8=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 17:00:13 +0200

Statements from an if branch and the end of this function implementation
were equivalent.
Thus delete duplicate source code.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2transport.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index bc0e92eb2b64..33f33013b392 100644
=2D-- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -240,11 +240,6 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __=
u64 ses_id, __u32  tid)
 		return NULL;
 	}
 	tcon =3D smb2_find_smb_sess_tcon_unlocked(ses, tid);
-	if (!tcon) {
-		spin_unlock(&cifs_tcp_ses_lock);
-		cifs_put_smb_ses(ses);
-		return NULL;
-	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	/* tcon already has a ref to ses, so we don't need ses anymore */
 	cifs_put_smb_ses(ses);
=2D-=20
2.51.0

