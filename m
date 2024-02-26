Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8769D13541B;
	Mon, 26 Feb 2024 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959342; cv=none; b=povF3CNl8RwRa2jSzGXyL326Adzt1bJNVgXi2b65W7mMkHk4XfrQEnihj8wx0rs0l49kVU+gGFeTNsPisTgbjmWV/Bj2mOw5YEdtzmVReKh+m0gNqxNHHwbBiS085Pix4kV1E87/Kpjz2fFCGmv2kiEK75M/FpduJU78j5qrZzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959342; c=relaxed/simple;
	bh=iGTDi7slp7j7H6r1AYo4p8VNJhFt72RGq9C8BuRPFoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CS0y9+JEAMU/ESAxv52VsMgw0BXBbZhuSP8M/eBNPNynTsp0BvGYm5l3rwR5PRdNK88GYSCbuJmY1I7Nmd19daxfWvutcWiE/NClY6R5jvj9vunWMVKguweLgjiDFG793k4zdnPu+KyYioEQ71UzD709AKKPmNu+XprjFXe/JFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DL8LuuQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DL8LuuQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B53C433C7;
	Mon, 26 Feb 2024 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708959341;
	bh=iGTDi7slp7j7H6r1AYo4p8VNJhFt72RGq9C8BuRPFoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DL8LuuQ81g6FwhDpVHbvl2aP5FkUNumBg24frdN5W7qC7yeZ1NnXKMAgenC0jSlwO
	 bzY8prg36w3nYk1rAC5fen1vSwqgLmpoWbznMDaboBLfrD3B6cMT750FANmiurEIP9
	 prh2iBvq2itFvTwF9+LbY3Mobeomu7jDfqdoCjWY=
Date: Mon, 26 Feb 2024 15:55:39 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc: Linux regressions mailing list <regressions@lists.linux.dev>,
	SeongJae Park <sj@kernel.org>,
	"pc@manguebit.com" <pc@manguebit.com>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <2024022604-encrypt-dullness-8127@gregkh>
References: <20240126191351.56183-1-sj@kernel.org>
 <2ab43584-8b6f-4c39-ae49-401530570c7a@leemhuis.info>
 <fd0174a5-8319-436d-bf05-0f6a3794f6f9@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd0174a5-8319-436d-bf05-0f6a3794f6f9@amazon.com>

On Mon, Feb 26, 2024 at 02:28:41PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> On 23/02/2024 06:14, Linux regression tracking #update (Thorsten Leemhuis)
> wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> 
> > Thx. Took a while (among others because the stable team worked a bit
> > slower that usual), but from what Paulo Alcantara and Salvatore
> > Bonaccorso recently said everything is afaics now fixed or on track to
> > be fixed in all affected stable/longterm branches:
> > https://lore.kernel.org/all/ZdgyEfNsev8WGIl5@eldamar.lan/
> > 
> > If I got this wrong and that's not the case, please holler.
> > 
> > #regzbot resolve: apparently fixed in all affected stable/longterm
> > branches with various commits
> > #regzbot ignore-activity
> > 
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> > --
> > Everything you wanna know about Linux kernel regression tracking:
> > https://linux-regtracking.leemhuis.info/about/#tldr
> > That page also explains what to do if mails like this annoy you.
> > 
> > 
> 
> We are seeing CIFS mount failures after upgrading from v5.15.148 to
> v5.15.149, I have reverted eb3e28c1e8 ("smb3: Replace smb2pdu 1-element
> arrays with flex-arrays") and I no longer see the regression. It looks like
> the issue is also impacting v5.10.y as the mentioned reverted patch has also
> been merged to v5.10.210. I am currently running the CIFS mount test
> manually and will update the thread with the exact mount failure error. I
> think we should revert eb3e28c1e8 ("smb3: Replace smb2pdu 1-element arrays
> with flex-arrays") from both v5.15.y & v5.10.y until we come up with a
> proper fix on this versions, please note that if we will take this path then
> we will need to re-introduce. b3632baa5045 ("cifs: fix off-by-one in
> SMB2_query_info_init()") which has been removed from latest v5.10.y and
> v5.15.y releases.
> 
> 

Please send this as a patch series, in a new thread, so we can properly
track this, we have too many different threads here (and the subject
line is wrong...)

thanks,

greg k-h
