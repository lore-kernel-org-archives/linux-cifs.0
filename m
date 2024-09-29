Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964335680;
	Sun, 29 Sep 2024 00:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727571082; cv=none; b=D7mFGUzqPPTYD2/KDAy8RzoU93IdBaC5xDja+BrCQBFtiUp2kwhVcsC+4GKwOb6ByffiMNuECwcO+iOL8fK5yCPEUx+UYifVeMrMta2rgmPGl1Y7O5kDNohSNYn9d9qOZXtrGfglEq5zSfvhjzuwKU50Pch1ytQKShkXLc/483c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727571082; c=relaxed/simple;
	bh=pkexLRke1C+eYH00W2Deghk1jYJzAqkuP3XQ8PpT0sY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOl4Poy0HIqQMmEt/VVueDWtV/hdU4Ep2396FXi5sLP5HtW9JKJq6Ptt5OHv+5zciwLABoVzUfGHfz1xYksBvlgYC7skxvd2NxN43rUM4wEAbhha0m78P1csjBFWRSPcokoMWxbYYmdUc9o0JtcHgY1Vn5r7IXFCTw8jJMGotuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLKVWl7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLKVWl7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97D3C4CEC3;
	Sun, 29 Sep 2024 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727571082;
	bh=pkexLRke1C+eYH00W2Deghk1jYJzAqkuP3XQ8PpT0sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WLKVWl7HJ5QZSn3k214HKQ3Sn/vaij9MyOXWlpsXJMUE+vuoL/nMUCP/oeLsOfFPk
	 YimDKZbx8CXUScikofEij+CRGGgXBRI6cTyWIrbb5VIJY/nNVxeH7NQRqfmGarifif
	 WkNNxnHIb6y3VNtD6j8VM3ELRpBi/uBcZcHac+0pWyCWF4oagMnNJ/g0troFz2iqfL
	 vjUgXDZ/wDu7xufWikZ7ZeXVeGSdqzI5zMDkai+HW2brFi2/KFjuWZFW4vGIkipFCY
	 81QJBcxKHmPgID/VAMR3Xl/bXharj4+1t8UjB3W0aaSLOxN+lnvbbwovIuh/aQ9xSK
	 6aMF3pX8yupzg==
Received: by pali.im (Postfix)
	id A2469651; Sun, 29 Sep 2024 02:51:16 +0200 (CEST)
Date: Sun, 29 Sep 2024 02:51:16 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] cifs: Fix creating NFS-style char/block devices
Message-ID: <20240929005116.jojmzxymevmdyvsa@pali>
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-5-pali@kernel.org>
 <CAH2r5mvvNO4NjnBKd1R_wemJ34t=N+iL023c2Op+LPuYw3UcZw@mail.gmail.com>
 <20240929004439.4xgymuv3mnr3n4a3@pali>
 <CAH2r5mvbUhcW_c46oUiHzfPg97n5qiRg9kzpCkmzG9uHygOF3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvbUhcW_c46oUiHzfPg97n5qiRg9kzpCkmzG9uHygOF3g@mail.gmail.com>
User-Agent: NeoMutt/20180716

I guess that patch 3 can be dropped too as Paulo fixed it recently in:
https://git.samba.org/sfrench/?p=sfrench/cifs-2.6.git;a=commit;h=663f295e35594f4c2584fc68c28546b747b637cd

On Saturday 28 September 2024 19:47:52 Steve French wrote:
> Patch 3 may need to be rebased, iirc patch 3 didn't merge but 1 and 2 did
> 
> On Sat, Sep 28, 2024, 7:44 PM Pali Rohár <pali@kernel.org> wrote:
> 
> > Ops, sorry for that. I just let my work branch on v6.11-rc7 and here
> > this change was not yet. But it is funny that we have hit this problem
> > independently in nearly same time.
> >
> > On Saturday 28 September 2024 19:18:26 Steve French wrote:
> > > Looks like a duplicate of Paulo's earlier already merged patch, so
> > > will skip this one.  Reviewing the others in the series now.
> > >
> > > commit a9de67336a4aa3ff2e706ba023fb5f7ff681a954
> > > Author: Paulo Alcantara <pc@manguebit.com>
> > > Date:   Wed Sep 18 21:53:35 2024 -0300
> > >
> > >     smb: client: set correct device number on nfs reparse points
> > >
> > >     Fix major and minor numbers set on special files created with NFS
> > >     reparse points.
> > >
> > > On Sat, Sep 28, 2024 at 5:02 PM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > Linux SMB client currently creates NFS-style char and block devices
> > with
> > > > swapped major and minor numbers.
> > > >
> > > > Per MS-FSCC 2.1.2.6 NFS_SPECFILE_CHR and NFS_SPECFILE_BLK DataBuffer's
> > > > field contains two 32-bit integers that represent major and minor
> > device
> > > > numbers.
> > > >
> > > > So the first one 32-bit integer in DataBuffer is major number and
> > second
> > > > one in DataBuffer is minor number. Microsoft Windows NFS server reads
> > them
> > > > in this order too.
> > > >
> > > > But Linux CIFS client creates new reparse point DataBuffer with minor
> > > > number first and major number second.
> > > >
> > > > Fix this problem in Linux SMB client and puts major and minor number in
> > > > the correct order into DataBuffer.
> > > >
> > > > This change fixes interoperability of char and block devices on Windows
> > > > share which is exported over both SMB and NFS protocols.
> > > >
> > > > Fixes: 102466f303ff ("smb: client: allow creating special files via
> > reparse points")
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > ---
> > > >  fs/smb/client/reparse.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > > index 48c27581ec51..63984796721a 100644
> > > > --- a/fs/smb/client/reparse.c
> > > > +++ b/fs/smb/client/reparse.c
> > > > @@ -108,8 +108,8 @@ static int nfs_set_reparse_buf(struct
> > reparse_posix_data *buf,
> > > >         buf->InodeType = cpu_to_le64(type);
> > > >         buf->ReparseDataLength = cpu_to_le16(len + dlen -
> > > >                                              sizeof(struct
> > reparse_data_buffer));
> > > > -       *(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MAJOR(dev) <<
> > 32) |
> > > > -                                                MINOR(dev));
> > > > +       *(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MINOR(dev) <<
> > 32) |
> > > > +                                                MAJOR(dev));
> > > >         iov->iov_base = buf;
> > > >         iov->iov_len = len + dlen;
> > > >         return 0;
> > > > --
> > > > 2.20.1
> > > >
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
