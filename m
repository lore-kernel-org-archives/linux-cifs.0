Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695E91B423B;
	Sat, 17 May 2025 20:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747513148; cv=none; b=qYN9nVPxvsFtL51Buj7/gCMqeGRVSfeywLaSwaL1T+9nKlktZ1PjEz8XEjgMUojM4DjdB3APxzqhJwBRBawlY7SXX493tQb0g10mA3RN/cROwYVdVvkuWruhFRCst4KpaHhyOjgAC2oL19Xl/lAwwN2EMWmHDGrWlwoqdHozxmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747513148; c=relaxed/simple;
	bh=6pvbsEhZEB3b0gGTQXE/95u0wFiKoot3I8OkEIr5VPk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrXnje2L2HWO7qpIa0h8VhprF16d2oC5CbAX/iWuPKq7rEMKW80Km3yn0cuNpBOvoCuZaLQh3W5VkJWFNJukXMHElA3eh+i7bwF/+iQ0hw5yh5ijTss8uy1ADGslljxxrhSCxY+ZENrgM/DL/rQ07iB/e31v9WtqKsxZ+aLx9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lx/EEOu8; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lx/EEOu8"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-329119a3a8eso610671fa.0;
        Sat, 17 May 2025 13:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747513143; x=1748117943; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bxe9LQxmBejqhUnY/9oT1NUiY/3f8IH0qnoMafyHVxE=;
        b=Lx/EEOu8CYuirPR7n46w1/ePuyPqztSd121scYJZsTeAjCQlL1DkkP5ShwDwA2JfWk
         T0ngK01/6igJsOZuTfx4KsjmYCjsP72i16LByHoQ3BJNKnAwWUXYhKpqnTp/qJe7YuR4
         qIjShbwCmlQb34JNoRNBfYvUb6y3Rz/9wdvF4bPoF4TeMqXFwWRAT4z8Zp2GBv8wicKF
         phyasIhPQl9aaModVh08WDDdy1UIxieDMvPyHCdle95Hx+TcRsGWyUSaO6EL0vwh+7tI
         Hm120Pl1nENjsJWdWcYJk1mjyADDfbKM+fmQJMk3HCpdlHRrLjwGGSzY8+hfOyjdAMuZ
         obOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747513143; x=1748117943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bxe9LQxmBejqhUnY/9oT1NUiY/3f8IH0qnoMafyHVxE=;
        b=lyF8D6yVZamDxFz/VGky+GBkh26zAF/UNrINK0dyizaDJW6Wz0V/ePo2rhEHPsXdEh
         frxvmFhfYmpjCZBqOk7v8UJpSqZ8kcCJ3NEGW0zqJqf0ODPcWUdnzPGXQH/ZQ/sWdczt
         nic0y4Xub4IfvpDCOH78rU4AWbOH0BUX7JS0tcHp1AUfU5t1xLCYdtXlmJMkjfoJixMa
         CLHiUPy37gW6rZ0MD5QH5+ZCDMQEwuxNOcxXVl3Xhilc5iOCV30blPBUNK1/2mgxebzw
         JqL82tPHKPSG72u2n+6QlSeKmnOb1IJE8SDceDuIVjJjJgvBgA6QuOSeEKI49DdXKS4b
         k49g==
X-Forwarded-Encrypted: i=1; AJvYcCUYOOg0Gd8U/1XnXCzu4rFOr8e1HJI2XfMM4JS9tKnUrKzP9kuBuaCNRio7RtM3PguGyneCO4IiFbu4@vger.kernel.org, AJvYcCWAv1qgHxwshBlLeOIgR8airb33bXF75g1qxcKScZR0T9w3QcM9mQFq0+KiclqL/6+QOKauoanOdDC97/vz@vger.kernel.org
X-Gm-Message-State: AOJu0YxAPZPq+iX2EdW87FgTGOJjp1nA7237B0bc/mcRlAS/GoxXEWp2
	yZ4TPBWejjS/hpdFNVOBDkxyibeZ21kSi297kNzFJrVZZU58zuwoWM9W6kdpEKuxmYefje7cKAt
	XBPAdyFT8poeuk0sfJp3vk0dJ+lmfJi8=
X-Gm-Gg: ASbGncuRlQY8xBDV1umzFVEfW9oBvRId6yg+IsdjbfaFFnacEe5tiawrI6d921ihz/v
	HmO2iUmGfu1U7KEBUJLryZvBlXPFb2GryN2tGFyXRN1ZMTf/8mISPegXs6CgFAdKJR0XNRtK5vr
	rTa6/gKpmhtT0zC311KJBeNmedXG2EhPU=
X-Google-Smtp-Source: AGHT+IEkothdgJXqrPQfNYqU/Rd588XJkNSYCLUChzj98bM0OsY/FhsdrgrpGpGUyHmz8F0GnnbR23CFlAKHqPg30iY=
X-Received: by 2002:a2e:bea2:0:b0:30b:fc16:d482 with SMTP id
 38308e7fff4ca-327f8415242mr43463481fa.3.1747513143148; Sat, 17 May 2025
 13:19:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com> <860a4f7600814b17e48dbabe1ae19f68@manguebit.com>
In-Reply-To: <860a4f7600814b17e48dbabe1ae19f68@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 17 May 2025 15:18:51 -0500
X-Gm-Features: AX0GCFuAICdLPBTAXpZ0wq1jvW_7ke3xHmJajyqQ5qd3QP6gU3K9bSgYRhEi8nU
Message-ID: <CAH2r5mvo1e3034LpCWUAuE0=dDBb7R0bMCmt80dGRWKMegRV+Q@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
To: Paulo Alcantara <pc@manguebit.com>
Cc: Wang Zhaolong <wangzhaolong1@huawei.com>, sfrench@us.ibm.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, chengzhihao1@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next

I was only able to reproduce the rmmod problem once though (without
the patch) so been tricky to test.  What server were you testing
against (I tried current Samba and ksmbd)?

On Fri, May 16, 2025 at 8:50=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Wang Zhaolong <wangzhaolong1@huawei.com> writes:
>
> > V2:
> >   - Correct spelling mistakes in the commit message, such as 'lopp' -> =
'loop'.
> >   - The titles of patches follow the same style.
> >
> > This patch series addresses a use-after-free vulnerability in the SMB/C=
IFS
> > client readdir implementation that can be triggered during concurrent
> > directory reads when a signal interrupts directory enumeration.
> >
> > The root cause is in the operation sequence in find_cifs_entry():
> > 1. When query_dir_next() fails due to signal interruption (ERESTARTSYS)
> > 2. The code continues to access last_entry pointer before checking the =
return code
> > 3. This can access freed memory since the buffer may have been released
> >
> > The race condition can be triggered by processes accessing the same dir=
ectory
> > with concurrent readdir operations, especially when signals are involve=
d.
> >
> > The fix is straightforward:
> > 1. First patch ensures we check the return code before using any pointe=
rs
> > 2. Second patch improves defensiveness by resetting all related buffer =
pointers
> >    when freeing the network buffer
> >
> > Wang Zhaolong (2):
> >   smb: client: Fix use-after-free in cifs_fill_dirent
> >   smb: client: Reset all search buffer pointers when releasing buffer
> >
> >  fs/smb/client/readdir.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
>


--=20
Thanks,

Steve
