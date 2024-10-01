Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3D01865E0
	for <linux-cifs@vger.kernel.org>; Tue,  1 Oct 2024 12:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727785201; cv=none; b=A2QogABWDWtBluoVLRfH//A5WYRDTA/U0Vx88gOwfe0L5g+ogocDvdlXCzvG+tkCVRI0d42CIUpL16k8RtcNZ62f7w2aNtjBYtzTxGzIIcDjVc3XjwBGtWf/ctmAO/rV5wvDC/LwmHStThiVoznGW3cFCxh3uSfRmUuUbSRnMOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727785201; c=relaxed/simple;
	bh=EMc/V0l6vGhxUcC1V73XE0fGZXkHPvfDOq+3IrR4JRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMpLpUJVLoojpgYVxdJc7eFoGPgVaCJO13GuGQChWmfR9LVwP84ML7HrsbOPScAoIHGYf6IK4tWexYYIIHX55rMsznK0mC00ndtK9+yBY1FprOqBTSAm5ZpdBi4pKOLqQqn1flkLvS6zgMorm/ImHDeiZV/RF85YJIrS+dAInMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPQegO+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPQegO+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F93FC4CEC6
	for <linux-cifs@vger.kernel.org>; Tue,  1 Oct 2024 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727785199;
	bh=EMc/V0l6vGhxUcC1V73XE0fGZXkHPvfDOq+3IrR4JRk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oPQegO+Vnf6LduwxDtYiwlNCG/wxzqyuCm4ZKyZFtvNXL6NLHQJfZGaFUNcIe0HKp
	 dWFK9zz5vCdLzjAWpZGq9OlIG1bZxP/OW3sEUGl1jW0lK+ZotaK6L2T1TXGjO4xGQN
	 dCZMpxgi1LIuWtuqF599EmdVVHWAoa0aVs1HWB5FY2eUsN6pT8kOf1F2jhj2pwg1nv
	 a8OH7L3l5g8vmEsvHtEB9uq86umYs72gfiPK01CvZc7mOvSENo2eHGw4Ze18SkKzFi
	 RLROHSALYyMDGrQvFA0tI318U4OXVt5o1tuYYFLVACCKfhqKz8vGSVuRR1sM5Whjlh
	 FwmbVNn4tD21g==
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5e1b5b617b8so2570588eaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 01 Oct 2024 05:19:59 -0700 (PDT)
X-Gm-Message-State: AOJu0YzNL9TM7wot9Kcz5uOc4z+kpLVos8VzPi18i1SzTgljMaksWOjM
	Jgq7b/irOmxcpo4zk/E2/9D8R87bEbi5TDjeFawqgz+i8+JeOS3v1lD6YhF+RKAuk3uyxxRGTOZ
	8psKeyJpTz94gqZ4cwMqnMS8YCBw=
X-Google-Smtp-Source: AGHT+IGQ+FYkKdbZYkGj1kIX5lshBTpnQAtjzFCehHZ/fe7VXdUr382p42mT+mx5EyAY5DpCvspj3J1rECrpU2Bs2vU=
X-Received: by 2002:a05:6820:1693:b0:5e7:7a7a:37bd with SMTP id
 006d021491bc7-5e7a575c5e9mr1507460eaf.1.1727785198927; Tue, 01 Oct 2024
 05:19:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtfn-ve9+ohfE3HgxftcuX4CjpGqeAQ3x3EApQm-oFUCw@mail.gmail.com>
In-Reply-To: <CAH2r5mtfn-ve9+ohfE3HgxftcuX4CjpGqeAQ3x3EApQm-oFUCw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Oct 2024 21:19:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9PHgt2yqxExMg2U7U29pA_7S3BexpqZGiX_mVSKD0R6g@mail.gmail.com>
Message-ID: <CAKYAXd9PHgt2yqxExMg2U7U29pA_7S3BexpqZGiX_mVSKD0R6g@mail.gmail.com>
Subject: Re: improved special file support ksmbd
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 28, 2024 at 6:49=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> I noticed that support for special file support for ksmbd has improved
> with the recent patches e.g. but symlink can not be reported see below
> (in this example, I am mounting with "linux" mount option but file
> types are reported ok without "linux" as well):
This is not a new issue. symlink support in ksmbd was removed on
upstream, So smb2_create for symlink files to return
STATUS_ACCESS_DENIED. Work is in progress to add symlink support.  We
have to wait.
Aside from that, what's strange is...
What is "linux" option?  ksmbd refuses to open symlink regardless of
"linux" option of cifs.
Why does cifs.ko show differences depending on that option?

Thanks.
>
> root@smfrench-ThinkPad-P52:/shares/test# ls /mnt2 -l
> ls: /mnt2/symlinktofile: Permission denied
> total 8192
> -rw-r--r-- 1 root      root            0 Sep 27 16:37 block1
> -r--r--r-- 1 root      root            0 Sep 27 16:37 block2-mode-0444
> -rw-r--r-- 1 root      root            0 Sep 27 16:36 char1
> -r--r--r-- 1 root      root            0 Sep 27 16:37 char2-mode-0444
> -rw-r--r-- 1 smfrench  root            0 Sep 27 16:37 char3-owner-smfrenc=
h
> -rw-r--r-- 1 root      root            0 Sep 27 16:36 fifo
> -rw-r--r-- 1 root      root            0 Sep 27 16:38 file
> -rwxrwxrwx 1 root      root            4 Sep 27 16:38 symlinktofile
>
> and
>
> # stat /mnt2/symlinktofile
> stat: cannot statx '/mnt2/symlinktofile': Permission denied
>
> Locally the symlink looks like this on the server:
> $ stat /shares/test/symlinktofile
>   File: /shares/test/symlinktofile -> file
>   Size: 4          Blocks: 0          IO Block: 4096   symbolic link
> Device: 259,6 Inode: 268436173   Links: 1
> Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
>
> A few at SDC also reminded that it is best to report server side
> symlink with the default Windows format (reparse point for Windows
> symlink).
>
> Any ideas?
>
>
>
> --
> Thanks,
>
> Steve
