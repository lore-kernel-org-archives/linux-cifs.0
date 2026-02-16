Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5D435965;
	Mon, 16 Feb 2026 11:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242525; cv=none; b=n9+RtyFsT1D2Jp/viBgPiFoqP0Q87KEJleR8FCEfL+KTJfBt8HZAmBVo7yJUs+FXbvOt9QvrJJI6/49vYO34bcmZzBmu7jz3+7GDIzgXWlo8DeSO423Gta3p9Ilm8vBobeXHgjpEwB8azkUjvxKe1pg4sR+RB4rkhy9NVb6HZxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242525; c=relaxed/simple;
	bh=6VRNm+eAFhfF8sOnf3jRRLdRq/llt2IoODvqnHtXV8Y=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=cCs6GPXefjI1qQbIQwP2SxWkNQATBX1+UePRsZLZ5leElO+tVqSY9KSI/hrJlfdiUqp1JAaDKP5G7pdsVbJCvweZlHPuiOqtxO1APzzmSCXekCpl359gq/j2upVMxRk+vFxS/OKlSR5AC9fFCA42B0J5DyTLBgmjN2/dHuEa+2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Wg0Vf2Vv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L3cBX/fG; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Wg0Vf2Vv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L3cBX/fG"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 2CF72EC0312;
	Mon, 16 Feb 2026 06:48:43 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 16 Feb 2026 06:48:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1771242523;
	 x=1771328923; bh=cISFTMBag/f/bedhOZRdNw6b8AhrChYlcOSQXFousEU=; b=
	Wg0Vf2Vv4JNHXhZEiFxRByKzYW0bFhdsCr+A2G2PmRNhRzYJ43RRgiec4z2mPS8p
	d4hH3s3ZLrU0wMFae+mpBM1tgZoZKnupw+t11MqVWweuL4F95Px9N40Muw4NmFlo
	4QWbWyofYtqjnWZrRrViYLl5fCLMSuevKlSLlm02Xm9U8LuIE57mcQmTdfISLvVN
	X7tFT+JIpY/BWVD3ql8l97LLPe9AnvC/s7yM9OV3Ld5fVHwq91VEuHW7M2wobrFO
	al8YepiYJQ9EQ4i7jiBQTuwPOiO8JR05HlM/iMFYpVndXdDoqkxDf+4NFkqo9c+S
	A4YZcJbPZgPvHlAztS46uA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771242523; x=
	1771328923; bh=cISFTMBag/f/bedhOZRdNw6b8AhrChYlcOSQXFousEU=; b=L
	3cBX/fGZ5qq9BHix4PqUHGxgUUlItpfU65rExl8D7aowF+msUz2HpTKC7N4ZX9m0
	LBIXdCftR4cj/2BF3/avfscUOidYtbI6fCrgv9wIkoH4WnY7CY6kihlp7PC+1eMC
	9xQRkYX5wc2k8NoulIj1+e5qtRO4gDhhBlBtxviQP9hOoxX61A96lwuI666VxUtJ
	ZILrliGphu7Bzf6qVDIhrHGWHz38jercQ55YMg7PXp9mC8j77VpVUDTAR3+cdQte
	vx2rAdXf+tjods6BKh/ehJvatFIL8DVUvLKGxh31NHZndgs4TG5bCR1LO0/jF+4h
	EwOzEdgqM71nYI7nhkn7A==
X-ME-Sender: <xms:GgSTaSHl9oERUJxe_S1dlRggX1szc3gQGcLBY8EgP85TXWO91XEBVA>
    <xme:GgSTaeII9ttqqff3O1imn1ak-z2V1R2AaWRErlsWX6YA0kPquW4p7gHL55hdxYc_3
    OlVlOPvLBtO0mIIqaaSiUOOcOomJFIu302o3ZThapyqEVnkjjvcMenC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudeijeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepfefggeejgeeffeekuedvgfdvgedtveefueegjeduleeikeettddujeektdffteeg
    necuffhomhgrihhnpehsrghmsggrrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghp
    thhtohepudegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrohhnnhhivghsrg
    hhlhgsvghrghesghhmrghilhdrtghomhdprhgtphhtthhopegrrhgusgeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    gvsghighhgvghrsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhkihhnjhgv
    ohhnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrghmsggrqdhtvggthhhnihgtrg
    hlsehlihhsthhsrdhsrghmsggrrdhorhhgpdhrtghpthhtohepphgtsehmrghnghhuvggs
    ihhtrdhorhhgpdhrtghpthhtohepsghhrghrrghthhhsmhesmhhitghrohhsohhfthdrtg
    homhdprhgtphhtthhopehsphhrrghsrggusehmihgtrhhoshhofhhtrdgtohhm
X-ME-Proxy: <xmx:GgSTafW5XxKhByzqe_EihkuyTl_0OM79hv7rkZWiz-JWb23DoB1Xjg>
    <xmx:GgSTaT_LkPh1LblgfgZKIokS1CWqj6m7RALQ7rOoi_KB63DGPb-mJg>
    <xmx:GgSTaf20EC-pPZrB3ZogaVeP3KzP15j4YZON3SQFyzERa1pKn9llGA>
    <xmx:GgSTaYdyKdOqtNTrj2or2sp0wFtDuSOCTZqec2lbl19CnKuDQ0dZ4g>
    <xmx:GwSTabCs5SGfepWj0lzzxY_3jC-ngcHvCWQuxUCA7Tj3lZIWo8K8tXlq>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CB952700065; Mon, 16 Feb 2026 06:48:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AScXjXSrFZWk
Date: Mon, 16 Feb 2026 12:48:21 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Stefan Metzmacher" <metze@samba.org>, "Arnd Bergmann" <arnd@kernel.org>,
 "Steve French" <sfrench@samba.org>, "Namjae Jeon" <linkinjeon@kernel.org>
Cc: "Paulo Alcantara" <pc@manguebit.org>,
 "Ronnie Sahlberg" <ronniesahlberg@gmail.com>,
 "Shyam Prasad N" <sprasad@microsoft.com>, "Tom Talpey" <tom@talpey.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Eric Biggers" <ebiggers@kernel.org>,
 "Ard Biesheuvel" <ardb@kernel.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Message-Id: <449b49a7-4266-41fe-b8ae-b3323339d51e@app.fastmail.com>
In-Reply-To: <63908802-3313-4118-bbd5-b1c677d23ac5@samba.org>
References: <20260216105404.2381695-1-arnd@kernel.org>
 <63908802-3313-4118-bbd5-b1c677d23ac5@samba.org>
Subject: Re: [PATCH] smb: smbdirect: select CONFIG_SG_POOL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Feb 16, 2026, at 12:15, Stefan Metzmacher wrote:
> Hi Arnd,
>
> I'm wondering what the top commit is that you where compiling,
> I guess that's before the 'smb: client: make use of smbdirect.ko'
> commit.

I'm on today's linux-next-20260213, which contains 

4c91b67f87ac smb: client: fix data corruption due to racy lease checks
3774289f525c smb/client: move NT_STATUS_MORE_ENTRIES
617a5d2473dc smb/client: rename to NT_ERROR_INVALID_DATATYPE
fa34d0a57033 smb/client: rename to NT_STATUS_SOME_NOT_MAPPED
4da735c48a27 smb/client: map NT_STATUS_PRIVILEGE_NOT_HELD
3e5f08342860 smb/client: map NT_STATUS_MORE_PROCESSING_REQUIRED
e4424687fc6d smb/client: map NT_STATUS_BUFFER_OVERFLOW
ba39063ca3ee smb/client: map NT_STATUS_NOTIFY_ENUM_DIR
66dc58bdbd7c cifs: SMB1 split: Remove duplicate include of cifs_debug.h
72f4d4803486 smb: client: fix regression with mount options parsing
72f4d4803486 smb: client: fix regression with mount options parsing
4c91b67f87ac smb: client: fix data corruption due to racy lease checks
3774289f525c smb/client: move NT_STATUS_MORE_ENTRIES
617a5d2473dc smb/client: rename to NT_ERROR_INVALID_DATATYPE
fa34d0a57033 smb/client: rename to NT_STATUS_SOME_NOT_MAPPED
4da735c48a27 smb/client: map NT_STATUS_PRIVILEGE_NOT_HELD
3e5f08342860 smb/client: map NT_STATUS_MORE_PROCESSING_REQUIRED
e4424687fc6d smb/client: map NT_STATUS_BUFFER_OVERFLOW
ba39063ca3ee smb/client: map NT_STATUS_NOTIFY_ENUM_DIR
66dc58bdbd7c cifs: SMB1 split: Remove duplicate include of cifs_debug.h
72f4d4803486 smb: client: fix regression with mount options parsing
d53f4d93f3d6 Merge tag 'v7.0-rc-part1-ksmbd-and-smbdirect-fixes' of git://git.samba.org/ksmbd
8f7df60fe063 ("ksmbd: fix non-IPv6 build")
...

> As we have this at the end of the patchset in ksmbd-for-next:
>
> fs/smb/common/smbdirect/Kconfig

This file is not in linux-next as of today, as far as I can tell.

> config SMB_COMMON_SMBDIRECT
>          def_tristate n
>          depends on INFINIBAND && INFINIBAND_ADDR_TRANS
>          depends on m || INFINIBAND != m
>          select SG_POOL
>
> I'll try to change the patches to have your hunk
> in the temporary phase in the patchset where we use
> smbdirect_all_c_files, as it's gone at the end of
> the patchset.

Ok, thanks!

    Arnd
