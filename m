Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3F4C97
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 22:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745964034; cv=none; b=CGO/oV9apluqSjigY/VNC72aYipv9MuXoOddxvK6ZOh16wVSXkOwC2txVU4feUn15D6u2CxvEuWU9im7VlNJt3WIsRmPa29UK4o8U8/v1z06lgu0amWdJ52NhxiynqNIeK9/qaFSkeTXXjC2PN96IwYctWHr0XVMg5ibCPTQ4oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745964034; c=relaxed/simple;
	bh=rIJgNNc0qzTn5nzHs42MuGFPNU7kX29OGVdI+qSj1Nc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=uUZmBDpHz2W9iSJ8tIe38h7gPsPFNCEsMLpzgTZo0NMyWkKs8m7l7jIP2AByzKPQtDWOzw/nCo3sFpy4Xs0LVHt0XncF5ppXKgwX+PrmxDGerc7CAWfwVSc7vjUehyBBqrqwzNxNNfiAKtNoFolBYEyDkAuhAWOO4HJ6VBjPTd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=WDtAC8Yt; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="WDtAC8Yt"
Message-ID: <20ffc6424e8715005893a56c24a64a76@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1745964031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kVpaGKjaUOjRa0iQw+kUzzsFtgyuhxSAKY8cHvESh0=;
	b=WDtAC8YtXpdkUnZvy1s6FiUt2nVXob6DII4iiZpODowUyNwJn4NROGZFaWDwmVp1Vtvyn5
	Ko8QFoyZOhhweq6Xi7+QlDDDxbQZTEQRcu3H99VPUg4vY804q4Jh0DPPgbuun7zU1Ae4wb
	sHMhUvFjq03ThOZRJQbhV7d41f4+qRUJYK+5JbdGQEVYh/ow9KbH6eJ2NadeQHHnYuCRXo
	w86myswvOU6/tpS0wfxqqHs4syxVtM8T/dtVRjGWji5YmJkRFkwQGM2fptsm0wtQOSViVx
	sjKePK9ddBR4bjbeYTx+0BpGar4izkaVO4+ELJjVUo79fjtuc34kAbG5dwuahQ==
From: Paulo Alcantara <pc@manguebit.com>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: ensure aligned IO sizes
In-Reply-To: <442319.1745962381@warthog.procyon.org.uk>
References: <20250429151827.1677612-1-pc@manguebit.com>
 <442319.1745962381@warthog.procyon.org.uk>
Date: Tue, 29 Apr 2025 19:00:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

> Paulo Alcantara <pc@manguebit.com> wrote:
>
>> -	if (ctx->rsize == 0)
>> -		ctx->rsize = cifs_sb->ctx->rsize;
>> -	if (ctx->wsize == 0)
>> -		ctx->wsize = cifs_sb->ctx->wsize;
>> -
>> +	ctx->rsize = !rsize ? cifs_sb->ctx->rsize : CIFS_IO_ALIGN(rsize);
>> +	ctx->wsize = !wsize ? cifs_sb->ctx->wsize : CIFS_IO_ALIGN(wsize);
>
> I would flip the logic:
>
> 	ctx->rsize = rsize ? CIFS_IO_ALIGN(rsize) : cifs_sb->ctx->rsize;
> 	ctx->wsize = wsize ? CIFS_IO_ALIGN(wsize) : cifs_sb->ctx->wsize;
>
> that puts the default last.

Sounds good.  Will change.

>
>>  	case Opt_wsize:
>> -		ctx->wsize = result.uint_32;
>> +		ctx->wsize = CIFS_IO_ALIGN(result.uint_32);
>>  		ctx->got_wsize = true;
>> -		if (ctx->wsize % PAGE_SIZE != 0) {
>> -			ctx->wsize = round_down(ctx->wsize, PAGE_SIZE);
>> -			if (ctx->wsize == 0) {
>> -				ctx->wsize = PAGE_SIZE;
>> -				cifs_dbg(VFS, "wsize too small, reset to minimum %ld\n", PAGE_SIZE);
>> -			} else {
>> -				cifs_dbg(VFS,
>> -					 "wsize rounded down to %d to multiple of PAGE_SIZE %ld\n",
>> -					 ctx->wsize, PAGE_SIZE);
>> -			}
>> -		}
>>  		ctx->vol_wsize = ctx->wsize;
>>  		break;
>
> Are you sure you want to get rid of the warning for the misconfiguration?

I just found it annoying when mounting the share multiple times with an
unaligned wsize value.  I'll keep it but I'll have to warn for the other
IO sizes as well.  Printing them once with VFS|ONCE should be better.
