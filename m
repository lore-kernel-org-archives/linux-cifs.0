Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795181464;
	b=N8gtuDEnF1hxP9KiFRi97/WCUmm8a9ofVAtLXd40Mc1XHH7vNJFEDsMkJ/VfoqEBAYOr
	 i6ZmaUOs0ue/ngo5PebKe8AflkYNUxaN3XQpsS8cxPqi7svQc4O2YAu72LVaWlgdfch5m
	 Bfy9IBbZK8qGwTdkUBkWTkDWP4OW57h+NXBTRYLbFejQF2vWyc9iKGLwm/ILC+6SjxNn+
	 zNeOGcb03Ef6UbKwp3ZqbquWf+rhbuUJfjZnuNMC3+BF4vw/afgekS6QdDmAAyWq9FYpQ
	 J3rLBsduiz8Ab3M/QTc7dEkRK9dlwXve/Ces1L2W7GhoMHAD5bUaCUdvTlqNc2vwTKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795181464;
	h=Received:DKIM-Signature:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent;
	bh=tOtm0PpBEf52YI861ebAHgRQYFIljzPJXFL7lQq6YVs=;
	b=x7jSeUGDPVJjoFujekSGWRqtbjX5t+L68bbkoWUqi5NzBmr1BdVbaLwZH0KG7ewT20kT
	 vhlxLS2C9AN8nR5ULtCHYvuAU2z/hYGut2DH3R3Vi1srkf+nh4Fhg8o33Ca+NlvYgQRi7
	 JYneQ2c2YUNO5efO3OKTTrvHtoyzWYACKR8CbMZYOxWo3/KuEiTf7EEOa7ccAeXA4579M
	 4cm908lLehQRMiDe67a5gUVj07qZKqysZQvRkpF8dXq6EAdTjI6ea9YyL66YoMLvF7pb5
	 VxS44W/xGm51hBkYBEMaFdhim4FnD4s2zVseFuBMBmL24mbcpgVSDbDALsmkMj1mUuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBxbd7My;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137EC606A32A;
	Fri, 20 Nov 2026 13:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBxbd7My
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACAE1F000C6;
	Fri, 20 Nov 2026 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795181463;
	bh=tOtm0PpBEf52YI861ebAHgRQYFIljzPJXFL7lQq6YVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aBxbd7MyvzEFfSTcOVtq3CLYvjY2Mh1UK2j4ftnoC2V9Lx6ao1yX0wtXGqJAkNGii
	 vlA5Q1xOrKTji83kpkX1wlgeJhmOY6aVm261CnxHUZgVOv9r/jprhpHfS37ppnHIX7
	 xtql8SP2vkKqGWkZya3m8img84UnVvH+Ww2LBcG9wPhGcGGtq2Y33Qa2cnJp6PbAFH
	 9z//+TDw85FXSgt6JHya82UrHccpxurPKZGy7mCe6TvhQdD2mx8SdbXdnWdYfcBY8x
	 tIB3lvPJfrporWG8ow1arNL0Agz7WHowNgiZMNSX1AeXMsyou6lTBUCMco2l8sNPYu
	 0/Qybis/Hi+RA==
Received: by pali.im (Postfix)
	id 1412C36C; Fri, 20 Nov 2026 14:31:01 +0100 (CET)
Date: Fri, 20 Nov 2026 14:31:00 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7.3 0/9] Various changes
Message-ID: <20261120133100.skp7fow2tenxbgo5@pali>
References: <20261026222600.17323-1-pali@kernel.org>
 <CAKYAXd84MA0R+3Xd-SPq4jWqcQR7+Wu5voHAJWKOmVzdhwkRYw@mail.gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd84MA0R+3Xd-SPq4jWqcQR7+Wu5voHAJWKOmVzdhwkRYw@mail.gmail.com>
User-Agent: NeoMutt/20180716

Paulo, do you have any comments for patches 1-7?

On Thursday 29 October 2026 09:49:45 Namjae Jeon wrote:
> On Tue, Oct 27, 2026 at 7:26 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > Rebased changes on top of the v7.3.
> > No functional change, just fixed 3 oneliners from Sashiko.
> > Link to previous: https://lore.kernel.org/linux-cifs/20260825230622.24617-1-pali@kernel.org/
> >
> > Pali Rohár (9):
> >   cifs: Remove code for querying FILE_INFO_STANDARD via
> >     CIFSSMBQPathInfo()
> >   cifs: Remove cifs_backup_query_path_info() and replace it by
> >     cifs_query_path_info()
> >   cifs: Fix validation of EAs for WSL reparse points
> >   cifs: Validate presence of EA $LXMOD for WSL reparse points
> >   cifs: Check if server supports EAs before trying to set it for WSL
> >   cifs: Extend ->set_EA() callback to allow operate on reparse point
> >   cifs: Create native Window socket file compatible also with WSL
> >     subsystem
> For patches 1–7:
> 
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> 
> Paulo, Let me know your thoughts.
> 
> Thanks.
> 
> >   cifs: Add support for parsing WSL symlinks in version 1 format
> >   cifs: Add support for creating WSL symlinks in version 1 format
> >
> >  fs/smb/client/cifsglob.h   |  10 +-
> >  fs/smb/client/cifsproto.h  |   1 +
> >  fs/smb/client/cifssmb.c    |  43 ++++---
> >  fs/smb/client/fs_context.c |  11 +-
> >  fs/smb/client/fs_context.h |   3 +-
> >  fs/smb/client/inode.c      |  98 +-------------
> >  fs/smb/client/link.c       |   3 +-
> >  fs/smb/client/reparse.c    | 257 ++++++++++++++++++++++++++++++++-----
> >  fs/smb/client/smb1ops.c    |  11 +-
> >  fs/smb/client/smb1proto.h  |   4 +-
> >  fs/smb/client/smb2ops.c    |   6 +-
> >  fs/smb/client/xattr.c      |   3 +-
> >  fs/smb/common/fscc.h       |   5 +-
> >  13 files changed, 287 insertions(+), 168 deletions(-)
> >
> > --
> > 2.20.1
> >
