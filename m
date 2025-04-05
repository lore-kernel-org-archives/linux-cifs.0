Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFA4191F84
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743874915; cv=none; b=Cp85+jB74ore9iL0QCEv0uKJ5H/hl+00HHje3RU5AdL5Ahth0zo6h7JjfqNe1/wM0EcQXOkcqzVaJ2ydDCsyAJkReo7QUj15glt3icPgcIeRJlZW6jVMYFoEEatSNlXH3BfVIi24pzF0wCS9fL6UyqK171D8RZsubaQT1p2DZcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743874915; c=relaxed/simple;
	bh=wZgulfoX7tq4sp9uLFCaDNXgKAsZK3d46p1vQiOTefI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BO8y/7NltddLbHKzeUvDGwE2rFjrFu+qAX4iijjSjFYaoRFaR3pYbn3HqpwxqtR2rmRg/T48lBjXpCfAOYm9itI70veu2V3yXPjr77D/LPGfm++YFhLEFxtheS5OzFkoipym6glZscizv5CGXxgi69yCeUOli2AeHbSKqw9GUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIKEKBPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIKEKBPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DB4C4CEE4;
	Sat,  5 Apr 2025 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743874914;
	bh=wZgulfoX7tq4sp9uLFCaDNXgKAsZK3d46p1vQiOTefI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MIKEKBPXkMmI8hXQp0OuSv7O/t5vnAr2eJrES/j3WkA+wvP6fJuEU3gUU3q33hHsg
	 rcCRS0iSQFLncXnI1cpWYRF145TyMjRR2dnq3usKwP5Ks1SAu2QZhkcjm7b8nuj64X
	 +F5nSgoL0mInbEasQY+i5Ti0e909Rh43g3DlFVYTbPLFcsHrxlDvXiMm50sTraktG5
	 abMfRfmqvg43DfzPyIrxcxp1Qq0p0KjOKydBzt0t9KbBfnlj470MaRHGuiCwN6jagL
	 5AuCUvUy3Befme1nO91c5vQi8M6bwkdanoVYTkGXUVF8AB47hHfywYKI9s6G7bQEiX
	 FDSGKqpMwCLAg==
Received: by pali.im (Postfix)
	id 5768C85D; Sat,  5 Apr 2025 19:41:38 +0200 (CEST)
Date: Sat, 5 Apr 2025 19:41:38 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Junwen Sun <sunjw8888@gmail.com>
Cc: Steve French <smfrench@gmail.com>, 1marc1@gmail.com,
	linux-cifs@vger.kernel.org, pc@manguebit.com, profnandaa@gmail.com,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Issue with kernel 6.8.0-40-generic?
Message-ID: <20250405174138.3j57ajqbtcimhr3b@pali>
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
 <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
 <20250405172030.4ptuwa73nnqhkzdy@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250405172030.4ptuwa73nnqhkzdy@pali>
User-Agent: NeoMutt/20180716

Hello, I looked at the code and there is really missing case for
processing non-name-surrogate reparse points by the server.

The change bellow should should fix the problem. Could you test it?
Do we have exact test scenario which is triggering the reported problem?

Reverting the cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on
unsupported reparse point type from parse_reparse_point()") change would
break processing of the name-surrogate reparse points.

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 7b0d40d2668a..12d7d2d24423 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1166,6 +1166,16 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 				cifs_create_junction_fattr(fattr, sb);
 				goto out;
 			}
+			/*
+			 * If the reparse point is unsupported by the Linux SMB
+			 * client then let it process by the SMB server. So mask
+			 * the -EOPNOTSUPP error code. This will allow Linux SMB
+			 * client to send SMB OPEN request to server. If server
+			 * does not support this reparse point too then server
+			 * will return error during open the path.
+			 */
+			if (rc == -EOPNOTSUPP)
+				rc = 0;
 		}
 
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 74cccb57ddb7..7bcc3bcabede 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1041,8 +1041,6 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			const char *full_path,
 			struct cifs_open_info_data *data)
 {
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -1069,8 +1067,6 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 		}
 		return 0;
 	default:
-		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-			      le32_to_cpu(buf->ReparseTag));
 		return -EOPNOTSUPP;
 	}
 }

On Saturday 05 April 2025 19:20:30 Pali Rohár wrote:
> Hello Junwen,
> 
> Could you please provide me more details about your issue? What exact
> kernel version is affected and what error message you see? Because in
> email subject is version 6.8 and in description is 6.12, so I quite
> confused.
> 
> I will look at this issue, just I need all detailed information.
> It looks like that the error handling is missing some case there.
> 
> Thanks
> 
> Pali
> 
> On Saturday 05 April 2025 12:16:27 Steve French wrote:
> > Good catch - it does look like a regression introduced by:
> > 
> >         cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported
> > reparse point type from parse_reparse_point()")
> > 
> > The "unhandled reparse tag: 0x9000701a" looks like (based on MS-FSCC
> > document) refers to
> > 
> >     "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
> > filter, for files managed by a sync engine such as OneDrive"
> > 
> > Will need to revert that as it looks like there are multiple reparse
> > tags that it will break not just the onedrive one above
> > 
> > 
> > On Fri, Apr 4, 2025 at 10:24 PM Junwen Sun <sunjw8888@gmail.com> wrote:
> > >
> > > Dear all,
> > >
> > > This is my first time submit an issue about kernel, if I am doing this
> > > wrong, please correct me.
> > >
> > > I'm using Debian testing amd64 as a home server. Recently, it updated
> > > to linux-image-6.12.20-amd64 and I found that it couldn't mount
> > > OneDrive shared folder using cifs. If I boot the system with 6.12.19,
> > > then there is no such problem.
> > >
> > > It just likes the issue Marc encountered in this thread. And the issue
> > > was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. So,
> > > I've done some research and found that in 6.12.20, there is a new
> > > commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which almost
> > > revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I guess
> > > it brings the same issue back to 6.12.20.
> > >
> > > Thanks very much in advance if someone can have a look into this issue again.
> > >
> > > 孙峻文
> > > Sun Junwen
> > 
> > 
> > 
> > -- 
> > Thanks,
> > 
> > Steve
