Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E7F27A455
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752601404; cv=none; b=VZCW8B47JhugXO7HNsw38q9XpUmJ9wqmBYixK2d7oqbdnSS9oUx+3s826WB+V0luV7kKCwOPkDQtXuGs/NBmNdDV2uk01zpWnH35DVrHv2m13mGZ7CsfMAcXiC/CMuWNj8vd5+7R4ZdMb3XsZkk8+D+pxzDcGC7wjr1TginZ9xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752601404; c=relaxed/simple;
	bh=2UnTdQKzv2AGbyiNk3fc1wSt28ZFQCXeoPovMxRcKIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=peNpDIMVRuGubxPmquIdIlB1+OrJKXLJWPnLNOqEdqW1F6P5cftsqK+nryY9F85ayy/6ZRVWCT5cVzdF8KOaOCtEU3wAL4Yhk3Q0hcwjQpMv5oDTqX+K2UgcOcgQQnLz9yPLMWLavv+Pw3i986PXV0jkClfLz+JZ2yrQFG+HMLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tz/mUCqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tz/mUCqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44D7C4CEE3;
	Tue, 15 Jul 2025 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752601404;
	bh=2UnTdQKzv2AGbyiNk3fc1wSt28ZFQCXeoPovMxRcKIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tz/mUCqHrR+DmSQHxecAOgQNFlpmsdnr5XdKo2Jhx07UAATb8ANNuGJUqhwGUlxGc
	 X+LaThFisverocoupKSZxie+nyg6Ro9kv6yvboBdY1kIT3LmvrfiAGLDcGtNPswuwl
	 f4kFoTu7Pa4fCjZR6SXQIWyPdQ5oTeSgQcVRr7qzOjxL2AAw5mVKxiMPRJ3ZhSsPAc
	 vcL/ph+uKj7TFHtvQqZLbn69uCNXeGljbaRz1u4Oati8cWPyhIY72/4cIL2eyNWtwl
	 1eio3y9HjrOfoJShf1ver/0paM4gCYYvaFUInvl0KLkemhTEb9FX5o0gPXB7ep4nUL
	 EWJGTE+Axt9Ug==
Received: by pali.im (Postfix)
	id A087595B; Tue, 15 Jul 2025 19:43:21 +0200 (CEST)
Date: Tue, 15 Jul 2025 19:43:21 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>,
	"vl@samba.org" <vl@samba.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Samba support for creating special files (via reparse points)
Message-ID: <20250715174321.7xko6gtmmlfsrjze@pali>
References: <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org>
 <20250714165844.4hctlrwegfspiius@pali>
 <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
 <20250714192404.j3dw6l3afgm2voe6@pali>
 <CAH2r5msRGGHyy0GdNgVYBVN+8NzfevDS-wtzr9TO5jF5NmoxHQ@mail.gmail.com>
 <20250714211016.zqddwjdvybeplgdf@pali>
 <CAH2r5mumdvhWTNOCEGV-dT8aQVJrUQEDep0GEBn_CbKF+o3kjQ@mail.gmail.com>
 <20250715080911.julhkkcf7an56q4w@pali>
 <CAH2r5mvAuffmNwgJZ=n3m4aj4Xn45unK1ENPEdL_=pG-S3XHCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvAuffmNwgJZ=n3m4aj4Xn45unK1ENPEdL_=pG-S3XHCw@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 15 July 2025 12:07:50 Steve French wrote:
> On Tue, Jul 15, 2025 at 3:09 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Monday 14 July 2025 22:28:45 Steve French wrote:
> > > On Mon, Jul 14, 2025 at 4:10 PM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > On Monday 14 July 2025 15:30:26 Steve French wrote:
> > > > > > But generally this is not Linux centric, but rather generic to any other
> > > > > implementations.
> > > > >
> > > > >
> > > > > If they are supporting the SMB311 Linux Extensions why wouldn't they want
> > > > > to support special files? All of the servers which currently support the
> > > > > extensions do
> > > > > Thanks,
> > > >
> > > > Because of that possible filesystem limitation (like fat or proc or fuse).
> > >
> > > That is a moot point because even if the mount has FAT or FUSE mounts
> > > under it, the server can still support reparse points on that share.  A share
> > > often crosses fs type boundaries, so it is always going to be possible to
> > > setup a share where creating special files will work for only some of the
> > > subdirectories - but at least for those cases with the suggested change
> > > we will return a more accurate return code (e.g. EACCES in some cases)
> >
> > That is not fully truth. Crossing a mount point in mounted SMB share is
> > signaled by the new mount point over SMB and so the SMB client is
> > interpreting it like a new share and reading fs attributes for that
> 
> That does not look correct.
> I just tried this to Samba (mounting to the root of my laptop, and cd into
> various subdirectories on various mounts with fs) and none of them triggered
> query fs information.

I have tried it more times against Windows SMB server and it worked
fine. I created mount point on SMB share, which is pointing to different
filesystem on external disk with FAT and it is working fine on recent
Windows Server 2022 and is working fine also on old Windows 2000. So
seems that this is working fine for at least 25 years.

I tried creating mount point via both GUI "diskmgmt.msc" tool (which
allows to choose disk and then select mount point where to mount it on
other disk e.g. C drive) and also via CLI "mountvol" command in cmd.exe,
similar to UNIX mount command.

If it does not work against Samba then it looks like Samba issue.

> > crossed path. Linux SMB client is already doing it and correctly handles
> > crossed mount points. It also shows crosses in the "mount" output.
> 
> Looking at mount output I see no difference after crossing multiple
> mount points under the same share, no automounts were created eg
> and nothing new shows up in /proc/fs/cifs/DebugData or /proc/mounts

When I accessed the mount point then I see a new line appeared in /proc/mounts.

And shell "stat" correctly shows different Device major/minor numbers
for files inside the mount point and on the main share.

> > > > > Steve
> > > > >
> > > > > On Mon, Jul 14, 2025, 2:24 PM Pali Rohár <pali@kernel.org> wrote:
> > > > >
> > > > > > On Monday 14 July 2025 12:31:03 Steve French wrote:
> > > > > > > > It does not matter if the client or server is POSIX or not. Also on
> > > > > > > > POSIX systems there are filesystems without the support for special
> > > > > > > > files and it is common scenario on more UNIX systems that for
> > > > > > particular
> > > > > > > > mount are special files completely disabled for security reasons.
> > > > > > >
> > > > > > > If it is disabled for security reasons, then probably better to still
> > > > > > > send the request and let the server return the correct return code
> > > > > > > (e.g. access denied rather than "not supported").   But for Linux fs
> > > > > > > the only examples I can think of where all special files are disabled
> > > > > > > are VFAT and some pseudo-filesystems like /proc
> > > > > >
> > > > > > In case it is disabled for security reasons and server wants to announce
> > > > > > that it is "available but disabled for security reasons" rather than
> > > > > > "not support at all", then yes it makes sense to send the request and
> > > > > > let it fail with ACCESS error with all those cleanup related issues.
> > > > > > But in this case server should announce the support that it is available
> > > > > > for clients.
> > > > > >
> > > > > > In Linux it is not only VFAT. It is also slightly modern exfat. And also
> > > > > > whatever is connected over fuse to userspace.
> > > > > >
> > > > > > But generally this is not Linux centric, but rather generic to any other
> > > > > > implementations.
> > > > > >
> > > > > > > On Mon, Jul 14, 2025 at 11:58 AM Pali Rohár <pali@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > > > > > > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > > > > > > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > > > > > > > It's an oversight I'm afraid.
> > > > > > > > > >
> > > > > > > > > > hm... it seems reparse points support is mandatory for SMB3 POSIX
> > > > > > so I
> > > > > > > > > > wonder what this additional checks buys us.
> > > > > > > >
> > > > > > > > No. It is not mandatory. Getting or setting of reparse points is done
> > > > > > > > via IOCTLs which are optional. Also fs attribute for reparse points is
> > > > > > > > optional.
> > > > > > > >
> > > > > > > > And that make sense as there are still lot of filesystems which do not
> > > > > > > > support reparse points (e.g. FAT) and this fs attribute is exactly what
> > > > > > > > server announce for clients and applications to tell feature support.
> > > > > > > > So application would know what features are provided and which not on
> > > > > > > > particular share. Server can support reparse points on share A but does
> > > > > > > > not have to support it on share B. E.g. when A is NTFS and B is FAT.
> > > > > > > >
> > > > > > > > > > While I agree that generally we should likely set this, for SMB3
> > > > > > POSIX
> > > > > > > > > > the client should probably not check this and we should keep it
> > > > > > out of
> > > > > > > > > > the spec.
> > > > > > > > >
> > > > > > > > > one additional thought: it seems like a valid scenario to be able to
> > > > > > support
> > > > > > > > > SMB3 POSIX on a server that does not support xattrs on the backing
> > > > > > > > > filesystem and hence may not have a way of storing arbitrary reparse
> > > > > > points.
> > > > > > > >
> > > > > > > > xattrs and reparse points are two completely different things, and they
> > > > > > > > should not be mixed or exchanged.
> > > > > > > >
> > > > > > > > For example FAT on older Windows versions supported xattrs (I'm not
> > > > > > sure
> > > > > > > > if recent Windows version still support them), but does not and never
> > > > > > > > supported reparse points.
> > > > > > > >
> > > > > > > > For checking if xattrs (in MS terminology called Extended Attributes or
> > > > > > > > abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDED_ATTRIBUTES.
> > > > > > > >
> > > > > > > > Again, application can check if server share supports xattrs by this
> > > > > > > > fs attribute and decide what to do next.
> > > > > > > >
> > > > > > > > > In SMB3 POSIX we're just using them as a wire transport, not
> > > > > > necessarily
> > > > > > > > > expecting full support from the server.
> > > > > > > > >
> > > > > > > > > Hence, for Samba I see the following change
> > > > > > > > >
> > > > > > > > >     smbd: announce support for FILE_SUPPORTS_REPARSE_POINTS if the
> > > > > > share
> > > > > > > > > supports EAs
> > > > > > > >
> > > > > > > > FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) !=
> > > > > > FILE_SUPPORTS_REPARSE_POINTS (0x80)
> > > > > > > >
> > > > > > > > > ---
> > > > > > > > >  source3/smbd/vfs.c | 3 +++
> > > > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > > > > > > > > index 76895f52e039..ea3fa4c8784f 100644
> > > > > > > > > --- a/source3/smbd/vfs.c
> > > > > > > > > +++ b/source3/smbd/vfs.c
> > > > > > > > > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(struct
> > > > > > > > > connection_struct *conn,
> > > > > > > > >         if (lp_nt_acl_support(SNUM(conn))) {
> > > > > > > > >                 caps |= FILE_PERSISTENT_ACLS;
> > > > > > > > >         }
> > > > > > > > > +       if (lp_ea_support(SNUM(conn))) {
> > > > > > > > > +               caps |= FILE_SUPPORTS_REPARSE_POINTS;
> > > > > > > > > +       }
> > > > > > > > >
> > > > > > > > >         caps |= lp_parm_int(SNUM(conn), "share", "fake_fscaps", 0);
> > > > > > > > >
> > > > > > > > > https://gitlab.com/samba-team/samba/-/merge_requests/4104
> > > > > > > > >
> > > > > > > > > For the client this would mean, it must allow reparse points for the
> > > > > > special
> > > > > > > > > files if SMB3 POSIX is negotiated.
> > > > > > > > >
> > > > > > > > > Makes sense?
> > > > > > > > >
> > > > > > > > > -slow
> > > > > > > >
> > > > > > > > I do not think that this is a good idea at all. It would just
> > > > > > complicate
> > > > > > > > things, make more incompatibilities and prevent using FAT or any other
> > > > > > > > filesystem without mknod support, including cases when server itself is
> > > > > > > > configured to not support mknod for e.g. security reasons.
> > > > > > > >
> > > > > > > > FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute which says if
> > > > > > the
> > > > > > > > reparse point of any type are supported. If it was decided that special
> > > > > > > > files, like fifos or character devices are represented as reparse
> > > > > > points
> > > > > > > > then for share/filesystem on which are special files supported, server
> > > > > > > > has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > > > > >
> > > > > > > > And if the server itself supports special files, but particular
> > > > > > > > filesystem like FAT does not support it, then server should not
> > > > > > announce
> > > > > > > > the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > > > > >
> > > > > > > > This is how it was designed and how it is used.
> > > > > > > >
> > > > > > > > It does not matter if the client or server is POSIX or not. Also on
> > > > > > > > POSIX systems there are filesystems without the support for special
> > > > > > > > files and it is common scenario on more UNIX systems that for
> > > > > > particular
> > > > > > > > mount are special files completely disabled for security reasons.
> > > > > > > >
> > > > > > > >
> > > > > > > > So the result is that also when POSIX extensions are negotiated, it is
> > > > > > > > important and required to know by POSIX client whether particular
> > > > > > > > exported share supports reparse points / special files or not.
> > > > > > > > And FILE_SUPPORTS_REPARSE_POINTS is already there for it.
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Thanks,
> > > > > > >
> > > > > > > Steve
> > > > > >
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
