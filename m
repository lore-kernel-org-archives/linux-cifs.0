Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9D815E801
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093770; cv=none; b=TFWQOCOtUredzdzrOuxm18SZH8X+e3/y/MwXgwVJ2BUOK18tl65yRmHjlefyw78v3FLsHWa3fWdWJPPxTe2oSt1/5ZbrxergOpi3fJ/PRDd01CFOGlep13A8JC82I/YevTMTeODENbZmhb74e+jiGant6vcY8+pfIXtGAnwaZZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093770; c=relaxed/simple;
	bh=A+i2scP1i3n04ntHseA7vuTsn6YdwPi7luBLLidTYoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PR9ibgeuIdt6DmJ7wEDubCOW766p2Q21Y1nfC2blcqRAy1s6cWZuRkeA4yoruZaYAHIwfyg46DBTF39zEK0gSaCPSHZrgLNxRoDH4UUH4cpz1idF6dW3Bj0Dv9MBQMmoFrOhaPY5eAZBOkF15SontqnP6DjQyN8QuDjQz2vwdfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WY7GGNEa; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WY7GGNEa"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-516b80252c5so1718037e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 14:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1712093767; x=1712698567; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P45Bu4wHn5RquDWpNCud3aZNlC5obFSwexJqgolasMk=;
        b=WY7GGNEaM8IlhHBNHBqb7NRRax1fyM2PjPiLNwsuRm3gYRjkK54E8QvfsZJgG1N4Cq
         RmDUBcUZgrUNHxWvrPsuIWD/eGrpFZ8MG93XM2ANZDFv5VlxvZVMb+PN240FcKJGaS8e
         wNlODNBsevvisP7p8yEs+gUvaxwPEWxFMS0nQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093767; x=1712698567;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P45Bu4wHn5RquDWpNCud3aZNlC5obFSwexJqgolasMk=;
        b=AmboKcw000v4+Rd0joRsfjWY8JEO29q09+SuhMI1VNL6eRa1T3s6cBXdZRfJaLukVD
         FBlEZCCdKi7q0O6xBK9yo1GSjRLpPE0Nzi3FGGMvvOV/l84sUOw4cpJJ6dt8o2QP+yOh
         eMXAm0r8dIrMOMYyWWstlXZRko1neoplQ847iPT0aQWSVFs+MMWQj2A3BgY7dYcNGVhz
         QpjYSByG12kGOakQwixk6BDOI7mfpxuziobqlHsQ0pjvhmU7p3BhMvfXkzaq63XY2Br1
         HdCpqHAwKi7GIhJS/EvJgJKk3Dcc2kAlpx+2QirSoYPZ+YdXARhu6it7bef4UAx6rrHU
         acbw==
X-Forwarded-Encrypted: i=1; AJvYcCWHH8rDhqAMO7t/3QDqAk6nYqVnhSWlH3tvGKqWoTieMAbviX4i/gsXlzVqi0ie93fYC1GizncfQWF4l48gDLdoKrf5KdKPtvhO3g==
X-Gm-Message-State: AOJu0YzWSCA8Asc8BJvP1FCyGV2as5vJ6dGBghItioGzS0rKIVwmj8c2
	rZqiXWsr0f7jw/DUBbyIMZOAZqWFyDAqtfMMqi4/iDItYzzDlKfZ+s6ums86QAon+c8q2CpsEaf
	Juzw=
X-Google-Smtp-Source: AGHT+IFVBz2Utwq05x8Uov2K4gi2szzwFHw7LN55loRoJWaXd+HAI1d+cxJsGT30nvR2pE7YxM+MaA==
X-Received: by 2002:a2e:22c2:0:b0:2d3:87b:7e9e with SMTP id i185-20020a2e22c2000000b002d3087b7e9emr11336348lji.39.1712093766820;
        Tue, 02 Apr 2024 14:36:06 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id f4-20020a056402194400b0056c4cdc987esm7210456edz.8.2024.04.02.14.36.03
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 14:36:04 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a4e39f5030dso569750366b.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 14:36:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXfy3//KxG+QswsuWTxu9Bln3rIU/qcalSv+gEx2FI8tIJlWylKj+iI7Yp07bbpuxkXk4RxvgcIqZ+2hRveQGxqUsk/NpSxUMgZsw==
X-Received: by 2002:a17:907:944a:b0:a4e:48d6:b9d7 with SMTP id
 dl10-20020a170907944a00b00a4e48d6b9d7mr11214699ejc.56.1712093763393; Tue, 02
 Apr 2024 14:36:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402141145.2685631-1-roberto.sassu@huaweicloud.com>
 <CAHk-=wgepVMJCYj9s7J50_Tpb5BWq9buBoF0J5HAa1xjet6B8A@mail.gmail.com>
 <CAHk-=wjjx3oZ55Uyaw9N_kboHdiScLkXAu05CmPF_p_UhQ-tbw@mail.gmail.com> <20240402210035.GI538574@ZenIV>
In-Reply-To: <20240402210035.GI538574@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Apr 2024 14:35:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wikLJEzBT1_7K5CMfc6DjNNevuYR8z-CfKgYLgwwDLVDA@mail.gmail.com>
Message-ID: <CAHk-=wikLJEzBT1_7K5CMfc6DjNNevuYR8z-CfKgYLgwwDLVDA@mail.gmail.com>
Subject: Re: [GIT PULL] security changes for v6.9-rc3
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Roberto Sassu <roberto.sassu@huaweicloud.com>, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Apr 2024 at 14:00, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         1) location of that hook is wrong.  It's really "how do we catch
> file creation that does not come through open() - yes, you can use
> mknod(2) for that".  It should've been after the call of vfs_create(),
> not the entire switch.  LSM folks have a disturbing fondness of inserting
> hooks in various places, but IMO this one has no business being where
> they'd placed it.  Bikeshedding regarding the name/arguments/etc. for
> that thing is, IMO, not interesting...

Hmm. I guess that's right - for a non-file node, there's nothing that
the security layer can really check after-the-fact anyway.

It's not like you can attest the contents of a character device or whatever...

>         2) the only ->mknod() instance in the tree that tries to leave
> dentry unhashed negative on success is CIFS (and only one case in it).
> From conversation with CIFS folks it's actually cheaper to instantiate
> in that case as well - leaving instantiation to the next lookup will
> cost several extra roundtrips for no good reason.

Ack.

>         3) documentation (in vfs.rst) is way too vague.  The actual
> rules are
>         * ->create() must instantiate on success
>         * ->mkdir() is allowed to return unhashed negative on success and
> it might be forced to do so in some cases.  If a caller of vfs_mkdir()
> wants the damn thing positive, it should account for such possibility and do
> a lookup.  Normal callers don't care; see e.g. nfsd and overlayfs for example
> of those that do.
>         * ->mknod() is interesting - historically it had been "may leave
> unhashed negative", but e.g. unix_bind() expected that it won't do so;
> the reason it didn't blow up for CIFS is that this case (SFU) of their mknod()
> does not support FIFOs and sockets anyway.  Considering how few instances
> try to make use of that option and how it doesn't actually save them
> anything, I would prefer to declare that ->mknod() should act as ->create().
>         * ->symlink() - not sure; there are instances that make use of that
> option (coda and hostfs).  OTOH, the only callers of vfs_symlink() that
> care either way are nfsd and overlayfs, and neither is usable with coda
> or hostfs...  Could go either way, but we need to say it clearly in the
> docs, whichever way we choose.

Fair enough.

Anyway, it does sound like maybe the minimal fix would be just that
"move it into the
                case 0: case S_IFREG:
path".

Although if somebody already has the cifs patch to just do the
d_instantiate() for mknod, that might be even better.

I will leave this in more competent hands for now.

Let the bike-shedding commence,

               Linus
