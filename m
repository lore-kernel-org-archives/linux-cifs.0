Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793063958;
	b=D/4O6MI0lnH/hC7JE6iVWA4Nt7dYYQRK5bErhjjXP0IeV1ttQCt3TIiLp89tWQ0i44O6
	 GMjrhvrHWoYub6Rkdjv6Q29SyC4uIZ4TDzIIxXQDdV/Oz6S903PzX7No494ZGOl3e7KFl
	 AuNqm3kx9nmtbIzHqkM0ofw9APx/sHjrIhovmndsPGGzkcsR5ERftlQLkPP+pPiMWnScB
	 HNTKoWUzEYw1mn0ywzgStFMNNEPrWQIP9QXl7PZhhUB2OPa7Z+LxO/PdLFrNbQhKMM/4R
	 W97H0w7eS68ZqDEtrrtz2Cnc92t98Gi5LhOns7tTY4VAASLknlZfRTJ9pEj6tsJ67Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793063958;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=V6ucdF8CVrL1H+b/a6ewy2PMRiq8ZA0KkSsjiF9N63U=;
	b=0OkvoZixrfoAkOK03iisdyCYF7+wLWCeFWiddHsD70vyXfeLwfoQBrTmphcvy1pvwH2a
	 r2JpoWrTZQX0dydIlL+xUi+QOADooldskSiEzq1LCE5v2EkgcQC7zFFepjAllmod4PXfn
	 eQKdIYhHGo6SoEzvD1TkzjMTv6jADjcWk/CcV+Ozy5ioSyWqPqlFDg6NV3T7/mtMtCMCc
	 0Owt/uCJ5L66fXVY4AQ0azldZ8GJdSqCr9Jo1yIo/zxUkXVog1NBrVgg8/BU0JM66WDKp
	 RR0yoZHUgDcYt0bfUxBZpZRhNXbOa++O9BbGgwntZfLhyIdtz40cx9nG2Rc4KNiWdbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khbSiHL2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A83606A31A
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=khbSiHL2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7821E1F031E1
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 01:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793063957;
	bh=V6ucdF8CVrL1H+b/a6ewy2PMRiq8ZA0KkSsjiF9N63U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=khbSiHL2itRIN80YPJKpp+/eCfuMc/mokXqb3jMicljhAZljQklxBUcxNipY8q4PG
	 6MAwtjZ4c6mNU0LHZNlb+e2dKvNLbZGimw63AmaCyZ1mbtZJBrwKPU/7uefuKI4qRH
	 nbKE3dGBPIty9DQoSP5VjTgFvRMls8yg65BC3Va6lXIkfYWHVHstwPeSlPLuQwllQG
	 zn5VMah3o0jFKkxUA9sABcrPHXW7cpV7x5Mb0X/4J0rolUiX9Yh1NwfTrbfTGxR/UH
	 Tbr7ijhGWlj3wNq3FHtknO3BBnv6ejhfcwpV0dUG13CY2rXIpeMG/GOvUgltH6tleM
	 V7MPN1QMvE6Hw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40f29667e6so579694666b.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 18:19:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwlQZsLInEeKKCK+pXdrEV6PVLrWP3XYnWkEUFSn4aE2OzGNFu1gm47etNQptOwq7EGZ+SLxxICATcb@vger.kernel.org
X-Gm-Message-State: AFq9FYJ9PbhHaxZFeiWDJ14OfXQqwgPpCX4Ol/VfsgFGlMLnnZoZ/kJE
	Yy9lFH4ILt/R6EFI3pcsQ7dzY+yuNZy7/101otddCyG+Okr+xEpCMS2IRCLglk48P1irm4Th0TO
	jC0io4FPf1RfPVoS0K9ZrG7CD/FDETqM=
X-Received: by 2002:a17:906:d553:b0:c31:c767:ae0b with SMTP id
 a640c23a62f3a-c46bd906647mr905168766b.0.1793063956037; Mon, 26 Oct 2026
 18:19:16 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com> <af546d6b-d1c0-45df-8f81-ad839e7e4d6d@gmail.com>
In-Reply-To: <af546d6b-d1c0-45df-8f81-ad839e7e4d6d@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 27 Oct 2026 10:19:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-OpiRi2uQzK81rJpHis0VkS-gTaZpQWJ4TZH_RJFzL6g@mail.gmail.com>
X-Gm-Features: AclHuK9JxMtnlt53AqO7LF3FG6G1nnO1heXsQG0vFMGDEfz2ZPeUYa9Joj1Z150
Message-ID: <CAKYAXd-OpiRi2uQzK81rJpHis0VkS-gTaZpQWJ4TZH_RJFzL6g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ksmbd: fix named-pipe reply loss with small output buffers
To: Wang Zhaolong <wangzhaolong633@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 12:20=E2=80=AFAM Wang Zhaolong
<wangzhaolong633@gmail.com> wrote:
>
> Hi Namjae,
Hi Wang,
>
> >
> > if (rpc->pending)
> >     rsp->hdr.Status =3D STATUS_BUFFER_OVERFLOW;
> > Should we add this check ?
> >
> >> +       goto done;
> >>
> >> +empty:
> >> +       err =3D ksmbd_iov_pin_rsp(work, rsp,
> >> +                               offsetof(struct smb2_read_rsp, Buffer)=
);
> >> +       if (err)
> >> +               goto out_put;
> >> +done:
> >>         rsp->StructureSize =3D cpu_to_le16(17);
> >>         rsp->DataOffset =3D 80;
> >>         rsp->Reserved =3D 0;
> >> @@ -9349,7 +9375,6 @@ static noinline int smb2_read_pipe(struct ksmbd_=
work *work)
> >>         rsp->hdr.Status =3D smb2_pipe_error_status(err,
> >>                                                 STATUS_UNEXPECTED_IO_E=
RROR);
> >>         smb2_set_err_rsp(work);
> >> -       kvfree(rpc_resp);
> >>         return err;
> >>  }
> >>
> >> @@ -9947,7 +9972,7 @@ static noinline int smb2_write_pipe(struct ksmbd=
_work *work)
> >>         if (IS_ERR(rpc)) {
> >>                 err =3D PTR_ERR(rpc);
> >>                 rsp->hdr.Status =3D smb2_pipe_error_status(err,
> >> -                                                       STATUS_INVALID=
_HANDLE);
> >> +                                                        STATUS_INVALI=
D_HANDLE);
> >>                 smb2_set_err_rsp(work);
> >>                 return err;
> >>         }
> >> @@ -11440,20 +11465,25 @@ static int fsctl_pipe_transceive(struct ksmb=
d_work *work, u64 id,
> >>         struct ksmbd_rpc_command *rpc_resp;
> >>         struct ksmbd_session_rpc *rpc;
> >>         char *data_buf =3D (char *)req + le32_to_cpu(req->InputOffset)=
;
> >> -       unsigned int nbytes;
> >> -       int err;
> >> +       unsigned int nbytes =3D 0;
> >> +       int ret;
> >>
> >>         rpc =3D ksmbd_session_rpc_get(work, id);
> >>         if (IS_ERR(rpc)) {
> >> -               err =3D PTR_ERR(rpc);
> >> -               rsp->hdr.Status =3D smb2_pipe_error_status(err,
> >> -                                                       STATUS_INVALID=
_PARAMETER);
> >> +               ret =3D PTR_ERR(rpc);
> >> +               rsp->hdr.Status =3D smb2_pipe_error_status(ret,
> >> +                                                STATUS_INVALID_PARAME=
TER);
> >>                 smb2_set_err_rsp(work);
> >>                 return 0;
> >>         }
> >>
> >> -       rpc_resp =3D ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
> >> -                                  le32_to_cpu(req->InputCount));
> >> +       /* Write new input without reading past an already buffered re=
ply. */
> >> +       if (rpc->pending)
> >> +               rpc_resp =3D ksmbd_rpc_write(work->sess, rpc, data_buf=
,
> >> +                                          le32_to_cpu(req->InputCount=
));
> >> +       else
> >> +               rpc_resp =3D ksmbd_rpc_ioctl(work->sess, rpc, data_buf=
,
> >> +                                          le32_to_cpu(req->InputCount=
));
> > This WRITE leaves KSMBD_DCERPC_RETURN_READY set in mountd. After the
> > cached reply is drained, the next TRANSCEIVE can return the previous
> > reply without processing its own input.
> >
> > Thanks.
>
>
> Thanks for catching this.
>
> I reproduced the sequence you described and confirmed the problem.
>
> For the READ path, your suggested STATUS_BUFFER_OVERFLOW check looks
> appropriate when a positive-length read leaves unread bytes from
> the same reply.
>
> For TRANSCEIVE, I think the correct fix needs some discussion.
> One possibility is to return STATUS_PIPE_BUSY when cached reply
> data remains, without issuing another IPC request or consuming the
> cached data. The client would need to drain that reply through READ
> before submitting another transaction. MS-FSCC =C2=A72.3.48[1] lists
> PIPE_BUSY for a pipe containing unread data.
>
> However, I would like to confirm that this is the intended behavior
> for this SMB2 path before preparing v4. Simply omitting the WRITE
> and returning cached data would still silently discard the input.
>
> Would rejecting the transaction with STATUS_PIPE_BUSY be appropriate
> here, or would you prefer a different approach?
I think the former is correct.

Thanks.
>
> [1] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc=
/f48cecf1-98d8-48dc-926f-2f3a48f07cf6
>
> Thanks,
> Wang Zhaolong
>
