Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D613DBBF
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714420755; cv=none; b=hFcbWXO/tyR/5dOEgpuM5DbvxO6S9WOSvC7+iW9xnhHaM+yT3xayoSSIi8QX8aFrBUF2+UK4GwnpvugSqUEJduZ+TzkhRAnjKB76LAS2Knqqaa3q3EbpxgRLspBT6LFrrCP+mcHh8h/8AaTLKCF5L42vwVfmC2H9+4+4XJdBtyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714420755; c=relaxed/simple;
	bh=xQ43Fpy/5olmCbgFRrFMCZT4TTqYYGVZ5bOwdqLkL2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YayNHKBTCFpnrYiwONHsEHTWqVSrcPBKZRyHSJL48zeh6wv4OZLTh4Z66a9nJcFRuxpSwEDmSM8lMFaEk0khF5qJ9HihRAKnHXUM+ilg8zCLuzwBEgl8E+bTYvawI0+xUyu/YTS/3SCvCglrh2tNKaFa5HPNkMUz591sL0TnZt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=l0FB4jmb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="l0FB4jmb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=pvp8jdHG/UWGJbGvH61+TCgFglQGIMninU5tKEowdE0=; b=l0FB4jmbx0Yk8fR9JFav3V6zzT
	10bSxVLRGjNLNfmkYuTvOffUtXW5J8XHYu8TR2MDBfzaPAD8Q7KNd5+xSznn1eisKLzkUQGaDqLVd
	owkWUtY+NieV/AfGerp3b2qvHnG2CrPmhYwBY8XhEVpLp6SgW3P50NjdJ9XHpyx4k7GIf+QRNO2SH
	ZiyS9pLg4xb1etFxTvx1EdYYINSKQ76wX1jb6Ng1n5QHcerpVOQiTTqwmc6sGZ08XuhQVdXoYgV+6
	j6jwUj7dkpEJGx3vYnhYAlM1Zgk8a6xWAWnt2kH9jx5xSuj1Rq2rRJdulJT8IjhlBoCgmN25IR0iW
	wbk1V7pJSuy4Jlghroo6AwcWxv4GC2JgC4DwuBwyFqZxN60txU++JgQH6oRJnRfzkIDCBONSl63wb
	NaipKhmDu0kXf5XzRdfEVhlsPHHH3oE9jfrkcwFxm586qQZp5hbrKz9WYaXkYOQiuxgKocAnjXkYX
	1mvozIIGZwqp2yfcYNeYGut6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1X9b-008zKO-0T;
	Mon, 29 Apr 2024 19:59:11 +0000
Date: Mon, 29 Apr 2024 12:59:08 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Samba ctime still reported incorrectly
Message-ID: <Zi/8DEo+ZiF24LLw@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muXqpZN1mu=WAhaxXe0yRB7Rib_CaoGo3h15wwcSPZFuw@mail.gmail.com>
 <b40a9f3b-6d2d-4ddc-9ca3-9d8bb21ee0b9@samba.org>
 <Zi/WD7EsxMBilrT0@jeremy-HP-Z840-Workstation>
 <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d9f60326-9ddf-485f-81c8-2012b7598484@samba.org>

On Mon, Apr 29, 2024 at 09:27:15PM +0200, Ralph Boehme wrote:
>On 4/29/24 7:17 PM, Jeremy Allison wrote:
>>
>>If you look closely at that commit, you'll see
>>that it's actually not changing the logic that
>>previously existed :-).
>
>yeah, sure, but it was a decent refactoring so I was wondering whether 
>you'd considered the actual logic you were touching was correct. :)

That wasn't the point of the change I'd guess (although
it's from 2009, so who can remember :-).

>Hm, so what do we do? MS-FSA seems to indicate NTFS ctime has pretty 
>much the same semantics as POSIX ctime:
>
>2.1.1.3 Per File
>
>LastChangeTime: The time that identifies when the file metadata or 
>contents were last changed in the FILETIME format specified in 
>[MS-FSCC] section 2.1.1.
>
>Let's see how many tests complain:
>
><https://gitlab.com/samba-team/devel/samba/-/pipelines/1272333543>

Yep. This is the right thing to do going forward. Let's
see what breaks. Remember, 2009 was way before we had
any good time tests.
