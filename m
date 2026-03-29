Received: from mail-24425.protonmail.ch (mail-24425.protonmail.ch [109.224.244.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4616B76025
	for <linux-cifs@vger.kernel.org>; Sun, 29 Mar 2026 02:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774749834; cv=none; b=nLV/ugUgEBBtsAlt74ytWHBV6fnS20whP/sg2CKeqR2TnkUWc7xH4/vQxfQgZm4Wsjl5g5LzMPeLBVwH3R50bIUeCCa/2sTh2DzBzYHOJ5W5xdrNwuW4KS7rXQSykP+MKDDesX/gj1ML4cK2EuCbG91opbUDaXZ8PoAOQGq1PY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774749834; c=relaxed/simple;
	bh=MPpX+1V6sVnrbYjFzZoWq8S2QJs+13VLPXX8jUTZTI0=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=TN/rXZTymtfyeMqvknbbce+iMDm9scFAduisZnA+MmYEbiNDDfDYIFBxOeuXFq57GpOVAF8uGm3uvPvYGEQVVQJhlr6bzGSBiVTt1hci3/w45NbUlSy+J2mEqEuhJpFWwA9NWWH+yovvYCm0P3QngUZyI85SIYY+eZZZ015ohzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=ERsfArzz; arc=none smtp.client-ip=109.224.244.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="ERsfArzz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1774749821; x=1775009021;
	bh=jw7+sfd+qB0vbVbLoMklzSKEktx9W18DbP2b4yckE6w=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ERsfArzzV92+H7OtUJKXH+gRSGPlsbzrQR3grewV/1WUKEyLS786ALUKRgeCj0Txn
	 Bm//TJRydyyh5x5wxQuCm2LeYdGIELt+B3JpTxRVPfhsNB+XQ2cLE/TykTaYPUjA/x
	 jgpXTRSb+curNe1+wqvrICF/FFuPX9Ej7a0+BxFxElQZPbiRBT94CsHrfFucUBWS5A
	 doINANtiS0NFsFFfs16wLZeW62ewxZ8GZ7dC6m2x0S9XK2yFFg0zloV54SIYLf4Qw2
	 30JHO9oR11C1hVa3KZVIfev7jEUz65BpHQszrymWutLvlZjZ9z2ToKq4EWmnBcseRB
	 hAaSip7uu0Bww==
Date: Sun, 29 Mar 2026 02:03:38 +0000
To: "sfrench@samba.org" <sfrench@samba.org>
From: FredTheDude <FredTheDude@proton.me>
Cc: "pc@manguebit.org" <pc@manguebit.org>, "ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>, "sprasad@microsoft.com" <sprasad@microsoft.com>, "tom@talpey.com" <tom@talpey.com>, "bharathsm@microsoft.com" <bharathsm@microsoft.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/smb/client: add verbose error logging for UNC parsing
Message-ID: <2__2tXx9Hngg7rDwgOdZVY8FFBkjQGk_0TviV3dVWkoCa9CZznTtxHJsVvgg9U0lyXUo-_6KKPTPFZTIGTLo9YfQczBj2CxTZypXB2ydr7c=@proton.me>
Feedback-ID: 151443565:user:proton
X-Pm-Message-ID: e1b80ed98d432ae410aefef9a25b1ff45a792b96
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add cifs_dbg(VFS, ...) statements to smb3_parse_devname() to provide
explicit feedback when parsing fails. Currently, the function returns
-EINVAL silently, making it difficult to debug mount failures caused
by malformed paths or missing share names.

Signed-off-by: Fredric Cover <FredTheDude@proton.me>
---

If I made any stupid mistakes, please be patient with me.
C is not my best language, and this is my first patch, and I am just a high=
 school freshman. Thanks!
---
 fs/smb/client/fs_context.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a4a7c7eee..03c112f4d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -658,13 +658,17 @@ smb3_parse_devname(const char *devname, struct smb3_f=
s_context *ctx)

        /* make sure we have a valid UNC double delimiter prefix */
        len =3D strspn(devname, delims);
-       if (len !=3D 2)
+       if (len !=3D 2) {
+               cifs_dbg(VFS, "UNC: path must begin with // or \\\\\n");
                return -EINVAL;
+       }

        /* find delimiter between host and sharename */
        pos =3D strpbrk(devname + 2, delims);
-       if (!pos)
+       if (!pos) {
+               cifs_dbg(VFS, "UNC: missing delimiter between hostname and =
share name\n");
                return -EINVAL;
+       }

        /* record the server hostname */
        kfree(ctx->server_hostname);
@@ -677,8 +681,10 @@ smb3_parse_devname(const char *devname, struct smb3_fs=
_context *ctx)

        /* now go until next delimiter or end of string */
        len =3D strcspn(pos, delims);
-       if (!len)
+       if (!len) {
+               cifs_dbg(VFS, "UNC: missing share name\n");
                return -EINVAL;
+       }

        /* move "pos" up to delimiter or NULL */
        pos +=3D len;
--
2.43.0
