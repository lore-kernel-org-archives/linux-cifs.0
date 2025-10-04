Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9A3A926;
	Sat,  4 Oct 2025 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759603983; cv=none; b=O7jgmW4uvTG8ZYk50noetXFyKS4VUmjMXbhaIcSOmN88ztqLL5joZ9uwqKrKlnGCqeM7WSq4LVejBTcU7xCOLmapz1zxOQgvOkK8YEknlt5HtSWfgld1L8s9MH/6nK21GjMGjOzWYRXRMMvjA0IqhzpwZnqU5YZFC//BCRNwnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759603983; c=relaxed/simple;
	bh=IGcgfEuVTzkyhNCAB6aB9f4dCXuIrMZWFnGQoBTb50Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ajKotHn7DY8LTKXkpO65q2uU93bivWYdDf0kzrOLnzaikk7XHdiDBkoaS4CyxgWx0YA01sGjSIEa38aNy7XmrFNX5fS+om213apXi25vg1ror8czydhF2zbwhlVgPvmM/YoQgOvPtljXL0LnLlqR4vlPnvZKes27TkXI+6O6OaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=nO7SnR10; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="nO7SnR10"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759603979; x=1760208779; i=markus.elfring@web.de;
	bh=v48wCRj+kYRH35ZHlMCTkGuYsaBQGBMZvWsbfDUXBQA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=nO7SnR10Anht3or17zm8pLCwsh/Ee1qQ8gE6wPoVaDrUB/AezKP5w4/nsAGpd4eV
	 HVSYTdaCZtgOt5M5s7ryilqP3k+4EFTa0/jvTcVrpsuHL8VDUzTP2Ph10UIIQcu+V
	 3T3ZyRKnRb9KARLjD2xgac//VFXrl+6aoi7S6qoEphvwXV/Y8hyzpGMyG23iBPVQ9
	 GOOTcEIl8wH7sgSkLR8OlWLMSlsprmCpE4p1TuEncwAQfu08LU3QZGuMhoVV53rrQ
	 coWj+8twWrw7GVF+ksR19JPa0BHm/yORLMhWY6nErYOzke+f9RBc8Kj2OLRLRtkyo
	 X3sfmSQwKG0J80MB0w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.173]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M1rPI-1v7JEO15zs-001vRw; Sat, 04
 Oct 2025 20:52:56 +0200
Message-ID: <d9952e5b-9b7d-417b-80e4-74bc6f769eb8@web.de>
Date: Sat, 4 Oct 2025 20:52:54 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Stefan Metzmacher <metze@samba.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] ksmbd: Use common code in ksmbd_vfs_set_init_posix_acl()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AsPRtN4CpIxFZ68yz+JNy/muT5AkIdHlSWT56B7lkQpIKN8V3fh
 1TGSoQNoKQ6s3t/55GUfFj4/ypJO2bm+qs1FZVCV/0nDsqdA0+Nkks0NlGY9eiNkk7o21US
 Kbe6gg3ZF2ZkW4dH+YqJZnslJom/y9eps5aNA88tFWPig0CwIOCed0xLG/yeBoitexSznW4
 m5oqwaHg4NW/toIMX8axg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:72xZ8xuwD9M=;5NpUVRHnodA3HtKcxS22wgxfzyY
 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
 7uXjg==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Oct 2025 20:45:22 +0200

Use an additional label so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2b73..e53aa294b9ef 100644
=2D-- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1897,8 +1897,8 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *i=
dmap,
=20
 	acls =3D posix_acl_alloc(6, KSMBD_DEFAULT_GFP);
 	if (!acls) {
-		free_acl_state(&acl_state);
-		return -ENOMEM;
+		rc =3D -ENOMEM;
+		goto free_acl_state;
 	}
 	posix_state_to_acl(&acl_state, acls->a_entries);
=20
@@ -1914,8 +1914,9 @@ int ksmbd_vfs_set_init_posix_acl(struct mnt_idmap *i=
dmap,
 				    rc);
 	}
=20
-	free_acl_state(&acl_state);
 	posix_acl_release(acls);
+free_acl_state:
+	free_acl_state(&acl_state);
 	return rc;
 }
=20
=2D-=20
2.51.0

