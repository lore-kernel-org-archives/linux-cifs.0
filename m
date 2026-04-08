Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0B34DB6C;
	Wed,  8 Apr 2026 06:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631220; cv=none; b=MN+ubvIeCQDiXAodRNRIqksTSAS96FdLysF5xBpjCWO0JBs7fkBigtEL3idEAvsBnmXpJ7OkLNDW2IcldlYl3jSUCY4JQcPzuF+oGvCulXuquRBypVCyfs6QvpaxF0bsL1cj2RYAkTF2ZumRDet2nbq/8lWnG3/BP+eNDMhbrd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631220; c=relaxed/simple;
	bh=B6TadXJ7UkxaXY92qgXpVgRFisxJ4YU8D9qXTvn/c/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1NW0jBctZefG3o7dz745pCOxbrUDF92b0/QNXQhGN1pKIk8OqVy29bcpsp/Fg/9ad246tgYS2OIYd7SIBtxCDeiza663sqaHz0OMyJ8jhwVturhmv85aWR8VVj3gSJZPQieO1S9HZYjLd4O2CyiHp0/UJNIFfoE6BcOXzQbg68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=vdGEH80V; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="vdGEH80V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0ay1Bld+PT+7+bY0dPSDuSI2gP78QPmzwdoU1hZaceU=; b=vdGEH80VxB3KPuXj5MizBLUczb
	eixp0eD0iFGpwxetWR2hwUy0MXDat7ql8ClsCqiQF2jrBBjoaWi20VN9hwclKYuzdE54vtRANwLL6
	KyO2mUPqdjS8qWIkjTkZ2sQgKj0+x1ICUSijzLE+jC7EzJPCEqf7jbWQbz3rWGbU6VYmIKWlDS11b
	GlWGECjZg3ssJq2rBJcX/MdK3YnuOSKxxM3iPet5bIwyIifbVl8UbuUmlYAYBgWzGm9ZLb8hNHdMF
	84hRnmg3GfZxs+8LNkmChnyVaRHgLXQEqLPlCPwFrcqDSQsCWFJYsbmOaVsLY1GEktd4+gOLUszT7
	ZrCHj/Jg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wAMql-0000000H5JI-2Lct;
	Wed, 08 Apr 2026 06:57:19 +0000
Date: Wed, 8 Apr 2026 07:57:19 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paulo Alcantara <pc@manguebit.org>
Cc: NeilBrown <neil@brown.name>, smfrench@gmail.com,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] smb: client: add support for O_TMPFILE
Message-ID: <20260408065719.GF3836593@ZenIV>
References: <20260405211819.1251369-1-pc@manguebit.org>
 <20260405211819.1251369-2-pc@manguebit.org>
 <20260405233222.GW3836593@ZenIV>
 <177543319568.1474915.17445767081272255066@noble.neil.brown.name>
 <98c9845554e2e6a79965d68ba8ae722b@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c9845554e2e6a79965d68ba8ae722b@manguebit.org>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Apr 06, 2026 at 10:28:51PM -0300, Paulo Alcantara wrote:

> IIUC, this is what we currently have
> 
> * cifs_atomic_open()
> 
>   init state: in-lookup or hashed-negative
>   [d_drop() + d_add()]
>   end state: hashed-positive
> 
> * cifs_tmpfile()
> 
>   init state: unhashed-negative
>   [d_drop() + d_instantiate()]
>   end state: unhashed-positive
> 
> * cifs_create()
> 
>   init state: hashed-negative
>   [d_drop() + d_add()]
>   end state: hashed-positive

IDGI.  Why shouldn't cifs_create() simply do d_instantiate() instead
of that dance, ditto for cifs_tmpfile()?

The only case where you want to change the hashed status is in-lookup
O_CREAT ->atomic_open().  And there it's not d_drop()+d_add() - it's
d_splice_alias().

I'd lift that d_drop() out of cifs_do_create() into the callers and
get rid of it, along with d_add()...
