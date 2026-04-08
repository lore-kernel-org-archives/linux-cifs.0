Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BDC3B8938;
	Wed,  8 Apr 2026 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656144; cv=none; b=JZUvogo8oZMbYymuFH6O/YB4buzkoy3szOC/tZWvtOBHijHVKwoQAk5Nyu3EZQnywmOwRI7HCuPoFlglp7N8soyr54vR4HwXQwPkf+NzKdHXmR/wFhbpWQeYoqd4pAp0HEZavvggMrQYWI1wSuamkrvFgDhBeQ1kfvE9H4KlGEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656144; c=relaxed/simple;
	bh=J/36tdXnuL5/WxPiUuPIVcK4e6LUbAv18uNk9LedBZ8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=IvYcy4o6qkAgIYTZWu4tccLCkIYGJJCU3ljgriPDGcFlSJ5EP04Q06XsRUogMp7tEQhKimgP1A7zR0U8KOeUZe5Vetp6e1MXLcXs6O46jKfmYv1SZMTR8AmvpW10K1Tvaxv9WYdHlAnIEdC+8J0LdsQ8EjtO9yTP3eyjHRzKXmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=4aRV+x1U; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="4aRV+x1U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vj3tKZDOUQi62GOzvuBEjG6R84zZC9FphJesg2j9ymQ=; b=4aRV+x1UBGS+3XuflLgRiqxmAb
	TUr0t0NAXLUI17C3xwJpZmy32mXoFPxW4BlUrErfHkXtMHolATcNzy5FGUJUskXhUBLN5geizIhbT
	D+tQ2vjddo5Ion0ZuN8JQx61CQcXRcp8txL9sUTob7NaIeaPCvxxs3NRNeyd/ND4iIflM/uDI9JjW
	XmloBN2M9RGwctCTYjIaA3vxwoJqK1SoPNJozUQ8A1aVMtlSOZOKIciTm01K8Zl33CgeyYtzAxq45
	9/kEMFfYlMV+Z9P1uVJgnnzgApWaaKCzETXI09tdksh+9avpyKDQOA/0y+4uFf1HWIp6k7XK4D7vW
	WU6AX3hQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wATH2-00000002QPR-2848;
	Wed, 08 Apr 2026 10:48:52 -0300
Message-ID: <817395109cbfd3cd58203ea300eca8eb@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: NeilBrown <neil@brown.name>, smfrench@gmail.com, David Howells
 <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] smb: client: add support for O_TMPFILE
In-Reply-To: <20260408065719.GF3836593@ZenIV>
References: <20260405211819.1251369-1-pc@manguebit.org>
 <20260405211819.1251369-2-pc@manguebit.org>
 <20260405233222.GW3836593@ZenIV>
 <177543319568.1474915.17445767081272255066@noble.neil.brown.name>
 <98c9845554e2e6a79965d68ba8ae722b@manguebit.org>
 <20260408065719.GF3836593@ZenIV>
Date: Wed, 08 Apr 2026 10:48:52 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Mon, Apr 06, 2026 at 10:28:51PM -0300, Paulo Alcantara wrote:
>
>> IIUC, this is what we currently have
>> 
>> * cifs_atomic_open()
>> 
>>   init state: in-lookup or hashed-negative
>>   [d_drop() + d_add()]
>>   end state: hashed-positive
>> 
>> * cifs_tmpfile()
>> 
>>   init state: unhashed-negative
>>   [d_drop() + d_instantiate()]
>>   end state: unhashed-positive
>> 
>> * cifs_create()
>> 
>>   init state: hashed-negative
>>   [d_drop() + d_add()]
>>   end state: hashed-positive
>
> IDGI.  Why shouldn't cifs_create() simply do d_instantiate() instead
> of that dance, ditto for cifs_tmpfile()?

Yes, makes sense.  Especially d_drop() for cifs_tmpfile() which is
simply a no-op.

> The only case where you want to change the hashed status is in-lookup
> O_CREAT ->atomic_open().  And there it's not d_drop()+d_add() - it's
> d_splice_alias().

ACK.

> I'd lift that d_drop() out of cifs_do_create() into the callers and
> get rid of it, along with d_add()...

Sounds good.  Let me play with it a little bit and, if tests survive,
will send a follow-up patch fixing all that mess.
