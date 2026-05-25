Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768EC383993
	for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779718334; cv=none; b=oRRsVz/CE+ZDqXSZ5VoDrRJbv+GXL1tYrjDrsZP62MZQuMaY0x7zFlXBEOfMD0rqG1ZXnxq/p6k7vcw1kySu94lpar7dYLwqW4coCRWCLDEqo7MGnUjUJ04ijlZJMg/JNtUi7x8fQBnjvg0wc7UV+rlsnxKwKmOvnI0tFSHqw8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779718334; c=relaxed/simple;
	bh=6ChUvdruUOSXCr65gCgmWBaXKUFPey3RHg9GpdUGUMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SJSKFsJoYKAsl6RLeyPaeN35p36XPZGenyH4Jr6SXG+g3qrehMcOJHy4GFuNkC1twndzL2FPyp3kYJAPKr7JlwvHIzvy3iamta/QFpHlXthNSJzZPTkcCC4Aqmhcb8B5SVrOkc2stVVjaa8MEQsbfzYz1HPaxA04ySJ1wK+CpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCkVIeh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCkVIeh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57F81F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779718332;
	bh=6ChUvdruUOSXCr65gCgmWBaXKUFPey3RHg9GpdUGUMM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jCkVIeh60PBiOfBrxBx1k4RhG4LTYDODEL4+70/AhTjb58xVBx2pM11Nt0k6SbHcQ
	 g1T8UzdB8EUSdD9p2vMziI1TknDhr27Z3QVh4FTYMLuM5XWskUnQqQwtBXfazoimtj
	 nfc7MbcCv5X7poGjC2eVCeyE61M9r4CCJezQgU2x0agEVrq8FvwPxEAla90x5iumT1
	 WAdSoGmI297E4meSwRjo7TFV8L62S+iRNcMHayulRWtP9HZ67MWq7gwlMbPyRbDyT4
	 PpeO12lAnf17ReYs5FTBQW5eaRZu06ik68TdYggJzOkYAhPVMejKfkNMf3Y5+SxgDK
	 DCgbQl+KM0ZNA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-687d82dd690so3323990a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 07:12:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/6/ITpFNEr2emzEjwrqQMfKPQPj31Xorn+R2HgFF3oBGkuQdf+AL4deVXBdEQJOkymd2nJK4VRgbMO@vger.kernel.org
X-Gm-Message-State: AOJu0YyHl/Zc6i5zX1U5IL+zpWBsBfmFgEYCT3LiUc0I8+p+rdOd4IzC
	EuX7/U6h3awBoCA8xDg+ENFyMWplMfjuLQYMItgdPFWoAg91lyblbl6dTHBw40PNaAtClsQfIlh
	JI5d2nAuW+UWm7Ku1u3er6MAvVsff4AQ=
X-Received: by 2002:a05:6402:3907:b0:687:f18:c37f with SMTP id
 4fb4d7f45d1cf-6889cc6c63emr7071211a12.22.1779718331500; Mon, 25 May 2026
 07:12:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
 <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com> <472015a3-3592-4eda-a2b7-9ac2304c1d24@samba.org>
In-Reply-To: <472015a3-3592-4eda-a2b7-9ac2304c1d24@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 25 May 2026 23:11:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9wf9L6-ij1AL30rn9jzd4Rdrg4hmptSMBW+rU4HvA=yA@mail.gmail.com>
X-Gm-Features: AVHnY4KeF_QxkvrGxKYRV_T6q3g31-tjve9jrun6yJTEXHoDnRZuqJj2j4RS_N0
Message-ID: <CAKYAXd9wf9L6-ij1AL30rn9jzd4Rdrg4hmptSMBW+rU4HvA=yA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add missing software bounds checks in RDMA
 transport layer
To: Stefan Metzmacher <metze@samba.org>
Cc: _Vx Ano13 <ano13vx@gmail.com>, stfrench@microsoft.com, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2026 at 9:49=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 25.05.26 um 04:34 schrieb Namjae Jeon:
> > On Sun, May 24, 2026 at 10:50=E2=80=AFPM _Vx Ano13 <ano13vx@gmail.com> =
wrote:
> >>
> >> Hi maintainers,
> >> This patch fixes a missing software bounds check in the ksmbd RDMA
> >> transport layer. I noticed that a length parameter was not being
> >> properly validated before use, which could lead to potential issues.
> >> Please review this fix. Any feedback is appreciated.
> > Could you please explain where the problem occurs without this patch?
> > It must be described in detail in the patch description.
> > And wouldn't it be better to move the validation check inside
> > smbdirect_connection_rdma_xmit ?
> > Thanks.
>
> I think the patch is wrong as it assumes a single descriptor.
>
> These checks belong to the SMB2 layer and not the smbdirect layer.
>
> I guess smb2_write()/smb2_read() need more checks,
> currently is never validates req->WriteChannelInfoLength
> against the length of the SMB2 pdu, and the checks for
> WriteChannelInfoOffset also seem to be incomplete, it only
> checks for a value being to lower than offsetof(struct smb2_write_req, Bu=
ffer),
> which that check is not really critical, but a value larger
> than the client provided request buffer is a problem.
>
> I think ksmbd_conn_rdma_write and ksmbd_conn_rdma_read should
> already get a struct smbdirect_buffer_descriptor_v1 *descs
> and descs_count (which is the number of array elements)
> instead of the buffer length in the SMB2/3 protocol.
Since the buflen passed to smbdirect_connection_rdma_xmit is exactly
WriteChannelInfoLength, smbdirect_connection_rdma_xmit() can and
should validate the descriptor. Do not assume that the caller always
passes a valid buffer. And you need to know where kernel oops or out
of bounds issues occur.
