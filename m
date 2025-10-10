Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BFA3016FB;
	Fri, 10 Oct 2025 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760124097; cv=none; b=oivPslyTBciW5WA9Iqv0PnmoCvCdEXdbb2SCT9d8yjyRMHH6ohI9L5G4hjdkGsDBfF1CMsvVCb/IYUCB1zbDQr+3d4qm6k2FmzKvy6niJy6WGz7Yauo//yOdMFGWSMja2kHQScHE4g88HLxK7hKRA3HaypMDNB6e8nf7T3xKk9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760124097; c=relaxed/simple;
	bh=0YW4V+Oz9BuuX/SahxOR0qkDd6qjtc6lw4rx8c+Zzww=;
	h=Message-ID:Date:MIME-Version:Cc:From:Subject:To:Content-Type; b=R9ywVnM0QNFg6y5MTU1AMWeOtFlLiiOlacws25/0hQe21zzObs2go8LmITzPjMuxXaH6KFzdeAGyb+arVKyF0iZw658Tr+cFmMB81OUhpNPvqBqZ6Pv8H44Mci+3zViNKhJD7CiXD/lkCoiaWYvmThPBSJry+bEnFkncRO8Rw8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=p6r5rprf; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="p6r5rprf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760124087; x=1760728887; i=markus.elfring@web.de;
	bh=PVaJL8zPNKZRfu59FI3CUOM7lgnsj8C8tzcWf3qmHUU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Cc:From:Subject:
	 To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=p6r5rprfIW6yJi8/SVCOLowVLmQSLifoNS2S2yYyN12qRvBC54GyPOT5+6i18IKh
	 S7DD1HWzfqG/a3hBuuCsjrUTOFd8/FlBbrxqlm1GKYWA1pQAZnqWVoOaFzUYjeewk
	 Fw6UbkkCu2OApaxLWmCDIMV4c/ZzdhXjVvTf0LQPFqNdX07QPHwr6G6S0bFafCT79
	 5SBrSx8txQHBxrYM7fQzhViET4EDIYtpg/avc07UEcoyZ1AOrD2FS77+Dbw/GPMB9
	 D3SU3cFOle5nnPNg1gn8PEEw8TwGW9WS+56//xI7v4ATt4GqRBXHwVsOXVr3mP+h1
	 kcoiMO8506xl2CuJjg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MWi9q-1uj2eS24IS-00M4WC; Fri, 10
 Oct 2025 21:21:24 +0200
Message-ID: <f61abf77-4f12-4dc8-8b42-4bfe19aef174@web.de>
Date: Fri, 10 Oct 2025 21:21:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Return a status code only as a constant in
 sid_to_id()
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Qiujun Huang <hqjagain@gmail.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TxXm5h9ocjr0iF5JsEtU17zkeAwaHBaq3yBT5cBnWUP9RRqpqBj
 zdh8bH5R8cn+lLRL8BI4eo/mC8XC0cCVoSjSoxHSWwGINjqnnEn3O+b6giIySOqdCqDvZKI
 RT0HZlzfw8Niw0wkUwQ+92E8lMoj2qh1fAHK1M+jXWzeELh8urHEX0aps3xOh8Gu3xl2MAn
 O5cxOdKNnOf6xIieV0oAA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WDTwiktj9kQ=;k6tNdrSWvOS3QI5yph/vb75pQYF
 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
 Q6R9g==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Oct 2025 21:04:16 +0200

Return a status code without storing it in an intermediate variable.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifsacl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 63b3b1290bed..ce2ebc213a1d 100644
=2D-- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -339,7 +339,6 @@ int
 sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
-	int rc =3D 0;
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
@@ -446,12 +445,12 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_s=
id *psid,
 	 * fails then we just fall back to using the ctx->linux_uid/linux_gid.
 	 */
 got_valid_id:
-	rc =3D 0;
 	if (sidtype =3D=3D SIDOWNER)
 		fattr->cf_uid =3D fuid;
 	else
 		fattr->cf_gid =3D fgid;
-	return rc;
+
+	return 0;
 }
=20
 int
=2D-=20
2.51.0

