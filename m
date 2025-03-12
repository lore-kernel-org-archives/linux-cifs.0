Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEF718E025;
	Wed, 12 Mar 2025 03:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741750875; cv=none; b=p9DejTkB0AV3snuTcjVj7WWv/ZFjSjGb4df5D4v3BDa99pqBDtm0oRDplvXe5zz1aElYDWbUObNZIf/RKu1YwPAfJedcrwxQ0MrhaQ2DkBr+CBffhILFAq5dT6yZQOO+nxJM6riplGZA3Qs/kTEvGFaI7wIMVIV76yQScuU0kbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741750875; c=relaxed/simple;
	bh=/M6lNxWvHtJlqhwu+uX/2SIdkqV+8TxcYaF6GOqVtcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=brhh9fpQlWyqR05sCDWryOCCA/jEnzEAeZ1eDlscywxu7lNW44sCiF+pl/dYdF3DeVbE6aRbP9St7cbyK6I6KC8AYswRq9Qryp2Un6WS4caZDteEdllYZAn4P5/UbdTW5Hwep/DzvCIpnsIOYOS41go/v6IEU8MletJH+p/wsN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUn4Rx7p; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUn4Rx7p"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-548430564d9so6441775e87.2;
        Tue, 11 Mar 2025 20:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741750872; x=1742355672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92scuT0mPLxGItmKoFTauVYvE2ycFCz6mNcLharBo24=;
        b=QUn4Rx7pFA50jqjZ2Heybc7Y2HZXaWDL1mQtdzJIwcr9LkItxUhfu5Dx+y2okpLnrx
         vd+bjDQEK0Gzayw0OnGJGja7uMcWeQX2J9/U9+Ulxt7MZtIU6lSpXpvG/pFA8d2cUwne
         sl7X2hGeqyicbgVKzmSrFlNcUN+3XqUwX3UKIODhva9YtcGMipDjWw/Jnu7+zk7nEQ78
         ZzH+LtK3eM1KcJ8LodZL2CrWI5D6FdV1RJUBBZV/QA/ofp927MtKzWD7EuMJhgoB5PdM
         YK7d8yc3f3GesSJNW6q0GMhs5oIphEp6o+b4PVvFuT68ku8koKOyvcHTAsiA5uYh7AFG
         ODrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741750872; x=1742355672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92scuT0mPLxGItmKoFTauVYvE2ycFCz6mNcLharBo24=;
        b=TAAH/U49eTzM3HFY05l0yfXzF2XduLLaBqZEh6Tfk08PxjdHESdgOebXFUgGCpY3Vh
         CLuYpaV9vfnX8da7O7M39StN1HXYIK80C9fd+btTfvCRlscAgpSG5YMGHxgfTw4AZPx2
         S/FqOD3Ayg4kBZsvO1kGYu2kCwaKTI7WIqJkXWW4HkgSX2iaoKioB1Byyah0lg0PHhTw
         jpEmxAHfAYJCxJpQ+lqUleX0k9Xh/vlZZdcJA57T8SeqyjYt3dsP1aOcbmo8/KCzqUGr
         Hl339r2TTuG5LDywnm41sa8qX/efJeOZmhnhz0/L7/a5JENsQsfdf9jWTQEU2K9WXOns
         PdiA==
X-Forwarded-Encrypted: i=1; AJvYcCVbnIzqYSjaG9sZaHEq8FZV3oWDExkFntXC2CODcwBYZbZfHdXxHIxrQLcZpSzxvJYgcLaS5FR41kW6qwwt@vger.kernel.org, AJvYcCXmAFCOholv7JCB79CW8uWE8GcqGeJApOkbZsI6MvhLXHXQtVmIYWyrfQQ1RQblQUTlYbH3N+vviBfY@vger.kernel.org
X-Gm-Message-State: AOJu0YyjfJugHw5xbFztYAcVTHebDbi0XTu0SYe2UKYnRMXVg47In/95
	u9zNeRs2IKsR0SQhfIceLfsOPKXXkMAzpgg1+rZm4o5oEFbUOjBl3RU8+OJk6swQV/vYHj0+am/
	xAM7quQI8B1YC53NcDjOyiwG4vGE=
X-Gm-Gg: ASbGncvg+J3fI5/IFJem6jpRk7si+1nrt+Wo6F32mRtB1+wmQiTWClIoWb9UvLR2Djj
	mf3wtSkzUlFAu90mWCYHXZ/k6C7vXg/reaEzCV0M8Mkv5Tu5D5bT6bx9QIR6KcBYZYBsN1oj72o
	bJyOHBqzMwFMJc1U/lrIoHqT5MTJQ3D+sB4WmeoHsQpZnwBja4HKJcdzhYpYU=
X-Google-Smtp-Source: AGHT+IEXM+5xWJasauWbNbCS2YfDh1yeixbbhn9cHO3JOongiCVBYDLz+zdUkf5WvIfevUBa4DGHP4Ubo+i5MsMuNKA=
X-Received: by 2002:a05:6512:220a:b0:545:d35:6be2 with SMTP id
 2adb3069b0e04-54990eacf31mr7132413e87.34.1741750871834; Tue, 11 Mar 2025
 20:41:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250311142206.2045-1-m.masimov@mt-integration.ru>
In-Reply-To: <20250311142206.2045-1-m.masimov@mt-integration.ru>
From: Steve French <smfrench@gmail.com>
Date: Tue, 11 Mar 2025 22:41:02 -0500
X-Gm-Features: AQ5f1Joakb8bvYoYy1SXusb21hOdUoqGZatk-hDwb6TEKKEamC-CnIoAqjUpvm4
Message-ID: <CAH2r5msC7iL9UcS6CtD4yB-xyDEYrhXy9EWVUNxgxuLy2SsoMA@mail.gmail.com>
Subject: Re: [PATCH 0/4] cifs: Fix integer overflow while processing mount options
To: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Jeff Layton <jlayton@kernel.org>, Suresh Jayaraman <sjayaraman@suse.de>, 
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending additional
review and testing

On Tue, Mar 11, 2025 at 9:25=E2=80=AFAM Murad Masimov
<m.masimov@mt-integration.ru> wrote:
>
> These patches fix similar issues that have different origin commits.
> User-provided mount parameters are intended to have upper limits, but
> are validated after their values are converted from seconds to jiffies,
> which can lead to an integer overflow.
>
> Murad Masimov (4):
>   cifs: Fix integer overflow while processing acregmax mount option
>   cifs: Fix integer overflow while processing acdirmax mount option
>   cifs: Fix integer overflow while processing actimeo mount option
>   cifs: Fix integer overflow while processing closetimeo mount option
>
>  fs/smb/client/fs_context.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
