Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30A837F730
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 20:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778704459; cv=pass; b=JIxtvTiYopBV6MLIpsOPe8fCLk2DCALa/+E5fwlNDd4pal0hkJxkzy5DxsiaPNkNY5KsoS9wuUQkhBX+H34XzkS3uOcyb6PQVyD9ldbtCKXRFB30R87AvlgtVacf7E6Y7AeVRtkuEzEL6ogfgG5oLQhnYUV5a9ISCNJaexGOsXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778704459; c=relaxed/simple;
	bh=QqaIYA8X3X6Tew9rng99hk3rmPCslU/eWwD53qMGzFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tNr4DYxFp4tSustnu5y0G4SGbg3XUWc9w477Yl21Nbu40TemVmUbvyw5JuZAgFb0uQeFiqHpEqwff+VvZPQloyewoBitk0lAahzxpfpcK9ZrR0PojJ2jTHjWY9J6oyXttewIllWd0iYYUxbrDjGpsec5L06frNu6mbAtLPpwI0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dA0o70yO; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dA0o70yO"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899d6b7b073so68958046d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 13:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778704458; cv=none;
        d=google.com; s=arc-20240605;
        b=bDz0Czmd/Gsj1Xkz67eFO71eqpNEltyk+AXplJPfc7I7jb+6R6kzjwM46GhhDUOtRc
         Rup8dbaFv/ZHvN8zx/oXax/M/1aY2jrglPlPvINxJHnomspSADS8GfCh2n52tKZy1SgC
         Xmac+xV8CuS4RSwa22bRNQHpjpbPrLnzgKdbDhu+/T/eV2FzzV25ncQ78cRsfpZHX1Ed
         AZqWrB2Vmk1w+voIxjxZomJPGhdvrdT7Pkomp5tWBx96uAGHx8PPrWg1FBBoBsLx5FbM
         zNt7M1Pl2Dqm6+Gmva3F0QsKLXTpnRx+oNBFgPIelHwTu9xbvE8TOI6A6Wv4rypvgfHQ
         QEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        fh=kcYBUwUU8xedVL1vycU9AfXXDdCi3uYFO2jjxZm+HsQ=;
        b=Kay3njjb6KUpWJz6oB8WHqgVb+1imomWraiSChcprIzvJl6FaO0m/BNTjm9tm/ng/0
         dSvu9XzYqI7u77D1pGGWwvkxZFGUkWG+bHPb7hYfP82jEIPRCxjnxqiofzJEHsxoiWV6
         cqd6jo10gehonUMjF8KT1G409+4TC80n4oypmYsWYmZRs3hEmDMCPTuwe1xjTdcxJVXA
         Lr2bIukLBu6hJK408ZL2WToLOP4R6s/Rd4OxrE/t1OpsvPldCGMWO4DmOz4CYRicDWEt
         ObOQQgJe3wyHub5AczOuC2ZlCUaJRekk86QzyRSO2q8/+2z8tZWqYliEEaM1RuoNeau9
         UQag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778704458; x=1779309258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        b=dA0o70yO7x4XwWWzvpEDS26Z5CVMlZwZDEUfTWLEvVaRK4yzTpoqigWYN4u6jKPFH5
         8z8f+pL1kPXsvJQup6+k6ayL5HyyWGKZ5FmG0HC8DU5WhKVzewxnimgfTmczVTR33kxL
         7HOMI1YdZRtuDbT6KswjYpni0ay1fseof5Jq9CCquIxECDlpWcwYDPPuSRq8dpJ9nL3v
         qmW/dHE623XRBbSV8kH549exrt6lA/xL+bwbx11EmxuMjzRgSC93NgbnD2Mc0G376f3/
         YD15hJLWJPdHNTRgf8OKlmHgKn4KpOgujlyJdbjHi+5b/mFfIaYpfxHRBBP80nN7+tVO
         qkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778704458; x=1779309258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YffvRc4ueiaHAv5vxRd/K/yTD1qBPNZn3LhENW3N4xg=;
        b=OMAxaBRmp0Nec76Anfjvyj32H/ng/K1F0wSMkyT6Iv56InJ673Oxn9g1Quq1zhlPQG
         ocTmMzQWypfzQ7aSsUNCOaaPTD4c1ayY+qQXncWbLPA2/fJAZ5IaHDh8oKW+v307//dz
         /eWBXHhxrTS0huiSPye6pEZGHrOW21TvPNoNE4ffj1ZtIMQSvk9zqpcHThSN/TZcVr//
         wSslOrA0biqqy7XmxIF3/L6AZfzNO4jrb2GVHVBiop/KSd4fquOwygdTAOZnrbMm4qKq
         fpCtCmcIfRYTLyqqspGmREMJIIOKIN0neXHsO/P8htQoCrnemYfFPGIzenfsulKw1DID
         DOGA==
X-Forwarded-Encrypted: i=1; AFNElJ9umwZIYWkCUu0sxa5PH2vUoAWbdvHByNoXBsHkperxuUch3saHY/V7U03D/h9O6VSN3OC6zX0A5WXF@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/QlSvlJFjjieEuUYvxPI8LTVMDVy+D70nRxpFY6umA2jehVBr
	tmSr227COyWXRBQ/HYIqzTkCd6fuDQV2DaKwcne/tlEjrNvUeEdbgkDdngdgne3v5DzGzdbkex+
	U0tZYptbx8WxCBanM8Og7JTXQ41O2UjY=
X-Gm-Gg: Acq92OHGlhgB/qSyFH1p7C27esgPRdkznl2pD/vwYAJti0jNJ3/gLg9ZWW65w63SGd7
	0q4FWpBW0JBgde6XdyUkFYOb/ttOca8l2xTGNFGVEe30t02/IqnaUcvVWEWYMoe30qd831GnUDQ
	YSlzEbakwRsnTNmHBmr65E6aAYAVAjit1MHWd34zXPPsjJyzwffk0JcnhJi7sMP7wGMPmzCj299
	Ego7LwDbfibjiRpgS68GI/XcAPEWwEVAzFtMJMQ7ZnHZLkzYoCRbxsJhJDHyHWLtngtIPFuD76c
	RN9bPNbGItTiobkegvd7ix3OeviClF0xYCkDoxMD9i55qKVwywnToNBag0wiKm4sfcNCdKpUk5g
	MArK5PwbfrlbXk8MA6fedqwxfhbpThtd4qNtG2mpyWnvUIjGXr1C0Ieegu+tMxQQVpvhfaMZFjE
	4n1OyYw0c+iOcAPO8ag2v/LQ==
X-Received: by 2002:a05:6214:8009:b0:8a0:846e:8850 with SMTP id
 6a1803df08f44-8c7b9d6a34dmr79395336d6.20.1778704455206; Wed, 13 May 2026
 13:34:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de>
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 May 2026 15:34:03 -0500
X-Gm-Features: AVHnY4LdSaGvyovg6RvG5pKhPWnEZkoZnNgrzQdw3V-htIBym1ah9EOHikjxM8Q
Message-ID: <CAH2r5msnYVb3hhXHwqDVHGGC1h4E6mLCRS4ktCrQoD9zdUW81g@mail.gmail.com>
Subject: Re: improve the swap_activate interface
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I just tried this on 7.1-rc3 with the swap patches (full kernel build,
on Ubuntu 25,10) and boot failed with out of memory which I had never
seen before.  Any idea how to workaround this with the swap patch
series, or is there a fix for this in the swap series already?

On Tue, May 12, 2026 at 12:41=E2=80=AFAM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> Darrick recently posted iomap support for fuse-iomap, which was trivial
> but a bit ugly, which triggered me into looking how this could be done
> in a cleaner way.  The result of that is this fairly big series that
> reworks how the MM code calls into the file system to activate swap
> files to make it much cleaner and easier to use.
>
> I've tested this with swap devices manually, and using the swap tests
> in xfstests on btrfs, ext3, ext4, f2fs and xfs to exercise the different
> implementation.  Out of those all passed, but f2fs actually notruns all
> tests even in the baseline as it requires special preparation for
> swapfiles which never got wired up in xfstests.
>
> Diffstat:
>  Documentation/filesystems/iomap/operations.rst |    3
>  Documentation/filesystems/locking.rst          |   35 +--
>  Documentation/filesystems/vfs.rst              |   40 ++--
>  block/fops.c                                   |   15 +
>  fs/btrfs/btrfs_inode.h                         |    3
>  fs/btrfs/file.c                                |    4
>  fs/btrfs/inode.c                               |   72 -------
>  fs/ext4/file.c                                 |    6
>  fs/ext4/inode.c                                |   11 -
>  fs/f2fs/data.c                                 |   50 -----
>  fs/f2fs/f2fs.h                                 |    2
>  fs/f2fs/file.c                                 |    4
>  fs/iomap/swapfile.c                            |  165 +++---------------
>  fs/nfs/direct.c                                |    1
>  fs/nfs/file.c                                  |   21 --
>  fs/nfs/nfs4file.c                              |    3
>  fs/ntfs/aops.c                                 |    8
>  fs/ntfs/file.c                                 |    6
>  fs/smb/client/cifsfs.c                         |   18 +
>  fs/smb/client/cifsfs.h                         |    3
>  fs/smb/client/file.c                           |   16 -
>  fs/xfs/xfs_aops.c                              |   48 -----
>  fs/xfs/xfs_file.c                              |   39 ++++
>  fs/zonefs/file.c                               |   30 +--
>  include/linux/fs.h                             |   11 -
>  include/linux/iomap.h                          |    5
>  include/linux/nfs_fs.h                         |    3
>  include/linux/swap.h                           |  129 +-------------
>  mm/page_io.c                                   |   45 ----
>  mm/swap.h                                      |   92 ++++++++++
>  mm/swapfile.c                                  |  227 ++++++++++++++----=
-------
>  31 files changed, 471 insertions(+), 644 deletions(-)
>


--=20
Thanks,

Steve
