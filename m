Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC8D176231;
	Fri, 27 Sep 2024 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727434593; cv=none; b=q/qcNuIdQ1GCreaX3Gtn3mrWNayd7r6CsRj4nn20EyY1vNb71RTojDsVHyw1zSiRzd9dZaXDvYGv/sSkuYO7fl1JSHuJFakKqZD6OL6dglE5a/fEQJ6/gYMQbDNQRS3h6ofUTXnmotgKeoWQipuradiV+V95YmTbY10cdsb1c1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727434593; c=relaxed/simple;
	bh=EFuzS/7penP/8DikVwd3I9P1HIGUllWDy+0Pu1nsKC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F+GZl12n3OLhqOOvroI+DfxS9v4TFiGBchJUtnjS+y5dTZzadPmPxUsVUeFg+ZiVc1wt7G6s//eXAYnqhrXFSrOkJBtUaQ6bdG/mkIYP9mEiQrI336ehf8V3F3NF6CVQrS9lvxWINm8ELBkgJjdKqsEPSQMPPL0lI/Z90uPFmyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=VdcNwFqk; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="VdcNwFqk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=XlItckOsmTBXG7EYIPU02ZIPvmvGMSn1RQlpeMUpnPo=;
	t=1727434591; x=1727866591; b=VdcNwFqkjlnzUJccOR9x55UsJZEfL6vU/ZDb5BLwl8Ed2jZ
	Xuu8AZ4vOc/g3XEJGVBlhf4xGTkbF3Yl7GpCSGNQd1Y0dWcl1HanI04EBeUpYHkmzeqixDZCwCx8X
	6WhXRYCDjri9mgrXXIRKAjkZaYV5edgWcVCYVK0VPoMDR3AmqogYnQF8wqO24JpUNK/soJWHAHIHJ
	jWUUdx9lZUtbSZwsvi4cjGDB49V2AfaSUxxjaaQ9sojJFMTAoDHVhhIDyW6w089VqztmsNW5ja+KY
	Fj93Rbv1IldrarCZgG0L3mT844zgy+Cs5Lx9QfLk9Y1xJcdExiBqbxPPFx3M31Uw==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1su8e6-0003fO-Da; Fri, 27 Sep 2024 12:56:22 +0200
Message-ID: <fb4c481d-91ba-46b8-b11a-534597a2b467@leemhuis.info>
Date: Fri, 27 Sep 2024 12:56:21 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
To: Andrew Paniakin <apanyaki@amazon.com>,
 Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Christian Heusel <christian@heusel.eu>, pc@cjr.nz,
 stfrench@microsoft.com, sashal@kernel.org, pc@manguebit.com,
 stable@vger.kernel.org, linux-cifs@vger.kernel.org, abuehaze@amazon.com,
 simbarb@amazon.com, benh@amazon.com, gregkh@linuxfoundation.org
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
 <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
 <7c8d1ec1-7913-45ff-b7e2-ea58d2f04857@leemhuis.info>
 <ZpHy4V6P-pawTG2f@3c06303d853a.ant.amazon.com>
 <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <Zp7-gl5mMFCb4UWa@3c06303d853a.ant.amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1727434591;708cab26;
X-HE-SMSGID: 1su8e6-0003fO-Da

On 23.07.24 02:51, Andrew Paniakin wrote:
> On 12/07/2024, Andrew Paniakin wrote:
>> On 11/07/2024, Linux regression tracking (Thorsten Leemhuis) wrote:
>>> On 27.06.24 22:16, Christian Heusel wrote:
>>>> On 24/06/26 03:09PM, Andrew Paniakin wrote:
>>>>> On 25/06/2024, Christian Heusel wrote:
>>>>>> On 24/06/24 10:59AM, Andrew Paniakin wrote:
>>>>>>> On 19/06/2024, Andrew Paniakin wrote:
>>>>>>>> Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
>>
>>> Hmmm, unless I'm missing something it seems nobody did so. Andrew, could
>>> you take care of that to get this properly fixed to prevent others from
>>> running into the same problem?
>>
>> We got the confirmation from requesters that the kernel with this patch
>> works properly, our regression tests also passed, so I submitted
>> backport request:
>> https://lore.kernel.org/stable/20240713031147.20332-1-apanyaki@amazon.com/
> 
> There was an issue with backporting the follow-up fix for this patch:
> https://lore.kernel.org/all/20240716152749.667492414@linuxfoundation.org/
> I'll work on fixing this issue and send new patches again for the next cycle.

Andrew, was there any progress? From here it looks like this fell
through the cracks, but I might be missing something.

Ciao, Thorsten
