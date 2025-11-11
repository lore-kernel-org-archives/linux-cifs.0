Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA672561AE
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 08:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762850847; cv=none; b=JXt6UfUqOwA6oop5deP+XyY7KbWPfLhqJyU4QLzttDr5xhYFtus3HUbCmtC1vgZeihcGY/2rifpj4TouX35tR2PnmNWNw5Sj6PxFliwCM6H7kMxQyineDapCH8Yjnx8iRrKhJ6C8JaxrPJpT3YagBOKQG2xPKMeNz5jCjdCc9qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762850847; c=relaxed/simple;
	bh=2uauu+e7e2Iijj+hzAEHLbjoZXgVM4D+TCNpdSDVIvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MHriov78QCFIjE1n9dVkiAbxkmjBIiMDpI1rIYBYY9y0dF82GhXNYWQ/jgob//YHTQBp/+nAhhEUwfPEkHBRJxD5Zkt8mzoqK42LTCtalQD89riJiV5xMZq5PSN5D3MHGiLaFsL0vAj1xIdWdSooW7ffKsBiKTai+YkgZekI8RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5S3yRZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5S3yRZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32129C19424
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 08:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762850847;
	bh=2uauu+e7e2Iijj+hzAEHLbjoZXgVM4D+TCNpdSDVIvk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A5S3yRZhFBu0wHm9MDRF54snByCb7yRvJN+IghIeEnl0az/uWltKMf49/IiHIKUgt
	 NLfT6LjuzE+8PqUtqaoGCWwy04UDjirQ332jvtfLJPEY2nWaPVwgIy8vzHqDPP8qAH
	 SomxdZMNB12E/MUtFSg1WY2U46anQJQrxjzc7awkxVE5fqmEj+yWl923bPcNOffa5j
	 CVc2XkemaPMmX3ATKY5pfn8czep/BHFtssZS4aOBgRZPmscpuiUz8yWAg8qQXA6s+t
	 OkXE31wJGm0mrQhmvuf1dGuDjcSiGe5aMg8j5V4FKaEZbm11Ey+um00pWfDEHv1BQx
	 lryPZCA/TTiEg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso930835a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 00:47:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWQqE+Yk7fiOyqZq0ULakH3+F9ryabSEL4HLuLT7oWNjTFB2YeNEbjPbrUdb6xQD6T4iXNy06+MwdOH@vger.kernel.org
X-Gm-Message-State: AOJu0YzhQU2IoB3EKT73q9S293rB/ailaycL3lbHTUdvYOQ8RBtdZZjE
	soXvcbKnF20p/YVxNuX31TJHip4ig+Ln7NqvkT2PKIPRamRpVxrKlopXdA53QuspFeAdy/kShRg
	VehIX/rSgYSVACueNdealtr5Gv4wn0H4=
X-Google-Smtp-Source: AGHT+IHkQyqpu8uY/c9UPfomQHwGFx66iPjBHykE3hl/2cQehAkvE3KYP9MR7fZUJQfYxuuZp8VE4LWQAJGNO0qnxpw=
X-Received: by 2002:a05:6402:208e:20b0:640:cf58:47f9 with SMTP id
 4fb4d7f45d1cf-642e276c72emr2011860a12.9.1762850845770; Tue, 11 Nov 2025
 00:47:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030064736.24061-1-dqfext@gmail.com> <2516ed5d-fed2-47a3-b1eb-656d79d242f3@samba.org>
 <10da0cb9-8c92-413d-b8df-049279100458@samba.org> <CALW65jav2wiWzz6q6vdnjL88GJB1eWJtLVzH3M1CkOHbdgSDWw@mail.gmail.com>
In-Reply-To: <CALW65jav2wiWzz6q6vdnjL88GJB1eWJtLVzH3M1CkOHbdgSDWw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 11 Nov 2025 17:47:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8pcBaTjVpG9HQuLRqNT8yxpZmKvJypSA=EyfzyWDjAfg@mail.gmail.com>
X-Gm-Features: AWmQ_bkmXcuPhr7pfdB3NLP7MMVOO0QH8k5h9CXEl-rTvXG_N4UNf9xAwgxokSQ
Message-ID: <CAKYAXd8pcBaTjVpG9HQuLRqNT8yxpZmKvJypSA=EyfzyWDjAfg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
To: Qingfang Deng <dqfext@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 5:03=E2=80=AFPM Qingfang Deng <dqfext@gmail.com> wr=
ote:
>
> Hi Stefan,
>
> On Tue, Nov 11, 2025 at 3:16=E2=80=AFPM Stefan Metzmacher <metze@samba.or=
g> wrote:
> > >> Also remove:
> > >>    - TCP_NODELAY, which has no effect on a listening socket.
> > >>    - sk_rcvtimeo and sk_sndtimeo assignments, which only caused acce=
pt()
> > >>      to return -EAGAIN prematurely.
> > >
> > > Aren't these inherited to the accepted sockets?
> > > So we need to apply them to the accepted sockets now
> > > instead of dropping them completely?
>
> You're right, TCP_NODELAY of a new accepted socket is inherited from
> the listen socket, so it should not be removed.
>
> >
> > Actually the timeouts are added to the client connection,
> > but not the TCP_NODELAY.
> >
> > But looking at it more detailed I'm wondering if this might
> > introduce a deadlock.
> >
> > We have this in the accepting thread:
> >
> >          while (!kthread_should_stop()) {
> >                  mutex_lock(&iface->sock_release_lock);
> >                  if (!iface->ksmbd_socket) {
> >                          mutex_unlock(&iface->sock_release_lock);
> >                          break;
> >                  }
> >                  ret =3D kernel_accept(iface->ksmbd_socket, &client_sk,=
 0);
> >                  mutex_unlock(&iface->sock_release_lock);
> >                  if (ret)
> >                          continue;
> >
> >
> > And in the stopping code this:
> >
> >          case NETDEV_DOWN:
> >                  iface =3D ksmbd_find_netdev_name_iface_list(netdev->na=
me);
> >                  if (iface && iface->state =3D=3D IFACE_STATE_CONFIGURE=
D) {
> >                          ksmbd_debug(CONN, "netdev-down event: netdev(%=
s) is going down\n",
> >                                          iface->name);
> >                          tcp_stop_kthread(iface->ksmbd_kthread);
> >                          iface->ksmbd_kthread =3D NULL;
> >                          mutex_lock(&iface->sock_release_lock);
> >                          tcp_destroy_socket(iface->ksmbd_socket);
> >                          iface->ksmbd_socket =3D NULL;
> >                          mutex_unlock(&iface->sock_release_lock);
> >
> >                          iface->state =3D IFACE_STATE_DOWN;
> >                          break;
> >                  }
> >
> >
> >
> > I guess that now kernel_accept() call waits forever holding iface->sock=
_release_lock
> > and tcp_stop_kthread(iface->ksmbd_kthread); doesn't have any impact any=
more
> > as we may never reach kthread_should_stop() anymore.
> >
> > We may want to do a kernel_sock_shutdown(ksmbd_socket, SHUT_RDWR) after
> > tcp_stop_kthread(iface->ksmbd_kthread); but before mutex_lock(&iface->s=
ock_release_lock);
> > so that kernel_accept() hopefully returns directly.
> > And we only call sock_release(ksmbd_socket); under the iface->sock_rele=
ase_lock mutex.
>
> In kernel v6.1 or later, kthread_stop() in tcp_stop_kthread() will
> send a signal to the ksmbd kthread so accept() will return -EINTR.
> Before v6.1 it can actually get stuck, as accept() will block forever.
>
> If you're fixing the issue when this patch was backported to versions
> before v6.1, this will not work, because kthread_stop() blocks until
> the target kthread returns, so shutdown() will never get called. The
> sock_release_lock mutex seems redundant because of that.
> Instead, shutdown() can be called _before_ kthread_stop() so accept()
> will return -EINVAL.
>
> Namjae, should I send a v2 with both issues addressed?
Yes, please send the v2 patch.
Thanks.
>
> -- Qingfang
