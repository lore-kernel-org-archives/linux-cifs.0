Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2BF381EB4
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 02:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792202841; cv=none; b=ILeCsuNgcI9+4nZNAL5z1i7x0/bznsYVHZ0f2AnoeACA31pkaybjO3sK/Zto0U/wRzhnyY92CY3KLVcpf1pJLbmqLLUK7/coc7ZQE9xby7gTmspJ2nUdRQz+7abQK1Xolp9BswgYydqRBxgulhYlVtGMY1vaTQtvLDOoUFpGFyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792202841; c=relaxed/simple;
	bh=Q/W9XvZDp/OBJmW8p6m8XXeXFkDn5eEpecF7AJ4/4TE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n6RscGcNEpWikLzaY02FDE9ZwD0f7VGm38+qojzZQbcbHa2hlS2kVrqwTfiUGWO2kaehQybe1NwPucsV5HjUZ/UWPX8NC8jvNdmDaqTK6dIGe1JkOKsuvjVV54DyOAdhO/vHlGmChtVbvEZ1EBgyGyxYZWQfoCD24rnprMWAZQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8pfQXLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8pfQXLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761561F000C8
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 02:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792202839;
	bh=Q/W9XvZDp/OBJmW8p6m8XXeXFkDn5eEpecF7AJ4/4TE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X8pfQXLX8QslHeafB7veVWG2XXqzP8dLGQHNOkyKDsng0HnHxv5z9Ni6ucPkWgW+n
	 uxwazvuU4VSMhG4hc+W97Ijsm9zhv6AwSwv4ZTHYrWF/zTeiMC5WLOrsZSrKAcRtGU
	 LVrtzzV+JpOUVhwnvgA6JARnzd9Qtj+Y6duTYHohn0hxj9f5bGbruF1nAxz+VOm/v5
	 NT3gXb20tpK5pjsm9a4jVIXzcMzanY4SlU52QCRMF2cA2oNotAzliHcrpZ7aZHPrer
	 bfssefhy5cQdH+lFi/lQf77ZdRQmAeRivw+ppMLDRPLxGyxUbtPYOQkqNJ6Tu2xGB/
	 REPskSUGzOiHg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c263415982eso56598066b.0
        for <linux-cifs@vger.kernel.org>; Fri, 16 Oct 2026 19:07:19 -0700 (PDT)
X-Gm-Message-State: AFq9FYLXi6RSljMBGM0yh7oJrGqi+Jiq0Zdlz5tTqPE1wAQIRDfMI6oY
	RRSutrj+ZPC2LKYuWrNOsTAsw/XBoyDehmjB8Z7eM3hQNs3jaPqNybe09NU/8xr7NPaPAHKvONj
	6q4SiruqaFjJX51oSAOwVJ1L3FsIRIDg=
X-Received: by 2002:a17:907:d113:b0:c25:2e93:289e with SMTP id
 a640c23a62f3a-c419da41874mr108325166b.16.1792202838097; Fri, 16 Oct 2026
 19:07:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANTrAmy-Py3s30cCJC8Z+fG-Kk0JY+ihHrawGMMJQsOJCoqn-A@mail.gmail.com>
 <CAKYAXd8oh3xNWV+nnTmgudZeVTYzKCUQS9-CcDsOXXS6MDpLaw@mail.gmail.com> <CANTrAmxZH=+dfz-wpknNpBAbRS8Za04sQFLnGNcs4yeZ7Vp-WA@mail.gmail.com>
In-Reply-To: <CANTrAmxZH=+dfz-wpknNpBAbRS8Za04sQFLnGNcs4yeZ7Vp-WA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 17 Oct 2026 11:07:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd97K5e7PRvcrvp=6uoVL=gYyGaYGH2w7kXMyTRuAtX8iA@mail.gmail.com>
X-Gm-Features: AclHuK8iX-U1Ba2XmTw7UKEZwYeajpGW_Q9o72CALzJUTBBVWjK1MWSdZjsBBPI
Message-ID: <CAKYAXd97K5e7PRvcrvp=6uoVL=gYyGaYGH2w7kXMyTRuAtX8iA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle
To: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Cc: linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>, sfrench@samba.org, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 10:31=E2=80=AFPM =EC=9D=B4=EC=84=B1=ED=98=84 <ihope=
nre@gmail.com> wrote:
>
> Sending the formatted patch as requested, also inline below.
Applied it #ksmbd-for-next.
Thanks!
