Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5620023AB86
	for <linux-cifs@vger.kernel.org>; Thu,  3 Jul 2025 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751548020; cv=none; b=EhmTkIxFR9w8tksflwlIHtVlwNtw7CEyFImLisQB7nf+1qhISRvR3X1TmlhL5qOLJHQi+ijaEPOdDJ5AHZ1zlTCV/hZWldTRwIBYoYFdVyOhHKe7zMPzvnaIuDagcho6F6KZ2d9tE7iLfJrVMvoDJrzr03DcR81i98ZCucKuCqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751548020; c=relaxed/simple;
	bh=Z4w5m5CpgHFF6Tkqd9q7I7U3lx/nZIgUpB3h4mvQxNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D78iFVoGnCja29zH1Qoa2jfjOuUfHNG5ZKNlGmq8ndJO1SjY07s9O5l3zNMBMziv5xL6jqHi13oYbsv7tBT+lA387SeK9/n1+zzWy1nPUUyxUYlCtJ0IPC2aeovqba58YvrMRYsZO+XNW+iooCO6d/oG+F7HQTHopooTPyKtDVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2NuhnTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2NuhnTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF45C4CEF1
	for <linux-cifs@vger.kernel.org>; Thu,  3 Jul 2025 13:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751548019;
	bh=Z4w5m5CpgHFF6Tkqd9q7I7U3lx/nZIgUpB3h4mvQxNU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U2NuhnTDicer7wc5fwHHe2J+HiSWBwmyQ3nw95GM/LmRgIRPCkFq/VwXKH+5jqWZl
	 6CveNIsQwUYQztslBy0OAuO3j7UIXA7Y6AsdT6WtkwI+/y9TzO3mfEiY3pyw8dWOGT
	 zShu7zm5xg71UnW/t50id4cDqq3hhDTxBO4F80FhLe6DqWn4g4j/Y9rfGPNPOa7v65
	 e1Ud9yiwUh7yY5g03lUd41iVlH6Yzx2/SUfFp9Sb2nJuuMIED1HC16o4228MWpKcbL
	 VWUtqDhhPNX+vQW+9cNqFgnjLp2fKOmF/tWmH8IQ1FfAYyQEtDDn8hGFB+LGmt2SzM
	 ii75oLhniSbAw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso14074503a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 03 Jul 2025 06:06:59 -0700 (PDT)
X-Gm-Message-State: AOJu0YzsXyNJgb75HkUkQqihKFXpnnQC8Gg6yYnn/VBRaA3YSkl2iMmg
	rJaOiozSIiLCEWCGSXYcXvHx5bUeVvvq9o1PXOD/9LXMb6miKGxdlGJt2F8S1nDbkGuXVEvgkbQ
	BK7deioaC/uJMWfj0YttnU07H8I3mfa8=
X-Google-Smtp-Source: AGHT+IE3D9KLkoCi8UAoCLGcElF1OMy8eyJvYPFsLyKB1+RZTcGKRRnlAb+qEZ8UReMSgYiAfduEIoS1QOjdQUZeSCc=
X-Received: by 2002:a05:6402:1e8c:b0:608:64ef:3807 with SMTP id
 4fb4d7f45d1cf-60e6ca8f86bmr3149298a12.0.1751548018392; Thu, 03 Jul 2025
 06:06:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250702071805.2540741-1-metze@samba.org>
In-Reply-To: <20250702071805.2540741-1-metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 3 Jul 2025 22:06:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_KjT5qd3amwKr3p6v0nC2wURdODqHSyS6AY=KXeaR93w@mail.gmail.com>
X-Gm-Features: Ac12FXyT9zgAz8TIEGHjE4HVyLzYvH2IZvEQO7uDNJ5bIZDJeOmBtbsn2WtIpYc
Message-ID: <CAKYAXd_KjT5qd3amwKr3p6v0nC2wURdODqHSyS6AY=KXeaR93w@mail.gmail.com>
Subject: Re: [PATCH] smb: server: make use of rdma_destroy_qp()
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <stfrench@microsoft.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 2, 2025 at 4:18=E2=80=AFPM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> The qp is created by rdma_create_qp() as t->cm_id->qp
> and t->qp is just a shortcut.
>
> rdma_destroy_qp() also calls ib_destroy_qp(cm_id->qp) internally,
> but it is protected by a mutex, clears the cm_id and also calls
> trace_cm_qp_destroy().
>
> This should make the tracing more useful as both
> rdma_create_qp() and rdma_destroy_qp() are traces and it makes
> the code look more sane as functions from the same layer are used
> for the specific qp object.
>
> trace-cmd stream -e rdma_cma:cm_qp_create -e rdma_cma:cm_qp_destroy
> shows this now while doing a mount and unmount from a client:
>
>   <...>-80   [002] 378.514182: cm_qp_create:  cm.id=3D1 src=3D172.31.9.16=
7:5445 dst=3D172.31.9.166:37113 tos=3D0 pd.id=3D0 qp_type=3DRC send_wr=3D86=
7 recv_wr=3D255 qp_num=3D1 rc=3D0
>   <...>-6283 [001] 381.686172: cm_qp_destroy: cm.id=3D1 src=3D172.31.9.16=
7:5445 dst=3D172.31.9.166:37113 tos=3D0 qp_num=3D1
>
> Before we only saw the first line.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
Applied it to #ksmbd-for-next-next.
Thanks!
