Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA99181322
	for <linux-cifs@vger.kernel.org>; Wed, 10 Apr 2024 19:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712776105; cv=pass; b=oEC4h7Vapnws++EXuLEDLrfacOGiMglyBwuAwpFI7uGl8E25oN1FttMjowOa+NebHqClE8zU/tQeyy7qPgBqBtPztDuyIU1zbAk9t5l1CFz7lK7BsZS0isambJzpIdps4HH6bXwlzix917UbWrubcj+XP+Gs94OU0wZDHrfUB9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712776105; c=relaxed/simple;
	bh=BUNIAKF+ILa/YE0caDvgW+IDNcnGDM1aClwgICKpAlo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=rSXLtbdnndU/RPDGTpKmEW4LL8Z5l0tFsvQ+b6ibqArktlCZ8UfXo3g+M9aCbjImV/z8X0GXL7JdKY0SmisMhql0daFS0b9Eg0d4lizD+dUF/tPkgs8/5zEeB1oeudsnSYQBcOUVX5xap9P6T3IrHAt6U1G2fofOGZOgyYJof0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=EaJ2g9dT; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="EaJ2g9dT"
Message-ID: <80e09054c9490c359e8534e07f924897@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712776096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pqly9NXGqsCeqL4gnMpnn+kTJHrl+owTc15/zj6Yt+Q=;
	b=EaJ2g9dT2jcBskDqXcAq5T60LVHx5j/J0Bxaveds1Yr6lMl6OJQVsykZj4THi8ITSD8dZQ
	zlAWDkXXdVFaYwLXYSya0xWVZet9Ge5UvNfXvIHleJp9tBZdUlDrGGG6sPpBiU/SXlO/sH
	MziJE7B+/Q2mQ4sMhYzGb9MUdGH1hnCQKll6rOJln7+QJ+rG5NzcxFZRNXnuLczvh5iVPY
	ttAhekVJ2R9Jgjnsi5qqwhjQtwLozLNqJJDEd0fiV/dKRuRODndWubzhkawspioYEqA3TP
	stEhG+rR6JGGZ17U3aCsT6LVg8NXgKPKKxb6hRT9xFktioYqJB8eNwLB4dTK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712776096; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqly9NXGqsCeqL4gnMpnn+kTJHrl+owTc15/zj6Yt+Q=;
	b=H1wJXYcZK4UBmhfN9DdXMEk9s4x+twCZnWNbooaUR29sSydXkBUb6rG8J+nb/ss2eb1AE5
	KniYEHiw+mCri5LxoSZxTDzUYvwsEXz4Gjcq1xdHYhKLk5MKmwERCIjGlutWfKjyzFvBYz
	4QZ6gO22fH8HPXIzPkvfNICE+5DaFwepkTZRMwOZDWxdW0vfoCLzB7GfoZAppn2F0zH323
	4e8L64e7IShLKpUN9Q4403Bxwx2cvTc38Cpq3uCsvwrm8Du4RKMwoT0OsyheCk3KElJxP8
	wwtLSdvq4n8Ngn6mrELmusys42MOBxb8URfmXHebty7srbySqoYuOu8OIjEmTA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712776096; a=rsa-sha256;
	cv=none;
	b=TalM5FVzn7XEUClEemRWzFXyMktzV25fp/AT2rblJpdKTQiCTgHf7ncRuRuAt888gYOVD0
	OyILB10H/9a8mvd3yiszZfz9FBe2zZpaKI34JHJMxSCav6Xq2CKMTj3Q7KanT4FDqwu3a0
	K+7a9+qazCaH70aDAWymaFN84A391+pAJ3+hw4ZboLXYjKFahXrjkXCFa9wrjLxbSkxuei
	U9pKVyv07TSwh0VoMTYsJHhefxZcp9APpQTkEPHahJrCLkkCWumtVysdnK2C1fUU4DREjb
	GFZAgkw45DA8gppX+TcxxnHQoZRVZpMO9/TmzuXHAtuSo9fywDZmqyJeiO7jaw==
From: Paulo Alcantara <pc@manguebit.com>
To: David Voit <david.voit@gmail.com>, linux-cifs@vger.kernel.org
Cc: David Voit <david.voit@gmail.com>, Jacob Shivers <jshivers@redhat.com>,
 Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
In-Reply-To: <20240403052448.4290-2-david.voit@gmail.com>
References: <20240403052448.4290-1-david.voit@gmail.com>
 <20240403052448.4290-2-david.voit@gmail.com>
Date: Wed, 10 Apr 2024 16:08:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Voit <david.voit@gmail.com> writes:

> For domain based DFS we always need to contact the domain controllers.
> On setups, which are using bigger AD installations you could get random dc on the other side of the world,
> if you don't have site support. This can lead to network timeouts and other problems.
>
> CLDAP-Ping uses ASN.1 + UDP (CLDAP) and custom-DCE encoding including DName compressions without
> field separation. Finally after finding the sitename we now need to do a DNS SRV lookups to find
> the correct IPs to our closest site and fill up the remaining IPs from the global list.
>
> Signed-off-by: David Voit <david.voit@gmail.com>
> ---
>  Makefile.am    |  15 ++-
>  cldap_ping.c   | 346 +++++++++++++++++++++++++++++++++++++++++++++++++
>  cldap_ping.h   |  14 ++
>  mount.cifs.c   |   5 +-
>  resolve_host.c | 258 +++++++++++++++++++++++++++++++-----
>  resolve_host.h |   6 +-
>  6 files changed, 606 insertions(+), 38 deletions(-)
>  create mode 100644 cldap_ping.c
>  create mode 100644 cldap_ping.h

Great work!  I've tested it and found no issues.

Most of the cifs-utils code seems to follow the Linux kernel coding
style, but I don't see it being mentioned anywhere, so the patch looks
good.

Thanks!
