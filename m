Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340AC6127
	for <linux-cifs@vger.kernel.org>; Tue,  5 Mar 2024 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709650627; cv=none; b=lQirX+aKqLZ2CRop9g+C9SUtjnGYtYIFTdy1XJsFOcvlX6wWaZlt0rWuWxzaCrRL9FZqAslck9h2j+G23RrVqtkjKbkWPiaCxIfzDUbvgFnQ3loYpn63e8qzY9OD/NE6jncdxAYMEJVJJnVU02K3A+iYkgSOWnJzcQM37NXN8NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709650627; c=relaxed/simple;
	bh=7K3f8N56AxnxIkmFSfvFHk5XrFx4+WdeNbL92uFplgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ewaZDnhBRIUly+o9gAk3IKAu9Ibzq3ylCWuFFrUxrke7rWU/DPFikSm0epaQJgSRcguX2OQZzknkifSLd1eQFQVm8ztQolJIXaSHzn0xDmrxy/UGjjGLBkXpxPQu2PNhjWMeT+gVXVJMrE4d6uAPDRTSzsTeS3VMIlEH3LHpn7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K86pr52f; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K86pr52f"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5131c48055cso974183e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2024 06:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709650624; x=1710255424; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7K3f8N56AxnxIkmFSfvFHk5XrFx4+WdeNbL92uFplgo=;
        b=K86pr52fi+xeX7+6JyKFtL5N5NXak2D06e+dRurxDuu+kbZIXDJIt3AV6Emagcugpm
         H2L1G0nlU3YhlsMcgivRq5PCSh/oOp9AtG0U6+D+CT7xbpzz13WsTFsWTGS/HpellzSW
         DOx0A//TnAiU3l9X04+1WZTI3AiwjOpeS+tvpvlDik+HWGmtALbcXstoBdzoId5t08hY
         GG+5Sq7s0m7C61UdOVGFpB21fMg14HxiP7Lg+EswIpMs+7HA3rkPF4ukG0BpVgiKuQuI
         Z8U39gPURcxMAmAPHFdtntH8P6lsnKvDRrozpjDzx0BVKIyqM6lN/SfK3HlyfEz8h2k6
         rlyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709650624; x=1710255424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7K3f8N56AxnxIkmFSfvFHk5XrFx4+WdeNbL92uFplgo=;
        b=wMrSkY0rl2UxCKTerRJWcdB6pU/dMOeFtY86d46Pki2TZ3CJ5LcNxnFgGMsDPZHO5E
         63OxKbLkPkMMJxJ+I44dthYF3rfLa8gXgI4AILI/cPybk+JZBkg20vSR3DrqRC0SVI/V
         JYCSiLrLeDRCZwEWSKb6rikeuy4x4Xx6SezvTQyCTwoHF5ruZXDH6IqgjFGFghFMJew4
         wjCE8QJSwsBFdEgT6+0jO7QUmdhYvQHqUvtLgNQrjx/TVWDSQjyD6mpNcSMyGM+5MJm3
         b+x4XvZqw0gD0CeZ4Iphzhx22fbleello66ZVlJvNMpON31tuHnwXyCcRKzqk4JSj7q3
         Siqw==
X-Forwarded-Encrypted: i=1; AJvYcCVMGnICKOxMvBwH33wVkejJoyFVFPDwhueSXDZFdV6FBVSU98JL9jhuZHaHDE1yRX1w9eCjRW2SHoGcWN6vu3F5FFjN1/tmEmikSQ==
X-Gm-Message-State: AOJu0YwOVWgzOleqzDkIwfatqqImQ1BoWPc837GSALVFAWPVjv2FkiiU
	1zJddXmwBYaHU5H5q8C4EDUQe0BT/ozZDgNkEZJ/E5Z67yfZY/4svV5UzlPneSXKYLN7AjFwKlf
	LviGhXai0IpddWUHTCfImV0OxAeQggBkG/HpPCg==
X-Google-Smtp-Source: AGHT+IHfi+jophyewzgEZaadL//ZGttBKQQR6XHkiMsCvJSQC6wIriNiBQIWLoev1hXsjI1iGRQZYQBjLROTEv3NGvk=
X-Received: by 2002:ac2:4ed3:0:b0:512:d7e8:7046 with SMTP id
 p19-20020ac24ed3000000b00512d7e87046mr1295663lfr.42.1709650623975; Tue, 05
 Mar 2024 06:57:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <20230310153211.10982-8-sprasad@microsoft.com>
 <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz> <CANT5p=p4+7uiWFBa6KBsqB1z1xW2fQwYD8gbnZviCA8crFqeQw@mail.gmail.com>
 <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz>
In-Reply-To: <2abdfcf3-49e7-42fe-a985-4ce3a3562d73@sairon.cz>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 5 Mar 2024 20:26:52 +0530
Message-ID: <CANT5p=oFg28z7vTgyHBOMvOeMU=-cgQQdiZOw22j4RHO94C3UA@mail.gmail.com>
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
To: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com, 
	linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>, 
	Stefan Agner <stefan@agner.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 2:52=E2=80=AFPM Jan =C4=8Cerm=C3=A1k <sairon@sairon=
.cz> wrote:
>
> Hi Shyam,
>

Hi Jan,
Apologies for the delay.

> On 27. 02. 24 17:17, Shyam Prasad N wrote:
> > These messages (in theory) should not show up if either multichannel
> > or max_channels are not specified mount options.
>
> That shouldn't be the case here, I checked with the user and he's not
> doing anything fishy himself (like interfering with the standard mount
> utilities), and the userspace tools creating the mounts should not be
> setting any of these options, which I confirmed by asking for his mounts
> list:
>
> //192.168.1.12/folder on /mnt/data/supervisor/mounts/folder type cifs
> (rw,relatime,vers=3Ddefault,cache=3Dstrict,username=3Duser,uid=3D0,noforc=
euid,gid=3D0,noforcegid,addr=3D192.168.1.12,file_mode=3D0755,dir_mode=3D075=
5,soft,nounix,mapposix,rsize=3D4194304,wsize=3D4194304,bsize=3D1048576,echo=
_interval=3D60,actimeo=3D1,closetimeo=3D1)
> //192.168.1.12/folder on /mnt/data/supervisor/media/folder type cifs
> (rw,relatime,vers=3Ddefault,cache=3Dstrict,username=3Duser,uid=3D0,noforc=
euid,gid=3D0,noforcegid,addr=3D192.168.1.12,file_mode=3D0755,dir_mode=3D075=
5,soft,nounix,mapposix,rsize=3D4194304,wsize=3D4194304,bsize=3D1048576,echo=
_interval=3D60,actimeo=3D1,closetimeo=3D1)

Hmmm.. That seems like a bug.
Is there any chance that the user is willing to try out if the same
bug reproduces with the latest mainline kernel?

The other option is for us to try with the 6.6 kernel. But without the
steps to repro, it'll just be shots in the dark.
Let me try to go through the code and see if I can spot anything here.

>
>
> Or am I missing anything here?
>
> > The repeating nature of these messages here leads me to also believe
> > that there's something fishy going on here.
> > Either the network health is not good, or that there's some bug at play=
 here.
>
> Maybe, however I'm not able to reproduce the above behavior yet. But
> there's been so far one more report of this happening, so it's not a
> single isolated case. I appreciate any advice what to look at further.

If a user has reproduced this issue, the one thing they can send us is
the ftrace output of cifs events when the issue is being seen.
i.e. something like this:
# trace-cmd start -e cifs
# <now wait for the issue to reproduce>
# trace-cmd stop
# trace-cmd extract > /tmp/outputs.txt
# uname -r >> /tmp/outputs,txt
# cat /proc/fs/cifs/DebugData >> /tmp/outputs,txt
# cat /proc/fs/cifs/Stats >> /tmp/outputs,txt

And then provide the outputs.txt file to us.
Going through that capture can help us understand this better.

>
> Cheers,
> Jan



--=20
Regards,
Shyam
