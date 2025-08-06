Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0892BE044
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 20:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510770; cv=none; b=VNjp/LaQaq3fj+J+Up9hdAw8XeXxHwVQs1hZsNgpcmd2EXgwTvkkFLGM4hVrCwrLTOU55nrIs6N4FhMxst2kEtkTkc++d0vkzMd64xOe3mJbBPRn2TmELIV8JA8rn2yKw1TidYJViPktHQCdievltwPfx9BAtphwijnLDv+QADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510770; c=relaxed/simple;
	bh=9DGQBug1ffOU4JXhgDH22q5PJWFemWT9zAOjpRJOa0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H2oBMo1tCpgnHx8xMzmPQhKeGqUK+LMSi2vE7cFqgwH7O/ejiAONgxn26cFE/9pQJ8kyCssaKH6lSyXdJwO7PP7qODkfU8Aixqj+CiF/lA3aUCdxdnPhFcv4M47GeNlkVrlH9SF5cH4xAvuTfluyZeuJBtJ5Q2fDHvf9kUxzIn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=yQCTG87Z; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yQCTG87Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=9DGQBug1ffOU4JXhgDH22q5PJWFemWT9zAOjpRJOa0k=; b=yQCTG87Z9ExKf5UZi1WkYh/rVd
	nTMVv4wwuCBHAskycCIRARZCW1mx/NvyqRtmJ3Auwxlk+e5ooc5Y5q/csfGKyoh4dQKW1PDiM9KC0
	ykZBMWsiUONwCw8n0TlPvTpmelE5jJEw17IWeSDe0j5mpVsS28aS05L2HRjlGOkXkcM0ofWeC//5R
	rJUY8VkSP2GYL2XyJ5mZxTJN2U649dMz02NZJBXbnlH/siiI6GkdvnNJijlWBTYUYRULl4VLrpPEl
	n7mZXskOjWGm5Ut1tEF4kWPVfr8TTscm7BF6Lyt/YO0zcGOYGWGzrvzlnrvJlzpvM5S4AzDamUZBX
	T+jpcqBwHbS4QZCJ/DY746cY8Q9ZWCmy7wmhWcJmsEaDrgz978pmosRzK8IzL02wH/Ur4c3RiYEUC
	R34BsaMReTFqPiQP0YxzaD5jYn6zcQlwn6SC9AryD7KKkPI4/g2tIXBNat7EnBYZDS1i6bZPjOn6a
	srme5gpomPC1YxERFJEA8fyE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujkOk-001QIw-01;
	Wed, 06 Aug 2025 20:06:06 +0000
Message-ID: <37ac126a-c241-4e1c-86d7-3669b8ad42ff@samba.org>
Date: Wed, 6 Aug 2025 22:06:04 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] Sequence of actions resulting in data loss
To: sorenson@redhat.com, Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
 <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
 <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
 <4f20c584-aa44-4c8f-a3bd-6a7d72abf5e2@redhat.com>
Content-Language: en-US, de-DE
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 xsFNBFRbb/sBEADGFqSo7Ya3S00RsDWC7O4esYxuo+J5PapFMKvFNiYvpNEAoHnoJkzT6bCG
 eZWlARe4Ihmry9XV67v/DUa3qXYihV62jmiTgCyEu1HFGhWGzkk99Vahq/2kVgN4vwz8zep1
 uvTAx4sgouL2Ri4HqeOdGveTQKQY4oOnWpEhXZ2qeCAc3fTHEB1FmRrZJp7A7y0C8/NEXnxT
 vfCZc7jsbanZAAUpQCGve+ilqn3px5Xo+1HZPnmfOrDODGo0qS/eJFnZ3aEy9y906I60fW27
 W+y++xX/8a1w76mi1nRGYQX7e8oAWshijPiM0X8hQNs91EW1TvUjvI7SiELEui0/OX/3cvR8
 kEEAmGlths99W+jigK15KbeWOO3OJdyCfY/Rimse4rJfVe41BdEF3J0z6YzaFQoJORXm0M8y
 O5OxpAZFYuhywfx8eCf4Cgzir7jFOKaDaRaFwlVRIOJwXlvidDuiKBfCcMzVafxn5wTyt/qy
 gcmvaHH/2qerqhfMI09kus0NfudYnbSjtpNcskecwJNEpo8BG9HVgwF9H/hiI9oh2BGBng7f
 bcz9sx2tGtQJpxKoBN91zuH0fWj7HYBX6FLnnD+m4ve2Avrg/H0Mk6pnvuTj5FxW5oqz9Dk1
 1HDrco3/+4hFVaCJezv8THsyU7MLc8V2WmZGYiaRanbEb2CoSQARAQABzR1SYWxwaCBCw7Zo
 bWUgPHNsb3dAc2FtYmEub3JnPsLBlwQTAQgAQQIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIX
 gAIZARYhBPrixgiKJCUgUcVZ5Koem3EmOZ5GBQJllYCkBQkU/N31AAoJEKoem3EmOZ5GlzsP
 +gKNsDpixJ4fzvrEnsItxZuJgMfrdBAz8frY2DBnz/k74sNlW0CfwwU2yRuoEgKiVHX5N24U
 W+iju9knJDUFKb/A5C+D9HbuGVeiuiS59JwHqBxhtGXUYOafXt5JE0LKNdPDtUrx41i6wXBJ
 qXwvT8+gvc86+hp4ZujygyUuR9If8HXWhH10aTiPVte3lTGZjrZsqhY+MASG+Qxipk2a1f85
 jDLbLndtrKbf89AGqx4SRPRYGtNrqR2rDhqySNVzR8SquNTdvKvnrUIJkNSmVMsB6OOQc+Lh
 9gz9hHG8MXjKq6dz7q0JZE7enD/gFeK2CWI1pTjkHVQ9qXqkT7nQdrs1net5IPgXgNFxCLjj
 93ipRMoGh0H8GLMuOWksnyB3Lq1KnyPb7RBV9Apo7juz/Cp8KYqvr0s50b3pblB2NmDTNcxZ
 CkVLhWMGF4bJQvG4SNxarDC5aIwV+KLgLo24gaKV4+ubgMkLzyNoS1Ko4//FesfN8dgIhI3g
 wTJtzQ8hoRthoZRdjsGtZsw9OFZSc6Pp9v+988lTYpdOzl3CGfPpKcNry9ybQ+1teQkaI0fs
 GvG6MLviuuZizBpmBVMY++SpejHuxCF55WmClkMi+4dki5AG0UvFDrwTVKtKxLG4JX5kPDa7
 R6ssRM0q8yPlBCWtotp7Wz0gM/ub50DS09KJzsFNBFRbb/sBEADCSnUsQShBPcAPJQH9DMQN
 nCO3tUZ32mx32S/WD5ykiVpeIxpEa2X/QpS8d5c8OUh5ALB4uTUgrQqczXhWUwGHPAV2PW0s
 /S4NUXsCs/Mdry2ANNk/mfSMtQMr6j2ptg/Mb79FZAqSeNbS81KcfsWPwhALgeImYUw3JoyY
 g1KWgROltG+LC32vnDDTotcU8yekg4bKZ3lekVODxk0doZl8mFvDTAiHFK9O5Y1azeJaSMFk
 NE/BNHsI/deDzGkiV9HhRwge7/e4l4uJI0dPtLpGNELPq7fty97OvjxUc9dRfQDQ9CUBzovg
 3rprpuxVNRktSpKAdaZzbTPLj8IcyKoFLQ+MqdaI7oak2Wr5dTCXldbByB0i4UweEyFs32WP
 NkJoGWq2P8zH9aKmc2wE7CHz7RyR7hE9m7NeGrUyqNKA8QpCEhoXHZvaJ6ko2aaTu1ej8KCs
 yR5xVsvRk90YzKiy+QAQKMg5JuJe92r7/uoRP/xT8yHDrgXLd2cDjeNeR5RLYi1/IrnqXuDi
 UPCs9/E7iTNyh3P0wh43jby8pJEUC5I3w200Do5cdQ4VGad7XeQBc3pEUmFc6FgwF7SVakJZ
 TvxkeL5FcE1On82rJqK6eSOIkV45pxTMvEuNyX8gs01A4BuReF06obg40o5P7bovlsog6NqZ
 oD+JDJWM0kdYZQARAQABwsGQBBgBCAAmAhsMFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmWV
 gKQFCRT83fUAHgkQqh6bcSY5nkYJEKoem3EmOZ5GCRCqHptxJjmeRsyXEACeaIATB75W1nxf
 rO55sGpNwXxfjqQhA2b57y3xQVL9lFOxJ+efy/CLajKxeWMct8WrI5RRcjxObO/csw/ux06F
 BblgnUrp48k9qfbK/ajTCeU9AHJlJF1lVEwVqk+vn7l7Hfos9dATTBq7NoaBgEje166nxWod
 T7TIu8wOjGw5KMevj5evbKQNcTMRITIp6U/YXB0n7Iw/wYPDlFSra4ds/W++ywTM9fzO+G71
 osmHwBHUlRYszF814qDbQwbv3IfdCWltzzbFE3P8t8u5lLkZt721o0i84qLNK7msmvQEP7eQ
 qleNwCHb9hxoGuMTCsgybNlj/igub2I/wLIodboej1WyV7Q/58Wh6k+32YvY5WU9BnFjp+Uv
 RdzAEfUQ7D8heklQxrnkkCv1IVkdI/S8jwDXWIJ/mwbx7hs2pf0v8S1+AWAi1d6xOYru1+ce
 5qlmemqxqvzIt1jOefbG2uApX0m7Y8njC8JW3kQWRh+bRra2NOdy7OYjU4idxn7EVZVHmSxX
 Bermm52f/BRm7Gl3ug8lfcuxselVCV68Qam6Q1IGwcr5XvLowbY1P/FrW+fj1b4J9IfES+a4
 /AC+Dps65h2qebPL72KNjf9vFilTzNNpng4Z4O72Yve5XT0hr2ISwHKGmkuKuK+iS9k7QfXD
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <4f20c584-aa44-4c8f-a3bd-6a7d72abf5e2@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Z01W3n5qvfp2KqZVB8aPQ26y"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Z01W3n5qvfp2KqZVB8aPQ26y
Content-Type: multipart/mixed; boundary="------------QKA5qN6P661HM0Ur4UULMr25";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: sorenson@redhat.com, Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <37ac126a-c241-4e1c-86d7-3669b8ad42ff@samba.org>
Subject: Re: [Samba] Sequence of actions resulting in data loss
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
 <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
 <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
 <4f20c584-aa44-4c8f-a3bd-6a7d72abf5e2@redhat.com>
In-Reply-To: <4f20c584-aa44-4c8f-a3bd-6a7d72abf5e2@redhat.com>

--------------QKA5qN6P661HM0Ur4UULMr25
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOC82LzI1IDk6NDggUE0sIEZyYW5rIFNvcmVuc29uIHdyb3RlOg0KPj4gSWYgSSB1bmRl
cnN0YW5kIGNvcnJlY3RseSwgU01CIGhhcyBubyBhdG9taWMgb3BlcmF0aW9uIHRvIHJlcGxh
Y2UvDQo+IG92ZXJ3cml0ZSBhIGZpbGUgdGhyb3VnaCBhIFNldEluZm8gRklMRV9JTkZPL1NN
QjJfRklMRV9SRU5BTUVfSU5GTyANCj4gb3BlcmF0aW9uLA0KDQppdCBoYXMuDQoNCj4gc28g
aXQncyBhY2NvbXBsaXNoZWQgYnkgdGhlIHR3by1zdGVwIHByb2Nlc3Mgb2YgMSkgcmVtb3Zp
bmcgdGhlIA0KPiB0YXJnZXQgZmlsZTsgYW5kIDIpIHJlbmFtaW5nIHRoZSBzb3VyY2UgZmls
ZW5hbWUgdG8gdGhlIHRhcmdldCANCj4gZmlsZW5hbWUuDQoNCm5vLiBUaGlzIGlzIG5vdCBu
ZWVkZWQuDQoNCi1zbG93DQoNCi0tIA0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCBodHRwczov
L3Nlcm5ldC5kZS8NClNhbWJhIFRlYW0gTWVtYmVyICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcv
DQpTYW1iYSBTdXBwb3J0IGFuZCBEZXYgIGh0dHBzOi8vc2FtYmEucGx1cy9zZXJ2aWNlcy8N
ClNBTUJBKyBwYWNrYWdlcyAgICAgICAgaHR0cHM6Ly9zYW1iYS5wbHVzL3Byb2R1Y3RzL3Nh
bWJhDQo=

--------------QKA5qN6P661HM0Ur4UULMr25--

--------------Z01W3n5qvfp2KqZVB8aPQ26y
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmiTtawFAwAAAAAACgkQqh6bcSY5nkby
Ig//TKLOJ9yrEF13tY+akb9EpZImItQ0O2gJUaaW+QnmZKzX0iOyK5qVK/L+wSIvza6ryn5AAD+H
FpzViMSAS5Rl2/4B57mtQ6i6WasPxMgHAEyFgLCUvW8ejp+hLAGNPIrEu+6IhhWHNL8a7viLoF1U
m0S6Cc4fyqeLWPt1vfIjd7RX4l2I/wZVV/KQohI/p37y5QjK96jOe89XtSWv9+a6tC65HLt3a4+O
ZidSO9gUSMfd9raKlunWhLTlDdlzcea++r4f964r/4/RcnXYTqcmV05KpXxyY47hKy/yFdrcBB90
w2k6qmra3bleeOgjkYV0n8xlZSaWMTV1WD5GgxFCmYv/NBM0cJOr9lGJfjyKg1CCPIWMW8djxupA
i7N+3o9LlFkINMNPh2sN3sepUs41275hYafc58cVDetbtC7Jjx1K1gqKQcRW+/XXe6U0kGQ2dgax
geCkk2a7cw4hh3MNk0IPbE+plwpXrGFV3/vhEJLabQEM8E+d+08g6n74ABV20tEUakHQst+aAFPD
BlMg7nNpvUZrzvpD4Yz+NEBSnPp/LBUtc9JqXCcaGXUKoG8iRyKGqRxTHgykRAUoQr0ElsdtDSJL
qAbOJVry0b3sqJ5RQcd0RoEyxoh97L5JhkQLv3hDAiTECaNhNfA90nzmwV5DkuL683vB2d91WJaL
bdA=
=vqj5
-----END PGP SIGNATURE-----

--------------Z01W3n5qvfp2KqZVB8aPQ26y--
