Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F48B382368;
	Mon, 18 May 2026 19:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133587; cv=none; b=g8xnnk3J+5GACzYVQn6mOrfYl/vnzb66N9iHhmHOyB/wx7hT3T71UrDQ+HcNLKzV6iC98uXjSZtMpa95NkuBFoKanbVNphCy2pUy6/Y19071ZHUOeJfHF7Nn3Jhp/fLPbGqcGA7W5+r0zAlz5INHmMbQaS1gzpEYYe+ZwH3gYXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133587; c=relaxed/simple;
	bh=7CZiSpKGy3aqYpayTBO4axTiPSITWww+ahtBHVtxsBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iN4idXn0U3LMMbiOEIOjB4gJLCk91epTlEZFTO9Ot1NfbakAipuIGGnurqLhszxD5qNk+4uNeixCIt+Sf85BqMxHa+9sy5urJdE3Jsx2LDxw+b5ikWHmnqrSWHIWDKyc/+DMuyufmJ+j8aVuLTtvFqCKKaY/xMjp9n2Z86E4dHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPMBbs1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPMBbs1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858FC2BCB7;
	Mon, 18 May 2026 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779133586;
	bh=7CZiSpKGy3aqYpayTBO4axTiPSITWww+ahtBHVtxsBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uPMBbs1ESSbAvL38xLqkZTQAADrETvKzkpP+dBRQaso6QiNqlY471oIqI4VESu8mJ
	 Q0l7BHNaH1++m/ehG1seELchK66HqhNH3KZBLLYcTFewwBgdCTfkMSmV91SwJwlY82
	 cUdmpyRTkdkBauz1AGFh0yGKIgijH21ZKn6wDmxxkFfb5yEN6E+fprg7425G1I+jnx
	 tApDxkNqAkbgdaqltIagIFo18iDKOy99X6tSt2GsqKMewogSxR6GGkUY1GthBKpghk
	 wz/PiEAYit0bj89vwGmUnUjmr09mjFEd7C+mLIyBQa95JVtCTb128Q3h14MKAlTr/8
	 KFoIdezZ/CRaw==
Date: Mon, 18 May 2026 12:46:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>
Subject: Re: [GIT PULL for v7.1] vfs fixes
Message-ID: <20260518194622.GA2914683@ax162>
References: <20260518-vfs-7.1-rc5.fixes-3eded3a501f4@brauner>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518-vfs-7.1-rc5.fixes-3eded3a501f4@brauner>

On Mon, May 18, 2026 at 09:35:59AM +0200, Christian Brauner wrote:
> David Howells (22):
>       netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
...
>  fs/smb/client/cifsfs.c       |  38 ++++--

The changes in this file from that patch breaks the build with clang:

  fs/smb/client/cifsfs.c:1390:29: error: variable 'old_size' is uninitialized when used here [-Werror,-Wuninitialized]
   1390 |                 if (rc == 0 && new_size > old_size) {
        |                                           ^~~~~~~~
  fs/smb/client/cifsfs.c:1307:37: note: initialize the variable 'old_size' to silence this warning
   1307 |         unsigned long long i_size, old_size, new_size, zero_point;
        |                                            ^
        |                                             = 0
  fs/smb/client/cifsfs.c:1375:13: error: variable 'zero_point' is uninitialized when used here [-Werror,-Wuninitialized]
   1375 |         if (fend > zero_point)
        |                    ^~~~~~~~~~
  fs/smb/client/cifsfs.c:1307:59: note: initialize the variable 'zero_point' to silence this warning
   1307 |         unsigned long long i_size, old_size, new_size, zero_point;
        |                                                                  ^
        |                                                                   = 0
  2 errors generated.

There were no -next updates last week, so it seems like the majority of
this pull request saw zero -next testing time. I see two kbuild test
robot build reports but I guess they were ignored.

  https://lore.kernel.org/202605031459.eX5UbO3K-lkp@intel.com/
  https://lore.kernel.org/202605021450.ca5QGqLH-lkp@intel.com/

-- 
Cheers,
Nathan
