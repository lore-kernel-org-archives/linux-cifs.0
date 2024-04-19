Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA79A13775C
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 17:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713546738; cv=none; b=XEON+V1eY8A6kf6SS16+kV7tjlnEMVDlrzKdNMQFmiRl8sWYfakh823SvaJMfvD34w5XJlJXsLbzPEf/J20FBvPjfBcrPIpAVKC3RCJjp+gmlQSgAxJRRErwYqfEpz8jnI0BG/RCkMuFKMXXOeh8XjPOVffDKzyRsoZS2km6sJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713546738; c=relaxed/simple;
	bh=4UiNPWmq48O2Kml3xW7QBDJLvWZhd9YbWz5yZZm0oYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u+ajm+2vllKqy6KfH/NNmCrYX040ncxhXDZI00AWM+escnaGvRp2P3dRTnGIQCnHOkUCNDoNrzH44EQEMj/rcWzwEUUFbWAIi61HPmG+slV+x5RYrVvMqur1pGqohuf4N3Fv/DztxdRyvNoJCwAJOl1dAJGQ3S87j7nsp9xG/RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0DPu6ad; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0DPu6ad"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-51967f75763so2660325e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 10:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713546735; x=1714151535; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UiNPWmq48O2Kml3xW7QBDJLvWZhd9YbWz5yZZm0oYA=;
        b=m0DPu6adooQB8wyDbFeQiy1Q/LpO2IWwxtv9glu9DF6uawJwgWofKjtlEmXitZvafE
         iUdWf744zgt2nkLyA/V5MCdtmcZOQHIEBFSW5ebBf5m9NlEfsWdWilxfK2aB/iWFckZ0
         N8XVlELyYPmrWiUOY72qf7xIJNpFcpikmmeXl0g2VNVJw9skjkFx+k3axF0ZIzYl34xg
         gDbrLrmWsz8e6xUDQZnf9RW6AeheE+j2tToks10Z+lzwgTI+S4yDFOPjRSOJFG5C7GbJ
         mrwBRG+GReLKUbTmM2SeDv+X+Bd/sN6IJlvcVdwfz8RION0lU9eNm5nNqZpjdhJPWWF4
         bvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713546735; x=1714151535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UiNPWmq48O2Kml3xW7QBDJLvWZhd9YbWz5yZZm0oYA=;
        b=MCyTk0073yDBfmlQRjqww5GmQnpaAF3wCDFlp1pNW8xfe39XxtO6vV2T48fdyVMAgf
         Gb1mqwumkX/LblN+341LFqVWpY+BkbzXMDu6mmxn/jLHOqA4iRFfvee6b1vr+yZff0mX
         wzEykDFUobOmlOQ+qIwVTNVDlAhuGiv4gknl9Y7vXpH4oJqe++DBkJ5Wy8OFQEOQ3P1X
         RauXq/Xz9IRmudpH51zn7IVdSM0OGYYf/VR514vdvO7eZf6XYN0kmPRbpBxVQfNxA9KD
         SXb4ixh3TsJPO9oAW2nL6O9aeXv2BOfNtTipoT5pgR8CKaVK/3I8kenQJNpVcbDyxDbk
         4m1w==
X-Forwarded-Encrypted: i=1; AJvYcCWBbtAVt4mk23xQgAUfeDgsldCbzlI9kZAb6km0MQaFeXvDO3CEBSHClu7lc/fayKp+D7nMEK4jjo6wBdR6UqNVcqw8xgUiiqoTcg==
X-Gm-Message-State: AOJu0YwKUM+GWmjYKpiUMrsfy2MAwvC9yQ9sojYyWLH7ttZoH0vA6HgC
	pH8ySeOA8qydUaYcgCnniMIo9VFmqEf25BQCfzVGBRj/uC7C4D18YUpW7NF9OfCcqoF4F4acqqj
	htzJaiv/8WH1ezTm8QafcxlRq3VU=
X-Google-Smtp-Source: AGHT+IFaNmyXhKvkHaju/fD6czmfU5+0YRmYN0D9kWNR7TF9ngH2WTRU1X52ONsV3cgVzDb8Fk18ptTYJbgoITDIqso=
X-Received: by 2002:a05:6512:360e:b0:518:755e:4bb4 with SMTP id
 f14-20020a056512360e00b00518755e4bb4mr1559926lfs.1.1713546734510; Fri, 19 Apr
 2024 10:12:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
 <c7d80c1538db3a414636977314feba13871907ef.camel@samba.org> <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
In-Reply-To: <ZiKT4CursWvT2dhq@jeremy-HP-Z840-Workstation>
From: Steve French <smfrench@gmail.com>
Date: Fri, 19 Apr 2024 12:12:04 -0500
Message-ID: <CAH2r5mvn0tMB_SoQYGh4bVK-ZRYfOLNn4PgX51_rofPkhwqD4g@mail.gmail.com>
Subject: Re: Missing protocol features that could help Linux
To: Jeremy Allison <jra@samba.org>
Cc: Andrew Bartlett <abartlet@samba.org>, samba-technical <samba-technical@lists.samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 10:55=E2=80=AFAM Jeremy Allison <jra@samba.org> wro=
te:
>
> On Fri, Apr 19, 2024 at 01:40:34PM +1200, Andrew Bartlett wrote:
> >POSIX <-> POSIX locking over SMB is something I have a client trying to
> >get working with SMB3.
> >
> >They have a use case where, as I understand it so far, the mapping of
> >POSIX fcntl() read and write locks to SMB locks isn't 1-1, because they
> >expect advisory locks, but SMB locks are mandatory as far as I read
> >it.
> >
> >They use cifs.ko and Samba, so it isn't about working with Windows, it
> >is about running Libreoffice on LInux against Samba.
>
> That's not going to work the way LibreOffice on Linux expects,
> until we fully expose POSIX locking semantics.
>
> It's the range semantics that will probably break them.
>
> POSIX locks can be split/merged/overlapped. Windows locks
> must be distinct. Currently over SMB3 we only expose Windows
> locks.

For a surprising number of Linux apps mounting with "nobrl" (which only
enforces byte range locks locally, and thus POSIX style not Windows
style) is fine for SMB3.1.1 mounts.

--=20
Thanks,

Steve
