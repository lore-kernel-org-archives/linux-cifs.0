Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D3A330B32
	for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2026 08:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773477497; cv=pass; b=Z5B1JXlWQq8LZ7T+Bex2rvHFs9H3j1Fl3JX3/g8o+psNWFqkozKMXw3XGVNgmmWO/aa1C3+IBi340W4ACjOIr/6L1Yaowawe4XMYR80tiXJvnNotBX51ZK5iRzDM5WYAhE3abS3TRygLZOxZgI0azKAYe88lSa9FKrosBRXxWz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773477497; c=relaxed/simple;
	bh=cpFmF24GyMqENVA2YfswM37tyb5jbpC/xuBjtDYp9TA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pM3CC/JOfboD/50liXa1LYH5NwPggiNv39knVXL8d4oYnZoJCq5Z2LlEbOd3FUUJTJ76abuJ0SUFIAhnGQ0ABaELScUVJANws1BHwwPVhsFCBv69o/sCVQUaZxuF+1dTk41L6rC09f8yVdWEBrCWYtt9Z8ey7ruXB4wM3EIYGHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRB60EF/; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRB60EF/"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8d7f22d405so381023066b.0
        for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2026 01:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773477492; cv=none;
        d=google.com; s=arc-20240605;
        b=XpLm8IpPSZsZqu/4LYXu5sizVIM+TZ3AjcCJJ/70rYvdsY1NXM6B/8nT4zxuZPtYmE
         QIEuGR4fl7V1toQ7ITGYG1pdbqEKbye5bIE4hfKdYbVYetOuZH5Bdc2smwoLk25FzSVY
         ZtRQbxQaWL0z/8ZoSp7VKy8a+/Gbi6d/0U2svLmmyI9s6wg6IiBpabfPfnK8tckCeEL8
         NEKK8DchhqdBW+Z0E/8P6LDrjbACrsyEKrKAlc5nuBSYMWzH/33lKt98o3qPij/xhETT
         cV31/By8c9DV9ZVKN91U8Sm2My3Ri6lahwnwieMzxysbMtgUDxJpMI7iJWDKCEZDp0g5
         22Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cpFmF24GyMqENVA2YfswM37tyb5jbpC/xuBjtDYp9TA=;
        fh=7JecXso58ETVEUPHnDZAUIiuOBorpUskgIGXjBNwYgk=;
        b=cG9Of1aiwcoJ3alr3m4Sdr0ivimshBec2YxmN5kE+7DJjGDylD+hi8Zcjc5w9ErsjW
         ow4JoNtWYPbvV4i1vt7H6ll52EachFABLvGO8+AUIeHmGFWND2eWShL/aW8peCyA1mGQ
         t9AHmk1jkeyWTKRbKATHfL5tinaFDfnHjwW7Z++JDVZhY929aMeVS4e7d8bFpRkz+o5I
         UwJbhDJqiEzDtDcc8/AN3DlxkZIHuzIIB1T2HFymeEb/MQbEhr4yFfpE177H/GQ2G8AR
         iTEZXvkrWr7TyfBqdUp9PpRkJvN0ueoC2FjD3MQ3G/K6ze33SKfiqiaidgl5GJeowV+p
         sp4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773477492; x=1774082292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpFmF24GyMqENVA2YfswM37tyb5jbpC/xuBjtDYp9TA=;
        b=PRB60EF/br+0oUpdlW1CuIFplh7gcDBjssdED2gkxbPFqk4TFhj89VfwJrkafCJCLr
         h33Kc2rXZlwFJ5NlAM0qEsnCM0Puan9MmlVb7wL0cDmaA9QcSmRc2A0AqqHfhfTa+Y8u
         dkVoRjy2yNEh/NjxaV4X8i9x6Qwsmw4lGE6vlZvmEHN0LI6wmAz4FXc2kXltUV5DpGak
         ttHFeav5DtTBvFTb7NpRKed+6M3uLAByns/7hBD39t4UBhNbDHK54E+6+TNH50GHoiAc
         ySCaa0LXyhDYUA9W8lSqMr2mszfpZZYPB/hVFS6nd/FL7tiduQvkVFGXD7OYUSwSAAwO
         HgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773477492; x=1774082292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cpFmF24GyMqENVA2YfswM37tyb5jbpC/xuBjtDYp9TA=;
        b=Ti9dNB5KMYKiEUnaWxJH/oyK77d/WIjWWqOC7cyNxgarbRw6u6p+h0IKEIPCm3KED5
         lRXKelRKNjpjhrLekw9XWaIHhSSCJUbOgifnDfASxnx4ZKpOWjnZCPY+SwTJlAtYXOmP
         eGQ8CWyKAofvyEwASPapgoPjxwWCL8VeOPYTfM2r1cEVkBjhGaQ4B0vT9wPmZY4TKq4l
         bnoKHuf0tFvHWCFtV55Dzu36Gy4YBNuEgtUqveNXy+2BSzxnV1yhnk48FYCaToxAOOIo
         7nW3Ot6oj0Eee455NbVeORR8R//2mc0igbrJ21vKxj2QadgfL1x9iDF3gJavTSmWDB9+
         JcIw==
X-Gm-Message-State: AOJu0YxLs0z6B/xC30xOfrAru3DNkDh9aq9GVPXkmoRRQEm7jgHfbfEY
	E2bGpHa5A7xzvebJyE8bfSQWOfmOKV8M13HRI4HJgDaUWfR9QyjAhG1y7xKQ5yxtvcCNu7Huk/O
	IRhsQxms686Nv8Sza97ZoN75xOs5gR5A=
X-Gm-Gg: ATEYQzzPH8g3nMRG/VIBTscnv5/MubQMztvRa93Z251+0JVnue/ftRmU0u3A1KWfZUB
	0Nz7tBugBHujb2LvfRAJQysjrWUSxbHZZOgdY+grjB+UTxRqxU3hIdZUTpO7BTRRtppeEvjAkE5
	OhSPVFd0gn7TiM0iePmuSYSyAgabSNr2A67q9qOCvY75+3cJITUKcoDqgae9YtJZJ0PsLK5r3i8
	azMwIkNNcrk4ooCfhu0vX8n0052XYsUBBMmGqTEG/UxulUIpVXI78RLx1dbuHAvtr4clbHEUflB
	QPIUxQ==
X-Received: by 2002:a17:907:d0c:b0:b97:810a:1a8e with SMTP id
 a640c23a62f3a-b97810a2ca7mr172635766b.24.1773477491721; Sat, 14 Mar 2026
 01:38:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304124629.1616108-1-sprasad@microsoft.com>
 <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
 <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com> <54dzktjc3vwt55dfj6wi4346la2my4fsg7wfyrtwm2apzvppip@xbi6evlur3kz>
In-Reply-To: <54dzktjc3vwt55dfj6wi4346la2my4fsg7wfyrtwm2apzvppip@xbi6evlur3kz>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 14 Mar 2026 14:07:59 +0530
X-Gm-Features: AaiRm52yMPZyYPlxRvKjB_3fUTGAzyCDokU521m0RD1PdLwcqZJ8yw1U8rqpJ2k
Message-ID: <CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com>
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 14, 2026 at 1:47=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On Fri, Mar 13, 2026 at 10:57:42AM +0530, Shyam Prasad N wrote:
> > On Fri, Mar 13, 2026 at 1:28=E2=80=AFAM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> > >
> > > On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com wrot=
e:
> > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > >
> > > > Today whenever we deal with a file, in addition to holding
> > > > a reference on the dentry, we also get a reference on the
> > > > superblock. This happens in two cases:
> > > > 1. when a new cinode is allocated
> > > > 2. when an oplock break is being processed
> > > >
> > > > The reasoning for holding the superblock ref was to make sure
> > > > that when umount happens, if there are users of inodes and
> > > > dentries, it does not try to clean them up and wait for the
> > > > last ref to superblock to be dropped by last of such users.
> > > >
> > > > But the side effect of doing that is that umount silently drops
> > > > a ref on the superblock and we could have deferred closes and
> > > > lease breaks still holding these refs.
> > > >
> > > > Ideally, we should ensure that all of these users of inodes and
> > > > dentries are cleaned up at the time of umount, which is what this
> > > > code is doing.
> > > >
> > > > This code change allows these code paths to use a ref on the
> > > > dentry (and hence the inode). That way, umount is
> > > > ensured to clean up SMB client resources when it's the last
> > > > ref on the superblock (For ex: when same objects are shared).
> > > >
> > > > The code change also moves the call to close all the files in
> > > > deferred close list to the umount code path. It also waits for
> > > > oplock_break workers to be flushed before calling
> > > > kill_anon_super (which eventually frees up those objects).
> > > >
> > > > Fixes: 24261fc23db9 ("cifs: delay super block destruction until all=
 cifsFileInfo objects are gone")
> > > > Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oploc=
k_break")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > ---
> > >
> > > Hi Shyam,
> > >
> > > So the side effect of the previous code is that the umount hangs unti=
l
> > > all the files are closed?
> >
> > Hi Henrique
> > Umount works. All it does is decrement refcount on sb.
> > When the last file is closed (or when the last cifs_oplock_break
> > processing completes) that's when cifs_kill_sb would get called.
> > Before that if there's another mount of the same share, it will reuse
> > the same session, tcon and open handles. As a result, an attempt to
> > delete files on the mount point may fail (which is one of first things
> > done by many xfstests).
> >
>
> Thank you for the explanation.
>
> I will wait for your v2.

Hi Steve,

I ran generic/694 to understand why it is failing with this change.
I think that this fix has just exposed a problem rather than caused it.

The test does the following:
1. either fallocates a file to 4G or pwrites to it
2. calls sync
3. runs stat to get number of blocks allocated for the file
4. umounts the share
5. mounts the share again
6. runs stat to get number of blocks allocated for the file
7. compares output of steps 3 and 6

Without this change, both step 3 and 6 would return 0, since even
through umount/mount, the same file would remain open (since
superblocks will be shared).
With this change, step 3 would return 0. Step 6 would return the right valu=
e.

If you use nosharesock even after reverting this change, you'll see
the test failing.
Or even with this change if actimeo=3D0, then this test passes.

The real question to ask is why aren't we updating i_blocks even after
sync succeeds?
My guess is that this has something to do with attribute caching when
the handle is kept open.

--=20
Regards,
Shyam
