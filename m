Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D42783CD6;
	Sun, 13 Oct 2024 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728843896; cv=none; b=saWf5W4mXg3sk4ngBTnnuEhMQK4coLgL0YcGggtLqz7jaXc2YN1pI2+DcdqVWupkKo6gUZojzXrGcMggT4/HEs7PzYfYcJfRgEHCNB1aDAm2HMBAIvee99C1+gxB+jhXXROu9ssV9jRY+cWpjDWIofiBpFBPsPIkycddylrhvbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728843896; c=relaxed/simple;
	bh=csgu1k3Vw/mfHDjlVqCE2Wf/Z6litrpSaubXDJOIgE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBNhoPiuvmat1Jw5Oe70fOCYZ9GXYYzAWoe4/0c97XM11fQjEvwMa7PrRqZukWSSoas9Z7GvKIFUwZZ/j/6oh0rN957XrGDLIZxA/nzIPUxzdBQ2ixaWaffbc6UyDvJFxa2fRE2g/CRuXpscbF1VzO8D3+EU4ZQOix0mIPBhfyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz; spf=pass smtp.mailfrom=ucw.cz; dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b=OgQplltw; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b="OgQplltw"
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 44E0A1C0086; Sun, 13 Oct 2024 20:24:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
	t=1728843885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ApkmTvsFs0wepMHr85o8UFcCtvHLuYzUeCXD5Ot8YKw=;
	b=OgQplltwGPWodCHxi2p4rTe8pfii4DINKlXixBFi1Csd7I6RCgIp6+zQO19ggKe0WI0oqb
	2KMhaIWFNjyw8M5UKHyH6df86KF/JJP6fC080Y0voPNl84dqwMl0RShI+fyCbD+lDxv2zP
	0974ubJDmEHYLorhM3iCdhr69UZ5Xy4=
Date: Sun, 13 Oct 2024 20:24:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>,
	Steve French <stfrench@microsoft.com>, sfrench@samba.org,
	bonifaido@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 01/13] ksmbd: override fsids for share path
 check
Message-ID: <ZwwQbDchDzh+EC+T@duo.ucw.cz>
References: <20241012112818.1763719-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TyKf9fOujaFK227I"
Content-Disposition: inline
In-Reply-To: <20241012112818.1763719-1-sashal@kernel.org>


--TyKf9fOujaFK227I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Sasha, please include cover letter.

This whole series is already in -stable, as part of 6.1.110 or
6.1.111 (and I guess that means 4.19/5.10 parts are queued, too).

Best regards,
							Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--TyKf9fOujaFK227I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZwwQbAAKCRAw5/Bqldv6
8ntLAKCdrwa2yiVE1E2A2fmpg3E4E/HqHACfR5j/0vtheG/Ud9xkJViCQ+d/bzo=
=VSkO
-----END PGP SIGNATURE-----

--TyKf9fOujaFK227I--
