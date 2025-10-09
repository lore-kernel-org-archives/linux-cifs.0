Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62527381E;
	Thu,  9 Oct 2025 08:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759998086; cv=none; b=OhIZSnrnTKrhgI7wwZykHhwuS/UXu6BsSQqdVl4u7JxPZFemRHrn5EH8Aoedlr8icNtBoEh3jnpRB0xMmTqGqbR+kN7hk6cQnZTyBB3zgw1lurRYRrPKUeJfnGNFAjYDPXWeuHjITiuqIwG9xh9WceWYsqkn8vzMAGyIFi5b6SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759998086; c=relaxed/simple;
	bh=IA35/s9V7YanekrAiXoVt1OYxU9p6MWdbRmbGvQAYNw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FyFIBB2vQjK/92TyPVfRRR9661mX9aEXVXS5KSa6wXnCDMTfnDBDzoS+tcl3w/1rq5lbccEgc/YLh+NJmMcYzE4LcfC+wHN/N6p6GYQhSRf+Xz0aPNns0pHYICySgTtRu2THsKelYfSFMQjKj3dK6lKdIDQhSABuwYq8HmCdb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=VOrh67n6; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="VOrh67n6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759998074; x=1760602874; i=markus.elfring@web.de;
	bh=cHT2Uk+UhjLnmJdy9PgHbuY1buGHPgEqQHeM20ASBkU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VOrh67n6X7M7Tvl1zQy9IN4k1Rdj4h1meTrNOuF3SqZJeGWCj0RIY05p0Zfp24t9
	 tz8Z3lTtdvfdNBG7zaK4R30tf4oHld0aWr7/vrP3H1B2GReAAHMf1r8LkhsbjLDFR
	 hgPakMKQOKn49mbhxDiUgq8scjyUH/qJhnOOSxUZToHYpDo05KEcOfGVcHUVlL+wF
	 7qkBM24Q8xmon2Lzw3AuGxXOaObJtxTTvwzgIeoFDGld2HNUtYInVPbZ/0LV1gHBS
	 Y8z1uASOuQq0hqIg3mY45+KJsL/i190DztEvtnaAdTZon7rW0qo0TdSKIMjeuynE4
	 dB5f1FhprscLunTaVg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MIL4Y-1v1Dyg07nw-007i0W; Thu, 09
 Oct 2025 10:21:14 +0200
Message-ID: <42699172-eec2-427a-96f9-a687760dcaeb@web.de>
Date: Thu, 9 Oct 2025 10:21:04 +0200
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
Subject: [PATCH] smb: client: Use more common code in smb311_posix_mkdir()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1LVc4eVsjKfGp6ausHIbeBMK5GMPkFCoUvk0E/l7/ed9gKFsBuN
 pFNTGw3/+3oFfLa7CGp1gS02B5XFIpODJLcYPrvRN9lLFYWfkR/SS/cEu3Tr5EX76kIUtYV
 Ejmbqo7ZgP9XqPYgLP2vze305us0I53g0aD99RZmmIInZyiz5SgEtF7OOJ37svqXJvvAPk2
 j55ZyNrIMBkclYl8QC6sg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vNuX+RbS3NE=;T5itXRhOZDbegd8NSw7EAHovcUX
 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
 AnW8bKukk2Vi9oS0VTBGSQG914=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Oct 2025 10:08:04 +0200

Use an additional label so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 42e2d4ea344d..3a62a3a35580 100644
=2D-- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2975,8 +2975,7 @@ int smb311_posix_mkdir(const unsigned int xid, struc=
t inode *inode,
 	rsp =3D (struct smb2_create_rsp *)rsp_iov.iov_base;
 	if (rsp =3D=3D NULL) {
 		rc =3D -EIO;
-		kfree(pc_buf);
-		goto err_free_req;
+		goto err_free_pc_buf;
 	}
=20
 	trace_smb3_posix_mkdir_done(xid, rsp->PersistentFileId, tcon->tid, ses->=
Suid,
@@ -2988,6 +2987,7 @@ int smb311_posix_mkdir(const unsigned int xid, struc=
t inode *inode,
=20
 err_free_rsp_buf:
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+err_free_pc_buf:
 	kfree(pc_buf);
 err_free_req:
 	cifs_small_buf_release(req);
=2D-=20
2.51.0

