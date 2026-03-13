Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E8F398910
	for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 20:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433036; cv=none; b=jQF5B4Zml/AisNDocNWarliOIz9bKfjSh0ZMgB+IBsfKYW6lIgOIpRdzyrfYorTKKR+/zOZ1bY8AxWnUB0ggQjfBt5Glz4b+pWWaMeKw1/NScDwwjDnn18iX3yaJ30X7ZjQLmxoMjpxzYqrS98Q2fEWehUVIcqgpn1MYc+qxm9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433036; c=relaxed/simple;
	bh=vbARsqc+d3uVyBmdOg0cXIP4bmMldMpQ98Q8O6fpLMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaDhElnv6tzOXVVaw0JP03zQKmMdo4MTzl7NAJRajwlFeHb9crcmCe4X8vqvdugOmrpH23TQhM4hGnnB6hz18bo3khZO16OtrrXobF/ej8V4rJpdT2cNJYSYNDTp8cIhxxhRgJ37t4f3QduZuB+9ujk0+GnplqrgsDbv0DtXM3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BuQCbkPX; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BuQCbkPX"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48374014a77so24964185e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 13 Mar 2026 13:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773433033; x=1774037833; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q9gHGobWfNUu+5lsnewMjx+gKUC6WWoehDbrgRIwq2c=;
        b=BuQCbkPXqi9AzsFTO9JdLA3zr6GF2X8rFkV07zXk9hQhqzQhd/2GSue+1MWWH4pTTx
         MKYTqZs3ZONYNX5B5nSWsgORb8vtYZv76P/FbXzNbDpnol9Qg3U4GmpV6iwtP9Tb4KnS
         C3eFPUBBasSru0/G/SnFv84MVW3K1H1atI0JX5nhJHv/F1FcFw5bL1OTBWifWrPS6Ert
         Y5E9KNKLr+cBBgdTbIl/gjkL1VqEAaXi6M1ztzkAk3dkB0HXcSwekuy5so9LwZ29LY4M
         RWfDWOw8lQKAo57axq5Uk9fXvUBQ5hdUXgY1PsX9L7l8fDdbT+UZZi05WwtZfZZ4hFyG
         NHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773433033; x=1774037833;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9gHGobWfNUu+5lsnewMjx+gKUC6WWoehDbrgRIwq2c=;
        b=kCkaZEZ+Ms4NgBcdoPlNumpM5QNAAPULnke9pQwB19a1iCwkhsMRfFZF9g9ZFdwEeI
         gln3+kCfLNIhF5TOcjGObz0tLznF4hm+9jkwY3w39N7NQQ5MFl8cBly+A5owtp+09W5p
         bbLZ2GbFuCe3LaQqtveea4Ay0lJmRE6ZrmDqATo05Qgncaak2fIlrgZL2L0nojrnjvGg
         23Ht/jnTMytCHkESZUKwk8KE5YRfmUH4YYDcTvofeHIo2vm0+smeiePMA2S7B6yl701Z
         X+2j4MHmsm/2na0SJxgt7VkrGI5Vd/7F7ir58+TkgJXfFWbNjHy2PcpqNiJuL9vSFc0B
         yM3w==
X-Gm-Message-State: AOJu0YwN7ZbS3vEAaP37fTXRQLmtXuxl34HpaKsL89SRPXuT+O6/nQHn
	nCjoV7CmLQ09LJ4FgIdjke05VnWlHbAkwSA6eFxiRqCiyiOkNcKPomTTfE4vIywc0Cc=
X-Gm-Gg: ATEYQzx8WfFJIpg35Lm2uCFzQ9v8BBSTO1VW+d1xGIfCZOAQK0DXi6FE+YZMmWT7Ymw
	i+tQP2AWi4K6OoI37KsagJOeInB/79W/k73xiZcDVlKifEcQKFleut+BTbT+wtd9Evkp7A2K5/z
	O5IMoIVtENOTgJ0c7eG3tG4mfjlyO0VZuUYKzCVLRNqOs67xmOohGiqI0mPnPIvwux1uSmnwrhP
	mEuXTBzXbE3nHY8MHthwePyyuQkPGd28KQ3iGKQZKyQBadbqI0f0USQRZBMo3zY5LCk2Q7XyNZK
	o+QsruTZvEmKA3hOC5MLil3PYiqmtLKDhrp7nvVjfgZ1fokX3ilYp9gEHVU4dRHis6jTbpi6iYP
	SpJNtwI3jb2XeyeqizbxO1iWwe+E0KwoEeZfGPCR+8auYFjZj495MrajpJTdtd2SVTqNxrRM+Yw
	5kXp7wOOCjtY5IXi4sdrZJn+Y7Gf3fnkXM/ROFJHwDZnged92fP14Ex82SHVhibgF8fw==
X-Received: by 2002:a05:600c:354b:b0:483:2c98:4368 with SMTP id 5b1f17b1804b1-48556703401mr76665615e9.18.1773433032551;
        Fri, 13 Mar 2026 13:17:12 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2beab3a1117sm4787248eec.3.2026.03.13.13.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 13:17:11 -0700 (PDT)
Date: Fri, 13 Mar 2026 17:17:06 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
Message-ID: <54dzktjc3vwt55dfj6wi4346la2my4fsg7wfyrtwm2apzvppip@xbi6evlur3kz>
References: <20260304124629.1616108-1-sprasad@microsoft.com>
 <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
 <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com>

On Fri, Mar 13, 2026 at 10:57:42AM +0530, Shyam Prasad N wrote:
> On Fri, Mar 13, 2026 at 1:28 AM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com wrote:
> > > From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > Today whenever we deal with a file, in addition to holding
> > > a reference on the dentry, we also get a reference on the
> > > superblock. This happens in two cases:
> > > 1. when a new cinode is allocated
> > > 2. when an oplock break is being processed
> > >
> > > The reasoning for holding the superblock ref was to make sure
> > > that when umount happens, if there are users of inodes and
> > > dentries, it does not try to clean them up and wait for the
> > > last ref to superblock to be dropped by last of such users.
> > >
> > > But the side effect of doing that is that umount silently drops
> > > a ref on the superblock and we could have deferred closes and
> > > lease breaks still holding these refs.
> > >
> > > Ideally, we should ensure that all of these users of inodes and
> > > dentries are cleaned up at the time of umount, which is what this
> > > code is doing.
> > >
> > > This code change allows these code paths to use a ref on the
> > > dentry (and hence the inode). That way, umount is
> > > ensured to clean up SMB client resources when it's the last
> > > ref on the superblock (For ex: when same objects are shared).
> > >
> > > The code change also moves the call to close all the files in
> > > deferred close list to the umount code path. It also waits for
> > > oplock_break workers to be flushed before calling
> > > kill_anon_super (which eventually frees up those objects).
> > >
> > > Fixes: 24261fc23db9 ("cifs: delay super block destruction until all cifsFileInfo objects are gone")
> > > Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_oplock_break")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > ---
> >
> > Hi Shyam,
> >
> > So the side effect of the previous code is that the umount hangs until
> > all the files are closed?
> 
> Hi Henrique
> Umount works. All it does is decrement refcount on sb.
> When the last file is closed (or when the last cifs_oplock_break
> processing completes) that's when cifs_kill_sb would get called.
> Before that if there's another mount of the same share, it will reuse
> the same session, tcon and open handles. As a result, an attempt to
> delete files on the mount point may fail (which is one of first things
> done by many xfstests).
>

Thank you for the explanation.

I will wait for your v2.
