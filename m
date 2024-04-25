Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D8F14D717
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 17:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714067068; cv=none; b=fTXjW6zlqAPQo5lyOHYIlZ2rCF+cOrNzBSariZe8vwDn43zaoSqEhns83yQGK6g7/sdtp8X0dKdBzEmcVPhd8EsZzU8h1rUdEnZiq/7QZAqC/aFt+t8IpTAXamogmCXQhb1pg2dYNvP+6WvYZMwG5WIUuaCQsS20NcsKNTH2Z+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714067068; c=relaxed/simple;
	bh=ELbYx9+k1FZ3G+EMZneBvOHnbLbOrQgCNPiuHhoj0yQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nljakVVf18xJrS3L/Jku0I9Wwn304wiAPmomg+5jjwM+QWzRVteJ38fP0YHMMcL8YJidPB1caLwuTdyIciuA+j+9KD1njxVRdur5O9EzfO3o5wms9D9v1EU7lLIii0k9gk5IgznxemT4RCfQj1lkeU8LrffdW7KU178kJww1OaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A8Y9Vfl8; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8Y9Vfl8"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2dd7e56009cso15955001fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 10:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714067065; x=1714671865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELbYx9+k1FZ3G+EMZneBvOHnbLbOrQgCNPiuHhoj0yQ=;
        b=A8Y9Vfl8RMSPfb+V1XHaZJcNew+TMK5CHMBSDZAVZm13hPaHChboE4Ukt2NO2+s8MO
         SnD7GHNU6o9LmEysivHo77Iud7O38ahF03gKBVDgcH68se2bmrlwdkX4TtWUPyXVYd0A
         5kJKZr5txynPIPMPh0TIfBjXa0rqdP+w9HSw9MJCTZk+FjjUpwTBTrZvOocXUBl62niB
         mGpP7FM/mFrhqv3ZB0d08TDBb6QDiLksoJfwFGXVIg1lugyuhYSDS5Wb9SMhynojVRDf
         lkEPgRpGhg0Z+ac6dIo8Ln9aPLfk/geYUM6ar/eF7KPen2oIaoiJbrBJ9PhI0wFo8MHz
         vu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714067065; x=1714671865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELbYx9+k1FZ3G+EMZneBvOHnbLbOrQgCNPiuHhoj0yQ=;
        b=PehNSnR1J6Lf/ZxmOLXVk7HGksfhhsxtWE5NshyBfIXSPaZ+qfhVSyNTasKrS/ig+s
         cuCHnHF5LvAUqRsyAaSjuzUpcXjo8xKyywDZ/DBWJHn8X9bxC9G82tQEmphz8H5l6zdo
         f6sH8nI6jpyWcSc0y+1btL3Zzr1Nyln3Nh66zA8WF9lI0fY3eSxR14hXsAIuZXQ70uN2
         kmqY9jNq9aUwnLZagUV0paMEKT9e+HerWuSCs1aFBqavVbeXZzqBTK/CZtJEsUd+uPLe
         4lu0vVIkbd6OKczbqtHEtteeS+kEcJs6+vwhQM+ilmKI1+jN4X8JpXJuppRKes8dSBKa
         IC5Q==
X-Gm-Message-State: AOJu0Yxt+fWb4qSq+a2Hd0JdrvEy77WK2khKibhh9pQ/I1zPHbNxzzj9
	ajfPphmJQu6ueKV06qkzRyg3sOHnm3ZytN0mOci3DRGYObAQktDde5+soSD4yLTASD7UfGBUXk+
	jMsxn2pCFd87m/ZCp9pNZImtObAM=
X-Google-Smtp-Source: AGHT+IFPvQ0jGG4AVmom1xd20q1XFT80C2J3RsZQb7s+l7gM3Z6Mffwt27Srr5rcAsZF4Gt8h8P8Ds4eLhg/JuA19ok=
X-Received: by 2002:a2e:b714:0:b0:2dd:b190:241f with SMTP id
 j20-20020a2eb714000000b002ddb190241fmr32394ljo.39.1714067065278; Thu, 25 Apr
 2024 10:44:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtJuttkzHDQB=-U3o=bBnv5U9r2w+JG-mXg1TPBT1wFog@mail.gmail.com>
In-Reply-To: <CAH2r5mtJuttkzHDQB=-U3o=bBnv5U9r2w+JG-mXg1TPBT1wFog@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 25 Apr 2024 23:14:12 +0530
Message-ID: <CANT5p=qE_6xA7qML6f5i+0i7ZpD43QcT6vKsWqm+wdpc8VyoRQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix potential deadlock in cifs_sync_mid_result
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024 at 9:16=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Coverity spotted that the cifs_sync_mid_result function could deadlock
> since cifs_server_dbg graps the srv_lock while we are still holding
> the mid_lock
>
> "Thread deadlock (ORDER_REVERSAL) lock_order: Calling spin_lock acquires
> lock TCP_Server_Info.srv_lock while holding lock TCP_Server_Info.mid_lock=
"
>
> Addresses-Coverity: 1590401 ("Thread deadlock (ORDER_REVERSAL)")
>
> See attached patch
>
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
