Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E8E21CC71
	for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 07:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771053436; cv=pass; b=jbANacLM3E1xbKgtvZwo+xjUcBZM/x9ziadyo/RGYvMn4xLpc85aWAhhHeRdqFPTIZmFwPTNZQJEY9KB5deZ2TqOUV1nAanXDTegKzdYfOzuWySbJRZEIpsYvuVi8kCH7qeO9fwHm/lqRG/ES+OiIt8/1uvXA0GNmz5CUOlIehE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771053436; c=relaxed/simple;
	bh=gQNoXCleUVB/GQPpd4WrtiebRYMrChKNbKymArpDsoI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kEEYnRpZ84fdkJg2cgEqpXGvHIsJqziPpgA9iAdlfRo6jv4xYbANPUk7Pwa3gN2xzNKTQWf2IXgj1zukb4qhUAcW4Cn3AU9+egxea0OyG3ErzE/BB1ImhxWf7LozzKvu9qu0jiWR8xxV0JfybQrnVrz9nN9qHBuVjc8cYE5Hk98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lrdizb9w; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lrdizb9w"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b885a18f620so218358166b.3
        for <linux-cifs@vger.kernel.org>; Fri, 13 Feb 2026 23:17:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771053433; cv=none;
        d=google.com; s=arc-20240605;
        b=W2nY9pF5wfPunXxcmdfkhOiRi+ITrU0eCfjN1xuY6CYMD0htJKccKHunqGMoqbh9d/
         z3XFmsYDINQDfiyDfdgfF7EE0YB1Zhk5tXZu3iwxsfw1+2DZfWf82i8SbsHdz2n+D0A1
         bd5nzPtZhCiclvo1OwnnA7LKwRgWM9DaqVdDNzxrKenzOA9ZYMJ/RVXo60emVZIHlN+7
         pmsCfsg+6YzcYoec6muzNYGsn5AFja7jQ2qddLjr9f3zBhu9pXgqDuq8SKmC18UgHj7/
         Fvz73FXARwBSDvYbcoR6uGM5sMV7UdylT47h67vfqfwrT4H1Vwj7PSthGeVm9jlC/LsM
         rkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PXOCxnckoWaD3Jt8dx7GoM00kL4FtZQ5Um1imPSB1Zs=;
        fh=iYtOLZCZpwbqfWMOmPKG9pVjqSbbfrKng1F0YwjpMBY=;
        b=lgpuchR7lQ5cCq8S6B3PDFoNXYPgrAQYZh2F/F1zjRaHWzOhOA18OkR2BJnZdAgf9f
         iYF04+l1kDh4La/REmHXjjM7y/FHDM1UagZ6lx69fdgZIQ8ahM/y2Rw5+w3RaNoiI2j+
         0mWeKmu4o5yGv16LbPcYy/1zq9Wut3roxcV25CN8E7V1ivOe6m1qih8zSBUrn7h12r//
         AvffncN+cCsY5nQHFCAI/LhsLNJY+EmtpydSBvOcrglnypGZ9ytzSOIxLz+EK1rko7n0
         F0bT3rmyCFz/HQyR+j8+xmF+kvfGMf83mhs5rZVeqiedepvV6l+RxyP4KqPQOkQWFiHr
         X6Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771053433; x=1771658233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXOCxnckoWaD3Jt8dx7GoM00kL4FtZQ5Um1imPSB1Zs=;
        b=Lrdizb9wJS90t/PVU7zcjPjgm8kKV8kPyx9S5yHdu+OIET3HFxcIQuStiY+a8b3KTv
         UuHwxMTtlvAtPVmDm9K7UzD0C8dwaepjENQnzqVCr4+NQLF4UeWGqdo+XMp0Lc836ZUd
         hPArXtF1Q2jCPTRY9Hflep3vjZLb9Czys/fjO2yyTGAWZ0ul3QaLNVhRoqJkzNESnVBF
         79RdCmd/NcS/royXAqzwMvkuy6iE5JkdW7GDjAJi6bE28iQtSe3cNCndTJvx+po+duKG
         2xpbbO/mz/zaIXkGrjm8eC5VgFsT5gOlsNs0uTXKW8Wm6ajd5tZn+WFOv7x6+cbLIQr7
         FIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771053433; x=1771658233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PXOCxnckoWaD3Jt8dx7GoM00kL4FtZQ5Um1imPSB1Zs=;
        b=Ziwwh7Lgp/ayr7pmUgWhys4EqRyBVwPSXWOX3rCVuY/3cJDPAPHdjlfjkYzKpyxe6l
         R+Uukv6nmTbD1aNWpLpyihTDhwV1c+EUIYNzr6cxL/uJqlAScR1aExrJpNaNtjDVhJSX
         TSaCSTDJEXkqyOi8iv1x0MziRJzRxDwvw4zpa6vsqE5ku4Ar2/Ezik5N7fkf24eSgAZJ
         habRXQOOYi2KAHQ1zX/FpneOEThJXXf9w/899iVjSFZtFILs5JiF3nxSgComQm4a9Kyn
         XLN90ksAORlh3qt1xKrahHF1olth8QqL9XLF1GxU6JmvU8FMFd5bQZ0gfOjXIne8axc5
         VqyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqtgrgFm8mXWGUTbW6SVlfF9kvjqrbc5JQy65AxaQ6n1W7nj/OxITrGQzeATXvRSzIFzjr7xvEfgn4@vger.kernel.org
X-Gm-Message-State: AOJu0Yww97HgwlqwqGAfCsAOF390yyZOQPweraQifbK+rDYgSmKlI4eW
	MRj5zjEdhvaxgHK0Ed0ENJ1rFDex2TylDf5sw3pj6MkN+VkNre0v0JnsBfe1rwEdnWQujll71Yq
	sfg7/UTQt9+WhunyObW17R792iRM2iOo=
X-Gm-Gg: AZuq6aJXeMS/zt4tj55glEk9F5pc/CiTUbNgBnVMkMRFHog4Ic7fSTSjAjjzYi1wbSy
	8YJt1CL7EwaQYuXJ5UTTMd4b/prJl2v6aB/n0+MBhA/NKZwML6RpDAdfgYsiDCnhGd89QeHeD0m
	dc4dOXi4i9EB/SqgIe3W3wZrAUqnDIxrCLBytQGryKtKuKOoLEfG5FUY0EfnOmuuA2ObUHhG2ix
	kPInSVpZf1SxL9HFTMo0GBRKQhJbAppowRlj/t73b60yZ4bS9trk4ChKF+Q22aOxpd68bfPXLQ1
	KeyC8Q==
X-Received: by 2002:a17:907:747:b0:b8e:8874:8398 with SMTP id
 a640c23a62f3a-b8facd3d887mr304112466b.27.1771053433145; Fri, 13 Feb 2026
 23:17:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=oDUoq0JgTReUazFds5iLc+-gfiwL1iJXbeF-+YReXfSg@mail.gmail.com>
 <2463050.1770046784@warthog.procyon.org.uk> <1475df6b259c785c9a00e5ea496712fd@manguebit.org>
In-Reply-To: <1475df6b259c785c9a00e5ea496712fd@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 14 Feb 2026 12:47:01 +0530
X-Gm-Features: AZwV_QhKdUhmaXbxHYsP1AuqF1_Z06T6u57w2WDUfBiFYMkA8gifZi858eAmVJc
Message-ID: <CANT5p=qpdk4Qf9vJAdzWtw7JF=vnWBHnvSzqNAo2W+Bj+z-_wA@mail.gmail.com>
Subject: Re: Problem with existing SMB client mount code
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 2, 2026 at 10:51=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> David Howells <dhowells@redhat.com> writes:
>
> > The problem with not sharing the superblock is that you don't share any=
 of the
> > caches - not pagecache, not fscache.
>
> Yes, that would be a waste of system resources.  Not to mention that DFS
> and multiuser mounts would end up duplicating a lot of connections
> because they could no longer share superblocks.

My main problem is not the reuse of superblocks, but the filesystem
not having an ability to split them when necessary.
It is a case where user A and B both mount a share independently with
the same mount opts on two different mount points. Since the
filesystem sees that the superblocks can be reused, it does so.
Later, user B decides to change some mount option with remount. That
change will unfortunately affect user A mount too.

>
> Besides, what about existing users that rely on the following to happen:
>
> mount.cifs //srv/share /mnt/1 -o ${opts}
> mount.cifs //srv/share /mnt/1 -o ${opts} -> EBUSY
> ...
> mount.cifs //srv/share /mnt/1 -o ${opts} -> EBUSY
Not sure that I understand this. If you run these commands today, do
you get EBUSY?
>
> Instead of changing default behavior, what about using 'nosharesock'?
> This way you'll guarantee that every mount has an unique superblock, so
> your remount usecase will work.

Yes. That can be done.

--=20
Regards,
Shyam
