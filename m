Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B972574B
	for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711468875; cv=none; b=A9xyYWwuvOzdtcDk10Vu6pJ5M8z5iauMtAszSL23GqGgZipA1TMVo1KRToLVCadTwvbgiPz+lSumg1kuwWKRdji9+WTIcdfB7v6GmWlRxJSNoXxxzYFLE4bG3gqRMBW3+zAxj9v4LG/bJv+ZE5DYyKF/0DQhqHqa1NSEZCz9Bpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711468875; c=relaxed/simple;
	bh=7HPcuTgDHiPk5YZBCsK5HJH2j66CaGUksFrWl8AqBZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDn3ji/gMQ0hBI6z3nZ6M0A4VGovWCatlvDP/oANZUv8iBV3MbtqMl1MSwdyNSw41YyqloQfwIL1c9NQEJw7/4VIkHkUTBXOEdCfZFTm0oAQfvAjEryT15zY51XHGSmyyw+TFQ0lnUrmo32uxecNpW4UIsV/qkYaDPWJCdoquH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EtFxo5Bo; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EtFxo5Bo"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56a2bb1d84eso10003270a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2024 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711468872; x=1712073672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4I+g7lzJF/sHH7enwHn37o5bUae3FhsyjDdqMgXg3s=;
        b=EtFxo5BoOAk155XZBTfUim/eFGwYA3PQIyYzGUk1tlTtuW+9S+OB+iM+amOydbMm7O
         8lIPjvgCUVlVygKO9M7977JQtUMn8PXzByW+2pqO1oK7t2qVNZultDAOBDZc1mfQPDJl
         axNKyePRLzH+KEyYrA3ENwaU9lsWTvHb88HR40wOoY+yQzeho8Z9HbXaml2WKgRu2VEi
         s1ByLGf7EIW4PVIrTMa5X/71DixChKskNOsfR4j/2DecBeJdC1W1hxQlXOku5uzFRkjP
         A/yG/IlmPvNzsJuXpf1dAGH+xdIWDvT66Bk7jgEUDeSXb/1znEO+4vHTKxI5vva3jqlu
         4lEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711468872; x=1712073672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4I+g7lzJF/sHH7enwHn37o5bUae3FhsyjDdqMgXg3s=;
        b=J1twGXg82t3FHh1SNZsie4ncVzbEjMwt/7cNZ8ipLXbqjaw4qFcpmykZtHtTWZJY/5
         Yx1C/lQuHV4csRm0hNFqPzMUVovDEY9kowZF5J2EnmYLzCahUcp80N351GiS6FQD50rx
         /ltDTgGXU75fsKV7Nt+VRsJcONDTRrsVb+I/Y0Q3Eb9sQoTl6lWjFN+dxs0jgNY66R5O
         NkUgiJsu9w+UD3qGvHTQaLsils9LXUGTUhRbJrcaZ9wsC7YPsU3TfrnnqjLMO/iwjwD2
         AB3bQpErmWj9mY9/GnzVYed8l51BGheYcsT0WDov5jixXVKNYQLNtFuOdc9pTkFYfalw
         U4Vw==
X-Gm-Message-State: AOJu0YzD5wrtHhluhjiXUE3NIMSe84HNWfSoOSMKPdk7M2akLJedQORZ
	GfkHNrfh6H+5lHCsu1RM+MSRGEl/S5p5bRomEuRajJ2YKf/YMUgV+46I4gPv6Ylriuvdu/+aBgJ
	mzK3sgfVYZUHHoFTNHS4DvHzVMZbvQfBJ
X-Google-Smtp-Source: AGHT+IGANI0DkYj7PWJ8/ajAF/ppNwOkvcgNYCimcc5ggL3E5KIJhP/VWEYhM9TKDqB5lIgfej9jGRRjsiGqu2rzi/o=
X-Received: by 2002:a50:9feb:0:b0:56b:ddcb:bb67 with SMTP id
 c98-20020a509feb000000b0056bddcbbb67mr2041365edf.2.1711468871631; Tue, 26 Mar
 2024 09:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0HtRs_5hmKFLoh+OhWsHroAAHwvH51chaPJWWmpGPSg@mail.gmail.com>
In-Reply-To: <CAH2r5mu0HtRs_5hmKFLoh+OhWsHroAAHwvH51chaPJWWmpGPSg@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Tue, 26 Mar 2024 21:31:00 +0530
Message-ID: <CAFTVevVwcFw_n8OPpi4WuEojPCbohp0K7HQVmk-QeQ=gB6nxoQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] add trace event for mknod
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks good

On Sun, Mar 24, 2024 at 10:37=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> See attached
>
> Add trace points to help debug mknod and mkfifo:
>
>    smb3_mknod_done
>    smb3_mknod_enter
>    smb3_mknod_err
>
> Example output:
>
>       TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
>          | |         |   |||||     |         |
>     mkfifo-6163    [003] .....   960.425558: smb3_mknod_enter: xid=3D12
> sid=3D0xb55130f6 tid=3D0x46e6241c path=3D\fifo1
>     mkfifo-6163    [003] .....   960.432719: smb3_mknod_done: xid=3D12
> sid=3D0xb55130f6 tid=3D0x46e6241c
>
>
> --
> Thanks,
>
> Steve
