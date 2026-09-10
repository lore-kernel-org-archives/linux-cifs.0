Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45454485930
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049631; cv=none; b=ZqJvWQ55aj3vKUhidsJje/94uBYhlWAjy+g6cG7ApRAH0suiEVEOzkpBvpk/V+fRp3LguFPwZzk8zNwXMIexMLM0nxmRRS5LtP19dosKNBLCaochSC2wCs1IpMwwvwhmTEOn//EEcchL7DlZD6B1EcTz4+EZairVPmEqtShJjB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049631; c=relaxed/simple;
	bh=ipxPExihA6sPGiwrDwRjIH36USDATuM4VGr2+9JHiIg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=AW4NaihNtZzNAf0gvBveGG6jag6403tQLQ7dpDvlLVDv2EZD8rZNzvgq9i5IKQaW5e2O31fmNDmDIxQy7umWv6JbgFwShNWZ8r6whtIkJWBliiNrkN+ZXgJk5+oWJmLQ9f1bUTBAsDX1C6aPAJxMNlbcaUJE/Y6yXVhzT72gN88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=4X/iXwvN; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="4X/iXwvN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=3+JKQGbecm2wGCQ7U6I5F7605/T9ORYPeNAt7Tq3Id0=; b=4X/iXwvNrxjiG2ybLvmSRM5KHZ
	Wevpt8efcmf+2ybwFrIJDSbh4cYX3UI9PeR9GHxISDNLWaAZd9H2/utJZChSRnCBn5AHciVpDKe/e
	xkc8i9ueykCHAvNo6qgRibB7XPaUQtN54ANffof53CpsjlsJfCXn/aBHHiERBr6mASIoH06agC4Fq
	izrUVEK7YsKICnHuRnN1XIgvnD1gEhzCrNOeUjajERV6Jk8k/Jqhak/KuMSFG5GmDK+ypPqcWapyx
	JyiDcWFhbfCRmdtqS4HWBC0Bmtb8mKnOUbvuIx0329oetAbxmTVhvC0V2U3xNdHPQDqoOkf84GEKJ
	o6UUDA2Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4fX9-0000000181h-3vZ9;
	Thu, 10 Sep 2026 11:13:47 -0300
Message-ID: <da83dabd471d4714579703762c150162@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Soft lockup with 7.3-rc1
In-Reply-To: <CANT5p=phx4OqBSbki3RQBGwVQSFtiK7rvhQ2_KUD8aVbbyA8rw@mail.gmail.com>
References: <CANT5p=qCCdnFsDYTE0vTsBpD48ZkeVsb7=y7roczn61Kz1gtOw@mail.gmail.com>
 <a4af8859841207a11fb6daccd7132ac0@manguebit.org>
 <CANT5p=phx4OqBSbki3RQBGwVQSFtiK7rvhQ2_KUD8aVbbyA8rw@mail.gmail.com>
Date: Thu, 10 Sep 2026 11:13:47 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Wed, Sep 9, 2026 at 9:46=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>>
>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>
>> > On one occasion, when I was testing modefromsid,idsfromsid (which
>> > appears to be broken btw), I observed a deadlock during umount.
>> > Attaching the system logs from that time.
>>
>> Could you please be more specific in what exactly isn't working with
>> 'modefromsid,idsfromsid'?
>
> I debugged this further. The issue seems to be due to a combination of
> modefromsid,idsfromsid and handlecache.
> We cache file and dir attrs in the dir cache. But that does not fetch
> security descriptors yet. So it falls back to uid/gid,
> file_mode/dir_mode values.
> There's a fix needed in my dir lease changes. Will submit that soon.

Awesome, thanks.  Please send it separetely so we can backport it to
-stable as well.

Let me know if you still hit the multichannel reconnect issues with the
patches I'd sent you earlier.
