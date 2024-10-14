Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6C314B96E
	for <linux-cifs@vger.kernel.org>; Mon, 14 Oct 2024 09:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728899360; cv=none; b=VCbpQ/t4C2h61/AHCXsLpIhKnHrbA4PqofnyZqGdoy343WYg8ItQpy2xLv7oU6As9TmX0QGe8tLrByKL950sIfnOy557JBoN/NdKdxSvrKYbUgiAiGPbgp5te2xY/rUYM+N6zcqS61JmxZCxpEcd7shvKrfokuentJVuoyFQ6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728899360; c=relaxed/simple;
	bh=Y/kjs4eKBdGS32QVos+h9QML531Jx4oiWhj0cBZSX1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0DqnYQ20WF9vge6TOAuVv5v7LtTvd7AIB9RtcPObv9tGt5nPiaShuqbrS5A1y873u0PEoPqDntVLulpFQoT+nCFPJ3BZi7UWybBy+nsijHDd1CP4dGsMMj7NEen0qu3bsbqDHXb3t7fjAf49El8PyeL99cFO/RR8xEnge12+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsF9fqUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsF9fqUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFADDC4CEC3;
	Mon, 14 Oct 2024 09:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728899360;
	bh=Y/kjs4eKBdGS32QVos+h9QML531Jx4oiWhj0cBZSX1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XsF9fqUTUzwcE6YDlh1zGH6urjlsflrnf7Jfst3QEC4y1m7eplNtALhVK4kD5Xp+n
	 6xl4TAS/7BJ7Pi8WY0tkNHd4XTk1lFvH9af3/deJA0FtC+V4MTEzjhzQqYsFcQjHT/
	 3GWnzRNh/aoqFYe1GztLZZ5KAWYojhzHy5WE0qnLf1dYUwJkd+YGid4hN4r/O+vjx7
	 Ef3DqxtdXP7GcrOGuYpRfrDTvYi0bFz+RWMG95iBwU4vkUWq4km4BVXkDjDnqP/Gee
	 WFkwJbBRhufNwIV8XrrbBvn3OzzumZQyDlER1WgSNpl+v5sA8lD9jB4mykQxC5DGVE
	 tr6+m+OELenpQ==
Received: by pali.im (Postfix)
	id 959B69DA; Mon, 14 Oct 2024 11:49:13 +0200 (CEST)
Date: Mon, 14 Oct 2024 11:49:13 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241014094913.nyaltrl2t7vjhcuw@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
 <20241008181827.cgytk5sssatv6gvl@pali>
 <CAH2r5mvUjZdDo2gEZ-PSrP5cYT7q25yT7-J1RcaaLxGh-h7Eaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvUjZdDo2gEZ-PSrP5cYT7q25yT7-J1RcaaLxGh-h7Eaw@mail.gmail.com>
User-Agent: NeoMutt/20180716

I checked it and seems that both Windows SMB client and Windows SMB
server on Windows Server 2022 filter out this class 64.

Windows SMB client does not send request to server at all and
immediately return error to application which tried to use class 64. And
Windows SMB server returns STATUS_NOT_IMPLEMENTED, which indicates that
server recognized it, but filtered it. Older Windows servers returns
STATUS_INVALID_INFO_CLASS which indicates that they did not understand
class 64 at all.

So seems that against Windows SMB implementation, this class 64 is
unusable for now.


Anyway, can somebody ask in Microsoft if they can allow to use
class 64 (FileDispositionInformationEx) and class 65
(FileRenameInformationEx) in their SMB client and server?
This would really help with Linux/POSIX interop, which Windows already
provided for local filesystems.

Steve, are you able to ask somebody in Microsoft for this?

On Wednesday 09 October 2024 00:03:03 Steve French wrote:
> FILE_DISPOSITION_DO_NOT_DELETE  0x00000000 Specifies the system should
> not delete a file.
> FILE_DISPOSITION_DELETE  0x00000001 Specifies the system should delete a file.
> FILE_DISPOSITION_POSIX_SEMANTICS  0x00000002 Specifies the system
> should perform a POSIX-style delete.
> FILE_DISPOSITION_FORCE_IMAGE_SECTION_CHECK  0x00000004 Specifies the
> system should force an image section check.
> FILE_DISPOSITION_ON_CLOSE  0x00000008Specifies if the system sets or
> clears the on-close state.
> FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE  0x00000010 Allows
> read-only files to be deleted.
> 
> These are interesting flags, but are we certain they are passed
> through over SMB3.1.1 by current Windows?  It is possible that they
> are filtered and thus local only
> 
> Have you tried setting them remotely over an SMB3.1.1 mount to Windows server?
> 
> On Tue, Oct 8, 2024 at 1:18 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Tuesday 08 October 2024 11:40:06 Ralph Boehme wrote:
> > > On 10/6/24 12:31 PM, Pali Rohár wrote:
> > > > But starting with Windows 10, version 1709, there is support also
> > > > for UNLINK operation, via class 64 (FileDispositionInformationEx)
> > > > [1] where is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does
> > > > UNLINK after CLOSE and let file content usable for all other
> > > > processes. Internally Windows NT kernel moves this file on NTFS from
> > > > its directory into some hidden are. Which is de-facto same as what
> > > > is POSIX unlink. There is also class 65 (FileRenameInformationEx)
> > > > which is allows to issue POSIX rename (unlink the target if it
> > > > exists).
> > >
> > > interesting. Thanks for pointing these out!
> > >
> > > > What do you think about using & implementing this functionality for
> > > > the Linux unlink operation? As the class numbers are already
> > > > reserved and documented, I think that it could make sense to use
> > > > them also over SMB on POSIX systems.
> > >
> > > for SMB3 POSIX this will be the behaviour on POSIX handles so we don't
> > > need an on the wire change. This is part of what will become POSIX-FSA.
> > >
> > > > Also there is another flag
> > > > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE which can be useful for
> > > > unlink. It allows to unlink also file which has read-only attribute
> > > > set. So no need to do that racy (unset-readonly, set-delete-pending,
> > > > set-read-only) compound on files with more file hardlinks.
> > > >
> > > > I think that this is something which SMB3 POSIX extensions can use
> > > > and do not have to invent new extensions for the same functionality.
> > >
> > > same here (taking note to remember to add this to the POSIX-FSA and
> > > check Samba behaviour).
> > >
> > > -slow
> >
> > So the behavior when the POSIX extension is active would be same as if
> > every DELETE_ON_CLOSE and every DELETE_PENDING=true requests would set
> > those new NT flags FILE_DISPOSITION_POSIX_SEMANTICS and
> > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE?
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
