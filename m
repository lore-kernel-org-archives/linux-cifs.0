Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC80B1E5B7B;
	Fri, 27 Mar 2026 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774573204; cv=none; b=a4nx7BsyZU7vR9NBCkF3Qb+hg23zZEPsCxpeG0trYy1a1Q14jQ1rHV73AATmdMIdesMQ14WJBJp5O1h+YAc/xIGfZnobbE3m4gn8c83oJOvqxTKp30sPlYs1oO8dccGuX3xV/tiAhjWoAY5+hvmIPtS8W+Lhu2PAY9jBb45hRQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774573204; c=relaxed/simple;
	bh=qxY3/yGGf6j+ovhznsYEiHtyVq8spceSXqsmShyDfZM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SY4pxXyiwZN63jneSnzMQP9Pl7AHos42gUT2n+/CrN8MvF5IV9IbchCZ6KhuMGyzTfn95HInwXUc+8WJ4vvu3EMeIVx6U5g4cXWdMVrzquc3EsDVciU8fNWOaPSXpkQc86gKCyjdWmLvwAamvhnCNVPno5MWsidjzrERZEBpdXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNroW0u0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNroW0u0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE9FC116C6;
	Fri, 27 Mar 2026 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774573203;
	bh=qxY3/yGGf6j+ovhznsYEiHtyVq8spceSXqsmShyDfZM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FNroW0u0U36ViZc4+y7bksZ+3Vn2ECYJKzcMQu2+7+wgbCIIsSRoawWqyJWlucPZ7
	 veDTO26o7D2SxZUVQnuNVRXQsH+37K7QiGKE68XMAtOISbRknR/gJz4fBKSOZAe7HQ
	 4pSAfw8E5Sw8ox/f45asPCxLpEeiNr1H1DNmT5u3Knkt/niNOXoFoUrLn2/OvVVwlZ
	 9aMewJKaEHrcVCtS/Cf5rmiCxdC8HI9K0r2Nb18EsYP88+4fWaaw1bMdOpv359WuHL
	 lW4vI1EuzPrHZke3KX5/VNAvsuy0awj1MQSGvcAefO895voF4iRRZ+kav4kmluphgZ
	 hsSU21cW2rWog==
Date: Thu, 26 Mar 2026 18:00:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Metzmacher
 <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz
 <dreibh@simula.no>, linux-cifs@vger.kernel.org, Steve French
 <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara
 <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes
 Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, David
 Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, John
 Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, "D .
 Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg
 <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, "Marc E
 . Fiuczynski" <marc@fiuczynski.com>
Subject: Re: [PATCH net-next v11 06/15] quic: add stream management
Message-ID: <20260326180001.793b62be@kernel.org>
In-Reply-To: <CADvbK_eyNtAfA=JPR5Y4arFLPpkWMs8io=TO83rHAa-JJkhdAA@mail.gmail.com>
References: <cover.1774410440.git.lucien.xin@gmail.com>
	<91c6fd0a44eb15a98f945171ead8062badb89a60.1774410440.git.lucien.xin@gmail.com>
	<CADvbK_eXUfnGGQgGc_k-ecCW3-Co1MpGb7UvMgLonPy3HRhyFA@mail.gmail.com>
	<20260326130740.74b4c92f@kernel.org>
	<CADvbK_eyNtAfA=JPR5Y4arFLPpkWMs8io=TO83rHAa-JJkhdAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 26 Mar 2026 17:48:51 -0400 Xin Long wrote:
> > Can you also check the google one?
> >
> > https://sashiko.dev/#/patchset/4019cfba3ffd6f91aee24713d2adc778f858b4c4.1774410440.git.lucien.xin@gmail.com  
> 
> Will do. There are quite a few reports, and it may take me some time
> to review them all carefully.
> 
> BTW, what's the workflow for the Google AI feedback? should I reply to
> each item in this thread like we did with Claude one, or is there a
> different workflow?

It's a bit more chatty and we don't have any integrations there so it's
a bit hard to deal with :( At this point just look thru the reports and
address what's legit. We'll probably take your word for everything that
remains being a false positive.
