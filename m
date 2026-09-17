Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3525F4582F3;
	Thu, 17 Sep 2026 09:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637074; cv=none; b=OXT3aLmrPUnoDSBSHVtmdQ7ays8yV6IXurjczdI6I21myQMlnA728GYwp0v9ishKC+pjSGGWEp1nC41qqbSSG2mOp0C2UNBpt3pBHXzd96Ik8Rbg17sDxELJS0U9WiX1Bz7X7xusT4S8ecwRab9X9wOeJUpGP1EQAfyiBeoP0HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637074; c=relaxed/simple;
	bh=IeZdclOlcVa3lbSfPCK+9kOIB7jPAeSe6KelOoaITz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khs8lwpd2G1Hnbgd28780+arXXOjK3eDgb4wdF1TaRj/PG31rpjTOk+VdfQYg11iZb2nEXfyBlpOUwlAjvsiVeY7h9kHDniEBhDx9MEOnKTQLgMVBgB4T/rhsf3MqouiKZ/TCypbYY9/aM1RZESgRCUX/SStVte9Ma8XnRmEZiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7nTL6wc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7nTL6wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068291F000FF;
	Thu, 17 Sep 2026 09:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637071;
	bh=db+J/eRafWaa5Opoxh0rMyEWvwLPAsRb9zxs1a/2IX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7nTL6wcRzYXqhqEG/+xy8On5u4zPxqx9DlF9EAwwrOUEF0KWpIIzYKJpXhAoWKMI
	 qBQ8bvokZnrxS6cGZm4kES+K2AStiw5K0us2xS2g/NW2FwkqsJd5em3ZPzjv7UwMkD
	 mza2XpCfTSfkBJOxPmWmPs8vfOjYZfTZjkZbd4kS124DvvySgUEn5Z82YO0yxHnhaT
	 6CpPLz1E22uUUr6yLoq6nKEkwuQ3RL2jKEqDSXcPjEjyThPQ5qvSXtAi2k2MR2FbpL
	 pHz5EOuKGXA54yKHEIZxXDs9CUE7kLS4Oo8jsrv09GB6eE0Fg5hll2uodOX1AIlT47
	 wbsYnbrQ9HZQQ==
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfs: Fix netfs_read_gaps() to use separate sink folios
Date: Thu, 17 Sep 2026 11:24:21 +0200
Message-ID: <20260917-klinke-pulsadern-kehrseite-da39a9e5b6b9@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3228134.1789399227@warthog.procyon.org.uk>
References: <3228134.1789399227@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1024; i=brauner@kernel.org; h=from:subject:message-id; bh=IeZdclOlcVa3lbSfPCK+9kOIB7jPAeSe6KelOoaITz4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3njye+aB1rfhjBemO4TxV8WIWd878zMuc/NKE+6Vt q92Ha9+2FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRC4mMDBtFuaTMJiYL8Msm 73JLnL65cKlSlvGmPb3CNkLdFjUpnowMb4OfXt+bz23F1uWwq932yWrmKftmtl49J2YUpaBxu3I tFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 14 Sep 2026 16:20:27 +0100, David Howells wrote:
> 
> Fix netfs_read_gaps() to use separate folios rather than re-using a single
> sink folio to discard the unwanted data so that cifs checksum checking sees
> all the data that was fetched.

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

[1/1] netfs: Fix netfs_read_gaps() to use separate sink folios
      https://git.kernel.org/vfs/vfs/c/fc3ae66514ca
