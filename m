Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529386;
	b=U7Qc/Kt+CCm6MQp5PfbHSZhiYmeiA+VF7IcZj3sASKvhlauFiknG0wZNamVVUOxuWfkk
	 wG5amB6yJa+6E3W4wAPW+vc7d+v1gEEkgKQY1uNasltJuyNNTV+RoCXitv3Jz/ljFWrh8
	 jL5MsKW84gLxJVKlioDcrqvcOAoJ2Fs4DNBJl520GleEezEzEQg2I/0wPXvTIeoltvjdf
	 lAHuKLKmVcQRsjNg4hzO/Ht9Q+hRyRA0xp6oElEN5SR4zBvKWbPa5xTLkicyLBOvtzG6Y
	 7IQXEvMIqn4qA18F28L74U514lmQt1bV4uanLb/92aoM+RfkhpAR6nB/XSAvKicRAQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529386;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dh8wV/jJ5UfA4S3B5D1pgryN5AOY10+5zoMt8CWEc78=;
	b=PJPEhZZvQz7q+4mfPUWaxnY2e2LE03Qozrz4GHCAUqZ1pZlzMSA606U5BmjqHqzDyNXG
	 +4fJVajTs2ohyYlvEl+zgVQd3DfHlicgbG2b1/3eaXwJqekszQ+7LRAcKg8ouGmkkQ1uD
	 SkESDGh8dCodYEoJNfkUhri1FNOdGuCc8g0dp/WmcLK4iU8MXNa5VKbXjtWvMWAwHo8nJ
	 ADnNHCIlbCm2SiZp/mh8b0nefu6sSMv4y0kwGO+By8DXKIaQgUsNzwklMyB2ReNdUuzl9
	 xh3RAxZWlQXwnGSMp0DoBTLgSx9osSLsoonWmVFKbpzGjmXgBdp1rsD30c6miwZ6w+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtbSDrfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 43709606A319;
	Tue, 20 Oct 2026 20:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtbSDrfK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 47F001F000C9;
	Tue, 20 Oct 2026 20:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792529385;
	bh=dh8wV/jJ5UfA4S3B5D1pgryN5AOY10+5zoMt8CWEc78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LtbSDrfK/jnkOMIk1Vq/D6h1ukD57ByPKlcwGDFV0slDf9Q6JfzcgyssFWm0qkzsP
	 hVg/PQaVAsiqrdJFUWWX5WGGfj9FTPDcwP6XFpo4yDxFtRKNQocCUTN9ncdtBMfBe6
	 8gRawyU7SaQZQ9MRf4l5B7QnZR8wPpZvA5fizxvMhCWXjdJpeHshcBby5dssWv0evN
	 JlVnSmUhqoZY73KXweMXwkVAH1gToajWnUZWeqB2zu6GUujDKXzVRBlg5WDozD6V4z
	 UXyY43FQosz/5izpy6BPjW3au8xOpNHgFoZ87dWtF7i6FVQN2QN33+mwUfzXCRUDkX
	 DVCZ7MvNrA6Cg==
Date: Tue, 20 Oct 2026 23:49:41 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
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
Subject: Re: [PATCH v4 1/3] KEYS: Expand key->{datalen,quotalen} to unsigned
 int
Message-ID: <atfT5WJU_ldjpQOM@kernel.org>
References: <20261020174325.2229448-1-jarkko@kernel.org>
 <20261020174325.2229448-2-jarkko@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020174325.2229448-2-jarkko@kernel.org>

On Tue, Oct 20, 2026 at 08:43:19PM +0300, Jarkko Sakkinen wrote:
> In key_alloc() and key_payload_reserve(), key->quotalen and key->datalen
> can receive values larger than USHRT_MAX.
> 
> Example:
> 
>   keyctl new_session >/dev/null
>   owner=$(keyctl newring owner @s)
>   keeper=$(keyctl newring keeper @s)
> 
>   for ((i=0; i<16384; i++)); do
>       key=$(keyctl add user "k$i" x "$keeper")
>       keyctl link "$key" "$owner"
>   done
> 
>   awk -v uid="$(id -u):" '$1 == uid {print $NF}' /proc/key-users
>   keyctl clear "$owner"
>   awk -v uid="$(id -u):" '$1 == uid {print $NF}' /proc/key-users
> 
> Because key->datalen wraps around 65535, the quota refunded upon clearing
> is truncated, causing quota bytes to leak in /proc/key-users.
> 
> Change the types of key->datalen and key->quotalen from unsigned short to
> unsigned int so that they can carry the full payload length without
> truncation.
> 
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reviewed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

For any kernel patches I've missed all Sashiko reviews so far and have
not taken the feedback into account in anything.

There is two issues:

1. I was not subscribed to linux-security-module. I could be and have
   been but probably when I've changed my list subscriptions at some
   point otherwise, I happened not to be.
2. Even if I was subscribed to linux-security-module, at least I'd
   like to get reviews Cc'd that concern my patches or patches
   sent to me.

Now that Eric pointed out Sashiko review I was able to look up this
via web browser:

https://lore.kernel.org/linux-security-module/20261020174325.2229448-1-jarkko@kernel.org/T/#mccc5900222fdad9d790be343fcec2a32540ed2fb

This is somewhat inconvenient though that it responds like that, and
not to the review thread.

Not actually sure how do you write a Sieve filter that automates
relevant-to-me Sashiko emails going into some specific folder but
I'm sure that is somehow possible. I guess I'll start by subscribing
to linux-security-module.

Br, Jarkko
