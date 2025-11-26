Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726302C9D
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764119248; cv=none; b=T0+g92AzkMb9oEnIOd7WzP37xJ+0wgOrF48cMQQpu8mc3yCRTJjaisCaQZCLD7KedaLpl8BijxXh397qOHxGYp2UYdZby3hrsaboIhCgOou93APTRPMzZ2dl0vsPYWTgzKXetYZ5pJ4pa870ZTxUccI3F4T77Aoo6D7+9dBxdbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764119248; c=relaxed/simple;
	bh=4j4prJ1loIfsv2jK9hZf/AhlJq1vyu2k3SCgc+a0DiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C24tMYacBtdlirGe8DPEyNxAkoHNGNzg4EsBIeHQ30/9oiaBfLV0xyYUMo4dLQCfVglAVQkDtg4ibnctpEexQI5aOddUuskCyK3vJh0Ym/qUTbe0+a2Hr5Aj8INCvMZfPmuaRix3pIg8IEslomYwl1et9PSUsKEaZHm1tAuZlfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2jJBe86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2jJBe86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078A7C19421
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 01:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764119248;
	bh=4j4prJ1loIfsv2jK9hZf/AhlJq1vyu2k3SCgc+a0DiY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W2jJBe86jX0Q1jEWgMJtbB0EOn0DCWLa46xqczWnqUsnQkHpl5viQRTOZ/j0COO+W
	 LwAAabZNdt55FF7QTylxpIVy4ZuwteytBj8b1ZjjLglwc1mgsVu3rvV6R0OPAGBS0A
	 DpWw/o1l13zW9vRIpVoMVGtHuAW8Ooo3QkkIeq1iYM88gqqAZiSwHOlc3vjYH+THs1
	 8zcxiwX5eQILRvMFldZoD30EWPtDuJ6WiOJq1JrPf07sQLnWlichZuuAuXBHGjazJY
	 UBbNbr9U6dNu+47k35R8vvLT8k6zpc7upPv79LcDMaRv7gWEgKhKctJhh+gPv5aG8e
	 hV3WV5HI8smgw==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6406f3dcc66so9891040a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:07:27 -0800 (PST)
X-Gm-Message-State: AOJu0YwOBGs7tMOhXuB1b22B3PsCSYTK/KJ4tMe5SG2XWL0toiWxpgxa
	ZP5TsEpVHrBbFkqF7ghKT6UV9tU/Q49M/zH1PXbf0enthB9+anBQuZJuLfkDFFZZ+oVgTfldEaJ
	/h+yTvnJcVf+xs6QrbiRRnERJtjWNZNo=
X-Google-Smtp-Source: AGHT+IEnf08wlMbr4Q08I0+n1zOXDqkv7FG8rzgZ6TbR/EuZYOpwQBXw8/gnAR7H+t5q6Zbl5m5+Vhh99twJNTFQhjc=
X-Received: by 2002:a05:6402:13ce:b0:640:947e:70ce with SMTP id
 4fb4d7f45d1cf-64555b85acamr15860662a12.5.1764119246619; Tue, 25 Nov 2025
 17:07:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org> <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
In-Reply-To: <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 26 Nov 2025 10:07:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
X-Gm-Features: AWmQ_blBYvP1q6cepw1F9ocRFzh8URcE5zVIZr5F4HETE1xj2kMQdhzvD5ERR5Y
Message-ID: <CAKYAXd8Nb6Ay1-J0GeDUCzRDWWYtRtcU-2FZ1LrX9p8soKpaKQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 8:50=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@samba.o=
rg> wrote:
> >
> > Hi,
> >
> > here are some small cleanups for a problem Nanjae reported,
> > where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> > by a Windows 11 client.
> >
> > The patches should relax the checks if an error happened before,
> > they are intended for 6.18 final, as far as I can see the
> > problem was introduced during the 6.18 cycle only.
> >
> > Given that v1 of this patchset produced a very useful WARN_ONCE()
> > message, I'd really propose to keep this for 6.18, also for the
> > client where the actual problem may not exists, but if they
> > exist, it will be useful to have the more useful messages
> > in 6.16 final.
Anyway, Applied this patch-set to #ksmbd-for-next-next.
Please check the below issue.
> First, the warning message has been improved. Thanks.
> However, when copying a 6-7GB file on a Windows client, the following
> error occurs. These error messages did not occur when testing with the
> older ksmbd rdma(https://github.com/namjaejeon/ksmbd).
>
> [  424.088714] ksmbd: smb_direct: disconnected
> [  424.088729] ksmbd: sock_read failed: -107
> [  424.088881] ksmbd: Failed to send message: -107
> [  424.088908] ksmbd: Failed to send message: -107
> [  424.088922] ksmbd: Failed to send message: -107
> [  424.088980] ksmbd: Failed to send message: -107
> [  424.089044] ksmbd: Failed to send message: -107
> [  424.089058] ksmbd: Failed to send message: -107
> [  424.089062] ksmbd: Failed to send message: -107
> [  424.089068] ksmbd: Failed to send message: -107
> [  424.089078] ksmbd: Failed to send message: -107
> [  424.089085] ksmbd: Failed to send message: -107
> [  424.089104] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', =
opcode=3D0
> [  424.089111] ksmbd: Failed to send message: -107
> [  424.089140] ksmbd: Failed to send message: -107
> [  424.089160] ksmbd: Failed to send message: -107
> [  424.090146] ksmbd: Failed to send message: -107
> [  424.090160] ksmbd: Failed to send message: -107
> [  424.090180] ksmbd: Failed to send message: -107
> [  424.090188] ksmbd: Failed to send message: -107
> [  424.090200] ksmbd: Failed to send message: -107
> [  424.090228] ksmbd: Failed to send message: -107
> [  424.090245] ksmbd: Failed to send message: -107
> [  424.090261] ksmbd: Failed to send message: -107
> [  424.090274] ksmbd: Failed to send message: -107
> [  424.090317] ksmbd: Failed to send message: -107
> [  424.090323] ksmbd: Failed to send message: -107
> [  432.648368] ksmbd: smb_direct: disconnected
> [  432.648383] ksmbd: sock_read failed: -107
> [  432.648800] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', =
opcode=3D0
> [  432.649835] ksmbd: Failed to send message: -107
> [  432.649870] ksmbd: Failed to send message: -107
> [  432.649883] ksmbd: Failed to send message: -107
> [  432.649894] ksmbd: Failed to send message: -107
> [  432.649913] ksmbd: Failed to send message: -107
> [  432.649966] ksmbd: Failed to send message: -107
> [  432.650023] ksmbd: Failed to send message: -107
> [  432.650077] ksmbd: Failed to send message: -107
> [  432.650138] ksmbd: Failed to send message: -107
> [  432.650151] ksmbd: Failed to send message: -107
> [  432.650173] ksmbd: Failed to send message: -107
> [  432.650182] ksmbd: Failed to send message: -107
> [  432.650196] ksmbd: Failed to send message: -107
> [  432.650205] ksmbd: Failed to send message: -107
> [  432.650219] ksmbd: Failed to send message: -107
> [  432.650229] ksmbd: Failed to send message: -107
> [  432.650238] ksmbd: Failed to send message: -107
> [  432.650256] ksmbd: Failed to send message: -107
> [  432.650270] ksmbd: Failed to send message: -107
> [  450.254342] ksmbd: Failed to send message: -107
> [  450.254644] ksmbd: Failed to send message: -107
> [  450.254672] ksmbd: Failed to send message: -107
> [  450.254688] ksmbd: Failed to send message: -107
> [  450.254825] ksmbd: Failed to send message: -107
> [  450.254859] ksmbd: smb_direct: disconnected
> [  450.254866] ksmbd: sock_read failed: -107
> [  450.255282] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', =
opcode=3D0
> [  450.255342] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', =
opcode=3D0
>
> >
> > Thanks!
> > metze
> >
> > v3: move __SMBDIRECT_SOCKET_DISCONNECT() defines before including
> >     smbdirect headers in order to avoid problems with the follow
> >     up changes for 6.19
> >
> > v2: adjust for the case where the recv completion arrives before
> >     RDMA_CM_EVENT_ESTABLISHED and improve commit messages
> >
> > Stefan Metzmacher (4):
> >   smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
> >   smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
> >   smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
> >     recv_done() and smb_direct_cm_handler()
> >   smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
> >     recv_done() and smbd_conn_upcall()
> >
> >  fs/smb/client/smbdirect.c                  | 28 ++++++------
> >  fs/smb/common/smbdirect/smbdirect_socket.h | 51 ++++++++++++++++++++++
> >  fs/smb/server/transport_rdma.c             | 40 +++++++++++++----
> >  3 files changed, 98 insertions(+), 21 deletions(-)
> >
> > --
> > 2.43.0
> >
