Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DBC4C65;
	Sat, 13 Jan 2024 17:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XBIuTwAz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Hp64LaVQJQsLqAZDOrtoGqIE7tJ/OaeKJ7yu7L90+M=; b=XBIuTwAz+mQPEryrwAJZ6UeszL
	jRRvAwZGsDwM+EjYOskJsHH426TedF0zOhO4dleXKFl8tB1ZGSqboB1hWsPCWQvH0pbpnDM55DNwS
	Lr0dKgdg5LacT8loLu83uemo8t2l9iWXo69urvao7o+z0i9hTiGI3uNhISvVmGUtOSygUJxU2cPsG
	eZMkpsyPBSLlmhzV94yUymYsRq4E5EdLNprAc1bPkJRuPSvn2VMgeVqaEhWXpqDWPcZlbuYTJkuAK
	t3NU6QTovMv3xH60byNK5NqAL3NxlsLHwu3Utj6KUio3HjGPFnAS2Nz1zvBekHoNbzBJZMQzVnNkq
	nhnVmF3A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rOhOf-003X8M-Rh; Sat, 13 Jan 2024 17:02:13 +0000
Date: Sat, 13 Jan 2024 17:02:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	"Jitindar Singh, Suraj" <surajjs@amazon.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and
 file size with copy_file_range()"
Message-ID: <ZaLCFboedRPqcrDO@casper.infradead.org>
References: <2023121124-trifle-uncharted-2622@gregkh>
 <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com>
 <ZZhrpNJ3zxMR8wcU@eldamar.lan>
 <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info>
 <ZZk6qA54A-KfzmSz@eldamar.lan>
 <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info>
 <ZZ7Dy69ZJCEyKhhS@eldamar.lan>
 <2024011115-neatly-trout-5532@gregkh>
 <2162049.1705069551@warthog.procyon.org.uk>
 <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtBSvp9D8s3bX7KNWjXdTuOHPx5Z005jp8F5kuJgU3Z-g@mail.gmail.com>

On Fri, Jan 12, 2024 at 11:20:53PM -0600, Steve French wrote:
> Here is a patch similar to what David suggested.  Seems

Similar to, but worse.

> +++ b/fs/smb/client/cifsfs.c
> @@ -1240,7 +1240,7 @@ static int cifs_flush_folio(struct inode *inode, loff_t pos, loff_t *_fstart, lo
>  	int rc = 0;
>  
>  	folio = filemap_get_folio(inode->i_mapping, index);
> -	if (IS_ERR(folio))
> +	if ((!folio) || (IS_ERR(folio)))
>  		return 0;

filemap_get_folio() cannot return an err_ptr in 6.1, so this should
simply be:

-	if (IS_ERR(folio))
+	if (!folio)

