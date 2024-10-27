Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD941C2E0
	for <linux-cifs@vger.kernel.org>; Sun, 27 Oct 2024 03:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729999483; cv=none; b=vCNppUGQUn9Fzn/0AP7vYmK037bhtHqa/1R2vx0M+2rTQ8Bw326Xg+vQZxyt7gfBiVVtT/PXAhtw76uf44DjpfpT1el6S/gJ9SmSrxD6fXIdbfojqf5b+fAd2QInukNiiBLP2OoFimOpsCqfy1mYuxbE1Np2jU2DOWeRSFucIGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729999483; c=relaxed/simple;
	bh=4hfxqfZzPom0z8VkpT00EAC3qOZBM4Ecgs90XQv4GJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j8Iuu+fI6bJ+iVD40xAg7+0fuBXg5esG528GWUAJ1uBeOvhtG+o6HJaj9CIVu05G6Iu8Zw8HUqWBxjhTe9BgnvkNylodsYSy7foeFXefID0aAnOkzocEYDyZ5f1l2owVIxQN+Hd8TCrbgZR6FZkDGCRnQn5/Er2zQUJKi2Pn90E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrwVaPQe; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrwVaPQe"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539eb97f26aso3267596e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 26 Oct 2024 20:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729999480; x=1730604280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcxzuUQ2Whwp/4RYp19EQFLTrhS+rHwigWQtmK3AKc4=;
        b=nrwVaPQeGqrKAOipBtrLcunwqkCpSeW6K5OwlQg7Mt+KAZs5skHVXLpewKK8WJfZ1q
         2VKya7iv9X0fBup8dCU7vOYcVKtfIOt18BsqW2UrFWSEuM+YclolR2laiNl0Zx5qUZH3
         zJlQkFLeUUf7M+AtoGnbqNZB5m3gWz5a//DF9q8AhoHx8BH9aOa3bKs4IAgeoK34c7iP
         ErBjfcuCqt8Jeh8nVONImlvg2JnFkGEm0ixHRmHTiKxpG+/6mMOR6IeHCCv3iyBnsnaT
         mKfFrhcMVdiNPeTDtftl8KqxSs2cuqz5JphMaTAMGmR5K35XhPSsVz5S51fwM9Y3VFr9
         pKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729999480; x=1730604280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcxzuUQ2Whwp/4RYp19EQFLTrhS+rHwigWQtmK3AKc4=;
        b=UwdFElTOt+F5HmAQfErgRdeSbI70zhUCVN1ywDwS/L7861U5oYof5j0IGNMcSDGhPh
         MnLwHi/IKc9liTK+Lwi166M3qTT62iS9GX3RcIPIpwzXQWwCnIWCKRfrbVKstrdFt6Zx
         n04kG/ZdHOfMuwRv2eTyV5jR9udoh+8BEk1T28VIESSXhac7I+dg2sIZoS5DdeBynY8n
         bDVKPdekzeA/ZGCXuo3aBYbBu0mrHqHK8sO/8FaDlMS7viPE5rNr7O07Hd7faspcVvG+
         q9uY7SWrfxvjmGLfNGIHDjauafRSVbuqQQFQQIbZurswdfacLbWKKW6zbKNzAB6LcqAB
         ZFwA==
X-Gm-Message-State: AOJu0YxNCwWHmCBPn8ELs/dZH176KAURJ6j4Sk6CPNO4mVKB8K2N5rkh
	/5AaMNLGFk2/86aqhqQmoZ9VgsFNdZQ9n2mbq/fqtqK52pY1rwB4GjYjSNuPxVYSXDHUYi7rAhL
	j0Nxhqp0jC51w+R0xqra61POJpok=
X-Google-Smtp-Source: AGHT+IEQCxsr7vH4LrZqaxmi9jFdbp1NTOSM43C9nBlq2Xjq38TM6WkNVN6q4pIw8eNjFvDBISHv3lGgePl0S98Vrm0=
X-Received: by 2002:a05:6512:2346:b0:539:ebc8:e4ca with SMTP id
 2adb3069b0e04-53b348b9d78mr1841533e87.10.1729999479331; Sat, 26 Oct 2024
 20:24:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
In-Reply-To: <113d44d8-35a4-452e-9931-aca00c2237d0@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 26 Oct 2024 22:24:27 -0500
Message-ID: <CAH2r5muwuKvifnG0XK3wShCtpR6EZOEozn=H95qx9ewHDO5jdA@mail.gmail.com>
Subject: Re: Directory Leases
To: Ralph Boehme <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I built and installed Samba with your recent directory lease series
and tried some experiments with cifs.ko to it and I do see directory
lease requested by the client and held for 30 seconds for the
directory (or directories) that I do ls on, but I don't see cifs.ko
using the cached directory contents when multiple ls on the same
directory are attempted within 30 seconds of one another.   One theory
is that this has to do with some compounding changes a few months ago
- but I want to investigate more - will try some experiments (repeated
ls, looking to see how directory cached contents are being used) to
Windows from cifs.ko as well.

From the debugging and traces I looked at tonight it does look
possible that the client has a perf regression in not reusing cached
directory contents when we have a directory lease.  Will update when I
narrow it down more.

On Sat, Oct 26, 2024 at 8:25=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> Hi!
>
> I have implemented Directory Leases in Samba and wanted to do a few test
> with real world clients.
>
> Mounting with
>
> # mount.cifs //localhost/test /mnt/test/ -o
> username=3Dslow,password=3Dx,handlecache
>
> (no idea if "handlecache" is needed, found it by skimming the code)
>
> I don't see any usage of Directory Leases on the wire when I do an ls.
>
> Do I need to pass any additional mount options? Anything else?
>
> Kernel version is 6.11.3-200.fc40.x86_64.
>
> Thanks!
> -slow
>


--=20
Thanks,

Steve
