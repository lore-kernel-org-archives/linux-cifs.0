Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0813841C6A;
	Mon, 30 Sep 2024 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727716834; cv=none; b=uy6iExTarkmIJXOnENxYeNFYH/sKiG32m3/rgSfFenShrBNI+9GVL1o92AFt1GlExffH3tIY3fWvbCxjMJF074b2zu+Kw75LH8bFgjGvP2wQwggYjf++rbPwZYU/M4jANESSRM7H3ZIcjaWd1dNPd0WmU2qH9ydp1wVdYYkWP1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727716834; c=relaxed/simple;
	bh=JI4/YEqKLWDif6ESadf2wfzAw0CxyVpEezu9rHiCHQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLNCG7cFzSTs4BCi38MihvPDm4RyE52nP6WhLQO3mo9uhJo4SsRs8T5YTCRhxSYRqN/ENAnQ/ykh2YaT2e944i/h9eFxBtORnODaVu57IBfo7GN2sXdEJZ08pnYXETz1MvHnIrBMA8BAdQIcCHwL9gDA/UtPRhDoNwSN8ywCrIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5xOfX3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5xOfX3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B4BC4CEC7;
	Mon, 30 Sep 2024 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727716833;
	bh=JI4/YEqKLWDif6ESadf2wfzAw0CxyVpEezu9rHiCHQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a5xOfX3uVyCOUz21b/hAWclrVwN09wZsBbXmSJNFrXgJtWBDnVKSXV+Pg9CiOObr8
	 I/cGRvHY6I/AQiYdhAC4t5cCDaNbQMDreYwaPBSa4KpK377pTAqJLEXZiX5OwCNSnq
	 iP08TRGvI6TjWDNbBBaiok5r+pBgc9mYtPbE1huKNj6FjmRbkuSOgysaacjDZI9kdd
	 bnZgzAjrZccDX9ioZw0iXyJ4LqRGTR+gpPr3u2ky+8+w1f9XknD1CiOX1jgbrZhP8O
	 TBYWXAGMNN/S6y1OULLvSQ2VmB32FEf3j5yLjoVhuHilJnqRqDyr+qsHyLr0SU8ijx
	 b8HWRarKfQ0KA==
Received: by pali.im (Postfix)
	id E2CC87D0; Mon, 30 Sep 2024 19:20:27 +0200 (CEST)
Date: Mon, 30 Sep 2024 19:20:27 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <sfrench@samba.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cifs: Remove intermediate object of failed create
 reparse call
Message-ID: <20240930172027.yt6qijriln4sv5hc@pali>
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-3-pali@kernel.org>
 <c5914322d267a2ef8ae1f712a293b258@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5914322d267a2ef8ae1f712a293b258@manguebit.com>
User-Agent: NeoMutt/20180716

On Monday 30 September 2024 12:25:27 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
> > intermediate object created by CREATE. Otherwise empty object stay on the
> > server when reparse call failed.
> >
> > This ensures that if the creating of special files is unsupported by the
> > server then no empty file stay on the server as a result of unsupported
> > operation.
> >
> > Fixes: 102466f303ff ("smb: client: allow creating special files via reparse points")
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/smb2inode.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > index 11a1c53c64e0..af42f44bdcf4 100644
> > --- a/fs/smb/client/smb2inode.c
> > +++ b/fs/smb/client/smb2inode.c
> > @@ -1205,6 +1205,8 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> >  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> >  	struct cifsFileInfo *cfile;
> >  	struct inode *new = NULL;
> > +	int out_buftype[2] = {};
> > +	struct kvec out_iov[2];
> >  	struct kvec in_iov[2];
> >  	int cmds[2];
> >  	int rc;
> > @@ -1228,7 +1230,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> >  		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
> >  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
> >  		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
> > -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
> > +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
> >  		if (!rc) {
> >  			rc = smb311_posix_get_inode_info(&new, full_path,
> >  							 data, sb, xid);
> > @@ -1237,12 +1239,27 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> >  		cmds[1] = SMB2_OP_QUERY_INFO;
> >  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
> >  		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
> > -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
> > +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
> >  		if (!rc) {
> >  			rc = cifs_get_inode_info(&new, full_path,
> >  						 data, sb, xid, NULL);
> >  		}
> >  	}
> > +
> > +	if (rc) {
> > +		/*
> > +		 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
> > +		 * remove the intermediate object created by CREATE. Otherwise
> > +		 * empty object stay on the server when reparse call failed.
> > +		 */
> > +		if (((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_SUCCESS &&
> > +		    ((struct smb2_hdr *)out_iov[1].iov_base)->Status != STATUS_SUCCESS)
> > +			smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
> > +	}
> 
> You should handle the case where ->iov_base is NULL or out_buftype ==
> CIFS_NO_BUFFER, otherwise you'll end up with a NULL ptr deref.

Ok, thanks for info! I will send v3 with those checks.

Anyway, what does it mean if iov_base stay NULL or out_buftype is
CIFS_NO_BUFFER? Does it mean that the server has not returned reply for
that command?

I guess that it should be treated as unsuccessful result.
