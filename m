Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5941DC075
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748623899; cv=none; b=EBB2hyuQIA7vA34qaFGhCx3ULrMQByeYUp+JV++MYgfYxSS0sVitLoIABZk98f3Ixi4/v+mDixkurkIWUF2loRq/R8Z4LmUdQ5hzsnYMnQE0G+QxFrRV/4fGxo+V4la4Nyo1/A6UUMsamL/BKhB/VsdfxFZ5wIXl7hfzpqqwrP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748623899; c=relaxed/simple;
	bh=7tWQk7FlhYuOs5jKmT28IJNoO5omZZmybj9dft2OTVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HJ8oa3ohvEJE9kfixCoWP64lLgPzw61R4Zr+8BcUizfLtJsf2t3hLzdtRwkiI2p9BlWMdC6kADB44jAS2J/XQbuTTnd5pbIRleSNdzVUi8R/A2xpe+cjixW15oW97IAazCVugnwEDzyQHynFUEBBULZzxFYyLt0hW1GEUStx2g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fEH6S0Nw; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fEH6S0Nw"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3105ef2a071so26405041fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 09:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748623896; x=1749228696; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD91Az4ovD/Hq9SUuO38K5KgatmnklatOhykQqdmrQI=;
        b=fEH6S0NwjdNY0xIlViwzLN1bVjoE5f+9jxEwnA1BL+xGbSD0WzqzMRsZrugI6wQ0Y0
         eROBlW4gKXIwwQuYLhnWPjY5C8ViSGlMDVPzZ4BNJESXDZfziLAqBFlRphgdTHn5VjeM
         7SoyMhOv4268AFsA4/1lj6EfYb9uYduADfPM1Oms7NoC/im2auilGZNnunedpovBten9
         5eLpfAeZjiyKJ+CJaq41CEH6lvFTsqtU5j8DYuH53wQAoBoLgrlioZp7UHj8MFC0V6r8
         JqOg1aNPwWUTIV3MwF1W9LaJp06PGeo4uvcKgZzerUlya3XBStk9FYoo3BIBti2TMDNI
         6ZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748623896; x=1749228696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD91Az4ovD/Hq9SUuO38K5KgatmnklatOhykQqdmrQI=;
        b=nvpO8jeJo4sUzlfy4LE8r6vkNVrwEUfFBjx6SkL3S0vU596uQ8TQ5Zn5y/Lzhot3Mf
         5rUUB/CYNaKylWagI8UnHPLmndCw+dMJ/RIeGysyadlOlwxjH3FxiiTvGNTf+EJnIYWD
         HGZDQBUbc/lLiC9p80T26UngPlMc1GGkGSLFY7itTzF1fkrX4UA4bX6u+M2pRu0EJGmP
         bQQjuuhTowtvFglE0/Bjp1sVPzqTQu0M560TX/wnn+Q+jsKTg4Pc2x/Kh/RSdx9C9xxe
         rt6u0suUabioRmR79YTVPlqeIXJK1STVnQHEkm0rJszAyEWHKPJIfdCAiKPXI6TJYWZe
         5/ag==
X-Gm-Message-State: AOJu0Yz1gipcSm3skNs6c22z1NhXCd70oLb2J/ObR79c1xFDY711z3ui
	rAOQtdvNWZMnvEkmg0HBVckef9GrybGyWvDn9oue/+7I0Oj1Bw+9Upt3Tk5wXsDjl87csu1Fdzy
	VX/iF3DHWL2oQycC3lej1Xl/LDq6oEuhK+qYT
X-Gm-Gg: ASbGncvA7nuNfXa8EbRqzHmL8vu24ME/fedzj8ILHBxUi6IvXXVjMT3XRCezPBKXZWh
	MwSVtzkOM9OS4UKze0LLPwYw3kSg681eTrdqX+DeW9QMBGChLoSlwvPb8HhQ1skhsb3NNxmR8Uj
	jnWsWXQuKAx5SmhRe/6EPiDu2Epw/0NCu1uIoNYuLjrUvRQIXEoe9eOrdaVfhXlY48Wx8=
X-Google-Smtp-Source: AGHT+IEmGp/73upRLBSPJDdH4fvclKv0UFFY2j1RZTdBMU5LzO1n2h8rQSJ3Ktq3gSJS2RlsSFPwPd24obrFzNUakL4=
X-Received: by 2002:a05:651c:30c6:b0:32a:8101:bc00 with SMTP id
 38308e7fff4ca-32a906cb2f0mr10530601fa.9.1748623895744; Fri, 30 May 2025
 09:51:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org>
In-Reply-To: <cover.1748446473.git.metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 30 May 2025 11:51:23 -0500
X-Gm-Features: AX0GCFuub8-4Mm3_qDqd0azzM6HNDxaHfzR_MpygQ8Slq4FTtDpKPe2RmsVjCP8
Message-ID: <CAH2r5msi+4kUx37dkCCdz=YD8bGK64cTZqAujuh3nJh1+gj62A@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] smb:common: introduce and use common smbdirect
 headers/structures (step1)
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have temporarily removed that patches which touch the server, ie
updated for-next with only the client and common patches, pending
answer to one of Namjae's questions about the ksmbd changes.

4e89b3b35e98 (HEAD -> for-next, origin/for-next) smb: client: make use
of common smbdirect_socket_parameters
34399d47fa28 smb: smbdirect: introduce smbdirect_socket_parameters
39bfc4a85f60 smb: client: make use of common smbdirect_socket
8ed057da2a21 smb: smbdirect: add smbdirect_socket.h
3173f315fa92 smb: client: make use of common smbdirect.h
c54ba448cb35 smb: smbdirect: add smbdirect.h with public structures
2119e7ed45d1 smb: client: make use of common smbdirect_pdu.h
0aad6cf27293 smb: smbdirect: add smbdirect_pdu.h with protocol definitions
bc01b00a6ca2 smb: client: use ParentLeaseKey in cifs_do_create
0e441841edfa smb: client: use ParentLeaseKey in open_cached_dir
5015217979ad smb: client: add ParentLeaseKey support
55423e9c534d smb: client: Remove an unused function and variable
0ff41df1cb26 (tag: v6.15) Linux 6.15

On Wed, May 28, 2025 at 11:01=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi,
>
> in preparation of a having a common smb_direct layer I started
> to move things into common header files and added the first
> step in using shared structues like struct smbdirect_socket.
>
> Currently only simple things are shared and there is no
> intended behaviour change (even if I found some things
> I'd like to change, but I'll defer them in order to
> make the review easier).
>
> I'll work on this the next few months in order to
> unify the in kernel client and server layers
> and expose the result to userspace too.
> So that Samba can also use it.
>
> v2:
>   - change smb_direct into smbdirect
>   - make usage of header files just as needed
>   - also introduce struct smbdirect_socket[_parameters]
>     as shared structures
>
> Stefan Metzmacher (12):
>   smb: smbdirect: add smbdirect_pdu.h with protocol definitions
>   smb: client: make use of common smbdirect_pdu.h
>   smb: server: make use of common smbdirect_pdu.h
>   smb: smbdirect: add smbdirect.h with public structures
>   smb: client: make use of common smbdirect.h
>   smb: server: make use of common smbdirect.h
>   smb: smbdirect: add smbdirect_socket.h
>   smb: client: make use of common smbdirect_socket
>   smb: server: make use of common smbdirect_socket
>   smb: smbdirect: introduce smbdirect_socket_parameters
>   smb: client: make use of common smbdirect_socket_parameters
>   smb: server: make use of common smbdirect_socket_parameters
>
>  fs/smb/client/cifs_debug.c                 |  23 +-
>  fs/smb/client/smb2ops.c                    |  14 +-
>  fs/smb/client/smb2pdu.c                    |  17 +-
>  fs/smb/client/smbdirect.c                  | 389 +++++++++++----------
>  fs/smb/client/smbdirect.h                  |  71 +---
>  fs/smb/common/smbdirect/smbdirect.h        |  37 ++
>  fs/smb/common/smbdirect/smbdirect_pdu.h    |  55 +++
>  fs/smb/common/smbdirect/smbdirect_socket.h |  43 +++
>  fs/smb/server/connection.c                 |   4 +-
>  fs/smb/server/connection.h                 |  10 +-
>  fs/smb/server/smb2pdu.c                    |  11 +-
>  fs/smb/server/smb2pdu.h                    |   6 -
>  fs/smb/server/transport_rdma.c             | 385 +++++++++++---------
>  fs/smb/server/transport_rdma.h             |  41 ---
>  14 files changed, 613 insertions(+), 493 deletions(-)
>  create mode 100644 fs/smb/common/smbdirect/smbdirect.h
>  create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
>  create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h
>
> --
> 2.34.1
>


--=20
Thanks,

Steve
