Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455F184D15
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 16:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714409084; cv=none; b=NLHer7KNmdNWebiz5CWV3k0qkeWFfUA8O22wB6WkKKcB5tsfLvrz+OHrMQCUxxRKVJdL/kM9jgUQkuU6sVq5ioyuqFHE5eS8Z4IHvfC/Edj8yRjgTlWv/eWJeGmlM8ryaD/MBGlU4xcqbbftd+rIVzVQA++XPmZ3iC3zTUHlpKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714409084; c=relaxed/simple;
	bh=SVy0R4ZEvep0aD/IuUJ9sPgMskcH3sXlnbrUJ5vdxys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DYBcTCLbJr1CXlZuhZMyejf5tCirpDPWBShZb3/talXk+ADF6ZGpitz6CJm7t+L5R59GkncPTGnCiIdyeVKgyeO1kigFaRP2YzKiGm7fBRJqGl/I+sWcUSg6vE8TAxZvzmzhKzraB2yFWITvXdEmBQa4l3pBrOz/JH28riAADwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=n2j7deng; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="n2j7deng"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=SVy0R4ZEvep0aD/IuUJ9sPgMskcH3sXlnbrUJ5vdxys=; b=n2j7dengqDoLnvBZEN3uVU9yPU
	ALrZ/llPjJk+ZXqorGzk//lAWNt7NsPuRl3zn9/jMTQGtJFlrBFDtF6KCY48MembZ1MwslBYfpGRy
	hMZggj7iI9r/eFeeray9nR3vGRSIf5MqM0sJyvnJ3p+95zY6rTODW0pCVXX3IIX0KR7canKSTQok0
	xnxHLdVoM81M7bBLVsbI3+evuBg/JM9l4HgGigoe+ZwLAAoHH2WyR01vrbR1HfRDF57f1GIMDbNmz
	9rs3O+u7pYVN0MS53okXkigaoANP0GvPsdKMNBX77KeblVnqbHsW6KikU4fr7ZPjiv8V4Osd1k9LF
	nKYjJWCHgDtxJQLwhHj5MkaW7kB0MRQPiQB1oiKKL6e9kEQvyC0UleqCemneO1ayNbsCdIQ+6ueeM
	ZX4R0MPdCmBzjSWzEQrTNFc5w9jQmSyXCo3ma+iHbJbbHrbGyB3hRZ8C0I2eKXG9jsFY4z2ishP7S
	jGFP3Pdtx0jOK9ljZCiqLYtW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1U7L-008y3b-2z;
	Mon, 29 Apr 2024 16:44:40 +0000
Message-ID: <83480311-74b1-4ee6-be85-5b21b0f55ee9@samba.org>
Date: Mon, 29 Apr 2024 18:44:39 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: query fs info level 0x100
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
 <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
 <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HU5CWFqdUnTCCbO3V00Q5gdn"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HU5CWFqdUnTCCbO3V00Q5gdn
Content-Type: multipart/mixed; boundary="------------g0Vb3TZS9MUhuVFhz60on7kd";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: samba-technical <samba-technical@lists.samba.org>,
 Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Message-ID: <83480311-74b1-4ee6-be85-5b21b0f55ee9@samba.org>
Subject: Re: query fs info level 0x100
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
 <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
 <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
In-Reply-To: <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
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

--------------g0Vb3TZS9MUhuVFhz60on7kd
Content-Type: multipart/mixed; boundary="------------ydXWauukc0iw0g91eqtIsoyh"

--------------ydXWauukc0iw0g91eqtIsoyh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNC8yOS8yNCA2OjEzIFBNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IEJ1dCB0aGUgKGN1
cnJlbnQgU2FtYmEpIHNlcnZlciBmYWlscyB0aGUgbGV2ZWwgMTAwIChsZXZlbCAweDY0IGlu
IGhleCkNCj4gRlNfUE9TSVhfSU5GTyB3aXRoICJTVEFUVVNfSU5WQUxJRF9FUlJPUl9DTEFT
UyINCj4gd2hpY2ggY2F1c2VzIGFsbCB4ZnN0ZXN0cyB0byBicmVhayBzaW5jZSB0aGV5IGNh
bid0IHZlcmlmeSB0aGUgbW91bnQNCj4gKGUuZy4gd2l0aCAic3RhdCAtZiIpLg0KPiBOb3Ro
aW5nIHJlbGF0ZWQgdG8gdGhpcyBvbiB0aGUgY2xpZW50IGhhcyBjaGFuZ2VkLCBhbmQga3Nt
YmQgaGFzDQo+IGFsd2F5cyBzdXBwb3J0ZWQgdGhpcyBzbyB3b3JrcyBmaW5lIHRoZXJlLg0K
DQphaCwgSSBicm9rZSBpdC4gRml4IGF0dGFjaGVkLiBSZWFsbHkgZW1iYXJyYXNzaW5nLi4u
DQoNCi1zbG93DQoNCg==
--------------ydXWauukc0iw0g91eqtIsoyh
Content-Type: text/x-patch; charset=UTF-8; name="bug15639-master.patch"
Content-Disposition: attachment; filename="bug15639-master.patch"
Content-Transfer-Encoding: base64

RnJvbSAzODYyNTYzNTgyNjgzZjg2YTFmZDVkMjU0MjJiMzEzN2YxYjA1MTQxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBSYWxwaCBCb2VobWUgPHNsb3dAc2FtYmEub3JnPgpE
YXRlOiBNb24sIDI5IEFwciAyMDI0IDE4OjM4OjEwICswMjAwClN1YmplY3Q6IFtQQVRDSF0g
c21iZDogU01CMyBQT1NJWCBFeHRlbnNpb25zIHN0YXRmcygpIGlzIGJyb2tlbgoKUmVncmVz
c2lvbiBpbnRyb2R1Y2VkIGJ5IDU1ZDk4YjI5ZWIyOTQ1NDJjYzQ5NDc1NzNmMjMzZTBkNWU2
OTY2Y2IuIEQnb2ghCgpCVUc6IGh0dHBzOi8vYnVnemlsbGEuc2FtYmEub3JnL3Nob3dfYnVn
LmNnaT9pZD0xNTYzOQoKU2lnbmVkLW9mZi1ieTogUmFscGggQm9laG1lIDxzbG93QHNhbWJh
Lm9yZz4KLS0tCiBzb3VyY2UzL3NtYmQvc21iMl90cmFuczIuYyB8IDIgKy0KIDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3Nv
dXJjZTMvc21iZC9zbWIyX3RyYW5zMi5jIGIvc291cmNlMy9zbWJkL3NtYjJfdHJhbnMyLmMK
aW5kZXggNTE5OGEwNGE3NGM2Li44ZTEyMjAyNWQyODMgMTAwNjQ0Ci0tLSBhL3NvdXJjZTMv
c21iZC9zbWIyX3RyYW5zMi5jCisrKyBiL3NvdXJjZTMvc21iZC9zbWIyX3RyYW5zMi5jCkBA
IC0xOTkxLDcgKzE5OTEsNyBAQCBzdGF0aWMgYm9vbCBmc2luZm9fdW5peF92YWxpZF9sZXZl
bChjb25uZWN0aW9uX3N0cnVjdCAqY29ubiwKIAkJCQkgICAgdWludDE2X3QgaW5mb19sZXZl
bCkKIHsKIAlpZiAoY29ubl91c2luZ19zbWIyKGNvbm4tPnNjb25uKSAmJgotCSAgICBmc3At
PnBvc2l4X2ZsYWdzID09IEZTUF9QT1NJWF9GTEFHU19PUEVOICYmCisJICAgIChmc3AtPnBv
c2l4X2ZsYWdzICYgRlNQX1BPU0lYX0ZMQUdTX09QRU4pICYmCiAJICAgIGluZm9fbGV2ZWwg
PT0gU01CMl9GU19QT1NJWF9JTkZPUk1BVElPTl9JTlRFUk5BTCkKIAl7CiAJCXJldHVybiB0
cnVlOwotLSAKMi40NC4wCgo=

--------------ydXWauukc0iw0g91eqtIsoyh--

--------------g0Vb3TZS9MUhuVFhz60on7kd--

--------------HU5CWFqdUnTCCbO3V00Q5gdn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmYvzncFAwAAAAAACgkQqh6bcSY5nkbs
0w/9Gm6MW/V42B9hl+l//kepsNewHn1vGHjEhT9C5y64gvkbxikohJV4vz3UR51hOHz7fqfzr4R4
Nh/nBxoNqTr3jYZt5mznvDSg3esvwujC2PM2Qvxgj79MhdezrY3w0SmXXgmGen9n6Y53GCFuYXFw
qpQykD4V7xcEP8X1xx1oDFh0lkuBUVtd5lP2Ddr8QdVTEuO/K2+RN6YJTF1rkxgRVWw2iOjMoWXE
hVUiO/KwKbMFDdA1Vs0Wh3pAGWf923Awbf9trj+5jubN3LXXknFclca8NlhA8qDlFEF5nAxBBOrb
iCwgWXvvjehF7HSX/zUqhZjZOEyxVcURTV5sSv1roaCx7fHHT38eV1NfKn/nPg5rM1+A/Ck+yRsH
AyqTb1BGLFuyF3ov9kshrjlj+OHPhp6O6Qlt/KRSHdzyV+W4GdZd6IgRqm5mRhvA4VUgo2AgsdM6
R7aGWwSRwtCmw22LLrbOPga/fA1ue4E4yDh3XBPGMwFO7va9ZOm0TPtz/rupp4a8A+quo+Imdj0Z
sv87IGylfwgXURWUNBgoPPCAQtGtN8Kaj0vUiABkRJfHvQucXfbXE8LI+37kAXYLRZTpTK50AUh2
3CBySKqZJJtiUT0qJ01SE5SKNHAABvQ25GIESoKpnu22U2z0VwohylsAiPL08h+oijAvG48qXua2
WY4=
=xYkB
-----END PGP SIGNATURE-----

--------------HU5CWFqdUnTCCbO3V00Q5gdn--
