Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1792D6E58
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801021; cv=pass; b=ShWBrK0d3MLpfWDLt8QUqaZj/lHvheKd7CgcBWhtJWXmU9bqPEh/2gV64DTWNUDaGnrh87riSKFuhY+rBroZaEz3YjDbHDsZ8hqvGgClvTnJT+Vlkt4Dg/SQ2Qste832jRJNWAGnCR8WDetilqmlWITL7b4p0ti3nCM4ZaXpTmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801021; c=relaxed/simple;
	bh=h1rEu2gfWxLVmWy/ltoLx2tX2DVtOvcQC8zgMvbaZ2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tfLlXe2m7Ou3Ua5cSzfdTcHQEvneMTvS4kKsv6vH9Vx50a9gAo810NSxZq9Td1mBvjbvOuXDL9kdAGxovHZAuhnDHGE30BENk4u5Wlk1j4PMfMa96JBG+Kg/yIzwbdm7U4qnHXAdtIssG+1g3nQ8HB56rp14Y0lE9NKjqQpt6l4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GbwJbo4G; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GbwJbo4G"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-914ae4101b4so618345085a.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 06:10:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779801019; cv=none;
        d=google.com; s=arc-20240605;
        b=HPXzmc+j0Ic0qfW2TPDJlO4+F19idV8kj/kOSVCeYvMLnYtZ7ugqXEN3VZv2CbtI97
         BaBfY+47nJqrD51TuCQbXWfQsyTq7ZN1JC23EQ8U5gW0sWoM38RFrNJOqxBvZnTV6POp
         U8wY1L+g+Or3y/oU/foWhZALVz9P0ugCinUJ52ZrPouwjaPhhKdiyzeo06NLIF4czvlv
         5H2Ac3ZggNUl+/qRoC95ig5h423hkH/VkiwJbftHZYV1BDQUjp3WHpZq03ZWYgbORyhv
         /eFSIlndKbHU/eyc0YDaEJbr0zZdZUlgEcwxF3nmLryL0Ihg+8UrC64kkPgZ3CNgOYJp
         vkqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h1rEu2gfWxLVmWy/ltoLx2tX2DVtOvcQC8zgMvbaZ2M=;
        fh=Qia1I5H6h3QG0m0dS15rWOLSQVX6VfAGTeDYGKFK9ms=;
        b=CwZ14kJzs0Xz2tNDzNPNogPD+4IlXrhm2hUQAZHy8bpd8HM53UP5e5NbOGmBq9rNQr
         s2lxvxenUvSMbEgSkdqXfoRs7KL0HwjpzCzYNMvdhpJfJJLXo0CzTpDFpxiXOlX/K6sQ
         EG6viIIbhs7o725ZwO9drpNbcei82eOpQ+Gz8aOyzlm1ZCOdV7d85QOy+60KRBS03xJR
         7RosT+c4PssWxO0L6THjy7tYIJJmulEBush79Bk2UUlBXnM+hZDboGPJiy6+HyjgYom9
         YrszHZby5A2nk4OpuyC5KVRSb08y6Yiv8hb91em6w/KLiX9Qj6ITctMjo0uIif2Sd7f8
         Clyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779801019; x=1780405819; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1rEu2gfWxLVmWy/ltoLx2tX2DVtOvcQC8zgMvbaZ2M=;
        b=GbwJbo4GpnjDSOOo0YLD8gQuDOdIvsmmo80PNVe0slCJ0O0IXNpUDZuiroUOle3pD9
         6uFuurY3T3BA5Y2QaeTt78YzjtCSVc927YYlBNZB/gXtPUNOXFUMuZh9EbheUqVAAH5K
         TuJGGb16VkVTmgZmqnz3X8R1Zw0IknPWLmfYPteGZtSVJzRMpHqMpV0up7BGQjmNPUMP
         9yt/X+ehJ2Ojz+2618QErCERN3yQn1d4Ox/QzTuqybN6sjJDkbnO84q06YyOSgZOUHIe
         zPiGG9GJ/lKkxpHAdIV96IB/diCo8w3ct3GkZTIIW2V2sznyBP0HhGWRSixuwAhJqqy6
         FpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801019; x=1780405819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h1rEu2gfWxLVmWy/ltoLx2tX2DVtOvcQC8zgMvbaZ2M=;
        b=hi7DzeO5QOACA/vp1NWDiB2wE/3DxcvlL29jXLSKvUZoGxxJw9PUjj/rWgecO1MCUB
         YuIYFDHFqsDivNQFKVLbUFqQSL2ovf3xdXtly+abHSfGwP4WtT/GrWm0jLvW4EJVHnFL
         ONBtpMsOnehE67eDO3I+g777POFgn/Gv9yAEmhFPVfmN6HEjszNAV+p9qYWRXpZSrcf0
         OA4y67wW13OzxFdKstjKGuX5ONbnxAaxktIHhIsHog3xk5AFAbzwEm/nsAVwJf1RYzn7
         u+Zxge3ddN4rXfjHJis7ANvP3xEcj2ZkLKxU2ykO7Muf9jDmZQrpNREYYOXP+Bcjp3sQ
         0GoQ==
X-Forwarded-Encrypted: i=1; AFNElJ82NbVs33nTOa7i3A7GAEZ/CM4PffeFEixaMju2OF48WH2cEwZRArwYrfNra0Gjcp6YSDGsjt00zgLt@vger.kernel.org
X-Gm-Message-State: AOJu0YwQhJv+W5ImuDLXkaoHQlYAhModweMaVYuVCVW4TtBzWM8ugpPM
	9Js4RKux0LPmebiwIl8/yAAZZrdVqGvYRMQ/nPQM9GxNjHfjRJ2Ltm7gyIV44qtsfAT3/Yri7cG
	IdKHf1m1/up5L2sAthKizVSvdsJTUnm5QlIBrcLE=
X-Gm-Gg: Acq92OHFTBgzC9fS9BFO7e049sVKnAP5nvVR4iRx9tM2Xa1dyHyklaFYPUUFDSNs+Ph
	B3HNa0V7QYGr0cYGb73Z5btQHaS35npSLvxpFli8xv0dGvGkIh6GLu5WWXGDKRCLPAZ3QPoYFuT
	Wq+U0Aowhccxs97JvPd/RJilI+dlX6vVm+ixWA8EAieFXcRkuod291WYHkjAPH49VZWWCvhbLFf
	zayugZah2tDzmpZ8Kg7z4Mz05Z9BGVbEIII6iyiYv1TTX/7Z7jEA6loTIFBSC4N8FxXBr+D5RIo
	kS1UCavjugzpmc8lgnD0mXC7sAwlrqq3koQQvZcyJ1A0UKI/rqxrlx6XUi5mAgGyvlqndOSDcY2
	yIQVB0h7fg9v2t68diMW9jRldRY9F5LP+sMVdB7AzBnkASMjY2g+xjY8TlNrjVxLE2K7XPyK0lr
	kqsVw8iQ==
X-Received: by 2002:a05:620a:1996:b0:914:cd24:cb0f with SMTP id
 af79cd13be357-914cd24d09emr1669890785a.40.1779801018968; Tue, 26 May 2026
 06:10:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
 <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com>
 <472015a3-3592-4eda-a2b7-9ac2304c1d24@samba.org> <CAKYAXd9wf9L6-ij1AL30rn9jzd4Rdrg4hmptSMBW+rU4HvA=yA@mail.gmail.com>
In-Reply-To: <CAKYAXd9wf9L6-ij1AL30rn9jzd4Rdrg4hmptSMBW+rU4HvA=yA@mail.gmail.com>
From: _Vx Ano13 <ano13vx@gmail.com>
Date: Tue, 26 May 2026 20:10:06 +0700
X-Gm-Features: AVHnY4Jlh9bl5wKkBcLEs0hr-XbNjSoy0wssaVZ5Mo6ZIUK8RaLIGuO0sUTC4nY
Message-ID: <CAFdAxs6Ljafk6fU=jwaH4pwfebjLbaAAttTiar+gsSjiyfNxMw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add missing software bounds checks in RDMA
 transport layer
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, stfrench@microsoft.com, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

To be honest, I don't have the bandwidth to rework the patch or
develop a PoC right now. Since Stefan has already confirmed the issue
in the SMB2 layer, I=E2=80=99ll leave the final fix to you guys. Thanks for
the feedback.

On Mon, May 25, 2026 at 9:12=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Mon, May 25, 2026 at 9:49=E2=80=AFPM Stefan Metzmacher <metze@samba.or=
g> wrote:
> >
> > Am 25.05.26 um 04:34 schrieb Namjae Jeon:
> > > On Sun, May 24, 2026 at 10:50=E2=80=AFPM _Vx Ano13 <ano13vx@gmail.com=
> wrote:
> > >>
> > >> Hi maintainers,
> > >> This patch fixes a missing software bounds check in the ksmbd RDMA
> > >> transport layer. I noticed that a length parameter was not being
> > >> properly validated before use, which could lead to potential issues.
> > >> Please review this fix. Any feedback is appreciated.
> > > Could you please explain where the problem occurs without this patch?
> > > It must be described in detail in the patch description.
> > > And wouldn't it be better to move the validation check inside
> > > smbdirect_connection_rdma_xmit ?
> > > Thanks.
> >
> > I think the patch is wrong as it assumes a single descriptor.
> >
> > These checks belong to the SMB2 layer and not the smbdirect layer.
> >
> > I guess smb2_write()/smb2_read() need more checks,
> > currently is never validates req->WriteChannelInfoLength
> > against the length of the SMB2 pdu, and the checks for
> > WriteChannelInfoOffset also seem to be incomplete, it only
> > checks for a value being to lower than offsetof(struct smb2_write_req, =
Buffer),
> > which that check is not really critical, but a value larger
> > than the client provided request buffer is a problem.
> >
> > I think ksmbd_conn_rdma_write and ksmbd_conn_rdma_read should
> > already get a struct smbdirect_buffer_descriptor_v1 *descs
> > and descs_count (which is the number of array elements)
> > instead of the buffer length in the SMB2/3 protocol.
> Since the buflen passed to smbdirect_connection_rdma_xmit is exactly
> WriteChannelInfoLength, smbdirect_connection_rdma_xmit() can and
> should validate the descriptor. Do not assume that the caller always
> passes a valid buffer. And you need to know where kernel oops or out
> of bounds issues occur.
