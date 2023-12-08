Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ky5uNT56"
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3513510F1
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 06:03:53 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-50bf8843a6fso2020144e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 08 Dec 2023 06:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702044231; x=1702649031; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9GHg9mYYhpYtHkFtfDiPVVWry+U9bmV1TJtlDIch/n8=;
        b=Ky5uNT56B0JRLfIoiA9zns2YZZqvs8WfYNw3M845eT72GHc2dRgABvocxIX370YeZT
         +QunlGTMWeJiehlMM2Ht07szNj0iRQUJ2Iy8SHmF29/v1JCuKGU7UM8O/7RahPFyowiQ
         n7oDqxU1t0t+G4sIMdSvEbdTC2nb5WDMUNih1HPSF/1xwoahkmmUq2FNHD9EeoXPjlzc
         XXag4VKCLxDmKI8BbmsCTjQce17Um22yJA5fm4/CsAsainKfDzmweJHAcJzNgm9gNf5T
         qxF9gJh01AwNZaEgoaeJps2YDITXnpgAfD4zoUZLoE1eLjnekdakBLdmbB35H9ykICfL
         pC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702044231; x=1702649031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9GHg9mYYhpYtHkFtfDiPVVWry+U9bmV1TJtlDIch/n8=;
        b=gOdmMyBw8sYvT7QQMw0roGQKwVqkwf72nkh4eYoip9vyj3xojmOnGT6xWoMFE9UBUu
         U+xqgrv2ecYfgrQboBbspBDhjf8kxfn3Ln3BtBJDpNmVFFnAyQf2PtM3e0ZyD/gdR6Bl
         QLiHSuhxOQHW63G3zNh8orHXINu8PBKdPQLnGW1e1LCDxjddN4BaZ8qrLiCWrNuHWKck
         37aMUDhFgRQlUwenGmIksmzZaAqbD0o/2oWhF4cVeTAQuwRbuoIPcwt00zj8S22HNfug
         QCuYS9NpcTvqmS+kSllnLInfh7zD/nOEKPc+4fqmCcVMrIXKXltbSmGXoRh0reybvPKe
         ZBiA==
X-Gm-Message-State: AOJu0YznpVhYkeZX3m2TWS9gnvYIWUaS1GZ/J5FDDyWAMP5YjyT6mu+T
	w6bMIPeHB2hvG+eOT3l1q5CfsECqB/Q8cyUwQ7Q=
X-Google-Smtp-Source: AGHT+IFiYtAB4DX4Xl8v9W/TkeIy/J1MYZ8yoUrp6F848N4KQ4bwfn0Am8DcmxryW7xOyBVf7qDSUREBGXeIxAhGwo0=
X-Received: by 2002:a05:6512:4894:b0:50c:1047:5a04 with SMTP id
 eq20-20020a056512489400b0050c10475a04mr102899lfb.15.1702044231052; Fri, 08
 Dec 2023 06:03:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <700923.1701964726@warthog.procyon.org.uk> <ZXIDgvZ8/iBhYXwy@jeremy-HP-Z840-Workstation>
 <1215461.1701971450@warthog.procyon.org.uk>
In-Reply-To: <1215461.1701971450@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Dec 2023 08:03:39 -0600
Message-ID: <CAH2r5mvM0+Py7bjahBfwpUnFPGJkZJL9KnwX5Pbw5QUGDv-0rw@mail.gmail.com>
Subject: Re: Can fallocate() ops be emulated better using SMB request compounding?
To: David Howells <dhowells@redhat.com>
Cc: Jeremy Allison <jra@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, ronniesahlberg@gmail.com, 
	Tom Talpey <tom@talpey.com>, Stefan Metzmacher <metze@samba.org>, jlayton@kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> What do you think about the idea of having the server see a specifically
> arranged compounded pair and turn them into an op that can't otherwise be
> represented in the protocol?

That makes sense for some cases (open, queryinfo e.g.) and has been
done in the past for SMB3 servers.

On Thu, Dec 7, 2023 at 11:50=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Jeremy Allison <jra@samba.org> wrote:
>
> > >Further, are the two ops then essentially done atomically?
> >
> > No. They are processed (at least in Samba) as two separate
> > requests and can be raced by local or other remote access.
>
> So just compounding them would leave us in the same situation we are in n=
ow -
> which would be fine.
>
> What do you think about the idea of having the server see a specifically
> arranged compounded pair and turn them into an op that can't otherwise be
> represented in the protocol?
>
> Or is it better to try and get the protocol extended?
>
> David
>


--=20
Thanks,

Steve
