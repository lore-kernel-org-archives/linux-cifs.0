Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06461EEA3C
	for <linux-cifs@vger.kernel.org>; Mon, 23 Jun 2025 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750708119; cv=none; b=iTFYsZwAWSwetIcNjjRFBBWApo1OR+g/aNK9If9qxasAu4Squ/YUQ9Nql2/xkUXtPRi3+LFjdt1kgl8TB9dJId/opdwmCnvoF9/iIishDKfv0YrMlVEgKGVzOW9vf5oy7cOk59dErj1CUsr+7DMxKKU9xf91WAfz1GNOcQ/nDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750708119; c=relaxed/simple;
	bh=vVEJ9Wn4oNfwt3PBcmaEB9fxwWekDOz1WpOnu5uMIFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRk97yxlg6zjSdBp3lQzAATAaU8sjhG58qc0Q2ME3bPuYtHGK2z7EIuTBz9c+3CAL0RpsjVojT7EiYvBP+ik8fNn/PmMeSr1f266N1i+ZEWLPuWlIWLRbkd0pnGdtoklPToy2Oh6GG3bVtc7PJ+fy7iIPClXtKtlp76TYFf45gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHfe0j5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHfe0j5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB53C4CEEA;
	Mon, 23 Jun 2025 19:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750708117;
	bh=vVEJ9Wn4oNfwt3PBcmaEB9fxwWekDOz1WpOnu5uMIFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MHfe0j5jRU8Z7Aih9crIhjK4xafZ3u06OZQIXRH2bdgzp4oh8poYoeCN5bXYWG91g
	 wkhgObuCCoNT25UFUePg4nJqpxe6/OKR+X9JKj3GAnsc7/511jER7TLVVkVXqRUHcM
	 Q8MN7NBfqvbv3SAtGkIyatp1U9+lXPRcpCondxN6vt8X/BxYO5PcNlvy9ERoEFYAtq
	 iOpOXGXhgsI5fY887cVI6k6nAbx9qdQzokIidpUAuwozn/aK94v3FRm4T0bGcMGlE8
	 JpfAEb6j/8qnWLrFtTl+duiIOOtibbJk8vaunwOirYPQemjnBseJapoi5k2divW21j
	 Kde48/40LuGRA==
Date: Mon, 23 Jun 2025 15:48:35 -0400
From: Sasha Levin <sashal@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
Message-ID: <aFmvk2YFA7zj40V6@lappy>
References: <cover.1750264849.git.metze@samba.org>
 <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
 <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com>
 <a3073003-7f07-449d-8abf-dbe125ca3779@samba.org>
 <CAH2r5mtqRX_pC+dCCFf44=m58vujkDJJLnZBGypycNfRSbj4DQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mtqRX_pC+dCCFf44=m58vujkDJJLnZBGypycNfRSbj4DQ@mail.gmail.com>

On Mon, Jun 23, 2025 at 12:28:56PM -0500, Steve French wrote:
>Checkpatch will complain if you put a diff in the description so I
>suspect a link in the mainline patch description to the stable
>backported version of the patch is better than a diff in the
>description.
>
>Sasha,
>What is your preference for how to send a patch to mainline, that will
>not apply to stable, but a rebased version of patch is available for
>stable? Should the upstream patch have link to the stable rebased
>version? or just handle it as followup on the stable mailing list?

If you want us to not apply something, mark it with:

	Cc: <stable+noautosel@kernel.org> # reason goes here, and must be present

And just send a backport to stable@

-- 
Thanks,
Sasha
