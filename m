Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59F717BDC;
	Thu, 22 Feb 2024 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708642872; cv=pass; b=Qw7Lv+skgjLFHU0QPABSAF7A5fnIoPVSOAPelRZNUE8BRN6bDA00RUx1qqO4j3NUqSVu7hTPaAk6WANeKzuS9MmEkOiii4aCRPnxMlYlWGkfbri32Wuj+UQz3fB9gI4LeK77m40sflo3WxEtzCkIhLvzNxHQBTgiSCFzvLnlmEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708642872; c=relaxed/simple;
	bh=n3Ye9S6cNTU5mKO/NgYU/i/NCjN1QNFvHc5YgXu4FRo=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=NOKIn3o7ZT2hBEEi91jj/7X913PrXKVkhCqdhbsjCZc5Ud23UMeHrvEb4rUDG0VQGASNSx97OXGLC37UkmxMbOAx3RDIDmXHO2/VJ4ltPdJIYJfx2bWNmD31kmewGUGLfsuEShhq2BBArQIJGZlV+uT4SVNUwCkiSs/H4ELawSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=fbbFD+E7; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fbbFD+E7"
Message-ID: <181e4ae5b2ea3c2316e577cae4b62cc6@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1708642862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ULMiVdbvyYhzOmWmU+Y+KH9Pc9rIv3u9RYwV7FVrAFs=;
	b=fbbFD+E7/+ovmwu/xae3wADXP3lDbuUaLq/+QR96kFyOp6fIiNbHahpR40IvMQMd9leOwH
	sN06E/UhAUFkvZpyb16fB6EVLL2x6v7LXseJqKioZ+y0TU699JCV6f99n8QyvPY5CNRmJY
	8eODRbmrI3jKP/XfcyI2e/H8YALRUBHI6siTCuLHNvaZ5nQtjHk1pheXXbUJyskVie+q3w
	+h4wPKyxcDDKhuVopDZd6Isz4YyjaKHcANXL+l3zzbATfqZMzF/EcFxsiDKvlWSI/RRvU2
	P5Whd6SUnO6xOiQ7qF9uftMW6ilIhUUTYXyV3KFV2RKYoDX6voKBrqBexWH1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1708642862; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ULMiVdbvyYhzOmWmU+Y+KH9Pc9rIv3u9RYwV7FVrAFs=;
	b=AE0cvVTyOToK3izTUAV6csmJvBSHPC3yq+cVIf22xm7jqCwU9G3c6o+iz+d/N5QClfi7YM
	dpSi4em7aKR8ngAUAKXq1rpGYOLgLHd0vfQJ9pN+14NIqpeyUmLxfX1napIVR5gblceEDZ
	E8KnA5ifStd3hHDTan7V94InJUEqWxdaIrQHGZMoEVUcaRQqz1vUyIoWej4KF60YQX9neK
	LAWozNNmY9YFSS77jJILIvQw9TXwLp79vSwwaPOLckBKYVpBfbykA9D53hiBpeqhZ4lcw+
	dwN2WpGGhrxIqY2x7dOSRfBBAYM1C1zOHXWMkPocNdXMfZuSX+S8Q1GrlD7CLQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1708642862; a=rsa-sha256;
	cv=none;
	b=WkWbHtBlHb4sIwsRUcLKu9bZOTaK8C22Kmtl+MgPajtuTLFqeZXAqASFCxlZBcWZpv/KoA
	+4LBJcNamqmSgdiHPKx/ul6Xf8vmsrDaTfJzqgWPcgDMQhgIipu3MJXEp9N0JP7sR0YDOA
	rme2aAsrCsV3xVfR7I8RJ/WakdWlhrTjssiurayDNywz1A8imMnLPdyKExq3EDLZ5G5idH
	dnInOrEsRwF5RMOXE0pkrLZMXOB71sP6/l2+eun5Sl6KbanHtpfPN2u2EEIhwCSjYd1nNt
	k26UF9q/Ap3T8fBSOJlUpjGHQTtSExnx2KzXb32fW3IBX/MOOwiCC7IMbP14qQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Salvatore Bonaccorso
 <carnil@debian.org>
Cc: Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>, Leonardo Brondani
 Schenkel
 <leonardo@schenkel.net>, stable@vger.kernel.org,
 regressions@lists.linux.dev, linux-cifs@vger.kernel.org, Mathias
 =?utf-8?Q?Wei=C3=9Fbach?=
 <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
In-Reply-To: <2024022137-ducky-upgrade-e50a@gregkh>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <446860c571d0699ed664175262a9e84b@manguebit.com>
 <2024010846-hefty-program-09c0@gregkh>
 <88a9efbd0718039e6214fd23978250d1@manguebit.com>
 <Zbl7qIcpekgPmLDP@eldamar.lan> <Zbl881W5S-nL7iof@eldamar.lan>
 <2024022058-scrubber-canola-37d2@gregkh> <ZdUYvHe6u3LcUHDf@eldamar.lan>
 <2024022137-ducky-upgrade-e50a@gregkh>
Date: Thu, 22 Feb 2024 20:00:58 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Tue, Feb 20, 2024 at 10:25:16PM +0100, Salvatore Bonaccorso wrote:
>> Hi Greg,
>> 
>> On Tue, Feb 20, 2024 at 09:27:49PM +0100, Greg Kroah-Hartman wrote:
>> > On Tue, Jan 30, 2024 at 11:49:23PM +0100, Salvatore Bonaccorso wrote:
>> > > Hi Paulo, hi Greg,
>> > > 
>> > > On Tue, Jan 30, 2024 at 11:43:52PM +0100, Salvatore Bonaccorso wrote:
>> > > > Hi Paulo, hi Greg,
>> > > > 
>> > > > Note this is about the 5.10.y backports of the cifs issue, were system
>> > > > calls fail with "Resource temporarily unavailable".
>> > > > 
>> > > > On Mon, Jan 08, 2024 at 12:58:49PM -0300, Paulo Alcantara wrote:
>> > > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> > > > > 
>> > > > > > Why can't we just include eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
>> > > > > > arrays with flex-arrays") to resolve this?
>> > > > > 
>> > > > > Yep, this is the right way to go.
>> > > > > 
>> > > > > > I've queued it up now.
>> > > > > 
>> > > > > Thanks!
>> > > > 
>> > > > Is the underlying issue by picking the three commits:
>> > > > 
>> > > > 3080ea5553cc ("stddef: Introduce DECLARE_FLEX_ARRAY() helper")
>> > > > eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
>> > > > 
>> > > > and the last commit in linux-stable-rc for 5.10.y:
>> > > > 
>> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
>> > > > 
>> > > > really fixing the issue?
>> > > > 
>> > > > Since we need to release a new update in Debian, I picked those three
>> > > > for testing on top of the 5.10.209-1 and while testing explicitly a
>> > > > cifs mount, I still get:
>> > > > 
>> > > > statfs(".", 0x7ffd809d5a70)             = -1 EAGAIN (Resource temporarily unavailable)
>> > > > 
>> > > > The same happens if I build
>> > > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5a7fdd9b3ee0b7
>> > > > (knowing that it is not yet ready for review).
>> > > > 
>> > > > I'm slight confused as a280ecca48be ("cifs: fix off-by-one in
>> > > > SMB2_query_info_init()") says in the commit message:
>> > > > 
>> > > > [...]
>> > > > 	v5.10.y doesn't have
>> > > > 
>> > > >         eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
>> > > > 
>> > > > 	and the commit does
>> > > > [...]
>> > > > 
>> > > > and in meanwhile though the eb3e28c1e89b was picked (in a backported
>> > > > version). As 6.1.75-rc2 itself does not show the same problem, might
>> > > > there be a prerequisite missing in the backports for 5.10.y or a
>> > > > backport being wrong?
>> > > 
>> > > The problem seems to be that we are picking the backport for
>> > > eb3e28c1e89b, but then still applying 
>> > > 
>> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit?id=a280ecca48beb40ca6c0fc20dd5
>> > > 
>> > > which was made for the case in 5.10.y where eb3e28c1e89b is not
>> > > present.
>> > > 
>> > > I reverted a280ecca48beb40ca6c0fc20dd5 and now:
>> > > 
>> > > statfs(".", {f_type=SMB2_MAGIC_NUMBER, f_bsize=4096, f_blocks=2189197, f_bfree=593878, f_bavail=593878, f_files=0, f_ffree=0, f_fsid={val=[2004816114, 0]}, f_namelen=255, f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0
>> > 
>> > So this works?  Would that just be easier to do overall?  I feel like
>> > that might be best here.
>> > 
>> > Again, a set of simple "do this and this and this" would be nice to
>> > have, as there are too many threads here, some incomplete and missing
>> > commits on my end.
>> > 
>> > confused,
>> 
>> It is quite chaotic, since I believe multiple people worked on trying
>> to resolve the issue, and then for the 5.10.y and 5.15.y branches
>> different initial commits were applied. 
>> 
>> For 5.10.y it's the case: Keep the backport of eb3e28c1e89b and drop
>> a280ecca48be (as it is not true that v5.10.y does not have
>> eb3e28c1e89b, as it is actually in the current 5.10.y queue).
>
> I think we are good now.
>
>> Paulo can you please give Greg an authoratitative set of commits to
>> keep/apply in the 5.10.y and 5.15.y series.
>
> Yes, anything I missed?

The one-liner fix (a280ecca48be) provided by Harshit was only required
if not backporting eb3e28c1e89b.  As both 5.10.y and 5.15.y now have
eb3e28c1e89b queued up, LGTM.

Salvatore, please let us know if you can still hit the issue with
eb3e28c1e89b applied.
