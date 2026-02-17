Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC73535965
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 04:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771301816; cv=pass; b=NO9AgM+1xF0h6Y6QIaWDpsKyAN/QTG8p8FUrZ9YheXFemDvilS5130QnDh9sxP6qV+yKJQiucyZ2OwwqVfCQIAJVIp/UUM8s1pOMUyrSkA00O1a3z+ut3Z+mL+MRqOAJGN9bxMdG1LzDFJ13CGgU+2L1OHuata8Tcnm1FU2MRis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771301816; c=relaxed/simple;
	bh=qe+7XX/L5syn+cLvVHmf9Bl620oz//ebyw08Uel5J18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KG39l69hfxcbMI/OQ/jnbnW3YIF9RoLTI+vLcrB8qcshOP2jTTrKx1p7UhvlMIotg2AE242dUU7ZFAHvJLEmBhXt6fKJCCLsRvfNO2irbjY4vr0kfktTIbvl4ZTiPgAd+aZyCbS/MlwDkJS9t2XYbbMMKMoqGf5Q+c9EQp9UkKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+HXpIHG; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+HXpIHG"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c0d2f5fe1so2601188a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 16 Feb 2026 20:16:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771301813; cv=none;
        d=google.com; s=arc-20240605;
        b=aU4eaxrtLz1Z4IXaHKKNwEOmegGL7wwsAJi5kGQXQGSopCUxHOQSkMxdFFWH1crQuI
         wXXQJDmMf3IazRWKNR/whJAehO2e0m4opHdzpfY8Mm5NGi8HjbaWzpg2Psbf/VoG3902
         iFqup6hRmD5kxa6ZPeuuhFOhh8n8CmF5gtOX9XeDoxapGkYyCCpJ4JyQTEtsysxk0keJ
         4a0vz0t4FgYcWuINageV0tcRE7Z4Zop3/15o5JRT4KHZq0AxLj1RO7+0rHFDvvVLrMmz
         wUF/kaSkfqulduyWG+YW2MsGqq6p/IDzP5rgroVUEyHJk34hyDHGuY//ODmQ4s3G+lUz
         k+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qe+7XX/L5syn+cLvVHmf9Bl620oz//ebyw08Uel5J18=;
        fh=dGnP4pVYzjDoE76RipLDVoRFv6ug9sOteQ0RfHL1Sko=;
        b=gNXJTefHe5lYdZWofdlgvFOO2p9RTEznJgZKQEg8t4hpctThh7Nz8VKMGQmmLWY0qH
         V8K+zTRkXNqJp8oqET3/c7R1ho0lNXPOnqLcqHbHTS1HC0Y2EzEUHxfk4qSZgSFLyrPE
         9+Q3/CgZdrhjyMxrI4q4GZ1cq0S7zNSHjU689CGFgHumBXdC49wdav4bCgCPRRKxPxDB
         069sVtnWLYTenRQf92Sbk4PA2/tiLd77OgbGwHrun/fnAPMSt4ZlSfM8Rg5jauV/bns4
         RA8M9fxShSvoHYj7a7edE3HtZd1qZETLCcGlTCvKvZ/XJX8OUEIUf1SG3ivmU/Mpzhi5
         19yQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771301813; x=1771906613; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qe+7XX/L5syn+cLvVHmf9Bl620oz//ebyw08Uel5J18=;
        b=B+HXpIHG0tSTxiI9EhZ0HTLNVrd3JB4Xvv9hlsXrPnUq9zZhsBfOYL7wVgqO8iCBF5
         SWKUfVzoc4N1pQmQ1IQKOUlIsVnZj+lfAjxA7H4GHZyI3kpkMzeRiX3YobR2jN2wqRz8
         WQTQcHTJBcgBnEvVz5XSNNPrZqz1f6/m2R5rlNI/0PZiYY+MGywlsDPuYgzXF3FLKGgJ
         kzo1KOc5b7GMMQTnuV75QA6P9bj8PLhz2JzuIeMuak0GyoHUiteY8AlgXuYF7Vqrc1wl
         cjTs4XuGF3YfbzY6i4QuSuaGGVPokJYkg9lnYv84pHCSpu8bT7DRa0zHVScqPqV4E9wm
         NGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771301813; x=1771906613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qe+7XX/L5syn+cLvVHmf9Bl620oz//ebyw08Uel5J18=;
        b=bfpEaUKPoxDFF92zryfzl8agq1PLCPx8VJYjU9AaGucCpHWuuQStibJiwetee/FvIg
         rB8iOhX0lLfPQqKNldgA7ApCiPktvWCEkNX7WsCPlvUvEWzjbSegCsE6v3n+c4BlFESL
         zlDDfqbAfeu3qis4226ApXTOKdDoP0L2gthLeda0qQIiTHYt1+9EU2cs3eP+4i3K+tiB
         3co1eW/lJ5FvG2gI9eKx2EF7Dv5EAxwFevjY6GXFJsoD1MhrrNzez708+CWXDYAd49CX
         XksPCTd3rSZO0jWuJk4ipmZqqCvbyCnt3ZDn/bxZaz+Wb2VpamFiMwIDG8d19KdoKTRp
         VkAA==
X-Forwarded-Encrypted: i=1; AJvYcCWf0rCvBeqd9fMNZv87NOZiJSLJMveR+X4hRvVgws0ywaHGbHeZcHPD+4GGgWpclpPxwQew5E8Pcouk@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3AOtx630Ly8RVXVAAYrQysyL9KQ0L0kW+AmbbPFvn6BTEy11s
	6a2ybS20rYkvKNX+rEyJeBvaRvefB0FVZRMz6xSKahF3RYTpbP5JeeJrYQUcLAum9y9TS/g/KaE
	EHsQspOwMDB62HeC93xQafQYTP30L+5M=
X-Gm-Gg: AZuq6aLV1cQbfWW3Et+pU/yMBl4Mv+QcxHN9zGzWLZKYzQx/EXSyaxULhidDN8ZI3VT
	s0FVYtCCph92WG2Xrte092RkX9soo7NCL3dUGMoKosj9cJbkpasBfyCkuzdoGvwV5o6cexQ10sR
	/Tz46d6TFK16gMnIHXKzJoGvmNL6r4pBrbmyqOxt/k6eHOVkxFpF/ERv/34yssoz6YeqUgkkGVR
	VxuQZXnqxHGftm/kuVSdM48GH6+9T/1cRYnsrJ2qnuPId8H5JMZLQs64Y8iMytnUwatZnCb404w
	vIYe7g==
X-Received: by 2002:a17:907:3da2:b0:b87:d186:19e3 with SMTP id
 a640c23a62f3a-b8fb44a3778mr761877266b.43.1771301812795; Mon, 16 Feb 2026
 20:16:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=rDxeYKXoCJoWRwGGXv4tPCM2OuX+US_G3hm_tL3UyqtA@mail.gmail.com>
 <aZJmthYtk33KYDud@melos.hm.i.d.cx>
In-Reply-To: <aZJmthYtk33KYDud@melos.hm.i.d.cx>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 17 Feb 2026 09:46:41 +0530
X-Gm-Features: AaiRm51QHtefjwH_4aVN8UbkRPTl2or_N2X9XdmE9IAJs0YnwmTtQVL_DTyVRpY
Message-ID: <CANT5p=p6yw3eYJVXZc2CA2fBgBYpZ4W0uKivt2tCmtgos3GVdw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Namespace-aware upcalls from kernel filesystems
To: David Leadbeater <dgl@dgl.cx>
Cc: lsf-pc@lists.linux-foundation.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, keyrings@vger.kernel.org, 
	CIFS <linux-cifs@vger.kernel.org>, linux-nfs@vger.kernel.org, brauner@kernel.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2026 at 6:25=E2=80=AFAM David Leadbeater <dgl@dgl.cx> wrote=
:
>
> On Sat, Feb 14, 2026 at 03:36:22PM +0530, Shyam Prasad N wrote:
> > I tried to prototype a namespace aware upcall mechanism for kernel keys=
 here:
> > https://www.spinics.net/lists/keyrings/msg17581.html
> > But it has not been successful so far. I'm seeking reviews on this
> > approach from security point of view.
>
> I have more context from the containers side, but to me this doesn't
> appear safe. Entering the right namespaces isn't enough to safely run
> code within a container. The container runtime may have set up seccomp
> or other limits which this upcall won't respect.

Hi David,
Thanks for these comments.
Let me look into seccomp to see if kernel will have any visibility into it.

>
> I would like to see a solution to this though, we currently have custom
> callback code to make this work. I'm not familiar enough with the
> interfaces but an approach where something registers also seems
> desirable because it is able to preserve backwards compatibility, which
> changing the namespace the upcall runs in doesn't.

Ack. Will explore the options and get back to this thread.

>
> David
>


--=20
Regards,
Shyam
