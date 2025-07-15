Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BDD2D130B
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 05:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556722; cv=none; b=StVePvrk2DQnRg6qKi8V7/391b27y+4/wFa8VQM7kGa/Jh5PBAxoVbzxf1wLRirIHynDk0HW4IvZcBIecF1lNJJ1Xy8gGeBLs+cCJKLW5RMWobpRDShfTHQ6IJF+pHJp4Z5u3PVdi20VIiJ9IxGUMOpSiGVGOPczEjLevEtpLdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556722; c=relaxed/simple;
	bh=PbP2GN4qJMHbZFPap5fEa9/a3tNi7tUkHera2I51/TU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uqKzoAwEpBRJixuxwA01aq9mMa1HfsiQm6J3JZ+mLbzZzbSyvu/cbjSLdR7ffU8EsGJYSFGKH23NZZnhomqSuQLuaeeq7EuTzPMTudF7EWTDlunpBCJ0PnaGnmaoBgNGiZ3x/wlUa/3SvdMdYc/jgf6fuITbio60cU7aMlER3QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Gk1TkwrU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Gk1TkwrU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=PbP2GN4qJMHbZFPap5fEa9/a3tNi7tUkHera2I51/TU=; b=Gk1TkwrUxPZCjWzBppW2fmDzcO
	1Km9bmR89Eigx8zfj8abXsWpmJ3yFarSX/sw/ndK9jx2q/cCOsI3zROsGpRCb7DywA5qU75yawMfY
	jPECQnN1caIlVU4JuHI7YMy3glOe0BvnvKfx21wLdpNTSO5a8DU444/U1p38DmmqXaWMlJbo/NniT
	I7YEiR/Wy31VKSk+38/EMJV8+o5gEqZ7IV2XvQrSUQPMhQhiycvZsc3DA3l6iQJ2X+sgPirsjDdF4
	4G79TAGFv5hfQ7QA3KfdEo1zMCX8dhSdKKzprQ9KpfJtjAAIlVeBAaoe415nbJnw4OeuCSvzExlsS
	+wZE6Tff28iaeD/quxjTpf5qBpznvZEPtFqj0oaj5n2pp+l1285iEbEZNPIIGfgkIO5IULeCdeJMn
	vr+UTjga6oXIrvG72hnTEqPzX2o6oJ5xdLk/Nakft+G8uwIuCtGoJ7hV0LCxrTNG1KCq0W8y31sFY
	Ss0lywN1I23AZg5NmZ5wfZ3e;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ubY3j-00FOzm-1y;
	Tue, 15 Jul 2025 05:18:31 +0000
Message-ID: <f0fa321e-921f-40f5-b202-9cc751f2268f@samba.org>
Date: Tue, 15 Jul 2025 07:18:30 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][SMB3 client] Fix SMB311 posix special file creation to
 servers which do not advertise reparse support
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 Paulo Alcantara <pc@manguebit.org>
References: <CAH2r5mvA3NQp8BDj_v-k3YRUR9Xe7u5XmaM_XQBP4xJts0R6bA@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5mvA3NQp8BDj_v-k3YRUR9Xe7u5XmaM_XQBP4xJts0R6bA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8fp6l08Q2ug7TRK0IgoZDlQi"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8fp6l08Q2ug7TRK0IgoZDlQi
Content-Type: multipart/mixed; boundary="------------sLdlVrOgOPr2QQRPYaiE2r40";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>,
 Paulo Alcantara <pc@manguebit.org>
Message-ID: <f0fa321e-921f-40f5-b202-9cc751f2268f@samba.org>
Subject: Re: [PATCH][SMB3 client] Fix SMB311 posix special file creation to
 servers which do not advertise reparse support
References: <CAH2r5mvA3NQp8BDj_v-k3YRUR9Xe7u5XmaM_XQBP4xJts0R6bA@mail.gmail.com>
In-Reply-To: <CAH2r5mvA3NQp8BDj_v-k3YRUR9Xe7u5XmaM_XQBP4xJts0R6bA@mail.gmail.com>

--------------sLdlVrOgOPr2QQRPYaiE2r40
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8xNS8yNSA1OjMxIEFNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IFNlZSBhdHRhY2hl
ZCBwYXRjaA0KDQphY2tlZCBieSBtZS4NCg0KVGhhbmtzIQ0KLXNsb3cNCg==

--------------sLdlVrOgOPr2QQRPYaiE2r40--

--------------8fp6l08Q2ug7TRK0IgoZDlQi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmh15KYFAwAAAAAACgkQqh6bcSY5nka+
rBAAm3DEnr/Lwi9bPx08E0+adlnisXoEzBGnUzREzpy0AggC3ZlhgKAz+/16uUUmyv5DjphG0bHY
Z8zIyfsUTTNm0SQre2eofydzxYNZG2/fNlGRq1LmOD3COcGvjUI3Qiy9ZhfOuqmEYcmny70G+yob
UJ5WycPLbTxN3Vpx0RgEOmTy8ePR6RaKfLhSqVlTMXcpebU3XRRCb145cP/2JInhu/VpBFPYbOtt
idCz+Xxe6hNRKQfCqsCkgDXuLMEwNO07cvwFVbqS61QEroUFhCT9RuEMvPD1cnOVZjQasJx/c5t6
r6fSaXAoIfFjRBRnmyLOdJBuEjQYeaOvdOR09cC3q9n75rRnuWQ7tF8jRXvKiEaNhb5be54vssbE
hsjJYIs+DqtRobw4+zZlqKQxuDWSVaCcb7d2T9aSYvcIJS94vb2ozBApInAPcIQAGkvxbEey59pg
2uRIMBpP7aKtpc1Tt7T+xykOGS5nLCJ7utcNrLed4rIl+8M0CktdhBQf1lTDnvwCi9L5jn5sQWf0
7FQj4VB7tjaXqzPttkGJC8i1uKlNOAfr0dTI05SfevUbIz7hgR+yLLpBeZonFzJfYSO+iS6kT0td
iIn/lkG92iTSUo+fKfjkLFxTmFMcGfsbu7Q0IqWVq8a3H4jq6teXDegVmz4TJk3zo760iHVx+GCH
Nrg=
=RjSN
-----END PGP SIGNATURE-----

--------------8fp6l08Q2ug7TRK0IgoZDlQi--
