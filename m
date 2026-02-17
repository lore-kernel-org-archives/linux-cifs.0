Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D8B307AF2
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771320344; cv=none; b=DtN1bh3tRcLJNA28PXHCOamiHpgYgT8tDYelDexOoKrvpZ3t3hhD5EV7x16cdkptKM0ulLVvc212zvvadWmzy99ye/kkyuzCXNmO4e0s7GhbWAO3xo1LZk8wXr+8uA183Ghff2PItlZ+wZY08HU/oOr/49BjCJQgZVkZtGqHYe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771320344; c=relaxed/simple;
	bh=VnIiEtr2gGjxBjMvXUMRexP+zH8RLY1sl6pBXyiY1Mw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=toiAC2VPDBZaU79gDChxe225DrcmsYP67r9N6XuxwykKM/DJq3wynlRH+uatWdLBnCjCy/26D0dVdSug0CW6+RzV1F20yD6J4xBTD4ojgNJ4fqTk8WrFeLtM2H2j/O+UoJCPyL+umlbcZBSa5m6abb2YCGOrvNOSYP/kuvrs14M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zBSepbDU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zBSepbDU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=XZhe9B6a6Z3ybTfue67YbrselSKW6DN+PlJ1ctAyMB0=; b=zBSepbDU8t9I89F0GZim35urJa
	5+9CxQDYSgXL/wlRa9t6WES9DA7v0KdvXus7ywcibujX0j+IOMUqreRzbf9h8t8m5PL2Aq9rfo0eD
	HJNE+rNC2GuwaDDbRaZ0f+3e35BkD9R0016VM7evjy2nhXu9Nab3m4fqdWapbjo6un8PpKLuE8zw2
	RTtzCqBScfcuEIxI00o1Tz5OX5F+Ba/djDTfF9Zwpeea1SstQ5suga8DjiP93Ep8pCZgnNcZITjp1
	Rhj3kG/qHh+DDe9YdLKONLgG/m+VCI1c6BQeIWmzUk/xN5H8FoncMTZA0mWPRF2ImG712/SAlJr0S
	7nmrRQvUn+CnGsgWlViqiHCayE+tNz2yA8GznSYkjW+uCr0jeMRngbFqXDjVdSmfcGnR90tO9WFME
	bRLBGMOWIccCT0BmgNgugP+d/BsFk3l835KFZksCKxLBljCW5MoWwjRP/nXkUYRi/NLp7NC3ZyXrq
	cC33y8KEy9DqXq044l43WzVF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vsHKu-00000006khn-3hKF;
	Tue, 17 Feb 2026 09:25:40 +0000
Message-ID: <880038e4-f339-496a-8845-f7d3a7f3b5c5@samba.org>
Date: Tue, 17 Feb 2026 10:25:40 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>,
 CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 Arnd Bergmann <arnd@kernel.org>
References: <cover.1770311507.git.metze@samba.org>
 <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org>
 <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
 <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
 <CAH2r5muf=Th_AbA7SZaQKApyvr81FMB8WF-5yZ3ihzap1swQWg@mail.gmail.com>
 <98d25ce1-1f1a-4517-89f0-8956bffaf9d3@samba.org>
 <CAH2r5mswN8W652Br4QQTzhtDXtXKvqea=dWVfUFF+xDYfOx6HA@mail.gmail.com>
 <28d94c9f-b85e-4746-bb08-188090409682@samba.org>
 <CAH2r5mtA=DdpEiyqspNG3eoyjkGajnEwoRnOyXyBimDtCND9ig@mail.gmail.com>
 <c5aef237-2a12-4be5-b917-de502780be85@samba.org>
 <CAH2r5msAAN-EgOmRnoO7R4RPu2suNr+mgk5c5JAj9b-_kjwymg@mail.gmail.com>
 <237aa80d-8bd2-4dad-9975-85e11e2bf1fd@samba.org>
 <CAH2r5ms2EYJMm+764mJ2nLZRBz2R7+5LAeKfxZ1mb13uSSoYiw@mail.gmail.com>
 <CAH2r5mvmLYjJnxZmH3Mdawpk97Os7Zk9t_m=FrVOAXALNTw7hw@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5mvmLYjJnxZmH3Mdawpk97Os7Zk9t_m=FrVOAXALNTw7hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 17.02.26 um 03:16 schrieb Steve French:
> I noticed build warnings on two files when I build with your updated
> branch. See below:
> 
>    CHECK   client/smbdirect.c
> client/smbdirect.c:97:1: error: bad integer constant expression
> client/smbdirect.c:97:1: error: static assertion failed:
> "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
> client/smbdirect.c:98:1: error: bad integer constant expression
> client/smbdirect.c:98:1: error: static assertion failed:
> "MODULE_INFO(parm, ...) contains embedded NUL byte"
> client/smbdirect.c:104:1: error: bad integer constant expression
> client/smbdirect.c:104:1: error: static assertion failed:
> "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
> client/smbdirect.c:105:1: error: bad integer constant expression
> client/smbdirect.c:105:1: error: static assertion failed:
> "MODULE_INFO(parm, ...) contains embedded NUL byte"
>    CC [M]  server/server.o
>    CHECK   server/server.c
> server/server.c:629:1: error: bad integer constant expression
> server/server.c:629:1: error: static assertion failed:
> "MODULE_INFO(author, ...) contains embedded NUL byte"
> server/server.c:630:1: error: bad integer constant expression
> server/server.c:630:1: error: static assertion failed:
> "MODULE_INFO(description, ...) contains embedded NUL byte"
> server/server.c:631:1: error: bad integer constant expression
> server/server.c:631:1: error: static assertion failed:
> "MODULE_INFO(license, ...) contains embedded NUL byte"
> server/server.c:632:1: error: bad integer constant expression
> server/server.c:632:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> server/server.c:633:1: error: bad integer constant expression
> server/server.c:633:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> server/server.c:634:1: error: bad integer constant expression
> server/server.c:634:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> server/server.c:635:1: error: bad integer constant expression
> server/server.c:635:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> server/server.c:636:1: error: bad integer constant expression
> server/server.c:636:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> server/server.c:637:1: error: bad integer constant expression
> server/server.c:637:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> server/server.c:638:1: error: bad integer constant expression
> server/server.c:638:1: error: static assertion failed:
> "MODULE_INFO(softdep, ...) contains embedded NUL byte"

I didn't change any MODULE_INFO() code, I guess it also happens
without my patches?

I saw something similar with MODULE_LICENSE and maybe MODULE_DESCRIPTION
in the 6.19 merge windows.

And it was a bug in sparse.

I updated the version I use to this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/viro/sparse.git/commit/?id=2634e39bf02697a18fece057208150362c985992
which is one above https://git.kernel.org/pub/scm/devel/sparse/sparse.git/

metze
