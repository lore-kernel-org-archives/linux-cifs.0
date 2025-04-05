Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A318E1A
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 19:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743883180; cv=none; b=BUbIr3EPRRhuN3HAri0Q0L1JHYd/KGmCIW6fEB+UwYo3peKHkAlVjsle3UYc9dJ8zmsacZYpNWOsg9HbU+Qu3OI72Th7fKQ6G2xcDne/GZIDO2a3mJSfQrWSkE8Ds7GXS1ADX3OXg4XHVs4mD1Y4UTdnF6BdE05j6IsNYTRDNB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743883180; c=relaxed/simple;
	bh=vFYPVQxgO4xjxB7ml+SsHr2swHfYEooYmueGTqechOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDaQZGUQqQrMN6+kmVDEF4CB0+gH4I3qJIYALV9ise2p+g9ZYSz5dtD+EbC/jDEtXAWv8ombrpW201PTnA0ryITB8ZlKGQ2eboaG4QpTtQQjFiOT238lGNCzW6eVp6mOJilu6UvP7eXmDA11sAicMdBTei2DZ2mqCB+czEqoKLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IwcXGJlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IwcXGJlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DDBC4CEE4;
	Sat,  5 Apr 2025 19:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743883179;
	bh=vFYPVQxgO4xjxB7ml+SsHr2swHfYEooYmueGTqechOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IwcXGJlSkYCyi/b28RWKJKIQJT4DYAAr4nyG+GWBLaDRIZzhvOQZjxC31QPhtN+eG
	 bHnD+UnXps5Ml2QkxmNZ1RdJIzCz+us9I39MVjc8fdgyLCFLzO9/fYgsROt6ooJnAI
	 +9VFHTkNI/jofn3O5Q9RQLtxmVSmTUlH0ijsx4sP6HHadcdapEXap6PDvWuqdvzFtc
	 aYtDPL+h2xFJIPPY1qgNb/IcirAPQ5um5nipMcN320N9J0ccm5qjsQ4paUEzYU1f+7
	 Rd0sQ8m2SmMrNaSi5Noh4YIC6QpNNe6Jm/WbsFtTzq+ipVQxDwd6qGjYwHhIRj3t3T
	 /yEhyzBQYaRJw==
Received: by pali.im (Postfix)
	id 995CE85D; Sat,  5 Apr 2025 21:59:23 +0200 (CEST)
Date: Sat, 5 Apr 2025 21:59:23 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Junwen Sun <sunjw8888@gmail.com>, 1marc1@gmail.com,
	linux-cifs@vger.kernel.org, pc@manguebit.com, profnandaa@gmail.com,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Issue with kernel 6.8.0-40-generic?
Message-ID: <20250405195923.aieo7ad2g3kynudr@pali>
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
 <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
 <20250405172030.4ptuwa73nnqhkzdy@pali>
 <CAH2r5mtFPSe7ccQjVdaoL+OCBP8Dya9s8wjSyd1aQtstQnX7dA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bmhfqtykjq4ue2ax"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtFPSe7ccQjVdaoL+OCBP8Dya9s8wjSyd1aQtstQnX7dA@mail.gmail.com>
User-Agent: NeoMutt/20180716


--bmhfqtykjq4ue2ax
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Steve, thank you for testing. I will do some other my own tests too.

For explanation, the function parse_reparse_point() is called by
reparse_info_to_fattr() and then return value from
reparse_info_to_fattr() is checked against -EOPNOTSUPP for handling name
surrogate reparse points. This logic was added in the commit
b587fd128660 ("cifs: Treat unhandled directory name surrogate reparse
points as mount directory nodes").

So this code in reparse_info_to_fattr() requires to know if the reparse
point was handled by the parse_reparse_point() function or not. Hence
reverting commit cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on
unsupported reparse point type from parse_reparse_point()") would cause
that the above logic stop working.

To fix both problems, the one reported by Junwen about unsupported
OneDrive reparse point, and the name surrogate reparse points, I'm
proposing in my change to "mask" the -EOPNOTSUPP not in the called
parse_reparse_point() function but instead in the caller
reparse_info_to_fattr().

During writing b587fd128660 and cad3fc0a4c8c I somehow forgot about the
case which cause this issue.

Linux SMB client should not filter out unknown/unhandled reparse points.
Reparse points are processed by the SMB server (with few exceptions for
UNIX special files).

In the attachment I'm sending the patch, now with the commit message and
Fixes lines.

On Saturday 05 April 2025 14:30:22 Steve French wrote:
> This was easy to reproduce on mainline for me as well (and presumably
> the same on 6.12 and 6.13 since it has been picked up by stable, and
> even looks it has been picked up in 6.6. stable) by simply mounting a
> Windows share that was exporting a onedrive directory.
> 
> Pali,
> I did verify that your suggested fix worked for my experiment
> (exporting onedrive dir as share).   Could you give more specific
> examples of
> 
>       'Reverting "cifs: Throw -EOPNOTSUPP error on unsupported reparse
> point type from parse_reparse_point()" would
>       break processing of the name-surrogate reparse points.
> 
> ie some repro examples that Junwen etc. could try
> 
> Welcome any other Tested-by/Reviewed-by/Acked-by for the two
> alternatives - reverting the patch, vs. Pali's workaround
> 
> 
> On Sat, Apr 5, 2025 at 12:20 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > Hello Junwen,
> >
> > Could you please provide me more details about your issue? What exact
> > kernel version is affected and what error message you see? Because in
> > email subject is version 6.8 and in description is 6.12, so I quite
> > confused.
> >
> > I will look at this issue, just I need all detailed information.
> > It looks like that the error handling is missing some case there.
> >
> > Thanks
> >
> > Pali
> >
> > On Saturday 05 April 2025 12:16:27 Steve French wrote:
> > > Good catch - it does look like a regression introduced by:
> > >
> > >         cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported
> > > reparse point type from parse_reparse_point()")
> > >
> > > The "unhandled reparse tag: 0x9000701a" looks like (based on MS-FSCC
> > > document) refers to
> > >
> > >     "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
> > > filter, for files managed by a sync engine such as OneDrive"
> > >
> > > Will need to revert that as it looks like there are multiple reparse
> > > tags that it will break not just the onedrive one above
> > >
> > >
> > > On Fri, Apr 4, 2025 at 10:24 PM Junwen Sun <sunjw8888@gmail.com> wrote:
> > > >
> > > > Dear all,
> > > >
> > > > This is my first time submit an issue about kernel, if I am doing this
> > > > wrong, please correct me.
> > > >
> > > > I'm using Debian testing amd64 as a home server. Recently, it updated
> > > > to linux-image-6.12.20-amd64 and I found that it couldn't mount
> > > > OneDrive shared folder using cifs. If I boot the system with 6.12.19,
> > > > then there is no such problem.
> > > >
> > > > It just likes the issue Marc encountered in this thread. And the issue
> > > > was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. So,
> > > > I've done some research and found that in 6.12.20, there is a new
> > > > commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which almost
> > > > revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I guess
> > > > it brings the same issue back to 6.12.20.
> > > >
> > > > Thanks very much in advance if someone can have a look into this issue again.
> > > >
> > > > 孙峻文
> > > > Sun Junwen
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

--bmhfqtykjq4ue2ax
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-cifs-Ensure-that-all-non-client-specific-reparse-poi.patch"
Content-Transfer-Encoding: 8bit

From 6fd41c8f182238c93076c3f683e48825788f02b0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Sat, 5 Apr 2025 19:51:07 +0200
Subject: [PATCH] cifs: Ensure that all non-client-specific reparse points are
 processed by the server
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Generally, reparse points are processed by the SMB server during the
SMB OPEN request.

But there are few reparse points which do not have OPEN-like meaning for
the SMB server and has to be processed by the SMB client. Those are
symlinks and special files (fifo, socket, block, char).

For Linux SMB client, it is required to process also name surrogate reparse
points as they represent another entity on the SMB server system. Linux
client will mark them as separate mount points.

So, after processing the name surrogate reparse points, clear the
-EOPNOTSUPP error code returned from the parse_reparse_point() to let SMB
server to process reparse points.

And remove printing misleading error message "unhandled reparse tag:" as
reparse points are handled by SMB server and hence unhandled fact is normal
operation.

Fixes: cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()")
Fixes: b587fd128660 ("cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c   | 10 ++++++++++
 fs/smb/client/reparse.c |  4 ----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index a00a9d91d0da..9b56198f7230 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1228,6 +1228,16 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
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
index 2b9e9885dc42..f85dd40f34af 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1062,8 +1062,6 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			const char *full_path,
 			struct cifs_open_info_data *data)
 {
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -1090,8 +1088,6 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 		}
 		return 0;
 	default:
-		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-			      le32_to_cpu(buf->ReparseTag));
 		return -EOPNOTSUPP;
 	}
 }
-- 
2.20.1


--bmhfqtykjq4ue2ax--
