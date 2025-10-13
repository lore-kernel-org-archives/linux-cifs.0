Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8837B26F46F
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 15:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370457; cv=none; b=eFpabH+OR8AAikNmvF6DMqI7P97ArWAt3Mq/Q2A4AJEFlg2bMXNzQUCw1S2Yb0wTzwNcT/E3gsgdrHs6d1xI43+H2s5yLavIj6efsfWih6yPej+kAGGS79a8moA1ybE1Cmj0DaZwNWQDPm+AEw0Yr3jNVRNQtoyzJuDIihPM9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370457; c=relaxed/simple;
	bh=AhOixrgYqR54hINjRqYtw9syQi7y9lyAGQgwAx6KmKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UicUTkiGjPDx85mTGMMq3LQ0x8/X/vNQUVCUSKkIrXb2MBYtJwv3GsLBp6eHg7XDAF8QPmMqChAQJRfp6BPbmCM5CBT5pZx4tM6usOetxW2IH72PGA2v+xaW5tyfUxTq26sBSTEx52BNSK4sy+kZS9nyscUdmaAGSoQAyVh9HS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=uiPv1pti; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="uiPv1pti"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760370446; x=1760975246; i=markus.elfring@web.de;
	bh=nADwgyaUJIYZ45qOW2CaQmAHh1hfRjQ18lL4euBkjP8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uiPv1ptio66GX0LwJiFzvqfPmWF3226HL8SbInvdaOpek1fHaOb1ojht1wzMdwDx
	 t1Xs3yaQhZYs4OL359hU+V3nycC26B4xmghkMYclpxUftov/hsoQScd7MGkaYwUiR
	 kRPWlt3jX1xotH7hAUyD+Nyxsieo0msWy63j3NrVP/fZhSetWBrXsRWTGHdXOD0rs
	 xdA0vbrKsttTt0t+wnR96WKG7h1Ugvp8qQf2EA9Opu7VSh7EpY1lz/uQu+Lxwlcjp
	 /bz/YV2H/NAeo5uO2KQmuHUa1X4d3i/Zv6fgRrCImi3cDgLlBlFDPPmF3MXobHxlu
	 7wU8KtAoxoZvIWYCQg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.186]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N62ua-1uB9aI1GeG-016ecv; Mon, 13
 Oct 2025 17:47:26 +0200
Message-ID: <f114858e-84f5-47d3-80e5-febd138d68b0@web.de>
Date: Mon, 13 Oct 2025 17:47:25 +0200
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
 <8480276b-ee1e-454e-954f-b25890c79add@web.de>
 <dcfb5c63-ce1a-f487-df23-cadef6c45a32@inria.fr>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <dcfb5c63-ce1a-f487-df23-cadef6c45a32@inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vT60EahRG2TBPPQjyDLiKCH8ZyAKjsGNF5sFnsQZHngJKszfLOn
 GCY70h7L8Uac6fRGAuaQ53k8NtI2Z1yRpf39K/VK3esc2tsiR1Hf90BMUmJOIafJDUArkJu
 m+z9IyN5j5V+tVfSBaIz96Ca8MOD6ewES/GDiDzLcrb2qlm5gayt7GMuGd8PssdD7FATYQa
 zZG890w+QVxx4WVIY0YrQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qTzuIkxfek0=;/S26BvAD6xlPOjP4L5HOUNxcVFh
 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
 B+wOA==

> Thank you for the more understanable example.  I think it should ignore
> the code under the #else since parsing is not successful when that is
> taken into account. =E2=80=A6

Improvable software behaviour can be demonstrated also with the following
source file example.


static int my_test_condition(void)
{
#ifdef MY_CONFIG_LEGACY_OPTION
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
     my_log("test end");
    }
 return 0;
}


Questionable test result (according to the software combination =E2=80=9CC=
occinelle 1.3.0=E2=80=9D):
Markus_Elfring@Sonne:=E2=80=A6/Projekte/Coccinelle/Probe> /usr/bin/spatch =
=2D-parse-c test-ifdef-legacy5.c
=E2=80=A6
PB: not found closing brace in fuzzy parsing
ERROR-RECOV: found sync '}' at line 18
=E2=80=A6
parse error=20
 =3D File "test-ifdef-legacy5.c", line 19, column 0, charpos =3D 224
  around =3D '',
  whole content =3D=20
badcount: 17
bad: static int my_test_condition(void)
=E2=80=A6
bad:  return 0;
BAD:!!!!! }
=E2=80=A6
nb good =3D 0,  nb passed =3D 3 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 15.00% passed
nb good =3D 0,  nb bad =3D 17 =3D=3D=3D=3D=3D=3D=3D=3D=3D> 15.00% good or =
passed


How will the software evolution be continued?

Regards,
Markus
