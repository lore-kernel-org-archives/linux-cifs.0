Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47B1C3308;
	Mon, 25 Nov 2024 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732573529; cv=none; b=PGhZjQRW5GXSyQiD6cAn8F/ywWBPD7zvKeb+L7KcmeNKqTsVW6hTjNRIv7HIBsU4zNIDWoTX97HVoAGRkFFrEhTCfHNIGOXNxcFCclt3LfmTXoGzpjsprV9BnD0mypKWQgAs/HDvpazq7v5C7rha9BU1Vj3zHsajyqalmwIbD7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732573529; c=relaxed/simple;
	bh=EBPuKmA8nN6Gnr1yC6mRnpYTjnNMjFrjwv8z7wP9OqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eA5m+hRx6hKRzupVi2t5h/S0eSJ6GGxtD+iaD+qR0T+Z9q0ZIpXbTaAqnrw4ulpjoS9XZKmbtf5RKXn7b2Ch6fwqBxIjZLNnDh86cQR24LciQ7xhuxwB1mqv0FoFuq3KXxLpBitpfmPgF4E0kNe/KAAZ7wb+UCD/QyACD4O3CyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5fsexm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5fsexm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49952C4CECE;
	Mon, 25 Nov 2024 22:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732573526;
	bh=EBPuKmA8nN6Gnr1yC6mRnpYTjnNMjFrjwv8z7wP9OqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p5fsexm0l4tFIcElOZyHAxaxCpV5D6nzOG+FSwsFjTffihYNXfeUDo2I1k8HODAIc
	 KT2un/bE1wDybk0VwpB56nlKYdhj+ZELvs20Sigc2rFUfbOa+b9OYsxcw8lp90Guyj
	 YvmVm4E0egFd+uVcNeAImxbFICd3Ea5T7HclVLhAOq0bcAzwGAyJo2RRstbDNWrC+J
	 oOQS548u08QiA8yDKLUORaHknzCEa8b4MrTT/YWnScq8rzoe1/d/YcM8XgvR7m18Xh
	 ArRaZrZyQy3mVDy8UsgY08uxhfl8Lrbx0yTE+zE//qMsHzoa10kzuYzTrYfXBEpidU
	 +prC5CZmZ5UlQ==
Received: by pali.im (Postfix)
	id E8C075DA; Mon, 25 Nov 2024 23:25:17 +0100 (CET)
Date: Mon, 25 Nov 2024 23:25:17 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Add support for parsing WSL-style symlinks
Message-ID: <20241125222517.wxtwgfjs5rkcr7pj@pali>
References: <20241006090548.30053-1-pali@kernel.org>
 <CAH2r5mtLoAsZfHHe33=WfDjLZ1PNgV-SgcN1F-o0g1XXLsoAng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtLoAsZfHHe33=WfDjLZ1PNgV-SgcN1F-o0g1XXLsoAng@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Monday 25 November 2024 15:24:03 Steve French wrote:
> This patch
> 
> commit 06a7adf318a30bdcfa1222ed6d2640e6bb266d7b
> Author: Pali Rohár <pali@kernel.org>
> Date:   Sat Sep 28 13:21:24 2024 +0200
> 
>     cifs: Add support for parsing WSL-style symlinks
> 
> 
>  led to compile warning:
> 
>   CC [M]  fs/smb/client/reparse.o
>   CHECK   fs/smb/client/reparse.c
> fs/smb/client/reparse.c:679:45: warning: incorrect type in argument 4
> (different base types)
> fs/smb/client/reparse.c:679:45:    expected unsigned short [usertype] *pwcs
> fs/smb/client/reparse.c:679:45:    got restricted __le16 [usertype]
> *[assigned] symname_utf16
> 
> 
> Let me know if updated version needed

I have already reacted for this problem more than month ago:
https://lore.kernel.org/oe-kbuild-all/20241007213401.bsfqwlb4c2k6ynlr@pali/

But nobody on the list replied :-( So I do not know what is the best way
to handle this issue.
