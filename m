Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B938A920;
	Fri, 27 Sep 2024 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727460671; cv=none; b=JqWguiM/kbLszBhvYi+ERN+1KA2stkkUySE56XElX5s8qY59KC8SftNvOawRiKZE7WnjcQGcUEV/rrnrQTBVLW0jw2EUXlrUQ6Fo7UCIdgCAh51N5sfy9Fpg0Heb2uS45PLS/jc/0v/9TlgYLnu+SuYXe2rPxZ614dXXigCEwiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727460671; c=relaxed/simple;
	bh=6FDJIhSe4fG4oWn/NoyBMrL+8doHC+qUBUXlALAyfas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFvyKI1YcsCdiOYdYuVzJbS0++xZIzpbaXuW+DRQLho7pf5NoVnqfN5INmJAr8cff2DD5iJVkBW3UomH5RrzN78+fKHZ+dZDb6JmopDUua0BbFAcoVcNb8QLK29VSi8V4A8ET605ZKUGPEglPBAwCBVpKdXCYmB5r+SfTh0bBqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZH9Li0TX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZH9Li0TX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52571C4CEC4;
	Fri, 27 Sep 2024 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727460669;
	bh=6FDJIhSe4fG4oWn/NoyBMrL+8doHC+qUBUXlALAyfas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZH9Li0TXBg5L7b7RvkksO/G6HPnF0uTs8MuWuHMbgs4iWRPzend5qFY0tkYkO4ZOa
	 pzl7iv48sJNv8QfsJo/JKidr2ssjWszuWyGgxpW/RZR10YEKZy0ZFbxE9NMIVewYAL
	 u96BIbD3zNLIZeKpxqvSf1XlK1lyjetmr06wHKzeCm/vQ7eyRxV6RWvsYOLn17Kd3v
	 r3Xv9luw6+ezEpnxiLDfIzkUNM8Ifql33FSnGmXCZksncC9+P5VUaVbDQ44lugHL+b
	 mBFcVeDbn5BSh0xesxHy/8y7O5MfYG0cZ/808VBxAs2KLPr7yU+22ViuDsRxAPmBA/
	 FpYqRT+RaTkfg==
Received: by pali.im (Postfix)
	id 889BD9ED; Fri, 27 Sep 2024 20:11:03 +0200 (CEST)
Date: Fri, 27 Sep 2024 20:11:03 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cifs: Add support for creating SFU symlinks
Message-ID: <20240927181103.qf43ziyp5kddcr2b@pali>
References: <20240912120548.15877-7-pali@kernel.org>
 <20240915194545.14779-1-pali@kernel.org>
 <20240915194545.14779-2-pali@kernel.org>
 <re4m7ihhapjrjiu6acrnuex3jgbanz27uacig37xkereilmdcp@jzsjtdeg5wnb>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <re4m7ihhapjrjiu6acrnuex3jgbanz27uacig37xkereilmdcp@jzsjtdeg5wnb>
User-Agent: NeoMutt/20180716

On Friday 27 September 2024 14:54:31 Enzo Matsumiya wrote:
> Hi Pali,
> 
> On 09/15, Pali Rohár wrote:
> > Linux cifs client can already detect SFU symlinks and reads it content
> > (target location). But currently is not able to create new symlink. So
> > implement this missing support.
> > 
> > When 'sfu' mount option is specified and 'mfsymlinks' is not specified then
> > create new symlinks in SFU-style. This will provide full SFU compatibility
> > of symlinks when mounting cifs share with 'sfu' option. 'mfsymlinks' option
> > override SFU for better Apple compatibility as explained in fs_context.c
> > file in smb3_update_mnt_flags() function.
> > 
> > Extend __cifs_sfu_make_node() function, which now can handle also S_IFLNK
> > type and refactor structures passed to sync_write() in this function, by
> > splitting SFU type and SFU data from original combined struct win_dev as
> > combined fixed-length struct cannot be used for variable-length symlinks.
> > 
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> > fs/smb/client/cifspdu.h    |  6 ---
> > fs/smb/client/cifsproto.h  |  4 ++
> > fs/smb/client/fs_context.c | 13 ++++---
> > fs/smb/client/link.c       |  3 ++
> > fs/smb/client/smb2ops.c    | 80 +++++++++++++++++++++++++++++---------
> > 5 files changed, 77 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> > index a2072ab9e586..c3b6263060b0 100644
> > --- a/fs/smb/client/cifspdu.h
> > +++ b/fs/smb/client/cifspdu.h
> > @@ -2573,12 +2573,6 @@ typedef struct {
> > } __attribute__((packed)) FIND_FILE_STANDARD_INFO; /* level 0x1 FF resp data */
> > 
> > 
> > -struct win_dev {
> > -	unsigned char type[8]; /* IntxCHR or IntxBLK or LnxFIFO or LnxSOCK */
> > -	__le64 major;
> > -	__le64 minor;
> > -} __attribute__((packed));
> > -
> > struct fea {
> > 	unsigned char EA_flags;
> > 	__u8 name_len;
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index 497bf3c447bc..791bddac0396 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -676,6 +676,10 @@ char *extract_sharename(const char *unc);
> > int parse_reparse_point(struct reparse_data_buffer *buf,
> > 			u32 plen, struct cifs_sb_info *cifs_sb,
> > 			bool unicode, struct cifs_open_info_data *data);
> > +int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > +			 struct dentry *dentry, struct cifs_tcon *tcon,
> > +			 const char *full_path, umode_t mode, dev_t dev,
> > +			 const char *symname);
> > int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > 		       struct dentry *dentry, struct cifs_tcon *tcon,
> > 		       const char *full_path, umode_t mode, dev_t dev);
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index bc926ab2555b..2f0c3894b0f7 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -1896,14 +1896,17 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
> > 	if (ctx->mfsymlinks) {
> > 		if (ctx->sfu_emul) {
> > 			/*
> > -			 * Our SFU ("Services for Unix" emulation does not allow
> > -			 * creating symlinks but does allow reading existing SFU
> > -			 * symlinks (it does allow both creating and reading SFU
> > -			 * style mknod and FIFOs though). When "mfsymlinks" and
> > +			 * Our SFU ("Services for Unix") emulation allows now
> > +			 * creating new and reading existing SFU symlinks.
> > +			 * Older Linux kernel versions were not able to neither
> > +			 * read existing nor create new SFU symlinks. But
> > +			 * creating and reading SFU style mknod and FIFOs was
> > +			 * supported for long time. When "mfsymlinks" and
> > 			 * "sfu" are both enabled at the same time, it allows
> > 			 * reading both types of symlinks, but will only create
> > 			 * them with mfsymlinks format. This allows better
> > -			 * Apple compatibility (probably better for Samba too)
> > +			 * Apple compatibility, compatibility with older Linux
> > +			 * kernel clients (probably better for Samba too)
> > 			 * while still recognizing old Windows style symlinks.
> > 			 */
> > 			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
> > diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
> > index 80099bbb333b..47ddeb7fa111 100644
> > --- a/fs/smb/client/link.c
> > +++ b/fs/smb/client/link.c
> > @@ -606,6 +606,9 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
> > 	/* BB what if DFS and this volume is on different share? BB */
> > 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
> > 		rc = create_mf_symlink(xid, pTcon, cifs_sb, full_path, symname);
> > +	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
> > +		rc = __cifs_sfu_make_node(xid, inode, direntry, pTcon,
> > +					  full_path, S_IFLNK, 0, symname);
> > #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> > 	} else if (pTcon->unix_ext) {
> > 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 9c2d065d3cc4..2c251e9a3a30 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -5055,9 +5055,10 @@ static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
> > 	return 0;
> > }
> > 
> > -static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > +int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > 				struct dentry *dentry, struct cifs_tcon *tcon,
> > -				const char *full_path, umode_t mode, dev_t dev)
> > +				const char *full_path, umode_t mode, dev_t dev,
> > +				const char *symname)
> > {
> > 	struct TCP_Server_Info *server = tcon->ses->server;
> > 	struct cifs_open_parms oparms;
> > @@ -5065,30 +5066,64 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> > 	struct cifs_fid fid;
> > 	unsigned int bytes_written;
> > -	struct win_dev pdev = {};
> > -	struct kvec iov[2];
> > +	u8 type[8];
> > +	int type_len = 0;
> > +	struct {
> > +		__le64 major;
> > +		__le64 minor;
> > +	} __packed pdev = {};
> > +	__le16 *symname_utf16 = NULL;
> > +	u8 *data = NULL;
> > +	int data_len = 0;
> > +	struct kvec iov[3];
> > 	__u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
> > 	int rc;
> > 
> > 	switch (mode & S_IFMT) {
> > 	case S_IFCHR:
> > -		memcpy(pdev.type, "IntxCHR\0", 8);
> > +		type_len = 8;
> > +		memcpy(type, "IntxCHR\0", type_len);
> > 		pdev.major = cpu_to_le64(MAJOR(dev));
> > 		pdev.minor = cpu_to_le64(MINOR(dev));
> > +		data = (u8 *)&pdev;
> > +		data_len = sizeof(pdev);
> > 		break;
> > 	case S_IFBLK:
> > -		memcpy(pdev.type, "IntxBLK\0", 8);
> > +		type_len = 8;
> > +		memcpy(type, "IntxBLK\0", type_len);
> > 		pdev.major = cpu_to_le64(MAJOR(dev));
> > 		pdev.minor = cpu_to_le64(MINOR(dev));
> > +		data = (u8 *)&pdev;
> > +		data_len = sizeof(pdev);
> > +		break;
> > +	case S_IFLNK:
> > +		type_len = 8;
> > +		memcpy(type, "IntxLNK\1", type_len);
> > +		symname_utf16 = cifs_strndup_to_utf16(symname, strlen(symname),
> > +						      &data_len, cifs_sb->local_nls,
> > +						      NO_MAP_UNI_RSVD);
> > +		if (!symname_utf16) {
> > +			rc = -ENOMEM;
> > +			goto out;
> > +		}
> > +		data_len -= 2; /* symlink is without trailing wide-nul */
> > +		data = (u8 *)symname_utf16;
> 
> Can't S_IFLNK be handled somewhere else/other function?  mknod doesn't
> support S_IFLNK, so this seems out of place.
> 
> And even though it's unreachable (AFAICS), cifs_sfu_make_node() calls
> this with @symname == NULL (caught with gcc -fanalyzer).
> 
> 
> Cheers,
> 
> Enzo

Hello! As SFU-style special files have same format, I just extended this
function which handles all SFU types, to handle also symlink.

I wanted to reuse existing function instead of copying and duplicating
code.

Parameter symname is used only for S_IFLNK, so this should be safe. And
as you pointed out mknod does not support S_IFLNK, so mknod code path
would not call __cifs_sfu_make_node() function with S_IFLNK argument.

So I think that there is not issue. But if you want to refactor this
code, do you have an idea what to do?

> > 		break;
> > 	case S_IFSOCK:
> > -		strscpy(pdev.type, "LnxSOCK");
> > +		type_len = 8;
> > +		strscpy(type, "LnxSOCK");
> > +		data = (u8 *)&pdev;
> > +		data_len = sizeof(pdev);
> > 		break;
> > 	case S_IFIFO:
> > -		strscpy(pdev.type, "LnxFIFO");
> > +		type_len = 8;
> > +		strscpy(type, "LnxFIFO");
> > +		data = (u8 *)&pdev;
> > +		data_len = sizeof(pdev);
> > 		break;
> > 	default:
> > -		return -EPERM;
> > +		rc = -EPERM;
> > +		goto out;
> > 	}
> > 
> > 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, GENERIC_WRITE,
> > @@ -5098,17 +5133,26 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > 
> > 	rc = server->ops->open(xid, &oparms, &oplock, NULL);
> > 	if (rc)
> > -		return rc;
> > +		goto out;
> > 
> > -	io_parms.pid = current->tgid;
> > -	io_parms.tcon = tcon;
> > -	io_parms.length = sizeof(pdev);
> > -	iov[1].iov_base = &pdev;
> > -	iov[1].iov_len = sizeof(pdev);
> > +	if (type_len + data_len > 0) {
> > +		io_parms.pid = current->tgid;
> > +		io_parms.tcon = tcon;
> > +		io_parms.length = type_len + data_len;
> > +		iov[1].iov_base = type;
> > +		iov[1].iov_len = type_len;
> > +		iov[2].iov_base = data;
> > +		iov[2].iov_len = data_len;
> > +
> > +		rc = server->ops->sync_write(xid, &fid, &io_parms,
> > +					     &bytes_written,
> > +					     iov, ARRAY_SIZE(iov)-1);
> > +	}
> > 
> > -	rc = server->ops->sync_write(xid, &fid, &io_parms,
> > -				     &bytes_written, iov, 1);
> > 	server->ops->close(xid, tcon, &fid);
> > +
> > +out:
> > +	kfree(symname_utf16);
> > 	return rc;
> > }
> > 
> > @@ -5120,7 +5164,7 @@ int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> > 	int rc;
> > 
> > 	rc = __cifs_sfu_make_node(xid, inode, dentry, tcon,
> > -				  full_path, mode, dev);
> > +				  full_path, mode, dev, NULL);
> > 	if (rc)
> > 		return rc;
