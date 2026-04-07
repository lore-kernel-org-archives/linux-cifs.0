Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EEA3A381B;
	Tue,  7 Apr 2026 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775548673; cv=none; b=ANVLBy1Ag4uYWXQVV5pOn+BH/WoQJr5M7DBEsIZMPq5k5tzKeR65S7kzt+mYvo/kan/W/5B0MFsyYou5Vk7lXgtm6En13kfSMhal8qo4/o9EmhkEubPmoHSZ0IjAbuqC4a650mzGdY3JdR5T4PfyzTkjn82wwR/69pDr00aKp0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775548673; c=relaxed/simple;
	bh=h/4O/yATXv8Ku3JfGC+2Ot5tCSQ0kdZH4ik1Lx3uvJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIZFMkpy2WGFNCzZ37JZsWasD2ry8RgQDkW7JOCrqY5bBpDhGzzS5tTZEQYjnxSadVp0P0UAPfVjW2r3bL6nfc97vz55Z5hiYHNFioZXVmo68rF5Bvl9POxaEMwg1418gPfUDBEhsfEHEtRISoB6ohvxBwXJESufs0T50TQhUW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9ldtw77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9ldtw77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B17C116C6;
	Tue,  7 Apr 2026 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775548673;
	bh=h/4O/yATXv8Ku3JfGC+2Ot5tCSQ0kdZH4ik1Lx3uvJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J9ldtw77FlVG4XavZBmNr5XCfyvgIbIz1ApVEw2BWw8/Hroqh6VSyNili0GX1r8em
	 +ZGfbjC1pSYy3M9BoqsLfBpPaowhC83h6f+1j+SuCvKA3R+U7lJAV+IMdxwxPZTRoj
	 RN/agSP9O0kcqjyKS4BmCknWf6X20bLlAR/faivM=
Date: Tue, 7 Apr 2026 09:57:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 0/3] ksmbd: some potential bugfixes
Message-ID: <2026040726-obedience-cleft-1c6f@gregkh>
References: <2026040644-brussels-dab-6f99@gregkh>
 <CAH2r5mtrdsQBOQMeNtMu_0W9c+t0KxaD+1T=XnNB8BL0jL+RBw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtrdsQBOQMeNtMu_0W9c+t0KxaD+1T=XnNB8BL0jL+RBw@mail.gmail.com>

On Mon, Apr 06, 2026 at 06:05:55PM -0500, Steve French wrote:
> Potentially some useful comments from Sashiko's AI review of this series:
> 
> https://sashiko.dev/#/patchset/2026040644-brussels-dab-6f99%40gregkh

Looks like it is pointing out other issues to potentially work on in the
future, but the current series seems to not have any review problems?

thanks,

greg k-h
