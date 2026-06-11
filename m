Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD9A35E1A0
	for <linux-cifs@vger.kernel.org>; Thu, 11 Jun 2026 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781209243; cv=none; b=jrBkM/TRoWhH8rID2448j9UlLQZBaevhi0xWJiNbEm2fA5sT05oLIS9/pN1B7sNXp9bXEBPGvOJG+1H2Bz/R/KbUGSteVOojqo4fbF/SiHcYM7qMjzI7U8IQ4uI/P96fhkrA318ZW03qcSrqzp0fFJxxxTv4mwrrUiUb7qDCVV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781209243; c=relaxed/simple;
	bh=IfG67A0Jts04cIyLa6fhWJ/W0y/x9wyazXUwF0PGq4M=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=cE7VhGJZrNMaZ8h9lbIaEzdmOYgOtogL6O3DRDS29kjw0yxYlARWNTLihbuNxAO4UoYMLm/ivmWdTtxoT5iLgcB1mYlBpq8RfxjzEVZiQgOhbgi+6P1l1l5dGpt4x3X2keSs83Hk20OcLCpl7sQmYl+nRHssIFEdNEcMrtPlvAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=RgDw+MVc; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="RgDw+MVc"
X-KPN-MessageId: 04558366-65d3-11f1-89f6-00505699b430
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 04558366-65d3-11f1-89f6-00505699b430;
	Thu, 11 Jun 2026 22:20:41 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 044b386a-65d3-11f1-8109-00505699693e;
	Thu, 11 Jun 2026 22:20:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=7Ov7v2zaUsKQyd+rQc7yHadKIpzutEorLHTRrcpiUAo=;
	b=RgDw+MVc2Qet1WgQwtwcnUZt759tDJ+oBErf1U5+xxQXgYdSi9SgynxGFHwp88+Bp3hzAHLcSsMew
	 V8llfjnNJEfIdDC1CFT4WtTuOIf5l0nbga67AWw5CK1Jk3EepHRHVvLTX5ICv6quZeRarmiQGvaVpr
	 yT6QotuxyIBfZ9aGqMXQM1uG8M6yjdj+pH8BTRB3PTEneTPF+ZeZKIPqnrrf2sVVQSD7vRK26FqTND
	 97nfbc9QLbuSDyQsTXBnhNKJ3N73jDS7HVQ9imyQTOc+lLeqdfI0Jif21iPvh5pAuqTDHVMzCQMw+1
	 yAIxXzz0hj4MPZAsoyPGXb7qn57SWvw==
X-KPN-MID: 33|7XIYT4gxVhC2i/73hxusug8E0GT0kcO29eJp2Bj7UXh4xb7Ln30W17f35CgeKdd
 IjSlghudXmXnd+7EsEXsJJce4g9x5RyrsVcMa8yPOY9w=
X-CMASSUN: 33|2flxrK3KgCTfwfptdl/FAJyaW4hmG4aJpTZ72iFSgo6mcrufPWXugh29k5gnRxs
 72ag8Y40U0E6BGk8ufU+Ngg==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh04 (cpxoxapps-mh04.personalcloud.so.kpn.org [10.128.135.210])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 043ffc09-65d3-11f1-94b1-00505699eff2;
	Thu, 11 Jun 2026 22:20:40 +0200 (CEST)
Date: Thu, 11 Jun 2026 22:20:40 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
	NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <987538907.1434294.1781209240897@kpc.webmail.kpnmail.nl>
In-Reply-To: <7iocwlr7jg2jiyx53q7lxaccrybu6fpv6ch36u64igdmddafdk@3ejeqvr4e7rh>
References: <20260611145733.43776-1-jkoolstra@xs4all.nl>
 <7iocwlr7jg2jiyx53q7lxaccrybu6fpv6ch36u64igdmddafdk@3ejeqvr4e7rh>
Subject: Re: [RFC PATCH 0/1] vfs: pass S_IFDIR mode to vfs_prepare_mode()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal

Hi Jan,

> Op 11-06-2026 17:33 CEST schreef Jan Kara <jack@suse.cz>:
> 
> For the filesystems I know this looks sound. Thanks for the cleanup. But
> this series should then follow with the removal of now-pointless "|
> S_IFDIR" statements.
> 

Right, perhaps it should. But wouldn't that be too much churn? I know Al can
really be on the brake sometimes with regards to that. But it isn't a lot of
effort, so I am fine with it.

Best,
Jori.
