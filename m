Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D778C73
	for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723750639; cv=none; b=K4bVCjupzFABfdQiF0FZqQaJA0vYtxZYJCmJ4I36Tsft+YRYiIKwOhGINfD340r3jSrv5S1wkNZsg44W2/tVHcJxeiXoMa0iRe9VHALmr5Vs0y0mXA06YTBdODRMOqt5y662BqmlJpthblQiaFNySvJ38g6fKuI856aVar2aNaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723750639; c=relaxed/simple;
	bh=dD1d7e+solrW6wzskrgM3FzshXMhsowml0O5eVVuvVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WHIC6Xorz9/dcpvDzSx9km9dFX0CkQXMNIHaIzwFp5TK5rlN/PfQ5ZdbeeDKQyBaQWqHSvJKvDMk+/NzuObm2qIVPYZSugw31JPTya79abhTmKBYt/kNxSEn88DZtlnAEscv9pO5/2GVykFOcJxSmCdDX3+Kbaad5HvVuHrWwQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=du7PrBSJ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="du7PrBSJ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5bec4f71751so933502a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 12:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723750636; x=1724355436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=155WU6nzq/XE1Yr6L6q8j0BToMe3rroHJyOchAmQqRM=;
        b=du7PrBSJn1bEzsb3aqqzTHJVQcxZdVD5/YaM96CEedpJC3pdF/3NaeyVGvolCUFcnN
         4tvLMbtse45y+Glixwfwq6aio+gb8e5OhqjDo1/Q4NkGMQeW4PAkkw5eyjm0absVPeTn
         t4R83kZvLJCVRtpQBD/JbsCUC2f7m+rydgfYMNOO+9lwoYN2JsFwrw0rd40ylz181MRi
         RaGASrC/sm+nA7MR80F6hYGSfj/dJi5tj7MgDXY9uXk8yQPD9WrLBXrEvqOQqgzVgCDa
         NtyRNFFyEGxFMlQ8Q/wZguS2b1WWS2HWwO3ZfH4bINGiCSY82dDT5zil80SSEYoU+sB5
         EgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723750636; x=1724355436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=155WU6nzq/XE1Yr6L6q8j0BToMe3rroHJyOchAmQqRM=;
        b=xNoMvhMBcGD0d6593R8MMP4pQ4ZfsK9+lyXrFWeguBfkdE2Aso50pzkCbaEuaxz/F3
         qorS+wFrTjAbGes5H9T8DJbrxuAKVH4dezsD4/W94iK2XLRAIB1MvHE/QHz4Dx8R4XAi
         WZU4OxbHGS5ELbBwhwW6fJ9mjm6HOGoLeHi2PjTVxrLptQ7VoN6Le54sKrLL17kD/PCf
         Pt106ZcPHqLwLrK8tRxjMQJ4QfNaeiDX+X3REy6mwJ9RO3+l8Wve+XKZyCZ5yeaCqwaO
         lp+9BySk3Rn8cg5xJPc9QogYPwhXu9SX6wLbsArMnnRFe7UsPHjvqz8dqFtkE5+KCaRa
         /jiw==
X-Gm-Message-State: AOJu0YyCoALrdTaVxvvtSaleBUMRbItkzFkcbw6vS2P8c7KG+QyKevPe
	MKBPxV9i8xUdMbcVWjJyrGPsfbHFi5VyGJWriDEUm7gMP/udiv9XUT0p0OI4tDapzLFLS7cGdVi
	Eyzn9DWHp2Le+9y6/M6Juj153NLwg4Q==
X-Google-Smtp-Source: AGHT+IGrDD37sHq4Ngtt8G5FDVkRHP+G0FTmvcIRlRHhGPFujO4YHJDmXodQyLJ2WjMT2INjIU7bLtzMQZk1FAnij5Q=
X-Received: by 2002:a17:906:cac8:b0:a7a:9760:9aec with SMTP id
 a640c23a62f3a-a8392a16e77mr36796266b.43.1723750635471; Thu, 15 Aug 2024
 12:37:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
In-Reply-To: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
From: Steve French <smfrench@gmail.com>
Date: Thu, 15 Aug 2024 14:37:04 -0500
Message-ID: <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
Subject: Re: CIFS lockup regression on SMB1 in 6.10
To: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Linux Cifs <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you have any data on whether this still fails with current Linux
kernel (6.11-rc3 e.g.)?


On Thu, Aug 15, 2024 at 1:08=E2=80=AFPM matoro
<matoro_mailinglist_kernel@matoro.tk> wrote:
>
> Hi all, I run a service where user home directories are mounted over SMB1
> with unix extensions.  After upgrading to kernel 6.10 it was reported to =
me
> that users were observing lockups when performing compilations in their h=
ome
> directories.  I investigated and confirmed this to be the case.  It would
> cause the build processes to get stuck in I/O.  After the lockup triggere=
d
> then all further reads/writes to the CIFS-mounted directory would get stu=
ck.
> Even the df(1) command would block indefinitely.  Shutdown was also preve=
nted
> as the directory could no longer be unmounted.
>
> Triggering the issue is a little bit tricky.  I used compiling cpython as=
 a
> test case.  Parallel compilation does not seem to be required to trigger =
it,
> because in some tests the hang would occur during ./configure phase, but =
it
> does seem to provoke it more easily, as the most common point where the
> lockup was observed was immediately after "make -j4".  However, sometimes=
 it
> would take 10+ minutes of ongoing compilation before the lockup would
> trigger.  I never observed a complete successful compilation on kernel 6.=
10.
>
> The furthest back I was able to confirm that the lockup is observed was
> v6.10-rc3.  The furthest forward I was able to confirm is good was v6.9.9=
 in
> the stable tree.  Unfortunately, between those two tags there seems to be=
 a
> wide range of commits where the CIFS functionality is completely broken, =
and
> reads/writes return total nonsense results.  For example, any git command=
s
> return "git error: bad signature 0x00000000".  So I cannot execute a
> compilation on commits in this range in order to test whether they observ=
e
> the lockup issue.  Therefore I wasn't able to test most of the range, and
> wasn't able to complete a traditional bisect.  I tried adjusting the
> read/write buffers down to 8192 from the defaults, but this did not help.=
  I
> also tried toggling several options that might be related, namely
> CONFIG_FSCACHE, to no effect.  There are no logs emitted to dmesg when th=
e
> lockup occurs.
>
> Thanks - please let me know if there is any further information I can
> provide.  For now I am rolling all hosts back to kernel 6.9.
>


--
Thanks,

Steve
