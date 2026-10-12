Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB35D39EB59;
	Mon, 12 Oct 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820972; cv=none; b=puf9REF6bEuwoYTn52LzUTnQOdbzJ2f6DhecauRI4sMdDJdPZpfqE2Uov0eVlMc8nzeWPXtSmCNZbu0XPFvfcuoOZ53L4qK8OBmLpt5dQ7yqlX7hvR0WSiZwEpDC6b5SPT8J1qcwWs54lIxNZIICcpK7SrwQxURfbvaJaS0XjaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820972; c=relaxed/simple;
	bh=kMMV4dSgIuIINhs4G4bbHvnLS5XWVNYT7KOjXT95fwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tf9kYMOR9OzggCM53jqn+bIGSytiJjivcy1HoMT/tLNa+eiP5JMDb3B/Vhqs9ajJFBeud86+3/sSiifXsPw8SOovinNc/VTiuFzwODHOa3G5K5TMJIAM/7xbMUydDBRs1pb9jNozoMSFONyVDN5cK1bWvA56FmmdEO1gpn2mxYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrlQtDVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrlQtDVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21151F0089B;
	Mon, 12 Oct 2026 16:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791820971;
	bh=kMMV4dSgIuIINhs4G4bbHvnLS5XWVNYT7KOjXT95fwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DrlQtDVpAWdY2ZNst+h6PAcJZ7lrUA8jlexA1pf+PyEa9ACqlnywBdau677VwsPsn
	 8w1KHcrgFLS7jRLrF6/dKPKUXFOjEFQYlYULJFcVYExdne0S4feSjlkOPhSZTNIkC4
	 xpFCPbQZrbgj7YQyFSeQEWzFyLXpwpIFh4a9d+Y3KiEe9krOPNY5t3UuvdxKw8DXST
	 qzl+rtRsoJdV1bnFbkztQO2tY3G++6qDtWrnOmbRkW9BMp+JbBh+xgpC6NUjPdVdfl
	 5k7SEgWn/vg2x7/sb87EQYt7isjKoIWVMoqy12FT28KzoDh7FR/vVT2R44/gE+hr0I
	 BPDum5lSqmrBQ==
Date: Mon, 12 Oct 2026 17:02:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Ozgur <zgrieee@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	CIFS <linux-cifs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the vfs-brauner tree
Message-ID: <30b72db8-b92d-4e93-bab8-e82bac8a485f@sirena.org.uk>
References: <aszji59b6B79a3Hi@sirena.org.uk>
 <CAOFRbGnVCnW4CEvhp_x6t58v0sB2to+6AP0hHYtci0EBnUWQzQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NvMt478TcZTwFp0s"
Content-Disposition: inline
In-Reply-To: <CAOFRbGnVCnW4CEvhp_x6t58v0sB2to+6AP0hHYtci0EBnUWQzQ@mail.gmail.com>
X-Cookie: Is this TERMINAL fun?


--NvMt478TcZTwFp0s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 05:30:28PM +0300, Ozgur wrote:
> Mark Brown <broonie@kernel.org>, 12 Eki 2026 Pzt, 16:50 tarihinde =C5=9Fu=
nu yazd=C4=B1:
> >
> > Hi all,
>=20
> Hi Mark,
>=20
> i noticed Namjae Jeon's commit (2de2cdd9cc08, ntfs: add pathname
> access for named streams) is currently present in fs-next and your
> reported build failure appears to result from this commit interacting
> with VFS changes that make mnt_idmap const in the ->setattr() and
> ->getattr() callbacks, and i think fs-next before changes are
> integrated into linux-next
>=20
> i compiled linux-next tree but couldnt reproduce the build failure.

Today's -next hasn't been published...

--NvMt478TcZTwFp0s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrNBKYACgkQJNaLcl1U
h9DCvQf/cNP6xzycFuNGZgpc2WR17TOZjf8e5Qj4nc+rlzs8bSbiKjoKJh74CVAI
Cd0a1N3g+WvYVtQRSvx1FMaTb1Sw6ODGZCSEpijNBgi0oY4bl7/tK/SIl5C9Vrek
bwc11J1bkrGpgvAALpPttc381k37HW6PwDH0UszJ+YiwAGIMpM3BN4v82AGwPqS2
eefqr14MhO4VNqnSFbQLyXruIabGFC7HX8vtGr0aNAYxY0H7xTlD76lI4sB7Z+3M
cbMEYrchb9cQRaEInkwqXE1KS9ok5oN+XSVasRXxsksFS+UT71QAMT/2ZckEV05V
HcsjN8rvIf/NzxwMqbCBSGpr+Cnqkg==
=twEO
-----END PGP SIGNATURE-----

--NvMt478TcZTwFp0s--
