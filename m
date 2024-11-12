Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB33210184
	for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2024 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731403833; cv=none; b=d9WLfsGRVNN+c1t3Rye07K3YF668X9BiaoWEy7loQmUvY1KN658MvuUYUWfuvQmBaZ1HMPBbZ2ZvubjNLuLdiLLgQwVGv9vhGBOIjMXlDCXarUj/PBB7XWYuKKW2MvPr7bXqk3rBqt866ablUybedxCpZ9DS6eD2yaM9mD58Oig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731403833; c=relaxed/simple;
	bh=9T9ThHS8+L+iSJz/uAv5iZx5L5hq7YjCOAEB4QYIU0o=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:Cc:From:
	 In-Reply-To:Content-Type; b=C9R4P9PQ8shbDXVMtYy5xYmdFZI+4V+swqtMCSo+hFlwDP1BfNznLS0LVLeqjomDAKdbZV0SWW/pAwqX3r3mis29z7YCb9vNTu4eCGZNT+zXDOCboDLttUzEnT/GUps69DTkEN0fT1WSBrUz7uSIQwht6eKQDHvJgF1K5qioqr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BFUw4xo+; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BFUw4xo+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=9T9ThHS8+L+iSJz/uAv5iZx5L5hq7YjCOAEB4QYIU0o=; b=BFUw4xo+Vszo1QNzlNXKtc3O67
	lVCGXe8ToTsKPgg0sAARAEvNe+WIk1BFDaNoVFZ91n+eWX05GsnbewQ1XviH2mn5UnUbMvE9jO0tJ
	LhuT8EngGQ5Tvdl/wDPaD+kMNfFJzx8Gz3G+TfJbHbJ6q5iUAVCJApTdy50zZRdZOfibrFSoUFok4
	37o3n8kyQl2AfanW/zYU0GIAihw8QWXKetMPu7S8bO7pxCrFZPUWmnlHLlroiQ8q9xSqaxyf8z9aq
	RMubs29B/K1b7f060vaDtpK5+3n2MKIUfYvvNVMkTiGKBRjv12NNBu5twIU7GAPt8j39T6CW92eBW
	fEw+oFmzrUarjLUvp/HDXmX08T5eT8N6kSwhY28iUx2HQOeeE+YUEtJqSFUVZa0JVZ9VX0r6x6TaJ
	g06XFrqn16AfPCKlYOruOwmso6foXILaowpgXOsAiwFQzQ1DBBGjyVaqkysrbkWjrWACLMAyqpNM/
	aET640jgERaB+6OEpEAJeBe1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tAnE5-00ABXZ-36;
	Tue, 12 Nov 2024 09:30:22 +0000
Message-ID: <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
Date: Tue, 12 Nov 2024 10:30:21 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Fwd: Using file type information from POSIX mode
Content-Language: en-US, de-DE
References: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Steven French <Steven.French@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>, paalcant@redhat.com
From: Ralph Boehme <slow@samba.org>
Autocrypt: addr=slow@samba.org; keydata=
 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
 R3NApzHw2ZqQDtSdciR9og==
In-Reply-To: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
X-Forwarded-Message-Id: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ACRmAbeXQXAFLabyQqzdEtii"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ACRmAbeXQXAFLabyQqzdEtii
Content-Type: multipart/mixed; boundary="------------8Entc3zZ7FHaZDxeyRM4RKGw";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Steven French <Steven.French@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>, paalcant@redhat.com
Message-ID: <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
Subject: Fwd: Using file type information from POSIX mode
References: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
In-Reply-To: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>

--------------8Entc3zZ7FHaZDxeyRM4RKGw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Li4ucmVzZW5kaW5nIHRvIHRoZSByaWdodCBjaWZzIGxpc3QuLi4NCg0KRm9sa3M/DQoNCi0t
LS0tLS0tIEZvcndhcmRlZCBNZXNzYWdlIC0tLS0tLS0tDQpTdWJqZWN0OiBVc2luZyBmaWxl
IHR5cGUgaW5mb3JtYXRpb24gZnJvbSBQT1NJWCBtb2RlDQpEYXRlOiBTYXQsIDkgTm92IDIw
MjQgMTA6NTE6NDcgKzAxMDANCkZyb206IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+
DQpUbzogU3RldmVuIEZyZW5jaCA8U3RldmVuLkZyZW5jaEBtaWNyb3NvZnQuY29tPiwgUGF1
bG8gQWxjYW50YXJhIA0KPHBhbGNhbnRhcmFAc2FtYmEub3JnPg0KQ0M6IGNpZnMtcHJvdG9j
b2xAbGlzdHMuc2FtYmEub3JnIDxjaWZzLXByb3RvY29sQGxpc3RzLnNhbWJhLm9yZz4NCg0K
U3RldmUsIFBhdWxvLA0KDQppdCBzZWVtcyBrZXJuZWwgY2xpZW50IGRvZXNuJ3QgeWV0IGlt
cGxlbWVudCB1c2luZyBmaWxlIHR5cGUgaW5mb3JtYXRpb24gDQpmcm9tIHRoZSB1cGRhdGVk
IFBPU0lYIG1vZGUgYXMgZGlzY3Vzc2VkIGF0IFNEQzoNCg0KPGh0dHBzOi8vd3d3LnNhbWJh
Lm9yZy9+c2xvdy9TTUIzX1BPU0lYL2ZzY2NfcG9zaXhfZXh0ZW5zaW9ucy5odG1sI3Bvc2l4
LWZpbGUtdHlwZS1kZWZpbml0aW9uPg0KDQpBbnkgcGxhbnM/IFNhbWJhIGFscmVhZHkgaW1w
bGVtZW50cyB0aGlzLg0KDQpUaGFua3MhDQotc2xvdw0K

--------------8Entc3zZ7FHaZDxeyRM4RKGw--

--------------ACRmAbeXQXAFLabyQqzdEtii
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmczIC0FAwAAAAAACgkQqh6bcSY5nkbH
0hAAnfbYxHByCILgDH95OhfEYLH+FcF+dMieXNQhykapQ+HcDZtuYgnDlNK5i4q9jGBahXYQswbC
4oNQPwX4e8mphlY7UtToEzZTO03dtDzMdLiL10L6b2+NxVtMMQgJp57o/ody9U7JIn0DIlbsS833
YGuJcPLDUR3zJmmbZI+rJyct/BzvXGqWA3dNeca4K4v201vVSaoNrxk2CWogvm/4/McA3ggK1j76
/+yG7dGUWQKjP6Gw6JelsJs6McBfwHaarcvniUlb2uhqO7J2LUTunL8t2vZnbLeSR4bdyf2T1KTH
IjhRoxxnSGH1sJxFL12+xcS15RPKpex0pkIYPMRhrBbgjSIIAg2F35tlX3rcF2ww35fkZbX5hZgV
6CZQAVHseYTNb1Wy2CxdAWvJuO2L/kELA3AL1Ew0P/OggefVP7ctXF7d5Nc3ZvSnyCGUh43AD3Z1
XCzjjJoktQXMpPm2P1PbI67ZojPo3MO8I+Ru1jHglzwpxisIfPK8y+tQxv5AhszlI4wyIpTRH0mB
Wzr3oxBwfcDponBk4TfXIMSY0A7xWlscJ7bAMtuKwWpU/ugjDiRuU8QwCxslB02zV+YVKFtg4K92
TXYfDZa0X96MNrh2j86LELaI8I56tcxKNUUoepfb3GE5YcflV2QLkD2AcTXcX0HT8ZYppsPv44Tu
ZjI=
=8e/1
-----END PGP SIGNATURE-----

--------------ACRmAbeXQXAFLabyQqzdEtii--
