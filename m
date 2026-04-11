Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33452277017
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775868708; cv=none; b=Y3mgQ1lhjukJdip2IhhgSsv05+Xf3T2RICFAvoTh/LF35SgTKAou9gOhc5d2jywUUKD7pJUKKglwC/kWdBWPgzkMrxFJBaEeLPlAxbbfrVSj/ME31rcqF8wnw1di5ulGcOryLDW8tVQDyKaUM8Ae6RsYKX3CBqXWDtaBS6xOg3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775868708; c=relaxed/simple;
	bh=LoxiaigEOFMpszXvhJNbcYENe4Q00Ele74ENZUAtFi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrrsyFLFC8aAf339is+bEwsGzjvI+ON0r2eJn/mxrQlaEqctPBrVVMOzx4/8KLzFVLHUunc8Oa2iIUshdTWoiAaL+Kk9ZCBWBr4YY+BNqBgw3CmofUQ0uniwVX2o3NFJVI2+wzjN8O9MQeoVP0u+uplUeGJs+aR9/POnaNWaAcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiRJPs6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiRJPs6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D68C2BCB0
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 00:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775868707;
	bh=LoxiaigEOFMpszXvhJNbcYENe4Q00Ele74ENZUAtFi4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PiRJPs6J+xEasbtOk0vt+6zoNSeU5u96O58Z5YDnC/g1ubDeDN/O5gM5tHEzv6bma
	 nM3wouZxWb/nbdvSs/B4VoVH3fJ6WRr+XzY6t+1Nr/vIB4uMbE2c5QkAwlvMQoZmy+
	 1CAXfhjPF6oqKN8Vpg2Ei4HaFNcoVczPM3oM1AFBEa17lJo+GhlJ0PD5LTccI7rjL6
	 +UQ64rXFZ+yoH8TJCL7bwbW6SnGOHNi4x/ppE5bXd3hankt4/lR4bVeZmTPG5mC5hh
	 c6g8AIavNVCvBGxLzVAB7yg6uhBpZI3HPUK/5iVHUMiyQt+qnYW1wJl7Qc0/ElDIaT
	 QGOSCcnDeAFOw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so479006366b.2
        for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 17:51:47 -0700 (PDT)
X-Gm-Message-State: AOJu0YzIi822slSIxHdm2p63PORSmY6AmEhMOBbrt2dFLulm9tRc8MXh
	RHo1sMQrT1+HDl0+17P27cVkQRshG/SF5pJeBQFAjiWWA+Q2bG4TgrXQo6TQOpRgUvzJnR1FsCj
	XVu4EoK+wos2fOnavSPyqzaF6D2vw1vA=
X-Received: by 2002:a17:907:c708:b0:b95:6687:4d15 with SMTP id
 a640c23a62f3a-b9d729c0598mr384575366b.42.1775868706364; Fri, 10 Apr 2026
 17:51:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775838249.git.metze@samba.org>
In-Reply-To: <cover.1775838249.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 11 Apr 2026 09:51:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8p8OJnw4ATHDPi18vodMxVwj+sr+TF-Mj-CcAUXXROzw@mail.gmail.com>
X-Gm-Features: AQROBzDUcHPln10rbmtrEI2bczi3VQg2aX8KBFV-WLmVR4dNYcbRBeBOIxdXayY
Message-ID: <CAKYAXd8p8OJnw4ATHDPi18vodMxVwj+sr+TF-Mj-CcAUXXROzw@mail.gmail.com>
Subject: Re: [PATCH 0/2] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Ruikai Peng <ruikai@pwno.io>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Paulo Alcantara <pc@manguebit.org>, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 11, 2026 at 5:11=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Steve,
>
> here are the real patches for the changes already tested by
> Ruikai Peng for the double-free problem reported, see:
> https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0Divhx=
Q_pcc7immVVOQ@mail.gmail.com/
>
> I prepared a branch that can replace ksmbd-for-next.
> The 2 changes are rebased below the smbdirect.ko changes,
> I resolved the conflicts and made sure the problem is also solved in
> the new common code. This in for-7.1/smbdirect-ko-20260410-v12
> at commit: 274b415378bbd0cf6fde1a719e264cee2eefc06f
> git fetch https://git.samba.org/metze/linux/wip.git for-7.1/smbdirect-ko-=
20260410-v12
> https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/head=
s/for-7.1/smbdirect-ko-20260410-v12
> I made sure each commit compiles fine...
>
>
> Stefan Metzmacher (2):
>   smb: client: avoid double-free in smbd_free_send_io() after
>     smbd_send_batch_flush()
>   smb: server: avoid double-free in smb_direct_free_sendmsg after
>     smb_direct_flush_send_list()
>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
