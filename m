Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153833BB4A;
	Tue,  7 Apr 2026 01:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775525344; cv=none; b=I9B4PYeKFGsk3qiW1DIGd5zz55/g1tYof3dgv+OPMJLA3OCPNTb+UuIPv34yH+aRbnjb/1amZNmh8SUKKQO+6NVeRPDluyZMaqO9tXtA55isTWby+V5WtHH793MZ4qnI15sbESYJLZDVRJpQLVxn2MSnWJb1vHforfPoogzRqik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775525344; c=relaxed/simple;
	bh=PJADlUUSScJKCqISfIsyeZj2JISYiOXRr8KGMtZl1EM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Fh6D95EZt1aRfOfNhOl/ZrDSoaFqvN5ZOAV1P6cqfS9d9oZ4Yjha7hjwD+6a/1d5mfTyZ2wIGL2yuTKI2sTrsFMMfuzfeY4bUQrMXdy/cOu1wfga28EpeaCx1pfdX45dFd4VV5M6iaS9QcsMxO3AHPVAfw1JbffnP/HudRGGCwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=gTIxVZYK; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="gTIxVZYK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zktdSMhvzPfUniVbe07tyTHZi+jzlYeoZbXQLYVU6vU=; b=gTIxVZYKmDqU1mId1RhZH73Sez
	jW9OjAOV4SiMpUNFXke56XVP3gyx1npa5bHQwK2lZwWCQ47arp55Fx+hTVpbJKC+1xfsvy/zHQPER
	ezLAASQfVtvxUMCsQS6rNC1QZheS+KRRlW55pPtkhc53zm3yVmiZWVzbbZ+kawABpbJ6ytPU2IYJT
	haA8NOyB0VogFt6AaPt40O4pDnMNqJBKGDFZduP6HQt4iEt2wkukSjy/3jHHJQFGbf5/usb4rOneI
	sSHO/YzYhgV9bkfoPsoDd0k2c6sjX7amZCD3Xob+jCxkWJwRPple2VzKcqDfPxcvZcjAOjk42gKRq
	DVI8ahoQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w9vFL-00000002K2g-2j5j;
	Mon, 06 Apr 2026 22:28:51 -0300
Message-ID: <98c9845554e2e6a79965d68ba8ae722b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: NeilBrown <neil@brown.name>, Al Viro <viro@zeniv.linux.org.uk>
Cc: smfrench@gmail.com, David Howells <dhowells@redhat.com>,
 linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] smb: client: add support for O_TMPFILE
In-Reply-To: <177543319568.1474915.17445767081272255066@noble.neil.brown.name>
References: <20260405211819.1251369-1-pc@manguebit.org>
 <20260405211819.1251369-2-pc@manguebit.org>
 <20260405233222.GW3836593@ZenIV>
 <177543319568.1474915.17445767081272255066@noble.neil.brown.name>
Date: Mon, 06 Apr 2026 22:28:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

NeilBrown <neilb@ownmail.net> writes:

> On Mon, 06 Apr 2026, Al Viro wrote:
>> On Sun, Apr 05, 2026 at 06:18:19PM -0300, Paulo Alcantara wrote:
>> 
>> > @@ -436,17 +457,13 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>> >  		goto out_err;
>> >  	}
>> >  
>> > -	if (newinode)
>> > -		if (S_ISDIR(newinode->i_mode)) {
>> > -			rc = -EISDIR;
>> > -			goto out_err;
>> > -		}
>> > +	if (newinode && S_ISDIR(newinode->i_mode)) {
>> > +		rc = -EISDIR;
>> > +		goto out_err;
>> > +	}
>> >  
>> >  	d_drop(direntry);
>> > -	d_add(direntry, newinode);
>> 
>> > +		rc = __cifs_do_create(dir, direntry, full_path, xid,
>> > +				      tlink, oflags, mode, oplock,
>> > +				      fid, buf, &inode);
>> > +		if (!rc)
>> > +			d_add(direntry, inode);
>> 
>> 
>> > +		rc = __cifs_do_create(dir, dentry, path, xid, tlink,
>> > +				      file->f_flags, mode, &oplock,
>> > +				      &fid, NULL, &inode);
>> > +		if (!rc) {
>> > +			set_nlink(inode, 0);
>> > +			mark_inode_dirty(inode);
>> > +			d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));
>> > +			d_instantiate(dentry, inode);
>> 
>> I really don't like this "not sure what the state is, d_drop() to
>> get it unhashed" pattern, _especially_ when d_drop() and d_add() or
>> d_instantiate() get separated.
>> 
>> Note, BTW, this d_add() call site is one of the two in the entire kernel
>> that are neither d_splice_alias() in disguise nor pass NULL as inode.
>> The other one is nfs_link(), where we also have this kind of "d_drop()
>> first, then use d_add()" pattern.
>> 
>> Folks, what state can dentry be in cifs_do_create()?  I'd rather see
>> that sorted out, not obfuscated even more.
>
> cifs_do_create() gets call from cifs_atomic_open() which is
> ->atomic_open(), so dentry can be in-lookup or negative-hashed.
>
> If is also called from cifs_create() (->create()) and as cifs_lookup()
> never skips the lookup due to intent (like NFS does) the dentry will
> always be hashed negative.

Thanks Neil for the details!

IIUC, this is what we currently have

* cifs_atomic_open()

  init state: in-lookup or hashed-negative
  [d_drop() + d_add()]
  end state: hashed-positive

* cifs_tmpfile()

  init state: unhashed-negative
  [d_drop() + d_instantiate()]
  end state: unhashed-positive

* cifs_create()

  init state: hashed-negative
  [d_drop() + d_add()]
  end state: hashed-positive
