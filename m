Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368B115AD90;
	Mon,  6 May 2024 23:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715037092; cv=none; b=X3egm2DKPsTySt6kq3JuTgsSSOJ2/z20lefeKKL6p9fnICOIwvNAlYXOkSCWAYhh2Bjz3J5FZKdj2KQhGvsYv001WSdi6bysfssWIMoqGrjFPxl3+lHhe1E1avH6gRtY7d7WRycYH9qfXIsczlNoJgce0tWQDN/kx9UviWYagu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715037092; c=relaxed/simple;
	bh=qpYWJFEvBlxDIikDTcBC3mTe3tKzXg3f7B/YglwL+I4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8jC2eWy2Ag2PL0q/1oXj7gxfbYFRNZGwEJBgQjXQSi8FfrLduC9O6xf4XEmkNlwJ96kLCA2gEdNKgO0Z+FzbA+pUSu+aTnUbzkasc1M5eJemYYfxL+G23Q2B+nIh2ZLwtnzEn6W9IvuKstZqD1NWtffDfWXmY/CSwWTO+nvExA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7i7wD3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7i7wD3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE44C116B1;
	Mon,  6 May 2024 23:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715037091;
	bh=qpYWJFEvBlxDIikDTcBC3mTe3tKzXg3f7B/YglwL+I4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L7i7wD3Mh3TesasIjjUJ57kvs/3m2tfUrVCv5jZVGKtGgBDzcoYY+xXbMBg1IagRl
	 Qmbfe+kkg1D+pFHALim6MC/vIxyh6fqbEVwsRufSorJJEXkrcJ5kktCXbmN+sE3WZv
	 6nonD3epsvYal9tYPZz2+mxhx4aOL0fFDVVcNj21mxvYdFSVRuW2I1d3mKLMK1r8MZ
	 oFCmhZ4VBEquVWmSufZHZLzsP9HirPbWZWkGMS2kXIaDOoBlAAM15J+QNX1A3QUjU/
	 4S0E6eIGb0jRXgQQ36V+hoBiVG9N6DKU86nXGa1n6YyfjXRjchItegp4o5UOfUwwPO
	 6yXO/nXuKC3vg==
Date: Mon, 6 May 2024 19:11:30 -0400
From: Sasha Levin <sashal@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
	CIFS <linux-cifs@vger.kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: backport of missing fs/smb patches not in 6.6.30 stable
Message-ID: <Zjljol_GiXW3bKid@sashalap>
References: <CAH2r5mtC8NK=bH6qZfN6qwa=jot_scuLiDfYWSbFMwDWmkthOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mtC8NK=bH6qZfN6qwa=jot_scuLiDfYWSbFMwDWmkthOA@mail.gmail.com>

On Thu, May 02, 2024 at 11:28:38PM -0500, Steve French wrote:
>6.6.30-rc1 has a large set of fs/smb (cifs.ko and ksmbd.ko) patches
>backported but was missing more than 30 fixes so I put together a safe
>backport of the remaining, leaving out patches that had dependencies
>on things outside of fs/smb
>
>The following changes since commit 488f7008e62890fae8c7a2d3583913c8074f1fc6:
>
>  smb3: fix lock ordering potential deadlock in cifs_sync_mid_result
>(2024-04-30 12:30:53 -0500)
>
>are available in the Git repository at:
>
>  git://git.samba.org/ksmbd.git tags/6.6.30-rc1-full-fs-smb-backport
>
>for you to fetch changes up to 411b6f385ac2427ee9d70fae277a4ed6b9d3983f:
>
>  smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-end warnings
>(2024-05-01 02:18:25 -0500)
>
>----------------------------------------------------------------
>full backport for 6.6.30, includes all 80 (of the relevant) missing
>fs/smb changesets
>
>Test results look good (and better than without the patches).  Here
>are the functional test results (they passed exhaustive set of tests
>to various server types):
>http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/builds/99
>http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/117
>http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/9/builds/51
>http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/10/builds/63
>
>Note that 22 patches had dependencies and were not appropriate to
>backport and are not included, but here is the list of the additional
>80 fs/smb patches included, many of which fix bugs (the others reduce
>risk of backport, and help avoid merge conflicts):
>411b6f385ac2 (HEAD -> fs-smb-backport-linux-6.6.30-rc1, tag:
>6.6.30-rc1-full-fs-smb-backport,
>origin/fs-smb-backport-linux-6.6.30-rc1) smb: smb2pdu.h: Avoid
>-Wflex-array-member-not-at-end warnings

Thanks Steve, I'll pick these up.

In the future, if the patches don't need massaging, just a list of the
upstream commit ids would be great :)

-- 
Thanks,
Sasha
