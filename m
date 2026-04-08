Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875A42EAD1B
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775663960; cv=pass; b=fvxFLKNXJfLaAGqqZFHbz71MevWPPlO3juEpVeLscCQNTrKgPTqH+ZeH9j7DFP090KWPF4tC+AN/VxAttz9jxQHpFfwPdkwjVP22jcD+5QO8Y0fY33WxXmdGP2OOXe7nbE8N5w7f3m5sg+XzmbT7ECi+Bh0Xystc8KVhkX0kVAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775663960; c=relaxed/simple;
	bh=CpD45yIP+ZJp9cyUhANdN6Nn6j/5cSIE5D4iZnxwDCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AOv48xrGgWY4H5pEXxtKskHbmhkx7CuMM4zpRK/dm4K2nJBtbIEg/amvWpLWmpgyPpSfHE2+DZ9hQR5OQNq5tm57npSjf+j4STZmfIFHJa7YmxwU+rJifTgfpMZh4o7mOLGDcu1TN9TD19VB6Q3v6yHbmTwYe1/UPOQyIkg5NVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MismDL9P; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MismDL9P"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-899a5db525cso58544936d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Apr 2026 08:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775663958; cv=none;
        d=google.com; s=arc-20240605;
        b=lrux/c1Nf1d0PANgmsbdq18Kfvfa94LwGvWTQTO2LSlaboTg3NP7nJIgjK30nNFNq6
         wro6stPnSh/1MyERFxwcnZtN19NCCNazGFWAd6NOWtUzoyGrRPi12wnPlT7OTA4wtz7j
         1CpaRoLlAIhuNpGckDzD8T6aX4JG64VejP27jjRGM2m3dsguWP5N4+z6Q8mtKHfwL7h1
         mRjS0CZXiJM0JfsEvcmR5yLlL6CrmCw6OJaWqlNdaFwzzPluxZj0w5pn8wyb6NSMnvi7
         UPOLnqT4Oi6t3i9WqxRH2pIP/GU9mUF7KlOmkaThI1ReUkLRgL9LEME7Tr4Xf2wScB4I
         /8jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KCXbYFEmPv0b9c+kdxCzTg+D7VxvMLGOfoeiAugqIMg=;
        fh=7CUFWSGKpk5x5VKdYf2Uwc+No7AblJ3SQ9xw9nCFAf4=;
        b=FBIdTH1G70sc2C/VVi6WThxNI4Wu1VqDabr1xYc+xrOMmNFscf6VKl1zfDH8+yDV14
         Lo5OvjRxpkCrm1zq3ILiXqrXXoOoI2Zcrp/b3SEXE2wBVGIRuT+rhAOt5FgiHGbz/USy
         RM20+2hOkjYdFrZnKKRiGINOgd7hn0nN3VIGobiJzHAuifaRhahXbd3dXyRfRv4Mna6R
         zav5SfGKpPf7+dQajgC7Jo8Jsjf5sp/+vdRZgbchpkhCp9nVr5G0h8rzhQR9q3b0whTn
         +VVA95eC6Sd8HiRrfcJncWCy8U/evR0kZfjwtXmKRgP1OEzXzy/F1JucM7Xiy9xO72nm
         Lsvw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775663958; x=1776268758; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCXbYFEmPv0b9c+kdxCzTg+D7VxvMLGOfoeiAugqIMg=;
        b=MismDL9PYCQJuR9K3AN15ngbUHV++m6QnYCQWyw0jUfFThqwieR9eT03ZPWtON75pR
         +UpPzxMZnlHuJKnMgZsUfSC6M6tHyxqeJUlUBU6UN+fw1IFSJzehaxGvv3Ok6XySrhWr
         EwI6Db81XrTTbX96HtKCLpZkrOrzCACDYqX/FG3kUJeYCzPW02xSo8hIIt+/ktuo6rrF
         8CRBYv8Q5lGpV9A9ZvcvD7+kwxlWWmYU31pYIL+ZMHAk2062QxPxPF1wVPUantQ87WZM
         7DgXFAu1Mqab6IOTkTaYhhPofgI38EGqaBuOUluw+ECTzyZyi5q/A/5WBCvenK0+xUC1
         /vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775663958; x=1776268758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KCXbYFEmPv0b9c+kdxCzTg+D7VxvMLGOfoeiAugqIMg=;
        b=TdviFVHESEbk/svvlN+uayRVuZ665vXjUSNFGyKnXoBkOWl/GT+cmE+Jo8g4+Ctnmt
         TmYjNjeRRCQSWivlQ0mhWEnPcQVdk9AuNJteKXicRkzZU0yMx7y4936gQ2qYxGqj6bo7
         /Zbw2Leqrdj6qyxeLSj90VdGpHewtuxQoAxA9bggdhy6gZupyaGQnoUK0UvUfJyf9TQM
         RaRKeiVIGAFl75Rbn8dN7swaFh9y/0jBTxLoOhbC5DT63mW577duhDQA2AYBwXy6GEzC
         4yi1CfqdAEAQNZtuQcX65cGiP9gSxtyT7PJQt63vZ7V0yNBEfq3AQWNZACuT1IAaH4Za
         585g==
X-Gm-Message-State: AOJu0YzswdUosL5W2Mhae8YEtXYJzNHVEh/KeCeIwAaseVMU3pz2w2H7
	VRa4Ho/uogKUJeQCl0CrwCvw2QN9oIizUFvmuXKUyqDcQx4RupbFXrFQJ9zc0v4rkfFjzPIzvsP
	NnYUGNjVLcQYiRGfjQG3OF9emIBpeVtM=
X-Gm-Gg: AeBDievvqEzBO+YWcRD/X9XMfQpEko15rKWbuw468r1fd8Isz3AuroP/bok8wCrG97T
	gvfjR2EJJy3dHsHwVf4r0VZjG3bgOL4pwnV4AXUHhucubj1l0EUI/QSxaKa45bes99/tCUDuyqT
	NbmXUvZPzyGUR7Rh6Bzzu4GrhJrr+a0pnYE0GU56CfwjAosjfjsxVhD5GmfwweI5e8mxez9MnNZ
	L5EWtwN/qjoFKE6WvC0uhitxcLzMowIxWit0QSFf9S80rbhsyuraQaeN+ryPsU2WbU8OKfvcdSD
	/3Q2LFpihJuxRrfjqjwX9yr+wigm0J+7WbnbiJYWbazxQXyCBXIIp2tGQBwEifhZ38S8RXtUEZd
	BKFdcz7yYoG9OiLxkUPMrqGc9yDqCfAXJOGNjMYtwVK4OCvuzXqGIVgtRFwd5JdI=
X-Received: by 2002:ad4:5bee:0:b0:8a1:42f5:2c8 with SMTP id
 6a1803df08f44-8a702e838efmr343203086d6.16.1775663958237; Wed, 08 Apr 2026
 08:59:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4d96fd377f12876438f33a09d4342edc6151ec28.camel@suse.com>
In-Reply-To: <4d96fd377f12876438f33a09d4342edc6151ec28.camel@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Apr 2026 10:59:06 -0500
X-Gm-Features: AQROBzB2uk51O57A4MJM1FuhuehMKV4wnT4vx8k4u_qZct8vrS2Z6rG7MvxEoJc
Message-ID: <CAH2r5mvPOSP2VMSHfZbDyQFx1fqzSyMqxB203+4FG9vFf5dMTw@mail.gmail.com>
Subject: Re: PATCH: cifs.upcall: Retry krb5 TGS request with uppercase service name
To: scabrero@suse.com
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-utils for-next pending additional review

On Wed, Apr 8, 2026 at 7:03=E2=80=AFAM Samuel Cabrero <scabrero@suse.com> w=
rote:
>
> This patch allows to mount Azure Files shares using KRB5 authentication
> provided by Entra KDC for native Entra accounts, like:
>
>    auser@tw:~> sudo mount -v -t cifs \
>        //astorageaccount.file.core.windows.net/share1 /mnt/azfiles/ \
>        -osec=3Dkrb5,cruid=3Dauser,username=3Dauser
>
>
> After logging in with Himmelblau there will be a TGT in the user's
> credential cache:
>
>    auser@tw:~> klist
>    Ticket cache: KEYRING:persistent:1333365971:1333365971
>    Default principal:
>    auser\@adomain.onmicrosoft.com@KERBEROS.MICROSOFTONLINE.COM
>
>    Valid starting     Expires            Service principal
>    08/04/26 13:29:52  08/04/26 23:29:52
>    krbtgt/KERBEROS.MICROSOFTONLINE.COM@KERBEROS.MICROSOFTONLINE.COM
>         renew until 15/04/26 13:29:52
>
>
> But when trying to mount the Azure Files share it will fail because the
> Entra KDC always issues CIFS service tickets with uppercase 'CIFS'
> service name even when the request is for lowercase 'cifs', causing the
> TGS response validation to fail.
>
> This patch retries the TGS exchange with uppercase CIFS service name so
> the service ticket is accepted and then used to mount the share.
>
>    auser@tw:~> klist
>    Ticket cache: KEYRING:persistent:1333365971:1333365971
>    Default principal:
>    auser\@adomain.onmicrosoft.com@KERBEROS.MICROSOFTONLINE.COM
>
>    Valid starting     Expires            Service principal
>    08/04/26 13:30:06  08/04/26 14:30:06
>    CIFS/astorageaccount.file.core.windows.net@KERBEROS.MICROSOFTONLINE.CO=
M
>    08/04/26 13:29:52  08/04/26 23:29:52
>    krbtgt/KERBEROS.MICROSOFTONLINE.COM@KERBEROS.MICROSOFTONLINE.COM
>         renew until 15/04/26 13:29:52



--=20
Thanks,

Steve
