Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301F386426;
	Fri, 16 Oct 2026 14:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792162297; cv=none; b=BFt+5mAuFiNG5orwMon8vjgzYiUGDFqVQnKDwY/HsBwvw/yDa7/um4c12JaA8usZthGoaxPRKTfJONkjcRgxIx17fR5qymOlEXF2lvPk5dF8GSdQSbjOUxdRKhaOplkxysV5xwM7/hFmLxb25wAyXOV/5Cuu0ytXK3+VXnthbBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792162297; c=relaxed/simple;
	bh=Ems59G3BFGK+I1lmNDzZemrTVec3h4lqpC5IkM5QqFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eg3Rf/Rk90EMzRIK8lCmNs7kFRX0Q2RCQEain1kMjoXzKHqYnwv0q40XyliETO59dQHT0ntRgIg/j+7cfiK6d5C484lAvcxJBf2gZ5gL/GDhACPvd3lKyNnqAz1ViMhMv0Pmurd5Bjl25R2prmTkWhTekjJqyG0ehgCjwBINk2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2zbQLfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2zbQLfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750321F000C4;
	Fri, 16 Oct 2026 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792162296;
	bh=TyPaUzFOJSmNGcKiNKdDNUdNEou4J2E/ZpziikI46rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b2zbQLfB9fdLwxkUGC2UcXcS3Wlwaok5SKznedF1O0ipjc22ki4x/L+Yy9ZRqtxzR
	 PjY4O/fQM92C36FP3WrKfiERPknk2GHeukrUdf9J0MiTcTSB56VuyM3iQ7V5cDhriw
	 F8Q3FRLSqFlGhDzX8sZ8OWORaM5MGFFkrj408ipQ=
Date: Fri, 16 Oct 2026 16:51:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Paul Aurich <paul@darkrain42.org>, linux-cifs@vger.kernel.org,
	stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Sasha Levin <sashal@kernel.org>, regressions@lists.linux.dev
Subject: Re: [REGRESSION] smb: client: batch SRV_COPYCHUNK entries to cut
 round trips - 6.12.y EIO above 12 MiB with SMB3 encryption
Message-ID: <2026101633-evaluate-jurist-020f@gregkh>
References: <atEn9dyqsyI3SNaP@redcloak.home.arpa>
 <441cd931c56cb539eb099bf6d976cc59@manguebit.org>
 <atFFiAr9gbs9jXZA@redcloak.home.arpa>
 <437553f9978afec2dc14363fdfedab5f@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <437553f9978afec2dc14363fdfedab5f@manguebit.org>

On Fri, Oct 16, 2026 at 11:08:20AM -0300, Paulo Alcantara wrote:
> Paul Aurich <paul@darkrain42.org> writes:
> 
> > On 2026-10-15 16:54:29 -0300, Paulo Alcantara wrote:
> >>Thanks for the report.
> >>
> >>Paul Aurich <paul@darkrain42.org> writes:
> >>
> >>> In stable 6.12.y releases, a copy_file_range request exceeding 12 MiB on an
> >>> encrypted SMB3 mount fails with EIO and a WARN_ON_ONCE() splat in
> >>> SMB2_ioctl_init:
> >>>
> >>>      # cp /mnt/otters/13mib.bin /mnt/otters/output.bin
> >>>      cp: error copying '/mnt/otters/13mib.bin' to '/mnt/otters/output.bin':
> >>>      Input/output error
> >>>
> >>> Works in 6.12.110.  Fails in 6.12.111 through 6.12.113 (latest).  Via
> >>> bisection, introduced by 8d103b285359 ("smb: client: batch SRV_COPYCHUNK
> >>> entries to cut round trips").
> >>
> >>Does it work if you backport the other 3 missing commits?
> >
> > Yes.  With v6.12.113 + bc925c1216f0 + 9f544d26b15b + 90f7c100d2dd, 'cp' and 
> > the Python reproducer work.  (Tested with both a 13 MiB file and a 250 MiB 
> > file)
> 
> Thanks for testing it!
> 
> Greg,
> 
> Could you please backport the following to v6.12.y
> 
> 	bc925c1216f0 ("smb: client: improve compound padding in encryption")
> 	9f544d26b15b ("smb: client: get rid of bounds check in SMB2_ioctl_init()")
> 	90f7c100d2dd ("smb: client: fix compound alignment with encryption")

Now queued up, thanks.

greg k-h
