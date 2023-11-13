Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4800D224C1
	for <linux-cifs@vger.kernel.org>; Mon, 13 Nov 2023 18:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="YPH52W0v"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FB710F4;
	Mon, 13 Nov 2023 10:49:46 -0800 (PST)
Message-ID: <6bcf9eb2d4ca5faa17e8e0842c4d69fd.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699901384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YdugKrF1IHQlb6TkxWiEpumPtlmZ379QWs8fZvedX24=;
	b=YPH52W0vCrsa65YO0LWx28OiLIEZNBi9nurcA/VlQfU+CVhc4XSv9teWPiiXs1gcZ/1S6j
	2z6MMwfd8OkzBd5XtpWD0d1jPzocppDfGsmsY3/drw2AAPshTJlSBzCpZUPzSLbrfuvkB6
	ymCPO/7JjQd0NXRxBi4v+t/uLTYZ+SFDkZ71rVWk7UHbVdcKcTmE4govFPIHZNuaQcH2AV
	8Y3iAank794IxdExgLcjag4xkxyEzScpvdSHjKN5QJUrslHk0waL+X4k7/muesei2Gq/NX
	MK84RCVSmjfqn76DjhOU8Dt57bep+RotwQ0WgX5lh5w+ISu7XfufWzE4yVYqoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699901384; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdugKrF1IHQlb6TkxWiEpumPtlmZ379QWs8fZvedX24=;
	b=IVzS7DHdzhuBCTwZEqcrJ0EebdfaWtnBVQZ6Tw+SV10HTFOC7qiUOOF+qiAgtNE2oqyUp3
	yujSJGmPc3XaAqgWbbde5G+cSFKXbfvWPX/QKlhBwyCwj1gTti0B3O6RsFH0yfPyNR5cmQ
	Va8kvIh3FMMkGlANinL+Cn7mBqvnXZ4eQ9jFKCa1hlIrTR54qLH1eRLh3q06w7kaRqcp52
	oSF1FZ/aQEHG6tbAR+yDY9uOlLwGLZ9Vso6JZbxxQ5/MaLlAAbBZpoqsjMp8VBF1Bl44Q0
	8tfv52fOJnxnh4V6zU67knG0RoWXoUnDTy4Ea8OKjFk0nd5Ztut2s8KFZrOyTw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699901384; a=rsa-sha256;
	cv=none;
	b=govAlo1L714Gbqo1VbQfkM6vjRsK6bhNSG9DtUwjDdkU3lMBmC6+ud9z2NrKh9jj2D0PkB
	yIRk3dPQksDdh6Yi04mjjjTA1RpTozaISCoZrZrYIJYaTqcHrd9VbN+ciUQ2OioDao8vu9
	T8Ygh0cWuG/vVbIc+asUd+GgyLrWuhB5rsU8iuACu5+SNkWAG0m75Ykjzvec5KGLSpLOwe
	AloD5BcZc6XOF4a+NTZXcw6jhI8WBqi87a2SU59AqC9+nTDJhw51fgsqhPgGblhGPWfBCd
	olJoZV6+MNASjIPOVtxOL5/OR6QEOac9JvWGOdCc8SUlj7c2af8WnkYA58jEKw==
From: Paulo Alcantara <pc@manguebit.com>
To: Ekaterina Esina <eesina@astralinux.ru>, Steve French <sfrench@samba.org>
Cc: Ekaterina Esina <eesina@astralinux.ru>, Ronnie Sahlberg
 <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey
 <tom@talpey.com>, Aurelien Aptel <aaptel@suse.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, Anastasia
 Belova <abelova@astralinux.ru>
Subject: Re: [PATCH] cifs: fix check of rc in function generate_smb3signingkey
In-Reply-To: <20231113164241.32310-1-eesina@astralinux.ru>
References: <20231113164241.32310-1-eesina@astralinux.ru>
Date: Mon, 13 Nov 2023 15:49:41 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ekaterina Esina <eesina@astralinux.ru> writes:

> Remove extra check after condition, add check after generating key
> for encryption. The check is needed to return non zero rc before
> rewriting it with generating key for decryption.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
> Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
> Co-developed-by: Anastasia Belova <abelova@astralinux.ru>
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> ---
>  fs/smb/client/smb2transport.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
