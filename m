Received: from na1pdmzitismtp01.tibco.com (na1pdmzitismtp01.tibco.com [160.101.131.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086553911AD;
	Wed, 24 Jun 2026 07:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.101.131.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285573; cv=none; b=tLcXNQQDamFkNrXbPGwY64TZu0itTKyvEuB5RGchx5q/LqmTsduxpZo1tnz5GfhXzsLFsrn4mjs3scwWBXRqlUOczt/yWDVdoJlH/K1i42n+Hv4jbveuZXsCwNB8iJlYyr4eYEf+KjKK5a8aFkJpXLocDMnDuPWYcfDnCKv80IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285573; c=relaxed/simple;
	bh=l2peuH0t6pWMmt5S0cR0RzEKpKWovxlwRicPjW3wjnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZLP8swE14KK5SbWIfB/dprydVvreDLdsl1DzMcz/nbpGhkt4qRe9TB1m8ev4WtL8YdOQnp6roFSKzWhvphNWoUgA2OpA8zttZ7s3xhl2p4OvpMaCYoafmYVMtaQ04x8UwBEy4Fl3xg8H8ruItGIwEdVP3HfPs+wd4aa6FaFgtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; arc=none smtp.client-ip=160.101.131.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Received: from eddie6.eng.citrite.net (unknown [10.113.40.46])
	by na1pdmzitismtp01.tibco.com (Postfix) with ESMTP id 86A084393485;
	Wed, 24 Jun 2026 03:18:13 -0400 (EDT)
From: Chunjie Zhu <chunjie.zhu@citrix.com>
To: ematsumiya@suse.de
Cc: chunjie.zhu@citrix.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lsahlber@redhat.com,
	pc@manguebit.com,
	samba-technical@lists.samba.org,
	sfrench@samba.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com
Subject: Re: Subject: Re: [PATCH] fix smb client defer close causes file
Date: Wed, 24 Jun 2026 07:19:29 +0000
Message-ID: <20260624071929.6225-1-chunjie.zhu@citrix.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <ajtYUL_7qdzu21mx@suse.de>
References: <ajtYUL_7qdzu21mx@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It looks like it's not enough to mark a reused file handle by only file path.
Is there any plan to update it?
 
> As for the original bug report, do you happen to have a simple
> reproducer?
> 
> I created one on top of your instructions and I'm definitely getting a
> lease break on rename, which IIUC is the alleged root cause.
> This was with closetimeo=30 on a Windows Server 2022 share.

4 clients shared mount looks simple. Currently I do not have a simpler
reproduce step or script.

> Also, I'm failing to understand how cache= has any impact on this -- I
> get the same successful results with none,loose,strict.

In real tests with cache=none, we cannot see the symptom, by disabling
cache/buffer, client goes back to the server more directly, and stale cached
data/metadata windows shrink.

> 
> Cheers,
> 
> Enzo
> 
> >> Other narrower client fixes for this presumably could be done, e.g.
> >> forcing close on the deferred close when rename a hardlink.
> >>
> >> On Mon, Jun 22, 2026 at 4:40=E2=80=AFAM Chunjie Zhu <chunjie.zhu@citrix.com=
> >> > wrote:
> >> >
> >> > Test environment
> >> >
> >> >  4 hosts as smb client, 1 host as smb server
> >> >  smb client hosts, kernel 6.6.138
> >> >  mount options,
> >> >   //10.70.48.15/xxx /run/xxx cifs rw,relatime,vers=3D3.0,
> >> >   cache=3Dloose,username=3Dxxx,domain=3Dxxx,uid=3D0,noforceuid,
> >> >   gid=3D0,noforcegid,addr=3D10.70.48.15,file_mode=3D0755,
> >> >   dir_mode=3D0755,soft,nounix,serverino,mapposix,reparse=3Dnfs,
> >> >   rsize=3D1048576,wsize=3D1048576,bsize=3D1048576,echo_interval=3D60,
> >> >   actimeo=3D0,closetimeo=3D1
> >> >
> >> > Work around
> >> >
> >> >  mount with cache=3Dnone or closetimeo=3D0
> >> >
> >> > The Race Condition Flow
> >> >
> >> >  Step 1: Host-01 closes file
> >> >
> >> >   Host-01:
> >> >    file close (eeefe8d0.vhd)
> >> >    -> CIFS defers SMB2 CLOSE
> >> >    -> Handle H1 stored in deferred_closes list
> >> >    -> Lease L1 (RWH or RH) still active on server
> >> >    -> Entry: { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=
> >> =3DI1 }
> >> >
> >> >  Step 2: Host-02 does hardlink and rename
> >> >
> >> >   Host-02:
> >> >    hardlink(eeefe8d0.vhd, 0f11b74e.vhd)
> >> >    -> SMB2: Creates new name for same inode
> >> >    -> Server: inode I1 now has 2 names (link count =3D 2)
> >> >    -> Host-01 lease L1: NO BREAK (same inode, just added name)
> >> >
> >> >    crate(eeefe8d0.vhd.new)
> >> >    -> Entry { path=3D"eeefe8d0.vhd.new", handle=3DH2, inode=3DI2 }
> >> >
> >> >    rename(eeefe8d0.vhd.new, eeefe8d0.vhd)
> >> >    -> SMB2: Replaces =E2=80=9Ceeefe8d0.vhd=E2=80=9D name =E2=86=92 points=
> >>  to new inode I2
> >> >    -> Server: old inode I1 now only accessible as =E2=80=9C0f11b74e.vhd=
> >> =E2=80=9D
> >> >    -> Server SHOULD send: Lease Break notification to H1 =E2=86=90 KEY!
> >> >
> >> >  Step 3: Lease break delivery is not reliable
> >> >
> >> >   strict locking off, level2 oplock
> >> >
> >> >    Host-01:
> >> >    -> Lease break not received or processed
> >> >    -> H1 is in deferred_closes list (not "active")
> >> >
> >> >    Result: Stale entry remains:
> >> >       { path=3D=E2=80=9Ceeefe8d0.vhd=E2=80=9D, handle=3DH1, inode=3DI1_OL=
> >> D }
> >> >
> >> >    Host-02:
> >> >    -> Open 0f11b74e.vhd in readonly
> >> >
> >> >    Result:
> >> >       { path=3D"0f11b74e.vhd", inode=3DI1_NEW }
> >> >
> >> >  Step 4: Host-01 reopens file
> >> >
> >> >   Host-01:
> >> >    file open (eeefe8d0.vhd)
> >> >    -> Kernel checks deferred_closes for =E2=80=9Ceeefe8d0.vhd=E2=80=9D
> >> >    -> Found H1! (matched by pathname string)
> >> >    -> REUSES H1 without checking
> >> >    -> close or reconnect, flush buffered writes
> >> >       slient corruption?
> >> >
> >> > Signed-off-by: Chunjie Zhu <chunjie.zhu@citrix.com>
> >> > ---
> >> >  fs/smb/client/fs_context.c | 8 ++++----
> >> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >> >
> >> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> >> > index 0812af001417..4ed33de0a00d 100644
> >> > --- a/fs/smb/client/fs_context.c
> >> > +++ b/fs/smb/client/fs_context.c
> >> > @@ -1300,11 +1300,11 @@ static int smb3_fs_context_parse_param(struct fs_=
> >> context *fc,
> >> >                 ctx->acdirmax =3D ctx->acregmax =3D HZ * result.uint_32;
> >> >                 break;
> >> >         case Opt_closetimeo:
> >> > -               if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
> >> > -                       cifs_errorf(fc, "closetimeo too large\n");
> >> > +               if (result.uint_32 !=3D 0) {
> >> > +                       cifs_errorf(fc, "closetimeo must be 0, deferred c=
> >> lose is disabled\n");
> >> >                         goto cifs_parse_mount_err;
> >> >                 }
> >> > -               ctx->closetimeo =3D HZ * result.uint_32;
> >> > +               ctx->closetimeo =3D 0;
> >> >                 break;
> >> >         case Opt_echo_interval:
> >> >                 if (result.uint_32 < SMB_ECHO_INTERVAL_MIN ||
> >> > @@ -1795,7 +1795,7 @@ int smb3_init_fs_context(struct fs_context *fc)
> >> >
> >> >         ctx->acregmax =3D CIFS_DEF_ACTIMEO;
> >> >         ctx->acdirmax =3D CIFS_DEF_ACTIMEO;
> >> > -       ctx->closetimeo =3D SMB3_DEF_DCLOSETIMEO;
> >> > +       ctx->closetimeo =3D 0;
> >> >         ctx->max_cached_dirs =3D MAX_CACHED_FIDS;
> >> >         /* Most clients set timeout to 0, allows server to use its defaul=
> >> t */
> >> >         ctx->handle_timeout =3D 0; /* See MS-SMB2 spec section 2.2.14.2.1=
> >> 2 */
> >> > --
> >> > 2.52.0
> >> >
> >> >
> >>
> >>
> >> --=20
> >> Thanks,
> >>
> >> Steve
> >>
> >
> 
