Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD5273FD
	for <linux-cifs@vger.kernel.org>; Sun, 23 Mar 2025 10:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742726223; cv=none; b=JJrnt/zTsALu2MR5QGQsXQoqhDRaABeamf6yrgKZNVdUXOUbxOdbkvh5hZ62akMyf6uH34r8JgSMSpBtFohU9kNql4e8EioIKkA9cwQAiYOds5hayo7KUNA6wPUK5LxdT5MK41RuSSVmM4NivoFvBuYyJjyQygq9fjFFm480ank=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742726223; c=relaxed/simple;
	bh=WJBT75IGzmiLHUOA4Ub25T8k2lZDwaZL+M8gwOIYr/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7z4L+nS23qsanhHUmVv6otIrtR5kKZrrVzi3+XbGkfIVKDJn+qA83zHoNtCAjBQSW5V9q4x73koKH8IDmfYX86T5paMX5lPOYA2ZCOuI/CutoPhFkb1E84F+pjKFBSN0nTNrdDpCVhpynK1UDmwoRl7qEHzgS61408N3AHdgmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MouMm07/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MouMm07/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21CBC4CEE2;
	Sun, 23 Mar 2025 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742726223;
	bh=WJBT75IGzmiLHUOA4Ub25T8k2lZDwaZL+M8gwOIYr/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MouMm07/F1ipG+QOm1a4NRaeGjbjVo2EDOjYoGrch8wtd9IIpLoRT55yiXBYxTu1+
	 89zE2UNAb3PzbYtPztu43CZ92b36tkf6iAcY96TMKBmQXCYLT8OLO6IKcF6QhGxzHT
	 TU8L7qOyZ0vXz+myog+eMW6Srx0k4zAWqUsQbF4yhiLFw3Qs82o87Vfk+gbFbnQLI7
	 8WooANMJ5qQRUz+RHE463dGyhmoMv+Z5aMxQ2P2CMATbzSswbmC7O4+mwUaJHoI1sM
	 mlst0xx1evAqrHvv5YsHF8J0bXPLAiStOT44JhZiBKzcM6DPDuzgUd6X0HNVow0CCe
	 13X7S7Th750Yw==
Received: by pali.im (Postfix)
	id 15D1C7DE; Sun, 23 Mar 2025 11:36:48 +0100 (CET)
Date: Sun, 23 Mar 2025 11:36:47 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250323103647.rsex63eilfdziqaj@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali>
 <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
User-Agent: NeoMutt/20180716

Hello, I would like to ask, how you handled this regression? Have you
taken this my fix to address it? Or is it going to be addresses in other
way?

On Thursday 13 February 2025 12:52:50 Steve French wrote:
> This change to fs/smb/client/xattr.c is probably safe, and presumably
> could be removed in future kernels in a year or two as the updated
> cifs-utils which properly checks the error codes is rolled out
> broadly.
> 
> On Thu, Feb 13, 2025 at 12:42 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> > > Pali Rohár <pali@kernel.org> writes:
> > >
> > > > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> > > >> Steve,
> > > >>
> > > >> The commit 438e2116d7bd ("cifs: Change translation of
> > > >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
> > > >> expects -EIO to be returned from getxattr(2) when the client can't read
> > > >> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
> > > >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
> > > >> different problem, though.
> > > >>
> > > >> Reproduced against samba-4.22 server.
> > > >
> > > > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> > > > translate -EPERM to -EIO. This will ensure that getcifsacl will work as
> > > > before as it would still see -EIO error.
> > >
> > > Sounds good.
> >
> > Now I quickly prepared a fix, it is straightforward but I have not
> > tested it yet. Testing requires non-admin user which does not have
> > SeSecurityPrivilege privilege configured. Could you check if it is
> > fixing this problem?
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
