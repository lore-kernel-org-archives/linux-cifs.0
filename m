Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D1D1DA23;
	Sun,  7 Sep 2025 18:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757271431; cv=none; b=dCUdIqSoq0+VYe9VxgdnhrEyTu44Yve17+rBvkqn0o5tjWqYMFX7tButtwjbMe4xgTeN5JmL8b1zR8RnzYYwwbGBwBcfjvuLSIrxvWLgH1hnZohh6E6To3BMQeGSTjRVOJpia2HM5ofFL2H/UiOCteUCodZ5PW6Nik68WQISkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757271431; c=relaxed/simple;
	bh=V79pYRFc32aO8v0d/PJmtQPaMVgFkBCgwsmjBkROgXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0F8gHvKI6kSzJ1vQVOKhIeBUD8J9cdGJoSxM46vNsoq1i6LqlguZVPSDhJEqWLKTzNuPypfo1YbUhZgcY5Tva6+gS2GGcjLknsBjxnnUKckrAUxHnRglkTDYuAt23ik2M5yFpVV/EBM+6z1yDw5d5ApEFipZh+61bg8uvwhJHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/nhlj0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/nhlj0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C678C4CEF0;
	Sun,  7 Sep 2025 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757271430;
	bh=V79pYRFc32aO8v0d/PJmtQPaMVgFkBCgwsmjBkROgXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/nhlj0zz9k+yL2Z0Lh5ntQwoJWOVJhe/m2O9ZMOU0R/wrIZlnSxes4DJUDVjSf4n
	 i+CsYcq8nx/6cdQPN3zHgJBT0yxCfJB1GLsjmyjVWgXdVszO9GaNfPtQOZ52Be8f8z
	 hcF+aA06mB6tgRet37AftfxAaP3K7tg1pyVm+xc/apP6pHacaMBUYC+btsTWwBIh0c
	 RVcK2G08Uo1Uc1mmLv5poNkRZkKMO4sdfJxBl8nIjRyg/n6Dte+VDoagV+JoxdZpmx
	 HAFvozhcmZlsQevLHija7Pvrm92Mkbcsz1hPLj6rYzU5kgQ7lHU5+HqRXdjoCXx9p9
	 u2vx+Sx2darTw==
Date: Sun, 7 Sep 2025 11:55:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: Use arc4 library instead of duplicate arc4 code
Message-ID: <20250907185555.GA3530@sol>
References: <20250907032003.386794-1-ebiggers@kernel.org>
 <CAH2r5mutq5vZwKNyZ6nforOierKSH9si+47XoFV7PZSKxuvqHQ@mail.gmail.com>
 <CAN05THRE0powMS-AgXHfGT_rbkrqBA09PDA6ydzcCGzSnA-V9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN05THRE0powMS-AgXHfGT_rbkrqBA09PDA6ydzcCGzSnA-V9w@mail.gmail.com>

On Mon, Sep 08, 2025 at 04:33:18AM +1000, ronnie sahlberg wrote:
> On Mon, 8 Sept 2025 at 03:59, Steve French <smfrench@gmail.com> wrote:
> >
> > Ronnie may have additional context, but it may have been forked due to
> > unrelated restrictions on the arc4 module (that had nothing to do with
> > cifs.ko very narrow usage of arc4) breaking cifs.ko.
> >
> > Ronnie,
> > Do you remember the context?
> 
> Yepp.
> The context was that to my understanding it was suggested that the
> arc4 module would be going away
> and would be removed so cifs had to stop using it. (or create its own
> private copy)
> 
> Must been a misunderstanding of what/how would happen with arc4 when
> it was retired.
> 

Looks like it was this thread:
https://lore.kernel.org/linux-cifs/YRXlwDBfQql36wJx@sol.localdomain/T/#u

Ard and I suggested that, *if* the MD4 code has no other users, it
should be *moved* into fs/cifs/.  Unfortunately, it turned out it does
have another user: iwd uses MD4 via AF_ALG.  But either way, we never
suggested adding a duplicate copy of either the MD4 or ARC4 code.

- Eric
