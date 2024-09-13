Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A3ED502;
	Fri, 13 Sep 2024 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726267374; cv=none; b=d6z90Hj2+/xqfc86Wx2/9JL6ZwSAuDbuiyeDK02HW0Q3M3Q3K2336YxzhaotaJ6BclsbHUCDmHEHA6TT4vxEoYrY9KVAY+5vnCpx7ClncK8nwWqigt4d6gy4V0bzvb1VViwjQUKjWyTijeoDp4d4MUS640amAxWqqBm9ozTZM4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726267374; c=relaxed/simple;
	bh=a2XbEjLV8h2XnTRM3pofDRkpxxDnBs745jhF5ndW1FY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2lYJ7zr7fWfoo3HnspuouN7wJbG2T7/GAbJCw6OlIrUhY/P2QlW3px0j93BnbyqMjhV57+CgeAqHWe5RSduDOkKgY9ATWl8u8miLAdbxM9wtwgvLM1N/1/lflkmHY9zvwAivCbyPJPateTCX7eQBdi6dHCJxKBhaaU6OhKD0O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pX8cCdWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pX8cCdWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821E1C4CEC0;
	Fri, 13 Sep 2024 22:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726267373;
	bh=a2XbEjLV8h2XnTRM3pofDRkpxxDnBs745jhF5ndW1FY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pX8cCdWLkJber6PaUokrVnEV2CzO/2105z9hXq3nJp6gyfO32suzbbhsCMjxmuGTz
	 ma1jND86qt9lNiL+jCdzbMfKo6zkAGEisWVBAL+YnNfYod4XBVPZWQYH0OxdCtHzcM
	 KlzR6TjcYCM1gzCfsF/M5PyFcrAXwYBDE2+nlkLnCl4RkJOLucEK3sPPPMLo0buPjU
	 +dHcLBN1ek2I5WBrJv+7Rh+mNwQSZqBD4r8KvHO3Uu19BUAAm5k+GMUOLM3mpTNHz0
	 Qokt7E2zQvVi9v8L7SvMsA5Off1D30mEDhEP9Y6ftKoXfBUEZfEy0hjAuBDzadxVkb
	 ObEJyEXNfOheA==
Received: by pali.im (Postfix)
	id C1DA8725; Sat, 14 Sep 2024 00:42:48 +0200 (CEST)
Date: Sat, 14 Sep 2024 00:42:48 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special
 files
Message-ID: <20240913224248.k5tn2le3gau2prmo@pali>
References: <20240912120548.15877-1-pali@kernel.org>
 <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali>
 <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Friday 13 September 2024 17:14:22 Steve French wrote:
> How did you find the format of the FIFO and SOCK file types?  I

For fifo there are multiple sources on internet, but none of them is
normative. Everything is just what people have tried. For example this
old email on samba list:
https://lists.samba.org/archive/linux-cifs-client/2005-May/000856.html

Format of the socket I have figured out by creating it in Interix
subsystem and then dumped content of the file from Win32 subsystem.
Then I checked that it has also same format over older MS NFS server.
It was easier than trying to search for some documentation (which I have
not found).

> couldn't find any references to those so added two new types to allow
> current Linux to be able to create these (especially since they are
> opaque to the server and thus low risk).

I was searching over internet again and now I have found patent
https://patents.google.com/patent/US20090049459 which describe symlink
content:

#define NFS_SPECFILE_LNK_V1  0x014b4e4c78746e49 /* “IntxLNK” */

But does not describe other types.

> > +     case S_IFSOCK:
> > -             strscpy(pdev.type, "LnxSOCK");
> > +             /* SFU socket is system file with one zero byte */
> > +             pdev_len = 1;
> > +             pdev.type[0] = '\0';
> >               break;
> >       case S_IFIFO:
> > -             strscpy(pdev.type, "LnxFIFO");
> > +             /* SFU fifo is system file which is empty */
> > +             pdev_len = 0;
> 
> My worry about the suggested change above is that it is possible that
> we could accidentally match to an empty file.

I fully understand your concerns, but code in this patch is for creating
new fifos. Not recognizing existing fifos.

Code for recognizing existing fifos (=empty file with system attribute)
was not changed and is in Linux cifs client for a very long time.

And if nobody complained yet then this is probably not an issue.

You can create manually on server empty file, mark it as system and then
Linux cifs client even without these changes would recognize that file
as fifo.

> We intentionally added
> the two new dev.type fields for these to avoid collisions with other
> things (and since they are Linux specific).  It seems risky to have an
> empty file with the system attribute marked as a FIFO, and similarly a
> file with one byte null as Socket.   Since this is for only the Linux
> client to recognize, I wanted to do something safe for those file
> types less likely to be confusing (ie strings for Socket and FIFO that
> were similar in length and format to the other special files seemed
> intuitive) and "LnxFIFO" and LnxSOCK" were used as the tags in the
> file to reduce confusion ie the tags for those two start with "Lnx" -
> ie "something used for Linux client" not related to the original
> Interix (those begin with "Intx").

I see. Now I understand what are those types (as I have not seen them
before). It is somehow misleading if such "LnxFIFO" and LnxSOCK"
functionality is provided by SFU option, but is incompatible with MS SFU
and also with MS NFS server. And is also incompatible with older Linux
cifs clients (as they do not understand those Lnx types).

> Note that in the long run we hope to use reparse points by default in
> more servers to store special files like this but there are a few
> cases for unusual workloads that need special file support that would
> have to use sfu still.  The newer reparse tags that Windows uses "WSL"
> have the advantage that they require fewer roundtrips to query (since
> the file type is in the reparse tag).

Yes, new WSL tags seems to be better. Also SFU mount option is not
activated by default.

> Also noticed an interesting problem when mounted with "sfu" -
> "smbgetinfo filebasicinfo /mnt/fifo1" will hang (in sys_open).  Is
> that expected for a FIFO?

Reading from fifo sleep reading process until some other process write
data to fifo. This is how fifos are working. You can try it on local
filesystem (e.g. ext4 or tmpfs).

$ mkfifo fifo
$ strace cat fifo

You will see in strace output of cat something like:
...
openat(AT_FDCWD, "fifo", O_RDONLY

And once you write to that fifo by other process (e.g. echo abc > fifo)
then cat will unfreeze and continue:

                                        = 3
fstat(3, {st_mode=S_IFIFO|0644, st_size=0, ...}) = 0
fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = -1 ESPIPE (Neprípustné nastavenie pozície)
mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f17a34bb000
read(3, "abc\n", 131072)                = 4
...


> On Fri, Sep 13, 2024 at 3:07 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Thursday 12 September 2024 14:05:47 Pali Rohár wrote:
> > > SFU-style fifo is empty file with system attribute set. This format is used
> > > by old Microsoft POSIX subsystem and later also by OpenNT/Interix subsystem
> > > (which replaced Microsoft POSIX subsystem and is part of Microsoft SFU).
> > >
> > > SFU-style socket is file which has system attribute set and file content is
> > > one zero byte. This format was introduced in Interix 3.0 subsystem, as part
> > > of the Microsoft SFU 3.0 and is used also by all later versions. Previous
> > > versions had no UNIX domain socket support.
> > >
> > > Currently when sfu mount option is specified then CIFS creates fifo and
> > > socket special files with some strange LnxSOCK or LnxFIFO content which is
> > > not compatible with Microsoft SFU and neither recognized by other SMB
> > > implementations which have some SFU support, including older Linux cifs
> > > implementations.
> > >
> > > So when sfu mount option is specified, create all fifo and socket special
> > > files compatible with SFU format to achieve SFU interop, as it is expected
> > > by sfu mount option.
> > >
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> >
> > Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu" mount option")
> > Fixes: 518549c120e6 ("cifs: fix creating sockets when using sfu mount options")
> >
> > I located commits which introduced those strange LnxSOCK or LnxFIFO
> > types which are not compatible with SFU. I would suggest to add those
> > two Fixes: tags into commit message for reference.
> >
> > > ---
> > >  fs/smb/client/cifssmb.c |  8 ++++----
> > >  fs/smb/client/smb1ops.c |  2 +-
> > >  fs/smb/client/smb2ops.c | 29 +++++++++++++++++++----------
> > >  3 files changed, 24 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > > index cfae2e918209..0ffc45aa5e2c 100644
> > > --- a/fs/smb/client/cifssmb.c
> > > +++ b/fs/smb/client/cifssmb.c
> > > @@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
> > >       pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
> > >       pSMB->Mode = cpu_to_le16(access_flags_to_smbopen_mode(access_flags));
> > >       pSMB->Mode |= cpu_to_le16(0x40); /* deny none */
> > > -     /* set file as system file if special file such
> > > -        as fifo and server expecting SFU style and
> > > +     /* set file as system file if special file such as fifo,
> > > +      * socket, char or block and server expecting SFU style and
> > >          no Unix extensions */
> > >
> > >       if (create_options & CREATE_OPTION_SPECIAL)
> > > @@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
> > >       req->AllocationSize = 0;
> > >
> > >       /*
> > > -      * Set file as system file if special file such as fifo and server
> > > -      * expecting SFU style and no Unix extensions.
> > > +      * Set file as system file if special file such as fifo, socket, char
> > > +      * or block and server expecting SFU style and no Unix extensions.
> > >        */
> > >       if (create_options & CREATE_OPTION_SPECIAL)
> > >               req->FileAttributes = cpu_to_le32(ATTR_SYSTEM);
> > > diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> > > index e1f2feb56f45..e03c91a49650 100644
> > > --- a/fs/smb/client/smb1ops.c
> > > +++ b/fs/smb/client/smb1ops.c
> > > @@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
> > >       /*
> > >        * Check if mounted with mount parm 'sfu' mount parm.
> > >        * SFU emulation should work with all servers, but only
> > > -      * supports block and char device (no socket & fifo),
> > > +      * supports block and char device, socket & fifo,
> > >        * and was used by default in earlier versions of Windows
> > >        */
> > >       if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index 9c2d065d3cc4..9e90672caf60 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -5066,26 +5066,32 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > >       struct cifs_fid fid;
> > >       unsigned int bytes_written;
> > >       struct win_dev pdev = {};
> > > +     size_t pdev_len = 0;
> > >       struct kvec iov[2];
> > >       __u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
> > >       int rc;
> > >
> > >       switch (mode & S_IFMT) {
> > >       case S_IFCHR:
> > > +             pdev_len = sizeof(pdev);
> > >               memcpy(pdev.type, "IntxCHR\0", 8);
> > >               pdev.major = cpu_to_le64(MAJOR(dev));
> > >               pdev.minor = cpu_to_le64(MINOR(dev));
> > >               break;
> > >       case S_IFBLK:
> > > +             pdev_len = sizeof(pdev);
> > >               memcpy(pdev.type, "IntxBLK\0", 8);
> > >               pdev.major = cpu_to_le64(MAJOR(dev));
> > >               pdev.minor = cpu_to_le64(MINOR(dev));
> > >               break;
> > >       case S_IFSOCK:
> > > -             strscpy(pdev.type, "LnxSOCK");
> > > +             /* SFU socket is system file with one zero byte */
> > > +             pdev_len = 1;
> > > +             pdev.type[0] = '\0';
> > >               break;
> > >       case S_IFIFO:
> > > -             strscpy(pdev.type, "LnxFIFO");
> > > +             /* SFU fifo is system file which is empty */
> > > +             pdev_len = 0;
> > >               break;
> > >       default:
> > >               return -EPERM;
> > > @@ -5100,14 +5106,17 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > >       if (rc)
> > >               return rc;
> > >
> > > -     io_parms.pid = current->tgid;
> > > -     io_parms.tcon = tcon;
> > > -     io_parms.length = sizeof(pdev);
> > > -     iov[1].iov_base = &pdev;
> > > -     iov[1].iov_len = sizeof(pdev);
> > > +     if (pdev_len > 0) {
> > > +             io_parms.pid = current->tgid;
> > > +             io_parms.tcon = tcon;
> > > +             io_parms.length = pdev_len;
> > > +             iov[1].iov_base = &pdev;
> > > +             iov[1].iov_len = pdev_len;
> > > +
> > > +             rc = server->ops->sync_write(xid, &fid, &io_parms,
> > > +                                          &bytes_written, iov, 1);
> > > +     }
> > >
> > > -     rc = server->ops->sync_write(xid, &fid, &io_parms,
> > > -                                  &bytes_written, iov, 1);
> > >       server->ops->close(xid, tcon, &fid);
> > >       return rc;
> > >  }
> > > @@ -5149,7 +5158,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
> > >       /*
> > >        * Check if mounted with mount parm 'sfu' mount parm.
> > >        * SFU emulation should work with all servers, but only
> > > -      * supports block and char device (no socket & fifo),
> > > +      * supports block and char device, socket & fifo,
> > >        * and was used by default in earlier versions of Windows
> > >        */
> > >       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> > > --
> > > 2.20.1
> > >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
