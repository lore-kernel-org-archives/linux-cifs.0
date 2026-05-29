Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019C2332638;
	Fri, 29 May 2026 07:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780041050; cv=none; b=IN1NrEoavH0Ti/BCBHLeQVvNFBJ5A8vHGLqEGFOyefMxQCFePPq41cKJNF2qND3xaMCSppVYmIRbxhic8qhfa+wXnyYVibG3ADtLvN/UqDIlwPUS1j8NsJ72TATerHU6XQA3Y/f9/65YScvfpOP+dMhc4Stf2EnJJukPxfW8hBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780041050; c=relaxed/simple;
	bh=PQEJmiGG+7ql+D5lS5KVQsql2Pz24vxTUjnJKwD5vMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RN7k+bDb01WsOuA4DUc3vt+cPjTNH/3WwHT95TlKYOdYYlx6MdAYY11SFLuQgnnwDe2bUBk0G+nhx+FbUTDkhBwi+mvo32tnV1VvurtK4tVFFdeUzsYrfOM4EKPUlFIPPdbMXLWVy/QMEmmzCxqxqlDbQpyz9Be3RdvdGOeihfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hnho0XL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hnho0XL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E581F00893;
	Fri, 29 May 2026 07:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780041048;
	bh=A0U8MnkZrD7652lSFj3K2Vx7xiOulo4d52JBxhsU0LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hnho0XL7YlhZGMy5WkTVTj56xnzlCtQu90fPgn3/XHsxsEAP/3RoGahEcNhr1TCO4
	 MwS4Z955Qg+76yJGysNDHW+EBn7iyMS8mzExqxA0Zh4qjg0a4rI5wHcxQaXqkGAzdl
	 omWjcLXWQNomDNwul541Ov/DNUvKtfFQCMQIyQtzPsCd/6BRKlll+T7nWxpxUj7IBX
	 yjcYZ2FCUTeUpaiyGKGjLJK40DLTLFy4XAEwyz1W5TeEMv4qOH8jzz5+c8sHasSxru
	 ieN7ZCa1nZJdqouRFLnAXK6UokxXv0wCPudm5E5U3A9eRRNDYTW4KLxc4BII29VPCp
	 0AtZbQmd+NRTg==
From: Christian Brauner <brauner@kernel.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: make LAST_XXX private to fs/namei.c
Date: Fri, 29 May 2026 09:47:34 +0200
Message-ID: <20260529-knoten-neurologie-dienlich-fa0a68b3a33f@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260528175854.57626-1-jkoolstra@xs4all.nl>
References: <20260528175854.57626-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1966; i=brauner@kernel.org; h=from:subject:message-id; bh=PQEJmiGG+7ql+D5lS5KVQsql2Pz24vxTUjnJKwD5vMk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRJujoX1Ni9mH16iqMwY8S8JbmKdrtNRQNMhBmtQ2SLj 7x/rL21o5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCI/RBn+GUd3bFh4a5Fd4un5 WQ55c5OlDissj30VoPPgX+Wz80Z+ZowMUwo7Zzb+PG4tlPY/YXF93vF7K3gcv/u57erZ8UaZu5S LEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 28 May 2026 17:58:46 +0000, Jori Koolstra wrote:
> The only user of LAST_XXX outside of fs/namei.c is fs/smb/server/vfs.c;
> ksmbd_vfs_path_lookup() calls vfs_path_parent_lookup() and expects a
> LAST_NORM last type (or it will be ENOENT). ksmbd_vfs_rename() also calls
> vfs_path_parent_lookup() but forgets the LAST_NORM check.
> 
> It does not really make sense to have vfs_path_parent_lookup() expose
> the last_type because it is only needed to ensure it is LAST_NORM. So
> let's do this check in vfs_path_parent_lookup() instead and keep the
> LAST_XXX internal to fs/namei.c. This changes the ENOENT errno in
> ksmbd_vfs_path_lookup() to EINVAL, which matches better with how this is
> handled by callers of filename_parentat().
> 
> [...]

Thanks for finishing this.
This is minor whining on my part but it makes things easier if you include
--base=vfs-7.2.openat2 or whatever you're using as base and then git appends a
base-commit line at the end. Then tooling can easily identify where things need
to go. b4 does it automatically fwiw.

---

Applied to the vfs-7.2.openat2 branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.openat2 branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.openat2

[1/2] vfs: make LAST_XXX private to fs/namei.c
      https://git.kernel.org/vfs/vfs/c/f2f1dddccae5
[2/2] vfs: replace ints with enum last_type for LAST_XXX
      https://git.kernel.org/vfs/vfs/c/318643721de3
