Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AF052F9B;
	Mon, 28 Oct 2024 10:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730111667; cv=none; b=bN30OcL0fNqx3MesEwMTMwMwbxtgITZ1DTBydfBQZHnr8ilAqb7fdOGtYryQ7f4aZlqI7k463HlnwcJM1nKbJTRriINsYCRvWadhbuDKyP5FIoIDwfSJ97FlPkSaiYTuQpeON5vhzaafjC48wgxADVaGaWec9/TF1U9Ava7goEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730111667; c=relaxed/simple;
	bh=BMDEFuQeVZEJg877mQ38DYoOmNx83cPp9N8RmPmkZFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=metrGbzBE7lNPNQlBWZBj0rcf4VdiPW7uQk87mrJG+q1ryKaGJLrs/iydovk267qFD6Gamhxw7VjQOva6Cvl56ovBkW98iSZDmzro7p3cAOuydgcxhDKQ9IaQoQaR0KUS4AdZZGuvh+dznVCBqj8PFSzzLyE+xLmSpeqmQLh3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l91Da8yH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l91Da8yH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD6AC4CEE3;
	Mon, 28 Oct 2024 10:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730111667;
	bh=BMDEFuQeVZEJg877mQ38DYoOmNx83cPp9N8RmPmkZFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l91Da8yHs/i7GCujEIGzJRNG4FL6DGQEZXXHd5EiRtQB5lI6cjy3A1XXEM0zLUd/u
	 KPI6TWe8QO91T2LXs0fEpkC/B10rd4pFkoVkh3xkWtw5G0dNa4dc7Jgk0WbARtdMr3
	 GD+63qAI6uBWKdENbf2xuLZ5JVxFo/zuZULqpLwC7gB2xqj0u4/ikFZ9qk3lAPzYjv
	 vGPWwWR3u9LvhvrHuRhXznBMVm6SsLIJYBTKBUxk6jL4mkPzVd1mlplzdvBSlAD2Ll
	 QKhpHn/2jf0N+J957m7yDH8Li6Y5V/FSujGjtY9PN7j6WxxeonfnrjMCWQcmdAxBKw
	 6YYXtiVPSSlDw==
Received: by pali.im (Postfix)
	id 92F15A58; Mon, 28 Oct 2024 11:34:19 +0100 (CET)
Date: Mon, 28 Oct 2024 11:34:19 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] cifs: Improve access without FILE_READ_ATTRIBUTES
 permission
Message-ID: <20241028103419.3whzfyrdvkvu5tpy@pali>
References: <20241005160826.20825-1-pali@kernel.org>
 <CAH2r5mtvp74nnU7ueqiyVrNLurM3ubQmBSTP=HcFqti=ZsWaNQ@mail.gmail.com>
 <20241005184453.rdxetlsoszxzfqnt@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241005184453.rdxetlsoszxzfqnt@pali>
User-Agent: NeoMutt/20180716

On Saturday 05 October 2024 20:44:53 Pali Rohár wrote:
> On Saturday 05 October 2024 13:32:12 Steve French wrote:
> > The obvious question to check is whether this would lead to any issues
> > if desired_access is not passed in in oparms in any cases (ie if it
> > ends up 0),
> 
> This is good point. IIRC if zero value is in OPEN/CREATE desired_access
> request then SMB server returns STATUS_ACCESS_DENIED.
> 
> So it needs to be checked that desired_access is filled in all usage
> correctly.

I have done checks and seems that all callers put some non-zero desired
access to smb2_open_file() call. So I think this should not be an issue.

> > and also that this would not hurt any cases where we want
> > to keep the handle cached (deferred close) but don't have sufficient
> > permission for it to be usable by the subsequent operation (e.g.
> > revalidate or stat)
> 
> I see, so the code needs to be properly checked or tested that all these
> conditions are handled.

It looks like that when rdwr_for_fscache is used then proper read/write
desired access is asked.

During testing I have not spotted issues.

Also to note, I checked SMB1 code and it already does not automatically
add FILE_READ_ATTRIBUTES to desired access during open.

Could you schedule this change for some testing?

> > On Sat, Oct 5, 2024 at 11:10 AM Pali Rohár <pali@kernel.org> wrote:
> > >
> > > Linux SMB client currently is not able to access files for which do not
> > > have FILE_READ_ATTRIBUTES permission.
> > >
> > > For example it is not able to write data into file on SMB server to
> > > which has only write access (no read or read attributes access). And
> > > applications are not able to get result of stat() syscall on such file.
> > >
> > > Test case against Windows SMB server:
> > >
> > > 1) On SMB server prepare file with only GENERIC_WRITE access for Everyone:
> > >    ACL:S-1-1-0:ALLOWED/0x0/0x40000000
> > >
> > > 2) On SMB server remove all access for file's parent directory
> > >
> > > 3) Mount share by Linux SMB client and try to append data to that file:
> > >    echo test >> /mnt/share/dir/file
> > >
> > > 4) Try to call: stat /mnt/share/dir/file
> > >
> > > Without this change the write test fails because Linux SMB client is trying
> > > to open SMB path "\dir\file" with GENERIC_WRITE|FILE_READ_ATTRIBUTES. With
> > > this change the test pass as Linux SMB client is not opening file with
> > > FILE_READ_ATTRIBUTES access anymore.
> > >
> > > Similarly without this change the stat test always fails as Linux SMB
> > > client is trying to read attributes via SMB2_OP_QUERY_INFO. With this
> > > change, if SMB2_OP_QUERY_INFO fails then Linux SMB client fallbacks for
> > > reading stat attributes via OPEN with MAXIMUM_ALLOWED access (which will
> > > pass if there is some permission) and OPEN reply will contain attributes
> > > required for stat().
> > >
> > > Pali Rohár (2):
> > >   cifs: Do not issue SMB2 CREATE always with FILE_READ_ATTRIBUTES
> > >   cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES
> > >
> > >  fs/smb/client/cifspdu.h   |  1 +
> > >  fs/smb/client/smb2file.c  |  1 -
> > >  fs/smb/client/smb2glob.h  |  1 +
> > >  fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
> > >  4 files changed, 72 insertions(+), 2 deletions(-)
> > >
> > > --
> > > 2.20.1
> > >
> > >
> > 
> > 
> > -- 
> > Thanks,
> > 
> > Steve
