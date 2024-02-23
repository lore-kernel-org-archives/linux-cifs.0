Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CDB22EF5
	for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708695735; cv=none; b=gyR3FP2e6I7PaKjtbhrNrWRpMPTSOfX9YrkAPobC6iSjhQr8B3A1SytNnMzDTXWbi+NihPeTdZEUQOrZ9ErA8Bg4Usmikgvg+TeKUD8m7A/6P0+A3bAsm8syXCSt/yBJARznLQUDLDcj2W36xMlKh6bx40EGEvxPNTk5SHGMtYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708695735; c=relaxed/simple;
	bh=ZqtV8zSnTj81VnqWzZxmflTkzjnaExiKfNrfuKn5r2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0tXo3Me7htgpDEgVqseeWU9dp2mQNA+1/cLSfjyEHleiMFZGNCCZtXKLYDKnf62ZjT1nbHvQud2nzpaCIs/sKgJ/7wBX4PJlKQR/549ZFA1X+FuZfr3VP/aDBKBOnd/KMM13YEt4VzuTD1hdz9VEJvjEX3e1SDDPxk2DGg3jRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKZtNYU9; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKZtNYU9"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-512ed491872so1809e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Feb 2024 05:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708695732; x=1709300532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqtV8zSnTj81VnqWzZxmflTkzjnaExiKfNrfuKn5r2M=;
        b=HKZtNYU9LhDWuWzSFI9eNH7EbG3KwXbb4gLbGxREvGRWjhtW3Bue2UjwS6tZqa0ZvT
         xEbqS6MabrfacfDDzD0VOOHYggDDp1BE/aSpsuWuEO5xFFbJIrCxKUzCnH+0tKaJH9Vq
         K15e5BXc0PXX7B0I0HUCy5NSWSdHwF3r/1zQQJtgt0MzUULUpashE1Hu0+xZdb1kvpXj
         nL1Nit/hI3lpYKUGRhhG6mz4ND1RPlNJP9MwqU66BTV4MM2k/ridmhC11+10wJtXqFUB
         o0w6Elf/7vLJrXpfYgui4syakNw1m5xORv3IWJ05dfbxcorcl5s1ohkB1W+ofvjuuziJ
         I8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708695732; x=1709300532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZqtV8zSnTj81VnqWzZxmflTkzjnaExiKfNrfuKn5r2M=;
        b=EMKRnrXh/lQ0ILS89DSuGenZG0Qj4nF6dSV1dIoxcv4thpzAnooCuVrRDZW1EHewUo
         2taC4AVDXKLszH4y8P56ODOL0R+OiYJFt/YyvdsvPgQetDodm8EXxVNihMyrPKrKHlgD
         nXORcgp/7bypVKA800Xe7Uig5UmFWjTbDb6KA6xsXBHgKTyfcQ8X8WWB2W/W/YucFsbU
         UyutiMs3W7Qmfl9cBjzPl/ZIQG+GSGg6C9kd+F1w9+2coelcgvnffvjaay68+0ULAnoS
         /xHdEkLnQEBIawP5XTgHiDZXJ7DnBzTQXdTZz27q4awP2NlQrg1ejqOxB6AhE3HTSWrh
         NqQQ==
X-Gm-Message-State: AOJu0Yzc4JwiN1/yn3Q2iaUSLeUed1nE7UGiJzKv+nTMos7AkNEXmf8t
	3FPfIobyhyhcgla8kNTO0BIEEiivL6OWFhdOaq2PtaauflsC+0Op+MqE5t9fchmyTm5sGbR91Zu
	aPokQ7v3mS9ibAFV64ho3L8hCEtyMcHT2QEg=
X-Google-Smtp-Source: AGHT+IGC62BECBtbJaIZQhvfaSdsEsC0zAp29qVsBYULjlIV9MYyXvo/Cf0qLNlTSOc208b4UYICH5pFzLqABjCMtpw=
X-Received: by 2002:a05:6512:3c97:b0:512:99c2:dfa with SMTP id
 h23-20020a0565123c9700b0051299c20dfamr1933795lfv.42.1708695731398; Fri, 23
 Feb 2024 05:42:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtsvNU--3EDFvAPSVuSnLpmbDr5A4YbaY=9rrndLyOpiA@mail.gmail.com>
 <CANT5p=rqWiiYtRnCjd-SYv5SLqAzEPwLknLUqT0AGibtwNq+Vw@mail.gmail.com>
In-Reply-To: <CANT5p=rqWiiYtRnCjd-SYv5SLqAzEPwLknLUqT0AGibtwNq+Vw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 Feb 2024 07:41:58 -0600
Message-ID: <CAH2r5muW75oaXPM8+Lwhxxfs+JFPDP-z=guJAYNxZ9eNdNCXzg@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] update allocation size more accurately on
 write completion
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, Bharath S M <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 7:00=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
> Regardless of this patch, is this really a bug? This is only an
> estimation that we do till we get the true value from the server.
> A filesystem is free to allocate blocks as necessary. This patch
> definitely improves this estimation though.

It is needed to pass various xfstests (due to a recent change in late
December of how xfstests checks), but I agree that this is just an
improvement of an estimation (and in any case a local file system or a
remote server filesystem can change allocation size for a file)

--=20
Thanks,

Steve
