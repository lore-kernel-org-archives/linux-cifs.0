Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD63CB2FE;
	Sat, 17 Oct 2026 05:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792214927; cv=none; b=dqa7fgSzf5K7MoAeY2DFEg7Z/fab0/cAFcg9qNQJvsEnV3aCdNnemrhgb98kk0iCaP86VsaWB8h9tMarEvED8JmzoxuPiAFFKp/mLTe3ysy0hdRjjty/Tbgv2vREng6C6Vr1FLSPXmn+XgcJgj9V1iJ1Gqe1VHM6NlH+hWC9j0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792214927; c=relaxed/simple;
	bh=dcxQhAYdMkYqbjGzQhQuxLyVSo8w2KHBaD+beUtrWPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNg7/vILl5HCBk8DOrbUETtcDKRCwECCuGCNbVg0bH066zkLBT4+C2L712GzBJygyrFfUbmmVk3kB+4z5OOKAsxq+qUeVfTQfm1n0svUoFlv5vwPygejKAIewNMiBHNv+564kbN45SR9DNWVk2Vzjf0Q689gaPW3WSibaVdB4as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nskreV1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nskreV1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A4B1F000C4;
	Sat, 17 Oct 2026 05:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792214926;
	bh=EcaxPKxX9uoBFwTElF9ZUqxeiAMuQgHIDqV8C4YNeVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nskreV1tMtfy4uQ+q9SJPIWTUdkPtEyh8LsfJUwfsCR5J4zKDP6csQUUvk1lhYBzi
	 OHYpZ0GnpehraKwigrk3wdlLzV4sj4YTV8wdp+5Hog0vbAg+zOYU/ps+9gsGC9XDwB
	 vXbYwNJNIoCm/PeD7gY2AE3ygk+xODKbo2yskGUt9kbbTD/Jd4L39Liioh4GVEd/Z9
	 svPPXCa6xRTBimTEDOmahrexfyYWWMQrJNMN/7I7+B7q2xYKG635vgVd9rEGrcfHrt
	 fpvBE0UN0eFVBxYLPXchYzlFGRXQOvR4nZ6ZthBsrOc6jxhA5WpatAb6kUXRuYGpMr
	 UK8A3MuNSLSUA==
Date: Fri, 16 Oct 2026 22:28:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <linux-cifs@vger.kernel.org>,
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] keys: prevent quota overflow and widen quotalen
 and datalen to 32 bits
Message-ID: <20261017052844.GC29318@sol>
References: <20261016215326.4110064-1-jarkko@kernel.org>
 <20261016215326.4110064-2-jarkko@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016215326.4110064-2-jarkko@kernel.org>

On Sat, Oct 17, 2026 at 12:52:59AM +0300, Jarkko Sakkinen wrote:
> @@ -245,6 +245,10 @@ struct key *key_alloc(struct key_type *type, const char *desc,
>  	}
>  
>  	desclen = strlen(desc);
> +	if (desclen >= INT_MAX || type->def_datalen > INT_MAX - desclen - 1) {
> +		key = ERR_PTR(-EINVAL);
> +		goto error;
> +	}
>  	quotalen = desclen + 1 + type->def_datalen;

This should be tightened further to 'desclen > U16_MAX', since desclen
is assigned to a u16 later in the function.

- Eric
