Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B2328F3;
	Sun, 14 Jul 2024 08:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720946130; cv=none; b=V0K2ll4tgLyb0Hd3dMaqC23cnObG0fcjmd06OvCNhkXFr50oKoq2KFWVwcVyxHa4eih7HJpFR83v9HH/MUfTUCQy6AB3Px8zqDP51nyabHScBSsOhdXuvZB40/vOUpa2qIkoGzRoJ1ftIWv9NBoOQ00BMwgE5xUkxmqlSbipg10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720946130; c=relaxed/simple;
	bh=X4BdYgFSH221jGfjwvw4T+PWkp2cDmma/5jFhvnZ/hs=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=NE6RsSujcM6BQOHxng7pj2wRJIk6DdfpPeQ8e2d/fnU40eu4UmAodaxBmBSXcxCP/0Idq17V3hXVrM82NVRFiJmfE6DJL6R/+PppepMA6kCmSMwbEiIWlbwQbiO0GmqyL1A7ju187E7ps0J2kS99AilCPNJCWxd7anBVqiTIkzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ofF30iP7; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ofF30iP7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1720946118; x=1721550918; i=markus.elfring@web.de;
	bh=8sssd1CaXuoGXJxfU+Ilm+YolaxDXCqVXoLxKX/XL08=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ofF30iP738k2qmn4UvaX4oj29CJDuS3bb7j6pBQHjelixejAYM5lpfXvvKPSQhWv
	 OO1LvnhUEjkRX0en4/MAmxaWRrjSSqlLdC/CLScCbkrsXjv6AnGD+GSCm1lMYsuNC
	 BRApm95HYJzSwWsmpLb8Es0PFXgKKsP+1w/1tLz+nutq6LbYhke6hBsiP+THxb+J2
	 plLJ+7nrV4wl5OHQ7mC9RwFqYoNrac0BSepnsCUQoGtowSVIsRwKy2iMXtg+k98mP
	 Arp3v7SsHxXZ2h4UvCc5bTpnp+cPqPPJbh/ajPzE20R9xwer4mSFa1xXIo8gOSYue
	 2CF4ZHz4yBLL/FnrQA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MG9DC-1saeTq1dVc-00Dr5h; Sun, 14
 Jul 2024 10:35:18 +0200
Message-ID: <18310e20-826f-45ab-b69e-dbfe47a1f83f@web.de>
Date: Sun, 14 Jul 2024 10:35:00 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] cifs: Use seq_putc() in two functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wHQHsCa/IRF5oT7nVboVX4k43zcPoxY8kVyGiLEg6oH16W9H4qq
 +KK4e3p6ik1SAJPUhS/K0p2EEsqApim/8AwVRFnEUV2ZPsRofbAEMvHX03V90DvpFFFFdV1
 VdcMS3VfxdlgoAM8J21xg81Zvq6pwgKsxBeo1ppRw6TQxnNaUFi+Y2dYPddhwh0EuGm5CzM
 pRT0vnCOhnfspW3inE2fg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Tn93NAUKJpA=;twoAGmU/W3belNO+hhOuK40o9QN
 5gM08NFoVJWTSVwDlias1LTCZxTycPi6ikmFIf29Q8jcic42zprMbHHLwFqPNi9Ly1oBlc4PG
 7D2rcsGgudBPm/d7lbI/jOW8WDnqr3CT1RB//1uevPP28cTDPMgHF3RRUk6Ea9U9yS6SNYFce
 0JMTQx7CVqUCyOBlv7ICyocnVOI+MdHxDRh5Zt/83uxVXT8M9uE0oB5qoEwCCmBTPh9GeOuse
 3MN/6bjBapRuXCRe5c75OHyabCAc2lW9Wongl4FjJfv+zEcLDaEoh/gqN26IHQ6H31N20Diov
 Cp9tjjzvXDOIhgYsmF2HV+bFZIfctR1H9HwnvgOkO/XoAilAnhuvCFsjEWAoKhE/kGE7W+ORX
 cIHzfZN3Ri6+UISrPMHVivbFOwF8Y1TL2rdy6iifLfDJXIdTCTkSGlAJoloZKZ4TAljYqVaJg
 ZMw6Kmd+aw7auPm4Dd+Z3tABZiTPwMelUKuGY2OG4xtJzh+/PAk3Gn/WVXxN3fFJBicpJw0Vp
 0lGoY2/L9TJwTZEW6oZ1w3LBHID4IpMYYZbbjVHMnnGVlhcuHKH67K39EoDMJ9bNshfgve0r2
 C2gVwKNTifa4oyWT2ooG08HE7JqgNgwCgZBkp22Urpph51+kplGHfKY/Hgyimaruf8ZNsSZrt
 dwqmlh95j3+IdD2gfgsGFYUCh07OtcvmqGlF+k++285NhwTw3R8HksddccoHlsP2fXMMGT3Ha
 czaSwQEuIkwv5AnsWdm6TOuZjvEu3+fSBynXaR/RoBWYkYweQv1QvGw6a2c8i9C3yT8zspIwI
 G9LqJ29ifSiU2OWLxjF3adZA==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 14 Jul 2024 10:23:49 +0200

Single characters should be put into a sequence.
Thus use the corresponding function =E2=80=9Cseq_putc=E2=80=9D.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/cifs_swn.c | 2 +-
 fs/smb/client/cifsfs.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 7233c6a7e6d7..68998c6ba7a2 100644
=2D-- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -655,7 +655,7 @@ void cifs_swn_dump(struct seq_file *m)
 		seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
 	}
 	mutex_unlock(&cifs_swnreg_idr_mutex);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }

 void cifs_swn_check(void)
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6397fdefd876..ce5cb72bb81f 100644
=2D-- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -491,7 +491,7 @@ cifs_show_security(struct seq_file *s, struct cifs_ses=
 *ses)
 	}

 	if (ses->sign)
-		seq_puts(s, "i");
+		seq_putc(s, 'i');

 	if (ses->sectype =3D=3D Kerberos)
 		seq_printf(s, ",cruid=3D%u",
=2D-
2.45.2

