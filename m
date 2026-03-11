Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D07227EFFA;
	Wed, 11 Mar 2026 08:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.100.38.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773217612; cv=none; b=m+gEy98avTqFbr73CTPy341uR44pc5+aEQPL7CU1PuJb+PM7aiX/8J2Jg58GtUhzNXmocFVcZOrSBj/pGT0XzJ8OkWpVC72342sVxh5Q86VODeIyUha8ACR8fDBW0jLg4gx25aLELrUxFadabO2nRxFMY1hVUobuzrwovlM6FQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773217612; c=relaxed/simple;
	bh=87dh4ypGH5WauOZ4U5TBhMhHARRH0EgR9IOZeLc2qrI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPTd504FnRqHayOgzPEu4SKYCWegGa5gPXuLTupOGgzXvx2/mB93vyg7OlBk22t0SW0EhvM0PNDcH5GjgNNGFwep+WxXaLNRrRtUyLcbF6rYWcSS16DT7ash0TyO7+l7q4zTPEw+1t1oFrQtYhkBdgy7ZQY95v751Rh8djxm0HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de; spf=pass smtp.mailfrom=uni-hamburg.de; dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b=YUyZ1h+g; arc=none smtp.client-ip=134.100.38.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b="YUyZ1h+g"
Received: from mxchg03.rrz.uni-hamburg.de (mxchg03.rrz.uni-hamburg.de [134.100.38.113])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fW3WC3tM3z2xG9;
	Wed, 11 Mar 2026 09:16:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1773217015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xS35pK5GgtyG7mhh0Beq7I75ERnEZDRDHszQAMsxb60=;
	b=YUyZ1h+gqonKOXd1FNX1u+LzTsBClClvwlEgJk3gCpRdakuYcwrI+ao4Ne72CmjoIZ/Lif
	91+2XEeSkCr0xgxsqyOhA+LxIRH72jVsqSV18WxXcbyosPWTmOGYL239N3mNXPjthlVzeq
	w3W6TgPJ3bg6eLhip8y0Y3YWyVk7aQD0TbXaJW+yDNnNN+b9a28kQQiTZO6rYEW5wKPefM
	VKKDOdeYI2cDChTR5es3+lZWAAU98NoWFH/HtqkXnidJSQPas/GHXfnYnErMuSWyhFNqRy
	rYMjZJ7p0NL4aErPQuQjX/WtVq7ftOaeglne3yNUJotaLI4Mo35CGl6XxKsZEQ==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg03.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fW3WC2DFDz2xFP;
	Wed, 11 Mar 2026 09:16:55 +0100 (CET)
Received: from plasteblaster (80.187.125.159) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 11 Mar
 2026 09:16:54 +0100
Date: Wed, 11 Mar 2026 09:16:53 +0100
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
CC: Steve French <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
	<regressions@lists.linux.dev>, <stable@vger.kernel.org>
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <20260311091653.358b213a@plasteblaster>
In-Reply-To: <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
References: <20260310235642.6d9798f4@plasteblaster>
	<c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/rLq1UnO+dcbv_b3D6w7UnRq"
X-ClientProxiedBy: EX-S-MR01.uni-hamburg.de (134.100.84.80) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: 162d9f
X-Rspamd-UID: 28ced5

--MP_/rLq1UnO+dcbv_b3D6w7UnRq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Tue, 10 Mar 2026 23:06:24 -0300
schrieb Henrique Carvalho <henrique.carvalho@suse.com>:

> My suspicion is that the regression was introduced by:
>=20
>     5713127da855 ("cifs: update dstaddr whenever channel iface is updated=
")
>=20
> That change causes parse_server_interfaces() -- should this be running
> without multichannel mount option? -- to overwrite the port stored in
> server->dstaddr with CIFS_PORT.
>=20
> The attached patch preserves the existing port from server->dstaddr.

Splendit! This is the simple something that would've taken me long to
find among all the ongoing changes in the SMB subsystem.

I just built a 6.6.129 kernel with the slightly adapted patch (as that
is my production series right now before I jump to newer LTS) and can
confirm that this fixes the issue.

Do you need a confirmation with 7.0.0-rc3? I guess the picture is clear
enough as-is. I've started a build and can give a short follow-up later.


Alrighty then,

Thomas

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg

--MP_/rLq1UnO+dcbv_b3D6w7UnRq
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="smb-nonstandard-port-fix-6.6.patch"

--- linux-6.6.129/fs/smb/client/smb2ops.c.orig	2026-03-05 16:03:43.000000000 +0100
+++ linux-6.6.129/fs/smb/client/smb2ops.c	2026-03-11 08:25:05.244722103 +0100
@@ -586,6 +586,7 @@
 	struct iface_info_ipv6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -634,18 +635,20 @@
 		 * conversion explicit in case either one changes.
 		 */
 		case INTERNETWORK:
+			port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
 			addr4 = (struct sockaddr_in *)&tmp_iface.sockaddr;
 			p4 = (struct iface_info_ipv4 *)p->Buffer;
 			addr4->sin_family = AF_INET;
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
 			break;
 		case INTERNETWORKV6:
+			port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
 			addr6 =	(struct sockaddr_in6 *)&tmp_iface.sockaddr;
 			p6 = (struct iface_info_ipv6 *)p->Buffer;
 			addr6->sin6_family = AF_INET6;
@@ -654,7 +657,7 @@
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);

--MP_/rLq1UnO+dcbv_b3D6w7UnRq--
