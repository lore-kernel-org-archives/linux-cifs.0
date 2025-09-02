Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA2420110B;
	Tue,  2 Sep 2025 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756830657; cv=none; b=hXdg6z3c477BL8TUC+OKFsdyqZj+qDgdSiLH4Y5HpaAKM0v19P6p1tCKC3j09gtiUcIa++1jpaWdp2wifQkhFNsPiayHAwWW8CFYJKNBKPwGzjSOCad3KYCXMiV6xkpVOjyOvoEjQ/S1fMhfBBkKkNIQXAQ7slJrunN0PBwFhEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756830657; c=relaxed/simple;
	bh=7DSDu3xe+61KTUCFNykFVwnFmHEleC8yPorysYzOCXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9JPDbGe1xyeZhSvbqVCNgdAo36ProNQp9VFO/j3UJt91atVl5ZycB9mekliGbmU5s3vu+AgNZSoyRigYZTCJHE2J6QvJbm8H5VhAm6fxV8Pa4Xh1ABZm/I8g46n0YMn+ujjrIPJtuP/y0yVgBD3gKO5S1GDCm+9uXq3301HS5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLFsl1MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLFsl1MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DC9C4CEED;
	Tue,  2 Sep 2025 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756830656;
	bh=7DSDu3xe+61KTUCFNykFVwnFmHEleC8yPorysYzOCXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLFsl1MSsn8yfioftt3LDIwhCdZxval+GKnNQp5yfkog6UDNDgH7hQMUREQmBz56q
	 BzGAbDpKwFZ7m4ARYpInN8XoqIB5fiPS+/suHl2GBi66ZJ0P6FlHDOesEwwWK2J53y
	 Yp/tc2JLydTg9RCgsI7JGoulI1MhfpksSFCKVqDyMmEKh+KzMRdop+7PNwWupsj7iA
	 TJyUL+iHamMzqnfEhPXHUwBTs5kB+NTf6zyXwGzBYpgHjQgjCJzNiRJo91E34sJujR
	 NrY1JQA7umDsH406z7RcXWIuVRC4m7HAuJywfF2sgN7HF+06n+AV5wuCUCAEBqWEJO
	 0+5htAk7aXqnw==
Received: by pali.im (Postfix)
	id 46B634BB; Tue,  2 Sep 2025 18:30:53 +0200 (CEST)
Date: Tue, 2 Sep 2025 18:30:53 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	Ralph =?utf-8?B?QsO2aG1l?= <slow@samba.org>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cifs: Fix SMB rmdir() and unlink() against Windows
 SMB servers
Message-ID: <20250902163053.zzgd5ee4qguciajj@pali>
References: <20250831123602.14037-1-pali@kernel.org>
 <dfa557ed-eb34-4eaf-9e17-7cae221e74fd@samba.org>
 <20250901170253.mv63jewqkdo5yqj7@pali>
 <6660f6bd-ea74-4b25-b7dd-280833b5568c@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6660f6bd-ea74-4b25-b7dd-280833b5568c@samba.org>
User-Agent: NeoMutt/20180716

Hello!

On Tuesday 02 September 2025 17:17:14 Stefan Metzmacher wrote:
> Hi Pali,
> 
> > > > This patch series improves Linux rmdir() and unlink() syscalls called on
> > > > SMB mounts exported from Windows SMB servers which do not implement
> > > > POSIX semantics of the file and directory removal.
> > > > 
> > > > This patch series should have no impact and no function change when
> > > > communicating with the POSIX SMB servers, as they should implement
> > > > proper rmdir and unlink logic.
> > > 
> > > Please note that even servers implementing posix/unix extensions,
> > > may also have windows clients connected operating on the same files/directories.
> > > And in that case even posix clients will see the windows behaviour
> > > of DELETE_PENDING for set disposition or on rename
> > > NT_STATUS_ACCESS_DENIED or NT_STATUS_DIRECTORY_NOT_EMPTY.
> > 
> > Ok. So does it mean that the issue described here applies also for POSIX
> > SMB server?
> 
> I guess so.
> 
> > If yes, then I would propose to first fix the problem with
> > Windows/non-POSIX SMB server and then with others. So it is not too big.
> 
> That's up to Steve. But isn't it just a matter of removing the
> if statement that checks for posix?

I can modify that if statement, no problem. I just did not wanted to
touch POSIX code path as my focus is on the Windows code path.
I do not know all those case which POSIX paths against POSIX server may
trigger, so it was safer for me to let POSIX as is.

> > > > When issuing remove path command against non-POSIX / Windows SMB server,
> > > > it let the directory entry which is being removed in the directory until
> > > > all users / clients close all handles / references to that path.
> > > > 
> > > > POSIX requires from rmdir() and unlink() syscalls that after successful
> > > > call, the requested path / directory entry is released and allows to
> > > > create a new file or directory with that name. This is currently not
> > > > working against non-POSIX / Windows SMB servers.
> > > > 
> > > > To workaround this problem fix and improve existing cifs silly rename
> > > > code and extend it also to SMB2 and SMB3 dialects when communicating
> > > > with Windows SMB servers. Silly rename is applied only when it is
> > > > necessary (when some other client has opened file or directory).
> > > > If no other client has the file / dir open then silly rename is not
> > > > used.
> > > 
> > > If I 'git grep -i silly fs/smb/client' there's no hit, can you
> > > please explain what code do you mean with silly rename?
> > 
> > Currently (without this patch series) it is CIFSSMBRenameOpenFile()
> > function when called with NULL as 3rd argument.
> > 
> > Cleanup is done in PATCH 11/35, where are more details.
> > 
> > Originally the "Silly rename" is the term used by NFS client, when it
> > does rename instead of unlink when the path is in use.
> > I reused this term.
> > 
> > 
> > So for SMB this "silly rename" means:
> > - open path with DELETE access and get its handle
> > - rename path (via opened handle) to some unique (auto generated) name
> > - set delete pending state on the path (via opened handle)
> > - close handle
> > 
> > (plus some stuff around to remove READ_ONLY attr which may disallow to
> > open path with DELETE ACCESS)
> > 
> > So above silly rename means that the original path is not occupied
> > anymore (thanks to rename) and the original file / dir is removed after
> > all clients / users release handles (thanks to set delete pending).
> > 
> > It is clear now clear? Or do you need to explain some other steps?
> > Sometimes some parts are too obvious for me and I unintentionally omit
> > description for something which is important. And seems that this is
> > such case. So it is my mistake, I should have explain it better.
> 
> I think I understand what it tries to do, thanks for explaining.
> 
> I was just wondering why the rename on a busy handle would work
> while delete won't work. I'd guess the chances are high that both fail.

Both "set delete pending" and "rename" operations are working (if open
pass). Just "set delete pending" does not unlink file/dir immediately
but rather wait until path is not busy anymore. "rename" on the other
hand is executed immediately.

So we can rename the in-use/busy file on Windows server, but we cannot
remove it immediately. We can only "schedule" its removal on the Windows
server. So combination of "rename" + "schedule removal" is what are
patches doing.

In case open fails (e.g. due to conflicting DENY shared reservations or
because path is already in delete pending state) then obviously it is
not possible to continue with either rename or set delete pending
operation, both then fails.

> Do you have network captures showing the old and new behavior
> that's often easier to understand than looking at patches alone.
> 
> metze

I do not have them right now, but I can run test scenario and capture
them, this is not problem. Test case is pretty straightforward.
