Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F61B8248B;
	Tue,  7 Apr 2026 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775525376; cv=none; b=SJoFS1gLMBO+fDhP9FvOpQGkbaJdsXvWQeAQnAF7SnFHNFaxnAnnI2esDv5sBisNKVd15HAZ68jpVcGDFLS6sfd+dLExPRPo6tzySYEAzN+K0AXjhnmH3CeSat7VdPIoDhNI4f8Z9vMqWBiPEuyrUD78pphbNBkSWSGc/QN7FAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775525376; c=relaxed/simple;
	bh=cXGAOe/cSvpl6gbzhpXqBdgMjk18kXMhLFGKDezwWro=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=jB3BkL00QSO7lcRebTVIXouVhfdb4S0a2W+74IHIunjzj/oNWrmz1ps1UzDHfgTn/aVmU+wo/hsX7880e8TbV3Wu3mQPupYgu16Go4ymuhq3+ujziobKbbkczKfIE+nGl5Ck4bNwasjYBqasSmfFWAvI6znYUWn7mOf6eqmdRXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=0WveTjJi; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="0WveTjJi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nLkE6c5xKeBeFQpBfK1arqqr/URIoqGg+GeMjpqgSLQ=; b=0WveTjJiIqRAlC+gSY5EeBa3xY
	Gh25nz0GrlRg/2WC/oBTqcaAg/Sc94eff2ECZXDOz5H/GezJejKSbLZpcFvJa8w3q+1upFirH2E7I
	OFxJ+ulgQoBo5zqbGrQvLJTPd3WkUi3cqiiFn5i2hjH2RdTu7M4Jp69LvJYm0piahok4w7keaD2TD
	XFY2OmlU7Kwnnsmnp0U302iO5BxCNea5DhAmIMv/SkxEVu7ttnKicHU+kY4CDVeBy8+BijmLxavV5
	LeikYFb21BDtiguukGAz+tpGadaGONbUYObiHq/Ikjrnt7QHMU44yWoWMBrH5FqYdIkHUXIQJxw8n
	bRnLKO5w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1w9vFz-00000002K3A-04ec;
	Mon, 06 Apr 2026 22:29:31 -0300
Message-ID: <c5416c58c6fd882500e80f4b30c05c6b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Howells
 <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] vfs: introduce d_mark_tmpfile_name()
In-Reply-To: <adMnJ_FJ13NJ23Mv@casper.infradead.org>
References: <20260405211819.1251369-1-pc@manguebit.org>
 <adMnJ_FJ13NJ23Mv@casper.infradead.org>
Date: Mon, 06 Apr 2026 22:29:30 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Matthew Wilcox <willy@infradead.org> writes:

> On Sun, Apr 05, 2026 at 06:18:18PM -0300, Paulo Alcantara wrote:
>> +void d_mark_tmpfile_name(struct file *file, const struct qstr *name)
>> +{
>> +	struct dentry *dentry = file->f_path.dentry;
>> +	char *dname = dentry->d_shortname.string;
>> +
>> +	BUG_ON(dname_external(dentry) ||
>> +	       d_really_is_positive(dentry) ||
>> +	       !d_unlinked(dentry) ||
>> +	       name->len > DNAME_INLINE_LEN - 1);
>
> We tend to prefer each of these to be written out separately.  ie:
>
> 	BUG_ON(dname_external(dentry));
> 	BUG_ON(d_really_is_positive(dentry));
> ...
>
> That way if one triggers, we know which condition is violated.

Makes sense, thanks.  Will fix it in v2.
