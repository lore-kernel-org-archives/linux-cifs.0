Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0448CDD;
	Sun, 29 Sep 2024 22:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727647551; cv=none; b=rHKVCfqtBRr6PrM3I7OcD+yZBjMqGnPMN61d2t4/GPhhRTgtxmiG+SwVwaqw4oI6lH/b6nxIxeVPDny0Xc+1ntp2C9CvKTJksBRnTp0ajPetLUdMAlzJ+GEdq1scXPGR2VuEGkV8ImCh+mcHWVyOxDnBm39SK3ad9xu4BBjBaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727647551; c=relaxed/simple;
	bh=pL3DVPu+hNJJCWE6wyqLxm2vYTihM1Hsgm9OQN+YJ8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHHH1wZGJfjbF5qanxh6dl9Gl3HOmXzgkOJkmnYIQzASPm/X7L31Dr5qzXOPkuqai7qd4RD7wFDWh+eVSCX7IT7A06aO7Yc6AlPJ4BRaf3uVPkwJnIzT8T+96hdAturgHUqWx5Eb4l8jwWNp/daJClqkG8vTaz+HGNGG7WN28kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InLoWnBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InLoWnBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD30FC4CEC5;
	Sun, 29 Sep 2024 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727647551;
	bh=pL3DVPu+hNJJCWE6wyqLxm2vYTihM1Hsgm9OQN+YJ8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=InLoWnBubo3JE3jejkrAFtadah6/8oNLDHyuys1XSBX/oFNFSU/EF2B19/0/p7f3P
	 PbMiM7IqOpnke2t+3rc4BPPjDD3QYD/SMk6LWk3waq979PeY3thI7FeVXvxgHL+DSW
	 CEx3K6AuF0lU9m8UuRG2YnjAiqJM7Wgj6N5G9WScIk0wYUYSg3/X7K911/aC4uQD0y
	 HcMXwnEGlU9H4jLwCRcReKiIKhlRhGxW3d26vW+E8+y0Rn6Jk1EJRvnHSROxKooWFv
	 1nuHbdLo59lNOEs/wu2CENNgskTV+lv+/HEFhFRIV96skhCCu/LfLmpzSPIw5sLEIG
	 MsBQYoyU9aIPg==
Received: by pali.im (Postfix)
	id 0FDB2872; Mon, 30 Sep 2024 00:05:45 +0200 (CEST)
Date: Mon, 30 Sep 2024 00:05:44 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] cifs: Rename smb2_get_reparse_inode to
 smb2_create_reparse_inode
Message-ID: <20240929220544.fquv6h3q4q6rqked@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-2-pali@kernel.org>
 <CAH2r5mt71ybdLj-9X=v_tuzaLbjGtQgPJvmNvcdZqLPzYpOJhA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mt71ybdLj-9X=v_tuzaLbjGtQgPJvmNvcdZqLPzYpOJhA@mail.gmail.com>
User-Agent: NeoMutt/20180716

That is fine. You can also postpone changes in this patch series for
next major version if it is needed to more testing. And if you think
that this rename change cause issues, you can drop it. It is not
functional change at all.

On Sunday 29 September 2024 16:16:44 Steve French wrote:
> I lean against minor renames in rc2, better to focus on the bug fixes
> in your patch (the renaming also makes it a bit harder to backport
> fixes, so often better after all the fixes in, if important rename)
> 
> On Sun, Sep 29, 2024 at 1:51 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > This function creates a new reparse point, so put "create" into its name.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/reparse.c   | 6 +++---
> >  fs/smb/client/smb2inode.c | 2 +-
> >  fs/smb/client/smb2proto.h | 2 +-
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index a23ea2f78c09..507e17244ed3 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -68,7 +68,7 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
> >         convert_delimiter(sym, '/');
> >         iov.iov_base = buf;
> >         iov.iov_len = len;
> > -       new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> > +       new = smb2_create_reparse_inode(&data, inode->i_sb, xid,
> >                                      tcon, full_path, &iov, NULL);
> >         if (!IS_ERR(new))
> >                 d_instantiate(dentry, new);
> > @@ -136,7 +136,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
> >                 .reparse = { .tag = IO_REPARSE_TAG_NFS, .nfs = p, },
> >         };
> >
> > -       new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
> > +       new = smb2_create_reparse_inode(&data, inode->i_sb, xid,
> >                                      tcon, full_path, &iov, NULL);
> >         if (!IS_ERR(new))
> >                 d_instantiate(dentry, new);
> > @@ -282,7 +282,7 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
> >         memcpy(data.wsl.eas, &cc->ea, len);
> >         data.wsl.eas_len = len;
> >
> > -       new = smb2_get_reparse_inode(&data, inode->i_sb,
> > +       new = smb2_create_reparse_inode(&data, inode->i_sb,
> >                                      xid, tcon, full_path,
> >                                      &reparse_iov, &xattr_iov);
> >         if (!IS_ERR(new))
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 6e69a3b98be3..0fc73035d6dc 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -1193,7 +1193,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
> >         return rc;
> >  }
> >
> > -struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> > +struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
> >                                      struct super_block *sb,
> >                                      const unsigned int xid,
> >                                      struct cifs_tcon *tcon,
> > diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> > index b208232b12a2..4ac30d29d5a1 100644
> > --- a/fs/smb/client/smb2proto.h
> > +++ b/fs/smb/client/smb2proto.h
> > @@ -56,7 +56,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
> >  extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
> >                                 struct cifs_sb_info *cifs_sb, const char *path,
> >                                 __u32 *reparse_tag);
> > -struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> > +struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
> >                                      struct super_block *sb,
> >                                      const unsigned int xid,
> >                                      struct cifs_tcon *tcon,
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
