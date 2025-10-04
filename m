Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FC326AEC;
	Sat,  4 Oct 2025 11:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759576588; cv=none; b=IKmlWsPVYAD3BvInIK12FUwKvBs0rr9yHhXqaKfq+TooVf84iWu8+Rh62SxdbXslWoFaqT1q5uBq+yW4hus4xq+wjxNqqnA3KbkeJn4zi3aP7aa7aY8ZxIMJm88erK1r8u72R/IQwo7RLDsOaOxFJLbnRR3TJQXJ+2YfjAuLSNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759576588; c=relaxed/simple;
	bh=sppidEJWrn51K2Ay2MTBv9KfF+d6xRCaoO0w4IsE4s0=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=HITiINWOknBy7911PPUn7eQiPC/WzKZfDlvF/giGZiwsJQ+TJEIDrgiqbpddnUNnC/2hOTH4HJFCdK4YOEPUpexl8Hv0VxotdirV0gYFyAlkoRqO7unBlFkVr5oudisaPLCG9Wv0trKRpUIlnCeISw/qIDCTGJvtbMNmwYUslA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=EDR5sTuf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nDA3Xv+c; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="EDR5sTuf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nDA3Xv+c"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0A06A1400103;
	Sat,  4 Oct 2025 07:16:24 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 04 Oct 2025 07:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1759576584; x=1759662984; bh=3bjlNIuw0PXZPG1iCnKUGLpTk5DueM3VuTn
	kFpcjqT4=; b=EDR5sTufmaeqdNP6XAtqq5I/hmDAPQPjGumygl4+Ca/tvgPzF8O
	K1B/DF+Anv1l7RJhtbMmHsWq3wMavDlAZO83fNjoySN9tAeyL3NuSZXrolTEaewq
	kNaKwZf8HwaHdO9ezGiFitXuDmUIMWrvid8SNZKobgy4IvIouLeAb6JWfGPIkl8p
	BBxDfPeTqV+nseuKyh+hbv5lgXTlMc9AmmaHztOOjSnqfhrovoaHEys0DI1XaEDd
	Duz/7fq8QBW7w+pySagZzy0Rsh9zI9xmaI/393jFI5KWcJ7hR6djTFggfdkB/HOM
	K4HmkM37bVJmmrapiSsl5aCqVtpCIivV+MQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1759576584; x=
	1759662984; bh=3bjlNIuw0PXZPG1iCnKUGLpTk5DueM3VuTnkFpcjqT4=; b=n
	DA3Xv+cmiyneLY3/4uTwqNDH7DJAKnX2WmZ6y3wmL5SALneWAI86Ao03W1Ab+Vhw
	TbAzlVylh76vL0wU4tRNLwuaJd5wGLpY7aHbibrjPZM+WJd+DFru0JXjoU70oKNn
	gaXUAIo4h0Hb5HMSgakxJkSa9zrwjfhe6NCTHUo2yptVLDb5yd9lmRkgGBDQ4/LC
	BC8iaBitxPPP6cq9npYXbo/fpT1lxcX2Pfx/+WpihKof7a8wej3RbgKTIyNjIdnd
	EM/7zHQN1r3/NeOF3Zkis/sV2Kr9ojThAMh5STMOV9/7Sj5ynBLdu/rpicfWjDIo
	d6akvtJidQv00aFdG/9pA==
X-ME-Sender: <xms:BwLhaP6W0Xjv1JOOhIgGRvGo8taww6z_xp-mZwqJoJqM-apku9uK6Q>
    <xme:BwLhaFU0r0ZlgDWBlW1Xima-sCobOeL0wfwQpBv6eLrE3llKMXH3O7YwNxtuOEp07
    p36NcswY4gJeKHOCxY3t2bAlrciausP8mdrMVAgzX1DeQ4o0Q>
X-ME-Received: <xmr:BwLhaHKiAD-vZBEMuXEBcbJ7IJnFu11gXEQ3qTw9sDCWo0Q-hkd2DvKfVsG3PkbsI7nYrD5i4r7YUEamuy6zGnOovqIhzzsN23eduoUzXDWx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeludeifecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpegtgfgghffvvefujghffffkrhesthekredttddtjeenucfhrhhomheppfgvihhluehr
    ohifnhcuoehnvghilhgssehofihnmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpe
    eukeeuueeiueeluedvtedtieeuffffudejgeehuddvhfevhefgvdeludfhgfekteenucff
    ohhmrghinhepsghoohhtlhhinhdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggp
    rhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrghrkhhush
    drvghlfhhrihhnghesfigvsgdruggvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghifhhsse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhjrghnihht
    ohhrshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtohhmsehtrghlph
    gvhidrtghomhdprhgtphhtthhopehmvghtiigvsehsrghmsggrrdhorhhgpdhrtghpthht
    oheplhhinhhkihhnjhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsmhhfrh
    gvnhgthhesghhmrghilhdrtghomhdprhgtphhtthhopehsvghnohiihhgrthhskhihsegt
    hhhrohhmihhumhdrohhrgh
X-ME-Proxy: <xmx:BwLhaHt9G3pJIKYd8H7D6XXXyMWB1kRlB3SH7gStVnCfl46flWQa4g>
    <xmx:BwLhaEIoe3szVinsi8uFdjWA2Rrx5enMUKLYXgzfNKn4808AI6ZljQ>
    <xmx:BwLhaHNx6MI7tFRZNzHlde85Hcs4-sRV1YN7m90kFqqxIkkGL7VHLw>
    <xmx:BwLhaPV3B39lGmo6XrxmqfJtKjm-E375D5vdJzre1sT5rRrhkliirw>
    <xmx:CALhaNmjtkN4JTebGoKMjXq1b9kQR4hxPQsDvBUwAZfZkxUBLK3hCYJk>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Oct 2025 07:16:21 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Markus Elfring" <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org, "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "Stefan Metzmacher" <metze@samba.org>, "Steve French" <smfrench@gmail.com>,
 "Tom Talpey" <tom@talpey.com>
Subject: Re: ksmbd: Use common error handling code in ksmbd_vfs_path_lookup()
In-reply-to: <2d533e64-8543-402d-9295-5fd2f314f35d@web.de>
References: <6d759211-79e7-4d86-b22e-2ae46d209622@web.de>,
 <175953064635.1793333.2429881029964457140@noble.neil.brown.name>,
 <2d533e64-8543-402d-9295-5fd2f314f35d@web.de>
Date: Sat, 04 Oct 2025 21:16:17 +1000
Message-id: <175957657719.1793333.15585390544259019306@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sat, 04 Oct 2025, Markus Elfring wrote:
> …> - declare  struct path path __free(path_-put) = {};
> …>    return_path->dentry = no_free_ptr(path.dentry);
> >    return_path->mnt = no_free_ptr(path.mnt);
> >    return 0;
> > 
> > This is based on the pattern in kern_path_parent() and
> > __start_removing_path().
> 
> Do you propose that affected software components may benefit more from
> the application of scope-based resource management?
> https://elixir.bootlin.com/linux/v6.17/source/include/linux/path.h#L22-L28

Exactly.  It doesn't suit every case, but if you are going to make
changes to the exit paths of a function, I think it is worth
considering if scope-based code will work well for the particular
function.

Since v6.17 there has already been a net increase of 167 uses of __free
(though some might be in comments....) and 1902 more uses for guard().
So at least some people think it is a good idea.

NeilBrown
