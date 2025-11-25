Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFC62DC798
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 23:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764114616; cv=none; b=DylJe7GfDDpqT/OyyePeT4bJgD/dlBKjbBHkghVeACCD9s8wni2ddY0uKequixJGLXyUouFH5gFS+NtbqiFj9o7diUtzOugxquMKT7KIm970yLm8E5vJMTrfjP9VeId//7Erl6MwMkr/XSsdJhkhjvS9TZL1oZ5D4d7kj3o/ofY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764114616; c=relaxed/simple;
	bh=GX0zS8yFKKUA74p/E5iY1dLwzo6U23ycY15DSqD8Y8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U2FzP0Tt2CLfkZqTf/ocnO+TcGgZMPk27+PjFLJRQdxpOFNMHS6+1WdVB3JqD0M0A5a5Ej3a8mnPGBW6PGajxaJgW0lAG4jK8S8pu+AQ8270C2LKOtkmbUnonR9sPJqHEtteToyUEjc3h45QIKrztBfmSG9rz1NQKnKTuGlPILs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrBABbpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrBABbpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED23DC16AAE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 23:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764114616;
	bh=GX0zS8yFKKUA74p/E5iY1dLwzo6U23ycY15DSqD8Y8s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NrBABbpgKm3uaf+5zk5yedMvZf5fe6pUeMQS2o3nUlDjNhRw7x5kY5iipy9/JD6Ta
	 DXKN6b27MVyzno7IEru8zHgfLoAM5+7XmHslLQIm20xjmYjD34YDX2bvBoEJxR1fp3
	 h4qgO2N0n2uKkadyGpnrFaE3UnI2LnVVD62jxqSbmyz2J0I00Zsa03yM76ByTqsmRt
	 1iX8S2cyf1YGCl80QANoluCKQpI6l37r5+FrRs4bj4tINThYBnlaUmBMWVHKv4GHe4
	 n3gDHRGlmUWdU4PjpVO/9iHS40Uf5vtN+cnafeD9anFM54S7eSHUWalGt2FGBXpo6v
	 tENtIOcf7xKfg==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so8125097a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 15:50:15 -0800 (PST)
X-Gm-Message-State: AOJu0YytD4TRPi4y7Yyjh29wHqdoSEa6BRW7aMCPAOvliki/PmHQ25aw
	1qrTigDVq19CxeDg/uI525hmaikfD1MY8BH48OyomJAI1GxbqMk05DXhaLcm2pvekRbFwT1ixvp
	l2HNBSSTw0651jH7lLDptuLyxzDXFxhY=
X-Google-Smtp-Source: AGHT+IEceXWiE+qu3Cng5/TzNRNwtaP1qD56ZRdr8ZNTUzgSUnc6nIYNwy/lyOVTfNaarFJ095CIJvnnXmr5TOevKAY=
X-Received: by 2002:a05:6402:50ca:b0:641:3492:723d with SMTP id
 4fb4d7f45d1cf-64555b99b3amr16169695a12.11.1764114614477; Tue, 25 Nov 2025
 15:50:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764080338.git.metze@samba.org>
In-Reply-To: <cover.1764080338.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 26 Nov 2025 08:50:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
X-Gm-Features: AWmQ_bkKH09Q3KyrboAo3Oolfz1cOSS2TN_FlIqIx-cEwAjBN9KjT38y4emzjo0
Message-ID: <CAKYAXd_HKKBKx_B7+Z+b_jt+rHazuMkskYYPAp6BROPuy0uBfA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] smb: smbdirect/client/server: relax
 WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 11:22=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi,
>
> here are some small cleanups for a problem Nanjae reported,
> where two WARN_ON_ONCE(sc->status !=3D ...) checks where triggered
> by a Windows 11 client.
>
> The patches should relax the checks if an error happened before,
> they are intended for 6.18 final, as far as I can see the
> problem was introduced during the 6.18 cycle only.
>
> Given that v1 of this patchset produced a very useful WARN_ONCE()
> message, I'd really propose to keep this for 6.18, also for the
> client where the actual problem may not exists, but if they
> exist, it will be useful to have the more useful messages
> in 6.16 final.
First, the warning message has been improved. Thanks.
However, when copying a 6-7GB file on a Windows client, the following
error occurs. These error messages did not occur when testing with the
older ksmbd rdma(https://github.com/namjaejeon/ksmbd).

[  424.088714] ksmbd: smb_direct: disconnected
[  424.088729] ksmbd: sock_read failed: -107
[  424.088881] ksmbd: Failed to send message: -107
[  424.088908] ksmbd: Failed to send message: -107
[  424.088922] ksmbd: Failed to send message: -107
[  424.088980] ksmbd: Failed to send message: -107
[  424.089044] ksmbd: Failed to send message: -107
[  424.089058] ksmbd: Failed to send message: -107
[  424.089062] ksmbd: Failed to send message: -107
[  424.089068] ksmbd: Failed to send message: -107
[  424.089078] ksmbd: Failed to send message: -107
[  424.089085] ksmbd: Failed to send message: -107
[  424.089104] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', op=
code=3D0
[  424.089111] ksmbd: Failed to send message: -107
[  424.089140] ksmbd: Failed to send message: -107
[  424.089160] ksmbd: Failed to send message: -107
[  424.090146] ksmbd: Failed to send message: -107
[  424.090160] ksmbd: Failed to send message: -107
[  424.090180] ksmbd: Failed to send message: -107
[  424.090188] ksmbd: Failed to send message: -107
[  424.090200] ksmbd: Failed to send message: -107
[  424.090228] ksmbd: Failed to send message: -107
[  424.090245] ksmbd: Failed to send message: -107
[  424.090261] ksmbd: Failed to send message: -107
[  424.090274] ksmbd: Failed to send message: -107
[  424.090317] ksmbd: Failed to send message: -107
[  424.090323] ksmbd: Failed to send message: -107
[  432.648368] ksmbd: smb_direct: disconnected
[  432.648383] ksmbd: sock_read failed: -107
[  432.648800] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', op=
code=3D0
[  432.649835] ksmbd: Failed to send message: -107
[  432.649870] ksmbd: Failed to send message: -107
[  432.649883] ksmbd: Failed to send message: -107
[  432.649894] ksmbd: Failed to send message: -107
[  432.649913] ksmbd: Failed to send message: -107
[  432.649966] ksmbd: Failed to send message: -107
[  432.650023] ksmbd: Failed to send message: -107
[  432.650077] ksmbd: Failed to send message: -107
[  432.650138] ksmbd: Failed to send message: -107
[  432.650151] ksmbd: Failed to send message: -107
[  432.650173] ksmbd: Failed to send message: -107
[  432.650182] ksmbd: Failed to send message: -107
[  432.650196] ksmbd: Failed to send message: -107
[  432.650205] ksmbd: Failed to send message: -107
[  432.650219] ksmbd: Failed to send message: -107
[  432.650229] ksmbd: Failed to send message: -107
[  432.650238] ksmbd: Failed to send message: -107
[  432.650256] ksmbd: Failed to send message: -107
[  432.650270] ksmbd: Failed to send message: -107
[  450.254342] ksmbd: Failed to send message: -107
[  450.254644] ksmbd: Failed to send message: -107
[  450.254672] ksmbd: Failed to send message: -107
[  450.254688] ksmbd: Failed to send message: -107
[  450.254825] ksmbd: Failed to send message: -107
[  450.254859] ksmbd: smb_direct: disconnected
[  450.254866] ksmbd: sock_read failed: -107
[  450.255282] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', op=
code=3D0
[  450.255342] ksmbd: smb_direct: Send error. status=3D'WR flushed (5)', op=
code=3D0

>
> Thanks!
> metze
>
> v3: move __SMBDIRECT_SOCKET_DISCONNECT() defines before including
>     smbdirect headers in order to avoid problems with the follow
>     up changes for 6.19
>
> v2: adjust for the case where the recv completion arrives before
>     RDMA_CM_EVENT_ESTABLISHED and improve commit messages
>
> Stefan Metzmacher (4):
>   smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
>   smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
>   smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
>     recv_done() and smb_direct_cm_handler()
>   smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
>     recv_done() and smbd_conn_upcall()
>
>  fs/smb/client/smbdirect.c                  | 28 ++++++------
>  fs/smb/common/smbdirect/smbdirect_socket.h | 51 ++++++++++++++++++++++
>  fs/smb/server/transport_rdma.c             | 40 +++++++++++++----
>  3 files changed, 98 insertions(+), 21 deletions(-)
>
> --
> 2.43.0
>
