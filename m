Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AC61CD0C
	for <linux-cifs@vger.kernel.org>; Sat, 13 Apr 2024 20:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.162
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713038952; cv=pass; b=sJofX2YDOGmqH9cOTYbJhzb88ccbpbkCofLsGXP7yM1cmjanQMg7zTcaMllG7co0D3l16D7aAFQsrDwB7UhTMGSkOYIvESgk0aNygNyCpiCLprbrBpEyPGBhQRh5aWCXnIXRlzdc4lO/FuoudW2CbJ4xWH/bDqytmESbeyPA0xY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713038952; c=relaxed/simple;
	bh=sjFfrLbhmqms7kC12aQQ0KmPRI6LOxxt1dCt7MfDE6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jc65d/QDHWzmkL+wrJWecCXJk6TJfnPp53EMlP72xa6wUZlU9VKEgZ/5GOf3Jpg8uvRAwpFIN+2XmlI7ySZNI5E7pfbeHPZa2ftJuvf3s9PF9bhvTWcUYLsUvwCeeLomPaIcpx4Ef539OP1Y6+Od9m6iwwnvM34y59xPBerzk5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=clisp.org; spf=none smtp.mailfrom=clisp.org; dkim=pass (2048-bit key) header.d=clisp.org header.i=@clisp.org header.b=qY8EYH3F; dkim=permerror (0-bit key) header.d=clisp.org header.i=@clisp.org header.b=JqHl76xj; arc=pass smtp.client-ip=81.169.146.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=clisp.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=clisp.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=clisp.org header.i=@clisp.org header.b="qY8EYH3F";
	dkim=permerror (0-bit key) header.d=clisp.org header.i=@clisp.org header.b="JqHl76xj"
ARC-Seal: i=1; a=rsa-sha256; t=1713036549; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hX+ZYCPuAcCedpYkBVb2/20uHnPlrfji63BUBXgC8j8d5hbVDj3XdekD2uh1lx+Ia4
    T0bHZ98Yh2qRATD7NgGUUT6VZ824OE5kD36fJeMm8SqxtACmYxYECo4Rq4YfpkI2JYPy
    D7pMOlRa02ip3GmkrCACznEOlLFiUXqEThmbzlp14kF4Bb/onIUoAt2n19NsElDhmjUD
    c3bl4JD9bYS1Q6Rkfb8P7CSCgOup4XSF1P9u2Xrc33N7MqUlcuMivL4HwPMTWqcp9SKM
    IkFjuy1cMwq4KqyMu3l5HpES+IIDTyLGNlic4pfptulK+FteqeAgSNcxlf/1fkrfm7PQ
    asWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1713036549;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=qhAt5otVDH8+SsSqvSoB6eSj+C2hGe/xmL7655rZE4A=;
    b=VILB4ZCoqJLIx2eXdmcYaZD6slvAtHXy9Yez3olWjIsO+AI24Aj9d4M/I6kQD6VQGk
    m6H4d/empsBU1sdXNP4GQMWiGhRzlaudSr34E9Cln2M2S/hEEQKSGMHlrhr/legfv1hy
    5KPJfl3Nu0ByO6WCfe8OUoXyLzVkqdYVNaCvmBOHR2PF/2c+M2ph2/KVpQaqEtyHvFQP
    lPXhhh5l7QJKNrUkOZG83LUj7bXR65GbW5Mj0yEIxojFi98Iyi9P1g2Ssb6/2hpSd+gh
    EJlMNtpnzjzNV2llbuFDhyDG91IEZAjitSmYjh9TmeU5+DLpPCVwE5qxiYLwEqsjGLe9
    KnTQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1713036549;
    s=strato-dkim-0002; d=clisp.org;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=qhAt5otVDH8+SsSqvSoB6eSj+C2hGe/xmL7655rZE4A=;
    b=qY8EYH3FjYxBB5Rnf+NHgz4+IfvDIhWq0J9dPOOl2jwW8lR+VmzRLBFuFTmAsNl5Vc
    xWvQXAUz/9ne3XQQNYfSnL3nLbbnA37AK/UrfeoN/d9SVPnP75Y7h4XAJN+lw9b3meZa
    IanZuCP/osfmpNSDQCW4feeK4Twsk7uPawefSc0V6WH/W4RjU1S1xelMK+JJkAKW5AXe
    WmfoDXO1Bg9/nk4H70S562Q1IWhQJ/KI07rPUqgY53aPCJre+AMSl0RG5ePZX9+I/htn
    ntNb9nd7NPUuShcXN+prqdg6nHV25PIOVamCFnuMtZmcV/C2LmhF61TsGZKMBjAi0YMS
    N0KQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1713036549;
    s=strato-dkim-0003; d=clisp.org;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=qhAt5otVDH8+SsSqvSoB6eSj+C2hGe/xmL7655rZE4A=;
    b=JqHl76xjQF2UQRqBl05xh88QoZrYHadpAOBI5SR480SvVHTCccFf0PDa7t4/aiRp1U
    g10p8FsaVYTFHEAJnuDw==
X-RZG-AUTH: ":Ln4Re0+Ic/6oZXR1YgKryK8brlshOcZlIWs+iCP5vnk6shH0WWb0LN8XZoH94zq68+3cfpOQ2aBbMZXs0qeHh9o4fr7Y6SHg3Q=="
Received: from nimes.localnet
    by smtp.strato.de (RZmta 50.3.2 AUTH)
    with ESMTPSA id N8610003DJT9fPk
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sat, 13 Apr 2024 21:29:09 +0200 (CEST)
From: Bruno Haible <bruno@clisp.org>
To: 70214@debbugs.gnu.org, =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: bug#70214: 'install' fails to copy regular file to autofs/cifs, due to ACL or xattr handling
Date: Sat, 13 Apr 2024 21:29:08 +0200
Message-ID: <7050532.CnaeKSotiK@nimes>
In-Reply-To: <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
References: <6127852.nNyiNAGI2d@nimes> <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi P=E1draig,

I wrote:
> > 5) The same thing with 'cp -a' succeeds:
> >=20
> > $ build-sparc64/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
> > 0
> > $ build-sparc64-no-acl/src/cp -a /var/tmp/foo3941 $HOME/foo3941; echo $?
> > 0

You wrote:
> The psuedo code that install(1) uses is:
>=20
> copy_reg()
>    if (x->set_mode) /* install */
>      set_acl(dest, x->mode /* 600 */)
>        ctx->acl =3D acl_from_mode ( /* 600 */)
>        acl_set_fd (ctx->acl) /* fails EACCES */
>        if (! acls_set)
>           must_chmod =3D true;
>        if (must_chmod)
>          saved_errno =3D EACCES;
>          chmod (ctx->mode /* 600 */)
>          if (save_errno)
>            return -1;

And, for comparison, what is the pseudo-code that 'cp -a' uses?
I would guess that there must be a relevant difference between both.

Bruno



