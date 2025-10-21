Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4990F223707
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 06:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761029530; cv=none; b=Qd4ypHE+7CWSA++50L+aORA4IQxsWvywoA1DEyEMKWOXuDv6F+zMyy+c8uwfoUYMsgkszsNPDOg44uYmWSghelSynL06lqe6/zbkEhAlUjb8wmI1lI70qzjvf1GoNjKYJsKqAhhHqu/J0WQv68r9Gc8uqupDT8Ay4S4xkuBF67k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761029530; c=relaxed/simple;
	bh=sn2oVwNS+TozRSZUOIzYvrxL5Ano16/PHHOHPc8rOcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DalHl7/JAq5kk8fxf3dUhjwqQFpDX8LhA35mT3djn+ZsAthr3wtzVGAJnPyIDuWtOfWWew/5ycvYDOPYFKsbnAX5h6pubWn7PNrMeaYxrEHbHTKfczXrFE8URcrPl5jBqFzafzBzgAYTv4GscNZ/N1M76tdWLw0VTOVTvSoHoYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnej4HOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnej4HOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DA7C4CEF1
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 06:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761029529;
	bh=sn2oVwNS+TozRSZUOIzYvrxL5Ano16/PHHOHPc8rOcA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bnej4HOwelhXTLL32Ygz2bYk2/QYpTl7sDs/x2ZvgN+erBRSwsN/juVJvVPUMTF8a
	 Cuod+l+YB+NYl4jh+RLbb0vw2glEY+bPB3sGSizFUX4M2lSDCYciXQ0SjmBnYKocbE
	 +U2aaTX7n3EGOvvyzsOsThip+PCQiT0/wA2rZOJJejaVeS9CC7ZKgbPjGLMnQ3Iaga
	 5kYkX39h0jcYTpGZkeKFavJ5s5oWFT4NYqHytv6ytl2Llz+fB4IoXFi8U5n8lsdfIe
	 wZs6ET1LtF4P97YmDWVlwAA4LRzF9RInBPYAfFy4FUWsjZJsGpVhF7p5e23GIlruGt
	 5mFSxz2zfIHiQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-63c523864caso6611115a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 23:52:09 -0700 (PDT)
X-Gm-Message-State: AOJu0YyWdeaux19JHu78SxF6GpvjK98Tq+M04iSnsagEpxz5Fp0NTsBC
	jkd5E+waIlxQeTpSZaH3HhGPwiGn0FBVFlv8PTBAeHISuZlqXDodgjR+fykIRGyq13wte7L4Mn1
	yyejj2X9zrZyXaGcQMQ3NaL463IWI8io=
X-Google-Smtp-Source: AGHT+IFZNDKNWJa48C/FXExjke0/+yALeZkgGB9ynQVEz6IqFXNklSnl/HfM6TIrj1PZHpT8Uxy7FEc57DZ1+JBCd2o=
X-Received: by 2002:a05:6402:5252:b0:63a:294:b034 with SMTP id
 4fb4d7f45d1cf-63c1f634868mr15205207a12.13.1761029528359; Mon, 20 Oct 2025
 23:52:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760984605.git.metze@samba.org>
In-Reply-To: <cover.1760984605.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 21 Oct 2025 15:51:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8KQzA+0HoEFpfHj4rNRjkbhkUQn0P2dOgmr_bx_64XLg@mail.gmail.com>
X-Gm-Features: AS18NWAgxtJNHqWVefs6e3Lo8TZ4yADtDXKQ6fcO_ZG8HqiIEATt5ATIWq5VxXY
Message-ID: <CAKYAXd8KQzA+0HoEFpfHj4rNRjkbhkUQn0P2dOgmr_bx_64XLg@mail.gmail.com>
Subject: Re: [PATCH 0/5] smb: smbdirect: introduce local send credits
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 3:36=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> our client already has some logic to prevent overflows of
> the local submission queue for ib_post_send(), if the peer
> granted more credits than we asked for.
>
> But it's not as easy as it could be.
>
> I guess that won't happen against Windows, but our git
> history indicates this could happen.
>
> Now we have a loop of local credits based on our send_credit_target.
> With that we always try to get a local credit first and then
> get a remote credit. When we got both we are able to
> mark the request as pending in order to keep the
> existing logic based on the pending count working.
> Removing or changing that is a task for another day,
> when all code if in common between client and server.
>
> For the server this is a real bug fix, as such a logic was missing
> before.
>
> For the client it's not strictly required for 6.18, but
> I think we should keep things consistent, as it will reduce
> churn on my 6.19 patchset, which already has about 100 patches
> and brings things into common code. And more is comming there...
>
> Stefan Metzmacher (5):
>   smb: smbdirect: introduce smbdirect_socket.send_io.lcredits.*
>   smb: server: smb_direct_disconnect_rdma_connection() already wakes all
>     waiters on error
>   smb: server: simplify sibling_list handling in
>     smb_direct_flush_send_list/send_done
>   smb: server: make use of smbdirect_socket.send_io.lcredits.*
>   smb: client: make use of smbdirect_socket.send_io.lcredits.*
Applied them to #ksmbd-for-next-next.
Thanks!
>
>  fs/smb/client/smbdirect.c                  |  67 ++++++++-----
>  fs/smb/common/smbdirect/smbdirect_socket.h |  13 ++-
>  fs/smb/server/transport_rdma.c             | 106 +++++++++++++++------
>  3 files changed, 129 insertions(+), 57 deletions(-)
>
> --
> 2.43.0
>
>
