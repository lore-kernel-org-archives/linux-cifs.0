Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC36A13B286;
	Sun, 29 Sep 2024 09:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727601989; cv=none; b=RQnRIfB8H5tk271pCLMJYrDuzMDvEPkxpf5glp5ud2u3cdAMwj4qF6DqriBw3RHTJdh4K4HoYgZgVwOPWva6uOJn1JCcu5sR1APbvvqo7bGy4+xMUJVG8FFptZdVQ6N0GBISDpNpKxd3YZ7SD698mpH7HrXlD0i0mD1SW4UFnrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727601989; c=relaxed/simple;
	bh=Mm5p8mZPhTHwk9jN9a4m7nDE11tJpNhll6W9eFLoSv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONHxuInat5+TxbTGcJrvrdFHaTsOybN8j5Z7qaVGCNl/xxdLarrkHOhiv6uP6pw0BMniEu/ckdjGRdscUYA0jSleCOcZuSK8/Nh7fA/FdYUjSpBF46SXfFIFwe5nuJnzbEeQ7iyRZfSu4JxbEy354u5j1h8DW25C/ijL48wyLGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t4VR/THc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4VR/THc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB2AC4CEC5;
	Sun, 29 Sep 2024 09:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727601989;
	bh=Mm5p8mZPhTHwk9jN9a4m7nDE11tJpNhll6W9eFLoSv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t4VR/THcT7mBzLSgySx0+I0RkHTpwB3v2hF0e5xZUERzygZSpOQMxoJ3bAJGXcdgS
	 bXNqw75mfFbF3gIqIITs9WllqtMKtRNPI6qe4KDf17o7BxMN4xEqe1Jagu4g8L4L3G
	 yoyMbAd5TJ0rZJFlDFeXF41J409yQuuUwvwNJrkOMvVcNyCOlHupCWM5FIjaipl55P
	 OXsL3u/aHB7ZfWzCt0ZMWw9db2AOi0ZVXq9+ZK9j5fflkjM66FxDe56gPy2H+TSj28
	 YOvCbaUBRmo+3/KkrjGyy6w/SBReJCZmguUauzpx9j6wWcpHcC3KYsmL0+OPA+DcWG
	 1tpnkfdNd/PAg==
Received: by pali.im (Postfix)
	id 18081872; Sun, 29 Sep 2024 11:26:24 +0200 (CEST)
Date: Sun, 29 Sep 2024 11:26:23 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] cifs: Rename posix to nfs in parse_reparse_posix()
 and reparse_posix_data
Message-ID: <20240929092623.yaqhixsa4eot4k62@pali>
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-9-pali@kernel.org>
 <CAH2r5mvqrWHX6n58eXGL0EgVuhKBD-aZbgrF1DBG9evdXNNaCg@mail.gmail.com>
 <0105d773-3030-4ee9-8b25-b074768df73c@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0105d773-3030-4ee9-8b25-b074768df73c@samba.org>
User-Agent: NeoMutt/20180716

Hello Ralph, thank you for information. So in case Samba is not going to
use IO_REPARSE_TAG_NFS as primary way to serve special files, then it
still makes sense to do this structure rename with my patch?



Anyway, Windows clients mostly do not use IO_REPARSE_TAG_NFS. From my
knowledge on Windows this tag is used only by Windows NFS server.
So scenario when Windows sends IO_REPARSE_TAG_NFS over SMB would be
rare... It would be needed to export NFS share via Windows NFS server
from SMB mount connected to Samba server.

Note that Windows NFS client stores data about special files in EAs. So
for example if you mount export from Linux NFS server by Windows NFS
client, then NFS symlink would be visible to Windows applications as
regular file with "NfsSymlinkTargetName" EA. More info is in this email:
https://marc.info/?l=samba-technical&m=121423255119680

And this is what are Windows applications using if they want to access
data of special files. So application access "NfsSymlinkTargetName" EA
and not IO_REPARSE_TAG_NFS reparse tag.

To my knowledge neither Samba, nor Linux CIFS client supports
"NfsSymlinkTargetName" EA for creating or parsing symlink.

On Sunday 29 September 2024 11:09:44 Ralph Boehme wrote:
> Keep in mind that the inode type info will also be available via the posix
> infolevel in the mode bits. The changes for Samba by Volker have already
> been merged last week.
> 
> Spec draft:
> 
> https://gitlab.com/samba-team/smb3-posix-spec/-/merge_requests/2
> 
> <https://www.samba.org/~slow/SMB3_POSIX/fscc_posix_extensions.html#posix-mode>
> 
> Fwiw, in a future version of POSIX-FSA we will probably say that in POSIX
> mode (per handle) the POSIX client MUST use the POSIXMode field for the
> inode type and one MUST NOT use the NFS reparse point tag for this. The
> server in POSIX mode MAY also set the reparse tag, but that's still open to
> debate from my pov.
> 
> The NFS reparse tag will be there basically for the Windows clients in
> non-POSIX mode and support will be mandatory in the server. The only reparse
> tag we'd in POSIX mode for inode type information would be
> IO_REPARSE_TAG_SYMLINK for symlinks.
> 
> -slow
> 
> 
> On 9/29/24 6:57 AM, Steve French wrote:
> > since they are being used by default for servers supporting special
> > files in the "SMB3.1.1 POSIX Extensions" ... it might be appropriate
> > to keep a less confusing name ("NFS" for "SMB3.1.1 POSIX" could be
> > confusing)
> > 
> > On Sat, Sep 28, 2024 at 5:01 PM Pali Rohár <pali@kernel.org> wrote:
> > > 
> > > This function parses NFS-style reparse points, which are used only by
> > > Windows NFS server since Windows Server 2012 version. This style of special
> > > files is not understood by Microsoft POSIX / Interix / SFU / SUA subsystems.
> > > 
> > > So make it clear that parse_reparse_posix() function and reparse_posix_data
> > > structure are not POSIX general, but rather NFS specific.
> > > 
> > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > ---
> > >   fs/smb/client/cifsglob.h |  2 +-
> > >   fs/smb/client/cifspdu.h  |  2 +-
> > >   fs/smb/client/reparse.c  | 14 +++++++-------
> > >   fs/smb/client/reparse.h  |  2 +-
> > >   fs/smb/common/smb2pdu.h  |  2 +-
> > >   5 files changed, 11 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > index 9eae8649f90c..119537e98f77 100644
> > > --- a/fs/smb/client/cifsglob.h
> > > +++ b/fs/smb/client/cifsglob.h
> > > @@ -223,7 +223,7 @@ struct cifs_open_info_data {
> > >                  __u32 tag;
> > >                  union {
> > >                          struct reparse_data_buffer *buf;
> > > -                       struct reparse_posix_data *posix;
> > > +                       struct reparse_nfs_data *nfs;
> > >                  };
> > >          } reparse;
> > >          struct {
> > > diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> > > index c3b6263060b0..fefd7e5eb170 100644
> > > --- a/fs/smb/client/cifspdu.h
> > > +++ b/fs/smb/client/cifspdu.h
> > > @@ -1506,7 +1506,7 @@ struct reparse_symlink_data {
> > >   #define NFS_SPECFILE_BLK       0x00000000004B4C42
> > >   #define NFS_SPECFILE_FIFO      0x000000004F464946
> > >   #define NFS_SPECFILE_SOCK      0x000000004B434F53
> > > -struct reparse_posix_data {
> > > +struct reparse_nfs_data {
> > >          __le32  ReparseTag;
> > >          __le16  ReparseDataLength;
> > >          __u16   Reserved;
> > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > index 35e8f2e18530..a23ea2f78c09 100644
> > > --- a/fs/smb/client/reparse.c
> > > +++ b/fs/smb/client/reparse.c
> > > @@ -81,7 +81,7 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
> > >          return rc;
> > >   }
> > > 
> > > -static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
> > > +static int nfs_set_reparse_buf(struct reparse_nfs_data *buf,
> > >                                 mode_t mode, dev_t dev,
> > >                                 struct kvec *iov)
> > >   {
> > > @@ -120,20 +120,20 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
> > >                       const char *full_path, umode_t mode, dev_t dev)
> > >   {
> > >          struct cifs_open_info_data data;
> > > -       struct reparse_posix_data *p;
> > > +       struct reparse_nfs_data *p;
> > >          struct inode *new;
> > >          struct kvec iov;
> > >          __u8 buf[sizeof(*p) + sizeof(__le64)];
> > >          int rc;
> > > 
> > > -       p = (struct reparse_posix_data *)buf;
> > > +       p = (struct reparse_nfs_data *)buf;
> > >          rc = nfs_set_reparse_buf(p, mode, dev, &iov);
> > >          if (rc)
> > >                  return rc;
> > > 
> > >          data = (struct cifs_open_info_data) {
> > >                  .reparse_point = true,
> > > -               .reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
> > > +               .reparse = { .tag = IO_REPARSE_TAG_NFS, .nfs = p, },
> > >          };
> > > 
> > >          new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> > > @@ -313,7 +313,7 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
> > >   }
> > > 
> > >   /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
> > > -static int parse_reparse_posix(struct reparse_posix_data *buf,
> > > +static int parse_reparse_nfs(struct reparse_nfs_data *buf,
> > >                                 struct cifs_sb_info *cifs_sb,
> > >                                 struct cifs_open_info_data *data)
> > >   {
> > > @@ -414,7 +414,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
> > >          /* See MS-FSCC 2.1.2 */
> > >          switch (le32_to_cpu(buf->ReparseTag)) {
> > >          case IO_REPARSE_TAG_NFS:
> > > -               return parse_reparse_posix((struct reparse_posix_data *)buf,
> > > +               return parse_reparse_nfs((struct reparse_nfs_data *)buf,
> > >                                             cifs_sb, data);
> > >          case IO_REPARSE_TAG_SYMLINK:
> > >                  return parse_reparse_symlink(
> > > @@ -507,7 +507,7 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
> > >                                   struct cifs_fattr *fattr,
> > >                                   struct cifs_open_info_data *data)
> > >   {
> > > -       struct reparse_posix_data *buf = data->reparse.posix;
> > > +       struct reparse_nfs_data *buf = data->reparse.nfs;
> > >          u32 tag = data->reparse.tag;
> > > 
> > >          if (tag == IO_REPARSE_TAG_NFS && buf) {
> > > diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
> > > index 5be54878265e..2a91f64de557 100644
> > > --- a/fs/smb/client/reparse.h
> > > +++ b/fs/smb/client/reparse.h
> > > @@ -18,7 +18,7 @@
> > >    */
> > >   #define IO_REPARSE_TAG_INTERNAL ((__u32)~0U)
> > > 
> > > -static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
> > > +static inline dev_t reparse_nfs_mkdev(struct reparse_nfs_data *buf)
> > >   {
> > >          u32 major, minor;
> > > 
> > > diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> > > index c769f9dbc0b4..0e77a4c0145a 100644
> > > --- a/fs/smb/common/smb2pdu.h
> > > +++ b/fs/smb/common/smb2pdu.h
> > > @@ -1550,7 +1550,7 @@ struct reparse_symlink_data_buffer {
> > >          __u8    PathBuffer[]; /* Variable Length */
> > >   } __packed;
> > > 
> > > -/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
> > > +/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_nfs_data */
> > > 
> > >   struct validate_negotiate_info_req {
> > >          __le32 Capabilities;
> > > --
> > > 2.20.1
> > > 
> > > 
> > 
> > 
> 
