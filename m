Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD2B2868AB
	for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785074371; cv=none; b=quxGputC16k3cyfqT15qXyBKH4juq50UfdBiVonhAn8cPUjT1HHYyGHjXhx+zj1g7O6P+47HPEDIK8UeEUo7IBDT4vrtuL8h8DZIK/7E+45Ez+kIL4lus9pUgkBnqltUXwxttK7Nvj9SAjyY0SvZWDZFdLSUduIb+iL1geparCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785074371; c=relaxed/simple;
	bh=hivISCGaRFdnAupaSSmr+YWtC/tBMxTRrtYq8eOwZKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=osB10EuifM0/U4CsEq75STkqLAhjEtQZwyUusfLEqZURzn2jqqzP6HVbqKBHx74oIHSpqJ2lcps/93cUcvvVNkqtjrJENVsmFDLC4aWkvACOdYKE3gdPT4oi+WZIs5O01mAvkTq9/v3QXt6ZkynsnIR+ElX08fQN5hh2CYkdMvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=x9GCM5hy; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="x9GCM5hy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=hivISCGaRFdnAupaSSmr+YWtC/tBMxTRrtYq8eOwZKc=; b=x9GCM5hy6vzNmR/qJkhW9uPT+M
	q/iLHMMwY36tgEA1W77oNF/3wE1JdR94YW83q5P8Z/cLjsZN1hGl4F9A2MdErw0sDLfm2OIOON8Ft
	lKuGduwlrE3SGxNtICWHp0OdcjSRvs7I2CUU7EfUBdnzEFLGxIaNC2zYZllngRGPdMEHBVsm9JB2O
	M2N0Qd7iqJlIoEH9+8M8C+m9U4WCHs7c1k2YShGXYB9fk7PZJQd90S+xQge9PUdPXcXyAJY+0j7/U
	ZGECMDpXCFTBDB8gtbVEQu4SkDWve7uBBdpzTXAEkK11nQqA8yMzkmyNso/pxHGEz2YFrhhy0g1Hb
	sMEf/ep6KhfYg86ken0IzWSGvW8Dl33nf1gK1h+UA2oYa1RtcqOh34NHME41VUAD5RrbnOf85J5wI
	Y6SCW0TNYxbrtjqFxz2opf2UJIy0TpTls+NyOQD2GujwwYYGENL6yRnXw/BOt/jzB02MU5vxpKKD8
	M7cROuxDsFcSvCUtCQ29LaHr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wnzNu-00000000W5I-2rj8;
	Sun, 26 Jul 2026 13:59:19 +0000
Message-ID: <8356a15c-5ad7-4f98-a8fd-01d6aa4e2dec@samba.org>
Date: Sun, 26 Jul 2026 15:59:14 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: tanze <tanze@kylinos.cn>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
 "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <d680a27a-49f2-4214-8ad1-5718c95ed4f6@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
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
 gAIZARYhBPrixgiKJCUgUcVZ5Koem3EmOZ5GBQJo+I8JBQkYXvllAAoJEKoem3EmOZ5GdQoP
 /2BPMBZZCddHoXlJu++OPOf9Rk6TuYN3Pntq2LfhPsFEdNHrMCV0KSNY993cQBRFrn6HbvLD
 NazKxDR9U1kSAXoopKyk2M3qpJ6kRvekqriCY04sOZ/iHk75Vmn5bp/Q3/9f3+40ZC4e0hF1
 XNMLyunGtCoxOWfDViax+qemDVwJvamMNx7kQXYe5SMtH7Gpi2DiGAq41g+93xKj/pS9WEo3
 5+d5zm2KEofaBQU4iecWA3H8U2OIh3kFJeiV4HDfVxkP5INcPNyP+bckpei4Nd3BczKN6I1q
 dAjdn/wmwGAlGpnSjjrYYKFKO3lHbBwm95Lv2rlpzqiBfIizXn656LsG0PQIslO6e5u9wwiR
 JOMlYBPmE/PwUPJkTiBSup8j1hFmyTqXYMzAjxGJ+MBkJ+QYCRSP8uMRvgiLY5+1h/C3dJBh
 lvRUW97qC/g+nji3CRXJRKHrmxmEy1E7u1HCZsrLhGCIKZqTZxdu3vEsFh/pd9XE9OoXlC9y
 x61umA92rIgOYU93/d4emsAIjvtxDmx/h2kuj5D1moFkAyLp2wnKPLJGeyXQc2WSbBJHlc4k
 iDPAFVWj0a8SlTagXtnmIQ+jG6QLvGdIbotpxnfrXTRKOqxDU5Fb9t40zNA4AnRjV/wYtvm7
 ps1qn9AfKACW6GcCX1jkLJQtLNXfi0WBIXixzsFNBFRbb/sBEADCSnUsQShBPcAPJQH9DMQN
 nCO3tUZ32mx32S/WD5ykiVpeIxpEa2X/QpS8d5c8OUh5ALB4uTUgrQqczXhWUwGHPAV2PW0s
 /S4NUXsCs/Mdry2ANNk/mfSMtQMr6j2ptg/Mb79FZAqSeNbS81KcfsWPwhALgeImYUw3JoyY
 g1KWgROltG+LC32vnDDTotcU8yekg4bKZ3lekVODxk0doZl8mFvDTAiHFK9O5Y1azeJaSMFk
 NE/BNHsI/deDzGkiV9HhRwge7/e4l4uJI0dPtLpGNELPq7fty97OvjxUc9dRfQDQ9CUBzovg
 3rprpuxVNRktSpKAdaZzbTPLj8IcyKoFLQ+MqdaI7oak2Wr5dTCXldbByB0i4UweEyFs32WP
 NkJoGWq2P8zH9aKmc2wE7CHz7RyR7hE9m7NeGrUyqNKA8QpCEhoXHZvaJ6ko2aaTu1ej8KCs
 yR5xVsvRk90YzKiy+QAQKMg5JuJe92r7/uoRP/xT8yHDrgXLd2cDjeNeR5RLYi1/IrnqXuDi
 UPCs9/E7iTNyh3P0wh43jby8pJEUC5I3w200Do5cdQ4VGad7XeQBc3pEUmFc6FgwF7SVakJZ
 TvxkeL5FcE1On82rJqK6eSOIkV45pxTMvEuNyX8gs01A4BuReF06obg40o5P7bovlsog6NqZ
 oD+JDJWM0kdYZQARAQABwsGQBBgBCAAmAhsMFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmj4
 jwkFCRhe+WUAHgkQqh6bcSY5nkYJEKoem3EmOZ5GCRCqHptxJjmeRq7xEADDqdSBTnLC68Vr
 tq6Qum4LjdXmfsZjVr/JSgUCe89jrOaofycpddHBMP9ORk1UzPLJSZbO5N7gvwJTDK+ZBxtB
 9yP5DtIhgzJZamb6m8h3cthyn/8RG3h+Fk5pXq6wtH12ZerHJ8XVNd0CCH2GxF8oVB3csGWh
 nrBt8maGYk7x0/wZK2ErylsohEiSCAA9aPJyhM5kafnk/6ov5bbc5bxqbnaI+jpwzZXeGT/v
 ACyWKv6cAmWepuexlQVsH/s9JchzVgasD7YWwGHszZwyMqLZi7XeOTz0pg0JKFGLlfsNYSpc
 LVhBztTc9vg5Uf/lFhObHkhXv/7ootSNOtll98/2Bk1qLW9rKQsnc5IR01AuNGCJNDuaBNfX
 IHd7AHUW6xUVUWOCBtyMCCyOdbOiDFlMzF8GvR4kCUuRh66CUvl+EYCUOnwr551f6rq4sJga
 Wqn2Ta8+lozMNjMkqri6QV7fyJQCryCv2/cI0q5IVUTPIzB0xfFCkgOX4vz8Te7ou7bkS5L2
 PgCGx2XZ0ICO1zdh1OafQXZcI0ZKA/+ZmMt7rFcf8cdjwJ3qRKtScUYhxq2N9wL3fQJNQPvK
 TXc80T2QVqV/yS3gZ4UmqYaBcMIoAyQWu8vbJnt6vCnf33g5sko3H8vbfpFW2TgesM6tyK1W
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <d680a27a-49f2-4214-8ad1-5718c95ed4f6@kylinos.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TCA3D5iI9O0YydcvQZYYTS0U"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TCA3D5iI9O0YydcvQZYYTS0U
Content-Type: multipart/mixed; boundary="------------YMaORxDbfPW3L1D8b12s2Ifl";
 protected-headers="v1"; hp="clear"
Message-ID: <8356a15c-5ad7-4f98-a8fd-01d6aa4e2dec@samba.org>
Date: Sun, 26 Jul 2026 15:59:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: tanze <tanze@kylinos.cn>
Cc: Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.org>, Jeremy Allison <jra@samba.org>,
 tom@talpey.com, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
 "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <d680a27a-49f2-4214-8ad1-5718c95ed4f6@kylinos.cn>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <d680a27a-49f2-4214-8ad1-5718c95ed4f6@kylinos.cn>

--------------YMaORxDbfPW3L1D8b12s2Ifl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8yNS8yNiAxMDo0NyBBTSwgdGFuemUgd3JvdGU6DQo+IEkgY29tcGxldGVseSBhZ3Jl
ZSB3aXRoIHlvdS4gVXBkYXRpbmcgdGhlIHByb3RvY29sIHdvdWxkIG1ha2UgdGhlIHJ1bGVz
IA0KPiBjbGVhcmVyIGFuZCB0aGUgY29kZSBzaW1wbGVyLg0KDQpkcmFmdDoNCg0KPGh0dHBz
Oi8vZ2l0bGFiLmNvbS9zbWIzLXBvc2l4LWV4dGVuc2lvbnMvc21iMy1wb3NpeC1leHRlbnNp
b25zLy0vbWVyZ2VfcmVxdWVzdHMvMTA+DQoNCi1zbG93DQo=

--------------YMaORxDbfPW3L1D8b12s2Ifl--

--------------TCA3D5iI9O0YydcvQZYYTS0U
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpmErIFAwAAAAAACgkQqh6bcSY5nkaz
IhAAvy8yG6TdtVpqtszVHpFGfM1N4MOvfsn+pOxM7cfkTk+gN0A+q4/zjTHxPauy5yNkIaSq8Gn3
4/w+GJf8SfxRK9SwA7XYquVRTSToX9aMaALbEGamWiQcw0qwgPLvT5xGiMm4dSUjEykuyK2laoB+
nYrS4WB/zjBjT+tkf5sTGzHO1He1vciGQShNtzqplaUOpqoo8nxu1Q/G0e9dfEwAImL8pzXCm8vV
tIDp+/TpFm/fvDsSi5mtHJIp5l4lUypS4VXO/AJ/j0x7U24j7jSxLgzVR4qTgfP7CAgwL7dlfh/U
M1kAcZM6YCEbKgxuuZ1YdvQaO/5rOtXX2ok2mQSJOMMYv4yR7pyUBNJJtNBKF5Gy9IGKKseZZnO5
G3NaE92K3ECx5n3S844xvXoquTift9EVDrZSm6O5yP5REg+dLuuHQlmLayIXsiuQ5LaRJJSrLJK7
JCQCXQvQQIMIse7i5gUPojL6Vb2oJ76KieJ8rlNDR0Xh+CHnSdVknWEimqg7DbSiWXw7ye32Z+42
wnl1EEFw/3rKQFTPpjNicwq2gm880jez5t72XmztRVADW9BP19ei/iS0qnAxTG9Vp8D1RobL3f9v
3+ZM+eO9S23apdr6ZZ41FsyL/7E2PPuZFxiWI8vpuOwvBvaYDdAxyWyqCoKVeQ1PqOy/0hV3DpDR
sX0=
=ZBZc
-----END PGP SIGNATURE-----

--------------TCA3D5iI9O0YydcvQZYYTS0U--
