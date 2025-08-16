Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D0D2BB13
	for <linux-cifs@vger.kernel.org>; Sat, 16 Aug 2025 00:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305461; cv=none; b=GiE6CTrcEp1JwfreTGFGzYyV/BQuhSpYvLKZg3tGLEa2tOoBVVOV99Z+53pIE0IuAa//ZQ0buPrcFxKkLvP2zByM1bhMGyqJCYBXSWKaiJZ8J7eqdVQQZU6i9akH3dhBBf/s8DC9JAwi9PFy1HwooVaDNKSa9zYjS1CPZKlFyfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305461; c=relaxed/simple;
	bh=7y09Mq2CFDGTBDTGQCKT+BFeXsZGJ4Z/7RQV8Qo9mms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqFb4l+kCV3JWZhG0M4yKe8BT88I0087/nos8kTBqh/RhApNcKVkWuA7lBE1LSpt8jNeHpv6hEquiVkGS4XEwU5twgtMruVJV6PYwe1PtTMHfoCmDa0t+KhTWQHAZk3iv6kmqEFwZhcNahcXjkK3/wyf8iOalmHs/A1+tQ3KA6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOorGqB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOorGqB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4C5C4CEF4
	for <linux-cifs@vger.kernel.org>; Sat, 16 Aug 2025 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305460;
	bh=7y09Mq2CFDGTBDTGQCKT+BFeXsZGJ4Z/7RQV8Qo9mms=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iOorGqB05D6cGjM85r775PMq9bVumuUojmTEr4vBHCBbC8R9EINkva5aTty5/5eAv
	 Nd17pPFUviooD69KtwqCs+9DF9jP6RhzqRWX4iecX+DIO3rb6zqiG1wvu80P8M7Bdx
	 eQlTQ0ElfkdMaeppj3lzeDXMnBXW2MK8GmzKh9osxF+9ze+wdczxd6NIHkyGE6z4jY
	 9QkE84cggyjeo2NVho1Pp2AKZEBnoBBrI+FFsKkngm2bS843Js71PXzYysOgNYXQsN
	 xynmXC6i/UIV8oYxhs2+of1FjXh0Fynuq0ycKsA6GqmO5EMCw0NLajxwRYi37Alfum
	 iO13IqFxrJLbQ==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-619487c8865so516255a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 17:51:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVQ6rUXzrp3LMazKjxI0Bzf4xH0VFGTjdq02GNH6cdF+vEhAX6sLBpOuMDCi+rKuBMJzoFiRBl7/JxE@vger.kernel.org
X-Gm-Message-State: AOJu0YwhYWaZKzKIld3COwrIhol30VMPy6dBNcVtzpDW0aP1A2EBmXm2
	YFqVDzXd6EEplSjPRCXoTWZ3VYDh0bIt21kqf7X/DSUMCrFkQCtl4JLnGDIHiEwx4/YwYDpF8T9
	zkTFcUgJOhfnj6Qig3w1Kol4cye7k79Q=
X-Google-Smtp-Source: AGHT+IH1cms2RXPhA979vs/ivjAptmBa9x7gzf/DTxaLEdzgWQlbdmquwWGjLuy31N5baDj3oNGH7gBHk6FpsqxpfZ4=
X-Received: by 2002:a50:9f04:0:b0:618:198a:647c with SMTP id
 4fb4d7f45d1cf-6189199fab8mr5245793a12.1.1755305459521; Fri, 15 Aug 2025
 17:50:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aa1772e6-690e-477f-adcb-400ccb17d219@samba.org>
In-Reply-To: <aa1772e6-690e-477f-adcb-400ccb17d219@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 16 Aug 2025 09:50:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_RjrYHve7OYLxPuKTeJGZeo1G0bz=hdJKo0QwH7_0YAw@mail.gmail.com>
X-Gm-Features: Ac12FXwxeoCDptjX_jKEqJUmfwWf85a9_qJQUOJpea2CpWqyI6Q5X5wrKqPvP9I
Message-ID: <CAKYAXd_RjrYHve7OYLxPuKTeJGZeo1G0bz=hdJKo0QwH7_0YAw@mail.gmail.com>
Subject: Re: ksmbd: limit repeated connections from clients with the same IP
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 16, 2025 at 12:42=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi Namjae,
>
> this commit relies on IPv4 only, which is wrong!
> Can you please have a look, thanks!
Okay. I will do it.
Thanks!
>
> commit e6bb9193974059ddbb0ce7763fa3882bd60d4dc3
> Author: Namjae Jeon <linkinjeon@kernel.org>
> Date:   Tue Aug 5 18:13:13 2025 +0900
>
>      ksmbd: limit repeated connections from clients with the same IP
>
>      Repeated connections from clients with the same IP address may exhau=
st
>      the max connections and prevent other normal client connections.
>      This patch limit repeated connections from clients with the same IP.
>
>      Reported-by: tianshuo han <hantianshuo233@gmail.com>
>      Cc: stable@vger.kernel.org
>      Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>      Signed-off-by: Steve French <stfrench@microsoft.com>
>
> I came to it because smatch reported this:
>
> Warning: server/connection.c:53 function parameter 'inet_addr' not descri=
bed in 'ksmbd_conn_alloc'
>
> Thanks!
> metze
