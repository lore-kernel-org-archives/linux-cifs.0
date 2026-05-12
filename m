Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AD83905E9;
	Tue, 12 May 2026 12:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589803; cv=none; b=X2PfmeAw5SxP4BFbmmipIdwpQ7dc/5HwaVfgeo2UrEiUKolMvyurSp1XQCUu/VDrNi9odch9iCUWlMPV32JxotJjRsmyVltb8i1/8hLX2PtcTJBhu7YLIJ3vuM90WFnrbybv8cG6CaYuorHvejJOwgL3effYc1+8mLTJX6OdAJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589803; c=relaxed/simple;
	bh=jfDosqd7UGS2Yf2KYMlqVd6Sg1zrZc7gNnLbAFCEMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LFlDvV1GnsPP2PU8RPfM/OHBEHz32ucLvtt9HCxlqNdHIML2kK/7j40NuNB1/nLUWNLpWm+Ed59KlKGm2EDeCKjk3aDJU1nzGMRlo+uN4ZQG1cjmKExTYafZPTk0akFohNoCX4TKS4++N7jpI0G5XrLn3ldBNFJXx8bLyrE5x9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfIIGkAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfIIGkAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BD7C2BCF5;
	Tue, 12 May 2026 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778589802;
	bh=jfDosqd7UGS2Yf2KYMlqVd6Sg1zrZc7gNnLbAFCEMnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfIIGkAW2zQ9Pz70B4IjUAMqSjAJUjARSHnMxa8Sevg0Gp7Pkia/NJYQ4rGrS8daJ
	 XNzJoNth2LbAqXaopPwWpqI8UDvgt7r0NtcU+7zvgnwfDj2LFGyZI4DHy0BnYhnjSg
	 RAIaUdjYdkeIO49Thld3c5kbS4X31acY+MJ3rFhTmM3eLDXC8rPg8wZTM2gg9qBp77
	 lLj6Y7JTW5/hhDAJZZiuQSjE+3tGh83BCnMWqAnns1YG1fEXyjacXQU5PpdxUlMrsJ
	 tk/29KdH62Ooz3jgDMYUAOQoWpYfVYFjo8rlq7h4gh75tWWCyFomPCJxTkO+ispD1C
	 zxYpIvvAibn/Q==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/24] netfs: Miscellaneous fixes
Date: Tue, 12 May 2026 14:43:10 +0200
Message-ID: <20260512-infozentrum-becher-7f86c47c96c8@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=4033; i=brauner@kernel.org; h=from:subject:message-id; bh=jfDosqd7UGS2Yf2KYMlqVd6Sg1zrZc7gNnLbAFCEMnA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQxK6Rej4lRzvFL8lkybQ8PZ4rujk1LmDdHPFXku/z77 4lsbTeDjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIksOMPI8ElxzrRjtUKBXGwW HL9e2y7YNm/Dkgzdyq6F5cUHp7peSmVkmLXdY4/CHDMT5Q2Ke1JOGC3PWj87NOJYT6ECW8yvX1Z WLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 12 May 2026 13:33:37 +0100, David Howells wrote:
> Here are the outstanding miscellaneous fixes for netfslib gathered together
> and with some fixes-to-fixes folded down and one rearrangement.  Various
> Sashiko review comments[1][2][3][4][5] are addressed:
> 
>  (1) Fix subrequest cancellation cleanup in DIO read and single-read.
> 
>  (2) Fix missing locking around retry adding new subrequests.
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

[01/24] netfs: Fix cancellation of a DIO and single read subrequests
        https://git.kernel.org/vfs/vfs/c/6f0f7ac1915a
[02/24] netfs: Fix missing locking around retry adding new subreqs
        https://git.kernel.org/vfs/vfs/c/cce18c263e96
[03/24] netfs: Fix missing barriers when accessing stream->subrequests locklessly
        https://git.kernel.org/vfs/vfs/c/b5782e2d462c
[04/24] netfs: Fix netfs_read_to_pagecache() to pause on subreq failure
        https://git.kernel.org/vfs/vfs/c/8a8c0cfdf465
[05/24] netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
        https://git.kernel.org/vfs/vfs/c/2c8f4742bb76
[06/24] netfs: Fix zeropoint update where i_size > remote_i_size
        https://git.kernel.org/vfs/vfs/c/4543a4d73794
[07/24] netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call
        https://git.kernel.org/vfs/vfs/c/dc7832d05deb
[08/24] netfs: Fix potential uninitialised var in netfs_extract_user_iter()
        https://git.kernel.org/vfs/vfs/c/7e3d8db899d5
[09/24] netfs: fix error handling in netfs_extract_user_iter()
        https://git.kernel.org/vfs/vfs/c/0aad5704c6b4
[10/24] netfs: Fix overrun check in netfs_extract_user_iter()
        https://git.kernel.org/vfs/vfs/c/0ef37eef83fa
[11/24] netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes gone
        https://git.kernel.org/vfs/vfs/c/156ac2ec2ee7
[12/24] netfs: Defer the emission of trace_netfs_folio()
        https://git.kernel.org/vfs/vfs/c/daeb443b9281
[13/24] netfs: Fix streaming write being overwritten
        https://git.kernel.org/vfs/vfs/c/7b4dcf1b9455
[14/24] netfs: Fix potential deadlock in write-through mode
        https://git.kernel.org/vfs/vfs/c/b6a4ae1634b3
[15/24] netfs: Fix read-gaps to remove netfs_folio from filled folio
        https://git.kernel.org/vfs/vfs/c/a41168aef634
[16/24] netfs: Fix write streaming disablement if fd open O_RDWR
        https://git.kernel.org/vfs/vfs/c/70a7b9193bbb
[17/24] netfs: Fix early put of sink folio in netfs_read_gaps()
        https://git.kernel.org/vfs/vfs/c/3e5dd91b87a8
[18/24] netfs: Fix leak of request in netfs_write_begin() error handling
        https://git.kernel.org/vfs/vfs/c/5046a34f0643
[19/24] netfs: Fix potential UAF in netfs_unlock_abandoned_read_pages()
        https://git.kernel.org/vfs/vfs/c/dbe556972100
[20/24] netfs: Fix partial invalidation of streaming-write folio
        https://git.kernel.org/vfs/vfs/c/6d91acc7fb85
[21/24] netfs: Fix folio->private handling in netfs_perform_write()
        https://git.kernel.org/vfs/vfs/c/ccde2ac757c7
[22/24] netfs: Fix netfs_read_folio() to wait on writeback
        https://git.kernel.org/vfs/vfs/c/ded0c6f16060
[23/24] netfs, afs: Fix write skipping in dir/link writepages
        https://git.kernel.org/vfs/vfs/c/9871938f99cc
[24/24] afs: Fix the locking used by afs_get_link()
        https://git.kernel.org/vfs/vfs/c/c0410adf3da6
