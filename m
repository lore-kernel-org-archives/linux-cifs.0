Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789EC1BD9C9;
	Sat,  4 Apr 2026 01:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267361; cv=none; b=dVC4rj6KP4fCiqD8Q/zyBdMb4S9MHlFAxbRCm9cI0HcEBfhFutfmfGReNUPjtrNfd0bA+HCjU5TmYUrCvWIuJPLkJ0Li+KldNHcMPmNCckLU3Tbo7sQntlakg5me6ctI1Y+LVdzEMCDhMFVRXPdHYOXP6RztE6WbOFjUFxCu/sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267361; c=relaxed/simple;
	bh=Y++27/2VWS18zK/e3/mypmTiqAM7O8WT2iISA9ZrNJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dqVCXUxBa1Mx4yGOkmAyX/Un+qw6nakzGi5ACPKiJjPQ4ZNbTG93VvqV/QMLsu50Nu0zhXagTExp2wdIOQZHm5rGORVtVxntpbOOUDZZ/F3RzrXcbchN5AmCONUklXeu/k0AE4EMmIvXRjRHX2Hhi6oVoWTdTtMSgdVTl8qDHtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=PzceOE12; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="PzceOE12"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WNLPCgVOcaF2AvCNysp126Yc/bcEBd8fX+o+MaJeDEI=; b=PzceOE12txnC4P86a1x3CWKeGc
	iWy65t6YGPKBY4MmCHOwwYPDyoud6ylAib/0F0lnJSIto3mLTYc5uwlrQf8H662IvFWb4n8nFfHCY
	qh8cdTvdn2lQsIlTSk5m2xReyCnkHClJIxbvVANt97m7xUNBFlIBxeLkjsAzFlrQdWcXxd2od2yGz
	GjkZYxu+v1QWK5GcVu6EO2fnYlca/Blj1D3y0cE5ugUHBXnLplyWHhV+x/peaagxobmRrCaLJSo8X
	atqFCC9vZsuijdh3VRamNkxchsmIPapGnw/QBA8r7Hk6jKl67qL2xVJMlco68V6igXMcDCdkXi98/
	m8wqxSew==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1w8qBx-0000000A7sN-3ept;
	Sat, 04 Apr 2026 01:52:54 +0000
Date: Sat, 4 Apr 2026 02:52:53 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paulo Alcantara <pc@manguebit.org>
Cc: brauner@kernel.org, smfrench@gmail.com,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [RFC PATCH] smb: client: add support for O_TMPFILE
Message-ID: <20260404015253.GP3836593@ZenIV>
References: <20260401011153.1757515-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401011153.1757515-1-pc@manguebit.org>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Mar 31, 2026 at 10:11:53PM -0300, Paulo Alcantara wrote:

>  	d_drop(direntry);
> -	d_add(direntry, newinode);
> -
> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	if (oflags & O_TMPFILE) {
> +		set_nlink(newinode, 0);
> +		mark_inode_dirty(newinode);
> +		d_instantiate(direntry, newinode);
> +	} else {
> +		d_add(direntry, newinode);
> +	}

What d_unhashed(dentry) is going to be when we arrive to that thing
with O_TMPFILE?

> +static void cifs_d_mark_tmpfile(struct file *file,
> +				const unsigned char *name,
> +				size_t namelen)
> +{
> +	struct dentry *dentry = file->f_path.dentry;
> +
> +	BUG_ON(dentry->d_name.name != dentry->d_shortname.string ||
> +	       !hlist_unhashed(&dentry->d_u.d_alias) ||
> +	       !d_unlinked(dentry) ||
> +	       namelen > DNAME_INLINE_LEN - 1);
> +	spin_lock(&dentry->d_parent->d_lock);
> +	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> +	dentry->__d_name.len = sprintf(dentry->d_shortname.string, "%.*s",
> +				       (int)namelen, name);

That's one hell of an odd way to spell that...  What's wrong with using union
shortname_store for an argument?  Just memchr() for '\0' to verify it's there
and use the result to calculate the length and plain assignment to d_shortname
for copying...

And in any case, that !hlist_unhashed(....) in there is d_really_is_positive().

> +static int set_tmpfile_name(struct file *file)
> +{
> +	struct dentry *dentry = file->f_path.dentry;
> +	unsigned char name[CIFS_TMPNAME_LEN + 1];
> +	struct dentry *sdentry = NULL;
> +
> +	do {
> +		dput(sdentry);
> +		scnprintf(name, sizeof(name),
> +			  CIFS_TMPNAME_PREFIX "%0*x",
> +			  CIFS_TMPNAME_COUNTER_LEN,
> +			  atomic_inc_return(&cifs_tmpcounter));
> +		sdentry = lookup_noperm_unlocked(&QSTR(name), dentry->d_parent);
> +		if (IS_ERR(sdentry))
> +			return -EBUSY;
> +	} while (!d_is_negative(sdentry));
> +	dput(sdentry);

That looks racy.  Checking it doesn't exist at the moment is fine, but what if
it's created right after that lookup?  You are not holding any locks, so even
the same-client race (with plain create()) is possible...

> +	cifs_d_mark_tmpfile(file, name, sizeof(name) - 1);
> +	return 0;
> +}
