Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4566831CA50
	for <linux-cifs@vger.kernel.org>; Tue, 13 Jan 2026 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768322621; cv=none; b=tEyAt4paZF1MHoop/G48qUT3UR/PLnfGA/q6D5fIE1dnhMkXzTxccJG1anJT1Serf0MD/zMimfcqTp6NKKj5dlTpvZ0rRMvW7jEtlbGGaLf5AVrIXbJ7P9MBadVUcZfa4TICsBvBZQXlvg53euPu3ixkgTqk0jN9DGLsOELUOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768322621; c=relaxed/simple;
	bh=Hm+hFkCxE6lVbQx4eQObQxXAcvrq9lVQw90Wa4bRafg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B6ujRDZeC+fCMN4+xwWhc/JFv7jb2SBUp8UjVyVgrbJRGO4xEW8C4J6qL3osXsZNcTGAxSq3JWZhAGSLdT+puu6qIzdQ4iUGuz1sZgFa/uc93uu0XxIJTlMfUK9RNqhwXGtc3dS6olfV7kY5YC0qeqMZVqvIxXwvzx4qubobVFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3ed151e8fc3so4702544fac.2
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jan 2026 08:43:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768322618; x=1768927418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gc7yqO7D0eseyKYDyefBFLldfXSHU35zlyHiXIvs8J4=;
        b=mLf9d/wnM99Dl++mPRNE0VoHAP9VJKiMWUNATJt+Qsr4dGs5tmdsfcZdhYkExjb4aD
         fILyUbN2xCtIUskwjWuScviu9V39g36StDoKdQvLrs03y99jr4B2AFnV9ICw7aKtsZQU
         GK/B1f8Nb84upus05+LpeG9r120RuE0LD5+DcNQJncrlWzf8PmroAc1axtEL58fSyPnE
         +dJbN5gfVgSqt49uBxce+RZPkG5eHD5n4j8S84GNghLcCZ2R2QhNUJNeHgu+njNtNmOd
         df4pcs9xfLxj/5izm/D9ZWnkkoQvj2XS00wmeZv2rrgMhP90wBPDIfOU+qjNtNu3hz2k
         14Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUk4+eNrEauUioN6+DBOyXu2ur7bQNRh0eZU7HXSzwbvfRsXClCigoiJFZRtspPM4L09nwC6aO98LE0@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0CJbAz4iy6WD2zMJ5lQ094Dou3dwZECjBuOZhJSmmO4zx31/o
	DXp3Rgfij5K/p5q/8vj+aG5xweOBOEzvabLp8XvAV8xMkFbNM1xcP3xqZAACyQ==
X-Gm-Gg: AY/fxX7aFv55IrhCP3p7dRzVXmiDM0GN9tVkoEhSetc5naAkJBag4Boex8kMlrJCteN
	t5qjw5ufU4DSpo0afwFGZ5/0G1897Igt9lbpy5FAlL4n3hDtyYwxOA4CB45la4PdeBwW/Yfgqtd
	e3nZB8yhTOiODaPtKZT54VDkHuevYAC/glM7C/yvxlDvPvzScgRIEn6ySywSubea2l9rsT80d4Z
	fa6sHkCI2hcQ/4emyEqhTWYUXPb6PSoa3EywMJkro8S4DGeHtvstRKMr3t3Veg0Fk2WZ5IHgz7n
	M5BFFYOPQfZ4TX7MDPeAHkuZCLRHlTlZheFR7uvlMrRS5wOdAYu4zFqrIRy0bO0+BWPs4Jaj+O9
	2UNB6uOcuOb6sqbBdmCdnYsy656ZXlZ0vsfatE1KFEfTXiPtnb3OKhOqyt+AvjRIqYSIcmbijMY
	s8xyoFydsz/grrNS/zz9f50Oefk4J7IMpwCHFHXKbZU6ILzBwUbBWtwQBmv3XLV+ZQbdGvKFq8
X-Google-Smtp-Source: AGHT+IHnLzwml00JdNAcz8mlFTueVGyK5vW3IXIi79warMynYw02wUX68TyzD2BPNqdmpitQ8NXdCw==
X-Received: by 2002:a05:6870:c0cc:b0:3e8:9b86:3c6b with SMTP id 586e51a60fabf-3ffc0bd6137mr13002010fac.44.1768322617739;
        Tue, 13 Jan 2026 08:43:37 -0800 (PST)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com. [209.85.210.41])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4a9099csm14545306fac.0.2026.01.13.08.43.36
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 08:43:36 -0800 (PST)
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cfb21a52a8so1487758a34.2
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jan 2026 08:43:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVt+ukJ0BUyu6mXUuSCwqFcj+RIb0o/w23HGA2GVST/9Q97BmnL31pZQgcAsKJH5kJiOQorgleQSoZk@vger.kernel.org
X-Received: by 2002:a05:6830:2e04:b0:7bb:7a28:51ba with SMTP id
 46e09a7af769-7ce50a6def5mr10521137a34.26.1768322616531; Tue, 13 Jan 2026
 08:43:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112174629.3729358-1-cel@kernel.org> <20260112174629.3729358-9-cel@kernel.org>
 <20260113160223.GA15522@frogsfrogsfrogs>
In-Reply-To: <20260113160223.GA15522@frogsfrogsfrogs>
From: Neal Gompa <neal@gompa.dev>
Date: Tue, 13 Jan 2026 11:43:00 -0500
X-Gmail-Original-Message-ID: <CAEg-Je8LGZGGAQ3XLMQg8=XmJjvvJNShT3zkE-o2t2fv=VGeHw@mail.gmail.com>
X-Gm-Features: AZwV_QiAh8VN4kaDD2E2Q52MaqDS5cW88U1qWaL9kDfC-E_siYu-7adEi4A7eM4
Message-ID: <CAEg-Je8LGZGGAQ3XLMQg8=XmJjvvJNShT3zkE-o2t2fv=VGeHw@mail.gmail.com>
Subject: Re: [PATCH v3 08/16] xfs: Report case sensitivity in fileattr_get
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, vira@web.codeaurora.org, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
	almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, trondmy@kernel.org, 
	anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, hansg@kernel.org, 
	senozhatsky@chromium.org, Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 11:02=E2=80=AFAM Darrick J. Wong <djwong@kernel.org=
> wrote:
>
> On Mon, Jan 12, 2026 at 12:46:21PM -0500, Chuck Lever wrote:
> > From: Chuck Lever <chuck.lever@oracle.com>
> >
> > Upper layers such as NFSD need to query whether a filesystem is
> > case-sensitive. Populate the case_insensitive and case_preserving
> > fields in xfs_fileattr_get(). XFS always preserves case. XFS is
> > case-sensitive by default, but supports ASCII case-insensitive
> > lookups when formatted with the ASCIICI feature flag.
> >
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>
> Well as a pure binary statement of xfs' capabilities, this is correct so:
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>
> [add ngompa]
>
> But the next obvious question I would have as a userspace programmer is
> "case insensitive how, exactly?", which was the topic of the previous
> revision.  Somewhere out there there's a program / emulation layer that
> will want to know the exact transformation when doing a non-memcmp
> lookup.  Probably Winderz casefolding has behaved differently every
> release since the start of NTFS, etc.
>

NTFS itself is case preserving and has a namespace for Win32k entries
(case-insensitive) and SFU/SUA/LXSS entries (case-sensitive). I'm not
entirely certain of the nature of *how* those entries are managed, but
I *believe* it's from the personalities themselves.

> I don't know how to solve that, other than the fs compiles its
> case-flattening code into a bpf program and exports that where someone
> can read() it and run/analyze/reverse engineer it.  But ugh, Linus is
> right that this area is a mess. :/
>

The biggie is that it has to be NLS aware. That's where it gets
complicated since there are different case rules for different
languages.



--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
