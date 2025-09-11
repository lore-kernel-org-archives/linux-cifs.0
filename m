Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995BE1DDC33
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605519; cv=none; b=nAo11GFS3WncnTkz6mgUWTZ1rAouFKHkf1Hge57FbIv3lGwxzq2bK6Vf3b8xUpT9DkgawAV+0Rip7aZVaQz3jJpveJRMR6+RfZL/bUcmgo0Kr6VkVYVvXQY/kW42gP5KCgfuhTl9rqMD8jmMluWLYqVBUANyYsDjcw0lPz0r7/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605519; c=relaxed/simple;
	bh=uoulG3lk05c/hweFS/6gKSueAPpN4OWgsVeMOXdlTmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5b9MtYxoAgwcRl9ECq2VAxTwTTMM5lDQY8hRPLxbncspFR9YqgWjG6TPOHz+5EWDXf3b4ezhv9+e8leD/1We0DbqkQHSffJimCosRbnQrsVui8v6RgDLM9i+bh0WJJ3KSIdLSJaBAeyrni2eBpwqt6pnAtnztLwZUYu0N0tYmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NCWiCdmJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=L/zgXwUq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=F84Y/eec; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6/n6rb3s; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NCWiCdmJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="L/zgXwUq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="F84Y/eec";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6/n6rb3s"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 809CD401BF;
	Thu, 11 Sep 2025 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757605515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGbDCMs51FFiodmFmwMfYykXg2bo5d18UwDV5CSZrws=;
	b=NCWiCdmJvw2xhS/oKz1FJidSQfVvVccMbgPnzEsOxj63Sm3iurDC2T4NP+jSjjSZjqgPq9
	JCOKKIs/VXJJl5A3i+HQ52PP0Zx/K0vCe1V64AhtXwimMw+m/8ANXjEFlVEEyk5JRy8z9m
	rDo5Oo/3VF/WWpyRAr+129FO1GFd1mA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757605515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGbDCMs51FFiodmFmwMfYykXg2bo5d18UwDV5CSZrws=;
	b=L/zgXwUqoOQ0sB2Lnr521tnA1MOScoxCFqOxMPjkse6k1zkyj1epX/F6Eax4xbQxpeDCXI
	sDetouNKddVRiICA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757605514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGbDCMs51FFiodmFmwMfYykXg2bo5d18UwDV5CSZrws=;
	b=F84Y/eec7sUK7kxcPZxwr+vGYjm1ROkCsUmHTQZqRPlY6+FtDkfIAjIcgJjphmWSJuOcD2
	Wx7J3UmYGFRZMFOoxOO4EjAWT0tOPoxku2C5KtHPOADU+3JHV5qOKFsx/7JUvxyHy/n+cZ
	y12tgiZOLvvLMhv1Bn2Zqqij61fE7gg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757605514;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGbDCMs51FFiodmFmwMfYykXg2bo5d18UwDV5CSZrws=;
	b=6/n6rb3sePWMzjVU79an47D9JKc+IDAG8/iavLvw8aShJvkQxvLd+cPrlD4MnFCmqh+HeP
	hobMxGhROB6KrICw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0426E13301;
	Thu, 11 Sep 2025 15:45:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aEM0L4nuwmhlCwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 11 Sep 2025 15:45:13 +0000
Date: Thu, 11 Sep 2025 12:45:11 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: yangerkun <yangerkun@huawei.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, 
	Greg KH <gregkh@linuxfoundation.org>, sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com, 
	sprasad@microsoft.com, tom@talpey.com, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, stable@kernel.org, yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Message-ID: <clprezewclxsoxwzdxcc5zmclux47svnwylpsr6ncycrmksgov@et2dcfqs5gnm>
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <2025091109-happiness-cussed-d869@gregkh>
 <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com>
 <2025091157-imply-dugout-3b39@gregkh>
 <95935128-69fa-2641-c2a7-9d9660e2f9ba@huawei.com>
 <CANT5p=rE+=g7KA0RKOxs2UCnMEKfr3cm2V_+mwdb1g7+yV8NtA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANT5p=rE+=g7KA0RKOxs2UCnMEKfr3cm2V_+mwdb1g7+yV8NtA@mail.gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,linuxfoundation.org,samba.org,manguebit.com,redhat.com,microsoft.com,talpey.com,vger.kernel.org,lists.samba.org,kernel.org,huaweicloud.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 09/11, Shyam Prasad N wrote:
>On Thu, Sep 11, 2025 at 4:55=E2=80=AFPM yangerkun <yangerkun@huawei.com> w=
rote:
>>
>>
>>
>> =E5=9C=A8 2025/9/11 19:17, Greg KH =E5=86=99=E9=81=93:
>> > On Thu, Sep 11, 2025 at 07:09:30PM +0800, yangerkun wrote:
>> >>
>> >>
>> >> =E5=9C=A8 2025/9/11 18:53, Greg KH =E5=86=99=E9=81=93:
>> >>> On Thu, Sep 11, 2025 at 11:22:57AM +0800, yangerkun wrote:
>> >>>> Hello,
>> >>>>
>> >>>> In stable version 6.6, IO operations for CIFS cause system memory l=
eaks
>> >>>> shortly after starting; our test case triggers this issue, and othe=
r users
>> >>>> have reported it as well [1].
>> >>>>
>> >>>> This problem does not occur in the mainline kernel after commit 3ee=
1a1fc3981
>> >>>> ("cifs: Cut over to using netfslib") (v6.10-rc1), but backporting t=
his fix
>> >>>> to stable versions 6.6 through 6.9 is challenging. Therefore, I hav=
e decided
>> >>>> to address the issue with a separate patch.
>> >>>>
>> >>>> Hi Greg,
>> >>>>
>> >>>> I have reviewed [2] to understand the process for submitting patche=
s to
>> >>>> stable branches. However, this patch may not fit their criteria sin=
ce it is
>> >>>> not a backport from mainline. Is there anything else I should do to=
 make
>> >>>> this patch appear more formal?
>> >>>
>> >>> Yes, please include the info as to why this is not a backport from
>> >>> upstream, and why it can only go into this one specific tree and get=
 the
>> >>> developers involved to agree with this.
>> >>
>> >> Alright, the reason I favor this single patch is that the mainline so=
lution
>> >> involves a major refactor [1] to change the I/O path to netfslib.
>> >> Backporting it would cause many conflicts, and such a large patch set=
 would
>> >> introduce numerous KABI changes. Therefore, this single patch is prov=
ided
>> >> here instead...
>> >
>> > There is no stable kernel api, sorry, that is not a valid reason.  And
>> > we've taken large patch sets in the past.
>> >
>> > But if you can get the maintainers of the code to agree that this is t=
he
>> > best solution, we'll be glad to take it.
>>
>> OK, Steve, can you help give a feedback for this patch?
>>
>> Thanks,
>> Yang Erkun.
>>
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>
>Hi Greg,
>
>Steve can give you the final confirmation, but I can add some context here.
>
>This bug was never fixed upstream since the write/read code path was
>entirely refactored (with most of the folio maintenance
>responsibilities offloaded to netfs).
>We've recently had at least a couple of customers complaining about
>this in Microsoft, following which we've been able to repro the
>growing memory usage with a certain type of application workload.
>We've also been able to verify that the issue does not reproduce when
>cifs.ko was built with this patch against the 6.6 kernel of Azure
>Linux (and that kernel is mostly equivalent to stable 6.6). If you
>need a confirmation that this patch fixes the issue even on stable
>6.6, we can do that check.
>
>Additionally @Enzo Matsumiya also mentioned that SLES had to backport
>this change to their v6.4 kernel to fix this folio leak.

That's right.

Just a note that we did it for v6.4 because we had backported the fixed
commit (f3dc1bdb6b0) to begin with.
But I haven't checked if stable-v6.4 (i.e. without cifs_writepages_begin())
is affected.


Cheers,

Enzo
