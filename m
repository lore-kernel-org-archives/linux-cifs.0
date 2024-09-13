Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145387489;
	Fri, 13 Sep 2024 22:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726267557; cv=none; b=NysMfcj6TakmlXg4gRaUK/bXMVeurtYjRtr7BnS5AS2zViB4jfuTLEbNkbwtvMPsSZdJw7oZRoSXuwvNqkEuS/Rr4CY7iWnynDbAZmrbPFcH5RvKYliacTVRooc+mgha72lBHCgvWaHV8OxxAd9QygxuH74C7zXfuoCsVUw5mW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726267557; c=relaxed/simple;
	bh=myl4NhahxrGqZ/mFtRCKp9aHtsE2z+lA/LBN1a+GZGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJfe3ufzUW1UNOcqAwIf4/Ut/s/FnceU7RidWBSnEG4nhiqw8FMS7+b8sChD6A0DKX9qLl0aiN6twrIi6Y22jAaax68ECr9kt7nTSFNn+CO2XkdC3S4y9VmrKv1UFatepo2kQzS18jgGQoBCJKmMTWzRlCQfuxP4oaJuGG4/YkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sosoVW5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sosoVW5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94701C4CEC0;
	Fri, 13 Sep 2024 22:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726267556;
	bh=myl4NhahxrGqZ/mFtRCKp9aHtsE2z+lA/LBN1a+GZGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sosoVW5i7IOGOxHes+x4sTqpVtVPLW6VgDnlht9z2oMSXzbDvu7QnwVMqRJkVzxFx
	 dehFVTJEIQTvOIw6uVr/Dj7uwrfF9l+Vn1nRBmQhgeIMZBoR6XAaX1E0jb4/qKxoAI
	 9hGBJustWWWqPdAtIgvOAuNZYPTZPtNqdZxyJU/Y9aleL/DSqgTTtoWN2nSuE1TrZ/
	 mnDbq19f1oxkVt5BE2gSj2oZV9ZAvoQN6n30xoOgdWswHxC+Fw/R8KnRu/sQZ5GxFx
	 7NY9UK1RVWm837qdfGkU6G9fyGmOCVeG2tcij0J897bUV0TJoc6LkUPA5gZg6lOt4I
	 pgzBWVKFXM6Jg==
Received: by pali.im (Postfix)
	id 82402725; Sat, 14 Sep 2024 00:45:51 +0200 (CEST)
Date: Sat, 14 Sep 2024 00:45:51 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special
 files
Message-ID: <20240913224551.xf3tfxohvqwoloy7@pali>
References: <20240912120548.15877-1-pali@kernel.org>
 <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali>
 <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
 <CAH2r5mskDvz2-iAYY8mknuBVtPq_C5sQyggYEwDivtGPc83B1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mskDvz2-iAYY8mknuBVtPq_C5sQyggYEwDivtGPc83B1g@mail.gmail.com>
User-Agent: NeoMutt/20180716

Yes, but it was enabled also before this patch series.

Now I have checked that even old Linux 4.19 cifs kernel client detects
empty file with system attribute as fifo. This functionality is there
for a long time. Probably since first cifs/sfu version.

On Friday 13 September 2024 17:33:22 Steve French wrote:
> One other thing which worried me a bit is that I confirmed that an
> empty file with the system attribute set was matched as a FIFO file
> type (when you mount with "sfu") - this seems risky.
> 
> On Fri, Sep 13, 2024 at 5:14 PM Steve French <smfrench@gmail.com> wrote:
> >
> > How did you find the format of the FIFO and SOCK file types?  I
> > couldn't find any references to those so added two new types to allow
> > current Linux to be able to create these (especially since they are
> > opaque to the server and thus low risk).
> >
> > > +     case S_IFSOCK:
> > > -             strscpy(pdev.type, "LnxSOCK");
> > > +             /* SFU socket is system file with one zero byte */
> > > +             pdev_len = 1;
> > > +             pdev.type[0] = '\0';
> > >               break;
> > >       case S_IFIFO:
> > > -             strscpy(pdev.type, "LnxFIFO");
> > > +             /* SFU fifo is system file which is empty */
> > > +             pdev_len = 0;
> >
> > My worry about the suggested change above is that it is possible that
> > we could accidentally match to an empty file. We intentionally added
> > the two new dev.type fields for these to avoid collisions with other
> > things (and since they are Linux specific).  It seems risky to have an
> > empty file with the system attribute marked as a FIFO, and similarly a
> > file with one byte null as Socket.   Since this is for only the Linux
> > client to recognize, I wanted to do something safe for those file
> > types less likely to be confusing (ie strings for Socket and FIFO that
> > were similar in length and format to the other special files seemed
> > intuitive) and "LnxFIFO" and LnxSOCK" were used as the tags in the
> > file to reduce confusion ie the tags for those two start with "Lnx" -
> > ie "something used for Linux client" not related to the original
> > Interix (those begin with "Intx").
> >
> > Note that in the long run we hope to use reparse points by default in
> > more servers to store special files like this but there are a few
> > cases for unusual workloads that need special file support that would
> > have to use sfu still.  The newer reparse tags that Windows uses "WSL"
> > have the advantage that they require fewer roundtrips to query (since
> > the file type is in the reparse tag).
> >
> > Also noticed an interesting problem when mounted with "sfu" -
> > "smbgetinfo filebasicinfo /mnt/fifo1" will hang (in sys_open).  Is
> > that expected for a FIFO?
> >
> > On Fri, Sep 13, 2024 at 3:07 PM Pali Rohár <pali@kernel.org> wrote:
> > >
> > > On Thursday 12 September 2024 14:05:47 Pali Rohár wrote:
> > > > SFU-style fifo is empty file with system attribute set. This format is used
> > > > by old Microsoft POSIX subsystem and later also by OpenNT/Interix subsystem
> > > > (which replaced Microsoft POSIX subsystem and is part of Microsoft SFU).
> > > >
> > > > SFU-style socket is file which has system attribute set and file content is
> > > > one zero byte. This format was introduced in Interix 3.0 subsystem, as part
> > > > of the Microsoft SFU 3.0 and is used also by all later versions. Previous
> > > > versions had no UNIX domain socket support.
> > > >
> > > > Currently when sfu mount option is specified then CIFS creates fifo and
> > > > socket special files with some strange LnxSOCK or LnxFIFO content which is
> > > > not compatible with Microsoft SFU and neither recognized by other SMB
> > > > implementations which have some SFU support, including older Linux cifs
> > > > implementations.
> > > >
> > > > So when sfu mount option is specified, create all fifo and socket special
> > > > files compatible with SFU format to achieve SFU interop, as it is expected
> > > > by sfu mount option.
> > > >
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > >
> > > Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu" mount option")
> > > Fixes: 518549c120e6 ("cifs: fix creating sockets when using sfu mount options")
> > >
> > > I located commits which introduced those strange LnxSOCK or LnxFIFO
> > > types which are not compatible with SFU. I would suggest to add those
> > > two Fixes: tags into commit message for reference.
> > >
> > > > ---
> > > >  fs/smb/client/cifssmb.c |  8 ++++----
> > > >  fs/smb/client/smb1ops.c |  2 +-
> > > >  fs/smb/client/smb2ops.c | 29 +++++++++++++++++++----------
> > > >  3 files changed, 24 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > > > index cfae2e918209..0ffc45aa5e2c 100644
> > > > --- a/fs/smb/client/cifssmb.c
> > > > +++ b/fs/smb/client/cifssmb.c
> > > > @@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
> > > >       pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
> > > >       pSMB->Mode = cpu_to_le16(access_flags_to_smbopen_mode(access_flags));
> > > >       pSMB->Mode |= cpu_to_le16(0x40); /* deny none */
> > > > -     /* set file as system file if special file such
> > > > -        as fifo and server expecting SFU style and
> > > > +     /* set file as system file if special file such as fifo,
> > > > +      * socket, char or block and server expecting SFU style and
> > > >          no Unix extensions */
> > > >
> > > >       if (create_options & CREATE_OPTION_SPECIAL)
> > > > @@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
> > > >       req->AllocationSize = 0;
> > > >
> > > >       /*
> > > > -      * Set file as system file if special file such as fifo and server
> > > > -      * expecting SFU style and no Unix extensions.
> > > > +      * Set file as system file if special file such as fifo, socket, char
> > > > +      * or block and server expecting SFU style and no Unix extensions.
> > > >        */
> > > >       if (create_options & CREATE_OPTION_SPECIAL)
> > > >               req->FileAttributes = cpu_to_le32(ATTR_SYSTEM);
> > > > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > > > index e1f2feb56f45..e03c91a49650 100644
> > > > --- a/fs/smb/client/smb1ops.c
> > > > +++ b/fs/smb/client/smb1ops.c
> > > > @@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
> > > >       /*
> > > >        * Check if mounted with mount parm 'sfu' mount parm.
> > > >        * SFU emulation should work with all servers, but only
> > > > -      * supports block and char device (no socket & fifo),
> > > > +      * supports block and char device, socket & fifo,
> > > >        * and was used by default in earlier versions of Windows
> > > >        */
> > > >       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
> > > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > > index 9c2d065d3cc4..9e90672caf60 100644
> > > > --- a/fs/smb/client/smb2ops.c
> > > > +++ b/fs/smb/client/smb2ops.c
> > > > @@ -5066,26 +5066,32 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > > >       struct cifs_fid fid;
> > > >       unsigned int bytes_written;
> > > >       struct win_dev pdev = {};
> > > > +     size_t pdev_len = 0;
> > > >       struct kvec iov[2];
> > > >       __u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
> > > >       int rc;
> > > >
> > > >       switch (mode & S_IFMT) {
> > > >       case S_IFCHR:
> > > > +             pdev_len = sizeof(pdev);
> > > >               memcpy(pdev.type, "IntxCHR\0", 8);
> > > >               pdev.major = cpu_to_le64(MAJOR(dev));
> > > >               pdev.minor = cpu_to_le64(MINOR(dev));
> > > >               break;
> > > >       case S_IFBLK:
> > > > +             pdev_len = sizeof(pdev);
> > > >               memcpy(pdev.type, "IntxBLK\0", 8);
> > > >               pdev.major = cpu_to_le64(MAJOR(dev));
> > > >               pdev.minor = cpu_to_le64(MINOR(dev));
> > > >               break;
> > > >       case S_IFSOCK:
> > > > -             strscpy(pdev.type, "LnxSOCK");
> > > > +             /* SFU socket is system file with one zero byte */
> > > > +             pdev_len = 1;
> > > > +             pdev.type[0] = '\0';
> > > >               break;
> > > >       case S_IFIFO:
> > > > -             strscpy(pdev.type, "LnxFIFO");
> > > > +             /* SFU fifo is system file which is empty */
> > > > +             pdev_len = 0;
> > > >               break;
> > > >       default:
> > > >               return -EPERM;
> > > > @@ -5100,14 +5106,17 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > > >       if (rc)
> > > >               return rc;
> > > >
> > > > -     io_parms.pid = current->tgid;
> > > > -     io_parms.tcon = tcon;
> > > > -     io_parms.length = sizeof(pdev);
> > > > -     iov[1].iov_base = &pdev;
> > > > -     iov[1].iov_len = sizeof(pdev);
> > > > +     if (pdev_len > 0) {
> > > > +             io_parms.pid = current->tgid;
> > > > +             io_parms.tcon = tcon;
> > > > +             io_parms.length = pdev_len;
> > > > +             iov[1].iov_base = &pdev;
> > > > +             iov[1].iov_len = pdev_len;
> > > > +
> > > > +             rc = server->ops->sync_write(xid, &fid, &io_parms,
> > > > +                                          &bytes_written, iov, 1);
> > > > +     }
> > > >
> > > > -     rc = server->ops->sync_write(xid, &fid, &io_parms,
> > > > -                                  &bytes_written, iov, 1);
> > > >       server->ops->close(xid, tcon, &fid);
> > > >       return rc;
> > > >  }
> > > > @@ -5149,7 +5158,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
> > > >       /*
> > > >        * Check if mounted with mount parm 'sfu' mount parm.
> > > >        * SFU emulation should work with all servers, but only
> > > > -      * supports block and char device (no socket & fifo),
> > > > +      * supports block and char device, socket & fifo,
> > > >        * and was used by default in earlier versions of Windows
> > > >        */
> > > >       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> > > > --
> > > > 2.20.1
> > > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
