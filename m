Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0554E330B3A
	for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2026 22:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773525843; cv=pass; b=PA06BADmOnE1KgJjNd7nhQgo7fAUMLsokyeM/P/u67dWPslPSaeXR7m6QrdmEDu8EfhXh1ICmmwEwpL7EPkUy7COm4IDM6bTSk0F1fNbGAvnUua7b1PXbs/TlcMM6QLymua0SraCmiWtsAXp9wu4PVDRL0lTRsIi08cxejFYsO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773525843; c=relaxed/simple;
	bh=tESGjDRsRwRVMJz7YziPnRrYKHNBVbivzom9+m38T5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p/FHDzH3cBQkhd7Ev2B2CtFHphImCiGc3YlYwJOrH4DcQgacA5Phe5I+chUGGocIBqk027A3a93qlwlWea/T3r8F5dQTE173kxolZE99Zbyz5TrYm+TK9XiCvJ/bZ39dmg1dMFmDVuQaSbWO1qBtH7siFowZ35OAeLCl5NLqaNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDrXtgAz; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDrXtgAz"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89a1c6dd788so43164936d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 14 Mar 2026 15:04:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773525841; cv=none;
        d=google.com; s=arc-20240605;
        b=ChmqipWAueV9/QIx10yAqRjd9McLptMcz/3XwtgX/sVmZSEtGi/KGXpco50ExPj2Wk
         Eg3TJIx5nt2k1j16dE0PDvMvVZwkmDFOcEvOazs3sFWXx5zPWXh9J941s93IAGMqyaji
         8O9F+aSz5PmgJRI4CJZGj32Ifocx/IGaBnm3jSujfWQajGGzxXncpuuxxJpnk2i3T8LL
         sWcLIrQMdZBieQk7szr92rvwDsGYqwVtMBhM3TJG8KFrBXDOXnijyBCz4vQmv9QmRNbz
         tCzcZQpARSWie6s0RfZW893PplB9Pf1dlYov5dbM0q+ofvRH901UDUHhLJMyjMzTLsMH
         6aGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rE6cISs8geIe6+6m5MJBJl+B8H3cnkAkxjeX8DjEF0g=;
        fh=dUZbi13m/5INif3hC86nOgS9R8cwmypW8E0wGtV5SkQ=;
        b=UrmzSu51a9o84+CPK25TLAaKgazmUJoqnuwIjV81o9q7BJ1UhsyxGpjRSyKS4CrjT+
         Rh3X57eT8iHh1+JcMgWnBSu5XholBf4/e7LwV6vD7DaZTihZYWUOIWzsesuvSQWshDLC
         r3Ej8/ibbVX1TVa3xf28+mmn7ZlJ2/NAp5ySfychtGGvGtDD1EYqef0v7AN5u3cS0Z5F
         7FbeZw9n4U2dCSl0XcxPjl4X/XjdTRg0pEikNj2pYL3hDycV7VCwm6wx3MKPZ9TvXUyS
         hj1mPyhEic8U7WQswzWRtMOvjmDAJQXoAQ0PhijMbyWhFo7S2s0DxdAQMGHDRRVsmX5l
         MCew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773525841; x=1774130641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rE6cISs8geIe6+6m5MJBJl+B8H3cnkAkxjeX8DjEF0g=;
        b=YDrXtgAzI/hquwpfJFrpdHbPDl7s5wbDNmXo15s/8kSmHBaAJJy7vL8MlyvDmR0XUn
         7B5vV4t3Yg2sXkkilQiqZmE5U5HGRNsjlTkIbPRNnK27nsPSEI8LnOMBD4/6vHNURvVG
         bgobRtaYj36hTvcOJXEkiUmPcRUK76V6lIRrWs5XZw8+hF8F3b7G2FBZp3DoQnHRxzWP
         8qGdKo8usi4t+6/5RkB8Vp5jspDJj0oirY7Ee8iAlOqYhRv271AL4fa2+zFA3Zv9JGAK
         nEUH9cI64+tTSUZfufru6sriqfcRn00PnYhxHXsI60ROa+7KFCIAWvn9DfUk7ySfS+e5
         mMlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773525841; x=1774130641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rE6cISs8geIe6+6m5MJBJl+B8H3cnkAkxjeX8DjEF0g=;
        b=d9Mjta/puOzRCrLcKs7Evif9ABGQrRdBQdkMOnGNQokvLE/GuLatj+JMQ96A3lupP0
         2j4eVks+/FEMUkfoccbDZs4Xk/oT4/ToLscjIXw124gLHVfAAWAGggqZUrltGbBU4wf/
         so6XNi5eJCgyDeCdh2obsXU1ehO08dR8f0EAEdJx3MZwY/juV6JPnj98kvgIEpEqY0HK
         W7r5gD3H4bUyAmInsSbjyVEX3lEBAHlOncSvpgEGQVtTVJw0NJDRuZZUWAXs526Sch91
         FFYxApJUQrM/RdLhmaZRtVrxmlMtcfltxHru0sVhVxcOQL18hyjuxZ2DG1/aRhYXb8G7
         P0FA==
X-Forwarded-Encrypted: i=1; AJvYcCXj1FljpshMiuPPx2N7BfGr5ORe9u7KpCxUMk95ENQfw431IG2SySnqAJZQREvIJRep3OxCBoYDN7S9@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkg2xmYn/FELFlH2PORAsLSY8SASk0cCTw7L9zrlf4yOQnJALC
	IltLTQNYFa6inuoh7NOkOltG1o6bicmh7bhWpqJxDR7yVvYjlCF4zdSRHG0aBnnR2lwX/2cfB08
	/iInOzru0fFyhaAXhGpAaAo/RGqF1Ti0=
X-Gm-Gg: ATEYQzwdwWNB8BP+jtiruRpuV8EzNj91u6PExtFGiAXD+dRw3n3vb/r4KXVzfnt412B
	ktDoaiG6QdWejFbGS4y3Dbq6EoyhafqJYzA5Zse27nVKsN7k3hjWDzofN97/Ooblu44YQSjsZOh
	UtKq3pZbiCtcYXLTwiE+nKN04UYoL/7hxDYGEvG856eyjvGJw4n+zD14OW1QmvyVumqgBG74V/k
	k8mQ9n55u5b9dIH1OARsjdwX4wFvkMOpoP5iGveZ9wUKro76BL2e7g8fbBnF0xkq0FD4o+nnqBk
	gfAqOMMLSEl4qWPEVgeVHSAg/xFPQcl3JYiut1YDne+PENzPthwHmzCVumZl1JJypMf6e3UZ+pR
	fmehUK1vvuvtWm4MqkOIZ4EA0e8nrnGzL8GP3W4zI8f3OVBpJmmvs4EPREqzD5Nhr
X-Received: by 2002:ad4:5743:0:b0:899:fc48:4e68 with SMTP id
 6a1803df08f44-89a81d44c63mr121103486d6.4.1773525840803; Sat, 14 Mar 2026
 15:04:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304124629.1616108-1-sprasad@microsoft.com>
 <u4s57pxvrttksfxe5evylucarfoyiv3ut32d45nvfafsgmxtog@72x2iew66wrt>
 <CANT5p=rdme19zW8Dk7WuEXw68Jzdt2QsdfK-gRManJJgGWQByw@mail.gmail.com>
 <54dzktjc3vwt55dfj6wi4346la2my4fsg7wfyrtwm2apzvppip@xbi6evlur3kz> <CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com>
In-Reply-To: <CANT5p=rqgRwaADB=b_PhJkqXjtfq3SFv41SSTXSVEHnuh871pA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Mar 2026 17:03:48 -0500
X-Gm-Features: AaiRm50wKC0fbjkPB-mPO361S1p_Y7lu5DO5wJdXm8vmIxkUKCxYLwxOG--Mo7c
Message-ID: <CAH2r5mu-3cDEhQWnBwBATq4hv4tw9aoPtGdmaDuc1+PxeiTuxA@mail.gmail.com>
Subject: Re: [PATCH] cifs: open files should not hold ref on superblock
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, linux-cifs@vger.kernel.org, 
	pc@manguebit.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 14, 2026 at 3:38=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Sat, Mar 14, 2026 at 1:47=E2=80=AFAM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > On Fri, Mar 13, 2026 at 10:57:42AM +0530, Shyam Prasad N wrote:
> > > On Fri, Mar 13, 2026 at 1:28=E2=80=AFAM Henrique Carvalho
> > > <henrique.carvalho@suse.com> wrote:
> > > >
> > > > On Wed, Mar 04, 2026 at 06:15:53PM +0530, nspmangalore@gmail.com wr=
ote:
> > > > > From: Shyam Prasad N <sprasad@microsoft.com>
> > > > >
> > > > > Today whenever we deal with a file, in addition to holding
> > > > > a reference on the dentry, we also get a reference on the
> > > > > superblock. This happens in two cases:
> > > > > 1. when a new cinode is allocated
> > > > > 2. when an oplock break is being processed
> > > > >
> > > > > The reasoning for holding the superblock ref was to make sure
> > > > > that when umount happens, if there are users of inodes and
> > > > > dentries, it does not try to clean them up and wait for the
> > > > > last ref to superblock to be dropped by last of such users.
> > > > >
> > > > > But the side effect of doing that is that umount silently drops
> > > > > a ref on the superblock and we could have deferred closes and
> > > > > lease breaks still holding these refs.
> > > > >
> > > > > Ideally, we should ensure that all of these users of inodes and
> > > > > dentries are cleaned up at the time of umount, which is what this
> > > > > code is doing.
> > > > >
> > > > > This code change allows these code paths to use a ref on the
> > > > > dentry (and hence the inode). That way, umount is
> > > > > ensured to clean up SMB client resources when it's the last
> > > > > ref on the superblock (For ex: when same objects are shared).
> > > > >
> > > > > The code change also moves the call to close all the files in
> > > > > deferred close list to the umount code path. It also waits for
> > > > > oplock_break workers to be flushed before calling
> > > > > kill_anon_super (which eventually frees up those objects).
> > > > >
> > > > > Fixes: 24261fc23db9 ("cifs: delay super block destruction until a=
ll cifsFileInfo objects are gone")
> > > > > Fixes: 705c79101ccf ("smb: client: fix use-after-free in cifs_opl=
ock_break")
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > > > > ---
> > > >
> > > > Hi Shyam,
> > > >
> > > > So the side effect of the previous code is that the umount hangs un=
til
> > > > all the files are closed?
> > >
> > > Hi Henrique
> > > Umount works. All it does is decrement refcount on sb.
> > > When the last file is closed (or when the last cifs_oplock_break
> > > processing completes) that's when cifs_kill_sb would get called.
> > > Before that if there's another mount of the same share, it will reuse
> > > the same session, tcon and open handles. As a result, an attempt to
> > > delete files on the mount point may fail (which is one of first thing=
s
> > > done by many xfstests).
> > >
> >
> > Thank you for the explanation.
> >
> > I will wait for your v2.
>
> Hi Steve,
>
> I ran generic/694 to understand why it is failing with this change.
> I think that this fix has just exposed a problem rather than caused it.
>
> The test does the following:
> 1. either fallocates a file to 4G or pwrites to it
> 2. calls sync
> 3. runs stat to get number of blocks allocated for the file
> 4. umounts the share
> 5. mounts the share again
> 6. runs stat to get number of blocks allocated for the file
> 7. compares output of steps 3 and 6

Any chance of creating a small repro script for this that is easier to
debug han the xfstest was?

> Without this change, both step 3 and 6 would return 0, since even
> through umount/mount, the same file would remain open (since
> superblocks will be shared).
> With this change, step 3 would return 0. Step 6 would return the right va=
lue.
>
> If you use nosharesock even after reverting this change, you'll see
> the test failing.
> Or even with this change if actimeo=3D0, then this test passes.
>
> The real question to ask is why aren't we updating i_blocks even after
> sync succeeds?
> My guess is that this has something to do with attribute caching when
> the handle is kept open.

That sounds an important bug to fix.  Glad this test showed it.



--=20
Thanks,

Steve
