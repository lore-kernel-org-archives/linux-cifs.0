Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3520330B2D
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 21:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933352; cv=pass; b=DsuPX53ugKkEzDRzeyzHn6Io210Pl0wUROCSIi47ZfIJsUXja5X5XeE6zCjWo6QFgHxzXnQAh5IGgwkgqYftHz50xHrqSszrMc7W2TfUpxFI6fVPJHbv/k+NrTv+KmmvWkp26e7gUojy6UAMmmhnJgtRxfgVL+rcXcMhhTYbiQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933352; c=relaxed/simple;
	bh=GIbRXC4GFpVvvReTONtWDCPeijEBycf5fd5C05Sf+P0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OKO+DbM4STZQHnNpK6W/ZLesPDP7nRMuq864UNnCm9UxEvCNPby5/3CxLGu36zRHYxwLLKhcD0VrSXlYYATHA4q9H46kR8v1VhRpS8AMf+EmfY8rIhsFiV4cV3+INvU9wAAZ/NlAB92EhEw9Ut5oDrkFEFuWinmbMXayMnjPQO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QCZJqGsf; arc=pass smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCZJqGsf"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb3b3e643dso23868585a.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 13:55:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770933348; cv=none;
        d=google.com; s=arc-20240605;
        b=LXVRwve2PaS18UqhY48ld3y7LVPIX48+3n7MxkPl5mo8Wychw3gA+7mGXFf4Nnn3Ci
         8eyLFfzzSIZ7sVeQOqjWkXCdmXYBjgJBvJRh706cUhNGwCraQcVo5qWtya9C/vAFmBIo
         8J/XEz8BRKioW0d9h6r4/VDbSlmb4nWsmz3Yk+i3Cws3toThTidFqbSgrLb1ApLBrUpu
         Rw5o/SaDrU+sIEnr56KzJfZ9EJNTq7V2idGpeGeiyMePpnXyurPhRisna5MDDBeQVlHY
         B5s6mrVl8zx3X85k57DSsKa7LSY0dBrvIqwO8ZBIOERtn1yxghqYzzlW2M2244FTnAvl
         6SkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S+zip02OJXIOm12uEwGl05ud9Bik7dG9fiOw9PrORXg=;
        fh=Ah9UfP+lSOOYrMEHPLnF6nj37sdm7N8iUsWpV56yBLw=;
        b=XSIIDte/L8mGb66okqp0bNzZkEHmTo8eVBqSyTi74LvoncVuXsMZ6TbwMM6TxmO0ku
         wMK5DmJbPBMsRdhSIlNTwFzThC0Lcysc/8MiKfkjpDaAi7eSldBfaN7AA/mppfpAWlM5
         gZeVX+E+2XDtUxV5VEovFK9oU+c8A12gaeXSVyQ1xCX5N+kMXcxhH5JaqL8lxAUpy4LG
         dZJKJq3kNelSlkZzbkEXMnmRxh9+il/nAXcTESDofwlJ9j3gF0PbG2CQULUNNE9Orbps
         XiBanEcA9UGY/spK0yaHx55tvsHi/EK272rh19iWbIYR1R9shb1KjEW0aR3tsMCvPVK8
         H+5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770933348; x=1771538148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+zip02OJXIOm12uEwGl05ud9Bik7dG9fiOw9PrORXg=;
        b=QCZJqGsfoLfGT3mepAnPM2yVtqoCBIpGG5k3bW8pkdTD/jeitVaIgPRlJBiAcZ3Fh2
         qzIs+ld6+Mcg7bD7ALSKv+c1gi5NgSrCcbxqUzWkdRojtRyLI36oH81f++q001xyzY4P
         tsG3Si3JEVTxiAqgBsO7i9y8K0avod1+enKfQFLD7eQg9qcGhzFABWbin4WHWq0VeFia
         /JXTdJx9rAOd6tRV8kYJzKhqsSdkdR/widRUDbQmA7QlrPNTiADE34XfLeyFE+SSBt6B
         sLeDwyTc/5+NxkQCvJ3j+VmpUDAofz49CgpetMWwHD9G4K6I8djgDkDcKhwgPDr9WpjV
         1miw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770933348; x=1771538148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S+zip02OJXIOm12uEwGl05ud9Bik7dG9fiOw9PrORXg=;
        b=UDTKb8np1bVcmOgVVWLdF5AcUQPz4LSHn3icWGrk0eS/R0VDtuKieQTmkmKWPL5Q/B
         yKu1cRoxF8cJmuR0uIfzZ85FAH4LjXplCYTu1kV37HhSqjJ1bOsIL+LTtbnqvGbOfevR
         /4IvuDXfiXd8EIpHFm+xxzkFmdTqnmkHrR3SyaTX0cM33Can5Q5olgZTLZjs9k1sYHJI
         GuhJrrRDXwP6gJi7ZaMbInYaLyx1JdmmVwPhI5HK8CE8bF/CMDAewKZuC1DGr3f9SFP+
         Vzz47hAWoG+19Pg5B2Ga0yQ0cbm9IItcP/+Z0bY0mjUdARjDJ2Ad+vCHYye9E5+GOsNq
         C0cw==
X-Forwarded-Encrypted: i=1; AJvYcCUTZ76FegPBd4dHIF7Tg080CWoImN22+9bX7Ig6Pm7EwHwefXdMyKA8aRxwOy0tnY2S7aZT5l1d5+Sk@vger.kernel.org
X-Gm-Message-State: AOJu0YzXEK85fb36j3Uyi4PfPuoVZZC+SwxbB4i7rcdWZOHwGETi3j/z
	OSzXtqiwm5w7T1U4Y08Pg0W9SdDk7AsnS2z2iRMwT1F0DxIxAkw3DzK3fXbIMvRljSeE8wbWlsS
	n3naBZDe4i7nafZRCH6/esaQKGIw4gIA=
X-Gm-Gg: AZuq6aLl/S3gPeA9iPoC5jLwHVR4af6XnDUSYD6H4dhctnnBSDpRVzk+SuaVfrtU/GQ
	33GpzW0cH+kHxPNX2hEvFmcXAGNB5LPAoZ9tRFqecN2d1a989KxtioxjpTjoJhHKPVJBNvXKDzz
	GiYmRq4NhHPiBseF7sLHF8uySLpmScIfZoWqtF5ZzxJqSRxi80BTJpdq0CxOkFAw32hduc1ofmB
	Xwg0S1QdSuIHo2miOCI1gOp8PziIqB6iq2MZ73v46Ua6orOKmOvnJMbAYFYWyv9KG2YcxBR42Sw
	fKgx//lt39kKD4hSWCIdXvEN2JTGyVuMp8VXKwJYKB2BDal0m/NkWHKyRcdar02+VaiqVUtlpzL
	4E1NnL9oWwz5dir4pClu0iHclUYtgmMKadDOaEPikCeuCEaziPEWzCwWzx5kKzoaMNdNaC2JCVr
	AieCIzDI9h4E7B5GdP8uFn
X-Received: by 2002:ac8:7f06:0:b0:501:13ce:4e0a with SMTP id
 d75a77b69052e-506a68090f0mr2697511cf.10.1770933347942; Thu, 12 Feb 2026
 13:55:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260209175421.66469-1-adarshdas950@gmail.com>
In-Reply-To: <20260209175421.66469-1-adarshdas950@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 15:55:36 -0600
X-Gm-Features: AZwV_Qjbiq0yoPxqiBI8n9JOGxm7MBN3CQ5muk9WnoGkR9gS3ipNVvumJDFJgbA
Message-ID: <CAH2r5mtcGschT3qE9_8gxGg-Eo=Bm0ps2L64GujnWGFzWQ9RMA@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb: simplify boolean expressions
To: Adarsh Das <adarshdas950@gmail.com>
Cc: sfrench@samba.org, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

After getting feedback from others, it was felt that these two patches
(eliminating the "=3D=3D true" and "=3D=3D false") don't improve readabilit=
y
enough to justify the risk that they would complicate future backports
of fixes.   If we were already changing related code for a fix then
cleanup like this could be added on to a fix but not worth the risk if
not related to a fix

On Mon, Feb 9, 2026 at 11:57=E2=80=AFAM Adarsh Das <adarshdas950@gmail.com>=
 wrote:
>
> This series simplifies boolean expressions in the SMB code by removing
> redundant comparisons with true/false.
>
> Adarsh Das (2):
>   smb: remove redundant =3D=3D true comparisons
>   smb: remove redundant =3D=3D false comparisons
>
>  fs/smb/client/cifsacl.c        |  2 +-
>  fs/smb/client/connect.c        |  6 ++---
>  fs/smb/client/file.c           |  5 ++--
>  fs/smb/client/fs_context.c     |  6 ++---
>  fs/smb/client/misc.c           |  2 +-
>  fs/smb/client/smb2misc.c       |  4 ++--
>  fs/smb/client/smb2ops.c        | 12 +++++-----
>  fs/smb/client/smb2pdu.c        |  2 +-
>  fs/smb/client/transport.c      |  2 +-
>  fs/smb/server/oplock.c         |  6 ++---
>  fs/smb/server/server.c         |  2 +-
>  fs/smb/server/smb2misc.c       |  2 +-
>  fs/smb/server/smb2pdu.c        | 44 ++++++++++++++++------------------
>  fs/smb/server/smb_common.c     |  2 +-
>  fs/smb/server/transport_rdma.c |  2 +-
>  fs/smb/server/vfs.c            |  8 +++----
>  fs/smb/server/vfs_cache.c      |  6 ++---
>  17 files changed, 55 insertions(+), 58 deletions(-)
>
> --
> 2.53.0
>
>


--=20
Thanks,

Steve
