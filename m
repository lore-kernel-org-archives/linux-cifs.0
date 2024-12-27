Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251753D69
	for <linux-cifs@vger.kernel.org>; Fri, 27 Dec 2024 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735317133; cv=none; b=Irn2qeJlXP4umU4ubloNv7DZr/1eLBopRVBNlnA93qcr3GqeTEaZ0AuPzJmaTbixZL2JT0wosH6X35LDu6jgEvWOdOufyfAFrhKLH/kvKGvy+xhlvx5XE/28USV1HwH7VeVMpzTVX+Q+uikQtXWVnjHAy9FkKrZXOJXBfMlQ2g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735317133; c=relaxed/simple;
	bh=Cw4Cn5FASVAQWDWUmfVZS5EZPvgGQxYdrGx6AdFKOg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6RdNUkkdi3iSstI7pBO4UDAGJZlaD4CdcE+nz1IY2G2dLjquJPWqtp9hOYjMEyyl+DC15VbMzvbVK/zAneGqjGwoWR/DI+jzRwaPk3rTE0l4aP6AospZHHHILzoj3hI131k6dHRwob6egPEaoCcH+vOCIQgcF2EhbXdvL6Ag0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2X6gNWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2X6gNWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6895EC4CED0;
	Fri, 27 Dec 2024 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735317132;
	bh=Cw4Cn5FASVAQWDWUmfVZS5EZPvgGQxYdrGx6AdFKOg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l2X6gNWIjCsFUJQdRHPvI7Lr7CVvRzl3Qh2OKgnb3XB0m4xFH4bqxd+XpTCZuZhxI
	 AxZi2gRKSW8n0smCwoFTfrmAhezUWGUp4/zGci65ieDKKc7TnuTlVvnD2BynbbshsZ
	 +DeNI3vnrBrsaUWocFWpmmwICn7j+jdTzxezcFqbqG8C+WHDVS2YFoQd31duajG3hJ
	 bKCk+KBbhXcKyoGWbeW5gH7JAxTVytevMEcrZ0Xc4FDb7DN04QaU83Jkh2xkVh4q9t
	 PxcQd9FiwRpZkO3rqtVQYdnSQcaziGs6XoGw4geUqjpijPTobL1G1pJcZsLmW7bafd
	 IezpV7fhixXPw==
Received: by pali.im (Postfix)
	id 74671787; Fri, 27 Dec 2024 17:32:02 +0100 (CET)
Date: Fri, 27 Dec 2024 17:32:02 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Tom Talpey <tom@talpey.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241227163202.ihp3cxmhe2sehxoh@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <20241225144742.zef64foqrc6752o7@pali>
 <76c28623-b255-4589-8bad-7e576cd1687c@talpey.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76c28623-b255-4589-8bad-7e576cd1687c@talpey.com>
User-Agent: NeoMutt/20180716

On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
> On 12/25/2024 9:47 AM, Pali Rohár wrote:
> > On Sunday 06 October 2024 12:31:27 Pali Rohár wrote:
> > > Hello,
> > > 
> > > Windows NT systems and SMB2 protocol support only DELETE operation which
> > > unlinks file from the directory after the last client/process closes the
> > > opened handle.
> > > 
> > > So when file is opened by more client/processes and somebody wants to
> > > unlink that file, it stay in the directory until the last client/process
> > > stop using it.
> > > 
> > > This DELETE operation can be issued either by CLOSE request on handle
> > > opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
> > > (FileDispositionInformation) and with set DeletePending flag.
> > > 
> > > 
> > > But starting with Windows 10, version 1709, there is support also for
> > > UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
> > > is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
> > > CLOSE and let file content usable for all other processes. Internally
> > > Windows NT kernel moves this file on NTFS from its directory into some
> > > hidden are. Which is de-facto same as what is POSIX unlink. There is
> > > also class 65 (FileRenameInformationEx) which is allows to issue POSIX
> > > rename (unlink the target if it exists).
> > > 
> > > What do you think about using & implementing this functionality for the
> > > Linux unlink operation? As the class numbers are already reserved and
> > > documented, I think that it could make sense to use them also over SMB
> > > on POSIX systems.
> > > 
> > > 
> > > Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
> > > which can be useful for unlink. It allows to unlink also file which has
> > > read-only attribute set. So no need to do that racy (unset-readonly,
> > > set-delete-pending, set-read-only) compound on files with more file
> > > hardlinks.
> > > 
> > > I think that this is something which SMB3 POSIX extensions can use and
> > > do not have to invent new extensions for the same functionality.
> > > 
> > > 
> > > [1] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/ne-wdm-_file_information_class
> > > [2] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-_file_disposition_information_ex
> > > [3] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_rename_information
> > 
> > And now I figured out that struct FILE_FS_ATTRIBUTE_INFORMATION which
> > has member FileSystemAttributes contains new documented bit:
> > 
> > 0x00000400 - FILE_SUPPORTS_POSIX_UNLINK_RENAME
> > The file system supports POSIX-style delete and rename operations.
> > 
> > See Windows NT spec:
> > https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_fs_attribute_information
> > 
> > Interesting is that this struct FILE_FS_ATTRIBUTE_INFORMATION is
> > available over SMB protocol too but bit value 0x00000400 is not
> > documented in [MS-FSCC] section 2.5.1 FileFsAttributeInformation:
> > https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa
> > 
> > So it really looks like that POSIX unlink is prepared for SMB, just is
> > not documented or implemented in Windows yet.
> > 
> > Maybe somebody could ask Microsoft documentation team for more details?
> We absolutely should do this, if the bit is visible remotely then it's
> an obvious omission. If it can be set remotely, even better.

Now I check that Windows Server 2022 via both SMB3.1.1 FileFsAttributeInformation
and via SMB1 QUERY_FS_INFO/FS_ATTRIBUTES announce the 0x00000400 bit for
FILE_SUPPORTS_POSIX_UNLINK_RENAME.

See other email in this tread, I was able to send POSIX UNLINK as
FILE_DISPOSITION_POSIX_SEMANTICS via SMB1, but not over SMB3.1.1
(but it is possible that I did it in wrong way).

> Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
> Send as much supporting evidence as you have gathered.
> 
> Tom.

Ok. I can do it. Should I include somebody else into copy?
