Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470AA309DC1
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367639; cv=none; b=rDS13HAhWhllA4CvBXodSnAqOXZg0IKlpO3kV5TlQWgTm83vtw3yGhX01czjEVsDQIM1CWlwp8bN0kT2R2jrxUuTJ/HAnQ1Z2zM+ZAD3B9hZnI4Yd0Ql7dnEkBMsR5xKTxtz5/MwimEAGdRUsHlcdJ0f3BzVkM9ggj8RWibpgbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367639; c=relaxed/simple;
	bh=LDk4+fJwsridLKsw8iE5we9QZA64ltWsVFzn0Pz5v1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cj04zXteJuwNmX7M0sYMzOs+4XXwm+alJJE70lWSBdIOtICytSxhawIliX1V0c62qcmP01/NByMK8sd6CEE1JdErFuHGJfEqbjYPj6R62lYihQ7Pc6mEa0a9suDitAhvVC0ubeKEj87LQbqHnydFUasTIwMdNahAFgSKfzpQKaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=q4a/NOnD; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="q4a/NOnD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760367633; x=1760972433; i=markus.elfring@web.de;
	bh=hXnTdgAPjYrdiEgZ19r0NNXYw0VFBc80NTYwccBdyYY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=q4a/NOnDZKIPgbCSQl1yrmOWfZT68fzobEDlvvUXqet5EahD2hi3vgahuoay9COc
	 zDCQ7xWk+mlY7ijSUJuWbx72J6wcjBoVbZDHT+7xrhqrZWeSI2FZiAnZnHs7vgwK3
	 rrZK7D261Ga//jnXCvKGngO4FST0I+c3N2Y1vzXNEkDnwcAT5AUf99iwHRfxKOMCd
	 4edmSw7O8xDkSoia/RBWUylI2t/FEi36FTqcTe34ZcJFx5aned4mzVeG409IBP7TE
	 pBFrgJR9rrF3L/Jq/LJagsZdO9vMk4inceAu6MBcJ6KOPgaYQa6clySW8MKe3hM5f
	 bXNGf1oBE6dUlcWVZg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.186]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MtyA4-1uERAL0tau-017Hub; Mon, 13
 Oct 2025 17:00:33 +0200
Message-ID: <72c12d4d-3edb-4838-b131-a0d210acd615@web.de>
Date: Mon, 13 Oct 2025 17:00:32 +0200
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
X-Provags-ID: V03:K1:MifiNqkh69PsypW5fhJ8oAz229rudCJbuXROS8fFszplJBtJ0S7
 RetQUee+sUiOzYFSrMM4ZwyM+6M4kPO1sQHaPwrQBeiaHIAmtatjotTEiHSN9sbXxIUeF3M
 vSlw6yDcKq9PEteDAyfSgMELpWmf5j+Axqi8r98fQCxwUhhx+YZUgeEelDz+Lb6+1+Isl/I
 V/rNLuIO/MoV+T62nInSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+7rkQam9mNo=;58ekecpjwUJeZ8W/TD9EAfz8de0
 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

>> static int my_test_condition(void)
>> {
>> #ifdef MY_CONFIG_LEGACY_OPTION
>>  if (0)
>>     {
>>         my_log("working?");
>>     }
>>  else
>>     {
>>         /* Test comment */
>>     }
>> my_info:
>>  if (0)
>>     my_log("reminder!");
>>  else
>>     {
>> #else
>>     {
>> #endif
>>      my_log("special part");
>>     }
>>  return 0;
>> }
>=20
> Thank you for the more understanable example.  I think it should ignore
> the code under the #else since parsing is not successful when that is
> taken into account. =E2=80=A6

Both source code parts provide an opening curly bracket according to the d=
esired
conditional compilation.
It might be possible to move this bracket behind the preprocessor directiv=
e =E2=80=9C#endif=E2=80=9D
so that an =E2=80=9C#else=E2=80=9D branch could be omitted.

Regards,
Markus
