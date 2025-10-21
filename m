Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843CF23C51C
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761068732; cv=none; b=fIl2f7HVavja4pb/zysnZmEKyYu6mNv26kKVx2AI3mDEtP7hrjDO0rEKRId/nv5i6DKB8caEcaL20aF3hfWz10ZzAiEoEX0ohog3hkcTpvoPBEEFhpi3nuO5ji/V+0semGNc4yzgMqzzfkKiCMtWF9FXuhVJjuOcaaNovV6rwds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761068732; c=relaxed/simple;
	bh=hfjwvX0MmN9Yx9tVnROi/qIwJU7BWsOlLjQ4THR5G84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TcojqqHVOGKza8l+jzXxjTdUDm0BxVOvKzoBxrp7LNuffBD9PfOzGCWsoWxhkzED4VDEINBv2EdaNyIZdwWrD+2QTWTL3j07pReKdXpMUslylOXwpH0xzmJKvcZCUaQ3VOFDVn57IUSijnU72AUQnj/8ZiVF8M9y4rMlGndiTN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ve04Sjko; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ve04Sjko"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-87c11268b97so91562976d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 10:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761068729; x=1761673529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Is8wbWn2PRb137hpX8Cf9e8uizjZfmxROvpNniu1Pgk=;
        b=Ve04SjkoYPLt7E+VIPzf9v734lSqZvKSXFSEtPUR0nY9JodTHGcobMNWiip/qEBLwe
         xiaL5pG10HfK5dnaqtY787pP7rnQucY6idnDBDR/TIBt60wdXu8njwZ6MHfHf23pdzrd
         t9OEP0rdjMWfmwiM5FRasPbpwwxAA3MNO5FfwF3JOqce8rS2o6SXFzyaUE1LVSwTdnR7
         0g+ATzBJ7uHooEtF7AUrRXlrnZKOxyztXvKBMR69Azw86WRZ1FK/mUbwQvRTM8yYkmH6
         IjRph6ufTP8LL/vRlKU2mWE75+nVZIyD0bcNafCbVVlJ/NAcL+oP/+PgMQ47eJtupTAS
         JX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761068729; x=1761673529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Is8wbWn2PRb137hpX8Cf9e8uizjZfmxROvpNniu1Pgk=;
        b=t9O1BmC8PAei4ZP+pqtkdeV0MD3b9YRL5lTtZ5+7/3BiY91iFqpfClTXNa6ldiZR2y
         ilSWTLDY81SSQMjgYdntD3s04CIg/6N4jS6HHdNLyniN5gZcd84AP8tVtgNw6WaTJ9c9
         INT0bpzUuoiZhYi1BDR2mKgzA9laJ15ix2RD8Zw33okypFP+drApTkRSnSp7muz35zgn
         D338jQngjXGW9DK+yXiW6IcDmO6vhjLt4yYUpV/xJbLqmaEfcgR+RxzyVVL3eN+wtweZ
         OPzTjYesekC3HD7f8VyC4a3uiP6OrSQxkFVzhbZ4Zm/hwwcusAEpn6Z01CdT0ia7pswp
         o5eA==
X-Gm-Message-State: AOJu0YwvVfEYyhaqoLE0FzDikKYvcrwkjRfdz3M2h3XkBrMtAuxwr78D
	FXvpoTeeeI/qR2gX+nIu68jTog6am6EFj3MUkpKv/xEExAjTTrgWSWA7Q5p/JQuucOiGPKddXMY
	0NG0HGTCVQ6hBKSrOSFjS77HdCAO6FJ+MuJWZ
X-Gm-Gg: ASbGncuntKKxs1237ykv7YJGTeJE7zI3nWLEsT+ysHyY+rW6X3WbmVFPU9TX5XUJDNi
	9iQEnhqIQShmtCO54ZbTUi+wzKNTPZ4CRGe88dsmEvyQCuXjEz2zIQgXpPEUx8E85xzePH29Cnu
	3soksiPq7NPPsGe8UqJe9d3tNFyp6HLI5ge2Deg0EllvfX9340Ee3HGYx2R5sLkGmscJrUUqzFX
	vKIsLnKxhapqQP7ZSH+jgRMEBGTohZ1kDDsYsRjFA0uWLysYKghV6lLwJCDEfC149ABgqhReHFt
	/fGOjp8vu1mH4qVf0ax67yTLOYihPTGCpS2O6sY9CQAS1XXIc3zA8CP7zfSlIV71md3V2HKWfDE
	r6fMsvgAqXoJeLYB2uid0l24+zFU1s+gyUYaGOt9nwwyGdkoOhw==
X-Google-Smtp-Source: AGHT+IE8/MjObd6lLnDIXO5Y3xXfuL/3nMc3lmnBHuDgp7SD+tfMr7IafMDU5ZrAGbrLeSPHcxxHxt1h0JjcAPLLHtQ=
X-Received: by 2002:a05:6214:c8e:b0:875:e7f:ecf9 with SMTP id
 6a1803df08f44-87c207df8f6mr231497046d6.32.1761068729148; Tue, 21 Oct 2025
 10:45:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
In-Reply-To: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Oct 2025 12:45:17 -0500
X-Gm-Features: AS18NWA1q5dehCKE0zoTPQRv0Zkt2lZabQsBJUseIjIrp45IZ1PRr15vMvzSYOQ
Message-ID: <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when enforced
 via sysfs or modprobe options
To: Thomas Spear <speeddymon@gmail.com>, samba-technical <samba-technical@lists.samba.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch - this looks very important.

Do you remember if Samba support gcm256 signing?

On Mon, Oct 20, 2025 at 3:52=E2=80=AFPM Thomas Spear <speeddymon@gmail.com>=
 wrote:
>
> First time emailing here, I hope I'm writing to the correct place.
>
> I have an Azure Storage account that has been configured with an Azure
> Files share to allow only AES-256-GCM channel encryption with NTLMv2
> authentication via SMB, and I have a linux client which is running
> Ubuntu 24.04 and has the Ubuntu version of cifs-utils 7.0 installed,
> however after looking at the release notes for the later upstream
> releases I don't think this is specific to this version and rather it
> is an issue in the upstream.
>
> When I try to mount an Azure Files share over SMB, I get a mount error
> 13. However, if I do either of the following, I'm able to successfully
> mount.
>
> 1. Enable AES-128-GCM on the storage account
> 2. Keep AES-128-GCM disabled on the storage account, but enforce
> AES-256-GCM on the client side by running 'echo 1 >
> /sys/module/cifs/parameters/require_gcm_256' after loading the cifs
> module with modprobe.
>
> I can see after running modprobe that the parameter "enable_gcm_256"
> is set to Y (the default value) and the parameter "require_gcm_256" is
> set to N (also the default value)  so I believe the mount command
> should theoretically negotiate with the server, but it seems that no
> matter what I try, unless I require 256 bits on the client side by
> overwriting the "require_gcm_256" parameter, it will never mount
> successfully when the server only allows 256 bits.
>
> It seems like mount.cifs should look at the "enable_gcm_256" parameter
> and if it's "Y" try to use 256 bits at first, falling back to 128 bits
> if the server doesn't support it or throwing an error if the
> "require_gcm_256" parameter is set to the default "N" value, but I
> must admit I don't know if there's some reason that can't be done.
>
> Is this something that could be looked at and possibly improved? I'm
> unfortunately not a developer, but just a user interested in making
> better documentation so if this cannot be improved, I'll go ahead and
> get something written up and share it with downstream teams like Azure
> Files CSI driver -- on that note, I'll appreciate any clarification on
> why setting this specific parameter is required if this can't be
> improved.
>
> Thank you,
>
> Thomas Spear
>


--=20
Thanks,

Steve
