Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD811C687
	for <linux-cifs@vger.kernel.org>; Tue, 20 Aug 2024 01:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724117053; cv=none; b=p76NDwHt7pN2wZyP0ONemnVKr0ZWy//QbC3+I8hKQQIY7w8weMjX2xHUJemcFiloYdnOrZ9tYHNpNqoGKr/kpTJuQM9in0/EAoorIwSep/Tk38KpqEtHk28xZBqF+sILblUhyHZ83jVc96ILmDkcHuxN5Mg92B/tD4FW1dNqxWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724117053; c=relaxed/simple;
	bh=qZJt29THNTJbTl/P4fQBLwCVvxnjuZg+/WFNzDAhwgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l23eA8P939azhZWr782QZzKm65VXh5bTQLZCIFDkNpEGxJoZ2GTNMaQP/0p6/jsRXLHGllvcPE1+iqwD7IQcVREjEFocveFQ+JuxcqHNCuJ7gsIdjq5UVjJJIL3x9O2SOgHowqxfz8/mPJBTvmDHbfACen4jnGIslfRjQw7nOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4XfG4x5; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4XfG4x5"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso6252000e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Aug 2024 18:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724117049; x=1724721849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZJt29THNTJbTl/P4fQBLwCVvxnjuZg+/WFNzDAhwgg=;
        b=D4XfG4x53OzBoJmcYEdUxN2FeN3/g+2clzE23nW3icl2O8gqxjAC9GQQAohI27TX1H
         VbFIzyrpB8HuFafJkBcM7d4iME+BS0Smj0Kci3dfw03tcZ7kpQAUuGOx7G8fGm32DSFp
         GgKJMfPe8Dfv+pTBgoMrT52nuTNU3Q5Fx6yz5PNotFOL42F5fCEpzzsAcnZmFslwROqv
         WI9ZfwICtobQ8XFsX8tyXY5g3ns8FMY4dVo4/4OnnLf7ONDJH5RVIVdhUnuGjV+9ejDN
         rhB3y0fcYFDqHXZmqwjM9v7GCNt8ab476ArsZp4uCjb0oHwyFwjU7wX0EVCjLym0BbQe
         ONxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724117049; x=1724721849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qZJt29THNTJbTl/P4fQBLwCVvxnjuZg+/WFNzDAhwgg=;
        b=teZ5snFYJnN/6/z4g9Vdxjz76sPCiymDYccuHdQ9+HMKFb73jO1ve7az2QPMuzcIqp
         w1ISalGKeVgOaSJt5WdNNa6RxvCy/aRxOocGC5d0+9oIueZg8XzMWTCoSTMdxouk9UzB
         8GSD1QVT61cX9Ba2796+JfUnDlENTvcr3j+WmttmIqs6NeM9zkhj7iwaViTBO7XR7cKy
         QHrFZULT4IOFYj67nUVfpTle6UBqhhjkimKDc4KCURGqJx8VTMHJFml59jG1EFwuADqV
         yBiMee2jJF0c7cusydhKV+W0tFI0TbJx+HVW4QTmEpbZQnaX+tcvEHYFu2z1I+DGH0sf
         5+Jg==
X-Gm-Message-State: AOJu0Yzx58XutOV6OJ8RIvwQwk6jFtJE56VM7CwkKLU9DI4cKS6FSHRr
	PgotlvmgC5fWTXTRa0K+cel4xmvU3jf+91JF0/Kig8pnQluXNZLqX9F8G8K52bIVqshwvMR7vPm
	7V4nZWG80Etvt7RY+OipsdqIpe7s=
X-Google-Smtp-Source: AGHT+IEObm59F8THKpr8E0aRQUDy8gtI2fAmoczN0BF0w5G4LPDSOfhVXpEhjZFM9RNRjcWWA6CYtXME0wl9NllNuSw=
X-Received: by 2002:a05:6512:a8d:b0:52e:fa5f:b6b1 with SMTP id
 2adb3069b0e04-5331c6f46c2mr7073753e87.60.1724117048955; Mon, 19 Aug 2024
 18:24:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
In-Reply-To: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 19 Aug 2024 20:23:57 -0500
Message-ID: <CAH2r5mufLoiXdRjwbpjEUdbUhpv8QuowTOSrTvnbxap=FmjpFA@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Marc <1marc1@gmail.com>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for reporting this.

If anyone has easy setup instructions, please feel free to share, that
is not a configuration I have tried.

I did find the reparse tag in the protocol specifications (see MS-FSCC
section 2.1.21) and it does indicate that it should be ignored.
Presumably the workaround would be to move this onedrive link down one
directory, but we will need to investigate ASAP how to fix this.

IO_REPARSE_TAG_CLOUD_6 0x9000601A

"Used by the Cloud Files filter, for files managed by a sync engine such
as OneDrive. Server-side interpretation only, not meaningful over the
wire."

On Mon, Aug 19, 2024 at 8:15=E2=80=AFPM Marc <1marc1@gmail.com> wrote:
>
> Dear all,
>
> First time posting here. Let me know if this is not the right location
> for this message: I am happy to redirect it elsewhere.
>
> I have the following setup: Windows 11 machine running in VirtualBox,
> hosted on Ubuntu 22.04.
>
> The Windows machine uses MS OneDrive to connect to our corporate
> OneDrive for SharePoint. Inside the OneDrive directory structure, I
> have created a Windows share. Let's call it "mydata".
>
> Whenever the Windows 11 machine is running, on my Ubuntu host, I then
> run `sudo mount.cifs //192.168.56.2/mydata /mnt/mydata -o
> username=3Dmarc,uid=3D1000,gid=3D1000`. This will then mount the Windows
> share and I can work with the files on Ubuntu.
>
> This has been working great for many years. Yesterday, this stopped
> working. When I tried mounting the share, I would get the following
> error: "mount error(95): Operation not supported". In dmesg I see:
> "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
> "VFS: cifs_read_super: get root inode failed".
>
> My Ubuntu host machine is completely up to date, running kernel
> 6.8.0-40-generic. From this machine I am able to mount other shares on
> the same Windows 11 box. It seems that as long as the shares have
> nothing to do with OneDrive, it works.
>
> When I booted my Ubuntu machine on kernel 6.5.0-45-generic, I am able
> to mount the OneDrive-related shares again.
>
> Hopefully someone can have a look into this situation.
>
> Regards, /|/|arc.
>


--=20
Thanks,

Steve
