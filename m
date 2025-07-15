Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89910366
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752602201; cv=none; b=DQTSFSFYl7eE+m7RGjTA22rmjomgOXKPIfWtRTjXPUlUj3AHzzSnsIY+rQf42tFJVRhQBlcqVwwrdT5pLWLTDkvlfEN6LnOZRWYNyLgPPkn2tfgpAT5fQrJJAu4uN6fWE/7A7XS+EOzJURdMI+IAFIvWklfvzSiAefyY0PP06Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752602201; c=relaxed/simple;
	bh=4Ffv10zEn97lnyG7IdhDYx/JGUioH73z2iKWfAT1PN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mwj15CGYDl5iPl/8UTGanssgT06rP927xnIPi76kwx4tqk+rjdfkzKOqkgopoggetMQZsr+WplGF1f9ljm3OF+zq0oUfOAbKWmTRIy5khJW1s2GHeCYLuZlz2vRkB0m6/S+M3vwUtFmjjjO1LIa1uVWMDL+4XNeT0yuJI6zzgP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hefX+6Ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hefX+6Ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9B0C4CEE3;
	Tue, 15 Jul 2025 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752602201;
	bh=4Ffv10zEn97lnyG7IdhDYx/JGUioH73z2iKWfAT1PN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hefX+6CivYGtULuWoMdp0yE+CoTl55ItjAPx1MXLHlMbbCozYfilVZj5KPaGTp6pb
	 2k28Dnh/xdI4Eq2yDikwQvDZ2jZ4XJ9IXrEsljhwVLId/lgpc3GhYdHQf0h2+Mqj+z
	 WqtqjLtIZxwKT4kyC9bRkEzET5X0dBo5WsGKoyIAJL6fTqoS8YBqzLUyx9tOcTjC3V
	 wTgkmBC/BtFNy3p6Cfvso14NkNH60YTDzEcenQb99ZX4ijOICVgKxB8nGFAyJ8Oh/0
	 WobLtweHYgSSHilRGMLHiteciQG4djluJM7CYQhoPOvzxbrEi28P4YF/CUYPYiTnY7
	 d4DPQ5OGzGoLw==
Received: by pali.im (Postfix)
	id 8551E95B; Tue, 15 Jul 2025 19:56:38 +0200 (CEST)
Date: Tue, 15 Jul 2025 19:56:38 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>
Cc: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
	vl@samba.org, samba-technical <samba-technical@lists.samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Samba support for creating special files (via reparse points)
Message-ID: <20250715175638.yj2wiuikpdv473nf@pali>
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
 <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org>
 <20250714165844.4hctlrwegfspiius@pali>
 <946b0ed2-6aca-4b52-be1e-2910bc371ba7@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <946b0ed2-6aca-4b52-be1e-2910bc371ba7@samba.org>
User-Agent: NeoMutt/20180716

On Tuesday 15 July 2025 14:27:50 Ralph Boehme wrote:
> On 7/14/25 6:58 PM, Pali Rohár wrote:
> > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > It's an oversight I'm afraid.
> > > > 
> > > > hm... it seems reparse points support is mandatory for SMB3 POSIX so I
> > > > wonder what this additional checks buys us.
> > 
> > No. It is not mandatory.
> 
> sorry, imprecise wording: support for receiving and understanding
> REPARSE_TAG_NFS and REPARSE_TAG_SYMLINK is mandatory. Server and client MUST
> be able to send/receive and understand these. They can still fail of course
> on the server for various reasons.
> 
> Support for other reparse point types is optional and the client MAY check
> FILE_SUPPORTS_REPARSE_POINTS before using those.
> 
> REPARSE_TAG_NFS and REPARSE_TAG_SYMLINK are reparse points on the wire, but
> typically the server stores them in their "native" POSIX format and the
> client MUST represent them in their native POSIX format.
> 
> It's really just some accommodation to the protocol, with something being
> disguised as a reparse point when it is actually something else entirely.

Ok, that makes sense. From the protocol perspective it is reparse point
and so everything related to reparse points applies to it.

> > Getting or setting of reparse points is done
> > via IOCTLs which are optional.
> 
> Same here. Server and client MUST be able to send/receive REPARSE_TAG_NFS
> and REPARSE_TAG_SYMLINK.

Yes.

> > Also fs attribute for reparse points is
> > optional.
> 
> yes. And it applies to all other reparse point types.
> 
> > 
> > And that make sense as there are still lot of filesystems which do not
> > support reparse points (e.g. FAT) and this fs attribute is exactly what
> > server announce for clients and applications to tell feature support.
> 
> If a filesystem on the server doesn't support storing REPARSE_TAG_NFS or
> REPARSE_TAG_SYMLINK one way or another, it is free to fail the operation
> with some sensible error.

Make sense.

> > So application would know what features are provided and which not on
> > particular share.
> 
> Application do not and can not check this.

Windows applications can already check for it there is
GetVolumeInformationA() function for it.

And also applications on Windows can issue directly the syscall to NT
kernel and not use that API at all. It is NtQueryVolumeInformationFile
for FileFsAttributeInformation class.

On Linux this information is currently not exported from kernel to
userspace, but recently is a work to add a missing gap and support for
different attributes and I guess that information about filesystem would
be too. As a first step are being added new syscalls file_getattr() and
file_setattr() (see fs: introduce file_getattr and file_setattr syscalls)

> > Server can support reparse points on share A but does
> > not have to support it on share B. E.g. when A is NTFS and B is FAT.
> 
> Sharing NTFS is somehat out of scope for SMB3 POSIX Extensions really, as is
> FAT. The scope is end-to-end POSIX-to-POSIX compatibility.

This was an example of two different filesystems where one support
special files and another one does not.

> > > > While I agree that generally we should likely set this, for SMB3 POSIX
> > > > the client should probably not check this and we should keep it out of
> > > > the spec.
> > > 
> > > one additional thought: it seems like a valid scenario to be able to support
> > > SMB3 POSIX on a server that does not support xattrs on the backing
> > > filesystem and hence may not have a way of storing arbitrary reparse points.
> > 
> > xattrs and reparse points are two completely different things, and they
> > should not be mixed or exchanged.
> 
> It seems you're missing the point: if the server implementation stores
> reparse points as xattrs, then of course you claim support for reparse
> points only if you know (by configuration), that the filesystem supports
> xattrs.
> 
> Cheers!
> -slow

Ok. In this case, it does not matter for the client how the server
stores reparse points. Every filesystem can do it differently. And it is
really out of the scope. The important is the network / transport layer
and how it is used and announced.
