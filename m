Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F1D538F
	for <linux-cifs@vger.kernel.org>; Fri, 10 Nov 2023 06:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlqUbQAN"
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBFA5FE7
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 22:18:03 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9d242846194so275767666b.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Nov 2023 22:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699597082; x=1700201882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAmwXK+iDSWfdTObmutZF/SAgh4gxinIE7yeyirigQA=;
        b=BlqUbQANSpJ4+Brs41A3b0uDqB4oEa0/4xKJ9HtwIsMBTAG/tTuVxcCd+y5EzopE1N
         57bft8i/9zSKhJpAU3IhBP852qW3uAj/JJn6EfDmEGg/h/gTGxI9y6paCX52D1kWHL7s
         /Zas3l99Y6hwCvOxx6KdulPv0p6f8XmKqizSbXIRzEag4auTEI/5y5aBv1bfvihfafAk
         ZR1jEF0PjqrsIV8h1j06IEF2SqGdNNhKhjsgS3+OVeq0e+Ew4wU+OWc8liavDPzwRKBl
         jNJNl5QCjkRgbBhN+9UuBx7XcBVnM1jy2y+q7PUfhQPVc0lGQx0pnpbdfSWySJOm6C65
         Y9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699597082; x=1700201882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OAmwXK+iDSWfdTObmutZF/SAgh4gxinIE7yeyirigQA=;
        b=RU+et92BUpRPP7/O1/3s2MQYzKdQke6t8c5ilJ2AvVa47KxS9vkm9fZcUWbp1D85BZ
         0mYS695bF8QnNSbcw7Kn4xcspJ7ELOG1c0BA6Z2NneLTCD9jKw0WgKK4qim5BSh4tLeV
         xszVxRny2YktsDrux5d/7u0H1n23aiNHQeT+b8/Vh/UWQUVVeGZ5TLTnOdnGHHHR3X9H
         Mjd3ePHEmCfNdd7y5YAmPSq0dr0UuMQaNRehaPptKlgrcJHzi3LyrtXT3/NrGKfUYhPb
         3JNhaDWLogiS80ws28EW5NxsxQpdRfklAK/XZ3hUqjkMsYvqPFsR9zkTArRGLpnmtGRV
         6TZQ==
X-Gm-Message-State: AOJu0YyNB4OlLR/gj9OHqHFsvej0/FKTCGY7Rpnr0uvmKkLeXNvnCgin
	d2iymzDmPr4QeEvSP4q/qYZlCNc5A0ZmVF8n7UUNxtC5DiY=
X-Google-Smtp-Source: AGHT+IFH8mCws/7YFJadNm2sRt8kKIC0xAsS4FDccNuYgmupaiuoQLs6kc2nWTizlJgFgLQFBAJdmxwrsaJnIC6e2Eo=
X-Received: by 2002:a2e:3315:0:b0:2c5:2182:48db with SMTP id
 d21-20020a2e3315000000b002c5218248dbmr5320463ljc.20.1699589971813; Thu, 09
 Nov 2023 20:19:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt-t0QDZk4Zz+cSs8=s=VhUW09erUBAtm8f7xXG3rHJqw@mail.gmail.com>
 <CAH2r5mtWC4hX8v-CwDQC6qp4tWzdNaMSag9myYM4dGmC4zr9FA@mail.gmail.com>
In-Reply-To: <CAH2r5mtWC4hX8v-CwDQC6qp4tWzdNaMSag9myYM4dGmC4zr9FA@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 10 Nov 2023 09:49:20 +0530
Message-ID: <CANT5p=rLdEAsXCXtf88OTg=Zy7d9yqDJf2_Z-r9oFZ0aGaR8iw@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] allow debugging session and tcon info to
 improve stats analysis and debugging
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023 at 8:21=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Updated patch to remove dumping of flags (tcon->Flags was already
> supposed to be dumped via
> the other ioctl (CIFS_IOC_GET_MNT_INFO) but it had a minor bug - will
> send followon patch for that)
>
>
> On Thu, Nov 9, 2023 at 3:51=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
> >
> > [PATCH] smb3: allow debugging session and tcon info to improve stats
> >  analysis and debugging
> >
> > When multiple mounts are to the same share from the same client it was =
not
> > possible to determine which section of /proc/fs/cifs/Stats (and DebugDa=
ta)
> > correspond to that mount.  In some recent examples this turned out to  =
be
> > a significant problem when trying to analyze performance problems - sin=
ce
> > there are many cases where unless we know the tree id and session id we
> > can't figure out which stats (e.g. number of SMB3.1.1 requests by type,
> > the total time they take, which is slowest, how many fail etc.) apply t=
o
> > which mount.
> >
> > Add an ioctl to return tid, session id, tree connect count and tcon fla=
gs.
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

IMO, tc_count is not necessary here. We should keep this ioctl very
specific to this use case.
Moreover, DebugData already prints tc_count.

--=20
Regards,
Shyam
