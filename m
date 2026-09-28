Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD90A2DFA3A;
	Mon, 28 Sep 2026 05:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572569; cv=none; b=QkNXsvyjUC73OdfuFgkPLvebUF/Z8xuuEZ8eCvHDGbjNkpycjTmjsEot+J/e9uxtoQQYD9bHZE7IF/iPxAFdqhczHfLHm6WLfkgUcq5Wy2xM50CwenG71RbUoHq6Dn/WcGbuhorsUKHdezrq7EnScVdkwsmN6p/5Dgvz/G7ZVpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572569; c=relaxed/simple;
	bh=jJDP1WGliYUG1BeCYo80zVySbsIovC8dCX9Cz9papEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLbCmZHea+U0IbTBmc9Svga7RDBfXL2cO9gqPhmkIGgBrRItgyj4iUfwITR2uGPYuNyTJrozwFhXy3ELEWjSUD4Z65IbcxgMwQPLzpB/jWRpscv6trCYgKnAfRxPqr2nXuLDG0Wgh7Qey+JO/Nrpocww0FDKCcasyMIFufHfK+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=jNFDsa7+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=k4cigvjh; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="jNFDsa7+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="k4cigvjh"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9216214000A1;
	Mon, 28 Sep 2026 01:16:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 01:16:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1790572566; x=1790658966; bh=Pp2T234dxP
	iZ9yPXbpgvnQGH/84HEKbpDYLipPtuYok=; b=jNFDsa7+8rauPT1N0xCz6wiDMr
	/EbZxUgPWaxeDuL2CkFUJKHN/HF8vqGXf+3Z6Qen8gXcqzRAZ80vrhKQaA68Q6mF
	A4lt2Vn9rg4HtL0Wg1JO7i+IG64kgSRRRYu7Mi8M4xqG8g3oNu8vSFZRghoa3Y7u
	jZucbqKdefKAwzaQWFYCB9ypAwzi5fqkpmjxWR4QLjzrJhHI+4R1/LzzsQf13tsH
	Qp2bweFW9wwb96k7xY1goDrBsSF1/jYBAVUjexPEJkDcNXOFxm0T3EaQ6lzua1ZN
	kffUDCxXfkkwXPxk18ggvhJjIEKplruv0CfjJFG1Ql041Sy52221Hmvd9OsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790572566; x=1790658966; bh=Pp2T234dxPiZ9yPXbpgvnQGH/84HEKbpDYL
	ipPtuYok=; b=k4cigvjhjx0yN3ijY+7o+M6dMFagEYGTbN7/RJ8WC3wKMeL6BKz
	oIMSB+JCt80sYlM2fhj01UABE4+dbt9LbhyZMOFor/FrYinib8O3pi6dwS6s3LEQ
	vfbgPdlGfdUWG+QeXCYQRTRD91PK/a6KGJrUT7W2tFN09lS7SER82uxUjkCcp1T3
	FxhBKg0p6aPMs5S8k44ETbWCmecx7YW2SazeQVrwy/eCnHiDj/qA/LxGUayweW4a
	xdLF4oDk7U6rMKLy+YYkRK+xpAvyUJBcckVuGNgCpByoS12a3pSRAQEyTLksClaT
	yKlxqw6cSCz1KPDNrcdws0gDpUfl1cTd9Sw==
X-ME-Sender: <xms:Fvi5ahiiA1zM2CD6efS7zS7YqVC_oTHNEKOnBz69sxchd2WqXSwXcQ>
    <xme:Fvi5akjS047xqefcNGovL9fESrbiK1yals3A7m7dBjFKo-8cToUBwLiXsWj9GNdMN
    3h4bP7ygCQQ15jqsUDDz_n3nTjFXCr3Bs94r0C6UI_RHvqReiI>
X-ME-Received: <xmr:Fvi5an5Ued8L0zVeDKeEKFOQvJAtuAQXEd4Hjkdmt0e02VKDZ-8H2JyUBHWV8NhwN6i59Uwik2CvCmDK1C_3bmuMOreeH06wTvYdo-bln6Y>
X-ME-Proxy-Cause: dmFkZTGRRSPD9+vV47KYqoBTk+U3XPaUbLoHWNfqn2ej9m2/UWEVudtX30Nq1rUXt05IbZ
    ptRMEknEgXXQvgG7C6uZ0IK8i9VIy4XUTJLI5Ti8jQSQ2gklG2QUQKWsCigDTGReLaHNH8
    hooKYf8joIdtZSAg8hEVbzDdtl8+moFRsAkxbswDMas8fdqG4sVhzEfelGikIHbLD6953B
    3vsZFx80xq8Oi419kyWYaZCIxWoB9CJqk8bIQ+mL8rSGlkorHikD5omq47y86Qr4JBHy6d
    yEVbqehUXec+l4bkQlGoy6sDwO0o5mrSKwochNahfyt9ASDpD80u0CmDXVvWewPclknCXM
    u85qKjmhLEkt0Hb9X6BEMBYEM353YKxTylFSC5RwIQfvnPA2xPYRmKXG915W5uLBEC6ulP
    tJVluaR9xBGfasdxXDPe9Mneh02UBghN/WZgsM2wALgFNGF8Ts7Utx5vS7LQuww36klRes
    7PItYG4SG5kjDQJJrqwvL5OAVlkV614/TckBTbPGY89Tacli1QmDUxsPeEN3KAIa/A51nH
    BkK6fTCv1JTtnHunZ5+29JPFdpMT3eFmB8hfjrzAIoPbHewN59AtIDHtRkC/WqsWWs7m1S
    utJPWcYp7xoHBvcNRRof9abHDeQQmJcsVIsNAQowh2+plZFxRHXR7pFZyk6Q
X-ME-Proxy: <xmx:Fvi5amR5ICKqL_VwW6HAfCxQU4VWbpZfh2Fg8TUkeWNQUFdwj0hPIA>
    <xmx:Fvi5am_FEiUK0GbYK-jUnuQv-8k_5ypT_qlTsgjeChBtku8e6DpSCw>
    <xmx:Fvi5anpI7CYX7LYQQnLAhxs15HxaSOZsjpk64ik3T4blQuieadq1sA>
    <xmx:Fvi5asV93VbI0Mv1Sdppa33kQ3VzYWcvsy1yV8PrddFEbuw3OulsYw>
    <xmx:Fvi5arAg_jskaW0Vp4-CSFXNg_qxZPfp8JiB8pIuPZsQ0xjxoRBkvP0r>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 01:16:05 -0400 (EDT)
Date: Mon, 28 Sep 2026 07:16:03 +0200
From: Greg KH <greg@kroah.com>
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] ksmbd: verify transform SessionId matches the decrypted
 header
Message-ID: <2026092848-retaining-unlaced-7767@gregkh>
References: <20260928031300.1782690-1-zhangdairui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928031300.1782690-1-zhangdairui@gmail.com>

On Mon, Sep 28, 2026 at 11:13:00AM +0800, Dairui Zhang wrote:
> The decryption key for an encrypted request is selected by the
> SessionId in the encryption transform header, but the request is
> then authorized under the session named in the decrypted inner SMB2
> header. Nothing compares the two, so on a connection carrying more
> than one session a client can have a request decrypted with one
> session's key and executed under another session's identity. Since
> encrypted requests are also exempt from the signing requirement, the
> AEAD tag is the only proof of session identity, and it is checked
> against the wrong session.
> 
> Per MS-SMB2 the server must verify that the SessionId in the
> transform header matches the one in the decrypted SMB2 header and
> treat a mismatch as a protocol error. Validate the whole decrypted
> message before dispatching it: the message must be at least one
> fixed SMB2 header; the first operation must not set
> SMB2_FLAGS_RELATED_OPERATIONS and its SessionId must match the
> transform SessionId; each subsequent operation in a compound chain
> must either set SMB2_FLAGS_RELATED_OPERATIONS or carry the same
> SessionId; and NextCommand offsets must be 8-byte aligned and within
> the message. When the encrypted payload is a compression transform,
> the transform SessionId is saved during decryption and the same
> validation runs on the decompressed message. (The 8-byte alignment
> of compound responses is already handled by the existing
> chained-response padding.)
> 
> Reported-by: Dairui Zhang <zhangdairui@gmail.com>
> Assisted-by: LLM
> Cc: stable@vger.kernel.org
> Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
> ---
> v2 -> v3:
> - Per review, extend the check to the whole decrypted message before
>   dispatch: first-op size/RELATED_OPERATIONS/SessionId rules and
>   per-op compound-chain SessionId and NextCommand validation, shared
>   between the plain and compression paths via a common helper.

The "v3" isn't up in the Subject line for some reason :(
