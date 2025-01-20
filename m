Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC9779DC
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 01:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337119; cv=none; b=LbcExY0zyHU/zK6BnyoSRRwSxUcrUatAf4rjikXkCxLh15nMlojlNttiVOdRPozFTdzOtu0zMTZ/sNIj+0jJabGfg2aLZaWBA1KE5Tv34aRh0FnPPsqHk8KFNwCEe34etZUhIuz/o92HaPSjchtxJdXYk61iwBR1hmRIntnXNy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337119; c=relaxed/simple;
	bh=hDMPnyBar1GLxzNxS3lvlvQ3I+FWHkfLEC2C3cQNEPE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dt+2MBRKSwGsbOP4zXo1GOakrMIR0qqLqBe/hkD2xZfFcn8QcucFXQIcJqnoTIoqPavMA8brIAyZLBM3SjLUgU+fInZS6/lNfjtvwWXW8zvkI2z2RN1+HEsAfMew4oDp3lYTpWAfdB55PvfBQ33AyhhNbSMSRcfrwMSdr5fkc3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7XZhh5c; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7XZhh5c"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53e3a37ae07so4193461e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jan 2025 17:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737337116; x=1737941916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hDMPnyBar1GLxzNxS3lvlvQ3I+FWHkfLEC2C3cQNEPE=;
        b=c7XZhh5c8QSZaO9hAmvJoAi4KKvbIhvzqrkEt9hE7MjNDmgTKGR5e+y3Go3lXHx583
         EYj/8XSeXWOYD+GG5AA2DU7IB0R2Iebk5bEA4wEDTK1ZQ4n/Mis6x4NEBhGm1c0gcGFq
         pFpZ+7PilYVjt4cMmcT6f+KqXGbuvQSUK3hyICXQw5PY2nBIk9l+lhtNztLZwAnlFmhi
         dZYZqj2fDhoDolVJCJzgeoozWRZO1s9eNrw8Z25fSF/6ilofLhXJJ76Limx6HyaM2eKh
         3kHw4S1Oy2zxWiPtpQXPVQBnQN4OKwEBk9I7H6N1i34/Fe53ddmDttjoHSrhf5a/VXwo
         Zsbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737337116; x=1737941916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDMPnyBar1GLxzNxS3lvlvQ3I+FWHkfLEC2C3cQNEPE=;
        b=Ps4OnYQRqrR8L2VaNY8bLCVx5wqtuGphjdj2lYcH3oHRzfau0SmJrbdyPiFYo5Wqmo
         WX9BicY4MXgwENuzIK6RH50wkMa9KFovfKNOTynh1bYPavzA7/a6SByXOKgVtYkZ8gzX
         BjKDtIq1XpB7w5Q5rjTXjRRQ7QSuaeiXfkLRjf+7a7S6ZLfgifEBijrni67osgz8Nh/+
         fW5jPIAeBzdrgdKoYSf6aad7hv0V6aA9dmn9i+6hX304QdcpU49POc27wY3S0W7oDJV1
         zOkUUdlTC8s0bUhAuiFHQASNPEIGOlCmGjtJuw/FZqRj2IFUmKJCKw9ZaRdXZ0HMYqNk
         Magw==
X-Gm-Message-State: AOJu0YzfUfmd6uEVH5IOWtUzRLYqGdkjUUZLZzc5NjOQCJmWQ/YOHWv6
	wISWNcsgJeQmmotXGFf6OfwpWZt2IWcBvFXnPmDYk2ftOO6Ii6bczEIUPLxFxO3ompSPxpWZA+c
	h/lgbTZIHGoH9wHBpO+EimOs0s9c=
X-Gm-Gg: ASbGncvwDeM076t3jOpKAnM/N/lOSpq9w89CDgbqC+DhuKMNQCb6Vydsfc72xmVryDK
	ma2FizDT1u3hJFFMopKSf7OixNSK3VljNMj5UmrOr0Rdmmu0T2OOYRJ1IEKAUIjSK8cQ6dsq4y2
	DpZeJ2iDgx/g==
X-Google-Smtp-Source: AGHT+IFsHI+sC9okXv4BUAwL35WfDRAu+rngUgSLYFFTaesIVOfcBrn2xE8MxCQKKv4Xh13LrdhPgCUDilz2JMI9COM=
X-Received: by 2002:a05:6512:32c7:b0:540:3566:5760 with SMTP id
 2adb3069b0e04-5439c265ce7mr3376086e87.35.1737337115687; Sun, 19 Jan 2025
 17:38:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 19 Jan 2025 19:38:23 -0600
X-Gm-Features: AbW1kvbmLJA_xDqzl4NPxmpPD0ocVqN7YYLeffy2GMSwVRx7RaiQPMpiV4KyLOc
Message-ID: <CAH2r5mtOobiuE1v5Qf0JqEg7VttodHJy-95KFOyYHtVsx=bHfA@mail.gmail.com>
Subject: [PATCH 34/71] cifs: Set default Netbios RFC1001 server name to
 hostname in UNC
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>Windows SMB servers (including SMB2+) which are working over RFC1001
>require that Netbios server name specified in RFC1001 Session Request
>packet is same as the UNC host name. Netbios server name can be already
>specified manually via -o servern=3D option.
>With this change the RFC1001 server name is set automatically by extractin=
g
>the hostname from the mount source.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>

Pali,
Is there a good way to simulate this with SMB2.1 or SMB3+ mount to Windows?

--=20
Thanks,

Steve
