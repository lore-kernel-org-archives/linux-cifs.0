Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187D71118C
	for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2024 03:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447836; cv=none; b=AEaRZnHT371dyROPYlbLUVRsmuqJCp0MevljnTEnmz8/eNkrudB3JZ+WLOCAZyVCqZZsOaMQdaumIsOlM7pB/wTUmq53lwdQMq0/dFTGlXVOnJ4/pwkbC0aSG92AnepJXJw+aZSxp3StpNqrNjiFgerxMwFR6h+/oTzVm3E8OPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447836; c=relaxed/simple;
	bh=niWRDPM1WBU34BVtBTwmyJO/rtKF4BHAs3mE0IksNW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JnJYPLLMXhed243RYQv8fWYw65BN5oTJ9McaHrxAs/9CMwHPA3zmPAuU3mamUrCEPDrG9xqy9SzbvL5KSAfCRm9wOSe5JZu/xFtPTRQjfcdA15D792Jx8fZJ9Vw7AiyzifexbmxgVeOUIqlOSqn/E5UedR0z5nV0ZYCoF10x48Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=giDciKMl; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="giDciKMl"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2def8e58471so81010261fa.0
        for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 20:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714447833; x=1715052633; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MoZlXSZP/0npl5u6Gp7hc8n3Y3K8zPSHo+Cg+9jfJxs=;
        b=giDciKMlqJbateUjLO3vzHCKfG2nEkgenfevoFXmsqrIlwFHW10uiXGpwUdx+bdgpf
         55SZbv58Bo0B/3vT2qfapnO/b3qhkb9Uipq7uHXMPDMNxVt+4zpQR+IEAuwnbqd8O1u/
         cWkHtXhU7Ndx4DRmHQJINqDEhDPCZMAtRU1DEaxFlpn2Pel4H6I299uC6/0jvJiKWnjC
         s+6lWNEj7bDcj9FOORn3/bSRhMbVCsc3C/jJdujqmUoXwvbGRQfGMDGlDBny1Nnd19Ta
         8XWRibz78XCjF81txB5ynwfA8IdMOLX46kTGBpOkgQpaSdLljkAOs50DcNABX6Go0hPA
         K4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714447833; x=1715052633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MoZlXSZP/0npl5u6Gp7hc8n3Y3K8zPSHo+Cg+9jfJxs=;
        b=tG3jaulTJGYKBrGYF2uErs5AI3qxOVk6a9gFAHqJWmnQbU6umv7jSo6CFdBntEAaB2
         5haCSsK8siYHFwAXbsN7R81AAhK2iglLzpkZRgwFpyiZBMdybI5BD1D96qDw5z6hw1zb
         q51nMI4mdfSV7Cp2sDkuPE7tbwl6o/OhLAUyErywHsG8uU6JZwZ1Y9o1Ded08f7ik3eq
         pCrsrRZEO6o1jHuqoct9N+Nxy9N9kfaCcKCDuchc/gmyVUO3NAYkBduDC+27tu233OBN
         3/bWem6mXl8abNApyOU+dXhQCwIxDbSf31Mi0lzgTtkSAOVEaL8jRNJGJuVa4eNrdOsj
         xkhw==
X-Forwarded-Encrypted: i=1; AJvYcCVq4RdCrLLNw9N4yVeytBfyTcZXVF0GahrGGC0axHBXa6CnPTV+4Yz3rqLOZlwxid9U6ySl3XewCVWXhY12ljEOQUelrNPWf0rbeQ==
X-Gm-Message-State: AOJu0YwTeYpvqmrrdgFlgHnkjdAn58O6AUc5oYDfVy5pCgFs+mZAEzBP
	QWiq2w5t+2i4S6mh0BfkNnZvkg4+aBP7XzJJW0HBH6dYuaU8KS8rTuw7m15pSTYe609DA3NexAm
	GOznI4xqt85A/U101iODC2aHx79k=
X-Google-Smtp-Source: AGHT+IFwkPOLqw8WtqjbNzTmmhTNLX0Q1atBGD1deVAz7dqHzyROhOur4V0LlxYm2Cw/rLJsRgiss0ST8lIYG/3J6Tg=
X-Received: by 2002:a05:651c:221b:b0:2e0:5d7:a3a6 with SMTP id
 y27-20020a05651c221b00b002e005d7a3a6mr6445182ljq.9.1714447832661; Mon, 29 Apr
 2024 20:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
 <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org> <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
 <83480311-74b1-4ee6-be85-5b21b0f55ee9@samba.org> <Zi/UzF/guANa02KO@jeremy-HP-Z840-Workstation>
In-Reply-To: <Zi/UzF/guANa02KO@jeremy-HP-Z840-Workstation>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Apr 2024 22:30:21 -0500
Message-ID: <CAH2r5msSmi7z0usFAU-BGctoApZthgqy6j9ZdghYRyifBNB60A@mail.gmail.com>
Subject: Re: query fs info level 0x100
To: Jeremy Allison <jra@samba.org>
Cc: Ralph Boehme <slow@samba.org>, samba-technical <samba-technical@lists.samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Worked for me.  You can add my Reviewed-by and Tested-by if you want.

On Mon, Apr 29, 2024 at 12:11=E2=80=AFPM Jeremy Allison <jra@samba.org> wro=
te:
>
> On Mon, Apr 29, 2024 at 06:44:39PM +0200, Ralph Boehme wrote:
> >On 4/29/24 6:13 PM, Steve French wrote:
> >>But the (current Samba) server fails the level 100 (level 0x64 in hex)
> >>FS_POSIX_INFO with "STATUS_INVALID_ERROR_CLASS"
> >>which causes all xfstests to break since they can't verify the mount
> >>(e.g. with "stat -f").
> >>Nothing related to this on the client has changed, and ksmbd has
> >>always supported this so works fine there.
> >
> >ah, I broke it. Fix attached. Really embarrassing...
>
> Double embarrassing, I +1 reviewed it. So sorry for the bug :-(.



--=20
Thanks,

Steve
