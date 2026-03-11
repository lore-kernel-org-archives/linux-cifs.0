Received: from mxchg04.rrz.uni-hamburg.de (mxchg04.rrz.uni-hamburg.de [134.100.38.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF6F28A72F;
	Wed, 11 Mar 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.100.38.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773246113; cv=none; b=h3dgLQZTFNHtQ/sxhMC/8lZAj9JBMtjGTi/O6id8e51/sOItKOzaY/diDKKmNXXpCOWITc3w0ryqWMGVIg5BYGK9HvpVaaK/guJ2U6pJ4EbOQazv7urTkjPuKZ4TcK2vZWYcIeXeg9Oh16yWme8LTbYgbTvSqf/Z3lm4g75Zqtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773246113; c=relaxed/simple;
	bh=xweATK8Hr7olkCH1cCAJN5aOpT6umDJFeOwdQo6LMRA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+G5Gxc6oMTEG5eKx86DdJ11R36xWRdj52f+qdS5/QA4dYAG4BCk3Sn6G9uB42h9pmdFJOQtpuZijd8tid2oBhVJMQBmTM61ZMkyVEM2iaGyUv8BL0HcBfh31AW7O2Lm75kLnszQSk+HIxGQbNO34QK3If0fIJZFFUGt/0aMB3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de; spf=pass smtp.mailfrom=uni-hamburg.de; dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b=rbGRj1tD; arc=none smtp.client-ip=134.100.38.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uni-hamburg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-hamburg.de header.i=@uni-hamburg.de header.b="rbGRj1tD"
Received: from mxchg04.rrz.uni-hamburg.de (mxchg04.rrz.uni-hamburg.de [134.100.38.114])
	by mxchg04.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fWGGc248ZzLlbq;
	Wed, 11 Mar 2026 17:21:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-hamburg.de;
	s=rrzs003; t=1773246104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xweATK8Hr7olkCH1cCAJN5aOpT6umDJFeOwdQo6LMRA=;
	b=rbGRj1tDSMeJ/Q76RPutBOThV85llmAZTWy+mbwB8rr29C7yhakjO0ui/D955Kdgi5VdiA
	Ic+RTIl3lGkXb9+Bbq9q1+dudFDAjWqE6sZHhRpdexnV78SigQgB8N+nU7wgWT2t9pv6zp
	uURPz2BDrAVPLbxflxw0pF4JGe1jsOr8FR1W7K6vslzOeSwz/rXMzyGOhKmX+eA/KNlKSQ
	B8l5x4b1afiBgsGwRh22aoE65q/AO3tieBtMNSzMuncnFnJyyoW7574gcsocuDQilZEs2/
	/oYo1vXzOvSqypl7MGa8Hgf7hoCJlCW2QxRjGWl3t10A7rxpBZ5/hKMWqbgs7w==
Received: from exchange.uni-hamburg.de (EX-S-MR06.uni-hamburg.de [134.100.84.89])
	by mxchg04.rrz.uni-hamburg.de (Postfix) with ESMTPS id 4fWGGc0BTqzLlbk;
	Wed, 11 Mar 2026 17:21:43 +0100 (CET)
Received: from plasteblaster (134.100.32.91) by EX-S-MR06.uni-hamburg.de
 (134.100.84.89) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 11 Mar
 2026 17:21:43 +0100
Date: Wed, 11 Mar 2026 17:21:42 +0100
From: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
To: Henrique Carvalho <henrique.carvalho@suse.com>
CC: Steve French <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
	<regressions@lists.linux.dev>, <stable@vger.kernel.org>
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <20260311172142.4b8077f3@plasteblaster>
In-Reply-To: <lbexcljami5n73cz7oevuarmcvwbchtolcvlx27w376lparasj@kcfy45dkgt7g>
References: <20260310235642.6d9798f4@plasteblaster>
	<c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
	<20260311091653.358b213a@plasteblaster>
	<20260311094836.5ba141a3@plasteblaster>
	<lbexcljami5n73cz7oevuarmcvwbchtolcvlx27w376lparasj@kcfy45dkgt7g>
Organization: =?UTF-8?B?VW5pdmVyc2l0w6R0?= Hamburg
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: EX-S-MR02.uni-hamburg.de (134.100.84.81) To
 EX-S-MR06.uni-hamburg.de (134.100.84.89)
X-Rspamd-UID: 8f6ca9
X-Rspamd-UID: 20baa3

Am Wed, 11 Mar 2026 13:12:25 -0300
schrieb Henrique Carvalho <henrique.carvalho@suse.com>:

> Can we add your "Tested-by: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de=
>" ?

Sure! Thanks for the quick action!


Alrighty then,

Thomas

--=20
Dr. Thomas Orgis
HPC @ Universit=C3=A4t Hamburg
