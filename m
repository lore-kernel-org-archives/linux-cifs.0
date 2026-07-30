Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A314F40BCB8;
	Thu, 30 Jul 2026 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407120; cv=none; b=XKiRF9KNuZFNjm+Q9oO9pj6HORsIU4JyPplxjhBJIklzmuO4/PTe2IyK3Mc0cZRxeF/ClYcaqlig1eeCHKkJxidQoBbgIKEhYIDq6nwMfQKAzyCZKeZ+AxnB23Ocbuf2yDHTeNO87FfqHUZ/1o/85LBAxLzsqRIdZtN6Rfs81Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407120; c=relaxed/simple;
	bh=czVkuyw/s6ERAjL5sXfs6aMPrpEYKCpayyElVUsn104=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FS61boIteEM6F9EE+hOrtbEGovq/IZ+CTFgfN/T7ulqMDtNIfgS7m+tj5qo4+DgyZhz8TIa6/lUiHNE8H86hLQwn+H6qIGVKQk66Oy7CYEsKL8CRsvtUzyoN+wgEfO27n87ICe2POzEM4GP3+jgGVjQ8NoW17HlgfM8Y9GIWWIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ETeHtwxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETeHtwxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3AE1F01563;
	Thu, 30 Jul 2026 10:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785407119;
	bh=loJLGnYw1Jh17eN4lW3DwFepygLp3Lqst6GZWqFhZug=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ETeHtwxCmQbDYR08v4NCMrJmRa5ZvxGknbZ0eONzvb+9Vkp0mmPOL8ToRjyNdEEDK
	 FLDRbjL5/fxT0Asb4Q0v433x14MW94OShWgOQMauvq2G9dpGZSKmAR5EG7EygTPjRm
	 6dUag2tUT6zmD/8bLUmDyCQcpBZQlctWLQ+5k/ZGfoNdNJYJl5K4kB/7TaU22LpdpA
	 nmEJp8nM3E6hDLgi70U0L+9UyI5RkueDTNrbCLbC1q947UnrBJtlmIWAB6OOOGkTe1
	 eh5FRWdUhg5LJB7sPbjxe/saczPc4wNYAq82RAs1h/wnm6mNd45+TeLqWM6Zy5DqqW
	 ZlpVPdZ5n2ywQ==
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, 
 Christoph Hellwig <hch@infradead.org>, netfs@lists.linux.dev, 
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260727130716.1099906-1-dhowells@redhat.com>
References: <20260727130716.1099906-1-dhowells@redhat.com>
Subject: Re: [PATCH 0/4] netfs: Miscellaneous fixes
Message-Id: <20260730-akzentfrei-entfuhr-fernverkehr-8864ebc59e91@brauner>
Date: Thu, 30 Jul 2026 12:25:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1385; i=brauner@kernel.org;
 h=from:subject:message-id; bh=czVkuyw/s6ERAjL5sXfs6aMPrpEYKCpayyElVUsn104=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlq/Ve+N/x478rn923pp/5a14nMF072TyvOKfOSNtsL
 6uS7fIDHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPhE2f4n7Cl/be5zi+9j7wV
 27bLJRbWr762YvVBNmZ+hvnRyU/zLBgZph9+u3N/YsnM06pLTjodneZzTnNqtymr0hfvHYu8vmy
 p4QUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Mon, 27 Jul 2026 14:07:11 +0100, David Howells wrote:
> netfs: Miscellaneous fixes
> 
> Hi Christian,
> 
> Here are some miscellaneous fixes for netfslib.
> 
>  (1) Clear PG_private_2 on copy-to-cache append failure.
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

[1/4] netfs: clear PG_private_2 on copy-to-cache append failure
      https://git.kernel.org/vfs/vfs/c/cbdd2f04d712
[2/4] netfs: handle single writeback rolling buffer allocation failure
      https://git.kernel.org/vfs/vfs/c/a8c5ec7cb06c
[3/4] netfs: release readahead folios on iterator preparation failure
      https://git.kernel.org/vfs/vfs/c/655f48ea68ef
[4/4] netfs: Fix folio_queue ENOMEM in writeback by adding a mempool
      https://git.kernel.org/vfs/vfs/c/fc6965676202

