Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A08193432;
	Thu, 19 Sep 2024 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726746180; cv=none; b=MX50AbZpZgKVOq8IWloxoniUSGu55RWtuHPHhPNGoOHeEM21wfXLwdQqwqK12lXtP5QgchfOeyi01QsUwNsQrf6yxgs8gKWeFwVgrt3dvZBC1EcKEu9ryd5o3r5Or8jdxtjDdNjJ35u7GtYI/hnoehpXBg0cC1RtVXJ5jDRU3po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726746180; c=relaxed/simple;
	bh=5TmbLzNY35MPG+6DijuO7RpVRl06QkUdrFsOEJAake8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2eIgIv93xaU3d1GPsGVkwQglVcBoXfhKS4D3z5ne1kQ+RiL7l4RUKBpswDdzSp+mQMGwJIeymVO/V3fhrW69rEFYx9aKsaXzAJxVAv/AnwjYVJ8qEzzPrqJ19vJl7FBRnxTE2lP+63RKH6h4t3uihfrPttX1pXkNxw/zAon7go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2STDVEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2STDVEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C61C4CEC6;
	Thu, 19 Sep 2024 11:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726746180;
	bh=5TmbLzNY35MPG+6DijuO7RpVRl06QkUdrFsOEJAake8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Z2STDVEp0SWsdE8cz181USldSfl7tKq0D8q592RkBCuQ8qPctpI4OZSZzXW75KGte
	 zZAKN1mny/Tj/XToxtfw+HPvLmGqCPDm/H08w49llY0tD4bKVvmDuMKiR/XUpzGHbd
	 KRPVzn3TAhi8KzfUQQHMyOGdoNBEoK5ulNVjLuy3ZqTyl1eg/p74rFSspnaRx3vD/L
	 GzBTv5/6EzTo0z0KbWk56Vz3hxhCtL6DkuJGk+c9iB77sHRI9L1uyv2UihF+rWA2pU
	 urmfJQ5ZkNPJjjpoLP5syXuMmg/fQdtcjbaJCvuH8A+TQIq6epU08QUqCztKRSEfjx
	 tiUUKZowVtrhw==
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3e04a6feef3so368131b6e.3;
        Thu, 19 Sep 2024 04:43:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV6UXwobDd2OOK39h3a7a1kvPBayjJlF7rRB6rKGTiK/lsrGqfdFldcTRqF5+vQ+xie7VhCfKNDGYBegrVQ@vger.kernel.org, AJvYcCX0p3l6jwXzYfAO8V7IkJA7TYvJ0MCyqFZmcVhvaTpzDjXp7FWV+zxYbMP3+wEjXf8q5l7UTvcWyOJ5vlxJT+50@vger.kernel.org, AJvYcCXuoe49sSOiOh8C0Wxf0vjdwOMUzhTE8zClF1zDZKyVwRRrgrv2Og/v9yYjK8uRaDdL/7hzRxKMsooX@vger.kernel.org
X-Gm-Message-State: AOJu0YxlYqvirlla6byXWkNSkVAVBmiGf6mOoN7Occ2AeCyw5V06Jbjl
	sdOZWeAYajS7WFPSMWhLNxFDR4aJRk8W+lI0dQDmElbsAIA8a2J0UnRaXc0irxSrVt8KZjIlrUz
	asycnwyFtdGV0GrGwSapP9uqbziw=
X-Google-Smtp-Source: AGHT+IGMHvj71v4pRxIz9H4t3dZJiQYtGoEasfwol8SunCUXrBGi2TuhnCmQuTnIqrnVRMALjf80YAFRxuBInDLw4Ao=
X-Received: by 2002:a05:6808:2181:b0:3e0:48e7:7f31 with SMTP id
 5614622812f47-3e071a850cbmr17700057b6e.10.1726746179365; Thu, 19 Sep 2024
 04:42:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820191520.100224-2-thorsten.blum@toblux.com>
 <CAKYAXd_T4JzjOVFqxSt=RQG7w0yzPX62-AihQHUepvS+80BZJQ@mail.gmail.com> <4881D699-9109-47B5-927F-B048479C48B8@toblux.com>
In-Reply-To: <4881D699-9109-47B5-927F-B048479C48B8@toblux.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Sep 2024 20:42:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9u5mxx=QY2Y64DjGNCoguCiqbDq69Xi2g6dpMJx9unCA@mail.gmail.com>
Message-ID: <CAKYAXd9u5mxx=QY2Y64DjGNCoguCiqbDq69Xi2g6dpMJx9unCA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: Replace one-element arrays with flexible-array members
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2024 at 6:12=E2=80=AFPM Thorsten Blum <thorsten.blum@toblux=
.com> wrote:
>
> Hi Namjae,
>
> On 22. Aug 2024, at 14:01, Namjae Jeon <linkinjeon@kernel.org> wrote:
> > On Wed, Aug 21, 2024 at 4:15=E2=80=AFAM Thorsten Blum <thorsten.blum@to=
blux.com> wrote:
> >>
> >> Replace the deprecated one-element arrays with flexible-array members
> >> in the structs copychunk_ioctl_req and smb2_ea_info_req.
> >>
> >> There are no binary differences after this conversion.
> >>
> >> Link: https://github.com/KSPP/linux/issues/79
> >> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> >> ---
> >> Changes in v2:
> >> - Use <=3D instead of < and +1 as suggested by Namjae Jeon and Tom Tal=
pey
> >> - Link to v1: https://lore.kernel.org/linux-kernel/20240818162136.2683=
25-2-thorsten.blum@toblux.com/
> > Applied it to #ksmbd-for-next-next.
> > Thanks!
>
> I just noticed this patch never made it to linux-next and I can't find
> it anywhere else (also not in #ksmbd-for-next-next).
>
> Maybe it got lost because it has the same subject and a very similar
> commit message as [1] (I submitted both around the same time)?
Sorry for missing it. I have pushed it to #ksmbd-for-next-next again.
Thanks for your report:)
>
> Thanks,
> Thorsten
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D7c525dddbee71880e654ad44f3917787a4f6042c
