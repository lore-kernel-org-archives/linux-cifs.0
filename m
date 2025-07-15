Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7034545
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 20:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752609915; cv=none; b=o4Fkwo08pjt0zNRT/0G0S8r/gv8sSPObrCBeRKAI+m2wx7kJxSppW67IMEcsVs/NTukyV6DxS+xOGErRsaiq8cW1+FJO+VF/9adqYDMgDGVyQ7UiOpFQQqyOh+z4fV1PPuy86qRYwrFJEyoZcs9CXQlPDLgN1jb2oKSMgxMEAuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752609915; c=relaxed/simple;
	bh=6PsuNWjKXzOjPPrWAPiyXjrjDhGYJBon8ciVer8e9nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtY8n8rTgEDg2CKcE+CvgXMMlnQxjEl5YNHJZS+zTmkJVjcfyG4J7gGZ6wILtFjJzzzyBqh5jLaODIrtqa9S8hwzqx0oW0pHFqrUbzoikN+M9SHpOcZaAzrM9h3JE0l4izVSk5PF49e2IB7pJX0vOwPdR+ZjCyN/VqBEL98h2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLKao4ii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLKao4ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CC0C4CEE3;
	Tue, 15 Jul 2025 20:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752609914;
	bh=6PsuNWjKXzOjPPrWAPiyXjrjDhGYJBon8ciVer8e9nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RLKao4iiMXFRI4ofgHP3LGbTVsZ9PPY/t/ZBn0+4K7PL4KnCCIv9/tiwl8cfhbKfl
	 kojejjmosFfOiN17pnPBfLUO9/I57RYSnyp7lXcSTlL+9g6KSe3BBhB9d+e8don+Xl
	 HcUKyXYWQiUmql4pfV4W5DQrdtsmuG6U6Qq+/gkuRnkaQiv5Vxi8WjQBv7bsnwLPWY
	 yWxtmWagbKcw5zNXm7PbZi8eD2maAFPu/+6L6gFLE1tpdNa2S5c9m2vQl45Pi+38h4
	 U/MixHPTew8LqZArvEUW9RuMxV/sq1efKBBzfO9NKwbWAqoKb2fMTZ0DwzAKY7T8Xg
	 OTAgHXL07if6Q==
Received: by pali.im (Postfix)
	id 8B88495B; Tue, 15 Jul 2025 22:05:12 +0200 (CEST)
Date: Tue, 15 Jul 2025 22:05:12 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>,
	"vl@samba.org" <vl@samba.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Samba support for creating special files (via reparse points)
Message-ID: <20250715200512.k2domft463is4du5@pali>
References: <20250714165844.4hctlrwegfspiius@pali>
 <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
 <20250714192404.j3dw6l3afgm2voe6@pali>
 <CAH2r5msRGGHyy0GdNgVYBVN+8NzfevDS-wtzr9TO5jF5NmoxHQ@mail.gmail.com>
 <20250714211016.zqddwjdvybeplgdf@pali>
 <CAH2r5mumdvhWTNOCEGV-dT8aQVJrUQEDep0GEBn_CbKF+o3kjQ@mail.gmail.com>
 <20250715080911.julhkkcf7an56q4w@pali>
 <CAH2r5mvAuffmNwgJZ=n3m4aj4Xn45unK1ENPEdL_=pG-S3XHCw@mail.gmail.com>
 <20250715174321.7xko6gtmmlfsrjze@pali>
 <CAH2r5muQPRjpzWFLNJirhNjJ=DyJNusg-oNYOtQdxc2d-A7Hog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muQPRjpzWFLNJirhNjJ=DyJNusg-oNYOtQdxc2d-A7Hog@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Tuesday 15 July 2025 14:54:31 Steve French wrote:
> On Tue, Jul 15, 2025 at 12:43 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Tuesday 15 July 2025 12:07:50 Steve French wrote:
> > > On Tue, Jul 15, 2025 at 3:09 AM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > On Monday 14 July 2025 22:28:45 Steve French wrote:
> > > > > On Mon, Jul 14, 2025 at 4:10 PM Pali Rohár <pali@kernel.org> wrote:
> > > > > >
> > > > > > On Monday 14 July 2025 15:30:26 Steve French wrote:
> > > > > > > > But generally this is not Linux centric, but rather generic to any other
> > > > > > > implementations.
> > > > > > >
> > > > > > >
> > > > > > > If they are supporting the SMB311 Linux Extensions why wouldn't they want
> > > > > > > to support special files? All of the servers which currently support the
> > > > > > > extensions do
> > > > > > > Thanks,
> > > > > >
> > > > > > Because of that possible filesystem limitation (like fat or proc or fuse).
> > > > >
> > > > > That is a moot point because even if the mount has FAT or FUSE mounts
> > > > > under it, the server can still support reparse points on that share.  A share
> > > > > often crosses fs type boundaries, so it is always going to be possible to
> > > > > setup a share where creating special files will work for only some of the
> > > > > subdirectories - but at least for those cases with the suggested change
> > > > > we will return a more accurate return code (e.g. EACCES in some cases)
> > > >
> > > > That is not fully truth. Crossing a mount point in mounted SMB share is
> > > > signaled by the new mount point over SMB and so the SMB client is
> > > > interpreting it like a new share and reading fs attributes for that
> > >
> > > That does not look correct.
> > > I just tried this to Samba (mounting to the root of my laptop, and cd into
> > > various subdirectories on various mounts with fs) and none of them triggered
> > > query fs information.
> >
> > I have tried it more times against Windows SMB server and it worked
> > fine. I created mount point on SMB share, which is pointing to different
> > filesystem on external disk with FAT and it is working fine on recent
> > Windows Server 2022 and is working fine also on old Windows 2000. So
> > seems that this is working fine for at least 25 years.
> >
> > I tried creating mount point via both GUI "diskmgmt.msc" tool (which
> > allows to choose disk and then select mount point where to mount it on
> > other disk e.g. C drive) and also via CLI "mountvol" command in cmd.exe,
> > similar to UNIX mount command.
> >
> > If it does not work against Samba then it looks like Samba issue.
> 
> Not necessarily, but in any case until Windows supports SMB3.1.1 POSIX
> extensions
> it is moot point for the change to correctly check if SMB3.1.1 POSIX Extensions
> (not just check if the fsattr for supporting reparse points) is set.
> Obviously a server
> can (and will) support special files with SMB3.1.1 POSIX (emulating
> them as reparse points over
> the wire, but storing them however the server thinks is best) but some
> will not support reparse points
> generally (just in the narrow case for SMB3.1.1 POSIX Extensions)

But mount point support which I was referring here is not POSIX
extension specific. It is already there without POSIX extension support
and available by Windows SMB server for at least 25 years in SMB1, SMB2
and SMB3. I checked them with older Windows version to verify it.

So any SMB server, with or without extensions, in any version, can
support it if it wants.

And I hope so that POSIX based SMB servers like Samba would support
correctly announcing of mount points over SMB and on POSIX systems it is
more common to have crossing mount points. On Windows systems it is less
common, but possible and it is already working.

> > > > crossed path. Linux SMB client is already doing it and correctly handles
> > > > crossed mount points. It also shows crosses in the "mount" output.
> > >
> > > Looking at mount output I see no difference after crossing multiple
> > > mount points under the same share, no automounts were created eg
> > > and nothing new shows up in /proc/fs/cifs/DebugData or /proc/mounts
> >
> > When I accessed the mount point then I see a new line appeared in /proc/mounts.
> >
> > And shell "stat" correctly shows different Device major/minor numbers
> > for files inside the mount point and on the main share.
> 
> That is not the case to Samba (and presumably to some other servers as
> well) although
> it may be for Windows.   Windows handles junctions/links pointing to
> different drives much
> differently than Linux so am not surprised that the behavior differs.

Here were are talking about mount points which are represented by
special reparse point, plus on Windows registered in system itself.
Accessing it on Windows is very similar or maybe same as on Unix
systems = just access the path and it works automatically, no special
thing is required. And "smart" application can do "stat" (on UNIX) or
"getsomething" (on Windows; do not know exact function) to figure out if
is crossing mount point or not. It is really "mounted" filesystem on top
of another filesystem on both Windows and Linux.

Just creating such thing is different -- but this is not important here
as over network protocol we are not creating new mount points, just
accessing existing.

> > > > > > > Steve
> > > > > > >
> > > > > > > On Mon, Jul 14, 2025, 2:24 PM Pali Rohár <pali@kernel.org> wrote:
> > > > > > >
> > > > > > > > On Monday 14 July 2025 12:31:03 Steve French wrote:
> > > > > > > > > > It does not matter if the client or server is POSIX or not. Also on
> > > > > > > > > > POSIX systems there are filesystems without the support for special
> > > > > > > > > > files and it is common scenario on more UNIX systems that for
> > > > > > > > particular
> > > > > > > > > > mount are special files completely disabled for security reasons.
> > > > > > > > >
> > > > > > > > > If it is disabled for security reasons, then probably better to still
> > > > > > > > > send the request and let the server return the correct return code
> > > > > > > > > (e.g. access denied rather than "not supported").   But for Linux fs
> > > > > > > > > the only examples I can think of where all special files are disabled
> > > > > > > > > are VFAT and some pseudo-filesystems like /proc
> > > > > > > >
> > > > > > > > In case it is disabled for security reasons and server wants to announce
> > > > > > > > that it is "available but disabled for security reasons" rather than
> > > > > > > > "not support at all", then yes it makes sense to send the request and
> > > > > > > > let it fail with ACCESS error with all those cleanup related issues.
> > > > > > > > But in this case server should announce the support that it is available
> > > > > > > > for clients.
> > > > > > > >
> > > > > > > > In Linux it is not only VFAT. It is also slightly modern exfat. And also
> > > > > > > > whatever is connected over fuse to userspace.
> > > > > > > >
> > > > > > > > But generally this is not Linux centric, but rather generic to any other
> > > > > > > > implementations.
> > > > > > > >
> > > > > > > > > On Mon, Jul 14, 2025 at 11:58 AM Pali Rohár <pali@kernel.org> wrote:
> > > > > > > > > >
> > > > > > > > > > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > > > > > > > > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > > > > > > > > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > > > > > > > > > It's an oversight I'm afraid.
> > > > > > > > > > > >
> > > > > > > > > > > > hm... it seems reparse points support is mandatory for SMB3 POSIX
> > > > > > > > so I
> > > > > > > > > > > > wonder what this additional checks buys us.
> > > > > > > > > >
> > > > > > > > > > No. It is not mandatory. Getting or setting of reparse points is done
> > > > > > > > > > via IOCTLs which are optional. Also fs attribute for reparse points is
> > > > > > > > > > optional.
> > > > > > > > > >
> > > > > > > > > > And that make sense as there are still lot of filesystems which do not
> > > > > > > > > > support reparse points (e.g. FAT) and this fs attribute is exactly what
> > > > > > > > > > server announce for clients and applications to tell feature support.
> > > > > > > > > > So application would know what features are provided and which not on
> > > > > > > > > > particular share. Server can support reparse points on share A but does
> > > > > > > > > > not have to support it on share B. E.g. when A is NTFS and B is FAT.
> > > > > > > > > >
> > > > > > > > > > > > While I agree that generally we should likely set this, for SMB3
> > > > > > > > POSIX
> > > > > > > > > > > > the client should probably not check this and we should keep it
> > > > > > > > out of
> > > > > > > > > > > > the spec.
> > > > > > > > > > >
> > > > > > > > > > > one additional thought: it seems like a valid scenario to be able to
> > > > > > > > support
> > > > > > > > > > > SMB3 POSIX on a server that does not support xattrs on the backing
> > > > > > > > > > > filesystem and hence may not have a way of storing arbitrary reparse
> > > > > > > > points.
> > > > > > > > > >
> > > > > > > > > > xattrs and reparse points are two completely different things, and they
> > > > > > > > > > should not be mixed or exchanged.
> > > > > > > > > >
> > > > > > > > > > For example FAT on older Windows versions supported xattrs (I'm not
> > > > > > > > sure
> > > > > > > > > > if recent Windows version still support them), but does not and never
> > > > > > > > > > supported reparse points.
> > > > > > > > > >
> > > > > > > > > > For checking if xattrs (in MS terminology called Extended Attributes or
> > > > > > > > > > abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDED_ATTRIBUTES.
> > > > > > > > > >
> > > > > > > > > > Again, application can check if server share supports xattrs by this
> > > > > > > > > > fs attribute and decide what to do next.
> > > > > > > > > >
> > > > > > > > > > > In SMB3 POSIX we're just using them as a wire transport, not
> > > > > > > > necessarily
> > > > > > > > > > > expecting full support from the server.
> > > > > > > > > > >
> > > > > > > > > > > Hence, for Samba I see the following change
> > > > > > > > > > >
> > > > > > > > > > >     smbd: announce support for FILE_SUPPORTS_REPARSE_POINTS if the
> > > > > > > > share
> > > > > > > > > > > supports EAs
> > > > > > > > > >
> > > > > > > > > > FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) !=
> > > > > > > > FILE_SUPPORTS_REPARSE_POINTS (0x80)
> > > > > > > > > >
> > > > > > > > > > > ---
> > > > > > > > > > >  source3/smbd/vfs.c | 3 +++
> > > > > > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > > > > > > > > > > index 76895f52e039..ea3fa4c8784f 100644
> > > > > > > > > > > --- a/source3/smbd/vfs.c
> > > > > > > > > > > +++ b/source3/smbd/vfs.c
> > > > > > > > > > > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(struct
> > > > > > > > > > > connection_struct *conn,
> > > > > > > > > > >         if (lp_nt_acl_support(SNUM(conn))) {
> > > > > > > > > > >                 caps |= FILE_PERSISTENT_ACLS;
> > > > > > > > > > >         }
> > > > > > > > > > > +       if (lp_ea_support(SNUM(conn))) {
> > > > > > > > > > > +               caps |= FILE_SUPPORTS_REPARSE_POINTS;
> > > > > > > > > > > +       }
> > > > > > > > > > >
> > > > > > > > > > >         caps |= lp_parm_int(SNUM(conn), "share", "fake_fscaps", 0);
> > > > > > > > > > >
> > > > > > > > > > > https://gitlab.com/samba-team/samba/-/merge_requests/4104
> > > > > > > > > > >
> > > > > > > > > > > For the client this would mean, it must allow reparse points for the
> > > > > > > > special
> > > > > > > > > > > files if SMB3 POSIX is negotiated.
> > > > > > > > > > >
> > > > > > > > > > > Makes sense?
> > > > > > > > > > >
> > > > > > > > > > > -slow
> > > > > > > > > >
> > > > > > > > > > I do not think that this is a good idea at all. It would just
> > > > > > > > complicate
> > > > > > > > > > things, make more incompatibilities and prevent using FAT or any other
> > > > > > > > > > filesystem without mknod support, including cases when server itself is
> > > > > > > > > > configured to not support mknod for e.g. security reasons.
> > > > > > > > > >
> > > > > > > > > > FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute which says if
> > > > > > > > the
> > > > > > > > > > reparse point of any type are supported. If it was decided that special
> > > > > > > > > > files, like fifos or character devices are represented as reparse
> > > > > > > > points
> > > > > > > > > > then for share/filesystem on which are special files supported, server
> > > > > > > > > > has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > > > > > > >
> > > > > > > > > > And if the server itself supports special files, but particular
> > > > > > > > > > filesystem like FAT does not support it, then server should not
> > > > > > > > announce
> > > > > > > > > > the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > > > > > > >
> > > > > > > > > > This is how it was designed and how it is used.
> > > > > > > > > >
> > > > > > > > > > It does not matter if the client or server is POSIX or not. Also on
> > > > > > > > > > POSIX systems there are filesystems without the support for special
> > > > > > > > > > files and it is common scenario on more UNIX systems that for
> > > > > > > > particular
> > > > > > > > > > mount are special files completely disabled for security reasons.
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > So the result is that also when POSIX extensions are negotiated, it is
> > > > > > > > > > important and required to know by POSIX client whether particular
> > > > > > > > > > exported share supports reparse points / special files or not.
> > > > > > > > > > And FILE_SUPPORTS_REPARSE_POINTS is already there for it.
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
