Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793182476;
	b=X095aYM4bYjnKmjgZayctY8rn105jtung6wI8Y4M6XCNBjgqsZlVIV/H0hD4z0AuDz/X
	 1Vo1kYMEJZ40l1Y2r1Q2TJYWB4TBxTvXAs0NDel5FnbmMkNbZzH+vJCm7x8wEWmRJ/5mZ
	 eoPSZMxGDYcrxuqjSyLgGRV2mshhsFbdr1t1uwxhuj/mJLwO+tPOIANW8zYCfdyhmVdL0
	 2M8OIf10JtGIW5WAusnfnmASo7DaiczZy7qL5mzwOlBbc/QIKtfvUqC5XmDTnLXIJgGXv
	 BJvB7q4AZhfqilYjOoFoifMY+ArxvoYlQdqluRdMFcnGsZJzu7KzhP0cnu0B62mP4Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793182476;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=9P5+D+ui8UEfwSRO75vUxdqjlTpuzN71t1+jJ94dO0c=;
	b=XyFI2kxgWMN2HmpW1JzupY1lsnNNyyOmXwozFGQLhpDjIrZaBTr7FN/raxa4hk1x/7L5
	 4pWyKARLPvtE+ZKyR0bKU+JJBlX8UY/cPFE4eS9B3PvuKTPYpuelmYzn5F8zXac5hP0Sf
	 XiWMWkapLR6rl6/+YmumzFopI6QuPwuEepwEH9OZuYF3K0xlMQnEOzs2PFQWaEp7i02hO
	 6/dCZ1TdlemzrVouEed5oRWQ8PVavLYmvc/rLXSSvpxXdfDaRl4SUPT3+hA+5qaITLEGJ
	 Bl+tbAWjM2dmFQyRw7pCl8X6Uhn5KqcHXWSoL1vyxE8KfGRHfxUlr62/ndZq6B8SYtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2ky93DO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C74E606A321;
	Wed, 28 Oct 2026 10:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h2ky93DO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0919B1F01828;
	Wed, 28 Oct 2026 10:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793182475;
	bh=9P5+D+ui8UEfwSRO75vUxdqjlTpuzN71t1+jJ94dO0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h2ky93DOVbEasxVfqadkANQeIlqtKz8No+WvGJF/PboYB94tf+BD620gQ7rZXlY1T
	 utVP1BXc0lMZrR/qWiNzTZj43yHEeNFZS1mcMDW4Bfa5gASPXk/RdakloVXP+TQ7Hr
	 HM64noLKEklOazPawG/pN9nnnp1qaygGMZXtVBio=
Date: Wed, 28 Oct 2026 11:14:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: =?utf-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>, stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: Backport request: ksmbd and smbdirect fixes merged in 7.4-rc
Message-ID: <2026102825-episode-rival-d3fa@gregkh>
References: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
 <2026102733-sinner-baguette-1d07@gregkh>
 <CANTrAmys9yD+KB4Nhkqo5Z1R7vJCbyoXpizDeV6kM5YA4nEMiw@mail.gmail.com>
 <b69a61a6-47b7-40d3-9235-2c34fa0cfc29@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b69a61a6-47b7-40d3-9235-2c34fa0cfc29@samba.org>

On Wed, Oct 28, 2026 at 10:04:22AM +0100, Stefan Metzmacher wrote:
> Am 27.10.26 um 17:47 schrieb 이성현:
> > On Tue, Oct 27, 2026 at 11:44PM, Greg KH wrote:
> > > Why no tag?  What happened to prevent that?
> > 
> > For 3) that is on me. When I sent ef85bad39cf2 on 2026-10-15 the
> > commit it fixes, 25e414db7033, was only in 7.3-rc, so I assumed there
> > was no released kernel to backport to and left the tag off. 7.3 was
> > then released with the bug before the fix reached mainline, which is
> > why I am asking now.
> > 
> > For 1) and 2) I am the reporter, not the author, so I cannot say why
> > the tags were not added. Namjae and Stefan are on Cc and can answer
> > that. I only noticed the gap when I checked which of the fixes had
> > reached a stable tree.
> 
> Sorry, I thought that a Fixes: tag would be enough to have commits being backported
> as needed.
> 
> I read Documentation/process/stable-kernel-rules.rst again
> and will also add stable in addition.

great, thanks!
