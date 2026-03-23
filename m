Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79E21B983F;
	Mon, 23 Mar 2026 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774270931; cv=none; b=FFcpr271ArpeyAd16HWeU4Z+Uz3ltn2r/IjhtOjpmyVPT/BNCGF8vWY5gTSDxSWUO+jqzycHAXSloBLlB9raBvXPfcEliG43A5REh91YH95zpDZWDlum1z3kZD/zyX6u7RDribgbhD5XX0INiVnaJR6N+bpDe+u7xHvwjiO7mgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774270931; c=relaxed/simple;
	bh=6/E9/MhBVS2AhC7OkD/9Lcjir86nfpvxA37exMYYIew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1pfFJqArO82CGW4oh3GQH9U9joH5djRFYlCccBlKve+ONlN9W7+FAgWUG3zRgF8VCwWBw21jBO2nm+ApQehsVBcKjYktojaWamUOKBEoIJHNfihCgj+fpemWFcxRMb9eVMjGLxzmIAPQ48bRl/OqJ8Zh1oH81POGrnWDG+YO3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=V3bBWxCA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=v462ggz/; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="V3bBWxCA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="v462ggz/"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 79BC61D001BA;
	Mon, 23 Mar 2026 09:02:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 23 Mar 2026 09:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1774270928; x=1774357328; bh=6/E9/MhBVS
	2AhC7OkD/9Lcjir86nfpvxA37exMYYIew=; b=V3bBWxCA4f8iqYkbXExSk5r0A5
	IZ38tWXdF7hMpIDyGoutCoBxqwuOQyD/js8Yf/tAytpX6mHBRQ3VFMK7wg5rv/+j
	hIye/mDdaBWSESHqf6wiVoJW4FJNCo3Aax4NsqeAuCcuS70ESy2+uO5omDEE7AD9
	RfZGj2XHpWI/F0Jda6hZMu7cvzz9B32mGLb132vNac77ihRh96eSmPNjX+nDVaSu
	c7bEA6La4EXpUZTa8/0Fa+aY9SFNji3gOg7lrVwVV+iM+GZ8qkqgqR9SVasQOgtw
	UG2MrTVdOT5gMBci/8syUC/74Zju3QIZVHMciwENMHXLoZJOmypfg8O9ZfIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1774270928; x=1774357328; bh=6/E9/MhBVS2AhC7OkD/9Lcjir86nfpvxA37
	exMYYIew=; b=v462ggz/ALoURPRbW/ZvmeZfG7rkUuWP/u/9UExiZtfa4YCMXtY
	13sOgvlzSSvE0JJlbHaISYnxAdpbMEMaty9c8ZMx3lTbLDiAJtwMwgRr8Q8hkihg
	RHnwoR3LfnAOgBft0QXlvEUSjX2TfGPi2453Iy1QEVedlDRAV7P5aYjzEUivRSI5
	xtKiNF3WHW/W/Q1vxQq+Ibq5x7i905/e3DvLW14bH7/esfXreXgPtDPAffrusL80
	eIalpmm/Vozh6WUkviq97NdarNwb1x0O1aW/6ekqGuMumfaaNmRikI7Gjgk5eNga
	Ld/SQJsAXvkJY8z83hWPRFOfPGVKLeWB2zA==
X-ME-Sender: <xms:zznBaY8rrMuZ_AonA5cRGX2nhbtmwoMAS37QRZ7CaWcBxxU-5xgQnA>
    <xme:zznBaXycoFGRXnJGGR0S8Jdg5X4b3ZtIiU85BnyeQ3wdflhrYJ4g3nf4SZnQ-XC0e
    axDee5ZbiGZMHW1uh4_r-fU-dFWDbb8sbzv02xjsRa7DPowjw>
X-ME-Received: <xmr:zznBaVsqFOJs-PqUi8bxqJv_ok1ZoxteQEQtgfeNDVTnPGC-XXIT78U5gdEh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefudekjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvdevvd
    eljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepghhhrgguihdrrhgrhhhmvgestggrnhhonhhitggrlhdrtghomhdprhgtphhtthhope
    hsthgrsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsfhhrvghn
    tghhsehsrghmsggrrdhorhhgpdhrtghpthhtohepphgtsegtjhhrrdhniidprhgtphhtth
    hopehlshgrhhhlsggvrhesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshhprhgrshgr
    ugesmhhitghrohhsohhfthdrtghomhdprhgtphhtthhopehtohhmsehtrghlphgvhidrtg
    homhdprhgtphhtthhopegrrghpthgvlhesshhushgvrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqtghifhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:zznBae1-liClJARwPuhICmD3-qFtJrDEEgVtR_vNv_hMXyqpndFWGQ>
    <xmx:zznBaZ4GUx3bxv7O0yD_1Ra7V4hkM1rMEePWYvafeM3KSY3ZnDClGg>
    <xmx:zznBaYN2xc9pUjCYc9IacA95d1HoxDRm7MmLEXVktmKWeBkLE-SKKw>
    <xmx:zznBaVEsgFWJjmeSxM_ywu19F42OKailwfTGwrHFu2hLLv8yyro2Xg>
    <xmx:0DnBabBQzA_jtcFRiElfEmw4d2uF1EsJaN0a0yE-vV_107ivUpxPV8O6>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Mar 2026 09:02:07 -0400 (EDT)
Date: Mon, 23 Mar 2026 14:01:46 +0100
From: Greg KH <greg@kroah.com>
To: Ghadi Elie Rahme <ghadi.rahme@canonical.com>
Cc: stable@vger.kernel.org, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH v2 6.1.y] smb/dfs_cache: Fix NULL pointer dereference on
 session connection failure
Message-ID: <2026032339-irate-monsoon-76ce@gregkh>
References: <20260319144929.455978-1-ghadi.rahme@canonical.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319144929.455978-1-ghadi.rahme@canonical.com>

On Thu, Mar 19, 2026 at 04:49:29PM +0200, Ghadi Elie Rahme wrote:
> [ Upstream commit 6916881f443f67f6893b504fa2171468c8aed915 ]

Again, wrong git id :(

