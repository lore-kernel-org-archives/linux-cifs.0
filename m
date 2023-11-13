Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D491B22EF6
	for <linux-cifs@vger.kernel.org>; Mon, 13 Nov 2023 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="GS9FJ1mC"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7941BD;
	Mon, 13 Nov 2023 10:11:43 -0800 (PST)
Message-ID: <05bfafca49fbed96ea500c25a0606205.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699899102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yKSrjtxbuj9NYHKxn0CA+1z9ujAMfGaUyn32vutlNYo=;
	b=GS9FJ1mCnxnQQpV5S3pvgFV9msp4MULkEwJy1c84k7K7H4tMkrRAo/OHJgjf1KxZiME0Ez
	Aij6N9cc6+/bjJcwRW0+W/d5VeHSNjXM3ihtIUZ6E0+ppNaEBIXmXPnZMgdc3QingLZoRe
	v5JChg++fLyyap+EjEnc1GDKVj2A2ktX8pbl3IHfejKB1VUUiow4oNDE6OzH8EpkIXSpy0
	MZvEaq0ykg0RK8VXMLcd0slkweWBacy4e6y/UlJ6+87IdGrDnomK2QC2CgxBQaNfVANxKH
	12S5J2U43Ptx8yQ2jRNbHMnR/kHDAAJCquHAFRy2QJ18D4v2DHrMoc151/y2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699899102; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKSrjtxbuj9NYHKxn0CA+1z9ujAMfGaUyn32vutlNYo=;
	b=Tk3B5gXGy4901LYXYS682EHokjf4ZKcukDBWeDHKrt/1G11h4KMuqDDZLg/710GljnuQZF
	i+cPq2hgmhMuLBhOdSlBg34RU9HGAri4zsSGCeIZXKwx43VcOd9JTy1ehcCmDHRPKar+SQ
	q5virzBVEr8vBcdrAsSKep/TpmNlshcVqhH7EIBMLtkjyWQ7cr1/Pz/yH3+KpSnNZkTd+2
	YvJ1rABBI7AV+HD0VBT4Mp5xXi6mgHluR1vJ2tWWj5Cxai+jpaqv9dNXNrdfz0+IqYaWvd
	GTK+Gqa4wD9bMQjr9lLr14Odjk9eeDsTZmqPk0YNhMJiLJ8oAM9QauXfPJAfeQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699899102; a=rsa-sha256;
	cv=none;
	b=NQIi+hdOWOW3kWFB0mPd14F7ABAkz4M01Mu2/JUeZA8xWS9BNMrgAa7Hk+f8RzTlY+4USC
	GditludfOky8+Kt6u7v+RepyLRQMDkRMCvCZqV+VA8qgjhnvfO6gb76AmnIW5c8KNDdeiC
	IQOYcWGh+LHonLr+bYuaUkjxH3c0RXg1CAI/8stYwDVNlxQ60d2pccDeaY/wyUjhXQRy7a
	mpexNcTund2kk3S/Nz96GI8ihM6a7HCfIHnWT6VDd7f5T09/bS0sDo6LQqu3fDAvwMYMTF
	wHJLBsLfAOy7v6Ot+hVb3WArZcmeE2Inzn0esrehbvvNkal7GdQH/VgweC9DCQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Anastasia Belova <abelova@astralinux.ru>, Steve French <sfrench@samba.org>
Cc: Anastasia Belova <abelova@astralinux.ru>, Ronnie Sahlberg
 <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey
 <tom@talpey.com>, Jeff Layton <jlayton@kernel.org>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, Ekaterina
 Esina <eesina@astralinux.ru>
Subject: Re: [PATCH] cifs: spnego: add ';' in HOST_KEY_LEN
In-Reply-To: <20231113145232.12448-1-abelova@astralinux.ru>
References: <20231113145232.12448-1-abelova@astralinux.ru>
Date: Mon, 13 Nov 2023 15:11:37 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Anastasia Belova <abelova@astralinux.ru> writes:

> "host=" should start with ';' (as in cifs_get_spnego_key)
> So its length should be 6.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Fixes: 7c9c3760b3a5 ("[CIFS] add constants for string lengths of keynames in SPNEGO upcall string")
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> Co-developed-by: Ekaterina Esina <eesina@astralinux.ru>
> Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
> ---
>  fs/smb/client/cifs_spnego.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
