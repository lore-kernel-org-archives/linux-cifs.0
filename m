Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F2433F8A3;
	Sun,  5 Apr 2026 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775431726; cv=none; b=ekSUAypvoXagasKFRjhgB/RToKsNGiC+Vn00IL6KonmW9VFHJKHfUEwHaU+c0uenPYND+wseCTNLmuKdpvYDnf+VDhbH5QqCAJGNfHd1iDov6auJzLs1F2c1fFswrk6UKxWs8WcspXYR5BK63SwfoGVd2CTC4JC9PrUgHpLjYi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775431726; c=relaxed/simple;
	bh=u8cVb4wU1yq68havVuiF0o8l9PzF/vN+DMfVKEO5GOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9RsvDbeboHIZVyJtCgJlUTGGOI7NCSSexB/f+pPBhSH1g8nl3Hu5qrjCSHfPaUe2IKcSbHSsZllF26LyAEdCNsWqTFFCcvrpifeU0cyJ4B+abE1+9OO+wt1aZ06/I6KHmN3uI46xC969dQnua7q3Q9AG7omiIcWzBZc0tmzWtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=gOtfBH6e; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="gOtfBH6e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S6dL0DMlTr7pWinIvY0E9M0o6ErcEOcOmnsEnXhkEoY=; b=gOtfBH6ehak6y8ecVZ6XnaL6T0
	94Bc651XDuWUdTr9YHIMfzDwT97Bav6isqm12D7kAQ/PM965qTNTZeTahaZKDDRwZm5RZI53IDVCa
	xCu87SzSSMz2rkWrDPcGHjO0hx/Wqv/BecY2CwX/XCjE+S2VZ1K/QuafR9avTKmHQtq1JLmztY9K1
	ozBbjn4DCu+BG+LSlue/1cvKS4dCcVF+C5fYQlfKVZfyz0NoGyG9ZFV6GoESaGVoiVcMz1LTLmWCB
	qlkeJ2cnFO0vb9wC5rwnIepwz9oe65/DjU9l0RcztsrPLrsRUcTdPdAqnHh6mFB8H6+qhRQSdZgVA
	D26NiXwQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1w9Wx5-0000000Di4i-041w;
	Sun, 05 Apr 2026 23:32:23 +0000
Date: Mon, 6 Apr 2026 00:32:22 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, David Howells <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	Neil Brown <neil@brown.name>
Subject: Re: [PATCH 2/2] smb: client: add support for O_TMPFILE
Message-ID: <20260405233222.GW3836593@ZenIV>
References: <20260405211819.1251369-1-pc@manguebit.org>
 <20260405211819.1251369-2-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405211819.1251369-2-pc@manguebit.org>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Apr 05, 2026 at 06:18:19PM -0300, Paulo Alcantara wrote:

> @@ -436,17 +457,13 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  		goto out_err;
>  	}
>  
> -	if (newinode)
> -		if (S_ISDIR(newinode->i_mode)) {
> -			rc = -EISDIR;
> -			goto out_err;
> -		}
> +	if (newinode && S_ISDIR(newinode->i_mode)) {
> +		rc = -EISDIR;
> +		goto out_err;
> +	}
>  
>  	d_drop(direntry);
> -	d_add(direntry, newinode);

> +		rc = __cifs_do_create(dir, direntry, full_path, xid,
> +				      tlink, oflags, mode, oplock,
> +				      fid, buf, &inode);
> +		if (!rc)
> +			d_add(direntry, inode);


> +		rc = __cifs_do_create(dir, dentry, path, xid, tlink,
> +				      file->f_flags, mode, &oplock,
> +				      &fid, NULL, &inode);
> +		if (!rc) {
> +			set_nlink(inode, 0);
> +			mark_inode_dirty(inode);
> +			d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));
> +			d_instantiate(dentry, inode);

I really don't like this "not sure what the state is, d_drop() to
get it unhashed" pattern, _especially_ when d_drop() and d_add() or
d_instantiate() get separated.

Note, BTW, this d_add() call site is one of the two in the entire kernel
that are neither d_splice_alias() in disguise nor pass NULL as inode.
The other one is nfs_link(), where we also have this kind of "d_drop()
first, then use d_add()" pattern.

Folks, what state can dentry be in cifs_do_create()?  I'd rather see
that sorted out, not obfuscated even more.

FWIW, that's a major headache for Neil's stuff around directory locking
changes - any place where we play with unhash-and-rehash needs separate
analysis.  d_drop() is not something to be used lightly; it obfuscates the
dentry state and we'll need to translate those to the new locking scheme.
