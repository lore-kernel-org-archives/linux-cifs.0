Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2175F1E0DE6;
	Tue,  7 Jan 2025 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291669; cv=none; b=ASVF91ARhAUStJFWS8t40pOWuscWUU2FM3K2hSeZDuOic1E8i38GmsSCuP5IDoSF9/ecaUeKaly5IHg8Y+CtLFuBV1wL1Zu3OgXNfKFEG82aaQcxWONj4W9pkUnPDxSEmKiM8oGl7c4OyvehPzNVUXVbI+/kR7KbuM1rqCR8NBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291669; c=relaxed/simple;
	bh=Cd3zj42kbpu7B1Mhl80YepXpQQMDBq3y8hCbf2AyoOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KEgDLtgJOU4shBAhpTSVb2Ny++7plDLajvb3PWv1Ph3E9kiUVunHvFUYBQ7sbofOsxTi+yj9ytE3zIhv3mvP0UueRVdJLjzX1RSLWvMAykKJE/jXx9v+mAciPVkQSf38q0iGnFmVHsZxSvOYj1YjjroJuW2kmAg9l/WMW8MYL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=he8fTD76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="he8fTD76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A46C4CEE2;
	Tue,  7 Jan 2025 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736291667;
	bh=Cd3zj42kbpu7B1Mhl80YepXpQQMDBq3y8hCbf2AyoOQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=he8fTD76DxzkQXqLZ+Ipe84RNHTjN6+9fx1UFkiKad0YgPmzBoDVuZRgxiVXE6QZB
	 PEMae/6lhCw2L0M/wot/EIXJJBjPbeY56ruuD1Bf9LpOWKl9tnex0i3Nvw74oxWKnX
	 JBTsCc79yDFFFcdPeW45IVS/FYSBA5xaxTCZcGfUptbCEVYw9H38RQuu7k0AwhI/uC
	 SOyICVNHMrltAwY4nexCtFowTtFxP6eQOVtuuKQ4FzSCMIZWo11PKosy7AjD+CQ2HG
	 JmsBy4ndl5sbmD8BXHeXpfi8pTWFCfsNT0U/TXkRv/LFdbbSquo5bJKS4NfEX3k80c
	 /d7yHqqXX2rBQ==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2a01707db44so5611128fac.2;
        Tue, 07 Jan 2025 15:14:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWoEnGwOY0EGTeMM5pbt8wfyU754PswmVkO/+EhYu3KmzJtDE4KMvgGgQ8L3GG7E+kdLW3qhyGO1Zj8@vger.kernel.org, AJvYcCXNhIQAGfgiEJzTl8ypxMY0jFB+0GGmWBX+3iFh4Qy06ih30FAyfU71mkfBsCNr6XA8V40LJFZCJy2WCCHu@vger.kernel.org
X-Gm-Message-State: AOJu0YyKHHClmwNHabIb+xX7RGcmKUHft+oEJbGeHbjhXZty789kmPP/
	aRi12Uy2b9XLjcS9HeOUOuAnpEBfoCf5U2INks/wrH1h4pwHzvtb2KVoYHZJs4qzSYxdWUEVbMU
	+danyXNKpiVNENkdScNr7PTXj7GA=
X-Google-Smtp-Source: AGHT+IHcMGuJJHXeR2uO2U33rZoa15FdSkF1RL+41yw3wIs9uRSPM3xWdiza4vWy3fHvbaFiQrr9pgXNirVDvFZi8VI=
X-Received: by 2002:a05:6870:ef02:b0:296:df26:8a6e with SMTP id
 586e51a60fabf-2aa06a0203amr418780fac.35.1736291666774; Tue, 07 Jan 2025
 15:14:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250106033956.27445-1-xw897002528@gmail.com> <d013fffa-8ed3-4c96-90a1-df2e7f45380b@talpey.com>
In-Reply-To: <d013fffa-8ed3-4c96-90a1-df2e7f45380b@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Jan 2025 08:14:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Dj+YCKYQNO_g4WwARcxkKCB4TZLriuzhm-u9o+kuAoA@mail.gmail.com>
X-Gm-Features: AbW1kvYF-uH6GGX8EScbIOYelEm6jYVk7St7dKTIusDSxWSjt31lgbPFKGzRvT0
Message-ID: <CAKYAXd_Dj+YCKYQNO_g4WwARcxkKCB4TZLriuzhm-u9o+kuAoA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer size
To: Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>
Cc: He Wang <xw897002528@gmail.com>, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 6:04=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 1/5/2025 10:39 PM, He Wang wrote:
> > Field `initiator_depth` is for incoming request.
> >
> > According to the man page, `max_qp_rd_atom` is the maximum number of
> > outstanding packaets, and `max_qp_init_rd_atom` is the maximum depth of
> > incoming requests.
>
> I do not believe this is correct, what "man page" are you referring to?
> The commit message is definitely wrong. Neither value is referring to
> generic "maximum packets" nor "incoming requests".
>
> The max_qp_rd_atom is the "ORD" or outgoing read/atomic request depth.
> The ksmbd server uses this to control RDMA Read requests to fetch data
> from the client for certain SMB3_WRITE operations. (SMB Direct does not
> use atomics)
>
> The max_qp_init_rd_atom is the "IRD" or incoming read/atomic request
> depth. The SMB3 protocol does not allow clients to request data from
> servers via RDMA Read. This is absolutely by design, and the server
> therefore does not use this value.
>
> In practice, many RDMA providers set the rd_atom and rd_init_atom to
> the same value, but this change would appear to break SMB Direct write
> functionality when operating over providers that do not.
>
> So, NAK.
>
> Namjae, you should revert your upstream commit.
Okay, Thanks for your review:)
Steve, Please revert it in ksmbd-for-next also.

>
> Tom.
>
> >
> > Signed-off-by: He Wang <xw897002528@gmail.com>
> > ---
> >   fs/smb/server/transport_rdma.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_r=
dma.c
> > index 0ef3c9f0b..c6dbbbb32 100644
> > --- a/fs/smb/server/transport_rdma.c
> > +++ b/fs/smb/server/transport_rdma.c
> > @@ -1640,7 +1640,7 @@ static int smb_direct_accept_client(struct smb_di=
rect_transport *t)
> >       int ret;
> >
> >       memset(&conn_param, 0, sizeof(conn_param));
> > -     conn_param.initiator_depth =3D min_t(u8, t->cm_id->device->attrs.=
max_qp_rd_atom,
> > +     conn_param.initiator_depth =3D min_t(u8, t->cm_id->device->attrs.=
max_qp_init_rd_atom,
> >                                          SMB_DIRECT_CM_INITIATOR_DEPTH)=
;
> >       conn_param.responder_resources =3D 0;
> >
>
