Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FF917DFE7
	for <linux-cifs@vger.kernel.org>; Mon,  7 Jul 2025 22:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751928708; cv=none; b=sgatEw03NKg4SofvUkiYKQ56yJUKXj4dxNYtVqLfdgecbadcDsP2vxbLBWY/N2uNuC7xyi5dlcoZONun8Ken5pO4QchPH+d9NXz8mM/ePy98WtvrtJqCj3gL9sWQNTCiCAXqXbabHoMb2L0yBp5SnuYIO6WbivXGGvPi/u1oqT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751928708; c=relaxed/simple;
	bh=U5bTWCbakcVF83IumN8o0uiE9sZYfwr9aPaej40PLh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pN1+UWKIUPxFY84h95ZyEr1pXRinKk4NugqwjUiH43uqSdMBUVwLUCb5E2amduYHgvslgSkAUcZgCxj9VJam9Nr33UXZqwsoC0s1zMZ08/E+ixP15U9j21WtYzPPuZf7q21GhEF30itQeek+HbU8ojx6v/hPDAaFfHujuBxxEnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goxPYjmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goxPYjmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF692C4CEF7
	for <linux-cifs@vger.kernel.org>; Mon,  7 Jul 2025 22:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751928707;
	bh=U5bTWCbakcVF83IumN8o0uiE9sZYfwr9aPaej40PLh8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=goxPYjmHrGcUh2vOx5LVeCuAmjoaIGvidBzoXhd9dpYJRgBVs8soU2GMcp1QRMCoV
	 7thQqPJpAuJUkNi994pwxTPZRpQl0sJzldRzjiIg5JUlL450m8MJVrnj8YmEeE8afB
	 KBXgeYSPg/skHA+NMnO+1d+Ut8jsM+lCqWhMD7mS4xer/58Age+Wf0jYkdCjwAYETD
	 GxDnIAVIQr2ioMjeNr+GDXBO6FgmOQQHmqxCUIIjHA8Nhb1tlOF+r+yXu4vniupANU
	 zAm78pEdAn9+bt897GdSaLW3ImxxYrPeglVrRTHHtxnvR19ehh2/gZVSbAsKljPCvC
	 T+DeDTPR3sMfg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ae361e8ec32so750125866b.3
        for <linux-cifs@vger.kernel.org>; Mon, 07 Jul 2025 15:51:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVMbnSMFqoKQHA7rsvpW6UZWd5Q24RhQ3Oir/73zphy5NKTNkHFSKrtjuUGwwY693rtFAdptC4CAP1H@vger.kernel.org
X-Gm-Message-State: AOJu0Yx94VfACDoDCLQ70C0MkjRcJ5dd3rARcfdFH0/C5p3uc1O/QLIr
	KpyiDamn3WphxS7VIza610CnFHr8rdWbSTahBBuhr6WmQ8vNdhRJ1TzuRrzgAlpBOodNZAl5shD
	l/ZkKFx8XU8wdZAX8yhfcMIwllOuRTZM=
X-Google-Smtp-Source: AGHT+IHwOb1WLnlcpTnYdhBN+BS3RRLvNiM/gLCpSNeRpZSSmPGtDRIEPzEyTexxvVZ80B1xeOKk/z4FbEOuqpTUs1k=
X-Received: by 2002:a17:907:7e88:b0:ada:6adb:cca with SMTP id
 a640c23a62f3a-ae6b0b1f788mr77945866b.6.1751928706460; Mon, 07 Jul 2025
 15:51:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702071805.2540741-1-metze@samba.org> <CAKYAXd_KjT5qd3amwKr3p6v0nC2wURdODqHSyS6AY=KXeaR93w@mail.gmail.com>
 <f5c5155c-e53b-465d-a1e5-659ce513d87b@talpey.com>
In-Reply-To: <f5c5155c-e53b-465d-a1e5-659ce513d87b@talpey.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Jul 2025 07:51:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8XnbiqutNfzmbbvGOu9dmn+kAmrHqH3ppCMZ0DuHeo4w@mail.gmail.com>
X-Gm-Features: Ac12FXyVozb40tmTv_-dCqohg-YF6MPPVJQoB9FuHEg-XLMIc3ytGh8NpCDZsZk
Message-ID: <CAKYAXd8XnbiqutNfzmbbvGOu9dmn+kAmrHqH3ppCMZ0DuHeo4w@mail.gmail.com>
Subject: Re: [PATCH] smb: server: make use of rdma_destroy_qp()
To: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Steve French <stfrench@microsoft.com>, 
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 12:03=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> Definitely better and safer.
>
> Reviewed-by: Tom Talpey <tom@talpey.com>
Added reviewed-by tag now.
Thanks!
>
> On 7/3/2025 9:06 AM, Namjae Jeon wrote:
> > On Wed, Jul 2, 2025 at 4:18=E2=80=AFPM Stefan Metzmacher <metze@samba.o=
rg> wrote:
> >>
> >> The qp is created by rdma_create_qp() as t->cm_id->qp
> >> and t->qp is just a shortcut.
> >>
> >> rdma_destroy_qp() also calls ib_destroy_qp(cm_id->qp) internally,
> >> but it is protected by a mutex, clears the cm_id and also calls
> >> trace_cm_qp_destroy().
> >>
> >> This should make the tracing more useful as both
> >> rdma_create_qp() and rdma_destroy_qp() are traces and it makes
> >> the code look more sane as functions from the same layer are used
> >> for the specific qp object.
> >>
> >> trace-cmd stream -e rdma_cma:cm_qp_create -e rdma_cma:cm_qp_destroy
> >> shows this now while doing a mount and unmount from a client:
> >>
> >>    <...>-80   [002] 378.514182: cm_qp_create:  cm.id=3D1 src=3D172.31.=
9.167:5445 dst=3D172.31.9.166:37113 tos=3D0 pd.id=3D0 qp_type=3DRC send_wr=
=3D867 recv_wr=3D255 qp_num=3D1 rc=3D0
> >>    <...>-6283 [001] 381.686172: cm_qp_destroy: cm.id=3D1 src=3D172.31.=
9.167:5445 dst=3D172.31.9.166:37113 tos=3D0 qp_num=3D1
> >>
> >> Before we only saw the first line.
> >>
> >> Cc: Namjae Jeon <linkinjeon@kernel.org>
> >> Cc: Steve French <stfrench@microsoft.com>
> >> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> >> Cc: Tom Talpey <tom@talpey.com>
> >> Cc: linux-cifs@vger.kernel.org
> >> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing=
 and tranport layers")
> >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> > Applied it to #ksmbd-for-next-next.
> > Thanks!
> >
>
