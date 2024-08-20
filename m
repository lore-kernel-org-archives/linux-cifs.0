Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6043D1B7F4
	for <linux-cifs@vger.kernel.org>; Tue, 20 Aug 2024 01:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724118280; cv=none; b=Ah4reomhUMROOjfae2EuDGc0PYvaY4k4HfKMYAULwGMAclB+54PfOghBiNV6fLnxT9ZVU8KVlXQgAElMO/v6/fO/OHwWuUgAVblmz1P5fvPFDadrN84GcQO3vf+pJtr+K5JIGCVFeeExcE+R6Qg03Ob0PnYIKGEW+OGOvnLBLig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724118280; c=relaxed/simple;
	bh=+W4boS1IEB29cZIlAK2mWfqEpNwVpgnRGdr1sox65vA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ydr8hR2mYX2ueGND4PGWsvZA6LJX32BqCYH3ddFDi0aFnnrxhGec0cRTAYPl2vQsaiZs86IQoWWR/8yHpxp7NqB9sqTCdWgITkIqEvxx/e3qhc5VLfqoY12jk8Z0scEAcTYxG8tupAL0rUgjDEcmefsJ+N4c/SMoi55ktzlDB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKD59xaq; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKD59xaq"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-70940c9657dso2304687a34.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Aug 2024 18:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724118278; x=1724723078; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+W4boS1IEB29cZIlAK2mWfqEpNwVpgnRGdr1sox65vA=;
        b=GKD59xaqu7CTYyXRjsP0/YzGtfu7ISPi2PkQpr2iC1WEkB2IyOErHnE8txJiaIYDs9
         XMRkH0lx9J7vhP4sm7klIFrZWNml8VX95/X2CCvK7p2mkK+UKTz/r2ojv41HCbbnEwSw
         aY96heplGH861yUq2KDDydVcZlZVGJGF9iPczIusuC4Z686BHKENvOR+1TvS3HGQbUJE
         c7RVF8DHOltf7hwHDp4i/cg1SRK8mZIY2hlzMpVTffnE3YRR8mhklW7UMvtVqTWBC3hY
         W1w6dlVlf3hW8rF2cZEhizbbkRYHjaBlz4K2U30t4BJfGGV3DkrFtwT87HMqVDEtWFFh
         pTKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724118278; x=1724723078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+W4boS1IEB29cZIlAK2mWfqEpNwVpgnRGdr1sox65vA=;
        b=YTOC/ofUWOZcTOVyA1mdWNuIoS008ELOhiyYJGdQllzRA7zma5AXVzB1Fb5rl9Sr/S
         vaXPBEEzy9URalTqcDjgXRI3l/T91MgIIcmuVQ9WLSijfy5MciIwjLqEKmc3QOGpPBUz
         HrhhtmpenpT9tRq5FfCAAkXemNHjgrM9TAJxi/HSvi/PHgsK2vL9wk33BSDNFOOOUZ5s
         VHP8NKvju1mxJiFsdd1dOm92h5LCNFrRaWauY8iPuMfR6Pai2qqoq3v1dSvNe7SJ0Nb6
         zzdfP2SW8HEupgdrHKUrzGyZh3GxJ6UqNsTeAKp+WuZph3GvWwpx9k76Ox100w/mzYXu
         Dcww==
X-Gm-Message-State: AOJu0YxVkd6ou/PUqysktoDDX6ZfsbbzODKP7OjCA4NwJRSRWEu+PWmT
	RQkmZdluYyRwsVitPJWmsGIFk9T27swuooSaHKMJf4WTjydpW0OgXXWfXMVMwDQXslxR6vmfdXP
	s1K3IhMiSao/FgLyL03t2QOa+ldHdc77m
X-Google-Smtp-Source: AGHT+IFnrvuZzBRJ2TYZ/6fJIHdveoRK2Bv1L6IxCOjtsVtGK6vokzAHJyOmjNYvcX+wPMFPPsuwZBULnfrwHcQ3IJ8=
X-Received: by 2002:a05:6830:3909:b0:709:4d43:32cd with SMTP id
 46e09a7af769-70cac842cf3mr15169854a34.10.1724118278298; Mon, 19 Aug 2024
 18:44:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <CAH2r5mufLoiXdRjwbpjEUdbUhpv8QuowTOSrTvnbxap=FmjpFA@mail.gmail.com>
In-Reply-To: <CAH2r5mufLoiXdRjwbpjEUdbUhpv8QuowTOSrTvnbxap=FmjpFA@mail.gmail.com>
From: Marc <1marc1@gmail.com>
Date: Tue, 20 Aug 2024 11:44:27 +1000
Message-ID: <CAMHwNVvgVmQ_W5B6X8v+y_YyrryLtziaJ1fGCRS7f8sZ2S18UA@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If I mount higher up the tree, e.g. I share "C:\Users\marc", then I
can mount. However when doing `ls -l`, the directories associated with
OneDrive show up as `d????????? ? ? ? ? ? OneDriveDirectory/`

Regards, /|/|arc.

Op di 20 aug 2024 om 11:24 schreef Steve French <smfrench@gmail.com>:
>
> Thank you for reporting this.
>
> If anyone has easy setup instructions, please feel free to share, that
> is not a configuration I have tried.
>
> I did find the reparse tag in the protocol specifications (see MS-FSCC
> section 2.1.21) and it does indicate that it should be ignored.
> Presumably the workaround would be to move this onedrive link down one
> directory, but we will need to investigate ASAP how to fix this.
>
> IO_REPARSE_TAG_CLOUD_6 0x9000601A
>
> "Used by the Cloud Files filter, for files managed by a sync engine such
> as OneDrive. Server-side interpretation only, not meaningful over the
> wire."
>
> On Mon, Aug 19, 2024 at 8:15=E2=80=AFPM Marc <1marc1@gmail.com> wrote:
> >
> > Dear all,
> >
> > First time posting here. Let me know if this is not the right location
> > for this message: I am happy to redirect it elsewhere.
> >
> > I have the following setup: Windows 11 machine running in VirtualBox,
> > hosted on Ubuntu 22.04.
> >
> > The Windows machine uses MS OneDrive to connect to our corporate
> > OneDrive for SharePoint. Inside the OneDrive directory structure, I
> > have created a Windows share. Let's call it "mydata".
> >
> > Whenever the Windows 11 machine is running, on my Ubuntu host, I then
> > run `sudo mount.cifs //192.168.56.2/mydata /mnt/mydata -o
> > username=3Dmarc,uid=3D1000,gid=3D1000`. This will then mount the Window=
s
> > share and I can work with the files on Ubuntu.
> >
> > This has been working great for many years. Yesterday, this stopped
> > working. When I tried mounting the share, I would get the following
> > error: "mount error(95): Operation not supported". In dmesg I see:
> > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
> > "VFS: cifs_read_super: get root inode failed".
> >
> > My Ubuntu host machine is completely up to date, running kernel
> > 6.8.0-40-generic. From this machine I am able to mount other shares on
> > the same Windows 11 box. It seems that as long as the shares have
> > nothing to do with OneDrive, it works.
> >
> > When I booted my Ubuntu machine on kernel 6.5.0-45-generic, I am able
> > to mount the OneDrive-related shares again.
> >
> > Hopefully someone can have a look into this situation.
> >
> > Regards, /|/|arc.
> >
>
>
> --
> Thanks,
>
> Steve
