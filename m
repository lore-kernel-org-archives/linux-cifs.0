Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE35145FEB;
	Tue, 17 Sep 2024 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726603567; cv=none; b=TBTJu2APeAV2pf1GR3q+bmK5Slj/WlwUB97HU4NBnXvtkUzO147XkX/038ue6gCXtZGTrlWYEEQ5IzvEzaLQkNkLIvjG2Wt/Qx3FmWUKrOtcVq/FTNIy8sGJ5MX6GfeEzPnZeXd6HDIPEgekmIlr6BUW+ZUUnJXtWMrbC8iEals=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726603567; c=relaxed/simple;
	bh=SUsK8Svdw3efubdcejW6xIz0v3Eh5IcBKBW2pOhzyhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alKsEUGCD2zYxoPX5pHUZekKfd69ajU6cI1kUM9rUOP/Kk65ziy55HN1hPcouHe01NXbpoBAQSIdSfaQaCeYS9lm13qz9r7K1G3JRoiwrMLaIlBoANbH02WHQ5xG6bqGuDSwbalR2tGABAxX4OBfMeUHXDZX1HjBT6htii03hL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZ6KcVq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZ6KcVq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B497EC4CEC5;
	Tue, 17 Sep 2024 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726603566;
	bh=SUsK8Svdw3efubdcejW6xIz0v3Eh5IcBKBW2pOhzyhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iZ6KcVq9FTQAdTIpkvSLOvR6cTQ2d36mu+93O3SHxsDj9pI8ILZTUV3yaWCA7ohDf
	 r3zui2lSheIA6HWKJrn0nZDXsJPshn/K8ZYdsvcPJxUYXCDu7Y8cZde2SlPMORHlZv
	 o06cr1OYrLPRQsSwLIpMY3BXvEpitxHtew4saBemEOqSXF1DNGzAb/NWYSjUwmHeLt
	 0yqbQLUib36RV0UnntiCQvjxvEs6rXnIASLSY+NVx7lAF164oDEY9/ZCO89AzKkx7A
	 lH+6PRhwIWfk0U8r8IhicKR0w/TK1nbtQQQQS8nqpI67bPqWnvnvwY6zbFHN8S4/Kb
	 LLnVxTgHTRaEg==
Received: by pali.im (Postfix)
	id 0E4CD7BA; Tue, 17 Sep 2024 22:06:01 +0200 (CEST)
Date: Tue, 17 Sep 2024 22:06:00 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <20240917200600.6smfxhrppkyjuyku@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240913201041.cwueaflcxhewnvwj@pali>
User-Agent: NeoMutt/20180716

And seems that SMB2_OP_QUERY_WSL_EA is useful not only for reparse
points, but also for any regular file or directory as it can contain
UNIX mode and UID/GID ownership.

On Friday 13 September 2024 22:10:41 Pali Rohár wrote:
> Paulo, please look at this patch as it is related to WSL attributes
> which you introduced in the mentioned commit. I think that the proper
> fix should be to change SMB2_OP_QUERY_WSL_EA code to not trigger that
> -EOPNOTSUPP error which is delivered to userspace. I just checked that
> this my patch works fine for Native NTFS symlinks and NFS-style reparse
> point special files.
> 
> On Friday 13 September 2024 22:02:04 Pali Rohár wrote:
> > If SMB server does not support WSL EAs then for SMB2_OP_QUERY_WSL_EA
> > request it returns STATUS_EAS_NOT_SUPPORTED. Function smb2_compound_op()
> > translates STATUS_EAS_NOT_SUPPORTED to -EOPNOTSUPP which cause failure
> > during calling lstat() syscall from userspace on any reparse point,
> > including Native SMB symlink (which does not use any EAs). This issue
> > happen for example when trying to resolve Native NTFS symlink from SMB
> > server on Windows 8.
> > 
> > Avoid this problem by calling SMB2_OP_QUERY_WSL_EA only when detected
> > reparse point is of WSL type. Note that this is not solve this problem
> > fully as WSL reparse points can be created also on other SMB server
> > which do not support Extended Attributes at all.
> > 
> > Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/smb2inode.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 11a1c53c64e0..d65471aa55e6 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -941,7 +941,20 @@ int smb2_query_path_info(const unsigned int xid,
> >  		if (rc || !data->reparse_point)
> >  			goto out;
> >  
> > -		cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
> > +		/*
> > +		 * Skip SMB2_OP_QUERY_WSL_EA if reparse point is not WSL.
> > +		 * The server file system does not have to support Extended
> > +		 * Attributes and in this case returns STATUS_EAS_NOT_SUPPORTED
> > +		 * which smb2_compound_op() translate to -EOPNOTSUPP. This will
> > +		 * present failure during reading of non-WSL special files.
> > +		 */
> > +		if (data->reparse.tag == IO_REPARSE_TAG_LX_SYMLINK ||
> > +		    data->reparse.tag == IO_REPARSE_TAG_AF_UNIX ||
> > +		    data->reparse.tag == IO_REPARSE_TAG_LX_FIFO ||
> > +		    data->reparse.tag == IO_REPARSE_TAG_LX_CHR ||
> > +		    data->reparse.tag == IO_REPARSE_TAG_LX_BLK)
> > +			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
> > +
> >  		/*
> >  		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
> >  		 * response.
> > -- 
> > 2.20.1
> > 
