Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6FD1841;
	Sat, 13 Jan 2024 09:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwwJrL3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A019FC433F1;
	Sat, 13 Jan 2024 09:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705138893;
	bh=iIfRNzMwCZatwlz6+5d9iYQFQ+seLrr3ObHXV7KLTFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NwwJrL3mwwhtQ07kxdy3ufGdzw+38uC8UDoEHv545zn3IoGY/9A6+NYu6qCxRIWHd
	 gdM+8cPyhgg80YqF5UjGcUDNEDiFQb9TW9JisY00ksCInw+kCwBEL1aVLgCc4Zrjlx
	 js5ORG2ErbNS3TCZXdMTgu/q84Hz22Vr9BmZ90lk=
Date: Sat, 13 Jan 2024 10:41:30 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	"Jitindar Singh, Suraj" <surajjs@amazon.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
Message-ID: <2024011316-cathouse-relearn-df14@gregkh>
References: <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan>
 <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan>
 <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
 <ZZ7Dy69ZJCEyKhhS@eldamar.lan>
 <2024011115-neatly-trout-5532@gregkh>
 <2162049.1705069551@warthog.procyon.org.uk>
 <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>
 <ZaJYgkI9o5J1U3TX@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZaJYgkI9o5J1U3TX@eldamar.lan>

On Sat, Jan 13, 2024 at 10:31:46AM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Fri, Jan 12, 2024 at 11:20:53PM -0600, Steve French wrote:
> > Here is a patch similar to what David suggested.  Seems
> > straightforward fix.  See attached.
> > I did limited testing on it tonight with 6.1 (will do more tomorrow,
> > but feedback welcome) but it did fix the regression in xfstest
> > generic/001 mentioned in this thread.
> > 
> > 
> > 
> > 
> > On Fri, Jan 12, 2024 at 8:26 AM David Howells <dhowells@redhat.com> wrote:
> > >
> > > gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
> > >
> > > > I guess I can just revert the single commit here?  Can someone send me
> > > > the revert that I need to do so as I get it right?
> > >
> > > In cifs_flush_folio() the error check for filemap_get_folio() just needs
> > > changing to check !folio instead of IS_ERR(folio).
> > >
> > > David
> > >
> > >
> > 
> > 
> > --
> > Thanks,
> > 
> > Steve
> 
> > From ba288a873fb8ac3d1bf5563366558a905620c071 Mon Sep 17 00:00:00 2001
> > From: Steve French <stfrench@microsoft.com>
> > Date: Fri, 12 Jan 2024 23:08:51 -0600
> > Subject: [PATCH] cifs: fix flushing folio regression for 6.1 backport
> > 
> > filemap_get_folio works differenty in 6.1 vs. later kernels
> > (returning NULL in 6.1 instead of an error).  Add
> > this minor correction which addresses the regression in the patch:
> >   cifs: Fix flushing, invalidation and file size with copy_file_range()
> > 
> > Suggested-by: David Howells <dhowells@redhat.com>
> > Reported-by: Salvatore Bonaccorso <carnil@debian.org>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/smb/client/cifsfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index 2e15b182e59f..ac0b7f229a23 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode *inode, loff_t pos, loff_t *_fstart, lo
> >  	int rc = 0;
> >  
> >  	folio = filemap_get_folio(inode->i_mapping, index);
> > -	if (IS_ERR(folio))
> > +	if ((!folio) || (IS_ERR(folio)))
> >  		return 0;
> >  
> >  	size = folio_size(folio);
> 
> I was able to test the patch with the case from the Debian bugreport
> and seems to resolve the issue. Even if late, as Greg just queued up
> already:
> 
> Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Thanks, I've added your tested-by to the patch now.

greg k-h
