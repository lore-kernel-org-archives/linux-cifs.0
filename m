Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4063E170826;
	Sat, 18 Oct 2025 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760812238; cv=none; b=oJ0E+kXPeUEiU36WcI7ltlZ/tfmX0O3FdfldIc4U/7QitP3FZnUvYIlEciGp3u30J2ck8liAgdkAkRd+DA3Y5q67VDIQ0O9mIXrg4FvX40lAKX4IDyGeSl0jmrzjWkKM/PQh8t+i7hnwwTSmpca7NQDEbGZr1qS3LvpbjGHoKWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760812238; c=relaxed/simple;
	bh=9K60V8xaZjL4nPo2fNFMTbnA7qPD7awztSqylcBUDDA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=nEYkHANv3QYvOgilloF20lkRcPoQkLk3MwKwRg0lUUOQqlx7PksbeRHkVM1QFz6NMerJkhmE+kLFb8umW4L86xB7D2tGQnkx/DBS7Tn4VNsGdJFcvKtjY28gR0+93a4evrvKiNvYVUURUMKh7mgUWDHnypMOXmbTMos5UKINGRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ch29JoTY; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ch29JoTY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760812220; x=1761417020; i=markus.elfring@web.de;
	bh=9K60V8xaZjL4nPo2fNFMTbnA7qPD7awztSqylcBUDDA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ch29JoTYAZ/grBqPiLGyCUBD5Q5LnVJxwRNwb/an+glkVlsulhd2DTuHz8wjtpO9
	 xKxp8oF5djZ6wi0X9dVjRbuSyhY+4JqTk+nSHLPXX3Wx1d1ixBPW/TlyMUvp+C0XF
	 I1mUb/eb7xivsiAyTUy7nhfKD7afpSqCVCr6j2xDoAoD754i1qUwNu7K3KZNuGbBX
	 w3rlrqfIzWtJJlAITyzJ7jSvkGPj2jx4lOS6OdDyLRwP3BE1KVxnw8Nqlzd+OMtNS
	 AHMUsMsA84eAT/RKENGu/nHtQEG5Lk9PeXVRZegeEEaNklE/TYGO3H6upPcbU8yEp
	 f1lxDQjiil0c4CDOvA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.233]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N8mzy-1u6YAf3KNi-0166DU; Sat, 18
 Oct 2025 20:30:19 +0200
Message-ID: <103ac0c4-486c-44c0-926c-8cc5b1387efa@web.de>
Date: Sat, 18 Oct 2025 20:30:18 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>
Cc: chenxiaosong.chenxiaosong@linux.dev, LKML <linux-kernel@vger.kernel.org>
References: <20251017104613.3094031-3-chenxiaosong.chenxiaosong@linux.dev>
Subject: Re: [PATCH v2 2/6] smb/server: fix return value of smb2_notify()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251017104613.3094031-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4LFcclqbxXjVPgI9b6elBqYsQn0rM0Tqt/kuvMsVsa7oo9IUvo5
 yPWtc3IrsH2bMnceul+AlHSNDxRtv0YWr6EgGses9RuCgs5yUCI62SiV/Z+pSnrAaWHhSBi
 aoelSgJdDX592Rz4KZMcARHEdUcZlVG7ODN5S9BunmUlKitnVCpi6+f0kZwPsJ7a15eys/x
 AgjXn6JFUkU7tJo34aBKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Va/ldQfVunM=;pxySeyVnPaRbZpCmK0pG5mKd67c
 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
 /gErqFo/ydTYKY6xX8JOjSKjCoQhT2RGeKA=

> smb2_notify() should return error code when an error occurs,
> __process_request() will print the error messages.
>=20
> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
> in the future.

Will another imperative wording approach become more helpful for an improv=
ed
change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.18-rc1#n94

Regards,
Markus
