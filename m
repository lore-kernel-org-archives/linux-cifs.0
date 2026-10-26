Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793010473;
	b=1RgqN26WlDypdlfhBTdSZgE0hqH8dJwZVpYwGQHD0+NSQFK6FnLD8zWY4o8FC9cSJ+wK
	 FDWjnHAsaFy0m1DBDkrs0mjdKSixfIBkNXBLiigXZi1KJ0dGWIYrppKbprZCZmiVGXoiu
	 /EHlEEiTrnXPVV3iag0Gz+6BWd0T3xEB6bOkXilsZuNTUEDcnmpklA8e0TXXEyWU5ZtLo
	 GTtdOc3/i1dkgSQYzX5KNUbMs0LY/AczhStWFFtGf0A1neXylLZ691RbBy6sULCYnOdZ6
	 9KqW8dOfoy69/B2c70ApW3EQ0qErZMotekeRmJ5zxFjKlwd3UlHybLYUCHvalqS00uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010473;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=KEYF1Qdwi1jMonlg1r9rkeG0fPaEslrCIlWRFx60BpY=;
	b=r8XxK2q6/iqKgvK1JrgCMRJg73ITUwb+dr4Sx3wwPP0HdbA7bY+lspM8ThFyyEUy7xiq
	 vdkm3XTBpbbh4hO5ajA+8jG5/0IyFvtn5YoIywg0eA9F2rffA7klXalMXCCRYdTCxdXkJ
	 GOWowlJLdKcBH5vwiPAFs6+om0ms4+JE+f1M3HqyJlSwnrvKRxZVSPL2LqQpYjrEBAKPa
	 3yv3DiRv1wgVRHue9u9ncbrlzE1DgheYKetGr4WcUAQnnrrOacRcwNVtoIFHoutj3O0w6
	 5F+YPjD2O9vFRboFDGIguppxakLoewZ6HtZ3gyFtD0JajW2EkYDy714T87F/mtbpowg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lDhTrYxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5692606A322
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lDhTrYxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679171F01825
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 10:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793010472;
	bh=KEYF1Qdwi1jMonlg1r9rkeG0fPaEslrCIlWRFx60BpY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lDhTrYxZ/LjFJ5wqI4DkHleRo6MqvXfZ6fku59FGS+1+zt2gOlR+M2JtCZc18j0+D
	 EnPILqddfz+JPklwtsykX0IwJK2LE5Zn8bgNG7DyUt+ycf66zkqXwnHVDAxArSdUB1
	 wxJykDvlO2v5a10k8zt3KtksR9gFRiF6hM47XPll0Sg4KMBdupdxV7Okvkl/B/RgYk
	 s7EaJHYJ0lRNr09u/PvhPtfUoSZbJzoI0QYSBanMZg8BOX9UiujzoLoqZAiRbOqDPb
	 Z4Qmmn54qyJjYCDbX0BzhffaJLTs/q1V7KWEecJGCqt7qKs5dYJmYNIl5B1QjcY0y3
	 V3tiPMFqqnrog==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4697404c2bso354357366b.2
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 03:27:52 -0700 (PDT)
X-Gm-Message-State: AFq9FYKMTXhZJW0hSgwvZ2+mlmhvQMjBv0Z573LSYD+xAtKe+1CwDRlD
	iX/HS2SIasqroCnDr49HeNupzbp4TwNS91/bnw5zoZyMrlL1JKwInbUgr3R1/0ziDfzXqF4Fk1G
	cTDCE/mA5y9EmG8FG57c9azBXAd2mpbk=
X-Received: by 2002:a17:907:d40a:b0:c29:4fcb:2886 with SMTP id
 a640c23a62f3a-c46bde94ee9mr687168966b.39.1793010471098; Mon, 26 Oct 2026
 03:27:51 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026092537.43210-1-j.koester@act-marketing.de>
In-Reply-To: <20261026092537.43210-1-j.koester@act-marketing.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 26 Oct 2026 19:27:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_+at1TnyLB6cR29Jbmhpt92+vajY02MQ0+6j+m3jWe+w@mail.gmail.com>
X-Gm-Features: AclHuK8C0yeeXlZKoFsTsplTmdv8RRA3xkHtgibir-3-o-fFEem9X78pdRwr9LI
Message-ID: <CAKYAXd_+at1TnyLB6cR29Jbmhpt92+vajY02MQ0+6j+m3jWe+w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: ignore network devices of other namespaces
To: Jan Koester <j.koester@act-marketing.de>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 6:25=E2=80=AFPM Jan Koester <j.koester@act-marketin=
g.de> wrote:
>
> With no interface list configured, ksmbd binds every interface that
> comes up. ksmbd_netdev_event() does not look at the device's namespace,
> and create_socket() opens the listener in the namespace of the task
> raising NETDEV_UP. A container with its own address on a bridge brings
> up its interface and finds port 445 in its namespace already taken by
> ksmbd, so an SMB server running inside the container fails with
> "Address already in use".
>
> Interfaces are also matched by name only, so a container's eth0 going
> down would stop the listener on the host's eth0.
>
> Only handle netdev events for devices in init_net.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jan Koester <j.koester@act-marketing.de>
Applied it to #ksmbd-for-next.
Thanks!
