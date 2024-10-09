Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21062154C00
	for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2024 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728450916; cv=none; b=bs1xpcaDoIV0zOsSnb6a30AbXKzmS76qsNcEzBliuJkwPm2C4IQPH5L0MXA6PATrT3Ou6Vl0v50AswVshQJ+6oaDl0F1O6KQjVL3sBCTbDIqf1hqWGngQINJoqsvB/Mh5eoxbov/WqSYNpeMY2usdPfxdMmS+aUWOGT+C4fpfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728450916; c=relaxed/simple;
	bh=m9TrV6EgG7S1Q9poiFU9v6WOpVYYQVF/p3D1Mu6AULI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CWdNKivxx+h0RYyss179C2QI65vMaeYIB+XUinx5Mt5rZwLvI8kWyLEkl5jX42tYktrPLb9VrgeWkZ8e5Inzfdm3VF+fGB2PV0OOvncJf51rp7s3No4ZuPYLB8AJZD2zL/fB7rl56gr4N0suxOntECOjU98xwfnpuk1n8ZQF1R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwmQzau2; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwmQzau2"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5398939d29eso7853566e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 08 Oct 2024 22:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728450913; x=1729055713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3rPbpta+TkDtMcuijvWndOcsGtTuVqdwMw+TL35Ikw=;
        b=iwmQzau2eO4BGR76uAjYKxbyL7lZ/dgWPCAN9ysoH1ZPqc9kmq5HNaen5Wy9O5/EKd
         Gywbk+TRMucNdaU8xNAYEDWDahS8+iTk1Asdq2xBx5SzX8BfH7P/V8zjTzmW1/tDBol8
         5ooOGEBeu3b+zqjoBKoa0HPhNzqgFLSFCoDvyLiw4rbyWj/FfmY6gXrOWqIzZG5kZKNc
         cIQT0Rr+W4Qpe/L/+gmH8WtK4GPuDrdOWfzSfMo6FgzPvutkFxlNNnoCdRtn1PH8ZqvN
         s4P4fYaXbvUKKsHqdfraUvR98wSD8l46NB9NOr7VoWTPhMZWfWOPlGWZFeDynGO7Ggfw
         +7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728450913; x=1729055713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t3rPbpta+TkDtMcuijvWndOcsGtTuVqdwMw+TL35Ikw=;
        b=qe4qZr+9IufFnUBgIbdC4U5/7zvxVCOpH21OBkKOsVTkIkaBM7YHAzsIb3UGTJmk9t
         x60JV4dJphxOZoqAeRa4p8b+INt1SK/x9MkCihGiqCYEaFO8geyAHRNzve/IivLH9aV3
         zsnHXSenp2hSQq6qBMCuIfJ4vbu7ulWLn1qLcoM0MINt/xaoIl1h3kFMcwA+8IMErFbI
         rgm8H1XqAms+bj+nOturG9SUkth5WCBd0kFwk1vMI9zPgjmdbLGbqfOv83HW85g9DKQv
         RVOhoSpPRpCdEv1YCVEdx8hXYjh5eIEOZ4oCUn2/Wd79kVBFfSuamu5hsg6H/yfjL38V
         E7NA==
X-Gm-Message-State: AOJu0Yy9oihEL9TtmLEw/+eCOHFkjj1YqcThW+JFvhweFhniIGmi8woi
	2ITdgoWgBcaZmD/PbAFYoOuxuhMGP4usTA2kcKfRXxXJkLxkgIp/MQLmhXo5T1lZEMrJIU0Ee23
	KO1RNRS9975CMbaTzMD0Hs0HNcc5RerKW
X-Google-Smtp-Source: AGHT+IGjhHwu04dRLP08q5XTeRGydfa30kYDjYWY8eLhcJc0b25g857h3qliB09cHiDEI3aaYfUjok7rX1RnzhWQW80=
X-Received: by 2002:a05:6512:3a87:b0:539:8f4d:a7dd with SMTP id
 2adb3069b0e04-539c4948c1dmr503951e87.42.1728450912975; Tue, 08 Oct 2024
 22:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5ms2jpBVtpYaE2hOgnfnjx73MnmPW2pQZnY-42ARYMf9ZQ@mail.gmail.com>
 <4bfa6f89b43289e2a66642f182f733c6@manguebit.com> <CAH2r5ms8JwSnRbyFmijk4Vhmd9-Khs+V3Co8sx6u=AEu0yb1Xg@mail.gmail.com>
 <4fc5c70cf311ed65d7c617cb154ef90c@manguebit.com> <05ed718277b1a302d0119729f4cda6ed@manguebit.com>
In-Reply-To: <05ed718277b1a302d0119729f4cda6ed@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Oct 2024 00:15:02 -0500
Message-ID: <CAH2r5mubj=JQx4TVu4bToiVkMLPiV_dg5pyNv03_eT=LfEAHcA@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] minor updates to "stop flooding dmesg" patch
To: Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

my goal was to at least get the non-controversial debug message
spamming improvements in, even if figuring out the rest of them (to
make sure we are logging important session setup failures enough for
users to see the error at least once) will take more work to improve.

On Tue, Oct 8, 2024 at 3:25=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Paulo Alcantara <pc@manguebit.com> writes:
>
> > Without this message we at least have
> >
> >         VFS: \\srv has not responded in N seconds. Reconnecting...
> >
> > which tells the user that connection was lost.  And, in case server
> > dropped the session (e.g. STATUS_USER_SESSION_DELETED), we'll also have
> > the above message printed out as we currently mark tcp ses for
> > reconnect.
>
> Err, no.  I forgot that we only print this in server_unresponsive().  We
> call cifs_reconnect() when the session is dropped and don't print
> anything.



--=20
Thanks,

Steve
