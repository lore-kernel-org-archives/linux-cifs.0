Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C2B227B88
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 19:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753989655; cv=none; b=ed6dWOxUPwXfnGxj6f1IQ+p0AUQRHZLoUNd+Kunc9cdSpHHazZcHUskTmsYJ4jIZwdDEJzFeKgHQCeWyZApShZ88VV5Fc3xffCn6qHm4fBBAHWAlNlAT0P0pA29Ss5D6it9yfbMBLQwqcobthY1JVuu+WeqGlN7YL49X+Mc9cQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753989655; c=relaxed/simple;
	bh=xrQDe2w04Cf8HA2gqmWbgFTVNuFYxRnQfjcVwMPXwps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qdogruiBOqHs129VlxAxI4+5I6/JFL2SL145Iqw0IsrzHrQgJAmuX0sXgs4QvKHgq9rQV2GHSUaKBBQ0O7ko8R+NNpQVDu7DAXSfkkXqjZFd6XtItXrEO48g/iaGmaqAZvhT5wd2YIm5OWQk0Gwi3LR3GZoAIbm5gRyCFIkTJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0IQhI0rn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0IQhI0rn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xrQDe2w04Cf8HA2gqmWbgFTVNuFYxRnQfjcVwMPXwps=; b=0IQhI0rnzE1VvE2OECHkm72AX/
	TrNcEqvgXMACcm9aljDpHy+n0QpYb98f8xGDcT/tXuhEhm9kdnd6iNwk2tpH+t5USIWDi9uxkCuV5
	Ek1aZH65/HNLets4GDhzaiUzZn40fhXaWkkqLjADDlJaTuSFO4oNyD16TWxm3+vB9awEfHUbcmrQH
	DYiwqnjg3LNGFkyqgI6bGpSYzdoQmvke9+y5oZLG6Pzg8KOFup4Nms7UsWyYskBUWlaphtI1DKdGJ
	H5LdL9bERlpaI803cHM/OjZ+JN5gKHOkidgFxHnu6E9mLP8j8PnnRc5y1Mpe46PEq6myDXF3Z88zN
	B8c4Zk7ANLww8pnhU3npoMdR+EDnwS3FswwONHVzkd+kBWUqQTxsjcYcQcS1f1RmOVKFzmerdbsVt
	vqdoz4tljI+LrqSOtml6fvULkpIQFh0bZQx+EqSr3u0W//BFXzcqwB78esyYVLb1KsRKg8rLHTO5h
	UY6Frz9yBNG5B67zGiH5oUDx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uhYpe-000PQn-1a;
	Thu, 31 Jul 2025 19:20:50 +0000
Message-ID: <08cbb023-7824-4319-bdf4-481013cff2a9@samba.org>
Date: Thu, 31 Jul 2025 21:20:48 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: Paulo Alcantara <pc@manguebit.org>,
 Matthew Richardson <m.richardson@ed.ac.uk>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>,
 Steve French <smfrench@gmail.com>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------4OsdJgWs9fSRLXdk0Q5P3ngk"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------4OsdJgWs9fSRLXdk0Q5P3ngk
Content-Type: multipart/mixed; boundary="------------8s1jYQEkqzuY2WB2oB980xTh";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Paulo Alcantara <pc@manguebit.org>,
 Matthew Richardson <m.richardson@ed.ac.uk>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <08cbb023-7824-4319-bdf4-481013cff2a9@samba.org>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
In-Reply-To: <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>

--------------8s1jYQEkqzuY2WB2oB980xTh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8zMS8yNSA3OjM3IFBNLCBQYXVsbyBBbGNhbnRhcmEgd3JvdGU6DQo+IEkgc2VlIGEg
cmVncmVzc2lvbiB3aGVuIGF0dGVtcHRpbmcgdG8gY3JlYXRlIHN5bWxpbmtzIGFuZCBzb2Nr
ZXRzLiAgTm90ZQ0KPiB0aGUgJ25hdGl2ZXNvY2tldCcgYW5kICdzeW1saW5rPXVuaXgnIG9w
dGlvbnMsIHdoaWNoIGFyZSBkZWZpbml0ZWx5DQo+IHdyb25nIGZvciBTTUIzLjEuMSBQT1NJ
WCBtb3VudHMuICBJdCBzaG91bGQgaGF2ZSAnc3ltbGluaz1uYXRpdmUnIGFuZA0KPiAnbm9u
YXRpdmVzb2NrZXQnLg0KDQphaGgsIHNvcnJ5LCBidXQgSSB3YXMga2luZCBvZiBleHBlY3Rp
bmcgdGhhdC4gVGhlcmUgYXJlIGp1c3QgdG9vIG1hbnkgDQpvcHRpb25zLg0KDQotc2xvdw0K


--------------8s1jYQEkqzuY2WB2oB980xTh--

--------------4OsdJgWs9fSRLXdk0Q5P3ngk
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiLwhAFAwAAAAAACgkQqh6bcSY5nkan
wQ/+NO/T/uHpf65r5P+R/gQXIsfn7a1yn6Dv5G8po5moTaw/BOCks+R79lF7vh1lTQHMgnA0zi1s
TIwNvwj3V6P7L++TSWyQlOs2QsUlcqnmiEWyun8tIOYGYO74I3mxlkSBl5uhoF47LA282up04mis
+eWeFjPd4qsfUFDGsdNUQuj8a33rGkh6uHRSrztR8n1LNG1VnrinlffIjvHLKdjpT1Gx4um1DQfF
gGsDj61+oFsksuc72ZwIocXsGB7rYe75RyROrYkvwIL8qaxaoWUDBrZaAP0RpW+IQ5O6k9EqhXwe
O9NzcvySKW7pWimKL93hogiMx77Y+Gbh0oHwIBolVUksgUeDWzafqWwRN9aF7+XrVqh4o7r/GwQF
bqmRYG9srcpa5/pc4FSgw5NAHhQnEQBPQIv/UWpJWINxIyexEi3ZJjuP/5kyJxvSE4L85SJzVPzx
H3Z8/D9frcCUP0DEQX929rl9r/Ew78MMBZ8kJaDoS9O3aBcJhbZChYGipKZbvrhOkH/IjNYS9naz
al3IS65nElsZDT1e27Q3mjutd9mgxIy2m2ogAbRqRFX8F+tXsbO0UkYNOaqeEWMrF27HIpx31jWC
TStnnqQXkwt3kXBuO1aQePkGnPYv7VkzdrLGA0UPWFDs14lSUw+le9ZIynfYhSn5GdOc+B3bDhv8
4QI=
=Oay6
-----END PGP SIGNATURE-----

--------------4OsdJgWs9fSRLXdk0Q5P3ngk--
