Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E0715A84E
	for <linux-cifs@vger.kernel.org>; Mon, 11 Nov 2024 14:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731335490; cv=none; b=BCWShP6PnlRSaq5GqwWV5dDKgQ4x2jfbnwJJsGn7Zm5sr6D9OcAtFXxXJM9vMsiom8plaLucb7O/KgjYHcShowf1f3OG2HbvAnOzMaY5zWDbkij1LBeWliqZ4aiX2Kf/sUWdxkFCF4m2By8wVktAtKYkE9XVgBCHwpp64ZA2Ce0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731335490; c=relaxed/simple;
	bh=4GUlfCMxQKnfsAfjR39tVWKQ8fYrxUAQD6kjwrMtjLM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GD5edYWl814LODsEvJTGyexm0MFN7vRm0erupAaZRfWK/JX8QiM6u6/iq7yvS8tfVGJzF13NAYJiZiBsulsX0ZP1o4mNUz8YnZEWP8B9/ygXymVGacNFIFQ515c6K3ExMR4J5MjgWlnVPKgFntmTeziw6V3KzleiWDkOvIf1sgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bVrks/JI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bVrks/JI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=4GUlfCMxQKnfsAfjR39tVWKQ8fYrxUAQD6kjwrMtjLM=; b=bVrks/JITS88Dk/viO1UPAUBpK
	aanUi3WpoDLkhXOSXDztSTJYP+aK87OYeL3BIRFWH0VDSyO+qG84kqo9NqEztz9Fqdx8wjnlgjUJF
	W7F6R+uX+ipE0DCbdpmaEhoF32yeU6u9lwiPNV1A7pVJZq+dlwh4M2HI9jvWkhYKOqSWgX64UCtMN
	pTqFBIhtzLew3FFE+dCRpOYDqFE88rQlNx9matZgCNW4OY9APqKDIDulfDJC5d0Setiiwn/O9gp8/
	wdtfmdgHgNIsjl0sLPsw+pl7nqcaq5VJI+LXGYCxYqzlfCm2yb8oL81p2CAokdTHSTn6I1se+nnCM
	6T7K73CzStt6IkNk2VUY+h+bIO2bt/fXjdMTS6/k5egE8voAL22vhk9zIAmwJ/5fGv+rmESYIXM+l
	bD8Opjr2UWFlzINRzk5EWuJ1tKLzAQUrODYvGDCZV57Nf8JrOKt7aBeis8RQxM9twO5XDbxJRrAt1
	WtZCkwpU/hOFB1X3UGjsLiXK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tAVRt-00A3q3-1S;
	Mon, 11 Nov 2024 14:31:25 +0000
Message-ID: <a5b250c9-8f69-4a48-86cb-f5347dfc4a2e@samba.org>
Date: Mon, 11 Nov 2024 15:31:24 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
From: Ralph Boehme <slow@samba.org>
To: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Jeremy Allison <jra@samba.org>,
 Volker Lendecke <Volker.Lendecke@SerNet.DE>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
 <2eb2e4fa-1e74-46d4-a399-0200dd08e348@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <2eb2e4fa-1e74-46d4-a399-0200dd08e348@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0ozO4QW0RhLvr5txCpT9QreH"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0ozO4QW0RhLvr5txCpT9QreH
Content-Type: multipart/mixed; boundary="------------UBshE0RYAoyBn22aQQ6nh0vv";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Jeremy Allison <jra@samba.org>,
 Volker Lendecke <Volker.Lendecke@SerNet.DE>
Message-ID: <a5b250c9-8f69-4a48-86cb-f5347dfc4a2e@samba.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE on
 copy_chunk
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <c146a052-40e2-4d90-9a8e-9236a0b2dc20@samba.org>
 <2eb2e4fa-1e74-46d4-a399-0200dd08e348@samba.org>
In-Reply-To: <2eb2e4fa-1e74-46d4-a399-0200dd08e348@samba.org>
Autocrypt-Gossip: addr=jra@samba.org; keydata=
 xsDiBDxEcLsRBADMQzpWoVuu4oiq23q5AfZDbakENMP/8ZU+AnzqzGr70lIEJb2jfcudViUT
 97+RmXptlnDmE4/ILOf6w0udMlQ9Jpm+iqxbr35D/6qvFgrgE+PnNAPlKSlI2fyGuLhpv1QP
 forHV13gB3B6S/ZWHpf/owKnJMwu8ozQpjnMnqOiVwCg8QnSX2AFCMd3HLQsqVaMdlO+jBEE
 AKrMu2Pavmyc/eoNfrjgeRoNRkwHCINWO5u93o92dngWK/hN1QOOCQfAzqZ1JwS5Q+E2gGug
 4OVaZI1vZGsAzb06TSnS4fmrOfwHqltSDsCHhwd+pyWkIvi96Swx00e1NEwNExEBo5NrGunf
 fONGlfRc+WhMLIk0u2e2V14R+ebDA/42T+cQZtUR6EdBReHVpmckQXXcE8cIqsu6UpZCsdEP
 N6YjxQKgTKWQWoxE2k4lYl9KsDK1BaF6rLNz/yt2RAVb1qZVaOqpITZWwzykzH60dMaX/G1S
 GWuN28by9ghI2LIsxcXHiDhG2CZxyfogBDDXoTPXlVMdk55IwAJny8Wj4s0eSmVyZW15IEFs
 bGlzb24gPGpyYUBzYW1iYS5vcmc+wlcEExECABcFAjxEcLsFCwcKAwQDFQMCAxYCAQIXgAAK
 CRCl3XhJ1sA2rDHZAKDwxfxpGuCOAuDHaN3ULDrIzKw9DQCdHb3Sq5WKfeqeaY2ZKXT3AmXl
 Fq7OwE0EPERwvhAEAIY1K5TICtxmFOeoRMW39jtF8DNSXl/se6HBe3Wy5Cz43lMZ6NvjDATa
 1w3JlkmjUyIDP29ApqmMu78Tv4UUxAh1PhyTttX1/aorTlIdVYFjey/yW4mSDXUBhPvMpq52
 TncLRmK9HC6mIxJqS0vi6W9IqGOqDRZph3GzVzJN7WvLAAMGA/sGAyg2rVsBzs77WH0jPO+A
 QZDj+Hf/RFHOwmcyG7/XgmV6LOcQP4HfQHH3DGYihu5cZj3BeWKPDJnjOjB2qmr+FTjYEsjw
 LDBNG7rjRye412rUbNwmEtcD2/dw4xNyu5h2u+1++KVBPf4SqG/a10gDqGJXDHA1Os5MmnQl
 3CTq9sJGBBgRAgAGBQI8RHC+AAoJEKXdeEnWwDasbeIAoL6+EsZKAYrZ2w22A6V67tRNGOIe
 AJ0cV9+pk/vqEgbv8ipKU4iniZclhg==

--------------UBshE0RYAoyBn22aQQ6nh0vv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEvOS8yNCA1OjE4IFBNLCBSYWxwaCBCb2VobWUgd3JvdGU6DQo+IE9uIDExLzkvMjQg
NDoyNiBQTSwgUmFscGggQm9laG1lIHdyb3RlOg0KPj4gT24gMTAvOS8yNCA5OjQzIFBNLCBK
ZXJlbXkgQWxsaXNvbiB3cm90ZToNCj4+PiBDYW4gd2UganVzdCBtYXAgKGFjY2Vzc19tYXNr
IChGSUxFX0FQUEVORF9EQVRBfFNZTkNIUk9OSVpFKSkgPT0gDQo+Pj4gKEZJTEVfQVBQRU5E
X0RBVEF8U1lOQ0hST05JWkUpKQ0KPj4+IHRvIE9fQVBQRU5ELCByZWdhcmRsZXNzIG9mIFBP
U0lYIG1vZGUgPw0KPj4NCj4+IHRoaW5raW5nIGFib3V0IHRoaXMgYSBiaXQgbW9yZSwgdGhp
cyBzZWVtcyBkb2FibGUsIGFsYmVpdCBvbmx5IGZvciANCj4+IFBPU0lYIG1vZGUuIEZvciBu
b24tUE9TSVggbW9kZSB3ZSBjb3VsZCBwb3RlbnRpYWxseSBicmVhayBXSW5kb3dzIA0KPj4g
YXBwbGljYXRpb24gdGhhdCBvcGVuIG9ubHkgd2l0aCBGSUxFX0FQUEVORF9EQVRBOiBJIGNo
ZWNrZWQgd2l0aCBhIA0KPj4gdG9ydHVyZSB0ZXN0IHRoYXQgV2luZG93cyBkb2Vzbid0IGVu
Zm9yY2UgYXBwZW5kIGJlaGF2aW91ciBmb3IgDQo+PiBGSUxFX0FQUEVORF9EQVRBfFNZTkNI
Uk9OSVpFLg0KPj4NCj4+IEZvciBQT1NJWCBvcGVucyB3ZSBzaG91bGQgYWxzbyBhbGxvdyBj
b21iaW5hdGlvbnMgbGlrZSANCj4+IEZJTEVfUkVBRF9BVFRSSUJVVEVTfEZJTEVfQVBQRU5E
X0RBVEEgdG8gbWFwIHRvIE9fQVBQRU5ELCBzbyBjbGllbnRzIA0KPj4gY2FuIHdyaXRlIGlu
IGFwcGVuZCBtb2RlIHRvIHRoZSBoYW5kbGUgYW5kIHN0aWxsIGFyZSBhYmxlIHRvIGZzdGF0
KCkgaXQuDQo+Pg0KPj4gaHR0cHM6Ly9naXRsYWIuY29tL3NhbWJhLXRlYW0vc2FtYmEvLS9t
ZXJnZV9yZXF1ZXN0cy8zODYzDQo+IA0KPiBvaCwgZm9yZ290IHRvIG1lbnRpb24gdGhhdCB0
aGlzIGZpeGVzIHRoZSBmYWlsaW5nIGNvcHlfY2h1bmsgY29weSBmcm9tIA0KPiB0aGUgTGlu
dXgga2VybmVsIGNsaWVudCBpbiBwb3NpeCBtb2RlLg0KDQphbHNvIGFkZGVkIGEgdGVzdCBm
b3IgdGhhdC4NCg0KLXNsb3cNCg==

--------------UBshE0RYAoyBn22aQQ6nh0vv--

--------------0ozO4QW0RhLvr5txCpT9QreH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmcyFTwFAwAAAAAACgkQqh6bcSY5nkYi
cg//ZmjO9kRk4x5b/LQOeyquasW0WyySe+NdGb7vKEj84yn8FZwuy6SDFailEu+4G9mUFC3m6nQk
uiVG4xV/nBIFi6gQd0Dqd3N1e64XHCJde6rMaqT8LGGWAnkTAIpd3JGddHEWf1Mt2jN4ia1N3WdI
2E6NiioLFqn7B1E8WjyRqz0mtEksnRChoPSuhWqfg14OosaT6RKvpPUNfiDvGqad6jl9gqiPTIyh
nWNyh8RY9Fu/KCT8Sx9585pv713l8p49XZmB33FTMgNeZC0HDSJxdqdCU1qWooMnS8aVJiVJran4
ftlayfNi4qK5CVxr3DP4mloA6wpMOjYe9bnSfEPL994NLbE9Rvog9jhBSNiLagoq0cooAW91PyaP
P1TDhLfny+wJ9PU28EfXSPR+WuO3EaAAqNng+If/CClg75BnnL7OCIRViYMWc65yXNTdkGdycJZD
xj1fTPSi6SskO1QdCdMScZ20LX31BITTqlmyDOR4D76fG1XY4JjDqlkKTNeXQaCBT8558JNr7X2t
4xs+mN4/5U/+8cyb9CdptPH9l6VJ6ykSBjZml3Z93th2HsJ45bZBYrYtMlfbOsLT9qCTSCD0u2xU
/Fjg3Dt5Gwek1dBijJh6B/EyAcbnVIjLaCPOwaXy4G2iyJOgRUWWtzIgBwTj3b3lGeQmYd4fnwx/
v7g=
=K+Rz
-----END PGP SIGNATURE-----

--------------0ozO4QW0RhLvr5txCpT9QreH--
