Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5E815E5BB;
	Sat,  5 Oct 2024 18:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153899; cv=none; b=nZIvqmwonT2lx7oltxMO18QNhdoBDLj+xlacsqTzoDjjzhmSNULTBc9gDr8LfmXBua6EBNHXyXFitaS88vtBsN6+MUP0h3Poz5Nu6KC5Y8NK9s7UPgsNjhip5uAxOeK1oAN/xL8Yy2qe/E+o0nOMztlsTBBlMzp/dS27RB+A5mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153899; c=relaxed/simple;
	bh=O08h0MQkQkfaEZE7snAM38xE8jLrilzjQ8oxK/yHxsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5U83D93hlY5pWFbDBvKL8WFYIwuCRVL5DXAutL9eUtrQNlNbW7iKnZ1dQlbu0KgF331Y1BEJZ8G6cCDqlhbjGmetKAmbXaBRdbsslWLUtL/neRMehCdslcf9mZMQ0k2RT1aX9rjPeUZq8NO83GD8BXISgUX/fqBRq3FPvFVq6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0NJt6n9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0NJt6n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B401C4CEC2;
	Sat,  5 Oct 2024 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728153899;
	bh=O08h0MQkQkfaEZE7snAM38xE8jLrilzjQ8oxK/yHxsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0NJt6n93NUVGykU6lMKRzqSFKFD+aQIJK95/CSP3P8blFqO6GzY5zTG76iRwf29Z
	 naJ6hs6I6UKATwDYHFseji21QTDMI3y68sY0LWQloYf3u2m94eGj02mfnEbLmGScox
	 y5Qcov1BwazV1arMbDtL/c/yxqWvXzqwESxAUMI/JCaOid+Z5QW8Hu3WqlEnQfCGOK
	 Fsf/hV98sfHI1JROJMz+0vobX9oIy2T5qLdtyz4GBJfmjc/3DQr/qy+M0a/OmdR5tP
	 +iVBgHNT+waWoy+D9dnI3kSqmE1WqpSG8Z5c6M/H/8dcANlA901XCwJ3MEVGxqGXjw
	 4c5X9VHzY3Gag==
Received: by pali.im (Postfix)
	id 2AE5D648; Sat,  5 Oct 2024 20:44:53 +0200 (CEST)
Date: Sat, 5 Oct 2024 20:44:53 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] cifs: Improve access without FILE_READ_ATTRIBUTES
 permission
Message-ID: <20241005184453.rdxetlsoszxzfqnt@pali>
References: <20241005160826.20825-1-pali@kernel.org>
 <CAH2r5mtvp74nnU7ueqiyVrNLurM3ubQmBSTP=HcFqti=ZsWaNQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtvp74nnU7ueqiyVrNLurM3ubQmBSTP=HcFqti=ZsWaNQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Saturday 05 October 2024 13:32:12 Steve French wrote:
> The obvious question to check is whether this would lead to any issues
> if desired_access is not passed in in oparms in any cases (ie if it
> ends up 0),

This is good point. IIRC if zero value is in OPEN/CREATE desired_access
request then SMB server returns STATUS_ACCESS_DENIED.

So it needs to be checked that desired_access is filled in all usage
correctly.

> and also that this would not hurt any cases where we want
> to keep the handle cached (deferred close) but don't have sufficient
> permission for it to be usable by the subsequent operation (e.g.
> revalidate or stat)

I see, so the code needs to be properly checked or tested that all these
conditions are handled.

> On Sat, Oct 5, 2024 at 11:10 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > Linux SMB client currently is not able to access files for which do not
> > have FILE_READ_ATTRIBUTES permission.
> >
> > For example it is not able to write data into file on SMB server to
> > which has only write access (no read or read attributes access). And
> > applications are not able to get result of stat() syscall on such file.
> >
> > Test case against Windows SMB server:
> >
> > 1) On SMB server prepare file with only GENERIC_WRITE access for Everyone:
> >    ACL:S-1-1-0:ALLOWED/0x0/0x40000000
> >
> > 2) On SMB server remove all access for file's parent directory
> >
> > 3) Mount share by Linux SMB client and try to append data to that file:
> >    echo test >> /mnt/share/dir/file
> >
> > 4) Try to call: stat /mnt/share/dir/file
> >
> > Without this change the write test fails because Linux SMB client is trying
> > to open SMB path "\dir\file" with GENERIC_WRITE|FILE_READ_ATTRIBUTES. With
> > this change the test pass as Linux SMB client is not opening file with
> > FILE_READ_ATTRIBUTES access anymore.
> >
> > Similarly without this change the stat test always fails as Linux SMB
> > client is trying to read attributes via SMB2_OP_QUERY_INFO. With this
> > change, if SMB2_OP_QUERY_INFO fails then Linux SMB client fallbacks for
> > reading stat attributes via OPEN with MAXIMUM_ALLOWED access (which will
> > pass if there is some permission) and OPEN reply will contain attributes
> > required for stat().
> >
> > Pali Rohár (2):
> >   cifs: Do not issue SMB2 CREATE always with FILE_READ_ATTRIBUTES
> >   cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES
> >
> >  fs/smb/client/cifspdu.h   |  1 +
> >  fs/smb/client/smb2file.c  |  1 -
> >  fs/smb/client/smb2glob.h  |  1 +
> >  fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
> >  4 files changed, 72 insertions(+), 2 deletions(-)
> >
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
