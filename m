Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B135962;
	Sun,  5 Oct 2025 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759689947; cv=none; b=rIa2VlNHsU9Du3UdyPTj51kneDBA6aKeNciuFdV9lBE7pumU17DMF3mFq/vgpoD4kJ1nuptO2NnmZ2njSrI3K/69MRBau5H1J6l7evUS+iBirWkNlDyArTkucJq1I3VhtVBmEynH+jRdUdO0OKbinx2Z87WRXZzLFBaZv6mv/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759689947; c=relaxed/simple;
	bh=tyUV7eL3UA2aE5gXchrtrxZilc1JXmXcK3D7dnKbFbE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=q/P/aFiDbMW42llOLKNlGO+uEBS7kNUf43/UNKHVGONaklGC3yb1oCGGeXYrv4gczTuH/Xchp1o/w+pQDyVJEyas7VyF/BNZUyMkaXY0M6lufs3AmGs6undSxo4iHwf2izSsDd5u5LzU54ga+qcZlQZAtuzF7p9CViRIgpPINnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ZvAFWDDJ; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ZvAFWDDJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759689923; x=1760294723; i=markus.elfring@web.de;
	bh=4MU6UTSRzswNDy+Tvyb+jXhguOel7ObaYmVxD8CubbU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ZvAFWDDJUsb0z6/LMnwJ9ZCWMq6R2oJ9ENtD44oJyZpmWBPPfqv//L01AvVp3v+4
	 h/Ki7hD+c0eBwrQGS1LkZzAlmks58hsJDdOQwJ/R+n4ajTmXMS1KdZDahMZ1OM5W2
	 9+7u9NnO+oRg4zUbvig2vaC9kKjYYOOi6waeQFbn43D+jVKSBSBRsVfiKCwvCBcQu
	 +lkwIV5ne4aeBng4eRBlACZSPqOmWrcqz3zmQlrLR829SsBAroOBT13BXHYPaUhsp
	 39ykjfnDbksI/OVL4aKcwZVUHOz6m87Qg+xS1JaxJ0W1Ug8pcdLEooSpB4tVkC2hK
	 kBnsYdNhP764Jl572w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.233]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MQ8ao-1usKZO3aaW-00SK9A; Sun, 05
 Oct 2025 20:45:22 +0200
Message-ID: <59292fe5-1730-475d-bb5d-1e70f3d3fa1b@web.de>
Date: Sun, 5 Oct 2025 20:45:21 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Al Viro <viro@zeniv.linux.org.uk>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Use common code in cifs_do_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+HpnVjfYEnNkH78FCb7pVJd/PcsDn4coe5cIVKwCYMGURkwkXkh
 aa27jgIM1yLjHCPwWeKL1QxRGZTFbUxzRRZI7dPI9Z3qmQR0v7u3BrlDfT43YpEqw1SwVF2
 4+VScr3r3vZzhtEee6/UCV5F9LMlRrl8IJk5cEs2uAvyJc6GGnjqKtvuJiOQU4AeFyBVYQ7
 lsQmS2nVYznp0PuncJ8/w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bz8mFcKz4HI=;7D/dG9AckHxnQxllU4XGMNXcrAk
 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
 OpPedgdl0C1VNqcrxVwmzPlbnU=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 5 Oct 2025 20:36:33 +0200

Use a label once more so that a bit of common code can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index fc67a6441c96..6aa8740c2932 100644
=2D-- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -200,8 +200,8 @@ static int cifs_do_create(struct inode *inode, struct =
dentry *direntry, unsigned
=20
 	full_path =3D build_path_from_dentry(direntry, page);
 	if (IS_ERR(full_path)) {
-		free_dentry_path(page);
-		return PTR_ERR(full_path);
+		rc =3D PTR_ERR(full_path);
+		goto out;
 	}
=20
 	/* If we're caching, we need to be able to fill in around partial writes=
. */
=2D-=20
2.51.0

