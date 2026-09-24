Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373FE3D0919;
	Thu, 24 Sep 2026 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790257421; cv=none; b=UjxNJH5pbnoHpVYumDvIIyxqm9dCknuzKCW1k7mabwy74kE+brLeQRky8PeLkcpaOSVjOvEJzMa+4BzMcZt4A1a0v8AEJJXpLEYRJ6kQfCrzMm7ieuZ0J9tfEtVA4DdzCbWdcPPttpjajXI4p7XJBW1LYnMkSIB4/6HTLnAnbH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790257421; c=relaxed/simple;
	bh=cSzcyAZpFXUxMo6JHHFfSzdm6nZOBuy6I02fO+MyHlI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NJNYofyCle5cX05g0RP4XQOsCLjj6zULQSbJml4mVKIlkukEK1CCqMis4CPpy4nEtrUUyihppLSe4+h8yq3jayiNgPAhwk4lAFXV3W4F4iM/dB8T3NiTRgUWTIoO8RBhWUC3CQ79DYI+AmqP40X5CJCb7zhiC111mAukuEfJoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=PxO7iqvh; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="PxO7iqvh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=92cVdM6V0Hli3vXQa2vXPk+2sd+TTKDKVdsSFrNZl3s=; b=PxO7iqvhFttEAOszQ2De6jYhCV
	vULrfAd4JVPpkG6Wee4rC+Qvw7js5Akq65s62DUgYY7eRgF1UKYYbRja2sEHNTm3OtSn/bL0W7MOe
	o6KpDXD3fow0o0sw9ARQAxFEPxGxupf2CWN6Yv9BVVPUFXyh1oPiYNEiz9XSF3rAGcP/nsPOMhh/m
	b0bf3bTtJexHfkNpu7FUwXoOrJsRq8IsrCB0m0/PMaWFpeqCROXiqQtwkl6aO9jk6YlGWdV+/qoAz
	ZWb6/dEkt/04pz0JNnQNC0zP7rGmArjBnEWI0btHcxdq5Rhum3AXDotZGjMEA6sP0BT5poArmqzkI
	VER12SUA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x9jjR-00000002Bzr-2jpz;
	Thu, 24 Sep 2026 10:43:25 -0300
Message-ID: <69b370341031e782027602519e8b5d17@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-cifs@vger.kernel.org, netfs@lists.linux.dev, David Howells
 <dhowells@redhat.com>, Christian Brauner <brauner@kernel.org>, Namjae Jeon
 <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] netfs: clear post-EOF pagecache when extending a
 file via write
In-Reply-To: <arSkGzqebr4ogCZs@casper.infradead.org>
References: <20260921230755.1133425-1-pc@manguebit.org>
 <arHVJ0ihdqmNETMw@casper.infradead.org>
 <b5a645319f7b2475f65306c3445953db@manguebit.org>
 <arSkGzqebr4ogCZs@casper.infradead.org>
Date: Thu, 24 Sep 2026 10:43:25 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Matthew Wilcox <willy@infradead.org> writes:

> On Wed, Sep 23, 2026 at 08:46:35PM -0300, Paulo Alcantara wrote:
>> - netfslib needs to honour NOWAIT, which pagecache_isize_extended()
>>   can't do due to filemap_lock_folio() and folio_mkclean().  Besides, we
>>   would also need to return -EAGAIN in case the folio is mapped or under
>>   writeback.
>
> btw, if IOCB_NOWAIT is important to you, you need to be calling
> kiocb_modified() instead of file_remove_privs() and file_update_time()
> in netfs_buffered_write_iter_locked().

Yes, you're right.  My life was so much easier when I initially started
writing the fixes without having to care about IOCB_NOWAIT as I'd
noticed that netfs wasn't actually handling it correctly in some places,
then I thought: let's not make it any worse, handle it correctly in the
new helper at least and then send other patches later to fix the other
parts.
