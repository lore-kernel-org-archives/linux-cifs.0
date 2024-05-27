Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFBD61FFC
	for <linux-cifs@vger.kernel.org>; Mon, 27 May 2024 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716826183; cv=none; b=l+174kTEuBEjT/pfxVr/boULWddCC3BQWMb/t88habzOmBw7cjuLuJNO823yyyO9va8w90t3ZwoDLqGsCDbMj6GDfJs1k/YXFckcQtQ3r0PZyWaNGHWjCHsPUdlbN8zMK/XmczeL+uebah7dhHLEBfYbawe7PdG4QIN5cIxWvXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716826183; c=relaxed/simple;
	bh=u6Hl2/5IDs+8S14dmv94vTQ2HSFz62QHf82Ll45aHJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAXqnOi227CRLoUlQsdEzmQBOq6oCoTuV9OGVI9ezuuPB/mTYMEjT/hUpMWzotbq2TsCZrnkJveOHppCKWwFqDlA+Lqfk0qGsuSn5hW+pt+yi52OucLxmMRgbi9D0AWXrX+8ViRzKHNE73DQRnwbS4C3H0sQcy/opPnJsALI/zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gvFsABn3; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gvFsABn3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=u6Hl2/5IDs+8S14dmv94vTQ2HSFz62QHf82Ll45aHJM=; b=gvFsABn3Du3/XDuUyk5mSO6xah
	mo9mfTOUmpSPCdFNn3MdezlGLfE1OOZSyt94BQWFNMOM9NXJ18u40kplMwF8Mc8hyWL3nwaW8PoNU
	PB1fv2xYTrr1s9I5eDjL1bgGFm7aO4KJVbrn9Dh+/LigoZN3Yh58+TNuPvfA4n0Jteu7Uka8GoPT9
	s2EiEn2JveaFBqT/H6Z1oxlZTHFEt8v78haNRJO7eoKgRX56EnyRCn9/ht7Huoa7/lg2kupRiuU6J
	h2Ft5xAzWqF1ac8JFtNtuGpaRt8/ziHUk589cO04h3efs9YK4SdS84Jldp5CQNROFDK53mh8IMiTL
	sE7TjXXfK5etG5V/vZBfs0hz6BhF2IiugBLGJNagl9iXrny34UopQf2tB1dTfwKHKiNMJeYFhB1zU
	4VeMeLrJD5ocam95IQgN7HNCeRK5nnVtGhk/rp/fz6af7UWm8GGPz1MjpQ6aa/4QEDCgUSicwcBGh
	C5g3s05YoCzutk4Mawvnm4Lj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sBcuh-00DSnv-3B;
	Mon, 27 May 2024 16:09:32 +0000
Message-ID: <53a2b3b0-3600-4da1-b651-e10a065020e0@samba.org>
Date: Mon, 27 May 2024 18:09:27 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ksmbd: off ipv6only for both ipv4/ipv6 binding
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 atteh.mailbox@gmail.com, =?UTF-8?B?zpXOm86Vzp3OlyDOpM6WzpHOks6VzpvOm86R?=
 <helentzavellas@yahoo.gr>
References: <20240502121425.5123-1-linkinjeon@kernel.org>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20240502121425.5123-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTmFtamFlLA0KDQo+IM6VzpvOlc6dzpcgcmVwb3J0ZWQgdGhhdCBrc21iZCBiaW5kcyB0
byB0aGUgSVBWNiB3aWxkY2FyZCAoOjopIGJ5IGRlZmF1bHQgZm9yDQo+IGlwdjQgYW5kIGlw
djYgYmluZGluZy4gU28gSVBWNCBjb25uZWN0aW9ucyBhcmUgc3VjY2Vzc2Z1bCBvbmx5IHdo
ZW4NCj4gdGhlIExpbnV4IHN5c3RlbSBwYXJhbWV0ZXIgYmluZHY2b25seSBpcyBzZXQgdG8g
MCBbZGVmYXVsdCB2YWx1ZV0uDQo+IElmIHRoaXMgcGFyYW1ldGVyIGlzIHNldCB0byAxLCB0
aGVuIHRoZSBpcHY2IHdpbGRjYXJkIG9ubHkgcmVwcmVzZW50cw0KPiBhbnkgSVBWNiBhZGRy
ZXNzLiBTYW1iYSBjcmVhdGVzIGRpZmZlcmVudCBzb2NrZXRzIGZvciBpcHY0IGFuZCBpcHY2
DQo+IGJ5IGRlZmF1bHQuIFRoaXMgcGF0Y2ggb2ZmIHNrX2lwdjZvbmx5IHRvIHN1cHBvcnQg
SVBWNC9JUFY2IGNvbm5lY3Rpb25zDQo+IHdpdGhvdXQgY3JlYXRpbmcgdHdvIHNvY2tldHMu
DQoNCkkgdGhpbmsgaGF2aW5nIHR3byBzb2NrZXRzICc6OicgYW5kICcwLjAuMC4wJyB3b3Vs
ZCBiZQ0KYmV0dGVyLCB3b3VsZCB0aGF0IGFsc28gYmUgcG9zc2libGU/DQoNCkl0IG1ha2Vz
IGl0IG1vcmUgZXhwbGljaXQgYW5kIGF2b2lkcyBpcHY0IG1hcHBlZCBhZGRyZXNzZXMNCmxp
a2UgOjpmZmZmOjE5Mi4wLjIuMTI4LCB3aGljaCBhcmUgcmVhbGx5IHVnbHkuDQoNCm1ldHpl
DQoNCg==
