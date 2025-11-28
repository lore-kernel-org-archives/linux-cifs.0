Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB671FC8
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 03:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764299953; cv=none; b=gcWrxNc6hnUdJ2Y606at/OBCf7iaK5IZTxRF9XEhB4rMiUOqd+2ZBKsSYL55NeNrzEqQThhc6GSMXAKnkBhbP5Pl2knHyaPJ7gqpnJgO7Q5Qeek3zEjUaIXgsPtpX6uZ8N8b8Ut2O5uW9gWcay7jdIqEYm+qAJkRbN980DFjGeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764299953; c=relaxed/simple;
	bh=FYs/MBFp68N1iTyfSYVx6m/YYUnE4Nw9pQlanRMznfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QTclOtZHazXfSpcBj3WyRBy+qG+0ivjR4oz54UyaDdxvwx3+u+0PXeEfSNSoDc6NOR5OzR986B0XzmRbb6+kXF/j8B2FHe3ZOJpNQoSiXtgkDQIinSM8dzMO9lW4w+gbnqOWv8hWn63qxnfuii+WfU/stvIliMhrsa0ZiNHTuvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qPAzVwVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qPAzVwVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF354C4AF0B
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 03:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764299952;
	bh=FYs/MBFp68N1iTyfSYVx6m/YYUnE4Nw9pQlanRMznfs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qPAzVwVCTyb36oTQ/6Lx9RszqZQSsjPXJUYL9W461N7M3R8qzjeDDle7Fg/K+m4Sb
	 YcgKxAeykOyJQFz9+SEGzYSLGLxmV8gPTllwptei6L3Ljze1Z4qYPihCI1EeyQXPJi
	 yWRJjQvTEs1/XbgPUbFNS5J5h3mxxCh1VHKFQB4wZ/3CkEFwEw1/l0hgC3uesInqtS
	 4/ZaX0QoXFfqn59HTLi+kd8sdMMc3MHh+ubOj3R2JnwqpLh1O3x931P4M76CEAvSGA
	 oGu0HsLNt/BQ4r8EY3DGjESzkSCXXrjdwfGuny7e3Yxol+mzm8hcLzL54ySmEoY7/j
	 fhIEBeOW6fhxA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6419aaced59so2152859a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 19:19:12 -0800 (PST)
X-Gm-Message-State: AOJu0Ywc1MCVfTehR9adsIUI9XOKLqulNwITFspacpjF0TxRa6GG4IhR
	IzqcYWZ9VvqivDigTOGveILr5B06bo1TpG+S68P3MUMgxM0qmN43EUgOHB6Q7tjya+g5hFZGwYL
	XP0Wh/f/GgnwiPvii+gE/Dpjf0s2HL58=
X-Google-Smtp-Source: AGHT+IH5XTvaMrPG4bnSmW+lhd1fqCfFmftv1P/fIwHE0EQlMuIIlNsmdaGaCSIA7xj6rEdYB18K0Qnfc5IHIy6TojA=
X-Received: by 2002:a05:6402:42ca:b0:640:9eb3:3686 with SMTP id
 4fb4d7f45d1cf-64554685822mr22504773a12.19.1764299951293; Thu, 27 Nov 2025
 19:19:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
 <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com> <bd2237e6-86e7-40c8-8635-8ba6c0573cbe@samba.org>
In-Reply-To: <bd2237e6-86e7-40c8-8635-8ba6c0573cbe@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 28 Nov 2025 12:18:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8QhE_=zoK3pLqd0M-8Zw8M0auTw-P5yoqe6DioGXtsaQ@mail.gmail.com>
X-Gm-Features: AWmQ_bl7Wo8372Rh5RdOEiNopn9S1Y4slRdqHCH2m32yeCmqPYNSAA9tLvanS2I
Message-ID: <CAKYAXd8QhE_=zoK3pLqd0M-8Zw8M0auTw-P5yoqe6DioGXtsaQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 12:54=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 26.11.25 um 02:07 schrieb Namjae Jeon:
> > On Wed, Nov 26, 2025 at 8:50=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.=
org> wrote:
> >>
> >> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@samb=
a.org> wrote:
> >>>
> >>> Hi,
> >>>
> >>> here are some small cleanups for a problem Nanjae reported,
> >>> where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> >>> by a Windows 11 client.
> >>>
> >>> The patches should relax the checks if an error happened before,
> >>> they are intended for 6.18 final, as far as I can see the
> >>> problem was introduced during the 6.18 cycle only.
> >>>
> >>> Given that v1 of this patchset produced a very useful WARN_ONCE()
> >>> message, I'd really propose to keep this for 6.18, also for the
> >>> client where the actual problem may not exists, but if they
> >>> exist, it will be useful to have the more useful messages
> >>> in 6.16 final.
> > Anyway, Applied this patch-set to #ksmbd-for-next-next.
> > Please check the below issue.
>
> Steve, can you move this into ksmbd-for-next?
Steve, There are more patches in ksmbd-for-next-next.
Please apply the following 6 patches in #ksmbd-for-next-next to #ksmbd-for-=
next.

3858665313f1 (HEAD -> ksmbd-for-next-next, origin/ksmbd-for-next-next)
ksmbd: ipc: fix use-after-free in ipc_msg_send_request
b9c7d4fe6e93 smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
checks in recv_done() and smbd_conn_upcall()
6c5ceb636d08 smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*)
checks in recv_done() and smb_direct_cm_handler()
d02a328304e5 smb: smbdirect: introduce
SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
340255e842d5 smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
01cba263d1bd ksmbd: vfs: fix race on m_flags in vfs_cache

Thanks.
>
> Thanks!
> metze
>
