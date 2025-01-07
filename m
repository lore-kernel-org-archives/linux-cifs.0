Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C991991C1;
	Tue,  7 Jan 2025 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736292736; cv=none; b=itCLGVVandh12m2HTJPp84yPLE8WmyCd8mSgTnbNd7M3Lm+VJwt+skR95qJmPwbCBdvuVx9KEGiKutmMpc7R6/VUSE0pz6CJLkInj/ljRJnurcqIVPnzD39NK3Sw1lU3lrYBWQRPP3hPOK+4wbYvlglMSyT+UcSBo1Yh+TAjP58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736292736; c=relaxed/simple;
	bh=zM81Xe4W8/NlcGNF2Z3ub2t7cJUXqXd0qko2XJhgRJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=unKbUJu7lqhCVfX4RY5jhl4+CFYYEkYNH70DqQHZ6m29Y9ZJNhnuBzbMuwttwsmbuG/Qv93PtqY/5h2FYDs5qS+QMHcO5XSETPocfAW3+1/iyuOYYW7WCIf1SLjpYb9kvesBbeP62ZhSA2OwlRlH1f6BNfsgfqMtHlGqP69uvIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIJQx9vH; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIJQx9vH"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5401e6efffcso18662953e87.3;
        Tue, 07 Jan 2025 15:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736292733; x=1736897533; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxXBV5c9fPv4OwxnsAQNe1BlnMkkRxn9uY6zafjAKDg=;
        b=YIJQx9vHohKhv78Ey62mieXQnaZnr7b8l787oQxnOslHVh3UWj1UyB6gJR9g6Cbnza
         7sykXydQZfjNBTBNhcCUlvyljNJsEImdicd7FijUVGM/jYKHaDKi16uJLV7ndE8KOjNr
         oQypFvhbgOqAMVu2MkmvCvZIR2OwaMVTFZqHDNPnZFUbzut/YG2iQmiQvCqs/hGGaQLa
         RUf7t11cImpU8bSsFSlhklzON/FgO33MZSyn4mk8ByHW3Q5x4YSJ6POvj49PKdJlQq41
         rbRtqGLausfk9FvKidWUSVXBoGedGDCQ8w85UFvmVJE4rUETnOmZXfwbZRW2nDpTbd7B
         FF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736292733; x=1736897533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxXBV5c9fPv4OwxnsAQNe1BlnMkkRxn9uY6zafjAKDg=;
        b=Udd25xmaMo5vc57DqRIb51k/Msv4Ue3bpjd/LS4leQoRkmof/JZMRdUyefrVHnaST2
         o4jhWskSOxGDgMCXAHWWML+lrbmgav+9RsdBbxqUyJPBEei7kcTZYnnVF0NVwShMuE/V
         HncF+3+iYQHmp+NxZfik2HNWOfvVfQ4CPU3VM/OhPy2Xb87eIQ70Bgz0IwwnX3MMI7JN
         L8dN3kgesBuPJfjnpcENswy+OBL4BPpOrPsdZIBrj1uGTQw6LmheDtB99+sMt2pAVghp
         2iQp9aGFtxNejEdBu1b8HjGPCRKSIwh6eNyaBOg/5HuARtcbx6dh3nzk9tE4MvXmqBSE
         O6nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt8pWqfnqEFiY1PhkwbJ+yUK17QVrw0hC2dHlMa5EIxWN6z+BoOMvPWjY+bBraVdBEOdUBJHwfUgGx@vger.kernel.org, AJvYcCXyGUmXLt36g20Af+gqEs0tVgK4joWz5du2FhWevZa4aEhziJNWpRpfgz3tlzCrJrzSjycq8ad3t31Aq20x@vger.kernel.org
X-Gm-Message-State: AOJu0Yw683lJO1aJua154F5fXHRsab+rzCAvJ7phl4ghiuHYWJLBHcLX
	JHkuVfBf81hRG4jRqbhj9stl0UNxNAZKLYRM0oKvMUruWqwlNIlhNeZ8gmkWp4251/3ecfwEA4w
	8TkIODmsgDUO6jpbQhLXnPir4oCg=
X-Gm-Gg: ASbGncvrGizHkzjlrezWDRqMFg7Ul9Ugq6mEG1nyfm39jX/kql44rzwq3eT9YjArOQi
	XXfXcAO77ddUQoD+hK0AJ4gXVBiOO/QUG4NIJuugenNJINBQR6qAxxa9aXFz5P5MmU8+uD7Gk
X-Google-Smtp-Source: AGHT+IH+MRbkM8q7/bjc9bqgmQ36M8ie3TTDiuqAlOH7pGMYv6vivyZKn+f19hlkMFpvoP7V6xjuQ2CEzk+GkX4sW5c=
X-Received: by 2002:a05:6512:1150:b0:542:2166:44cb with SMTP id
 2adb3069b0e04-54284815b35mr148081e87.35.1736292732236; Tue, 07 Jan 2025
 15:32:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250106033956.27445-1-xw897002528@gmail.com> <d013fffa-8ed3-4c96-90a1-df2e7f45380b@talpey.com>
 <CAKYAXd_Dj+YCKYQNO_g4WwARcxkKCB4TZLriuzhm-u9o+kuAoA@mail.gmail.com>
In-Reply-To: <CAKYAXd_Dj+YCKYQNO_g4WwARcxkKCB4TZLriuzhm-u9o+kuAoA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 7 Jan 2025 17:32:00 -0600
X-Gm-Features: AbW1kvYCilnFAXNsCaESqfTxUcNF16qEsFNKvz3g-AdTDRWbp6_zGIWdYz5QWLw
Message-ID: <CAH2r5msTAPTtkkGftQ2yZK1KrQfp8gaf2QJqOF5Ewx947iMGvw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer size
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>, He Wang <xw897002528@gmail.com>, 
	Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 5:14=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org> =
wrote:
>
> On Wed, Jan 8, 2025 at 6:04=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
> >
> > I do not believe this is correct, what "man page" are you referring to?
> > The commit message is definitely wrong. Neither value is referring to
> > generic "maximum packets" nor "incoming requests".
> >
> > The max_qp_rd_atom is the "ORD" or outgoing read/atomic request depth.
> > The ksmbd server uses this to control RDMA Read requests to fetch data
> > from the client for certain SMB3_WRITE operations. (SMB Direct does not
> > use atomics)
> >
> > The max_qp_init_rd_atom is the "IRD" or incoming read/atomic request
> > depth. The SMB3 protocol does not allow clients to request data from
> > servers via RDMA Read. This is absolutely by design, and the server
> > therefore does not use this value.
> >
> > In practice, many RDMA providers set the rd_atom and rd_init_atom to
> > the same value, but this change would appear to break SMB Direct write
> > functionality when operating over providers that do not.
> >
> > So, NAK.
> >
> > Namjae, you should revert your upstream commit.
> Okay, Thanks for your review:)
> Steve, Please revert it in ksmbd-for-next also.


I have removed  "ksmbd: fix possibly wrong init value for RDMA buffer
size" so ksmbd-for-next currently has only these four:

37a11d8b2993 (HEAD -> ksmbd-for-next, origin/ksmbd-for-next) ksmbd:
Implement new SMB3 POSIX type
2ac538e40278 ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_lo=
cked
c7f3cd1b245d ksmbd: Remove unneeded if check in ksmbd_rdma_capable_netdev()
4c16e1cadcbc ksmbd: fix a missing return value check bug


--=20
Thanks,

Steve
