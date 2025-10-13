Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EDA26FA56
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 14:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366112; cv=none; b=AqZQ7g4qVB+9aZWRKVW7eMuOenChBYYzh/W8rU59G4jpKK4/rCYM7as8mtRP2qc4kUxFRrLY5XQeBBEY4uxVkm0fcxoWHgOLnZ3tEZGRauhw8QPOTm3ax288fu156mUWITGYSlsNMLGi9jEhDxGyJgVNoua7Es5nnLrFNX+Zbxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366112; c=relaxed/simple;
	bh=H5CD4aUulW3AJe9/EH+Y94y+kOIsJt58GEFRbfEOYtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjtZ0hNnsj3lk6sRqP74Nub4PKx3ZsEQkyOHSdFk4NEz6d27W2Y9pw6H4uhAFL3kAxA2DqoB6NKRcjoI/oQCVHB6alFBtsRyWvZamnI5NVlnUdUo2JDOxElpL77vbzYas2np+2Wid7yUZDzRCCr7/zBlhGZ7S45R5Re2Cal95UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=s6VOMfYw; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="s6VOMfYw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760366108; x=1760970908; i=markus.elfring@web.de;
	bh=t4YbVn7UuEQrxVmXBS9q88pwfFK3vA2fr6yZ+C+zAUc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=s6VOMfYwB7n9llZddKuqQfwE9rtPLHg5hAdMs5C72WjwTQ0k+H6fFTOY7MsP6Njd
	 5agp6S8/eRlikemMyzxxRTJ67OKwfwL4Xw12t2K6SVdn2V8LqO8Evz//2kYqmAXXH
	 UoqdsY6p+L80ZK0YJD7l1/HUSFiHRiRJBTFGe4F0te9q6+drc8XeXfU4wD/eSCRIB
	 8VMX4BKTv+MwjUnBXvIY0iQX5TND7kETDPxsijx0D863eRPrhvty2/mBEWlXwhuFL
	 6IG+kUJaC6nqoIgvq8weaoPdCe/p9D7Jm/jWn8QlHL+kj/xqqzfkd9Xt0Bb6EGt3n
	 jDp9QWDXcUQSCKRsBQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.186]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MhFlm-1ueDkM11hi-00jYFG; Mon, 13
 Oct 2025 16:35:08 +0200
Message-ID: <8480276b-ee1e-454e-954f-b25890c79add@web.de>
Date: Mon, 13 Oct 2025 16:35:07 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5Bcocci=5D_Improving_source_code_parsing_for_?=
 =?UTF-8?B?4oCcZnMvc21iL2NsaWVudC9kaXIuY+KAnT8=?=
To: Julia Lawall <julia.lawall@inria.fr>, cocci@inria.fr
Cc: linux-cifs@vger.kernel.org
References: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de>
 <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vReqd/9oMpsaaHqbrIJ5+J63+bR4BFcmR3USpowEQsPYC6v9bDN
 Rmzxbho0E5vcFAYrxez8OR7BECScE0Sk7W4gv2Po8ze2Yd73+OWkeXtmc1Jz9d2j8W5eCOu
 Stm7lklN5U+fNfGjlN0sk55/l2d1jTTIs139J7cEu3qls5zrjTo85zp3t4I7ni6/qsZonXP
 2YCQXzEYUtIYeVchl3rQA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DGcuGOkEwGo=;UgVyhxqlbPJ7WetXq8z4ajCUc3X
 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
 aoXDA==

> If you want the problem to be solved, please make some effort to narrow =
it
> down to a smaller number of lines. =E2=80=A6

How do you think about to improve data processing for another source file =
example
like the following?


static int my_test_condition(void)
{
#ifdef MY_CONFIG_LEGACY_OPTION
 if (0)
    {
        my_log("working?");
    }
 else
    {
        /* Test comment */
    }
my_info:
 if (0)
    my_log("reminder!");
 else
    {
#else
    {
#endif
     my_log("special part");
    }
 return 0;
}


Questionable test result (according to the software combination =E2=80=9CC=
occinelle 1.3.0=E2=80=9D):
Markus_Elfring@Sonne:=E2=80=A6/Projekte/Coccinelle/Probe> /usr/bin/spatch =
=2D-parse-c test-ifdef-legacy3.c
=E2=80=A6
PB: not found closing brace in fuzzy parsing
ERROR-RECOV: found sync '}' at line 23
=E2=80=A6
parse error=20
 =3D File "test-ifdef-legacy3.c", line 24, column 0, charpos =3D 282
  around =3D '',
  whole content =3D=20
badcount: 22
bad: static int my_test_condition(void)
=E2=80=A6
bad:  return 0;
BAD:!!!!! }
=E2=80=A6
nb good =3D 0,  nb passed =3D 3 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 12.00% passed
nb good =3D 0,  nb bad =3D 22 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 12.00% good or =
passed


Will similar test cases trigger more desirable improvements?

Regards,
Markus
