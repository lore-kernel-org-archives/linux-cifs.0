Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A832AAA9
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 23:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148438; cv=pass; b=n5rMh7CiD2walc5hFAlOXfsR7M7iq1a5uLtmmQkdXKiRc7Z9d3W7W/BI9wLnDM0ohwN+g6ECsl+NBmCrimifizRvdWSTwDYn7vW1yEWk0MEPjo/oAoVc9Sj2bHlM/f9dZ/7sQziFSU7NguXDS9kFz6xCX0qPKKyvjQRoYcbSSIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148438; c=relaxed/simple;
	bh=V6ccR7OJWFg21dBkQIXawIBB+RMwmgb7a4hCFkrEjNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F1hV4628dpe1BsUdnneu2lCqiVlDAlOFkrI+TrXfxZYRXgvgt+GeMEs0JFxnHs4fjf3UWirx1wrIFPpx374G/kXHCRHxZKZpwboNRZCll/kbg6e6Mj9eVzQFPHTQKM/XS/Bc2oSmomASbjuNB6zPKLWM1H6iwc2Xwa2fUGFiYtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cMRmdk/q; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMRmdk/q"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5062fc5d86aso13312071cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 15:27:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772148435; cv=none;
        d=google.com; s=arc-20240605;
        b=fyBvDDbMSuKz6sqaQ5HCR0qVdZ+cMNEbVU9SnQe9Qtx5x6P5YzpJnqEUVJRy0nn0HL
         lsVw8dnytbbEuMguGEOKzk4maoBGO/LgIsnC2vyorgZVztuBOn0Jg43npWcQS6hxmWag
         1dKFvFcdJ1VDcHf/wAFvh2cx8ZlzV9Uglfq1Ul4rScJVZHiH3uQ4X6tdLqVgO5tsT0KP
         S5W6VbyK8xUHT4O5JSArK2o6uRH41T+iXO8xAWqWp8cZOuPTz774hlLlKmNOT1Ksytgb
         CSEgpD/NMZOLbk+N35uHa0VTMu/iaDQ/31g5gSz8a/kuibvBeLTZuIns8yDJuQsHDquu
         CZnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+C13fuesOQsGWYIE+DwAPg3HyJpgm/lMqzmvJkG5mdQ=;
        fh=zL2VIUqWpJ7mWAyAlViO3ALHYcAAG5eVypdHL3FfIk8=;
        b=lMS3B3SjqRHLBbWAuGCyTzsf3kMexJVdiDhSMxyO8IA6EnuaHc+fltBTpf9EukYiAX
         85msZw8CNdzgMqUb8J2IUOjaGZkJCyDmDa9i2+H/tS5rx8nizcvgAuFLgViaBX/LHI46
         9leMNQ9PCGRl9l+Z85aTPwIa39mZtFDslG1eXNhjiIkMwsPjmY5OC310wXRvjXDdp0aH
         FC2bCcl8XBrpwxeQWZmbQCpLYPFmBJNvzItLRIKfFW7/lxoO6CmvW7HVUccysYfgBxtW
         kBVpGXhMeXCAZYeeV4xjf2fFn0xyzzpX3ynn2fNw2zMeNvKccIIZIgTvrA9/7GeQJc1n
         Wq5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772148435; x=1772753235; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+C13fuesOQsGWYIE+DwAPg3HyJpgm/lMqzmvJkG5mdQ=;
        b=cMRmdk/qtlmb+H3vUoCi0vXZCBtBxPP9FHDmj1G8xxh60UwRUOhaPzdX7H1r24ZqL5
         PWBiCm8RknssLKeK+3DdyHaFE0NHcS3hVunLYTJoeEgL8Nax33N6LMmlpAwOLT7o7+mS
         DE9V4WFbYtcUAsO9ZhHgkkItAv3McCW/zwzWXUNRm6sC4db3rj/wjnlGVY3ZxZdRb5lb
         xQ5VW/LcahTeKbZd7FBDfPXMbngBX0Dc/CgIQR3DZ4VJ434GJOOkuwmy7mfN+wCQFMlv
         unv5d8a1yhy1eYiXV6ncgN1pLNVJbr4qnE5iZqNTgNmiykq28GAWT/j7d0vgmnV+V57p
         Kehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772148435; x=1772753235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+C13fuesOQsGWYIE+DwAPg3HyJpgm/lMqzmvJkG5mdQ=;
        b=IxgbudjIbmKssxpjZMa6dUfSizt0M8xy/z7yOBj1Jlf37+T1VQ1M9LjXeLcIqdzofp
         Oq8BFplaz2mdYvCz7S4/5lkt3cH9nKBOMYIiIDByu1MTqR7+Sv90pK800iwzYJmuA1rg
         M2nTMzf3SHBiBEEr8ZXBYAAR0U3PDdOgg6myTXkXE1AihM4C8xrr0rGP5y9xi00DaNfw
         h8PytWpiU8yIVtpDk1hGKKzLmNb8jpYpvXRHcT/5der/gkZaiwCgDDo1nIf5Oj0vZDue
         BRdPyeySgm1Fcky2aNpISZLMFaayj+fZdrN+CDeKUaDBW+7y6uMwjl6R3fXJrp+xX1Nc
         yPPg==
X-Forwarded-Encrypted: i=1; AJvYcCWqY/PVcK7/Rf4SId4QQW/t8oGeKApH1YqnS+CxqiLS+hEiA1j1kZafnRhSU/QIxG0fNmNYLTSVC7eB@vger.kernel.org
X-Gm-Message-State: AOJu0Ywne/T1x8RifcKbz/1vc8KujyrjXZeIlZnnrusKrnSYB8caQAuD
	Jz3fV/18KXm4b3DMIzqZpBFozyjL2MiqE27lgB6pF1Nn09MOAyx/t7Py4HKTixb4yHVLncS5RhL
	ZUmy1tkoM54eIYR7k3GxvnIiwNX+xuDtpQg==
X-Gm-Gg: ATEYQzz0k53U7LC4gxl6x3deSfAOKGwf3T6Epk/xQ5gY8fvmUcShilFfX96HwKNHTSa
	iGHpM+Q32vyKWw2l/jEurxjvBBR4015YwVKFcDjiQbeCsyfD1mCcbhIEtYUjNHoeKd8gid/Y1Kh
	DMOTdzkGIy2shkMKVysRUe6Cg0A0qinqjgzgtqfgH1vYrR4KcPrbu0yAmz6U1WmO3D/f4FeQ6hW
	h6xr37oQcwp7OEbbMbMgrCrInOCXKB7lBziiCMyECcIfl6nCP8NGt38g1vQPaS4hs3mdHb0aWOP
	YU2DnUqpUYhSg5KAnlspxlv2lX3y7+Gh/vjj1kW6iJgWd3ULhGkLA23ioY+kcPYIQYfdp7Z5uwP
	P2C1sCNYIdgB23rGrPDJj5q0oCFpHkQPeqfIgKpEbwrijORjB5uuWObkGobk=
X-Received: by 2002:a05:622a:14d2:b0:505:e448:1b0d with SMTP id
 d75a77b69052e-507526bcc0fmr10524131cf.10.1772148434610; Thu, 26 Feb 2026
 15:27:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226212845.784172-2-thorsten.blum@linux.dev> <03d69afbe9fa3ec36dc39d6864a97b35@manguebit.org>
In-Reply-To: <03d69afbe9fa3ec36dc39d6864a97b35@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 26 Feb 2026 17:27:02 -0600
X-Gm-Features: AaiRm51wPI5Op2zWvoWmQOWUXDQJX1JkcBIS0gDMA-jQaYOqTDy0vzpeGhzagAM
Message-ID: <CAH2r5mtubVce+VgPaQqZLx8m+uW6cJxGDqBVqpSu-pTVgd06FA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Don't log plaintext credentials in cifs_set_cifscreds
To: Paulo Alcantara <pc@manguebit.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Jeff Layton <jlayton@kernel.org>, stable@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-2.6.git for-next pending additional testing (also added
the Acked-by)

On Thu, Feb 26, 2026 at 3:41=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Thorsten Blum <thorsten.blum@linux.dev> writes:
>
> > When debug logging is enabled, cifs_set_cifscreds() logs the key
> > payload and exposes the plaintext username and password. Remove the
> > debug log to avoid exposing credentials.
> >
> > Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-kr=
b5 auth multiuser mounts")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  fs/smb/client/connect.c | 1 -
> >  1 file changed, 1 deletion(-)
>
> Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>



--=20
Thanks,

Steve
