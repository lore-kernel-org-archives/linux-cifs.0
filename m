Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A23998AF;
	Tue, 21 Jul 2026 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653833; cv=none; b=jAJ3LMS9x1hgQiLV1Hwne7oLpDmrmo1XaVcRczWrsmwBEXaeWruPIA07EH5DvxxwH2J47UzUDYBU4M8rNIRDsENMojjSvUgi1BoYu25YjjYbJIT12lfGwAmFdZHxK6u7BM9mUS81xVApJZcbBgLLSdhrEcyQf6RzA0slJ6F9iQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653833; c=relaxed/simple;
	bh=Igv8S7TZwpJHBFBYfZInBuD6NzDWxpSSCuNSIRThK98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lNRoEPQdYKvx6vQgs7gNnc6mdHdItSW+l1lKlHjQBzxxto26D1bPn+G1gNa21WkoL7KZHzYG6/TdiYtQxmgi62rdJjcIwrn2MFoZuMVhDrMkJ+GNjzfjM2+aEm2cWODXBJnilQRcZeJqp3RYccDcIJDbrjfhuqq5CwHcERHq/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iytA9Zhv; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iytA9Zhv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Igv8S7TZwpJHBFBYfZInBuD6NzDWxpSSCuNSIRThK98=; b=iytA9ZhvwpXREn0Mpzs4/ujHce
	DOe0rcv68wf5+AzCwDD+4hol0eBYSbFW8Umi2NmTMkenxjis9YEjzKxA80/KTxBmPm8Jc2cTlMM0T
	132NBjyXJlGo81YJpnthEjWWSqqlKgro7vLe5p7fNixUc/Z422GG+Ur9J7uBbU+NYk7OT4RwTUw+r
	Ju9Aq87Y0/0lCqgZ5rjDb3UJ99YoRv/gEosDrWaJ3T8uPiG3bJlxWiQMtPVb9CGBx22yWVYa9hLwE
	rITtilfr0pba2S32Ke53ZZ19IZsLy1vq5hQarDfej0rg1o8eWxYCyp7kb6DCvNDiM1/tWnlcrrwTE
	3H1wNSpM45+e9KOirxe1QPm/QI20UZgj1xi/3HV3HFSpioXOv2WaUz7rX+60CxkKtSIeHYjnJtpW8
	mpuv1hrSRhczJIOIA06zvER2SbNzpy2fgjJCNkDp0I8k/auUI1MWWrBAT+HUKzatnHS9MQvAL/ffq
	9wKsakKfvxxegNkrcNbZuTOK;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wmDz7-00000006PpO-38bH;
	Tue, 21 Jul 2026 17:10:26 +0000
Message-ID: <0d7bf668-cf21-4513-8817-6cea3cfce689@samba.org>
Date: Tue, 21 Jul 2026 19:10:25 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
To: Steve French <smfrench@gmail.com>
Cc: tanze <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, sprasad@microsoft.com, tom@talpey.com,
 senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jeremy Allison <jra@samba.org>, Stefan Metzmacher <metze@samba.org>
References: <cover.1784258165.git.tanze@kylinos.cn>
 <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
 <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org>
 <5fa257a4-456e-4917-9249-bb3457952335@kylinos.cn>
 <3cef100e-48e6-4fdd-b7e3-a7f2ac2c02ce@samba.org>
 <CAH2r5mubDD4rFZUVTMibVN+up=uNps5HeOv8ehLBXR8GHF3fXA@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mubDD4rFZUVTMibVN+up=uNps5HeOv8ehLBXR8GHF3fXA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------irE6p0SpDdG7riqI1Dyj07kQ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------irE6p0SpDdG7riqI1Dyj07kQ
Content-Type: multipart/mixed; boundary="------------KoKr0WF0ZddpLFsR7990fUF0";
 protected-headers="v1"; hp="clear"
Message-ID: <0d7bf668-cf21-4513-8817-6cea3cfce689@samba.org>
Date: Tue, 21 Jul 2026 19:10:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
To: Steve French <smfrench@gmail.com>
Cc: tanze <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org,
 pc@manguebit.org, sprasad@microsoft.com, tom@talpey.com,
 senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jeremy Allison <jra@samba.org>, Stefan Metzmacher <metze@samba.org>
References: <cover.1784258165.git.tanze@kylinos.cn>
 <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
 <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org>
 <5fa257a4-456e-4917-9249-bb3457952335@kylinos.cn>
 <3cef100e-48e6-4fdd-b7e3-a7f2ac2c02ce@samba.org>
 <CAH2r5mubDD4rFZUVTMibVN+up=uNps5HeOv8ehLBXR8GHF3fXA@mail.gmail.com>
From: Ralph Boehme <slow@samba.org>
Content-Language: en-US, de-DE
Autocrypt: addr=slow@samba.org; keydata=
 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
 rb9LanmjmJltdkLDwbd58Q==
In-Reply-To: <CAH2r5mubDD4rFZUVTMibVN+up=uNps5HeOv8ehLBXR8GHF3fXA@mail.gmail.com>

--------------KoKr0WF0ZddpLFsR7990fUF0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8yMS8yNiA2OjQxIFBNLCBTdGV2ZSBGcmVuY2ggd3JvdGU6DQo+IE9uIFR1ZSwgSnVs
IDIxLCAyMDI2IGF0IDg6NDjigK9BTSBSYWxwaCBCb2VobWUgPHNsb3dAc2FtYmEub3JnPiB3
cm90ZToNCj4+DQo+PiBPbiA3LzIwLzI2IDM6MDYgUE0sIHRhbnplIHdyb3RlOg0KPj4+IFRo
YW5rcyBmb3IgeW91ciBxdWVzdGlvbi4gV2hlbiB0aGUgQ0lGUyBjbGllbnQgYWNjZXNzZXMg
dXNlci5FQSwgdGhlDQo+Pj4gbmFtZSB0cmFuc21pdHRlZCBvdmVyIHRoZSBTTUIgcHJvdG9j
b2wgaXMgc2ltcGx5IEVBIGluc3RlYWQgb2YgdXNlci5FQS4NCj4+PiBrc21iZCB0aGVuIHBy
ZXBlbmRzIHVzZXIuIHRvIGNvbnZlcnQgaXQgYmFjayB0byB1c2VyLkVBLiBJZiB3ZSBwYXNz
DQo+Pj4gZXZlcnkgYXR0cmlidXRlIG5hbWUgZGlyZWN0bHkgdG8gdGhlIFZGUyB1bm1vZGlm
aWVkLCBvdGhlciB0eXBlcyBvZg0KPj4+IGV4dGVuZGVkIGF0dHJpYnV0ZXMgd2lsbCByZXR1
cm4gLUVPUE5PVFNVUFAgZHVlIHRvIG1pc3NpbmcgaGFuZGxlcnMuDQo+Pg0KPj4geXVwLCBi
dXQgSSBndWVzcyB0aGF0J3MgZXhhY3RseSB3aGF0IHdlIHdhbnQuDQo+Pg0KPj4gSWYgSSBn
ZXQgdGhhdCByaWdodCB5b3VyIHByb3Bvc2FsIGlzDQo+Pg0KPj4gQ2xpZW50ICAgICAgICBO
ZXR3b3JrICAgICAgIFNlcnZlcg0KPj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gdXNlci5mb28gICAgICBmb28gICAgICAgICAgIHVz
ZXIuZm9vDQo+PiBzeXN0ZW0uYmFyICAgIHN5c3RlbS5iYXIgICAgc3lzdGVtLmJhcg0KPj4N
Cj4+IFRoaXMgc2VlbXMgd3JvbmcgKHVzZXIgbmFtZXNwYWNlIG5vdCBwcmVmaXhlZCwgb3Ro
ZXJzIHByZWZpeGVkKS4NCj4gDQo+IFRoaXMgYXBwcm9hY2ggYXQgbGVhc3QgZG9lc24ndCBy
ZXF1aXJlIGNoYW5naW5nIHRoZSBwcm90b2NvbC4NCg0KQnkgZGVmaW5pdGlvbiB3ZSdyZSBk
ZWZpbmluZyBhbiBTTUIzIFBPU0lYIHByb3RvY29sIGhlcmUsIHNvIEkgdGhpbmsgd2UgDQpz
aG91bGQgc3RyaXZlIGZvciBhIHByb3RvY29sIHRoYXQgaXMgY29uc2lzdGVudCByYXRoZXIg
dGhhbiBlbmNvZGluZyANCmhpc3RvcmljIExpbnV4LXNwZWNpZmljIGltcGxlbWVudGF0aW9u
IGRldGFpbHMuDQoNCkluIHRoZSBwcm9wb3NhbCBhYm92ZSwgdXNlci4qIGlzIHRyZWF0ZWQg
ZGlmZmVyZW50bHkgZnJvbSBldmVyeSBvdGhlciANCm5hbWVzcGFjZToNCg0KdXNlci5mb28g
ICAgLT4gZm9vDQpzeXN0ZW0uYmFyICAtPiBzeXN0ZW0uYmFyDQoNClRoYXQgbWVhbnMgdGhl
IHdpcmUgZm9ybWF0IG5vIGxvbmdlciBoYXMgYSB1bmlmb3JtIHJlcHJlc2VudGF0aW9uIG9m
IGFuIA0KZXh0ZW5kZWQgYXR0cmlidXRlLiBXaGV0aGVyIGEgbmFtZXNwYWNlIGlzIHRyYW5z
bWl0dGVkIGRlcGVuZHMgb24gd2hpY2ggDQpuYW1lc3BhY2UgaXQgaXMsIHdoaWNoIG1ha2Vz
IHRoZSBwcm90b2NvbCBsZXNzIHNlbGYtZGVzY3JpYmluZyBhbmQgDQppbnRyb2R1Y2VzIGEg
c3BlY2lhbCBjYXNlIHRoYXQgZXZlcnkgaW1wbGVtZW50YXRpb24gaGFzIHRvIGtub3cgYWJv
dXQuDQoNClRoaXMgaXMgaG9ycmlibGUuDQoNCklmIHRoZSBwcm90b2NvbCBpbnN0ZWFkIGNh
cnJpZXMgbmFtZXNwYWNlIGFuZCBhdHRyaWJ1dGUgbmFtZSBhcyBzZXBhcmF0ZSANCmZpZWxk
cywgZXZlcnkgbmFtZXNwYWNlIGlzIHJlcHJlc2VudGVkIHVuaWZvcm1seS4gTGludXgsIEZy
ZWVCU0QsIGFuZCANCmFueSBmdXR1cmUgaW1wbGVtZW50YXRpb24gc2ltcGx5IG1hcCB0aGVp
ciBsb2NhbCBuYW1lc3BhY2UgDQpyZXByZXNlbnRhdGlvbiB0byB0aGUgcHJvdG9jb2wsIHJh
dGhlciB0aGFuIHRoZSBwcm90b2NvbCBpbmhlcml0aW5nIA0KTGludXgncyBjb252ZW50aW9u
cy4NCg==

--------------KoKr0WF0ZddpLFsR7990fUF0--

--------------irE6p0SpDdG7riqI1Dyj07kQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmpfqAEFAwAAAAAACgkQqh6bcSY5nkYi
ng/+KTttnH4Jfn73vN4L35NSy22In8prin1I4LNDMSzQnEyGhEIW4RbEotqB6RxSTaCaGJRyqvRV
u3QUTA9VPp5HM37aumtMd+Tv8K8K6HjBj/BA3a4TVXF9e8dA33f/DywpkD7kh35T+TlXOL2hZ9IA
5j/0t2R3Ja1M/vWbR8pZhl4VDhQcdTrED5I2Z8YzBsBjRespvXBuAU8Xgt/YNix8yCHbuXfRi91u
BI6ukaQsQKTW3awu1y57tgvZ0rvzXUC37qxAmhB4p07dYXUAiJ5FjTxTLK5qkHdsMAGk2MAxiPQy
PWDYNQZgLizNFf1atT725TzDtZpPksgv0mHtRnG0bJMXHpv6M3fZjKbKyNWMipbOhPxDqdI2QtcV
STLOZiS0/WDrEQ1K3ZW0lwLPNV1kf1Qy9zLZfUNnEamZ7TTcq5inefnYdSWHaZlA/+Khrg5rMHBp
lJeoAozAr/8TeBXMuUOuAcmr5Yn+9uQCPEsw+dkzs9qKH9JZD1pLcTZaSRTQ5ghHBcrE4SE1GWps
A4yibnRLRA+Tlxitvai6i3JDDiJvdko1oPOE31dYIHnPShVYSiwIP8MyNP/UhPz+czcpUDQp5qh1
cp+kxa7mqSf6Pv6pb+xBaVTLBe7/ooGDuJGfQQ+3d8vnT3hHgFtS3g2Ifr5JES6nEh0mA2BGstMB
MN4=
=ROVZ
-----END PGP SIGNATURE-----

--------------irE6p0SpDdG7riqI1Dyj07kQ--
