Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50FE30C629
	for <linux-cifs@vger.kernel.org>; Fri, 29 Aug 2025 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756490643; cv=none; b=FYCOLVHeg9HA+5iXo7m3XB8MaSDZaBr35UskA5jGMIK5NALCILuCdH1zYt/LTfwbPSXmE1yb5OEisGc6GXiMiWj+DBLFgipvjmXyLgO/34q+U1w8QHJpyzMFihITtNLSADQ1hNUGvH4V+ILbfyXTEeb36vXWi674C2TreIlxppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756490643; c=relaxed/simple;
	bh=NcPQlIy5RLt8gpltJUR964uaQycyIlyScg8LlCNvIso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oLUYRud+nbwr+BWQB2nr/IMU3X9+uF6Wzq3zfKqCvKVuPm+Vt7wA/RsNXVJqM6e49KKNPtfTwOdq9U1P7/dCN7L/CcTK4Xr2OFDtT7KX4EM4zEZZu0D/C+J6JeRrV0QdPsYFbxiepNeh6G8f5+T9QVqCqAZGNQjwFUJjCUO5e/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PaITX8Lr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PaITX8Lr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=NcPQlIy5RLt8gpltJUR964uaQycyIlyScg8LlCNvIso=; b=PaITX8LrYogS9eQ0cPDE+1A9BO
	5J+GCV9D+EtdBlBgL82oKoqNI/c1oKbRR8eo5GpI8maZfwZy4K/QiQJeFv/o7Wu8rFj92hXfik82m
	eMFooAK+wooe0Cg56a6kqAGK4iJRKuOsZkL3LHgqbeuZY0jvdTxmqYNDl12G6h0Zi+9vTkrbUwqli
	aZaogIWSlYUtyrCpfAjY2bEw8SWAa+UpeMiPyHQhIdCVMR4YyjClfzQTLPdetBg6brIte3FQ3TLSJ
	C44kFzQkO1okhj8v7luYsn2S1i+Fy+18kXbNnvEJSbfEgIQ4ALCGTsnpTh5UpmXWM9vcf9m5FfOPw
	NHyvO2CyIBP+B8Ya18bJG53pR1mNAkwSe869F3Z8bnSHLgfmhYhgJtP+hdbbhRdtCkvBIYIgfvlwL
	LCw0r5C6yK1pL7obzAz3IQwDh68WzA9UYx79aUDBox1rFvNtvCo0KSYAnG90n4usWJlSSlmTk4Dh1
	OKyzAomBhbHnlnCZYwVxwigT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1us3SA-001TJm-07;
	Fri, 29 Aug 2025 18:03:58 +0000
Message-ID: <2854f742-a0bc-4456-a372-9fa2d4e2ee3f@samba.org>
Date: Fri, 29 Aug 2025 20:03:57 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cifs:for-next-next 28/146] fs/smb/client/smbdirect.c:1856:25:
 warning: stack frame size (1272) exceeds limit (1024) in
 'smbd_get_connection'
To: Steve French <smfrench@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <stfrench@microsoft.com>, kernel test robot <lkp@intel.com>
References: <202508291432.M5gWPqJX-lkp@intel.com>
 <c18ba6b4-847e-4470-bd0e-9e5232add730@samba.org>
 <CAH2r5mvksbiH-D4FbVb0PVg1vnik+WU7d0kxRUk0S9h9S+=zvw@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAH2r5mvksbiH-D4FbVb0PVg1vnik+WU7d0kxRUk0S9h9S+=zvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjkuMDguMjUgdW0gMTk6NTkgc2NocmllYiBTdGV2ZSBGcmVuY2g6DQo+IEkgaGF2ZSB1
cGRhdGVkIHRoZSBwYXRjaCAoc2VlIGF0dGFjaGVkKSwgYW5kIHVwZGF0ZWQgY2lmcy0yLjYu
Z2l0IGZvci1uZXh0LW5leHQNCj4gDQo+PiBJJ20gbm90IHN1cmUgaWYgdGhlIGZvbGxvd2lu
ZyBzaG91bGQgYmUgYWRkZWQNCj4+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8
bGtwQGludGVsLmNvbT4NCj4gDQo+IFRoYXQgaXMgYSBnb29kIHF1ZXN0aW9uLCBidXQgSSBs
ZWFuIGFnYWluc3QgaXQgc2luY2UgdGhlICJpbml0aWFsIGJ1ZyINCj4gd2FzIG5vdCByZXBv
cnRlZCBieSB0aGVtIHRoYXQgY2F1c2VkIHRoZSBwYXRjaC4gIElmIGl0IHdhcyBhIGRpc3Rp
bmN0DQo+IHBhdGNoIGZpeGluZyB0aGUgYnVnIHRoZXkgcG9pbnRlZCBvdXQsIHRoZW4geWVz
IGl0IHNob3VsZCBiZSBhZGRlZCwNCj4gYnV0IGNvdWxkIGJlIGNvbmZ1c2luZyBpZiB3aGF0
IHRoZXkgcG9pbnRlZCBvdXQgd2FzIHRvdGFsbHkgdW5yZWxhdGVkDQo+IHRvIHRoZSBwdXJw
b3NlIG9mIHRoZSBwYXRjaC4NCg0KWW91IHNxdWFzaGVkIGl0IGludG8gdGhlIHdyb25nIGNv
bW1pdC4gUGxlYXNlIHBhdGNoIHRoaXMgb25lOg0KZjJlMjc2OTI3NWY0YWE2ZTRkNWZhOTgw
MDQzMDFlOTEyODJhMDk0YSBzbWI6IHNtYmRpcmVjdDogaW50cm9kdWNlIHNtYmRpcmVjdF9z
b2NrZXRfaW5pdCgpDQoNClRoYW5rcyENCm1ldHplDQo=
