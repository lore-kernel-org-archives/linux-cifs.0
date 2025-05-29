Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE612472BD
	for <linux-cifs@vger.kernel.org>; Thu, 29 May 2025 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748489652; cv=none; b=Ij+QFjcvMg/TjYyTcmg+IbX3WqWuyQRJxsXmR+Xnso+cx6M8bmnLR8ocRveHYv4IqQ3wixgOsE/ZnNyHZ9Lr99ogB+7ArBmQCJgQ+D/Ix7UJy5w7nxjGpoVGkJRQNe8UM1ruGijPWLhiJzvIXdHYD4olmmoJHN3xqtjbvE3AEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748489652; c=relaxed/simple;
	bh=xVezsiN0Pr7I+vLy+6zB+CwddIwZPdGZgqWfW63ovRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EsrazhiVhP1Xx8+0OXA48IEDEKwKtjxLscLNxqDG1/jP8lTfvKArwKYVuY+cbEsp16lhgYw0WJlYEuJ6TbbYAf2MFwEdhROYNa3NFPuPZUusXKAyb4SGUI5g5ptmuy2BkNoGNM1u3aX5qL/w8ow9OK8UGH6bWR0DgxsXn7AKZNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i0h55VWJ; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0h55VWJ"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32a81344ae9so5320821fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 20:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748489649; x=1749094449; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xkfXESif56vvqQqcslrIjI82IZMQiKHq9r0decJLSis=;
        b=i0h55VWJeS7/SKvsgB2+pPemK1C35xF88MKWOB0QB1trB8pAxf1xrtu/btIJbp1fmE
         4/y8M7SN+tNN3QShw18NBCcDb90ZEZPyXBD1i0ne02IfWm3PFNpjh4r1NtbU5Nfcwu19
         mR2kFungGLePm7WV2OPtdKdWnpwSEPLaGXmqg3nM0iyKkvqaHKD5yzg3wxF35/EIjP2J
         o3p+qFUtHWd++536Wry0ow+vMG2doArGVCGyRizSyDr4hs2DpnJvity1lg0uz5eiYVNc
         AmALkmPxyOFUrn9q+sZjHPWAPoi2wFWNIErmnSMWTq4SCoqzpNTKPP8JYkgYtMYmQ/Cs
         Pesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748489649; x=1749094449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkfXESif56vvqQqcslrIjI82IZMQiKHq9r0decJLSis=;
        b=dWjosHnhIwl2rsYHPwk3+ilNPE8Vp8taYys/OeWVhPX8MkAboXdzqmUSS58Vp0ckcS
         b71TMBAg1Hjrh/gU+ZDtSgUP3z21WueTNAJuJHT4l6pnLvV7GlLnLOdTVcl8PyKqt/KE
         RZOA64wAlauuU+UjTEVLDVZ6QaQIAOen5AN0oN+69CglQqqk8KwyTkMessDJ4QZO+10L
         nkKB+n90k57zXsOdIGq8OJuSkPaZ+IlUatvmj4czPJh+Cd0JMFGdujA1M8RSNZIlDMMW
         T+x1jqrKBQ+zoc1DW98wNtDgIpGlJ9lCJ14ySwB1bCJJUINPeJ4RfMyE/wKnVMxwzALd
         3F+g==
X-Gm-Message-State: AOJu0YyC/BPfnuaz4clgQUgP9Ztetvpet+jgnGF2Xo1ZY6JzIulpdYwf
	tRYkU/JNjt133JM25JBG9jDC2W69REMwg6AVtpInIAVLu9Wo5Vs1q7DGtuoWklqtRUQFPsfAuSv
	CTy5r/VYXSOyOBz9rNBnlenjRPUC4rpg=
X-Gm-Gg: ASbGncvBcd95namOAOrErKOd36TJkdOHYQxocSGOfai8Nku80Up7GusKJgCe3SfV5yG
	HdpSa2Ajv7WMReNqFi8JjpH/V+ujVPAIwGdcytAXIfjrXpgrFRJ+GBERcdx/F2u09tr9MbnhMKX
	aQJF8MPiAd5KZkLOzNW95IUZD/5trqKtfyePvnJiLOu1IW35MMCgrVa0I8VJQkUWkw
X-Google-Smtp-Source: AGHT+IH+SWHYnNXb3f5p3Bicnn2gUrbUiW0eJ1b/HX1BoIKPTe4GgK5YkckqLNsitW592BxTGzFf5if5iZgseg7A3/M=
X-Received: by 2002:a2e:a98a:0:b0:30c:50fd:9afe with SMTP id
 38308e7fff4ca-32a79aa8d49mr15748641fa.9.1748489648913; Wed, 28 May 2025
 20:34:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org>
In-Reply-To: <cover.1748446473.git.metze@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 28 May 2025 22:33:56 -0500
X-Gm-Features: AX0GCFuKQP-6XOoz-IabLf2aZDvsYk6ZUPTtm1sbwxMjioVbUKU6GJr-JcQaDUw
Message-ID: <CAH2r5muwNi1Negnt=wmRYkHZxAHDzP_Wxxhbjj6_T-P3ZTjciw@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] smb:common: introduce and use common smbdirect
 headers/structures (step1)
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

So far not seeing any issues testing (non-smbdirect tests) with this
patch series, but would love feedback on any smbdirect testing with
the series

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
