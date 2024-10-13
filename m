Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C29636B;
	Sun, 13 Oct 2024 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728826715; cv=none; b=aKLlLIm/QKxa3iSdFd1n+hWGZVZDmrMpmaIb6+5JnJB7Gx3TQ/eBTm5KAcq6AVnZWs2wjAdmEYYyXWEL7NoA0jEIvEP/9yH8KuGc9FRKN9NCWqLcnD2/EdyZhaAtTo8DXfo9jzWU0pHlo48HO3Wd7YjgQdz0o28aUWpbDdtsTYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728826715; c=relaxed/simple;
	bh=NluLoHfX6JeLFpsX9MCWqSmrkJEpBuoc5uhCKz+6CCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxKDLjnDpEyYDYfpGD3IelArNMhsyIUDIXJFA/h6VL0IdjRau4npP6EiLOZNUzI2RbUIrtmJ33NKVbhnhAHT68TJAas+Xqukz0Z/LHPUJodwdHotuTV4D2/0hcIxUdpqrQ5SLBxaN++3yof+1MLGknorbW/J1iGTPUSJIZ2FK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OpCoFTmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpCoFTmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29BAC4CEC5;
	Sun, 13 Oct 2024 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728826714;
	bh=NluLoHfX6JeLFpsX9MCWqSmrkJEpBuoc5uhCKz+6CCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OpCoFTmzL6TGDqETUTyd7fG4HAorHZtsNSmoIJzO788jQhzzgSQOiQNPS4E8eeH+Q
	 2IqQlnY1FTzbXJNoYHt6ekS6Dxiujs3XeH2h54o1r9YPk3npzXoRmDo8oSh3cLWdis
	 Wo5vPuW2t1rCedvaJ6GSLBdFLNSYR5XStAx/aRXrU8YLi4UiPTPaWejL3wD70rX2Xv
	 lm+Q2/NevsXEtPLF7HrK2F64z85kd8tVLWtcb2F8yDf+lExW9fyAeUUQt4hbKWiPbX
	 lFqmADiL1ZJlirqkaybobaWpHYjKcU1DDX/+u1FWEJ5fgEShTeE9NBYnMs0pWCOgBJ
	 RICHyTGYaUOGg==
Received: by pali.im (Postfix)
	id 53B0B5F9; Sun, 13 Oct 2024 15:38:27 +0200 (CEST)
Date: Sun, 13 Oct 2024 15:38:27 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Allow to choose symlink and socket type
Message-ID: <20241013133827.lodho6ep2uspbzpk@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241012085252.560-1-pali@kernel.org>
 <CAH2r5mtGqqM35Cy5k9NN=X05rTZPk-adhb7LgoV8PGNVL9P6FQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtGqqM35Cy5k9NN=X05rTZPk-adhb7LgoV8PGNVL9P6FQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

Anyway, I think that the create symlink privilege is needed to create
any reparse point, so fallback to NFS reparse point would not help.

On Saturday 12 October 2024 23:18:13 Steve French wrote:
> after doing more experiments with native windows symlinks (and how
> difficult it is to get permission to set them over the wire to Windows),
> was wondering if we should allow fall back strategy if creating windows
> style symlinks fails with STATUS_PRIVILEGE_NOT_HELD then we should try NFS
> reparse point symlink.  Any opinions?
> 
> On Sat, Oct 12, 2024 at 3:53 AM Pali Rohár <pali@kernel.org> wrote:
> 
> > This patch series improves choosing reparse format when creating new
> > special files.
> >
> > Changes since v1:
> > * Instead of new -o reparse= mount option is now a new -o symlink= mount
> >   option for choosing symlink type during creation, and new option
> >   -o nonativesocket for choosing socket type
> >
> > Pali Rohár (7):
> >   cifs: Add mount option -o symlink= for choosing symlink create type
> >   cifs: Add mount option -o reparse=none
> >   cifs: Add support for creating native Windows sockets
> >   cifs: Add support for creating NFS-style symlinks
> >   cifs: Improve guard for excluding $LXDEV xattr
> >   cifs: Add support for creating WSL-style symlinks
> >   cifs: Validate content of WSL reparse point buffers
> >
> >  fs/smb/client/cifsfs.c     |   4 +
> >  fs/smb/client/cifsglob.h   |  36 +++++++
> >  fs/smb/client/connect.c    |   4 +
> >  fs/smb/client/fs_context.c |  82 +++++++++++++++
> >  fs/smb/client/fs_context.h |  19 ++++
> >  fs/smb/client/link.c       |  60 ++++++++---
> >  fs/smb/client/reparse.c    | 201 +++++++++++++++++++++++++++++++------
> >  fs/smb/client/reparse.h    |   2 +
> >  8 files changed, 364 insertions(+), 44 deletions(-)
> >
> > --
> > 2.20.1
> >
> >
> >
> 
> -- 
> Thanks,
> 
> Steve
