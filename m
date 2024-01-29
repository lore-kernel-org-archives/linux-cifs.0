Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61E815B0F1;
	Mon, 29 Jan 2024 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706546284; cv=none; b=a7Q43NiRESp0fZ+FYb0dC9hUECTSlLocOymc5hHqlG4T7R5FFcVTYfjhyrh1ZcBOiP94QcXXFRxJqHQX+4yZpABWwVY9JzVOJPgceE0wYn0nZeldqpa/p7U4gI4LbS7IsLpHTy8BlZRsRqoG3lDnaXdc0wGs+O6u3V4KsRQQlkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706546284; c=relaxed/simple;
	bh=dQViXVuYwfG1UHvOQUJkJhLMqB07gLLRE+0McGKbePI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1g34mfJCpD/9nvqlMhqF5QNLyU0C0TQqCRyLrXkfPbWmEFkD0zeLqzBlDVS1cgelhvtTuEAhYaYz7pifRUzTa4YYNQQ6g3MLN6ye+lOKT5YCTticHKdtk8pHrzL5Umv2UkDL7d3fIULeMpA7knSTzsV3r7Vnn+5mi/TFgBvBbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=JjvqFJt5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WnB77zbp; arc=none smtp.client-ip=64.147.123.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="JjvqFJt5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WnB77zbp"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailnew.west.internal (Postfix) with ESMTP id 1859E2B00081;
	Mon, 29 Jan 2024 11:38:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Jan 2024 11:38:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1706546279; x=1706553479; bh=nuyfZlUL4h
	kiP3h4HZf25tany1co6wSc8y7HvJ5lgE0=; b=JjvqFJt5kxJ+pQMTX2NSmRZKQF
	adqThmCySF9wLHy6wDqbimCRvetQG8pqO3LH2xV2zmhR6DXnpDQTx/TWZ6GyykF8
	WdKXVsF6moFKtIWY81yqhpjhD+0J6OaxHMsgqGY3/KvS8rPM07uz/smoZJSrGjKa
	6x/cMIgMTYD7EXazVpKNgxXVWs1KDlckv6K0G5moRV5X+//HExpG1i4v9HNoYvmF
	ql3BTFhM9+Ng0elxGKLpQAxrZCN//4iTnsbKGD7teG20hjYu5mq09dVvuvZw1iYh
	ThzBdmxhlpJRk2StH/yYGUrFVxrGMtSrZnzyqsGC09PkP8iyotbuZAvRGzBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1706546279; x=1706553479; bh=nuyfZlUL4hkiP3h4HZf25tany1co
	6wSc8y7HvJ5lgE0=; b=WnB77zbpAIIEvO5TF07+Ff3pAr2Uvp2i1EV2lJuTk22N
	oDJdOIo2lA2BbTA8BKuXqnvkqN2kBJrallACoHPa/LrnxM6CeH9GUbsLuXkDbsat
	4pnXY8Z+KhiYLqc53sN6Wk+S1uJJtDjPjV2vDCVMzVRtwgGCYXSBcrlF8oG3Dvlg
	/SziH1kk4mzavMExRH2zbTrPxiQA9kGDFVIqOGUk/KZDxreRnuapFC0iRSrdh9SO
	FU8NXWjJr5cWxQmFoI4Cvwg/ikKURUEvZpugbGIOD6BtvN6m02cojPgbwJzwePTD
	YbZ3aog2hh2kFDeslyqyMZholDUhH1MTcYVTabV/MA==
X-ME-Sender: <xms:Z9S3ZYThQmmcEfL_jc2PP81MuCviDVTC2si9G96cS4AqP8gPpOWZaQ>
    <xme:Z9S3ZVy5vI0x_GtJKf7mmPNlnnLaizYhxYCDEfWW-oE9W2C99VeZ4XDbO7mkPcF5v
    nCAn6qXdcmn4A>
X-ME-Received: <xmr:Z9S3ZV3sE4hSINij6ZV0qH5JSNCvMgfmQ5RKG3LsFOZkfoGa_J8pAz2zwwtr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtgedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Z9S3ZcCddqeNlzJ7mvKdXCT3mo1wQMFlCEJdm4cPvbgDKmf1_Tq6XQ>
    <xmx:Z9S3ZRhvfwiG1tSBSGZNX4QyNVCypV0lRHh1CMhRB6HUVXki4WIMag>
    <xmx:Z9S3ZYp5GNdjB-_C_woq_GcexuluCep0PiTQ2zhfB812DpOdicRLdQ>
    <xmx:Z9S3ZSbfNwsrNWvq3FASXKBZNwdHksAQctD3lFOrUC7Nx8podxswiVD2aAk>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jan 2024 11:37:58 -0500 (EST)
Date: Mon, 29 Jan 2024 08:37:57 -0800
From: Greg KH <greg@kroah.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: kovalev@altlinux.org, stable@vger.kernel.org, abuehaze@amazon.com,
	smfrench@gmail.com, linux-cifs@vger.kernel.org,
	keescook@chromium.org, darren.kenny@oracle.com, pc@manguebit.com,
	nspmangalore@gmail.com, vegard.nossum@oracle.com
Subject: Re: [PATCH 5.10.y] cifs: fix off-by-one in SMB2_query_info_init()
Message-ID: <2024012916-dictator-wrangle-e90c@gregkh>
References: <20240129054342.2472454-1-harshit.m.mogalapalli@oracle.com>
 <06bddf4e-a15f-bf1b-b9e5-d173cdacf4d0@basealt.ru>
 <88f25b32-033c-4e1c-b1d5-18bbc2ec91c9@oracle.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88f25b32-033c-4e1c-b1d5-18bbc2ec91c9@oracle.com>

On Mon, Jan 29, 2024 at 09:57:40PM +0530, Harshit Mogalapalli wrote:
> Hi Kovalev,
> 
> On 29/01/24 1:49 pm, kovalev@altlinux.org wrote:
> > 29.01.2024 08:43, Harshit Mogalapalli wrote:
> > > This patch is only for v5.10.y stable kernel.
> > > I have tested the patched kernel, after mounting it doesn't become
> > > unavailable.
> > > 
> > > Context:
> > > [1] https://lore.kernel.org/all/CAH2r5mv2ipr4KJfMDXwHgq9L+kGdnRd1C2svcM=PCoDjA7uALA@mail.gmail.com/#t
> > > 
> > > Note to Greg: This is alternative way to fix by not taking commit
> > > eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with
> > > flex-arrays").
> > > before applying this patch a patch in the queue needs to be removed: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/smb3-replace-smb2pdu-1-element-arrays-with-flex-arrays.patch
> > Maybe I don't understand something, but isn't there a goal when fixing
> > bugs to keep the code of stable branches with upstream code as much as
> > possible? Otherwise, the following fixes will not be compatible..
> 
> I agree, but at the same time we also should observe this:
> eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays") is
> not in 5.15.y so we probably shouldn't queue it up for 5.10.y.

It is queued up for 5.10, but not 5.15 for some reason?

confused,

greg k-h
