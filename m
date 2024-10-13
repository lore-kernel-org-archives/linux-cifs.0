Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4F42AA5;
	Sun, 13 Oct 2024 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728809964; cv=none; b=h7zTpr4B/lsblD+c4hXa/4aT4ntyRZIjehov6cW5+JXaxbMyzYasSH/khgMUQTHpZNTGvZK2UwoTProUc6UrJCzT/hRGHtyvyIWf8qtIfQNhxgHGmFSN3CXZoUFYpYlYSvS0xf6TGJXnfS4z+KjUsx9V5u+aGbV3gXTBOPIB08c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728809964; c=relaxed/simple;
	bh=MGPp+p+dxUmjH0cnQhkoeaR5EG/K95IWnJ4xLOSAOqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSV8uUYKHCokSXy0R9DfJo/XFMWV3Xnz8l1GUGLx8tVW7KVha3zwK8boH2LQGffxdfwPCmeN6/HOFzQbcF/aOCisA38RFIpVyFu1jSclAlg9zfDD9AE5gq6lwSzeQcDhvNRpec2p2Eq+qW2j471V6AEfVBZNd47B2fN0gx6pb5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5YJWuD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5YJWuD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E19C4CEC5;
	Sun, 13 Oct 2024 08:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728809963;
	bh=MGPp+p+dxUmjH0cnQhkoeaR5EG/K95IWnJ4xLOSAOqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5YJWuD6Aoics6ECGmsTwbHwSqToeSi/1LZB5VZbIwzy8V4l3Z/yu2VAZsAwYJDuI
	 YCPPvUgM5FjLOUVz33dYAPvTUtl4Xrk2HXstq9GKJbxLZlmX+oOAFFKjn8YnpYI1xJ
	 ezJeyVQ/ZPFFu6sSyk0fiulS9bp94WxUOukLIuyFjv5RUIra6wuXNuQ7FXISfky/Uv
	 Ew3Vx4y8cF/aSm9ceFwBo3iX7GAEjjR6zsRBAANuPUnPGk5EZw9XAMNllz+0+GpQyP
	 Ril9VZcfnzG9py9nUe5LE8u5izFspdFemZLtkPNMRYY/FWE8dAhCZPtVdfbrqQdUWM
	 uhTFeoUFEilgQ==
Received: by pali.im (Postfix)
	id 7E08A5F9; Sun, 13 Oct 2024 10:59:16 +0200 (CEST)
Date: Sun, 13 Oct 2024 10:59:16 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Allow to choose symlink and socket type
Message-ID: <20241013085916.tcpz6oclalqv6aan@pali>
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

Well, if server explicitly disallow user to create symlink due to
missing permissions, I am not sure if it is a good idea to obey it by
creating symlink in format unsupported by the server...

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
