Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4126B764
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 16:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760545479; cv=none; b=Rsd58to0fzy378A4xq7CEHdwGirRQQncQxiPbPogcSDAS+9gvmAXe9ohPuy6BrWxI3keSK9tna76gF/9eC9gG9iewi+c/c508qFbXqXMznGko9PModHZogKkqbsOiAK2Pjn2WvjHqxr9tbkZ94WQFtUhNVBku79k3ZPKYrYYOR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760545479; c=relaxed/simple;
	bh=NDEa7b393oOof+UrAoc6c0fFY70BtCrYw2rj8c59D0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VnqQITdt7SkUb4QFI8Ga/hSxSLlMQFJvA6JXy1WUaA2OZKtN6FDLJuk7ypuEJytJjdxHuMvd15nGtCCYC7tzIsZNXfOmKrI71BQxJoESaCBge/w35eIgO8qNdllCHbY7zbRc26VMUjjXHCRpDBRZqPWctcIq/uiu9zq+FV6m0no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdgpNt5M; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdgpNt5M"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-87be45cba29so58678166d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760545477; x=1761150277; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqHkGy7/fjPRyWV+kWEFR8BXKKYz0Livb4VHAc53lUY=;
        b=cdgpNt5MuHPV8KFzANduqffZegFkWsDSM/yTkvUhF1nTwjWFhAZ61CoBem/Ewg/iUr
         wwhYWr05PLGFZQs2ogw37M+cZ2YztY6vf/z6bIdS2aZ9AyA6rhdwSDLQu1gqgPuXgUsz
         Nwe8LdmRvRmcjaznSDuFK6Je9JZrRSON5xe/WFEy/JQRwC+ZJ3sss4zto+88l5LHuxDY
         4VbuHSIh3tkr5Oeqg/xdiLXFmMFOW19z0XQ/4EpeSOaAWRICueiZrI/97fAbsPSfDIvE
         sW9vqWc052VfouWh1ggM2ibedPK9RmHRrbyyLFonVlcdtyFA0dPCLVT4VZcl1I/CnEz+
         3ZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760545477; x=1761150277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XqHkGy7/fjPRyWV+kWEFR8BXKKYz0Livb4VHAc53lUY=;
        b=Pndqxd/69gKl+OcdJnfm8Rqw3LIHTM6ksCKSu79tFtU0NjPI/vNBLsOUUvmKaLHi4y
         chhSji+zPGJeS20AHFabKeJZh2BNP57jSkyZ9VqfYmV01Yq3YBe57kLm/nM6+KJklemy
         n9xpoxHA1/5MrbmyM4kOKYaPYVmUXQ/shlgEhBhe71jrfkJH1tfzs+23m3M2Knq35F8I
         CIEszEHHYl9JwelMT3D7Q1PuwwcNIN+afPOHtFQ2rWxTQEBMqiK1N9IKQQi0Tv63gCl7
         Q84z5q9j2OTLDxJ7wlhH6irkcom1fXyu7gJFNxknspKiOrb9GaMzTtLITfBFBLSdx3qw
         dnvw==
X-Gm-Message-State: AOJu0YxTomTnBMrpemz+MTOfMgUWYDf9/tVRiniVq4DbhhcCbtzpAEE0
	RFy5evOOTnBwXk4e5GT3gnNt6QKPLc8HjqLu9TqMW3YOmxukTynnYaq6ZY+tJTx2whXAWaUy5VG
	EKHxq1cA6QOHgA2FsmmDGfC95h5pfPNo=
X-Gm-Gg: ASbGncuiSMPY/QrD+iFvMIlyWm4Hwgn8ORKcZKR4eH4wB1wTMcxWKxk+e6l2m2Db3Z+
	xhOhuhcFIx01owrPskLPQcH3IjKW7OSsL3jaFuH3Hp/HemosQmdfnCigz/GejdBDf2m2dzM5JeA
	j3alLEREPRUxiZUj9xwJL3Z41Pxz32FlLz7nb+6e3XqjS7JepKF9z2Kh0tQi/uxTDXebB+la3+S
	CRUi/JlSabfk+l3cqPXeJt/Sa6AUaD8FLDqr85EF1j4tDU12+bcN+90qXk1NR9ysEoAVLjtzzvG
	W4zgQH+9lUC0Ke61mIQlZ4LjtiIWahIW6obg7hrnnDqoGBZliDIuVEnkPL+M7DofGKCQ7P7XTVI
	O2rrC0UBQX64eYSXVQkC/Sxa9nOsj/YJJ65zoTA==
X-Google-Smtp-Source: AGHT+IEVzZ+yLpoj1ia1wn/HsgbfqSzpJvZS6OpqjFjtVolpUr4+7TdWXEXq5uKPKk5gecG1XDu8E1ejxl7P3daRDUA=
X-Received: by 2002:a05:6214:2aa6:b0:824:30f8:ed70 with SMTP id
 6a1803df08f44-87b2107268fmr345152266d6.9.1760545476870; Wed, 15 Oct 2025
 09:24:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251015150504.1109560-1-metze@samba.org>
In-Reply-To: <20251015150504.1109560-1-metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Oct 2025 11:24:23 -0500
X-Gm-Features: AS18NWBgQv739s_NDjluG-V1hfp_W88BsgWQzXb0RipseMP32HeztWH9o4E72DE
Message-ID: <CAH2r5msUtZHp0jNWM142zyFvrqp+tLPyXR=bz+hCam_3HB5iQw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: let smbd_destroy() wait for SMBDIRECT_SOCKET_DISCONNECTED
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending more review and testing

On Wed, Oct 15, 2025 at 10:05=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> We should wait for the rdma_cm to become SMBDIRECT_SOCKET_DISCONNECTED,
> it turns out that (at least running some xfstests e.g. cifs/001)
> often triggers the case where wait_event_interruptible() returns
> with -ERESTARTSYS instead of waiting for SMBDIRECT_SOCKET_DISCONNECTED
> to be reached.
>
> Or we are already in SMBDIRECT_SOCKET_DISCONNECTING and never wait
> for SMBDIRECT_SOCKET_DISCONNECTED.
>
> Fixes: 050b8c374019 ("smbd: Make upper layer decide when to destroy the t=
ransport")
> Fixes: e8b3bfe9bc65 ("cifs: smbd: Don't destroy transport on RDMA disconn=
ect")
> Fixes: b0aa92a229ab ("smb: client: make sure smbd_disconnect_rdma_work() =
doesn't run after smbd_destroy() took over")
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/client/smbdirect.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 77de85d7cdc3..49e2df3ad1f0 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -1575,12 +1575,12 @@ void smbd_destroy(struct TCP_Server_Info *server)
>         disable_work_sync(&sc->disconnect_work);
>
>         log_rdma_event(INFO, "destroying rdma session\n");
> -       if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
> +       if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING)
>                 smbd_disconnect_rdma_work(&sc->disconnect_work);
> +       if (sc->status < SMBDIRECT_SOCKET_DISCONNECTED) {
>                 log_rdma_event(INFO, "wait for transport being disconnect=
ed\n");
> -               wait_event_interruptible(
> -                       sc->status_wait,
> -                       sc->status =3D=3D SMBDIRECT_SOCKET_DISCONNECTED);
> +               wait_event(sc->status_wait, sc->status =3D=3D SMBDIRECT_S=
OCKET_DISCONNECTED);
> +               log_rdma_event(INFO, "waited for transport being disconne=
cted\n");
>         }
>
>         /*
> --
> 2.43.0
>


--=20
Thanks,

Steve
