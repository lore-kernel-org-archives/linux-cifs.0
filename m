Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCB1E7C03
	for <linux-cifs@vger.kernel.org>; Sun, 10 May 2026 07:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778396590; cv=none; b=DtOzgzoYmnfZ0uksUvFHYY2c1bMPSUdgOSAV8XvJBHlyNt1bxA3zLFehUJ5F20evB/3DbPxC6tuohe2PSCcNz6Je7VUdJqh9EgV091cMYQnUrg3SpkluoBnqw5ccR/ZC8y8R74yyaIGGGiScX744gdR9COKkPhEWkoeUkR5Gc54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778396590; c=relaxed/simple;
	bh=6n/G/4JGU8fTNxowPQ87PHhLRkk91QGuIltcHdwnPpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k0Ezo5Pff8TuRdwWMhyBO6rTOC2afQR3DReT0esaZxSj14YBdWzaIM6RUafsAm3g15myMiLQLPjvcdI/+7FDExCeGjK9n9Ub7mbPxwFxtCWEIj6aDbS4EufXdX148zcN8s4Pp293ho+wPr+aGbHnMbW8RFyF/lnEOZ+aWPoJINk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIpQI+6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIpQI+6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E20C2BCF7
	for <linux-cifs@vger.kernel.org>; Sun, 10 May 2026 07:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778396589;
	bh=6n/G/4JGU8fTNxowPQ87PHhLRkk91QGuIltcHdwnPpc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QIpQI+6BZc6AGwee9NoCf7q9l0iiZm8j8++9lJ8B+3uoDRmkYzTmqFxpFm7LgmPeP
	 /NAq2FZwZ79CermMmStxWnN+1beOLTyyrTd04Bchzs+OO94PbuzZFvSr+o0yS2KyRT
	 PXQyL5E7Hmp7QlFaj7o+QgaBN2RhBfxwj/Kbs7XyARuFFWL+vGl3fWDPZVn9GP3CRZ
	 QzHxkG6o32KSRMjVczw+D25X9Rt98j5rKHGNQbzXBzHqpwSduN5+tBNyS368q2C8p5
	 WeXI4VsnPyFhB1TWTvSm3VROj5v8xbU3UMzgFF+seTTWJbT0b8WY73IGUYt9qLokWB
	 L4Ci41VUs7SfA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67c2d57a5ceso5694060a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 10 May 2026 00:03:09 -0700 (PDT)
X-Gm-Message-State: AOJu0YzINdzoq+r8yBbxWhiBbZxESjcz7DxsQBgsxDZqz3mRx4ykgQ7e
	60bQwYA63JV1EBxsigPyBgWI86GGaITZYdMUy5CaSvvlGTOhtAlCBPt55xHq0el7jI2KwbtCoZZ
	qDpuDXaWFtKdvLuZRH9Cro1HK9s9iIQ4=
X-Received: by 2002:a05:6402:35d4:b0:670:f319:ae77 with SMTP id
 4fb4d7f45d1cf-67f704fe942mr2214470a12.1.1778396588344; Sun, 10 May 2026
 00:03:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msznQbtjUWfS7_s6Xd4R23LispAFSJQtFAGg5s3THc=UQ@mail.gmail.com>
In-Reply-To: <CAH2r5msznQbtjUWfS7_s6Xd4R23LispAFSJQtFAGg5s3THc=UQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 10 May 2026 16:02:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-6icAv2hQrfc8DnwcuA8wM9++3QNFqOu3bJEOa9=qZrg@mail.gmail.com>
X-Gm-Features: AVHnY4K0LlOQxqY5Z5_zc7zNsmEtGHJGQARLgSEJdzxQtGhtoqTcWiPyZ8CXmrE
Message-ID: <CAKYAXd-6icAv2hQrfc8DnwcuA8wM9++3QNFqOu3bJEOa9=qZrg@mail.gmail.com>
Subject: Re: problem starting ksmbd
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2026 at 1:03=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> I noticed that ksmbd.mountd was failing on one of my laptops (running
> current Ubuntu, and current mainline kernel) and the reason was a
> missing directory /usr/local/var/run.  Manually creating that
> directory fixed the problem, but was wondering what is responsible for
> creating that directory and why it wasn't automatically created (e.g.
> with "make install").
>
> 2026-05-09T10:59:04.054852-05:00 smfrench-ThinkPad-P16s-Gen-2 ksmbd:
> [ksmbd.mountd/40000]: ERROR: Failed to create file
> =E2=80=9C/usr/local/var/run/ksmbd.lock.PNL2O3=E2=80=9D: No such file or d=
irectory
FIXED it. It will create the runstatedir (e.g., /usr/local/var/run) to
ensure ksmbd.mountd can create its lock files.
Thanks!
