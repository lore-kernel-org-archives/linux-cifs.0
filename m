Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D02D2495;
	Wed, 22 Apr 2026 03:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776828952; cv=none; b=EUuTBdDPKJStWf2z/8zP+JIFYO6Tb3vw7RYcDvNucEk3XmBNQTN19bs43ZP8rPnjD96/rBwgTJqJM4MH3LrGKDpkeCRs/t8GlWyy/Dz48csF8qqr6CfIWN4NITN2UgdAvGhvfQU2b10tZwl3hQbSRFceoJjIy9QmzZdx7tR+IOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776828952; c=relaxed/simple;
	bh=WY7RQRfgrHELx30NbuhdsbIsL2HRNeBipxfqBnreVyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OX1tcaDc3ycJQ3BglxbRSak8I59iZYMa0RS2WUCCRbIfEgqZ3Gs0hKEqzE+Su7s/WL1NEYUezNFehrTLGg0ZGdewWaLhx2qTR04RivS4qB6xUFi437cgdYyBgLsMRZMZs5oLzx05TShxqp/vYOwaXZjPtM4RvqRGAa6z0soh2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=wt8qWG5z; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="wt8qWG5z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bw2O6inGL+8Q/ZN4yIDCKfUACqQ2XYABbUQEv1jxunY=; b=wt8qWG5z1KwjZ/3ELqursGcjvU
	vxE51kOw0KIjR4Lu4gI5pxERUfILgjqodWbaG6w2AvOtdWpk6MDJ9xoEeXhYQp9CfylHeYykOzeLH
	lEWrYkGFX0TUe+ZcmwgWgL1uUpHa3PRwhiOMFfb1JG3YXKeL0y991BYADYXcvQn/7vyDGzjlMo+zP
	e8HCXwRLNECWnaqT14NbtQAyetoGuZu6haspp/isVkH/ti+65T6VS8iXiCoqOiBSUlBKSHlGt9gzl
	agke43r+BbpHsafWarAB+GyiaOu8AsN75Gfn+9ZfBMHuSHVn7pEeS3H+Tnk3vQbOlmT/4Z5yycTUT
	D12NCzFQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wFORM-00000005M8y-0rTv;
	Wed, 22 Apr 2026 03:39:52 +0000
Date: Wed, 22 Apr 2026 04:39:52 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>,
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL SMB3 SERVER (KSMBD)" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: replace ints with enum component_type for
 LAST_XXX
Message-ID: <20260422033952.GG3518998@ZenIV>
References: <20260419161620.564854-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419161620.564854-1-jkoolstra@xs4all.nl>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Apr 19, 2026 at 06:16:16PM +0200, Jori Koolstra wrote:
> Several functions in namei.c take an "int *type" parameter, such as
> filename_parentat(). To know what values this can take you have to find
> the anonymous struct that defines the LAST_XXX values.

To find _what_, again?

> I would argue
> that the readability of the code is improved by making this an explicit
> type.

Do argue, then.  How does that improve readability?

What I see is a lot of churn.  Incidentally, I'm not at all sure that we
should expose those outside of fs/namei.c - if you look at the sole place
where any of those are used anywhere else you'll see this:
	err = vfs_path_parent_lookup(filename, flags,
				     path, &last, &type,
				     root_share_path);
	if (err)
		return err;

	if (unlikely(type != LAST_NORM)) {
		path_put(path);
		return -ENOENT;
	}
with the only other caller of vfs_path_parent_lookup() being
	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
				     &new_path, &new_last, &new_type,
				     &share_conf->vfs_path);
	if (err)
		goto out1;
and having no uses of new_type whatsoever.  Smells like missing
check _and_ wrong calling conventions...

Do we ever want to allow anything other thant LAST_NORM in any of
the users?
