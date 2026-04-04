Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1297F3161A3;
	Sat,  4 Apr 2026 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775318053; cv=none; b=g39PeefWY4Rry4Zq6KE9B6upjnqwIyfnwk8VksGEZj9Eapb0JGaKtAbsUiMmOYogNpvxHzj3RFYj7hHULLXAcmQ/7T41BbBGpOscmezSY9KiPPXP1C4vTy5uq79GRKGAihyq3h7ghU6OFoxH9z3Mp5m2TWKaIVzqbS+Ftj4tBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775318053; c=relaxed/simple;
	bh=8BK50+dRMNkh4TT6hDFswobA0zj3IlH5WGy47YmWIGQ=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=gUSgmZSmc32NeAH0hozOGk34tHnhLklA/3CvwArHbBU8yYpbgYPLy3c+fsIsrqZou4KIVM8mimlEOt7MWu7pv2IyL59vg0p85zLeWBabE4oOXpHQFcdjuHZg4Zczb0U5xCbkcjPf75aJe2wgFwoZKeycajyF9gvqapc9xcFuy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=788YQQ9T; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="788YQQ9T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c5mWJ6JIbiSfyx302lhvpmJS92T0V8lNlKDF4pTcoOI=; b=788YQQ9TpEzsvA1lfTbPRbPvP2
	CCqGBOgdBSkazXO+sEoSAQk/z8iyCQ8NCA24QXk1R+JrP0xWPeDy+DQ41D8syfiQhJ6l3ZhcPgWrO
	3cd5OqOoBsu+9Xl2YFGaad0+cUlz5F8Z4YyDJtNMLEeoHazRq0GxH53SoWR812RKoRrUWlzaBAVNt
	omBnvas8RPBovDqBKZ+CxalhwfLJ3Fz7xstKLyTJz3v+xVP+nQYUMz2sC+OE1fWOsNfNyK2jWWb4U
	dsId77MKeksmNBm9hw1HWC2hrrUio2pfknsKENtseih+9vZt5iFHfV9KEat7ez/h57CcRc3TCZopc
	wIbm2UbQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w93Jy-00000002D6F-14AK;
	Sat, 04 Apr 2026 12:54:02 -0300
Message-ID: <dfd6f45153b8d5de4b9fd8b5755607f5@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: brauner@kernel.org, smfrench@gmail.com, David Howells
 <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [RFC PATCH] smb: client: add support for O_TMPFILE
In-Reply-To: <20260404015253.GP3836593@ZenIV>
References: <20260401011153.1757515-1-pc@manguebit.org>
 <20260404015253.GP3836593@ZenIV>
Date: Sat, 04 Apr 2026 12:54:02 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Tue, Mar 31, 2026 at 10:11:53PM -0300, Paulo Alcantara wrote:
>
>>  	d_drop(direntry);
>> -	d_add(direntry, newinode);
>> -
>> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>> +	if (oflags & O_TMPFILE) {
>> +		set_nlink(newinode, 0);
>> +		mark_inode_dirty(newinode);
>> +		d_instantiate(direntry, newinode);
>> +	} else {
>> +		d_add(direntry, newinode);
>> +	}
>
> What d_unhashed(dentry) is going to be when we arrive to that thing
> with O_TMPFILE?

It's called with an unhashed negative dentry.  Do you see any problems
with it?

>> +static void cifs_d_mark_tmpfile(struct file *file,
>> +				const unsigned char *name,
>> +				size_t namelen)
>> +{
>> +	struct dentry *dentry = file->f_path.dentry;
>> +
>> +	BUG_ON(dentry->d_name.name != dentry->d_shortname.string ||
>> +	       !hlist_unhashed(&dentry->d_u.d_alias) ||
>> +	       !d_unlinked(dentry) ||
>> +	       namelen > DNAME_INLINE_LEN - 1);
>> +	spin_lock(&dentry->d_parent->d_lock);
>> +	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>> +	dentry->__d_name.len = sprintf(dentry->d_shortname.string, "%.*s",
>> +				       (int)namelen, name);
>
> That's one hell of an odd way to spell that...  What's wrong with using union
> shortname_store for an argument?  Just memchr() for '\0' to verify it's there
> and use the result to calculate the length and plain assignment to d_shortname
> for copying...
>
> And in any case, that !hlist_unhashed(....) in there is d_really_is_positive().

I was thinking more along these lines (e.g. add a new VFS helper and
then call it in CIFS, as you suggested earlier)

    diff --git a/fs/dcache.c b/fs/dcache.c
    index 7ba1801d8132..c20a9c9e921c 100644
    --- a/fs/dcache.c
    +++ b/fs/dcache.c
    @@ -3196,6 +3196,25 @@ void d_mark_tmpfile(struct file *file, struct inode *inode)
     }
     EXPORT_SYMBOL(d_mark_tmpfile);
     
    +void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
    +{
    +       struct dentry *dentry = file->f_path.dentry;
    +       char *dname = dentry->d_shortname.string;
    +
    +       BUG_ON(dname_external(dentry) ||
    +              d_really_is_positive(dentry) ||
    +              !d_unlinked(dentry) ||
    +              name->len > DNAME_INLINE_LEN - 1);
    +       spin_lock(&dentry->d_parent->d_lock);
    +       spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
    +       dentry->__d_name.len = name->len;
    +       memcpy(dname, name->name, name->len);
    +       dname[name->len] = '\0';
    +       spin_unlock(&dentry->d_lock);
    +       spin_unlock(&dentry->d_parent->d_lock);
    +}
    +EXPORT_SYMBOL(d_mark_tmpfile_name);
    +
     void d_tmpfile(struct file *file, struct inode *inode)
     {
            struct dentry *dentry = file->f_path.dentry;
    diff --git a/include/linux/dcache.h b/include/linux/dcache.h
    index 898c60d21c92..f60819dcfebd 100644
    --- a/include/linux/dcache.h
    +++ b/include/linux/dcache.h
    @@ -264,6 +264,7 @@ extern void d_invalidate(struct dentry *);
     extern struct dentry * d_make_root(struct inode *);
     
     extern void d_mark_tmpfile(struct file *, struct inode *);
    +void d_mark_tmpfile_name(struct file *file, const struct qstr *name);
     extern void d_tmpfile(struct file *, struct inode *);
     
     extern struct dentry *d_find_alias(struct inode *);

Looks good?

>> +static int set_tmpfile_name(struct file *file)
>> +{
>> +	struct dentry *dentry = file->f_path.dentry;
>> +	unsigned char name[CIFS_TMPNAME_LEN + 1];
>> +	struct dentry *sdentry = NULL;
>> +
>> +	do {
>> +		dput(sdentry);
>> +		scnprintf(name, sizeof(name),
>> +			  CIFS_TMPNAME_PREFIX "%0*x",
>> +			  CIFS_TMPNAME_COUNTER_LEN,
>> +			  atomic_inc_return(&cifs_tmpcounter));
>> +		sdentry = lookup_noperm_unlocked(&QSTR(name), dentry->d_parent);
>> +		if (IS_ERR(sdentry))
>> +			return -EBUSY;
>> +	} while (!d_is_negative(sdentry));
>> +	dput(sdentry);
>
> That looks racy.  Checking it doesn't exist at the moment is fine, but what if
> it's created right after that lookup?  You are not holding any locks, so even
> the same-client race (with plain create()) is possible...

Yeah, that's definitely a TOCTOU race.  I should've looped over
cifs_do_create() instead to make sure that the tmpfile is created in the
server, by using a sane retry counter.
