Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CC2312807;
	Tue, 14 Apr 2026 09:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776159965; cv=none; b=dricxQEAUjJzDsup/kLKOab0DLlaj7H6Ts9eNdP+feIs7f3+1HWuLMx5Y1dn9qvnjmaf1OUjwCYrWafX+KFytGDrlAHssO6P0DHomBvLzoAyx315MkrsgLBGQnhc+Sspi2ss9ltUMPaiT/A9SibahSSA+NWb2V2I1usym3qnRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776159965; c=relaxed/simple;
	bh=oTBMMrZ0WwYlS0VBPYtswgP7rWKp6SV6mrmoV1WuJFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YApzCnOe5kjGC0xMWWVVTyXbnH9I5+vIZfAWHrlZDG54jXBJKlPqg10ZgRf6pJjwSYkoNWEYYzsIiJhjULWW4CJHD9g9w/5uIkFVOZiDsWw+wNzHcxdDCus2caPKkO8p9WwR0WaP+yyjqsIG0j5JMCTnl8OOuK+bGLbwULlqO4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlAovLXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlAovLXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D91C19425;
	Tue, 14 Apr 2026 09:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776159964;
	bh=oTBMMrZ0WwYlS0VBPYtswgP7rWKp6SV6mrmoV1WuJFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlAovLXv38p9O5RR1blnsSS4iYbhpQ+E4A/24iX/4y2FsC6A/rM55fg+On1eMt/lH
	 SVNkKNZ5JcZpJdKnH0nhScf227ChtDLbcL86GtPRmINSi5D/t3YtAPbhl0CREzM5Ig
	 FNSt+AOoDd+Le2PGAscjwM4bBO+K4hvOPoxawXowXXUnKtkyio/FyIfVu2CHW1DYkX
	 DAOanp90mS75auRwrrscVZIme9rC0p7N9aj6ndb1waP0l3zznK5822x5m2RyT9UuMW
	 eoPcv/PirA2YY19y7GKLfCcG9Avp+aoQIezE1np91/jY8EFyrYIYKHxnc5t5IiXTEL
	 EGpc6fXVZdcIw==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>
Subject: Re: [PATCH v2 0/7] netfs: Miscellaneous fixes
Date: Tue, 14 Apr 2026 11:45:49 +0200
Message-ID: <20260414-ellenlang-imposant-90fbc86f78ef@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414082004.3756080-1-dhowells@redhat.com>
References: <20260414082004.3756080-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1849; i=brauner@kernel.org; h=from:subject:message-id; bh=oTBMMrZ0WwYlS0VBPYtswgP7rWKp6SV6mrmoV1WuJFw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTe47m65eNH59wEH2n+VSs+Zl0Nm6nlGy66wDhr5twN0 tuU+yM7O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyYzXDf3cX9r3HdjdZ+71N Dj2W9+zA7M2i56azvzmxdu7uiQ1Wa6YyMlwMU+c9uvzqVrNJj6Y86/TSZveUeXl0Q75Q5C5d0fd f3zICAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 14 Apr 2026 09:19:56 +0100, David Howells wrote:
> Here are some miscellaneous fixes for netfslib:
> 
>  (1) Fix triggering of a VM_BUG_ON_FOLIO() in netfs_write_begin().
> 
>  (2) Fix error handling in netfs_extract_user_iter().
> 
>  (3) Fix netfs_invalidate_folio() to clear the folio dirty bit if all dirty
>      data removed.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/7] netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call
      https://git.kernel.org/vfs/vfs/c/adcb8efb5429
[2/7] netfs: fix error handling in netfs_extract_user_iter()
      https://git.kernel.org/vfs/vfs/c/8ef352bc015d
[3/7] netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes gone
      https://git.kernel.org/vfs/vfs/c/920532e4996c
[4/7] netfs: Fix streaming write being overwritten
      https://git.kernel.org/vfs/vfs/c/1bfeb53e990b
[5/7] netfs: Fix read-gaps to remove netfs_folio from filled folio
      https://git.kernel.org/vfs/vfs/c/d259cfb7dd32
[6/7] netfs: Fix zeropoint update where i_size > remote_i_size
      https://git.kernel.org/vfs/vfs/c/bb3dd1ea2628
[7/7] netfs: Fix write streaming disablement if fd open O_RDWR
      https://git.kernel.org/vfs/vfs/c/eac38f8a2b85
