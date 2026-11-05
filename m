Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895909;
	b=AWLhwV+U5gSyKvDknQM5XeAQm3wyLZrArO5KxF5Txtnz88mY+Ul5L0sVns/I2J/XQDLj
	 ji5/m74+yXWAEf6oX1YkeaKDntZ4D2mJdazEDE4Sy9ie4uV13YftD/YqEZ3S6EI5ZwjNg
	 4PaXmjvapMNNcKvpCSfA6T9U4e0kR7pTXmdzgUibMbQr/uyV/ugmWL6rEKvQ82y2lq+Y3
	 znoaDSlu4JRXIvQHNPsKrXDfHcl21MxJ6v3DH5pvbm/NyuH6AT9wUpa7gK4mkdZBjTso8
	 4dznjey5LuWN5hiDwBRzV4TSZ1MaLq96dcFjb9ZNP058wYqYW4nxiek12YZEeEZAVaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895909;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=7NMj2Y2EDcuPBjW65nvrvU7K71Q0gKCYtKgjJX4yu9g=;
	b=p+dkNp0eQo/mIAuOI550k6azZSOvtVs7cSvu/U115IlX1I2Tfoi6Zi/LQQjyTPPl2VAe
	 jXBnVdaR9A+AgY3v1r7/3KB5NtXlNr13Zyh1eFOogOox/MGuN0/H6uqX1oRepnd/6bwX9
	 8x9t3/2hFQk6P1x5A1dNLd/mi49+40G4KoCLFXNriYs00oYa+kDx+ifsZCRVDeuW1rNKh
	 gn8FB8urA6vua4RK1UqVL+Dixs0P6eysLQtto6hOKxVjoZdzNs9c1jRkePozsbXejsaIZ
	 qnlUxsxtdjPD3oBF5YX/lgncflReui2ajN7jk6CXNrhoNK1QwTNayME+ZQirW8gtEow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNqxQDhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD92D606A32C;
	Thu,  5 Nov 2026 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNqxQDhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD4B1F000C1;
	Thu,  5 Nov 2026 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793895908;
	bh=7NMj2Y2EDcuPBjW65nvrvU7K71Q0gKCYtKgjJX4yu9g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=MNqxQDhZQrXCyvNWXtS8kzeq27U9T/VSlEYeFRu1UBlzQTcumB6KMLC9FAU2tcmtt
	 9BO3Im7TwAPay/6m33q3fJkoR7mJaOoBgJmhbJrIOkgPlmB1Bbs4PVcQDL0Ub9E0Xz
	 yhQ/rnq7fuoVm/4Pv4iiqewDObJyZM5jNRlOW2o9fXQEp+Pnf739NXkj1hl/NlFLyQ
	 CxOqNkW7QtnY0EFTic0yQd0joHO3VHo5Gsm4QEKb4SWRFZEzRlawtqA3Nz/u0NQfTi
	 yvU7g++0b4PjrqWsDMjbLzpMmHtKHVjdmMJ7RxvHvWw8Pm0VptiUX4NOVTrPFo3zoG
	 dfS7wfAdNNzkA==
From: Christian Brauner <brauner@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, NeilBrown <neilb@ownmail.net>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <179272047063.2068970.18335523787621027348@noble.neil.brown.name>
References: <179272047063.2068970.18335523787621027348@noble.neil.brown.name>
Subject: Re: [PATCH v3 0/3] smb/client: prepare for locking changes.
Message-Id: <20261105-dachorganisation-dermatologisch-pufferzone-f7e9bab2cca9@brauner>
Date: Thu, 05 Nov 2026 17:25:04 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-ce4c1

On Fri, 23 Oct 2026 12:54:30 +1100, NeilBrown wrote:
> [[Missed the Subject on the cover letter - sorry.  ]]
> 
> This v3 removes the DCACHE_BLOCKED #define and uses IS_ERR_OR_NULL() as requested.
> Also adds the ack-ed by from Namjae Jeon - thanks!
> NeilBrown
> 
> [PATCH v3 1/3] smb/client: don't unhash and rehash to prevent new
> [PATCH v3 2/3] smb/client: use d_alloc_trylock in
> [PATCH v3 3/3] smb/client: Use d_alloc_trylock() in
> 
> [...]

Applied to the vfs-7.5.lookup branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.lookup branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.lookup

[1/3] smb/client: don't unhash and rehash to prevent new opens.
      https://git.kernel.org/vfs/vfs/c/b7362fb79d59
[2/3] smb/client: use d_alloc_trylock in cifs_silly_fullpath()
      https://git.kernel.org/vfs/vfs/c/08bcc8161fb5
[3/3] smb/client: Use d_alloc_trylock() in cifs_prime_dcache()
      https://git.kernel.org/vfs/vfs/c/de7f0d4e7ab8

