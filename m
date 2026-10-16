Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31467377EAC;
	Fri, 16 Oct 2026 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792141181; cv=none; b=kgToQ4Z6mo5nB2HWKkXyBzaqS7c9rKuVXD+rY3wFfR7JjR0jgPYu9tsNAFEfUoFTLfJtqDJ07u7hIlDYvY5il6UAubmSU0NHD89CGRIBcOG3rbL+5os5p/lIXtlHc8KaGzxYxa8nAarXXKF3YCdHOa9raf6JiCeX8PJP1Y3xSEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792141181; c=relaxed/simple;
	bh=NeGmjayS22zWnD1WnDqIK44ygvIXtCwzs8PUMbdojAk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nNicKicZKUP2WzPS3XliYkPreONopI4l0ecpEEU5oDzFE7EQC8l4GNqunWoVQD6w2xc5g3y0CZoUkjUpgsINxQLL2LH83ckO28AvGA671oEHc0aY7Preo/nYKo9STnFpWGB8G54wM0PRxN2jUtWFBpjRBr35JAMRWwna3w8ifHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7bZ4agY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7bZ4agY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C93F1F000C4;
	Fri, 16 Oct 2026 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792141179;
	bh=ygPqvTu0MZgnk+/Kb6/16DzoVjrOgynRG8deEIsJd64=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m7bZ4agYIMispujf5L370KG15bRIqUoeSyxTGdIctuS2r7xWF36CBfEBhe9KRGvVq
	 i/Pv8f67AF5QF/yIhkhjPFuMyYWqPZOtOW9/hgwjsIKcNxyy9/MIJ46hEscejW7i/g
	 FDHBsAOfkUeSG0jZzaRWjachh22tG3vqK1hpudZDN0lp52jNh4uyHss03SDLh43pN3
	 N/9YwfIuhX29rz19vcMa8fMOhFmeU2h3CyJRAKAj6bAubZuwx/ioHZ2rgvNo7ND80c
	 GTZYkYcJgzeKFgNOrIpHChbdnx8Xj9/ewFHY1Pgl4RP0A6gNUBcPpDW/PD83pamUsF
	 wMyTg7y8fW3xA==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Paulo Alcantara <pc@manguebit.org>, 
 Matthew Wilcox <willy@infradead.org>, v9fs@lists.linux.dev, 
 linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org, 
 linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1091807.1791483394@warthog.procyon.org.uk>
References: <1091807.1791483394@warthog.procyon.org.uk>
Subject: Re: [PATCH v3] fscache, cachefiles: Fix resize handling
Message-Id: <20261016-betagten-raspel-gepunktet-718b691298d2@brauner>
Date: Fri, 16 Oct 2026 10:59:33 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Thu, 08 Oct 2026 19:16:34 +0100, David Howells wrote:
> Fix the resize handling in fscache and cachefiles by passing down a flag to
> indicate if the file is being shrunk as the cache's idea of how big the
> file should be may be stale and thus not useful in comparison to the
> object's size.
> 
> The issue is that netfs_perform_write() updates the network filesystem's
> file's i_size as it adds data to the pagecache, but the cache isn't updated
> until writeback flushes that data.  A truncation may then scrap that data
> and so the cache never sees it and doesn't update before it is told to
> resize.  In the resize, cachefiles was comparing the new size against the
> current cache size and then thinking the file was being expanded.
> 
> [...]

Applied to the vfs-7.4.netfs branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.netfs branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.netfs

[1/1] fscache, cachefiles: Fix resize handling
      https://git.kernel.org/vfs/vfs/c/f65f6269cd37

