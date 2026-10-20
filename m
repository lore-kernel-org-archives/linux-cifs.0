Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532617;
	b=GDGkDxjblo5Lyfu4NUVUIbp1h/occJLGSssIEW/pOCk4/iEz5RrNfpeHjIN9J0Uz6rsv
	 dtDpitDNBssz5YufUc/zo1S/7xVh0ZkbmGCHH0qOlg2OujMfRBy09lCzVAhpz7lWsiGZS
	 Vo665gL9kIblUYOz8TqAuS8oZ2Ie34YS3C7jT5Uavtv7MXQstaQVY4R6N8UE0iX/JPpFV
	 K2CgG/mPxa8hgUA6AIK06HAdSSvLUe1aSeHknCQTpxR36F+eRLI3C7IF62t0GpTxi0IgX
	 YgZMfrCt1Odd/w9mq/zsdGXLXA+CLdV8f2Z9Kx78kcojnS75d1FEcuQzXnV1695rm8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532617;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FZYzVeUNoWEzXy2Zmcwswz0fwSsjGxLRlMvQ0gDzSrE=;
	b=CoYOy1nGfTxm1P04D/jl5s+IE2yRAxDgPeaHVuOglQBdYORbGeM/7ERTpxpFvUEfi4t1
	 pNW2v0qgqr9jSvOSbEg+pnLmCmIccWqaCWoN1yTZllfSsEsPB/BIl5yGSIi/AJDKo/kmp
	 1dO35MOlgsQQTIsj7kcxeyPZwWnkmXlVp6Et0eU7BY8RfO3VHa9+mwrdZApoRP97/lUBG
	 y9mIF+c7BuNqfZbH5M0/U3mlX6CpvBAYtyEj+Bt94hadKXCP2gJgWNwwnfKYxZkJG20lg
	 qKynuO8TPf0T8sjKzMTd1Lg9SOyqXnsW1YCKGBRk5Hg2mKVfUx+mnYS1FSOK2Cbis4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AR0AI64/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F2A606A319;
	Tue, 20 Oct 2026 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AR0AI64/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8A51F000CA;
	Tue, 20 Oct 2026 21:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792532617;
	bh=FZYzVeUNoWEzXy2Zmcwswz0fwSsjGxLRlMvQ0gDzSrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AR0AI64//jsGud8X3shnr3IfAk1Durldm/X3dAsqwcTnDnzi99yMaWc+jfP2N/PeB
	 IHgRtf7Nzud6Im0g8Rc3BrAG5GTPUMAXhhuHVWwkR5Tw+JDRGlHqCPnZoOx2L1XzmX
	 QrT6COmsCVUG+TS2IzBDKlmhlnK9x1wmwcGHAqQCepMYe4ylIHYDJgZkyDIG+mdLzE
	 gWXRSRaTMSx21GQSCoGmMUR8wDHIPsSkTzCwuPFFGHBOtP2ni7iGZxjSuRCsroq4Nb
	 YqNpOfh1GG0gC87tYyEF5HIjxZYZO7NCWpebZ/H8dISspHTMfygozDnlHzb8UIOr+w
	 tuVS8J+WfmyLA==
Date: Tue, 20 Oct 2026 21:43:35 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
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
Message-ID: <20261020214335.GE699485@google.com>
References: <20261020174325.2229448-1-jarkko@kernel.org>
 <20261020174325.2229448-2-jarkko@kernel.org>
 <atfT5WJU_ldjpQOM@kernel.org>
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
In-Reply-To: <atfT5WJU_ldjpQOM@kernel.org>

On Tue, Oct 20, 2026 at 11:49:41PM +0300, Jarkko Sakkinen wrote:
> For any kernel patches I've missed all Sashiko reviews so far and have
> not taken the feedback into account in anything.
> 
> There is two issues:
> 
> 1. I was not subscribed to linux-security-module. I could be and have
>    been but probably when I've changed my list subscriptions at some
>    point otherwise, I happened not to be.
> 2. Even if I was subscribed to linux-security-module, at least I'd
>    like to get reviews Cc'd that concern my patches or patches
>    sent to me.
> 
> Now that Eric pointed out Sashiko review I was able to look up this
> via web browser:
> 
> https://lore.kernel.org/linux-security-module/20261020174325.2229448-1-jarkko@kernel.org/T/#mccc5900222fdad9d790be343fcec2a32540ed2fb
> 
> This is somewhat inconvenient though that it responds like that, and
> not to the review thread.
> 
> Not actually sure how do you write a Sieve filter that automates
> relevant-to-me Sashiko emails going into some specific folder but
> I'm sure that is somehow possible. I guess I'll start by subscribing
> to linux-security-module.

Well, the keyrings mailing list isn't currently opted into Sashiko
monitoring or emails.  linux-security-modules is opted in, but it's set
to have the Sashiko emails go to only that list.  See
https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml

    ["linux-security-module@vger.kernel.org"]
    reply_to = ["list"]
    positive_review = "all"

(Sashiko defaults to no email, because unfortunately there hasn't yet
been consensus in the kernel community to enable it everywhere yet.)

keyrings could be opted in by opening a GitHub pull request that edits
that file.  Let me know if you want me to do it.

My preference is what I set the fscrypt and fsverity lists too: enable
monitoring of the list and emails of issues found to everyone (but not
the noisy positive reviews, i.e. "It looks great!"):

    ["linux-fscrypt@vger.kernel.org"]
    reply_to = ["author", "list", "recipients"]

So for keyrings I suggest we add:

    ["keyrings@vger.kernel.org"]
    reply_to = ["author", "list", "recipients"]

Do you agree with that?

- Eric
