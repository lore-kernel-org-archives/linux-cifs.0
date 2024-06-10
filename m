Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BE43BB48
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 22:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718059759; cv=none; b=kOgUn/UWMpH8BAT6mhkbDUTk6+ZSLKYRDhs/dk8TpKkDpEp5yGOLdlHFhSDZg093ftIbyFVDf7drFb/WJWPtBYutHDO5C6XVDUJay/qr8fuNWSNSOtJSryVmXliQjnG9XkA+wPhXtcdb8msKN5DVhUZh8vl92U/uXmLS/PCYp1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718059759; c=relaxed/simple;
	bh=u2FVMBEul7gAPJ7V/4timJoDll7CeXutwO8vUG2zTd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dUX2Ytd7NfabA/O8v2t4My5TXiWUA2sI1cqofk+obs/XOAoWJqR5Po4WQQV0QfyJUv9PVOIU+WNkqMaDIqnZEM7pd9JfxGYQULBGydoZq+Rmk2qkv/6K8d6rKbuZjzh2Q9zOF3lnnBoPKF8MXppI1b3Z/DKhdON7QBS7aV/t8dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fzh+FMTp; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fzh+FMTp"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52bc3130ae6so3446652e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 15:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718059756; x=1718664556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KsgyKrlLe94hupt+Zeq3Glf9p46H35l4nZ7xk1lMsNg=;
        b=fzh+FMTpnSqtyHw/hTPxrS9jSSLCO+zB4sSv2guuedv5g4aTlL2zWI+Uu+vCacSpyd
         RN4Mmcd+P4fFPwiLBwoK1Az3arFSVLYSlG4Ih0mdROArs2VdZ9T8MGNp1QqtfOGNiPD4
         wsPE8o1W2i6NWgOut2iBWeD6hYocv3cvV5tP+MSQTQs0kLO4gLhlXMx6EMRuukErqlK6
         3OfK4JQM1Qf58yw1wx9w0zZQolT+KZHwCw0t72gpi2uhnotOoRoegSQJO4DLQOxk8woq
         Tb1DAS7HWYtHDxyWsPMReMAF4pDrFN47o/6uub2fUhXGRi5Myh87PqRYZHRBxby4Hlap
         QRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718059756; x=1718664556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KsgyKrlLe94hupt+Zeq3Glf9p46H35l4nZ7xk1lMsNg=;
        b=ABkerreDp2Tu98LRSCfqV/z/PV+CT1mgErt1Jr3aoNIwawaNz50086QODwnPMPyFYK
         CphhxU/bGOmj26ncGl+o5HLTGgxJ0XRePjVwhvsXqHEk2/rMYNUN2oTfwr3fc84zbDYR
         A/fiwvOqs4uSZiCuCdA4mo/LnrV19g23F6kxLJVS/uzMAUnFMICYOykbyTA4eiXvklYo
         hrAuKRkjR5BCA1aScYC2/0FGbrasAoMPK6Pa9PoOklGm2v6h8eLD7bPCJHjMEYTKPHg4
         lubnZpwEykdkgh8b/xWx6CJo7l8k1zxkaXbMfhFZK3TuTFSrpM+HtXXZ/U6SJXadL21l
         EIHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOewkWWtmfpV/i37NZ5FNHdr8QlDkkKub91RtXdD/1oJypiORz6SZCNZE9zcJrWl9UhoQ7X8eLupF5XuAz1bhzSrNGs4qxuUUiBA==
X-Gm-Message-State: AOJu0YxUFxxhTlm8DPJUDEhIrHS6b3uLKpE9ml4awVulL51OLvhDSzxS
	XvGL04WwqLxDdqDDYRjGA/k4b2hwPWCsK6rClasZxq2DhAR6l0oWAdULdRHvA4zLGk+rqGAG1Tr
	Js3bqmCaGSTo/1thpoAswMwX7g+kkIw==
X-Google-Smtp-Source: AGHT+IFeYGviDgaPPjSd54OHPco1/2CBiuAIxXRRCOn80DdFP/+g6qXz0oNw0E0KSigKqfoWZOq/2NHbhsQRuz+pnIw=
X-Received: by 2002:a05:6512:368d:b0:52c:8f18:f774 with SMTP id
 2adb3069b0e04-52c8f18f802mr1328237e87.52.1718059756198; Mon, 10 Jun 2024
 15:49:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
 <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
 <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com> <0a043592-7034-4478-9969-9c17983886fb@samba.org>
In-Reply-To: <0a043592-7034-4478-9969-9c17983886fb@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Jun 2024 17:49:04 -0500
Message-ID: <CAH2r5mt=RgvYAMKX1zR-ofOEb2h+tcowerJn+ysiKY-+CrLtCQ@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Ralph Boehme <slow@samba.org>
Cc: Andrew Bartlett <abartlet@samba.org>, Kevin Ottens <kevin.ottens@enioka.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 4:19=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
<snip>
> >> a serious regression in the server (but trivial fix).  We are waiting
> >>
> >> on someone to merge the oneline fix to the server (which we tested out
> >>
> >> ok) from David.
>
> no, Ralph.

Oops... Sorry about the typo ...

> fix + test =3D MR + review =3D master
>
> The test is still missing and I was on vacation and am swamped with work.

All of the standard ("fstest" aka "xfstests") automated tests fail, so
trivial to test/reproduce.  Does anyone have a pointer to the
smbtorture tests for SMB3.1.1 POSIX? It only needs a single query fs
info to fail so this looks like only a few line addition to the
existing SMB3.1.1 POSIX tests.   I do badly want to re-enable our
automated testing to Samba with SMB3.1.1 POSIX (the "buildbot") but
obviously this blocks every test.   We do test on every pull request
upstream to Samba (and also to Samba with vfs_btrfs for those features
like "reflink" etc are missing without vfs_btrfs installed)

--=20
Thanks,

Steve
