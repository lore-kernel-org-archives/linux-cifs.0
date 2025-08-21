Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EC2277C90
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 03:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755745545; cv=none; b=Z/l2wa1jc8opN+TPAQhf5m86SSTyr1HendBP3xye2sve5mmHaGMksJE2kQuAN7rK7sbx31cPc2kJHGYMNfUXl3TyMuzEvp6OXVx2oSy4dwUoS0vbQLnK0d/+eOY1zE4IpCDu8dG+Jv8ZKn6aoQeQd4J9CI0KSVayTjk/zj1ynWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755745545; c=relaxed/simple;
	bh=hx7x5g9FwLwz1UZrqYmphj9WvoTDTNcyXxMx4qEoyAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SnD5dnBuHcW5gExNclof7fuKh+arf+6+9CaOHWtG6x41hWzGcXiz+wYlB2YQuhicI3E/bxPwWNliGMMUXL2Q5SGQmN/p4RJ5B8wuRr46y61rYLQDG/W1y/c3CRipkGA/frBoq0FkHs3/P/U3HLLVBE9Hw3tkQuWVnlIL112JFqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVDd/kP4; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVDd/kP4"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e87031ce70so36952485a.0
        for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 20:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755745543; x=1756350343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hx7x5g9FwLwz1UZrqYmphj9WvoTDTNcyXxMx4qEoyAo=;
        b=RVDd/kP4yXzSTcTQEmxwTdRAuy0v3eTPYlXNix/YoBLy77D1Bo2TIu/JdWBQgWmtjJ
         JhBjLzuuZODDLfOfPDfn59Zuv4LwjEll2tFJXOwLvVgnjWQ1GUNBZ92oeImvpdYfJT0J
         6uRLFk/Qprwo2oXOhlV3qHzeM/3ulT61dfCRNDHksS9t3XBMBgGLIyN+WPOc/PWsr71O
         pQCvs46R4mWGAH/MsV5M7Zv0k0Qh6qSR14AGfxNH5eEpJhvxoTRB+MBTbTh0u5lVkxFn
         X/JepnHX/7bMN+hQQrWtHgNtAw5lBRFY3B7vl5WAiOBA1L4zS4L4xlfbWSgTJ+VccT5K
         ZEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755745543; x=1756350343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hx7x5g9FwLwz1UZrqYmphj9WvoTDTNcyXxMx4qEoyAo=;
        b=i5g/gKIWa9zdFLDAIjdFQUfHh/LNN3zawsbxUSTUl28W9q5bWxbQgvUMn2l0LkAhGc
         SivGK+e6phX8FpjBdWLUvnLTggNZ9DCGQGlKwEgLvXLM1lhYwv1IwH6C/qkm/ixIU/YD
         sVLaBvU1adEquhf87UQj5OKKWShwBBM/Nq3CpLb2MEzTRKykvQWd3t684KZVhUevOBCk
         JMuL/RwYVJ8EvVxwrR0JjSSsFiGiA0n2PT0IKJKV+l85BWqM9ubPLSvNCxuO+g3WFcvv
         7QF3xiSQq555u5Z17AFcrx8+7gMoBaQKcI3onkkyyZbjI+P8XogXpCewSatFOYU3fzhy
         zdcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxRPznq6FmD+xaw8NNpC1VD5ERT8E5AdTSY0qjL554+YZ+LsahlYSLeJOQqSxYX8uRg1Xyuq+a2vnI@vger.kernel.org
X-Gm-Message-State: AOJu0YyPR3DsjLyEwrWbi2I+Xjo9HWquO5Up8tXoofs99YWG36ORHw3E
	6kP+mebbsnmOYvuycic4i9DygD7xMkO/Z+xA6NBySt9mSkUZ6wMf7Zv49DtJgCldt0mT8xxAbJz
	eN+DutNi66NXkOZgi6bc2ygcaCxnFlwY=
X-Gm-Gg: ASbGncvuSUqL5LGE0y1Mps1leaNltLtjP8SO+He6DoW4c0VDrOzZV8Caj6br4yThCCx
	e+tkLYwCO+xsehF87v28gQ8qojSW1fahwOZuPrgwYgP4700Fw9gbf3vuJWnsXyXjQNGBQRuSLeo
	Zz+vbWaJfgjS5uL6YX2rAYJ8xMc+mv9e4aefm94iLpCLIr1wnJ7VS6NeENufC3CN1M2oeS+miKi
	wpt6oRvkVHupXtep0VKuHDYQFnZfKVvdL4V+kqX
X-Google-Smtp-Source: AGHT+IF5YHc5QP+2T+JBdwn4a6J1sze71z+IbyONRGi6XRGHgqrqK/UgyCTQAjLKQyExxE1aPG4/qpuH3Zo8hS8aUrs=
X-Received: by 2002:a05:6214:c4e:b0:70b:43bf:29ce with SMTP id
 6a1803df08f44-70d88e0a6bfmr8867476d6.3.1755745542630; Wed, 20 Aug 2025
 20:05:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
 <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com> <aKYD0r1PLQFRWXyZ@jeremy-HP-Z840-Workstation>
In-Reply-To: <aKYD0r1PLQFRWXyZ@jeremy-HP-Z840-Workstation>
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 Aug 2025 22:05:31 -0500
X-Gm-Features: Ac12FXwYNYHNq4eJs-8piF8C6epRVQlnKfKfBqxYLlgd_62SYTDuPICzbaR2UuM
Message-ID: <CAH2r5mv=Ws3W3+mF3M1f0mfHhAXF01cfJqK+QVQ3Zf-q8_Ltxg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: allow a filename to contain colons on SMB3.1.1
 posix extensions
To: Jeremy Allison <jra@samba.org>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 12:20=E2=80=AFPM Jeremy Allison <jra@samba.org> wro=
te:
>
> On Wed, Aug 20, 2025 at 11:37:25AM -0500, Steve French wrote:
> >Samba allows this with POSIX extensions negotiated (creating file with
> >: in the name) but I am wondering if a better way to solve this (to
> >avoid any confusion with alternate data streams) is to change the
> >client to use SFM_COLON (ie the remap in Unicode where colon is
> >remapped to 0xF022 instead of 0x003A)
>
> No. Only do that mapping to Windows servers.
>
> POSIX servers should properly store the real ':' character.

makes sense


--=20
Thanks,

Steve
