Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11A51E4AE;
	Sat,  4 Oct 2025 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759581397; cv=none; b=h2XqbNKjoYcQCio7oi0YgKfq072YCkNeJ9lXnR0Nqjnff51zlM1pQ9/xw4doowbEptmnzjxUiccwqnPqPv6Cmo9ocAGUhFc8J7cV/TQ/faovL3CEwqRLaV98e6/k9tXcrdyu3mHCB3A5GjCCdbv+/cnF53Jgcg+s2V5qxJxFK54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759581397; c=relaxed/simple;
	bh=iTB4n+4WSo2KztEncuEhlk63fZWcTuPe+3XGUcHS93I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vt+PfB74hvo3OJmT9KQnCZTXOQkWd39np5iczbCiSJSwQLKXPcAI5pUq9bhp/csN3GMoA7EXjJFDjpPBIhpeEsvuHH8jXnt2Uvh++0c5Th81IkPsFEyujIbBMxphtr2B+w9atWxoFhKmrw0bldi4lJs68SBirunEYj3rIdbcKT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ByytSIdP; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ByytSIdP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759581384; x=1760186184; i=markus.elfring@web.de;
	bh=H7VX/qy8aGy+IOmkPg1MPbv2e+jG1HKFKTaSPBgmwR8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ByytSIdPKSCpW0Nu2LYhb/V9wtUeMkA7mwNzKXPghuV0Xn5eiYITFt+zOFJe1GPy
	 5AKsvI81GiH3Fn39DiKKaOML5fZZYDso9of6XrOJIz66FGD4RTrvKvK8Pgh2tFnwO
	 gMivULQUkHcbPCHMhU5XXw0ny6rbyOvu1DVxR7tMoblqEQhjbio8B7yr/mHJY+4R4
	 AVaXtk7muqrk2eVIGUvCxgLH8zmaVvQIXr+0OOdkrNraI8KLi8FP8/tjpX73P1uLx
	 jCBYGNTdx1rricOla1zpXgaUDMH1dv4PbfsmsGC/u0E+obl6u+b/wdEk6E5VN3r9z
	 Lu5RSZ3To1ceHMlGCQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.173]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M7ux4-1v9xRy1dMg-006R1M; Sat, 04
 Oct 2025 14:36:24 +0200
Message-ID: <9e1d6597-156c-4ecc-b188-75089e175dc0@web.de>
Date: Sat, 4 Oct 2025 14:36:23 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: Use common error handling code in ksmbd_vfs_path_lookup()
To: NeilBrown <neil@brown.name>, linux-cifs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Stefan Metzmacher <metze@samba.org>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <6d759211-79e7-4d86-b22e-2ae46d209622@web.de>
 <175953064635.1793333.2429881029964457140@noble.neil.brown.name>
 <2d533e64-8543-402d-9295-5fd2f314f35d@web.de>
 <175957657719.1793333.15585390544259019306@noble.neil.brown.name>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <175957657719.1793333.15585390544259019306@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UezFS5eW1Qctl6pwdezkhPJ8yAX0hHjr86+KNfHMsG+uW0hKtLI
 QSKtFySO4WttyTCP87y5Nc1I7cZL3CmM9UszPP9ontaF1Jr7ejcWEWdssegvNA3qXu65Ho1
 B01Xx2i85y75oZPPt86spZAu/jSc1Z5i+FEwtNm0NngqkFYhBIvRZZWPhot0TAEr5v8XDV2
 fk2DRFQRhaV2tarM2asAg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LVZhaHJlMSk=;aUIfWbCp1IVLqdhNzWU0jl/ttSI
 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
 bygHQ==

>>> This is based on the pattern in kern_path_parent() and
>>> __start_removing_path().

You influenced the software evolution also according to the availability
of a function like kern_path_locked_negative().
https://elixir.bootlin.com/linux/v6.17/source/fs/namei.c#L2770-L2792

See also the following commits:
* 76a53de6f7ff0641570364234fb4489f4d4fc8e9 ("VFS/audit: introduce kern_pat=
h_parent()
  for audit") from 2025-09-23

* a681b7c17dd21d5aa0da391ceb27a2007ba970a4 ("fs: ensure that *path_locked*=
() helpers
  leave passed path pristine") from 2025-04-16


>> Do you propose that affected software components may benefit more from
>> the application of scope-based resource management?
>> https://elixir.bootlin.com/linux/v6.17/source/include/linux/path.h#L22-=
L28
>=20
> Exactly.  It doesn't suit every case, but if you are going to make
> changes to the exit paths of a function, I think it is worth
> considering if scope-based code will work well for the particular
> function.

Is there a need to clarify possibilities for the usage of the macro =E2=80=
=9C__free_path_put=E2=80=9D further?

Regards,
Markus
