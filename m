Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AA71A5B9D
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767632427; cv=none; b=Vx481Wk2LcSj/7rEtyuDejqTqV0ZAFmuZccGH7/zR06N3TqFg/tzdka5m0PpFymSPieEHgrI4WRGdWmyON4bVu68ISCXptl90DrA7Kj0FuVCdvOTYo0HB+w692hdA+pag13oXfToXOWQTm9Gfr2a+4SJ7Ggoj9WdA7CyW+78+v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767632427; c=relaxed/simple;
	bh=fsTdfd2pTvpqFwE7trhZyndXq9M/GlsC7r4ggq/GZCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ReWQUfYx2oSDicXItcw38Z5YmOVOQpQn4jcRF0LzcoVJBDpMetXN1oV+cE4Llzd1/tNxCF/sN8oEPX8tKax4c+pi57gakfBkmIbhRzXUizZrkWqsZrvXwG2mER4e8smmRa/L+ErXSttrMWb+jb3UGQMvMZ8wFV1a85igsrOgHNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wo9oWWmb; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wo9oWWmb"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-88fca7bce90so634646d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 05 Jan 2026 09:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767632425; x=1768237225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfNaizK9N9JP9SLJof3wI6kMshDb/53QFTGW44BecrI=;
        b=Wo9oWWmbYaVPSQiiOyNWqgl9xF95uvHUMxhnX6GMe7z/BlVz/0/S9uVE2BHLRTfjlx
         IqUdJ+ZmLbsc9OT8pOqSltJHiFwZ7FkG9bZ3sqGG/+V3/bynMNA5hmTrM5X2vAFGxLSH
         LmsikNXOOfeFkoRgD3zlMsORckhA6YzEIZ0hENXGn18NsHNw05nRk1pwoQ6HWU5f2cY2
         f0hYYIYQ79a8ch8NLSbJvXksbz1vXiMMX3L8eRjaUfvd2N6Qc+BhI4qVKpeMZAZmFcU9
         2KGCZvOBzyMBOM1n/qBhHCf0kogGGRLiqxNATBFx9BrL6ZxC+aEbSTJRs55CPbivem2A
         7lKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767632425; x=1768237225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sfNaizK9N9JP9SLJof3wI6kMshDb/53QFTGW44BecrI=;
        b=t9ospbmQWitzlrG2Wn5YPuRSN0Kp2n0YRfLXbPVC1/4bIYFm7vlF6rg9TfclCyhRVr
         jYXmABPxmhkw8CJM2DsYJWXZLWCjV1E63Te2+gI05GNSVRy8DK512c7LrlXwtrIlpqvJ
         X7TPxh2Q4Un9cwdpJMJFI4v91Em9K5VAk+oI7jYjjyTxD6IMOEZag+TTS+RreF/rvpHS
         RtUhpCUxTTOzEitCHrU6XCV0gp3UQvbBZswcf5VijFtYp/yGcyotEbT+tFGXeJ+1T5H2
         F/TUnzEtNNMp1SlnryCdnO16gLJ6iZJAG4yYD6opzVY35f30N+MHLGK4Er9C0qjLkcIB
         UDEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKcGLrnSRwsAiwzGffHml6DyoEP0BURVvfVmgLyPPedJgUb1V2ND3lUy7JHFiusdUO9U47iObkSKMS@vger.kernel.org
X-Gm-Message-State: AOJu0YzlSOSbGT151VYp529ks9IXnp6ryrSCgMtEdGL8KWW5OOFTbLIV
	4Jv0eIlYNLuskIr/u8yIokq6eWXcxNsXg6yaG3PzZdqM0T/FiXBvDS4hj46eHL1ojVFBYd9CqDw
	KhCCA99yKeyV586AliUtX14xucz3m4DI=
X-Gm-Gg: AY/fxX5KXf0Vj2ZAb56M4bQYDKtUrFgttf/kp0YLUuxkxwVgA5ZS0jgCedoS430JxsF
	blVeH2x4FEMa+KsWCK+oRcNENezYjcFItI0PV91YyQ7TWioDOARIhi/rMHrzgPTqtjWHKD7YM7x
	7+P73OV8yX4DRW0uw6q7MOE8uRnLMfx7Ki+xSKC1LdyT8qHzfG/vClcSdhtmfzKaEsCq6Hxk/mI
	PRnUQ1J7rmxw0MNAoHq7Tkqj/uE/JEcRHtslFpo8xQzO9nz3FQIa+KE95dDyXbOKaSPWRmD/HHg
	8oB/RLGS1SxcnYPZRnGJ4oQcWwwoNM7+ScyvpKfW5s9qWNiXMc8Nul1V3Nud2JAqNgzZpadSKyJ
	loY5aLEoYXvrzYFPgFiOmagn5SzNvNyVAq7bLa/NPixNiDLhBhb8613qJ09jFJN02tLdicv+AjD
	LZO6eT9Cu08w==
X-Google-Smtp-Source: AGHT+IGflIT9WVQ6mYb1n3BeRwSZDmem/qiFKFaYaFFq2RoepcCKhQyHkU+X4uiZ33fJffKQXWLA+l1U6y2gHzI5dYQ=
X-Received: by 2002:a05:6214:4291:b0:890:19d1:532c with SMTP id
 6a1803df08f44-89075ebb1c7mr3587476d6.34.1767632424363; Mon, 05 Jan 2026
 09:00:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251226201939.36293-1-aadityakansal390@gmail.com> <s4kmfu25glkgu44wl46e3q3bjvyhlbcvnlaiuqkuey4qlg4d5o@s7ispothcved>
In-Reply-To: <s4kmfu25glkgu44wl46e3q3bjvyhlbcvnlaiuqkuey4qlg4d5o@s7ispothcved>
From: Steve French <smfrench@gmail.com>
Date: Mon, 5 Jan 2026 11:00:11 -0600
X-Gm-Features: AQt7F2osvuq_ibU9eLfXSRoWNYRc7txM6vtxiG4xHaSvgvQHEtDHYTVWR9YHa-4
Message-ID: <CAH2r5msUWXyzLTK1BtJ2feNe7Sj7+P-y6aix6Tdc4yJgUc8TEw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: terminate session upon signature
 verification failure
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Aaditya Kansal <aadityakansal390@gmail.com>, sfrench@samba.org, 
	linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 10:37=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 12/27, Aaditya Kansal wrote:
> >Currently, when the SMB signature verification fails, the error is
> >logged without any action to terminate the session.
> >
> >Call cifs_reconnect() to terminate the session if the signature
> >verification fails.
> >
> >Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
>
> Thanks, I think this was long overdue.
>
> >---
> > fs/smb/client/cifstransport.c | 7 +++++--
> > 1 file changed, 5 insertions(+), 2 deletions(-)
> >
> >diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport=
.c
> >index 28d1cee90625..89818bb983ec 100644
> >--- a/fs/smb/client/cifstransport.c
> >+++ b/fs/smb/client/cifstransport.c
> >@@ -169,12 +169,15 @@ cifs_check_receive(struct mid_q_entry *mid, struct=
 TCP_Server_Info *server,
> >
> >               iov[0].iov_base =3D mid->resp_buf;
> >               iov[0].iov_len =3D len;
> >-              /* FIXME: add code to kill session */
> >+
> >               rc =3D cifs_verify_signature(&rqst, server,
> >                                          mid->sequence_number);
> >-              if (rc)
> >+              if (rc) {
> >                       cifs_server_dbg(VFS, "SMB signature verification =
returned error =3D %d\n",
> >                                rc);
> >+                      cifs_reconnect(server, true);
>
> I'd like to hear opinions on having reconnect happen only if signing
> is required by server, otherwise only log the error (current behaviour).

I was thinking the reverse - if the signature verification on the
client fails but it was the server,
not the client, who forced signing, then we could skip the reconnect
(and just log), but if
client forces signing (sign mount option eg. or
/proc/fs/cifs/SecuritfyFlags setting forcing
signing) then we should be more strict and reconnect

> >+                      return rc;
> >+              }
> >       }
> >
> >       /* BB special case reconnect tid and uid here? */
> >--
>
> Nonetheless,
>
> Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
>
>
> Cheers,
>


--=20
Thanks,

Steve
