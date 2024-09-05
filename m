Received: from hua.moonlit-rail.com (hua.moonlit-rail.com [45.79.167.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B77604F
	for <linux-cifs@vger.kernel.org>; Thu,  5 Sep 2024 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.167.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725548598; cv=none; b=skMQesuq0EvL4Ikx5JVwsffBA9ca4HhuWqyVSY/DnykwdOs7O7jqVUsCVBSlofrO0T/zb9ZwO0CQwjKHodr59aNQ8HG3xRkdR4Uac7mPURk//GYJCVXQ/mDtSogKHkDuF5sJOinQK8CRxo+B6ERMNaaByISyeLGn7ZnCH3K10MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725548598; c=relaxed/simple;
	bh=Tubz6G7lFyVKoOF33fmW/TwrvNJ/tqu+GY6uD/I2wEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tl8WLemlicVtMwUtZ4zG5eZVv4Ly2QH1l/Wc2VRFpvELccCG+M926dY53ZBHNSJ+GseU2Ppq1Llf6Bk81X3c/ngQE+U7MG9cHZvVWAOZxXndqUwvgnoGl7i4GJuWvPQAv9mhOFG9hxsPPyVaPuhcIvQoeNKFGTGRAutPqWTnPqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com; spf=pass smtp.mailfrom=moonlit-rail.com; dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=OliYSJIk; dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b=8dim7v55; arc=none smtp.client-ip=45.79.167.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=moonlit-rail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="OliYSJIk";
	dkim=permerror (0-bit key) header.d=moonlit-rail.com header.i=@moonlit-rail.com header.b="8dim7v55"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=rsa2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LTe1y2oSW3fJOCtqvN01yj1Y3wIhGpRDsEDzGkMUI4k=; t=1725547241; x=1728139241; 
	b=OliYSJIkHnK4eBMX/xoT9Q357rkA4bSy/x+vOdoy76pFQV3Vfi+lPFuuFQ+x/mhd8KigzdNRLLW
	qwoUWk81xDzPvvp5ypHkKQc8sfub4IoCRY1JYOP3M6XXzny0lcdigUtG/8phZY86DP2CMD+/e+/cg
	8oyvCnuQ502TcE0g9xr7lLY1kHbnpZr29/fBckjhytlbXebm9ZergDDbvRvhElvH2nGmgf0u/1Uku
	gjhURoKilB9sngMybG5WIYq9eieGoPmqKUtFM5pSWMJMlr1DyJnuMY4J531AssWxHDThZO3SiTDxP
	jyzndf/+mVdcH286DY+fyjztOk7r69cYTdIg==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
	d=moonlit-rail.com; s=edd2021a; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LTe1y2oSW3fJOCtqvN01yj1Y3wIhGpRDsEDzGkMUI4k=; t=1725547241; x=1728139241; 
	b=8dim7v55n04wUMtsH5O67m1Esikwf9cS4yRvSvt5zgc0lBLzXLzDx697sGxNuMiiadAiacLcYq0
	N2vHvQmL7AQ==;
Message-ID: <91dad15e-9737-4c8e-9fab-113f0c633d3b@moonlit-rail.com>
Date: Thu, 5 Sep 2024 10:40:31 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CIFS lockup regression on SMB1 in 6.10
To: Steve French <smfrench@gmail.com>,
 matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: David Howells <dhowells@redhat.com>,
 Linux Cifs <linux-cifs@vger.kernel.org>, Bruno Haible <bruno@clisp.org>
References: <cca852e55291d5bb86ea646589b197d5@matoro.tk>
 <CAH2r5msAXgYs7=5D=YxGa8XohegJwpTn6yasVyZCmPmPt1QA9w@mail.gmail.com>
 <bf5a6d9797f33d256b9fffeb79014242@matoro.tk>
 <CAH2r5mta2N-hE=uJERWxz3w3hzDxwTpvhXsRhEM=sAzGaufsWw@mail.gmail.com>
 <4c563891-973c-46a4-8964-0ef90b1c7e49@moonlit-rail.com>
 <CAH2r5mugVqy=jd_9x1xKYym6id1F2O-QuSX8C0HKbZPHybgCDQ@mail.gmail.com>
 <90134f35-acb3-4124-b172-2de6d70dd0b4@moonlit-rail.com>
 <2925a37f946d1b96a7251f7be72ba341@matoro.tk>
 <CAH2r5mtDbD2uNdodE5WsOmzSoswn67eHAqGVjZJPHbX1ipkhSw@mail.gmail.com>
From: "Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Content-Language: en-US, en-GB
In-Reply-To: <CAH2r5mtDbD2uNdodE5WsOmzSoswn67eHAqGVjZJPHbX1ipkhSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Sorry it's taken me a few to get back to this, vacation weekend delays. 
The bisect was not as helpful as I would have thought, due to being 
stuck with too many "git bisect skip".  Seems there was some other bug 
causing OOPSen in the CIFS code, which happened to overlap the sequence 
of commits that were near our bug.  The bisect results, for what they're 
worth, are:

	There are only 'skip'ped commits left to test.
	The first bad commit could be any of:
	1a5b4edd97cee40922ca8bfb91008338d3a1de60
	dc5939de82f149633d6ec1c403003538442ec9ef
	3758c485f6c9124d8ad76b88382004cbc28a0892
	56257334e8e0075515aedc44044a5585dcf7f465
	ab58fbdeebc7f9fe8b9bc202660eae3a10e5e678
	edea94a69730b74a8867bbafe742c3fc4e580722
	a975a2f22cdce7ec0c678ce8d73d2f6616cb281c
	c20c0d7325abd9a8bf985a934591d75d514a3d4d
	69c3c023af25edb5433a2db824d3e7cc328f0183
	753b67eb630db34e36ec4ae1e86c75e243ea4fc9
	3ee1a1fc39819906f04d6c62c180e760cd3a689d
	We cannot bisect more!

The OOPS messages from the (unrelated?) bug were:

	refcount_t: underflow; use-after-free.
	...
	? refcount_warn_saturate+0xd9/0xe0
	? report_bug+0x11d/0x160
	? handle_bug+0x36/0x70
	? exc_invalid_op+0x1f/0x90
	? asm_exc_invalid_op+0x16/0x20
	? refcount_warn_saturate+0xd9/0xe0
	? refcount_warn_saturate+0xd9/0xe0
	cifs_readahead_complete+0x2db/0x300 [cifs]
	process_one_work+0x13e/0x240
	worker_thread+0x31a/0x460
	? rescuer_thread+0x480/0x480
	kthread+0xc6/0xf0
	? kthread_complete_and_exit+0x20/0x20
	ret_from_fork+0x44/0x50
	? kthread_complete_and_exit+0x20/0x20
	ret_from_fork_asm+0x11/0x20

I have not yet tried David Howells' patch.  Will give that a whirl next.

Kris


Steve French wrote:
> Let me know if any luck narrowing down the culprit
> 
> On Mon, Sep 2, 2024 at 11:56 PM matoro wrote:
>> Kris, a bisesct attempt would be immensely helpful.  My attempt failed as
>> there were other unrelated problems in the commit range which caused my test
>> reproducer (compiling python) to fail, but your reproducer seems much more
>> reliable (reading images).  Could you please take a crack at it and see what
>> turns up?  I think that's probably the only way to get upstream to take up
>> our case.
