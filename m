Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5001171D
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jul 2024 16:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722012153; cv=none; b=Z+Ms07HSQDVE0g/7hFhbPCrTKMOY3bKH6DUmyQJ14q5PHOh83ZxwMCj97bqC8++HwDjx+s67AcinPlmVS23F7W6QM0x5t0ov5FG/HKqDbk+yBKQOwJ8jzNTU0KgnREdAfZu59XuYQoiJLTBNwVt/OU1y/ll3jlnuqdHxcA8A7Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722012153; c=relaxed/simple;
	bh=UH7NLtGv+QSWR01Yjjc4vK7Tc/6QoJtmdhVtkrvLRx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MWvWHlBwdDL1E2kibzYRRMU0M/pFdIARdjgpNOJgVPd2wMGlfxmQn0TIO95/xZHRj+msNlofn6t0vEHGgU07iViIgLV7tgRES5+8KjfK/p4W5DKuopKu0OT/EgcyLk62q5YZZCo0LHdnfwjP1JkUBo19C77sRHYEisAOuERkecY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XBqgpYgY; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XBqgpYgY"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efd08e6d9so2256611e87.1
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jul 2024 09:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722012150; x=1722616950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtnw/QXEnzFflWvKazwzIgZIqbpRgu4Y4vVb8egtBWs=;
        b=XBqgpYgYfJcnShp8rjirp9cX0OOWRPiBbNHkqDrYN94c5AxTu2ZBKegVl33KuFPu7S
         W4Sj+qFl5B9RX8BTL8NkUoL7piKgJC7JD0CpGE8b/NZWqLCoxMChT65ZVlLWyuui6qWP
         GdyodaNPeNIC2y4gO1w2QSJ12/abOtTvjzxKK9jhq3SNysKWG8pBBVqP3IXlT4DGAQAm
         a2FBuFnQiKcXCnSdmbNCrNuUf536c45wQGtR9b6l4dDLgiIKu4c7k0x2dtEzZIf7K8wV
         L4Fbs1TYaz8XV8XSRbc0K728oFTNSESWx2lcgbtsXajwuydHEUMz3uNvbO8aiqOED3DX
         tfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722012150; x=1722616950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xtnw/QXEnzFflWvKazwzIgZIqbpRgu4Y4vVb8egtBWs=;
        b=CN99WGmhlJPiX9uUZFzmNJ11Vlh8+gQxdQZBCEzvuL3xkcXDW66S4YZsK7/ef5IhZr
         HHVW8UfUPAPwpUIu2Cdqy3sQJO3Vjh0QpShQSNMXfitgcf+m3Gc6HOzfQAdoy1o+kaon
         KmYK/uXAuvgs/tTTfgvhB9wd01an94uMbhP7V1Wp/3nDcrgyFUnVsSAknEK18a26tS42
         UuqYOAUXM9AAGOPhSUGI+PszVVUdIU9ST0I18m2P2IXztvPLRKuifW6ElcpAp79LU2EX
         9Ywg18j5hjzzEXZzZEeWAJqSYN8Nl+dHs+Fv19fb83oA+wdiYFtVczINau4ZkAdilvXT
         o6/w==
X-Gm-Message-State: AOJu0YyLBD7Er0IDQaG899q6O9aLZeOd7a+reDISDYGUyT4XPwJsoQeD
	FmPlk+kHMeH9VM0ciejTy5wcBS62kuxzctvL5EPAxr7CvcslZ9mbwoQ4NFel+aQhJ0oIL+kefb3
	bF72ZyDjStbp3xx9aRYPnPUUAmjE=
X-Google-Smtp-Source: AGHT+IHkQGo1BQ6dj6HHQoX9BONSqoUYW+JTBXwQlfOmg30pVrep1YwYvD2xeQhd79xLEYW684WrXv8Y1Di4Cj5yb8I=
X-Received: by 2002:a19:914c:0:b0:52c:d5b3:1a6a with SMTP id
 2adb3069b0e04-5309b27c79emr227596e87.28.1722012150201; Fri, 26 Jul 2024
 09:42:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvhrx52pZNWQ-ieKKBoa6mugLewPgXgL8ss=xE=Zh-4TQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvhrx52pZNWQ-ieKKBoa6mugLewPgXgL8ss=xE=Zh-4TQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 26 Jul 2024 22:12:18 +0530
Message-ID: <CANT5p=pmLH4gFNPdwdNMmQC4Cx+u9HUiVVojfqpQeZ2SN2h4PQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] add dynamic trace point for session setup
 password expired failures
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 11:48=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> There are cases where services need to remount (or change their
> credentials files) when keys have expired, but it can be helpful
> to have a dynamic trace point to make it easier to notify the
> service to refresh the storage account key.
>
> Here is sample output, one from mount with bad password, one
> from a reconnect where the password has been changed or expired
> and reconnect fails (requiring remount with new storage account key)
>
>        TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
>           | |         |   |||||     |         |
>
>   mount.cifs-11362  [000] .....  6000.241620: smb3_key_expired:
>     rc=3D-13 user=3Dtestpassu conn_id=3D0x2 server=3Dlocalhost addr=3D127=
.0.0.1:445
>   kworker/4:0-8458  [004] .....  6044.892283: smb3_key_expired:
>     rc=3D-13 user=3Dtestpassu conn_id=3D0x3 server=3Dlocalhost addr=3D127=
.0.0.1:445
>
> See attached patch
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
