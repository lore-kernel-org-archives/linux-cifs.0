Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295C21D5CFA;
	Mon, 28 Oct 2024 10:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730110395; cv=none; b=Era9zVzSyR7MDpqWEIFfNVmIJeUgZ14Wo19Fu5ZI0HalGsP8xzgckayNV9ZXPKWkCbOKRJrrhOQACvHhBHZeTWe2kr6bQ4zq8xJyLj7bvBrx4yRSvdalmclicBZscHp8aUMOstXr3IMYg5NAwAnRITVH8s2yNc9SKiU1PQNYZ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730110395; c=relaxed/simple;
	bh=7KsvxSW61uQXonMB89EN9dZ0RmwQxvzG3blD9ztYLGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXDWY/1gDEtc2W0+7Ul8wWsWpbH1FxhyW26jszJHGOsHXGGlH/UZ+ne+uS/v924lVAO+rghHBMChnY4hycxbO7UMa3jDrt8Wufbg4Kk+X2lAmOWv+c3WRfTWlPI9qv5qY1xkz1sLBaXPqseYb4nMKWaMdlhOeq8/mQh6aPL3/84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1RJ0+9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1RJ0+9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52402C4CEE7;
	Mon, 28 Oct 2024 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730110394;
	bh=7KsvxSW61uQXonMB89EN9dZ0RmwQxvzG3blD9ztYLGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H1RJ0+9ok5hGCX2SIgJq1YQA43g8Ak0DnLjrU3LfONI9aXLSU2qCtOesAJCLBrFuU
	 1EPAkn1558RKuqpDnyUKmXTT9dNAKf81JFAfGmUjcKVfXL2t4rcfTm3KTn41/ddBCc
	 qM8SZv9eUVrK4/ppwIL8C71MHMk0tla9GwC+/rdljCn/ynM3wAqF0IhSJ7XFofwONq
	 XsEkQHRmfqMxFI5Wtoe535AhZ85wEbodKn5Xoldye20Nw0efbGycIvGRpCzhZpajrS
	 IvjqcpsNYhfaw3t7OuWXbnX7ALkxvaBmFj94YjXuO2cYSgwBPNol5l0HUm+QK4W2bD
	 L8cubPCBNA9qQ==
Received: by pali.im (Postfix)
	id 34EECA58; Mon, 28 Oct 2024 11:13:07 +0100 (CET)
Date: Mon, 28 Oct 2024 11:13:07 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Allow to choose symlink and socket type
Message-ID: <20241028101307.nestealisxlusehw@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241012085252.560-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241012085252.560-1-pali@kernel.org>
User-Agent: NeoMutt/20180716

Any opinion about this v2? Is it better now?

On Saturday 12 October 2024 10:52:45 Pali Rohár wrote:
> This patch series improves choosing reparse format when creating new
> special files.
> 
> Changes since v1:
> * Instead of new -o reparse= mount option is now a new -o symlink= mount
>   option for choosing symlink type during creation, and new option
>   -o nonativesocket for choosing socket type
> 
> Pali Rohár (7):
>   cifs: Add mount option -o symlink= for choosing symlink create type
>   cifs: Add mount option -o reparse=none
>   cifs: Add support for creating native Windows sockets
>   cifs: Add support for creating NFS-style symlinks
>   cifs: Improve guard for excluding $LXDEV xattr
>   cifs: Add support for creating WSL-style symlinks
>   cifs: Validate content of WSL reparse point buffers
> 
>  fs/smb/client/cifsfs.c     |   4 +
>  fs/smb/client/cifsglob.h   |  36 +++++++
>  fs/smb/client/connect.c    |   4 +
>  fs/smb/client/fs_context.c |  82 +++++++++++++++
>  fs/smb/client/fs_context.h |  19 ++++
>  fs/smb/client/link.c       |  60 ++++++++---
>  fs/smb/client/reparse.c    | 201 +++++++++++++++++++++++++++++++------
>  fs/smb/client/reparse.h    |   2 +
>  8 files changed, 364 insertions(+), 44 deletions(-)
> 
> -- 
> 2.20.1
> 
