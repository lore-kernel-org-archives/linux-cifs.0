Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1E61A9F82;
	Mon,  6 Apr 2026 03:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775445805; cv=none; b=O/uzqk26MTs+51dUXHATsQUyF9JOTifla66+2Rp6UFcOguiMwnhmhl7rzC/PEWnqJCQTz/hJAvcP6h/Aa3qs0u2dSqVNlzR6BlvdRKo15TMc+CD4Xa3lUPh8RP6BrNNQizcdW/an6RBttgYMVihX3GMubmTOIS58t7q+rUOVDiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775445805; c=relaxed/simple;
	bh=lfpB8W9eRgk5AGGJA9+bX9XD4zEiWuJmxAULDW/Vxd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8hlGvCfqBPuavamlsKfnbNb7psUDsCjJD33RoGH5C6TO7V6AMSxMST8CLkPvvqjWNfi9XfU7LWY/ajEPfwgyb2AxLpvOXpAOBj0I5CcqKPyQpwlCQ9sYrFB+V1c+pcY9LHGfYfQnQhgKh0uJMrR035Et74SyXk6B3TzFIvwxDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JZSNg5iT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JZSNg5iT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vCSph1mZhlXtBaThNHBA6xnqnwg4ekiSnwqbANoAqpk=; b=JZSNg5iTHnAzfjToJ/3tKS/EWj
	H/Y3GKQHfHsA/o1vES+ZCY8jwGYn8r4jhOszX+CMvxjjAAhLvZJe0yeui0xYIzbhB+KzCEWbE4Lmr
	xW/AgGfMTAY5GCTeRuJWHt0yPAWZ2h6wCIIqozqNGa4DcIdgz2szMrFppR9W31anSANet2ja3Vx0b
	Xqo8WddsjfbmZqY8jlfUHjVxFN8TTecpTJS5kniQIAeNVW8kP3XgANkV0EX/NQ8adnLzVQQ2PZ6Ml
	QnEJlWkQdLxbvdytgXRhZQYPBxCdFb7QS9JTIUY68TEmdHb/NA6Vprz19U83JXiRnE0nNaA6jyFCq
	gBFkw7qQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9aYZ-00000000kkx-2b5R;
	Mon, 06 Apr 2026 03:23:19 +0000
Date: Mon, 6 Apr 2026 04:23:19 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: introduce d_mark_tmpfile_name()
Message-ID: <adMnJ_FJ13NJ23Mv@casper.infradead.org>
References: <20260405211819.1251369-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405211819.1251369-1-pc@manguebit.org>

On Sun, Apr 05, 2026 at 06:18:18PM -0300, Paulo Alcantara wrote:
> +void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
> +{
> +	struct dentry *dentry = file->f_path.dentry;
> +	char *dname = dentry->d_shortname.string;
> +
> +	BUG_ON(dname_external(dentry) ||
> +	       d_really_is_positive(dentry) ||
> +	       !d_unlinked(dentry) ||
> +	       name->len > DNAME_INLINE_LEN - 1);

We tend to prefer each of these to be written out separately.  ie:

	BUG_ON(dname_external(dentry));
	BUG_ON(d_really_is_positive(dentry));
...

That way if one triggers, we know which condition is violated.

