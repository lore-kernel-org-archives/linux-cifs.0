Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82211DD525
	for <linux-cifs@vger.kernel.org>; Fri, 27 Dec 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735315145; cv=none; b=cXaDc3G8z4RscJeUtkm1RpVIkTLg2NLRwSUtr3VaYtuLrk5e4DhUMVl1bhW+KJRepu0DIjKhsNSTw6lwq4N29TQ/Tr+kijP0+TKJE6kJmh5yoVWkrlymfCDrZKdE7H94gayc1zoUkQeDiOFJqNiujCHLlB517wDohwCGhhC+D2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735315145; c=relaxed/simple;
	bh=l3tUhJtrJ2o3kLtlnfYmuf5f30Nfla5+WUG0HXm2Apw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGWOQSnWju+lacc0nlHe83rR2FryhlgS29d0NfFQG8NPAvp48QZVAUVbpa1Bk5bqUXfcRPI32X/mmWaWgqvhfFeOcT4iUxTmiVzCV0+/4dWPnBQid59ixPAXFyaTVEg/e0Z10WWgWWbdRLX73+8kE6F4t2XKpZ8SCV2QcwAU37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3AmX+xT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3AmX+xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E8CC4CED0;
	Fri, 27 Dec 2024 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735315145;
	bh=l3tUhJtrJ2o3kLtlnfYmuf5f30Nfla5+WUG0HXm2Apw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C3AmX+xTEKkgjgfLTmTai4njBW8pAor95csOKQwHQtBo+8JQ2y9ErHiO5FykPGCKb
	 2YqlT1iidDbjS8+79W8GaIipZ+GUAKcJMaffxqCIsmXOo9O0NoGWdAFWLdvU10B0Nk
	 CxD7pGmJNtEM6bPTYe85C8Hf38dE3DEDIbuXa8y4IgX8g+FC6U/164wLdJDCDwfH3i
	 PwLPv2EP4Y8WdoPF77SlGh6U/dOMMBN0j8v+dpo17/4Ky8jEZarUvbP5vWgUOuZ7Fj
	 BFwUF2CetkDGor5WQjDmnkickSTKp/doUQXkVmp4PbXqd57jNkJOTiJjWEe4pq7Gjh
	 GJ6H1MxvWIDQA==
Received: by pali.im (Postfix)
	id 027FA787; Fri, 27 Dec 2024 16:58:54 +0100 (CET)
Date: Fri, 27 Dec 2024 16:58:54 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241227155854.5dpq2xihclrat6nn@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <01f5a207-7dfe-41f4-b2bf-bc38d48053b7@samba.org>
 <20241008181827.cgytk5sssatv6gvl@pali>
 <CAH2r5mvUjZdDo2gEZ-PSrP5cYT7q25yT7-J1RcaaLxGh-h7Eaw@mail.gmail.com>
 <20241014094913.nyaltrl2t7vjhcuw@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241014094913.nyaltrl2t7vjhcuw@pali>
User-Agent: NeoMutt/20180716

Hello, I have redone these tests again. And the results are that
Windows SMB3.1.1 server really filter out this class 64 and does not
allow to use it.

But Windows SMB1 server does not filter this class 64 when sent over
SMB PASSTHROUGH (sent as level 0x03e8+64, see [MS-SMB] 2.2.2.3.5), and
normally execute it.

I have checked that over first SMB connection I opened the file, then
over second SMB connection I sent that UNLINK command and check that
over second SMB connection the file is not available in the directory
listing anymore, and at the same time over first SMB connection it was
possible to use file handle (of that opened file) for other operations.

So it looks like that at least SMB1 can benefit of this POSIX UNLINK
support. I have also checked that if I used first connection over
SMB3.1.1 then it still worked correctly (opened file handle was usable
and the file was not in directory listing anymore).

Do you know if SMB3.1.1 has something like [MS-SMB] 2.2.2.3.5
Pass-through Information Level Codes? If yes then it could be
implemented also for SMB3.1.1.

On Monday 14 October 2024 11:49:13 Pali Rohár wrote:
> I checked it and seems that both Windows SMB client and Windows SMB
> server on Windows Server 2022 filter out this class 64.
> 
> Windows SMB client does not send request to server at all and
> immediately return error to application which tried to use class 64. And
> Windows SMB server returns STATUS_NOT_IMPLEMENTED, which indicates that
> server recognized it, but filtered it. Older Windows servers returns
> STATUS_INVALID_INFO_CLASS which indicates that they did not understand
> class 64 at all.
> 
> So seems that against Windows SMB implementation, this class 64 is
> unusable for now.
> 
> 
> Anyway, can somebody ask in Microsoft if they can allow to use
> class 64 (FileDispositionInformationEx) and class 65
> (FileRenameInformationEx) in their SMB client and server?
> This would really help with Linux/POSIX interop, which Windows already
> provided for local filesystems.
> 
> Steve, are you able to ask somebody in Microsoft for this?
> 
> On Wednesday 09 October 2024 00:03:03 Steve French wrote:
> > FILE_DISPOSITION_DO_NOT_DELETE  0x00000000 Specifies the system should
> > not delete a file.
> > FILE_DISPOSITION_DELETE  0x00000001 Specifies the system should delete a file.
> > FILE_DISPOSITION_POSIX_SEMANTICS  0x00000002 Specifies the system
> > should perform a POSIX-style delete.
> > FILE_DISPOSITION_FORCE_IMAGE_SECTION_CHECK  0x00000004 Specifies the
> > system should force an image section check.
> > FILE_DISPOSITION_ON_CLOSE  0x00000008Specifies if the system sets or
> > clears the on-close state.
> > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE  0x00000010 Allows
> > read-only files to be deleted.
> > 
> > These are interesting flags, but are we certain they are passed
> > through over SMB3.1.1 by current Windows?  It is possible that they
> > are filtered and thus local only
> > 
> > Have you tried setting them remotely over an SMB3.1.1 mount to Windows server?
> > 
> > On Tue, Oct 8, 2024 at 1:18 PM Pali Rohár <pali@kernel.org> wrote:
> > >
> > > On Tuesday 08 October 2024 11:40:06 Ralph Boehme wrote:
> > > > On 10/6/24 12:31 PM, Pali Rohár wrote:
> > > > > But starting with Windows 10, version 1709, there is support also
> > > > > for UNLINK operation, via class 64 (FileDispositionInformationEx)
> > > > > [1] where is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does
> > > > > UNLINK after CLOSE and let file content usable for all other
> > > > > processes. Internally Windows NT kernel moves this file on NTFS from
> > > > > its directory into some hidden are. Which is de-facto same as what
> > > > > is POSIX unlink. There is also class 65 (FileRenameInformationEx)
> > > > > which is allows to issue POSIX rename (unlink the target if it
> > > > > exists).
> > > >
> > > > interesting. Thanks for pointing these out!
> > > >
> > > > > What do you think about using & implementing this functionality for
> > > > > the Linux unlink operation? As the class numbers are already
> > > > > reserved and documented, I think that it could make sense to use
> > > > > them also over SMB on POSIX systems.
> > > >
> > > > for SMB3 POSIX this will be the behaviour on POSIX handles so we don't
> > > > need an on the wire change. This is part of what will become POSIX-FSA.
> > > >
> > > > > Also there is another flag
> > > > > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE which can be useful for
> > > > > unlink. It allows to unlink also file which has read-only attribute
> > > > > set. So no need to do that racy (unset-readonly, set-delete-pending,
> > > > > set-read-only) compound on files with more file hardlinks.
> > > > >
> > > > > I think that this is something which SMB3 POSIX extensions can use
> > > > > and do not have to invent new extensions for the same functionality.
> > > >
> > > > same here (taking note to remember to add this to the POSIX-FSA and
> > > > check Samba behaviour).
> > > >
> > > > -slow
> > >
> > > So the behavior when the POSIX extension is active would be same as if
> > > every DELETE_ON_CLOSE and every DELETE_PENDING=true requests would set
> > > those new NT flags FILE_DISPOSITION_POSIX_SEMANTICS and
> > > FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE?
> > >
> > 
> > 
> > -- 
> > Thanks,
> > 
> > Steve
