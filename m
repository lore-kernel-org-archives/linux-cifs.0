Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C7E2BE65B
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 01:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373508; cv=none; b=uxq7L4GEH9gCd8nDrCYTFZcM9uba4Aw8N8J2S0nYgrPLcGTIexyp8Dok/oYeC2EKYDZEdac0kNPhu5nqu7wWHdwM/q7oV0FYu1TSgS6JC+oAHp5QNsw+Gw8IHtZmhF0bwPD6xc3ALuz+/eF44mFai+z8X1QIwKNqpW1Wb7OtAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373508; c=relaxed/simple;
	bh=6wSly/zAVNVQBNkop3JZm7wxSKRrl2OS0jA+lApjCI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6F4FQvfbbo00kr52PUPQtOIFDLiXRzt8YRfLeKFm0wLR23cx3n1dGCKcehoS8VEji/69Q6hoSF8w9bTIwHCWaPoy650yz7/98bW6qSpeXETmK/7IIRJznlMitZIrgBpXpfSRtjyn1tMlaRie/EAmWONx5NYoQAoJyyEvQ/HZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6GtDGzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6GtDGzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A5D1F000C5
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 01:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792373507;
	bh=0QCpVlvN0N9E6v1ZQNUdVcnSaucjO/gzXlDFcmQebhg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J6GtDGzFr0ORl9rvdfwGO3r7ARDEpqiyS5so15t0tuvhVhMZq7XSTqyte6g/gY3Ee
	 EDb6wUhWrPhl7hAdM7yo36nc2S+9qkd0V7D9eURq756dt3bVwGhXwUaJjfSaLPHRJT
	 Ujs7tkWUD3w74pn8ZheDF/iDDklILJL4zCi8/HNt5UZrY2LTNN3l/zZCGQJOrEu0he
	 slR4dtM3SgWSbOXu2MhSb6eFf2ctO3BrtpnNy+j6RjnsZKIdjtEb71YIMAfkCv9D7s
	 3me0npERVnHbYe9L2WqNOrZb5wB5DUx6/IV6Wd8M7B0PFboECU5JCTQ0Q7nh0FJeXY
	 2fqYPlJ4E54tA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c37b612635bso174570566b.3
        for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 18:31:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzKmOcDrMk/9mJHwDF3K9RRVocuA9rVM8ao6ldWzxXVQ90mdbWM8pDBI/TSug1BCzh02bYvZowCrNf1@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5l3AiiCnLJ+3CKs4CMhvaBHZCmnW8/TvwtPd+SFRLuQO5GJic
	NABsgMXc2GQMRXdfIOp7LANB+6aPr3ABkBT/oZCzImakWgEoQsGNBV7Mays3XZsQtibJ0EetjbJ
	Uy9Zg0HVhvJIaUzrb4dpoq/ys2i4kfKA=
X-Received: by 2002:a17:907:944a:b0:c26:19de:9ae1 with SMTP id
 a640c23a62f3a-c41a01f6f3bmr445401866b.32.1792373506063; Sun, 18 Oct 2026
 18:31:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792345559.git.jan.koester@gmx.net>
In-Reply-To: <cover.1792345559.git.jan.koester@gmx.net>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 19 Oct 2026 10:31:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
X-Gm-Features: AclHuK9mkJKI67nTK0aGHS00BvYoK5qaDyeMDc4uPSmDdsHOy17r4E9JJ3FsZvU
Message-ID: <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Jan Koester <jan.koester@gmx.net>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, wang zhaolong <wangzhaolong@fnnas.com>, 
	Wang Zhaolong <wangzhaolong@fygo.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 19, 2026 at 2:53=E2=80=AFAM Jan Koester <jan.koester@gmx.net> w=
rote:
>
> Hi,
>
> a ksmbd server joined to an Active Directory domain can authenticate
> domain users with Kerberos, but not with NTLM: it has no password hash
> for them, so the NTLMv2 response can't be checked locally. Clients that
> fall back to NTLM (access by IP address, machines outside the domain,
> mount.cifs with user name and password) are refused.
>
> Samba solves this by forwarding the response to a domain controller
> over NETLOGON (NetrLogonSamLogonEx on a schannel connection). These two
> patches give ksmbd the kernel half of that, and leave the NETLOGON client
> to user space, like the rest of ksmbd's user handling:
>
> 1/2 adds a KSMBD_USER_FLAG_PASSTHROUGH login flag. For such a user,
>     ksmbd_decode_ntlmssp_auth_blob() doesn't compute the response from a
>     local hash. It sends the server challenge, the user, domain and
>     workstation names and the NT/LM responses to user space in a new
>     KSMBD_EVENT_NTLM_AUTHEN_REQUEST event, then takes the session base
>     key from KSMBD_EVENT_NTLM_AUTHEN_RESPONSE and goes on with the
>     existing key exchange. Both events have a strict netlink policy and
>     are checked in ipc_validate_msg().
>
> 2/2 puts the workgroup, not the netbios name, into MsvAvNbDomainName and
>     MsvAvDnsDomainName of the challenge's target info. A domain
>     controller checks these when it verifies the NTLMv2 response (Samba
>     in NTLMv2_RESPONSE_verify_workstation()), so without this patch
>     every pass-through login fails with NT_STATUS_LOGON_FAILURE. The
>     patch also checks that the challenge blob fits the response buffer,
>     since the workgroup can be longer than the netbios name.
>
> Logins of users without the new flag are checked as before. The only
> change they see is the domain names in the challenge's target info
> (patch 2/2). ksmbd-tools doesn't set the flag yet. The user space side
> we tested with is sharedd/adconnect from FenrirOS: it marks domain users
> without a local hash as pass-through, and it answers the event through
> a NETLOGON schannel client, tested against a Samba 4.22 AD DC.
>
> I can send the matching ksmbd-tools change if the interface looks
> acceptable.
Okay, Please send a PR to ksmbd-tools. Wang is also currently
implementing AD/DC features in ksmbd and might be interested, so I'm
adding him to CC.
Thanks for the patches!
