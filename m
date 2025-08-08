Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07649A944
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 00:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754612543; cv=none; b=tYwM1rEW1B0JUo/lsmKRm+Utj0S4hOCB50JQpsAfw6bHATJ5af91lUHI2VpJpfBSxCeOkC5LK3ddfWty5t2/PLkItQ++dBmSfKaqJvYZDKUAWPN3qlGsdJWr44cpuh3fBKfwUQ7qG66cDfb2/UhcKMYzJfytOdjG/LZdRE83geM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754612543; c=relaxed/simple;
	bh=BddAEfpMqVRjODJh9kz3/wRh+yYQGdJyzfFRT9EvL0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTtCw76NaO7VyV8/+3ULP9xVokKLjrZ71hPlLjprLLzb8gt5lSyd4qtzwKYdq5hURD5I9HtuNNaaLdFq1vRcUKzHiMa7fxXtihFwy2pWydRzZv/nLpQlScAwkLF/JiyG7AMJSdE/MC0ZLioqosscwiX15zFFASTfBsgBuTGgw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szlbWZAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szlbWZAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A382C4CEF4
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 00:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754612542;
	bh=BddAEfpMqVRjODJh9kz3/wRh+yYQGdJyzfFRT9EvL0k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=szlbWZAoIube+2GP0r9hRmCBWruF9hC8QOGWEpBdhdE0UG6/Wl2CrMSiT6bhLRDjS
	 X9BMe4HX/BkAIiUwKUAS+aYpdxxAHPDHqXTd/eZGolsdet8aIi3Jd0Lb/bghWSppeW
	 boKocTAqC+diTOcoBmLTa7GMnz2lquscpKRKXW9ijxp3vw+3GRk6rgHCfOhPak63bY
	 MM5TatJp1QyhQRr0ahUQmli6i3WamOZmDzY9uLyCZpqprdOstSuuZwjH7O8RQLWo7m
	 XzUlA9IZ0uHCn3CmWJP/lIcGI/vpkga0L04XW4P7hm+tG3pvuLi6PwyD3ZvQxcYxGN
	 rdmZlY8TP6dLw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-af93150f7c2so239109766b.3
        for <linux-cifs@vger.kernel.org>; Thu, 07 Aug 2025 17:22:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YznOHRP6XsAZV0Zc0I8BucouUzheJvmdkE7I3842UMlCfNv1kou
	ewlBMazCAhhWttK4vIonY+Vf0ITclgC4NmuRy3y5L+RwovN1Sp5ufB+ChjRBzryysleTaiXb2UL
	4PwdXhYji/LsKSf/SQVIf2Pbj/zVo7ec=
X-Google-Smtp-Source: AGHT+IHTzayJ7fA2MjXw+lfefek/RqugrB758ByWpIhU+M49BKb7UnnJNPni1VqvZLQDRX7dccI+nBficss3p7PpKD4=
X-Received: by 2002:a17:906:eecd:b0:ae6:f564:18b5 with SMTP id
 a640c23a62f3a-af9c64525famr83850266b.19.1754612541124; Thu, 07 Aug 2025
 17:22:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754501401.git.metze@samba.org>
In-Reply-To: <cover.1754501401.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 8 Aug 2025 09:22:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8AGwTcRO=cJmeTHpaktuqRs+RhLQg_Jy8BPMaVqZq4Gg@mail.gmail.com>
X-Gm-Features: Ac12FXwFNW0E55EbTxMQqSqtAe4ECiM8KOI2fQGT2gxBJ_-AZZQ8nseCJnad-zw
Message-ID: <CAKYAXd8AGwTcRO=cJmeTHpaktuqRs+RhLQg_Jy8BPMaVqZq4Gg@mail.gmail.com>
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
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

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
