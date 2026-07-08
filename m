Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FD34C9016;
	Wed,  8 Jul 2026 18:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783535728; cv=none; b=lFUkwgl3KYMEanB78+13epw5bN2x52q8jpnnSCzGCIocvlrAKuB39NfxrDWyRZJTK5QDc/oZAyavHY6kk2e1ACGJ/EXH6JYPEkV8FmFVIwH/7H9+ftbbqmNWi5oUGQzLTNoWvEFsFu5+MwWXzT/Qrm+I+A4kHh5fa9ZDcxO7ius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783535728; c=relaxed/simple;
	bh=jhAkc/0H21Djo37LwNvfZj316j2ZyhGwEuxZqTccnWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvVmDOLf8yyITU7BnYIaSvrX+1e6fahvPF5/zLKXQLZJqWdmH/Av17APuGygqyO04tkw45vLUffSmS+JJBnTPvfkjBFKvWQCR9JsyewHO6HaRhtqYVGMP1L+1bKJEZBL7pHlELAYbhA6qC1snwft2QqKxz+KEsgI1C5PtQv22Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfxaKwpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfxaKwpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B92D1F00ACA;
	Wed,  8 Jul 2026 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783535727;
	bh=wLbxIQSjk75ZSmnI/bogI1EBN0Dl5rPloc1ZlRfKoOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TfxaKwpDtdigccYylgdWfumofyIwWwQmwa/GXfqGdd+G6HABpONzKNRmCtEOuY8cO
	 +SBO3+9Q/WbpWKQ4X6bxjqea28LpU00ZVenJ4lwFMPWO6X5nDTFZqSydE5mqN0C8xv
	 8kHMT7exsuc9D7bq/fy2i9fSCXKpHZ9Qmb+oC0Y4xbRKdxVBDau2rzjRsJ7REyIEjk
	 AZOUhQeIQsJu0v0wdVH7UM4PqBSPdcamIaVFfGTg6xltqHM9XFyAB13htbWs71iZOA
	 nv76Be4XdZnIbemnTb0lxlsHldA6QdvpZlLq5zLprw4O8H5ENJkMwwwPIl5ZxUwvuL
	 3KLCBucWT561Q==
Received: by pali.im (Postfix)
	id B9403BA9; Wed,  8 Jul 2026 20:35:23 +0200 (CEST)
Date: Wed, 8 Jul 2026 20:35:23 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix support for creating SFU socket
Message-ID: <20260708183523.3pmgda746zphiva3@pali>
References: <20260707090318.26130-1-pali@kernel.org>
 <CAH2r5muHZ5+znNZv4rsLFsVEW-z1XHB3U2N2FWaYRC6vS+ijgw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5muHZ5+znNZv4rsLFsVEW-z1XHB3U2N2FWaYRC6vS+ijgw@mail.gmail.com>
User-Agent: NeoMutt/20180716

WSL does not use "LnxSOCK". This looks like an AI hallucination.

WSL stores data in NTFS reparse points:
 IO_REPARSE_TAG_AF_UNIX    - 0x80000023
 IO_REPARSE_TAG_LX_FIFO    - 0x80000024
 IO_REPARSE_TAG_LX_CHR     - 0x80000025
 IO_REPARSE_TAG_LX_BLK     - 0x80000026
 IO_REPARSE_TAG_LX_SYMLINK - 0xA000001D
And also in NTFS EAs:
 "$LXUID"
 "$LXGID"
 "$LXMOD"
 "$LXDEV"

All tests which I have done with WSL's DrvFs resulted in above reparse
points (or in native Windows symlinks).

Some sources which confirms those my testing:
https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/c8e77b37-3909-4fe6-a4ea-2b9d423b1ee4
https://learn.microsoft.com/en-us/windows/wsl/file-permissions

WSL does not recognize "-o sfu" things at all.

So here I bet that AI "mixed" SFU and WSL formats and parts together and
created that hallucinated answer.

On Wednesday 08 July 2026 08:51:40 Steve French wrote:
> AI query made it sound like "LnxSOCK" is still used by WSL.  Is this
> change safe?
> 
> "Yes. WSL (particularly WSL 1 and WSL 2 when interacting with NTFS via
> DrvFs) uses the Lnx* metadata family to represent Linux special file
> types, including:
> 
> LnxSOCK
> LnxFIFO
> LnxCHR
> LnxBLK"
> 
> On Tue, Jul 7, 2026 at 4:13 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > SFU sockets are natively supported by Interix 3.0 subsystem and also by
> > later versions. It is part of Microsoft SFU (Windows Services for UNIX) and
> > Microsoft SUA (Subsystem for UNIX-based Applications). They can be created
> > and existing (stored on local disk or remote SMB share) can be recognized.
> >
> > SFU sockets are recognized also by NFS server included in Windows Server.
> > Windows NFS server versions since Windows Server 2012 uses new reparse
> > point format for storing new sockets, but still can recognize this old
> > format (also in the latest Windows Server 2022 version).
> >
> > SFU-style socket is a regular file which has system attribute set and
> > content of the file is one zero byte.
> >
> > These SFU-style sockets are already recognized by Linux SMB client.
> >
> > But Linux SMB client is currently creating new SFU socket in different
> > format which is not compatible with all those SFU applications. Fix this by
> > creating new sockets in correct SFU format which would be recognized by all
> > SFU, SUA, NFS and existing Linux SMB clients.
> >
> > This change affects only creating new sockets when mount option -o sfu is used.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/smb2ops.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index 4f7eefa7a683..e59fda1b2230 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -5288,10 +5288,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> >                 data = (u8 *)symname_utf16;
> >                 break;
> >         case S_IFSOCK:
> > -               type_len = 8;
> > -               strscpy(type, "LnxSOCK");
> > -               data = (u8 *)&pdev;
> > -               data_len = sizeof(pdev);
> > +               /* SFU socket is system file with one zero byte */
> > +               type_len = 1;
> > +               type[0] = '\0';
> >                 break;
> >         case S_IFIFO:
> >                 type_len = 8;
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
