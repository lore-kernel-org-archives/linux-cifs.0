Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E0198A2F
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754590504; cv=none; b=n9/mIaZOsavFYR/9xTOhH4yCpkC5IhAaGj9p3w5fS1kZNGx2yldSsdIY2aIN7f2Naw6cPUhCHpFY7Ckvt1bgpuelgxgqlcFfq4FCA7bs3FyHFkBtsv7uBOBNc65xt/dSuvv8MQWJieLKesEtC8yv95gHqqNKBNTiUP5pk077apc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754590504; c=relaxed/simple;
	bh=p0YOwb4QY7CrhyAADN2BIWPjLDV8EwoAHh0lOJCZKtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K5axSR6rZf2lSZ2gq2NQe4I48jB8JcYFlpxT+M11LtaCyOMVWTPVcXx/ww8vJ74hq8Zo28gdY5v0s80eDEBwirtrh0aJ3c6Hd4FxlXF2KXBLkzDNTsJyHAwECskM4Z9vwzqHE4AtZcDlVNywnGcDZu/YQ6KK8ni2a6gT+8O210M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7hLDDEw; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7hLDDEw"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7e6696eb4bfso156566185a.2
        for <linux-cifs@vger.kernel.org>; Thu, 07 Aug 2025 11:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754590502; x=1755195302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDmHIeR9vBGhvgS6PfsbuztwiDYgJcdK8fhBDdr6eZw=;
        b=C7hLDDEwlsdXvgBFzzM93p1CyT/os6r3BwMBDlZ4TQ4JGnW+9rmtRo0N50AWY4RvC6
         kP9FfXOMPWC70Kzzg3bNmeTLy6zSSkBsoccJFzpAJhHoWOYKUMM+A/dL3ImjTEs5tg2o
         bTYMLHw7vw1g40zbym+WaONdng+bbgHe2EN6/32D80a3n68/ryKlHbj95c4dMj3SAwK4
         dk9ksoS9DlrD8t4znBrN1WdH5VSxSdn6Eq+Hbb3gIwl7vLKeCavWPU3vEDH6UTm0R60v
         PKCMyptDYC4DIgHVkgSgY8z+bdeQ3+L4+xWHDg3FFmPluZJp25X7amHevg0tOZ/966m0
         ceBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754590502; x=1755195302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDmHIeR9vBGhvgS6PfsbuztwiDYgJcdK8fhBDdr6eZw=;
        b=sZLLhPn0DjmIvBQLkWA8kVMdVgi7PXfF54u8pnI+com44eJJ9WhnlN192RlWB03Iu1
         7qSAEbTK1ffy1OE8RiSePuszi929uUb5E+NUHuFjxfLFhqHPzdwL4prE9kA5B9CRNP3P
         f4ICD5rmwNj6AhGY90gnVKyjHS5DjVFfDCeVbPhW4AWf3aF/sHPSd2ttAIqQ8n4lnjR8
         AFjaBGjOr01M6aDxbM/lnx9YCx3aHbt7MoBQ/0YZa4hzQd/qb0gglnmN6WaY8RHPGJh3
         J20HW7bLNTFJnZVpmdd9ORWvOpZVCJGjNcp4xumOAczmKrDAt2knLgETBkWObYcypM/s
         4Kvw==
X-Gm-Message-State: AOJu0YzlmTYz6oy2gAhRy4jeg2fXkubuzoBk7XiZWlCXYoSJL4/YZqP7
	FkHEH63d8I+O85XeCbirhI5lY1c4C1NzJFepmUy3G0F1nUE38XO+rrDf/iamIgiXG56sEwdO70k
	4Q50rMcQkszfo1JvmFyc8K0oAEFG4iRk=
X-Gm-Gg: ASbGncv5WcLXh+OOznFc6HDFQZM2K0ak8ydg3R2ESolUOBeGC+3T4UduNEveisGNdMk
	3wWiAMx7uHUlSqBJdmkDVPWRpS/8NCHhkJCIdVLkIdhcP9nkxj0+dA8ICeWOnVgFMy1E49LGrp4
	hFnWvZi3BotHZAZlLbBBYZz9wXKktFlD2+TnfA4BH1Y95e5CIJK0g/gMubScr3lth9KH9BnplSS
	ykuxGz3gWjlFZpN6hkFO5FlopLuqbdyaOYMurZXU5/KxmNNogg=
X-Google-Smtp-Source: AGHT+IHuRqoGf10eSMHQgO8/pbBLy5yJPEpZjUzvY0FkzwE9WNzNYSn9efYG7+5b8k/Ge3IicylmGZfjhuvxbnK5BGw=
X-Received: by 2002:a05:6214:c29:b0:707:228e:40b9 with SMTP id
 6a1803df08f44-7099a332e82mr3844666d6.23.1754590501781; Thu, 07 Aug 2025
 11:15:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754582143.git.metze@samba.org>
In-Reply-To: <cover.1754582143.git.metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 7 Aug 2025 13:14:50 -0500
X-Gm-Features: Ac12FXzDR4dJKVZm_6CRma5K5PBo63NXVlDieBSw8L-DYfAEnz1qxXjX7wrjOO0
Message-ID: <CAH2r5mvB2sLkZd5v0as4vrR=mmL6jDcq2xGOb+BZoZHLnGY_Gg@mail.gmail.com>
Subject: Re: [PATCH 0/9] smb: client/smbdirect: connect bug fixes/cleanups and smbdirect_socket.status_wait
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tentatively merged into cifs-2.6.git  for-next pending additional review/te=
sting

I did fix up minor checkpatch warnings in patches 5 and 6 (unneeded {
and } in if ... else)

On Thu, Aug 7, 2025 at 11:12=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> this is the next step towards a common smbdirect layer
> between cifs.ko and ksmbd.ko, with the aim to provide
> a socket layer for userspace usage at the end of the road.
>
> This patchset focuses on the client side today.
>
> The first one is a fix for very long timeouts against
> unreachable servers.
>
> The others prepare the use of a single wait_queue for state
> changes. This removes a lot of special handling during
> the connect and negotiate phases.
>
> The last two move the state_wait queue into the common
> smbdirect_socket.status_wait.
>
> For the server I have only a single patch that also
> uses smbdirect_socket.status_wait, but I'm skipping
> the server patches today.
>
> I plan a lot more progress on the server side tomorrow
> and hopefully finish the moving everything from
> struct smb_direct_transport into struct smbdirect_socket.
>
> I used the following xfstests as regression tests:
> cifs/001 generic/001 generic/002 generic/005 generic/006 generic/007 gene=
ric/010 generic/011
>
> Between cifs.ko against ksmbd.ko via siw.ko.
>
> This is on top of the patches for the client I posted yesterday...
>
> Stefan Metzmacher (9):
>   smb: client: return an error if rdma_connect does not return within 5
>     seconds
>   smb: client: improve logging in smbd_conn_upcall()
>   smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in
>     _smbd_get_connection
>   smb: client: only use a single wait_queue to monitor smbdirect
>     connection status
>   smb: client/smbdirect: replace SMBDIRECT_SOCKET_CONNECTING with more
>     detailed states
>   smb: client: use status_wait and SMBDIRECT_SOCKET_NEGOTIATE_RUNNING
>     for completion
>   smb: client: use status_wait and
>     SMBDIRECT_SOCKET_RESOLVE_{ADDR,ROUTE}_RUNNING for completion
>   smb: smbdirect: introduce smbdirect_socket.status_wait
>   smb: client: make use of smbdirect_socket.status_wait
>
>  fs/smb/client/smbdirect.c                  | 137 ++++++++++++++-------
>  fs/smb/client/smbdirect.h                  |   8 --
>  fs/smb/common/smbdirect/smbdirect_socket.h |  15 ++-
>  3 files changed, 105 insertions(+), 55 deletions(-)
>
> --
> 2.43.0
>


--=20
Thanks,

Steve
