Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D21DED68
	for <linux-cifs@vger.kernel.org>; Mon,  7 Oct 2024 18:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728326939; cv=none; b=kfCO3fZiCuLWZWxEyFyOYYRSRbobUsEOa14dN3ejkLjGUwFEaMV+S70LsXW+KxDxsY2sEUr1VlTVVYkrizmPK132pw54QcOy3zG2GTLjCvsBSHLyBOuPA5QRH1otABs4MsB5+tqyiGGDED2ybzs1r6GNsGUmXDRTr1ZHcPtkaMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728326939; c=relaxed/simple;
	bh=b+BT6gpvN4Y8DMNH8noTej7C6yyib4zlJEaMVjewo2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPCMqOOyDkIBumiuMgS8KJrip7Zly+t09I3idceyQuY+d2sUYiDW4KmerbtWpcIosqxzWfJz2X4FYf/3vzC0zbtOv5EX7SFupaNLYHiYrZOPyXPGPM09avJLTmP6Tk4dPyZuFIF5P/19QBJEyfL7fQGhc7FRsDB8ONijBp9CqOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sM/UzkIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sM/UzkIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A88C4CECF;
	Mon,  7 Oct 2024 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728326939;
	bh=b+BT6gpvN4Y8DMNH8noTej7C6yyib4zlJEaMVjewo2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sM/UzkIesV8s1RjJGdax2XMnKw6gWq3Wb2qYKs/L5kRYLwd8azZDnlNLCZxz7jQdv
	 I83WuvVmPrtJ0ej3j1tf2Be9SqyqQ9YEXQ6O80IWxbzLltGqDTwbAjBkYETF1QCiUj
	 DwzCIxyJRoKdCOy2ZORPlywI+HjmzSZIpWUW9N668542W5zosSYVSs3bogjeHfFsZg
	 fkM/NfPfIQtZKmS+8fO7dyJ1U842UfbBv+l1aLGEwh5J4b+LgjOqjI+mU2rRli9059
	 CH7kzArKf0+nqDI7+aUz61UHgvdCr2Ke5sh5vD2pM9bO6dHLvv9yt4AKPVywH8ywtU
	 ygzDgWiQJnBMA==
Received: by pali.im (Postfix)
	id 5C9B0792; Mon,  7 Oct 2024 20:48:53 +0200 (CEST)
Date: Mon, 7 Oct 2024 20:48:53 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20241007184853.cocdfouji4bngcry@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <CAH2r5muZcbhy-MbhsLXgvoBCv3kZo_XhgtNPOkMyjEvLFDWbCg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muZcbhy-MbhsLXgvoBCv3kZo_XhgtNPOkMyjEvLFDWbCg@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 06 October 2024 23:18:28 Steve French wrote:
> On Sun, Oct 6, 2024 at 5:31 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > Hello,
> >
> > Windows NT systems and SMB2 protocol support only DELETE operation which
> > unlinks file from the directory after the last client/process closes the
> > opened handle.
> >
> > So when file is opened by more client/processes and somebody wants to
> > unlink that file, it stay in the directory until the last client/process
> > stop using it.
> >
> > This DELETE operation can be issued either by CLOSE request on handle
> > opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
> > (FileDispositionInformation) and with set DeletePending flag.
> >
> >
> > But starting with Windows 10, version 1709, there is support also for
> > UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
> > is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
> > CLOSE and let file content usable for all other processes. Internally
> > Windows NT kernel moves this file on NTFS from its directory into some
> > hidden are. Which is de-facto same as what is POSIX unlink. There is
> > also class 65 (FileRenameInformationEx) which is allows to issue POSIX
> > rename (unlink the target if it exists).
> >
> > What do you think about using & implementing this functionality for the
> > Linux unlink operation? As the class numbers are already reserved and
> > documented, I think that it could make sense to use them also over SMB
> > on POSIX systems.
> >
> >
> > Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
> > which can be useful for unlink. It allows to unlink also file which has
> > read-only attribute set. So no need to do that racy (unset-readonly,
> > set-delete-pending, set-read-only) compound on files with more file
> > hardlinks.
> 
> This is a really good point - but what about mkdir (where we have a
> current bug relating to rmdir of a file after "chmod 0444 dir"

I'm not sure what is doing "chmod 0444 dir". It is setting SMB/NT
read-only attribute?

If yes then FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE sounds like can
be something useful.


But anyway, I think that such bug could be fixed by sending SMB2
compound of following SMB2 commands:
* CREATE with DELETE desired access without DELETE_ON_CLOSE
* SET_INFO with clearing READ_ONLY attribute
* SET_INFO with setting DELETE_PENDING
* SET_INFO with setting READ_ONLY attribute
* CLOSE

CREATE with DELETE_ON_CLOSE fails on object with READ_ONLY attr, so
CREATE(open) has to be called without it. First SET_INFO will try to
remove the protection, to allow second SET_INFO to set DELETE_PENDING
flag. In case setting of it will fail, the third SET_INFO will restore
the protection.

Has SMB2 something like transaction support? NT kernel and its NTFS
subsystem provides transaction FS operations for applications. And I
think that Cygwin is using those FS transactions for race-free
implementation of removing file with read-only attribute.
