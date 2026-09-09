Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3EF33DEF9
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 16:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788970602; cv=none; b=S+RsvIPovx1tPB0U8AcHPKvOg/+1xIXWjC9hvIigrjgrz+a0yB8mbQGdklGXSQAbeQyzXbjl92mjF4SQJZPdlVIODKACi7X2QIrwfk5HZx/IViWQnvO7s/KArsgb+FOnMs/r6ANas9X3Yz3xMTtrCbjkF9/mwx3qIzQT1hKXbPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788970602; c=relaxed/simple;
	bh=y31K/DCqAPKu02LB9jfZDpI0TpTf0y5H9bBzBT+cBdE=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=kc+z1uuZxZ3CJ4N5kY+JtPqG1L6GuLPzopfS2pD4OVSYaUNONxDaBs29Xpfmd5VbcZKefNEFSs6XpG2uDbWqBNNhUB+AsiUuXOvdlOq2YSkU+XKXaM9VGmXflx0HyOUlYXagdqTfix+Q3zsAdxaZEGgOx1TNsITnRJtM8i4JG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=koNo7hRN; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="koNo7hRN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:To:From:Message-ID:Sender:Cc:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gwNY074Nd9qsmVTHudXKujvLiPAHXZkyUG/ENV03QZc=; b=koNo7hRNc9UZYFklYrWHiVJAz3
	7N2PYONLv+8Qo+fe58bR3zl57EFifXlO19v1ZbDS71CQ2PfmII/BpJ0i72NhHj71Tx2nlEbXSck6X
	LTGrAA/QnwwpkFzMHXlZAPDK7x8aC12tOfSnX2ZlxEZ6CdPvxNr+hhVkYXp8kcyuehtRxh0jlkTD9
	wNLgtojd/cslu1bCF+1AJGapsExiB0IutVtGQ3RNUrdvoQQUhAv/c3bs8gsYqaP2TA0R0HUxcgbpp
	jEfb1MRT0g37X2MT50zTkEEHsOk1JmxW3ma7WdmnORQd8q72etNjbOAHX2qnEF7oyEAiAMV+ywCTW
	gmHlS44Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4KyO-000000012qh-2y7S;
	Wed, 09 Sep 2026 13:16:32 -0300
Message-ID: <a4af8859841207a11fb6daccd7132ac0@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Shyam Prasad N <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Soft lockup with 7.3-rc1
In-Reply-To: <CANT5p=qCCdnFsDYTE0vTsBpD48ZkeVsb7=y7roczn61Kz1gtOw@mail.gmail.com>
References: <CANT5p=qCCdnFsDYTE0vTsBpD48ZkeVsb7=y7roczn61Kz1gtOw@mail.gmail.com>
Date: Wed, 09 Sep 2026 13:16:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Shyam,

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On one occasion, when I was testing modefromsid,idsfromsid (which
> appears to be broken btw), I observed a deadlock during umount.
> Attaching the system logs from that time.

Could you please be more specific in what exactly isn't working with
'modefromsid,idsfromsid'?

I've quickly tested it against Windows Server 2022 from #cifs-next with
kerberos and it worked for me.

Please share the server type, settings, full mount options, so I can try
to reproduce it.

> Does this look familiar to you?

Nope.  I recall seeing some lockdep warnings among those paths in the
past, but I wasn't able to reproduce such deadlock.

Unfortunately the dmesg output is incomplete and we can't tell who is
the actual cifs_tcp_ses_lock lock holder.  Possibly on CPU 0 or 4.

If you have any reproducers for the dealock or 'modefromsid,idsfromsid'
issues, please share them.
