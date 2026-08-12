Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931035E1AD;
	Wed, 12 Aug 2026 01:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786496931; cv=none; b=Bbtm8TrLdbYnmU7JEZjCXDx8rVZN+99/Fj/uJuQeHLeJIMpPQVJFMkL8DstqkorAYjRp0D4T5iaIPmd4cpwr8TenvSrD+FPxbYe22jcSxIwTq0NT3ZrQD1kTSQKS/Bxh/aOXP3AepN2CCBObRdF3cCZVK0uKXKDXpoo2wk7A4TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786496931; c=relaxed/simple;
	bh=LdOBEKTdkgqDbNLJDbYskHxFAOqVJOonk0Qk8y3J0rw=;
	h=Message-ID:Date:From:To:Cc:Subject:References:Mime-Version:
	 Content-Type; b=S3AWz5+0rRHcQ21nCOndUtbtGEMd5Rk2wkvgb4s7SvCWPQ14hoQHcN2OzIDozEf4e8+MIfUKlABgiFWImJ3BU9rjJayoLcuarkugjNa4uarbARgppfnNneggp17jEXTz9jA+jkUTfP8gJURA5UbZ5Rw/IS3RRF04EV6m8k3UONA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=OMgtMqgU; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="OMgtMqgU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1786496915;
	bh=LdOBEKTdkgqDbNLJDbYskHxFAOqVJOonk0Qk8y3J0rw=;
	h=Date:From:To:Cc:Subject:References;
	b=OMgtMqgUas6H6Cc3vG2PWYMqsAQvlJMfDYIX3gD7x3tGpgMl9bzdK7iYNyCKkJ6Do
	 mB6IE+d4ZGOHezreIbjpgS9bdFFYDT7Yn/PifCLlXENUsQskxVIF0aMSvssHNt/AfW
	 SFvIP0QiaRjQqcBCR6/8QDCjEj7w98xOPACnIiZ4=
Received: from PC-20201120SBOH ([183.205.156.133])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 2213C648; Wed, 12 Aug 2026 09:08:33 +0800
X-QQ-mid: xmsmtpt1786496913t6x9emz2d
Message-ID: <tencent_7C0E8F3CBC25E603FDA0289583DC9BD16B07@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3Ju1p/+CdclI+OjHNtendqfr7yPSN0vQl03Qz1ImrEEt7dUoFV23M
	 9MoG4uBdLL1mILGx5vqHRKplNuS4mempxVGcdgCXMBCppTQWgLqpKit54x9oRQG487G+ai3oozw0
	 r1AYFXFz1aWP8Ol0dgIrTh8yezIwheUelbm8623A+Vml6RqAQi+qHxlUpAIlaPrAFvtV4vh56yPP
	 1s+vNybxuFQqa349yJ0FwzsDo+MRLn80Pukqwi/xG4ETl2L+Ow3mNPTJobj3riDiIdwaUzA2MFIP
	 QS38gVu/UR5ZCECCkQEJcyxbprIjAk5aB3xOM30miUZVe85z7n/MQqe62/oQOr45DXs/xeMb8eDd
	 UPHTPdlII8vQjwjje8DEGaSW3Mi/aRCD0MSZPLH0WdrkvFK4GiIJAeMUWfud6dBKyY+8XlFaEup0
	 SiXx+Ydvn1VdMnmnqtBSb0vzUX+b7mqd9fB92rAJBi27JEyq4KBrOKdMER+BdWvBydqVuwVznC7j
	 P4dY8lCPdDCvjhCjH2yL+sOSh8kkQr2iKf2/Zeud6VW3wQ/X2voEaLkBj3L+4lYoBivHSbKG9+08
	 TW5wY8ubRv5pf9JjcGlQ8Nn/+AuaMg8hQoTvimY1otiJygEiZBUNBEZY1l+hZZo85RVrJB137cLh
	 2sfeRvp13/nIm81WWSgXPyJFwUcoZfa7SE2vZnHgTwQLF2/XrJzBUiJp2R0OmpUJbsy2OqIuxctf
	 yzNhm97XuTN/NNChGC5DYBVYgoShpdSpmEtmjpLHDdCvkm6Q47a0UE4MwCYeFp7zJe9wLFQYCuFm
	 lw1ZAu924sS9DGyqJ/9bM0ajdBHOdFalAmKKNdrYoOswKxRd4YJHp90nIY/MVs+WOGMqoVeAWPN0
	 GevFhXHmT9oPzcYCJ0cO6wE/ezeW9g8wvkIN1EeNbiogyBgr0469Rrl4SsT+Ibqd4Lg79fJBybVp
	 PbCm7SXIkkLXfQZeMXhr/p1BYJn+tIV4sAsnVJVcFIFXoM8iNtKUlAfrM/67Gc75LCYSh25cMZBY
	 Y4jDvCyuI7PxVbJ8di+DgnWgMu6AaEIAYBg/9zEup0QtLVN4k5WpYMYvVTHoc=
X-QQ-XMRINFO: NHo+0iP/cI22ZgYdVAreg7B8/AHmI4Bv8g==
Date: Wed, 12 Aug 2026 09:08:33 +0800
From: "grayhat@foxmail.com" <grayhat@foxmail.com>
To: "Frank Sorenson" <sorenson@redhat.com>, 
	linux-cifs <linux-cifs@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, 
	smfrench <smfrench@gmail.com>, 
	pc <pc@manguebit.org>
Subject: Re: [PATCH] smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()
References: <20260811191846.1263281-1-sorenson@redhat.com>
X-Priority: 3
X-GUID: 7DC42953-4FDF-4DA0-B60B-CC79BE11F035
X-Has-Attach: no
X-Mailer: Foxmail 7.2.25.542[cn]
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-OQ-MSGID: <202608120908328785132@foxmail.com>
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: base64

T24gVHVlLCAxMSBBdWcgMjAyNiAxNDoxODo0NiAtMDUwMCwgRnJhbmsgU29yZW5zb24gd3JvdGU6
Cj4gW1BBVENIXSBzbWI6IGNsaWVudDogZml4IE9PQiByZWFkL3dyaXRlIGZyb20gdW52YWxpZGF0
ZWQgRGF0YU9mZnNldCBpbiBjb2FsZXNjZV90MigpCgpUaGFua3MsIEZyYW5rIC0gdGhpcyBsb29r
cyBnb29kIHRvIG1lLiBUaGUgbG93ZXItYm91bmQgY2hlY2tzIG9uCmJvdGggcG9pbnRlcnMgYW5k
IHRoZSBzb3VyY2UgcmFuZ2UgdmFsaWRhdGlvbiBjb3ZlciB0aGUgY2FzZXMgbXkKc2ltcGxlciB1
cHBlci1ib3VuZC1vbmx5IHBhdGNoIG1pc3NlZCwgYW5kIHRoZSBGaXhlczogdGFnIHRvCmU0ZWIy
OTVkMzhiNSBjb25maXJtcyB0aGUgcHJlLTIwMTIgb3JpZ2luIHdlIHN1c3BlY3RlZC4KCk9uZSBy
ZXF1ZXN0OiB0aGUgY3JlZGl0IGN1cnJlbnRseSBzaXRzIGJlbG93IHRoZSAtLS0gbGluZSwgc28g
aXQKd291bGQgYmUgZHJvcHBlZCB3aGVuIHRoZSBwYXRjaCBpcyBhcHBsaWVkLiBDb3VsZCB5b3Ug
YWRkIGEKClJlcG9ydGVkLWJ5OiBTaGVuIFlvbmdjaGFvIDxncmF5aGF0QGZveG1haWwuY29tPgoK
dHJhaWxlciB0byB0aGUgY29tbWl0IG1lc3NhZ2UgcHJvcGVyPwoKU2hlbiBZb25nY2hhbwo=

