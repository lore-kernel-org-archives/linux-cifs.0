Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9AD9460
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773672564; cv=pass; b=kKFN6h/mBsvY2ix0ilIYtlwBTywPQejfmNYigVS/pwDHcyLL3u59wMd+x2MeNz3QpMRfVY5eA5qRjrnC691cwFKHnAeo2J+XB1eq24xGlrw56f8UEHumVBfd66t/xVEgpo7q+u3tlXA2YckR1QOSPRjvAC0G/iJVqMab/iG5ORY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773672564; c=relaxed/simple;
	bh=YheuHDIQ1bTx+2Yrws4P8yJydCNsZZdPGX5a4Tufyf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F00aRIPJEytgLKG1EkECIFis3UbislmgFpfdoo0ILiPUn3ZQ7kRUIKcyGliiQvr9pN7GMhNe7bx2xq66isCe/TLQW996Wl5glE31djPTjpgFN7BKDpvenk0SmKDv7cZ/FrDgDSN7zw6lG2Ojb8z1I2FdtsS7oSXEQwxZYzRqwPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IdPS+aDS; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IdPS+aDS"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a1687f112bso1850690e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 07:49:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773672561; cv=none;
        d=google.com; s=arc-20240605;
        b=dq+AOtLITXO5Z+q5XKkAmjbU6NTElKEqaJroOeNLzZxiFvKtHKwRqSLlznltm7/fJs
         /k6f/nFTiwKuzEW8/uG3RGjOhLGF/yvtX8I6bQqf1Jj0cBA/kyrOT3Ou638FY+ZZKW/R
         E/rCMr9Huk0ziMzzyVBCE0R1l3eFpAAhIuoAZABEWPcJnBY/T0MUu3GKtJhatMpk54iV
         +kTOy78dUaftyB0NBeRt41zJ+mS97smeYBn9P6MopDbTwvXb0EIiyrNmbnjSksuEw0eg
         KB44Xfw++ZVfUoYnnp6iLX5lMFAqRtbBY3QbMI8+IleVy/7BAQTK5zdbxHJ+TY5gOowF
         jjxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YYj7CGaE8fwoH5/Jh9Pisug/+kQbkIzLGXVuMTPy9oE=;
        fh=ni3teZXND+kJQhRlYsLH0W8mFOAMGXbXDbDp+D/FErQ=;
        b=aigHUXWQhPh3+DgMxaKgPYfbyfPkisc+Jniro/L+Y+NgUyCdZkWpZjJdcSzLK8/JNU
         1aLLy9nFtmqrdSp96VzVWW1S30eJaXpyktVTWzQAoV0wsbAhxTqUkpkzWm3usQP+ClCC
         3SiThIB7GWIxht+VvnHuL3Pn5GBOj57ypFkIMU3Wrpv9n1rBzc8DCrBMUPnsMkMrpDIf
         GFuP6JUrcpBV+qq1Z5nf1UhRkPeYPSuXjmdCNmZvP4EYgAna166K2WNIF0oKJ4YhyiNg
         VXuo4i6Y9tA9zPsoB92Ewnhi6ZlPthUnwwQPx9yMYvEAj64aTWZG73LxdAST5pU1AOrk
         Du0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773672561; x=1774277361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYj7CGaE8fwoH5/Jh9Pisug/+kQbkIzLGXVuMTPy9oE=;
        b=IdPS+aDS/6bzDgRQb1vfTdq3S234zU9LbGT5lkmBvDCvuU/1QO2rwca30CqYmDpGfb
         sMwDv4Jn7J+j93EZAurIb/rjWNbyuVfyj4HGUpRH8s/ejPIKSLpgLTspeSAvLnQpPctK
         KvpmSt48fTfoddn9zZQTFyqA4KWtA5ciDx/bE4fWSd1qzVeCgBIf5cG5yvXLavYfB/OP
         2SPBfxkPQSFO3R6GxMQN/OwtsEN9WPbIFjnUZvlJ7vD9R9iNtHKhO9dhQkU0RzxltFp3
         cMDhneUItQ0KKp5i3NN0OCx2u4o6lgsohQAS4ynNo+qJS6TDQamnjo+5xX9sUSjTviQQ
         Gd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773672561; x=1774277361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YYj7CGaE8fwoH5/Jh9Pisug/+kQbkIzLGXVuMTPy9oE=;
        b=SYMdAu+n3fnR9tf6QSag5AmHNsHs1A4IbdJw/w1FrkNX/okNRLwdWX32LO4LKJ35qq
         RNYf2JN5AAp2xj+EcyWYDurqx3bjjyrllZZh12l4icOH7hTW8vwibMdumdf6I80sb9jD
         BE9OXutzn+iS9UcI806o259iQLaxRcBt7OYwSJaQodSOe4WlJ+mlvdPdbYuFBA3UR7eG
         Ls0nuJcQVuQ0IEKHC8T2gCFzkMkndjGA5s94KzZ1dgmWVFIlyuIrTdryhZHL0odXuAtA
         ovpWDvxIrT/gNsaSgtmVfJ7O6LV/0Yn+kTuahm4+6krYH5WhT6WmDXKaMRbuK7q1h627
         3HQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBF7E3HzdPXIjFwgJ4nIIFG7BC0WdynkU3fEl0n6N/XZiSxG/v1o555qV+ViEusJVVaLPX8ksQ4/PQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ7ACrKGo5y+eZd0JmlP+HjjFryqYk8He+oT3n05T1N1sGwzcF
	IPfVelchrAm88/IpjL5qE8ay6r9m4ZGtBafUAGsbvXUhneAKkn6fCEZB/bgMtFhAuBk4Z189ckG
	vku32VwD9jBYrY1eAnepBtXyUQBU8fbE=
X-Gm-Gg: ATEYQzwNNhMI9r2/0MbhElCEvVi7JQFeA/faxn6gEi5VqnbDy4PXFdEjaJiTCOZ3tDJ
	gqbNSYGRtWrOX8mTbM8epKdDQDObCylQJenetGYTGXLc+MBJumWNMaFd+GiZbM9iS5kt6FXaVfa
	rRAJyw45s7R7iqVlI6BI0OMrMvw9oKyzsKJoUy3NkqKNEeGIagbVDs6DmmQx+FuvurGfpNo0Jde
	WgT+ioLucSuFZlX9XkAJoEIGcZ6GLFg2Mv//Lx5DX9TIennYlx30Oq6pQACKkqNlw+FQ0MT/oI7
	sLjqHXP+Nhu17jXn3jaPPBD+Ily+rI5z1EbZawgANB1/8z5HpHclTQt3iD2sHY7nBYzUd0WFe9d
	Zpb00zapzAOUYwPzEGYMh35Rj6bAxuOlMvconoaTEj9etLn4xecOxPJ5mXTMziQ==
X-Received: by 2002:a05:6512:3404:b0:5a1:4bd3:7b5 with SMTP id
 2adb3069b0e04-5a162b22421mr4609951e87.29.1773672560923; Mon, 16 Mar 2026
 07:49:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b3da51e2-5360-4931-a5ce-95de39cbb294@samba.org> <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
In-Reply-To: <12936912-5c98-4599-9e6f-b454ad18d264@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Mar 2026 09:49:07 -0500
X-Gm-Features: AaiRm52wqT6K3rcNJF9Wk4BMkdZmsQyT1hQrLXHgW7ya_9j8OfUZgkqbnrayVvQ
Message-ID: <CAH2r5mvkGKex_Z+VAZtuZbAEzHM+Ov3O=TH_K4K1_RXVg9iZLA@mail.gmail.com>
Subject: Re: SMB3 POSIX, byterange locks and close behaviour
To: Stefan Metzmacher <metze@samba.org>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>, 
	Steven French <Steven.French@microsoft.com>, "vl@samba.org" <vl@samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 6:47=E2=80=AFAM Stefan Metzmacher via samba-technic=
al
<samba-technical@lists.samba.org> wrote:
>
> Hi Ralph,
>
> > while working on the part for byterange locks of the SMB3 POSIX spec, I=
 noticed a problem in the protocol:
> >
> > Neither MS-SMB2+ nor the SMB3 POSIX ext has a way to send a client side=
 identifier for the process (like the pid) to the server. That means when p=
rocessing SMB2-CLOSE we
> > have no way to correlate opens by the same vs different applications (p=
ids) on the client.
> >
> > Suppose on the client this happens:
> >
> > 1. application A (pid=3DX on the client) opens fd1=3Dopen("file") and s=
ets a brl
> > 2. application A (pid=3DX on the client) opens another fd2=3Dopen("file=
") and sets a compatible brl
> > 3. application B (pid=3DY on the client) opens another fd3=3Dopen("file=
") and sets a compatible brl
> > 4. application A closes fd1
> >
> > According to POSIX rules we have to drop all brls on "file" when closin=
g any fd on "file", but this can't be implemented on the server, as we have=
 no way to tie opens from
> > the same client side process together.
> >
> > It's also not possible to implement OFD locks in the protocol, same pro=
blem.
> >
> > Using OFD locks in the backend on the server doesn't help.
> >
> > SMB1 had pidlow/pidhigh in the header and MS-FSA "2.1.5.8 Server Reques=
ts a Byte-Range Lock" has:
> >
> > ---8<---
> > The server provides:
> >
> > LockKey: A 32-bit unsigned integer containing an identifier for the loc=
k being obtained by a specific process.
> > ---8<---
> >
> > and this part of MS-CIFS "3.3.5.15 Receiving an SMB_COM_LOCK_BYTE_RANGE=
 Request":
> >
> > ---8<---
> > Locks prevent attempts to lock, read, or write the locked portion of th=
e file by other clients or PIDs from the same client.
> > ---8<---
> >
> > ...implies the SMB1 server passes the PID as LockKey to the FSA layer.
> >
> > SMB2+ doesn't have a PID nor has POSIX-SMB2 and I wonder if we need one=
, at least for the lock/unlock SMB2 requests. SMB2_LOCK_ELEMENT has a 32bit=
 reserved field which we
> > could repurpose, but there'll be dragons, so we might need a different =
way to extend the protocol.
> >
> > We also have a 32bit reserved in FilePosixInformation, that would fit t=
he bill.
> >
> > Thoughts? Am I missing something?
>
> I think it's the job of the client to coordinate its local processes.

Yes. But it would be good to have a test case to repro this to make
sure client does proper behavior.  In many cases the client will reuse
the same open handle for multiple processes, but in cases where we
have two handles open, it would be good to have a test case to repro
this.

> I guess the client can have just a single open to the server for local fd=
1 and fd2,
> but in the end it's a local problem on the client.
>
> I guess a Windows client has to solve similar problems with multiple
> applications running.
>
> metze
>


--=20
Thanks,

Steve
