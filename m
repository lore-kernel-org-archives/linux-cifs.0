Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6577913CA97
	for <linux-cifs@vger.kernel.org>; Sat,  2 Nov 2024 06:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730529013; cv=none; b=tjXSwrnQh/f72ET/zrHgAF1ydl0VYG6m+qzLv0SADEEWkWNBgnEx68s6Nm0Qv/klfe/uxZNBPWuTcXIaCcyI8NtWzG25AXRwB+uZUiDWbrxRmNP8+MrT8KmwNel4FLMRvhp0lFxkITpEPg2/SJfal9QONwhLrwr0SljVDsr8goc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730529013; c=relaxed/simple;
	bh=K35Pbc86DK9EYd0OEBIzT9WdDVbKTTBaUeK/ijvUtyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=iubjfSmxpugr0BMeVOzI7gyVaWRBUhNnnPAwTJTbotGmC0T7U/zgW1j1g8ufgkv/w2l3R10otqUg/iMpSxF+n9e3JFd2xxHBqpNKkK9fH8T2tn+DIhba7ZCjSv8LSGfhwkvmD+0r6qLqkPB0PE2JBnKdWaZYqbPruhpPW5faZ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nOHm8bKB; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nOHm8bKB"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f1292a9bso3072275e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 Nov 2024 23:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730529009; x=1731133809; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yf0M2g+wsanIB/g/qd+1WZv+33tePhjQLmA30+X1uk=;
        b=nOHm8bKB0aPHU3QM+5MJF+60bwxlm5+DdBsiG8fgkSFAuAhexeaQV4KJMEJpM7+Tti
         KS2Im0BVFQ4eLJrawRfwtCqAEAURgA+nWIbLCulpBXL5AJmklVCh/4MweOmmIH4a5hyS
         GHJdQQ01VK0qLjowlLYTs+pMFvdHADnEJVsxTOtB7qJzBblFcG/KmIi4pdsSKFMNdlSC
         Ctf2HxAmFu+P9hFekosBs2BWqTlIhoP9ANITyCOCfyZHCs7FCWve/ql/HeTQSJgCAUWt
         xC5lpA+d29XYAxqZkR2CsRQWC4h7/2nOrkeo31jL0qpILzVi6HsXxy6O4KdmWBTo0UNC
         ++qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730529009; x=1731133809;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6yf0M2g+wsanIB/g/qd+1WZv+33tePhjQLmA30+X1uk=;
        b=tNTwj95IM9eQR5RzaWXudlfo5wQr0fsosvwm3EGnyXsIegnT4grbrFdD3vctRz5URd
         Bj+kvMUSWTTXxyTyl+QMakFA2jTtMpmdnOhyA0BpH3PLXONb6BTY33KIfxEoKMYMCU/K
         V1YibSmbAZ0/mSY2Vr58iZ8d/HKUNgeLNacOY13SajgZ6UMAWLB+lY0Mo7pbrEgyCnJP
         ejzDa9NPK6oqzVHVF19mIznQkAlhbArba5t62xJS00s/OMP++AAa+9n850s+PtlN6PX8
         P+zY7SNJ3/xLLNoG6zsF1TEwcP8QBCk+sf9Ix3Brm8DgSyh8M/O/Vua6ya/rygh4Y8Sl
         /6ZQ==
X-Gm-Message-State: AOJu0YycSdaiYAVqyB7og2k7pyFUvTfRJjG1RASZbhIgak90WrvW/Jb2
	GJWnVq2vTmvS9VHL9IvmPV7mI02l5bRHzNmIpbfrGXfnkpajk+Zj3FHhEIYP4qAGTvg3dt/DKru
	n8BZPkyQFw/jlEbrMQy2SLb7G5M4tirhX
X-Google-Smtp-Source: AGHT+IG1lrUNIWyspq5+2np7ogbfwCMQsUMFb+3K9cC1c40ovkGBhdd04F4OdEcUp7T5S+39l6wYGiG1P9oeSjmFxwc=
X-Received: by 2002:a05:6512:1324:b0:539:8980:2009 with SMTP id
 2adb3069b0e04-53b348e76femr13185310e87.36.1730529009010; Fri, 01 Nov 2024
 23:30:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
 <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com>
 <42c8b091-a57a-4d4e-aebf-aee57dabf5d4@samba.org> <CAH2r5mtr0SJHzG4tNeRA=1H1gEswQUywj0G5kR+wuoPk1r1YVA@mail.gmail.com>
 <6e38eeba-9a82-48f4-bfcd-a4f2ce718782@samba.org> <CAH2r5mtkuCihp9hRp16RSyV=g0xcPyYuUBbBipBAtdw_CbiTKQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtkuCihp9hRp16RSyV=g0xcPyYuUBbBipBAtdw_CbiTKQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 2 Nov 2024 01:29:57 -0500
Message-ID: <CAH2r5muc_uD2GH6FWe=jwNzS=h_s_+b6ruhNqr0UP9t3ZkO_Rw@mail.gmail.com>
Subject: Fwd: Directory Leases
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ralph,
Looking at the problem you noted with multiple directory listings (ie
'readdir') for the same directory not being served out of the
directory cache on the Linux client (as the 'stat' calls after
'readdir' will be) - I noticed that in cifs_readdir() in
fs/smb/client/readdir.c we are failing here - dirents.is_valid is not
set.  I want to dig into this more in the next few days and fix that
(and the missing 'H' in the lease request)

        /*
         * If we already have the entire directory cached then
         * we can just serve the cache.
         */
        if (cfid->dirents.is_valid) {
...

On Tue, Oct 29, 2024 at 5:05=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> Hi Steve,
>
> On 10/28/24 10:11 PM, Steve French wrote:
> > Doing some additional experiments to Windows and also to the updated
> > Samba branch from Ralph, I see the directory lease request, and
> > I see that after ls (which will cache the directory contents for about
> > 30 second) we do get a big benefit from the metadata of the directory
> > entries being cached e.g. "ls /mnt ; sleep 10; stat /mnt/file ; sleep
> > 15 stat /mnt/file2 ; sleep 10 /mnt/file"  - we only get the roundtrips
> > for the initial ls - the stat calls don't cause any network traffic
> > since the directory is cached.
> indeed, I can confirm that some cache is used for stat. Unfortunately it
> isn't used for readddir.
>
> Also, coming back on the issue that the client is deferring a close on
> the directory with having a H lease:
>
> In my understanding that's at least going to cause problems if other
> clients want to do anything on the server that is not allowed if there
> are conflicting opens like renaming a directory (which is not allowed if
> there are any opens below recursively). Unlinks will also be deferred as
> long as the client sticks to its handle.
>
> The client should acquire a RH lease on directories if it wants to cache
> the handle and that's a prerequisite in order to cache readdir.
>
> Afair the kernel is currently caching for 30 seconds. Increasing this
> time should not be done without also having a H lease.
>
> -slow



--=20
Thanks,

Steve


--=20
Thanks,

Steve
