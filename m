Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DFDF9C1
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 00:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754870812; cv=none; b=IQd6N5Tw3eCEZGyDSREdfv7pIrkyhAeGwcP6ZQ3xjnM+pW89vLfNr2Bu2rYss1sOvu2cDdR3DE21faPVnl2/8rJ7N/ZwVQYrkLnJ/8lTb8TSjvPGL7aBJXUvZpTtjGXiXx0NRhWKEv5AzRrTrP0d1SRNviee9haxfhk5cPiOGW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754870812; c=relaxed/simple;
	bh=nPB5zoVvK40cjsWU9LJykUfhIO4fsAqjAOUt1KqqH2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PEPA7HUkNcWtKs7VcklqGZZJ9xEGMDO8CkqMGWRThiFzPgvV/vsnCWjlhRHK7Ot/kCdVcOI5uICVDChK/65MTnkbq+uuIxYxCmAtpe6h944fb1lfazqz92FcxJl4Jl0nLQENvyp1S1LtfWOop+G5+WXHi3qSDNU9HsnDQxrs8Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=casjGMxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="casjGMxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB329C4CEEB
	for <linux-cifs@vger.kernel.org>; Mon, 11 Aug 2025 00:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754870811;
	bh=nPB5zoVvK40cjsWU9LJykUfhIO4fsAqjAOUt1KqqH2M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=casjGMxd50wGYa3b0Cli9gdX7i3rh882xJcRRg344KLC7/CefWO8S2N+gABlmMte7
	 KRiOh/h0ohqrEhKYS0gpQAkgJqLuhlMTLZG9vFG0CNfmSo2B/Aq4DzQhYVeUgqENqF
	 phgPRZDtBWi1RUVuoFpet3aTUv+TmaHW78rIbk5U6KrFTGLbCJ9tkqN+czWu4rzQTT
	 4LKDGznol6vcEk7N3dJd04got38BldlF6GhxAtsaUiGEvbMFiFBNv0vJDK7GQewjEZ
	 bFqFexWjhmlAJCFJeVZjH3K+a0KQu60EPNkk9ViylxJzr318u0VmYqYYw8NGR5Jqeb
	 y07S2rifgH4zA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a169bso6874274a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 10 Aug 2025 17:06:51 -0700 (PDT)
X-Gm-Message-State: AOJu0YzPbGwz29oZhZ+UIwsA4FbXfFdxcIa9gZJonF8zcKM9gxjrbe56
	SJM9MoNlJHOYUJv0xR+uQwf5MydSrJZKPxz/SKVvVB18gZd/mBW3ZTN5EGVAyRq+Iz6lh+zvkMB
	6DmhqgU/+bLlfsN8q9zbr3kLEWQgDi1k=
X-Google-Smtp-Source: AGHT+IGPZDmnJpCWDvKjuIfa5VvIshe4edNgsJ2MzHYxfc53NGYbswXpNtd/jBroCefzygcJGQEAYPL4XuSS8ITFq58=
X-Received: by 2002:a17:907:96a9:b0:ae3:7c8c:351d with SMTP id
 a640c23a62f3a-af9c6542d3amr864656366b.56.1754870810285; Sun, 10 Aug 2025
 17:06:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754501401.git.metze@samba.org>
In-Reply-To: <cover.1754501401.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 11 Aug 2025 09:06:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8s_fLFc1i2oNcGZV2guwCAiC1-+b_5s7r-HCOOC7eH1g@mail.gmail.com>
X-Gm-Features: Ac12FXzJQRqid5vA2XfXKteoYQl6jOWJUNyId3bmyy1qGFbXw5eqG_xj1XvY0RA
Message-ID: <CAKYAXd8s_fLFc1i2oNcGZV2guwCAiC1-+b_5s7r-HCOOC7eH1g@mail.gmail.com>
Subject: Re: [PATCH 00/18] smb: smbdirect: more use of common structures e.g. smbdirect_send_io
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 2:36=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi,
>
> this is the next step towards a common smbdirect layer
> between cifs.ko and ksmbd.ko, with the aim to provide
> a socket layer for userspace usage at the end of the road.
>
> This patchset focuses on the usage of a common
> smbdirect_send_io and related structures in smbdirect_socket.send_io.
>
> Note only patches 01-08 are intended to be merged soon,
> while the ksmbd patches 09-18 are only posted for
> completeness (as discussed with Namjae) to get early feedback.
>
> I used the following xfstests as regression tests:
> cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 gene=
ric/010 generic/011
>
> Between cifs.ko against ksmbd.ko via siw.ko in all combinations
> with and without the patchset on each side.
>
> Stefan Metzmacher (18):
>   smb: client: remove unused enum smbd_connection_status
>   smb: smbdirect: add SMBDIRECT_RECV_IO_MAX_SGE
>   smb: client: make use of SMBDIRECT_RECV_IO_MAX_SGE
>   smb: smbdirect: introduce struct smbdirect_send_io
>   smb: client: make use of struct smbdirect_send_io
>   smb: smbdirect: add smbdirect_socket.{send,recv}_io.mem.{cache,pool}
>   smb: client: make use of
>     smbdirect_socket.{send,recv}_io.mem.{cache,pool}
>   smb: server: make use of common smbdirect_pdu.h
>   smb: server: make use of common smbdirect.h
>   smb: server: make use of common smbdirect_socket
>   smb: server: make use of common smbdirect_socket_parameters
>   smb: server: make use of smbdirect_socket->recv_io.expected
>   smb: server: make use of struct smbdirect_recv_io
>   smb: server: make use of smbdirect_socket.recv_io.free.{list,lock}
>   smb: server: make use of smbdirect_socket.recv_io.reassembly.*
>   smb: server: make use of SMBDIRECT_RECV_IO_MAX_SGE
>   smb: server: make use of struct smbdirect_send_io
>   smb: server: make use of
>     smbdirect_socket.{send,recv}_io.mem.{cache,pool}
Applied ksmbd's patches to #ksmbd-for-next-next.
Thanks!
>
>  fs/smb/client/smbdirect.c                  | 112 ++--
>  fs/smb/client/smbdirect.h                  |  38 --
>  fs/smb/common/smbdirect/smbdirect_socket.h |  54 ++
>  fs/smb/server/connection.c                 |   4 +-
>  fs/smb/server/connection.h                 |  10 +-
>  fs/smb/server/smb2pdu.c                    |  11 +-
>  fs/smb/server/smb2pdu.h                    |   6 -
>  fs/smb/server/transport_rdma.c             | 742 +++++++++++----------
>  fs/smb/server/transport_rdma.h             |  41 --
>  9 files changed, 500 insertions(+), 518 deletions(-)
>
> --
> 2.43.0
>
