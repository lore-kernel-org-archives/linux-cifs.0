Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADCA249EB
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766140353; cv=none; b=BBewMemfzivEohDrZgMWFDOt+S26lt093LTPTxI4rVeIGMh1ipjF28B7xmhjriPbAvP5pTkOhscvpNuyxDKgl/gHxBaC4/gx/RccthnV+MWSeV7xlzRy9PV8eMrbxc0Nxz7hTSTw7om1+GotDilzPXY4Zbv5N3PGCoNBPvb4njQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766140353; c=relaxed/simple;
	bh=Ant0LKPpYKv1/WU7AomQnzNqE0PxOQNYQ9hZrghImDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qMKi2kicvmuYRyWY1c3I1H95oJWk+5QLMOpYAEjMrbpH/HY23BjW8QxLF4LZKAqB0yem49jTyr5Nk7iupqkpBwcD+/ciaXS2WQZ8aMOwslEb3xRpw+EiV3SkPbcWTnGXhu8edd5HhSDTiJYs993iB4wEtuDlNRT2FxbFSPbuNV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A17omFbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A17omFbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8799EC4AF09
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766140352;
	bh=Ant0LKPpYKv1/WU7AomQnzNqE0PxOQNYQ9hZrghImDI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A17omFbniacgrbRIxuInXoTb7iv+pinjbM4xupF3v59NEwupZH5k648Xf97LGTAFV
	 oiV8zINZuhHkLxTs9R/DhijnabcomA0OTFeVpSwYDaznJwKRhVhfzRnInogk9ugWj4
	 Oc8ZlOKlar9BrNU8Vo1Z3NicegJMInmL7vRbUCfs7W0RQ++fJC4ZUfI0jrgYUFLRAA
	 D8hrqIRA8MMrNmkS6MA/p4i+gPoCmRK7/B6lfHKr4i9LQSNHlSR3WCIBZJeOHSLHeT
	 WtgN7fwSs3WavwDob8PIKZHozeXl2C5UB9vn1sMdVZbny27K7rjBitsTdHQ7YKaf0n
	 6YM6LmX5fRLrw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b735487129fso279443266b.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 02:32:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVtYgmGkYpsM0tg01XNc1M7pDNeLvb+PRQNN6Cdg0mHRRBcIYHJ1ZwXysz4hCo6lmdSAGhcz64ur1lr@vger.kernel.org
X-Gm-Message-State: AOJu0YyFL3TGdeNhGGVhiRtC3hE4eY0V3OWM+hISn0zGsYXmPGUC88Or
	a2Pd/h5ahscu9WKBbFRU7wkioae90V4dDZe9ajJzBIeUvmcy+y+cIXmp4ST3Qc/1f6oSQhNOIZn
	UJa3pcb5pYP3f+KZcqr81hXaeizkrOSk=
X-Google-Smtp-Source: AGHT+IG3sOtPoGRqFNcKI+Z+f/rXu9JvVms5HR5ddjctBNcQgvZZY+SiZKc3NARtSsnAGIrp2BzBnlL6AhOIJIa98ac=
X-Received: by 2002:a17:906:eecb:b0:b80:b7f:aa27 with SMTP id
 a640c23a62f3a-b803722e390mr222865366b.63.1766140351102; Fri, 19 Dec 2025
 02:32:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
 <9b5eec32-d702-4d77-b4dd-5c33939ae6e2@linux.dev> <CAKYAXd-Lub=zOOE5cW5jEWNYhTJcmX3grZLLXFpZTcwWA4UYBA@mail.gmail.com>
 <805496.1766132276@warthog.procyon.org.uk>
In-Reply-To: <805496.1766132276@warthog.procyon.org.uk>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 19 Dec 2025 19:32:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
X-Gm-Features: AQt7F2q3Dn74Z2Nf7NPCv1l5odjpYcSh_4cNimc9j3cpvm3EgOwOp5HU1VE0F5s
Message-ID: <CAKYAXd_owC9vmSF+ukH-GgG5mWwFWGtwrXNT-8gfUZGHVDTcRA@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: David Howells <dhowells@redhat.com>
Cc: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>, sfrench@samba.org, 
	smfrench@gmail.com, linkinjeon@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 5:18=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> > > We should rename them to `SMB1_MIN_SUPPORTED_PDU_SIZE` and
> > > `SMB2_MIN_SUPPORTED_PDU_SIZE`.
> > >
> > > But we "should not" add "+4" to them.
> > Not adding the +4 will trigger a slab-out-of-bounds issue.
> > You should check ksmbd_smb2_check_message() and
> > ksmbd_negotiate_smb_dialect() as well as ksmbd_conn_handler_loop().
> > ...
> > >    pdu_size =3D get_rfc1002_len(hdr_buf);
> > >    ...
> > >    if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
> > >    ...
> > >    if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
>
> As previously mentioned, the problem I have with the +4 accounting for th=
e
> RFC1002 header is that the size value in pdu_size does not include the si=
ze of
> the RFC1002 header, so the comparison seems to be allowing an overlong he=
ader.
>
> However, I think the +4 actually makes sense for SMB2/3 - assuming the +4
> isn't actually for the RFC1002 size, but is rather for the StructureSize =
of
> the operation header that follows immediately after the smb2_hdr.
Right.
>
> If that's the case, I would guess that the SMB1 variant might want a +2 t=
o
> allow for the BCC field...  but according to the code in cifs side that I=
've
> looked at, some servers may only provide half a BCC field - or maybe even
> forget to put it in entirely.
ksmbd only handles SMB1 negotiate requests in smb1 protocol, And the
BCC (Byte Count) field of smb1 negotiate request must be greater than
or equal to 2. This is why I originally treated any SMB1 request
smaller than smb_hdr + 4 as an invalid packet. However, even if we add
+2, it will be no problem because ksmbd_negotiate_smb_dialect() checks
to verify if the BCC field is less than 2.

ChenXiaoSong, If you agree with this, Can you make the v2 patch ?

Thanks.
>
> David
>
