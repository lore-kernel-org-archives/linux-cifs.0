Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD74E56F3
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 13:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414988; cv=none; b=k/krO7H7grzyHiGQnM8d8TiN3fFuQKLM+U9zq4yLLtkdHKT1wWFGoREMDY9lyE4lHLR3H1tzv2QhdpPkowUXT+HT+xVa+MGrJJuzLaEqAlcU/e6QrsfQ+H15tsXJH4w5d1Dfw/3uRdwlruEem3J9UrceRFBnS28sGge/h2Csnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414988; c=relaxed/simple;
	bh=AxHaZknLmHw2c4oUtLvoTM/Sy3ITwXsf/3WpjcpHKCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bKnR9qbeMdMZaPwvBzSwXIIa8cfTiaIRB/FoCh2504GuvqD5X9p2ELirbnQYtenJ9M1lnX4oQCnojzcmi3r07CB/0uBf8il+7tHz18FNYRPD6kZngXxOvV/mXetL69fLjVoGy9iz31+vAquSSJDPMwFlKeO/6y6SNZZB7b6ZzHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMZB5Nqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMZB5Nqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DA91F000C5
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 13:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792414987;
	bh=a7bxq443au8bQdE7gaA78lFXj0+dw95FX0dHaWtaB9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aMZB5NqcghmwWC+OZSYyUzAHEuBLMhw5H8NjlJFl5SgcdRBOuVXYOWb0O4Ds7yben
	 50Vpvo/zc0jcIOqZz1hRrgKSvajBnZICbKnQP9921c721wHHkXIfjaYtGA9z5u6jQO
	 NyxQikFuahGLTYm/Vo5h8rblmh13XG0hRVbydNkeyotHnQC+Iisc+M5mw17qRnDnhe
	 d96wY1Au0Oc47FDSwODCcX9XzZbLxIvTZMo7jxbum8fPpaonno3YFSNbyrH3sN5CaF
	 S5uReJGH6p5jJHXTEZFSo2uVkEgsI8+sDrtfcyWAVCzxHVX4cgPk9Dt85DRwxCLwtZ
	 gbSLnCfPrPNfg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso346865066b.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 06:03:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxJ+89xgp1XQcyeoCPywsea9AFM1He1R3+7Hvk9TBGCt5a8FaaNoPDmy3env/anzLDO0EscTuSi/nrP@vger.kernel.org
X-Gm-Message-State: AFq9FYLqMRgccPrBZ+o2ibQvx2RsY+QSmSG6xWDftekZ35ghIZSpZhQr
	QCWyFVY+CdjYXIgP5WVsGkUTRp66Ju9dYuAk+I2U/0vKC2eMHQHiRnVS94HKxMyuzbjltWUOmdY
	JiEJKrP/2zomQ2pD894Q5gPJMNw/B1fk=
X-Received: by 2002:a17:906:8e15:b0:c2e:893:7010 with SMTP id
 a640c23a62f3a-c419f906220mr466260266b.37.1792414986239; Mon, 19 Oct 2026
 06:03:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792345559.git.jan.koester@gmx.net> <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
 <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
In-Reply-To: <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 19 Oct 2026 22:02:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8-QCawP+oEXDtubc62-QuAWGQk_zn4ZfGk+iKic_j2rA@mail.gmail.com>
X-Gm-Features: AclHuK8Kvkxp7NShd7TUCYnc22_xbq0PEFp6g_negDd21xABx3Nu3gk3ghWdAqs
Message-ID: <CAKYAXd8-QCawP+oEXDtubc62-QuAWGQk_zn4ZfGk+iKic_j2rA@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Stefan Metzmacher <metze@samba.org>
Cc: Jan Koester <jan.koester@gmx.net>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Wang Zhaolong <wangzhaolong@fygo.io>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	wang zhaolong <wangzhaolong@fnnas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 7:43=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Jan,
>
> >> a ksmbd server joined to an Active Directory domain can authenticate
> >> domain users with Kerberos, but not with NTLM: it has no password hash
> >> for them, so the NTLMv2 response can't be checked locally. Clients tha=
t
> >> fall back to NTLM (access by IP address, machines outside the domain,
> >> mount.cifs with user name and password) are refused.
> >>
> >> Samba solves this by forwarding the response to a domain controller
> >> over NETLOGON (NetrLogonSamLogonEx on a schannel connection). These tw=
o
> >> patches give ksmbd the kernel half of that, and leave the NETLOGON cli=
ent
> >> to user space, like the rest of ksmbd's user handling:
> >>
> >> 1/2 adds a KSMBD_USER_FLAG_PASSTHROUGH login flag. For such a user,
> >>      ksmbd_decode_ntlmssp_auth_blob() doesn't compute the response fro=
m a
> >>      local hash. It sends the server challenge, the user, domain and
> >>      workstation names and the NT/LM responses to user space in a new
> >>      KSMBD_EVENT_NTLM_AUTHEN_REQUEST event, then takes the session bas=
e
> >>      key from KSMBD_EVENT_NTLM_AUTHEN_RESPONSE and goes on with the
> >>      existing key exchange. Both events have a strict netlink policy a=
nd
> >>      are checked in ipc_validate_msg().
> >>
> >> 2/2 puts the workgroup, not the netbios name, into MsvAvNbDomainName a=
nd
> >>      MsvAvDnsDomainName of the challenge's target info. A domain
> >>      controller checks these when it verifies the NTLMv2 response (Sam=
ba
> >>      in NTLMv2_RESPONSE_verify_workstation()), so without this patch
> >>      every pass-through login fails with NT_STATUS_LOGON_FAILURE. The
> >>      patch also checks that the challenge blob fits the response buffe=
r,
> >>      since the workgroup can be longer than the netbios name.
> >>
> >> Logins of users without the new flag are checked as before. The only
> >> change they see is the domain names in the challenge's target info
> >> (patch 2/2). ksmbd-tools doesn't set the flag yet. The user space side
> >> we tested with is sharedd/adconnect from FenrirOS: it marks domain use=
rs
> >> without a local hash as pass-through, and it answers the event through
> >> a NETLOGON schannel client, tested against a Samba 4.22 AD DC.
> >>
> >> I can send the matching ksmbd-tools change if the interface looks
> >> acceptable.
> > Okay, Please send a PR to ksmbd-tools. Wang is also currently
> > implementing AD/DC features in ksmbd and might be interested, so I'm
> > adding him to CC.
>
> why making this NTLM specific, I think it would be good to the whole sess=
ion setup
> blob exchange to userspace, so that authentication is not used in kernel =
at all?
> And it will also help when IAKERB and other things will be implemented la=
ter.
> It would also be good to have the infrastructure working with winbindd be=
ing
> the bridge to the domain.
I prefer keeping the current patch's approach for now. I'd like to
stick to minimal changes rather than making a drastic refactoring. As
for IAKERB, we can revisit and discuss any necessary structural
changes when we actually reach the point of implementing it.

>
> What exactly is "sharedd/adconnect from FenrirOS"?
>
> And Wang, what are the AD/DC features?
Active Directory Domain Controller Support.
>
> metze
> > Thanks for the patches!
>
