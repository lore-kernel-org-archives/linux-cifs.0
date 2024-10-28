Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E1618FC75
	for <linux-cifs@vger.kernel.org>; Mon, 28 Oct 2024 21:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730149910; cv=none; b=IIhAQvw9UxDkTj95WY2mNaCzV/iiDUsxDlfHEQhzsXCj8+u78sdTImA1xL5gOYYGFll/yN7hr+c0FS3k9bCL7MxqmagDAz/3qwrnEDRnzBsMa05bnwVnYGh3tMVd4aBtnd+wj+1PNdXZ0SuMaEpoWkUSAKHeJ9jU9074iDrJrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730149910; c=relaxed/simple;
	bh=cUdDTco7JSh0JSrwAgOwMsgYwUqItUPbXGqNjli5Yfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5MiMMKu85duXMnKUguzgmPO9bDmJy1z8DhincAJKz7q8N9sdOoWI1gAOfzzeoiyyUsXs74KHojNXj9qLCV9cnOVJLr9QjdhPtXzdBY+GdIK5vE35YqJkTlxsMPL2PuJhyEYpJq7k2G0pKKpZKaelUFJZNKMFwRUKGm1gOspPZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Me8vy9dp; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Me8vy9dp"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f2b95775so5579938e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 28 Oct 2024 14:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730149906; x=1730754706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vFeuHJKOAkSOSbJZXzyd6I/TADXNwKaal4TytVMlwI=;
        b=Me8vy9dpMkPZfIst44IxRXV+AlTJOdD4ee40AO39FSJQI3thCSkEn92l0WSHBdwBYq
         SJlUWbLODDlaLIA1L/5cvi9lYyiOSP95BFab9SHP3WQqKhyYObxni9sUNHjH829+xBQi
         fHAvPbJBXTGO+g060D1dxZMBzoxsSlLS4J7JqkjGoo3+Px/FJgEPBXaEkR1xyCbp+WO4
         0inBZIG0MPJJcwdpGz9IKalJxm+7JjP9jy4wQXG5AU+WwhDXs/GKs4sm2Cv5B05YsWw9
         VaOl+8qcdeU12808t9pyIr+FKgB1baVmHOvQTMDv30XBC7E9w2SIr9/iO+pBdSWkNUQn
         I6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730149906; x=1730754706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vFeuHJKOAkSOSbJZXzyd6I/TADXNwKaal4TytVMlwI=;
        b=V2b0dxniYZplmvrY6sY3h9KZyFR02jNrGuDhq3Ul76pXgTeDyp6XdJVJxlgls7cnNa
         qJhgLEG5AnbpEg6TATZaIKGByXaJBGYhUThEMpGWo5ZpBZx1+S91FMnb3MRtKfSyuh4g
         eGj6yS0igqny1n4cCR/dvWvBNqov8CBd+C0zbLxTYaiP6k30CzJJv1Lh6zzQwyvmpb7Q
         7DPAQTzO2+wU3FAkIVl7xzkQ5c2GPBvJFgD9DaMZ/dUVB+3Y5PLEjUvY/8G6e9C2flUZ
         vacAJlqzzWqPlCDJ8S5YdgKSSWCbXs7tlvVkFcuuKZ+51PSnU7fGidjVti7HIolh/HqE
         TjXQ==
X-Gm-Message-State: AOJu0YwOtBgL7UVyXw1mDR+bH89/ngh5kdurAel8j8wywKBz4wiTswnh
	Zaz4CLUOcjvQL09fjHYUjNugG7H0ZCwdEAnYA+RrMEgMDbAOiBmBlJ6XK04cmBOcWRasjuW/fqX
	wIycBlKPeVHbstYRaGmJMpkLaM9KuFndxWvE=
X-Google-Smtp-Source: AGHT+IFIVcF8FdA98XZ3eTVgBBAz9me+P47qNJ/1yYUIFoI35AcvXYWyAcQGrKIjXZy87YdrJy2enxNANvUtZwDA/iU=
X-Received: by 2002:a05:6512:3ba3:b0:533:483f:9562 with SMTP id
 2adb3069b0e04-53b3491e07amr6373997e87.42.1730149905700; Mon, 28 Oct 2024
 14:11:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
 <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com> <42c8b091-a57a-4d4e-aebf-aee57dabf5d4@samba.org>
In-Reply-To: <42c8b091-a57a-4d4e-aebf-aee57dabf5d4@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 28 Oct 2024 16:11:34 -0500
Message-ID: <CAH2r5mtr0SJHzG4tNeRA=1H1gEswQUywj0G5kR+wuoPk1r1YVA@mail.gmail.com>
Subject: Re: Directory Leases
To: Ralph Boehme <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Doing some additional experiments to Windows and also to the updated
Samba branch from Ralph, I see the directory lease request, and
I see that after ls (which will cache the directory contents for about
30 second) we do get a big benefit from the metadata of the directory
entries being cached e.g. "ls /mnt ; sleep 10; stat /mnt/file ; sleep
15 stat /mnt/file2 ; sleep 10 /mnt/file"  - we only get the roundtrips
for the initial ls - the stat calls don't cause any network traffic
since the directory is cached.

> the client opens a directory with R lease, does a query-info on it and
> then opens the directory a second time, without lease, and uses that
> second handle for the directory listing.

We get two calls from the kernel here for that "ls"
That query info is for "revalidate" and the second roundtrip is for
the readdir, but
it does look like a bug in the querydir not reusing the handle.

On Sun, Oct 27, 2024 at 9:16=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 10/27/24 4:24 AM, Steve French wrote:
> > I built and installed Samba with your recent directory lease series
> > and tried some experiments with cifs.ko to it and I do see directory
> > lease requested by the client and held for 30 seconds for the
> > directory (or directories) that I do ls on,...
>
> hm, guess I was not looking close enough, I rechecked and now I can see
> the client requesting directory leases and the server granting them.
>
> Two things seem odd:
>
> - the client only requests a READ lease without a HANDLE lease,
>
> - the client opens a directory with R lease, does a query-info on it and
> then opens the directory a second time, without lease, and uses that
> second handle for the directory listing.
>
> In my understanding a directory lease without H lease is useless, as it
> limits lifetime of the cache to the lifetime of the handle and you can't
> defer the close on the directory handle without a H lease.
>
> Cf the presentation "SMB2.2 Advancements for WAN" from SDC 2011 page 20:
>
> "Without H leases, the R lease is of no value."
>
> open_cached_dir() seems to be the function requesting the directory
> lease and it requests SMB2_OPLOCK_LEVEL_II which is mapped to
> SMB2_LEASE_READ_CACHING_LE.
>
> Thanks!
> -slow



--=20
Thanks,

Steve
