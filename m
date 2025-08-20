Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EC13375A8
	for <linux-cifs@vger.kernel.org>; Wed, 20 Aug 2025 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755710426; cv=none; b=WVfRh3SnKsCBm70jos1CUBHgzOYQmiX/ES/ibC0qY3b1YEbzRhUMKyOfQpnjS56pl1JoSEcjYM+TQJn45NC+6iTBOi1YL9cXfTf44o+yCvrpTVe91of8/k/cFCUaEhbwuyNksQYaRiIlvawIOQ0uN1L3vmwox0ZHLi3ElU3dHqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755710426; c=relaxed/simple;
	bh=sCBuXnM3E3cnTsrInGAO3EjGbiGIeyujEqwceLqCLHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLhAUJJjmOhKpHMA2X+eI3kSeUi81rRQOHwwWxP2/wJYeBRH8g4gFi19ZVzfBPDWc0yWtnaEOcQp7/JQ+Xw5/zgqA2t4QvDdEbCOn+Fv521D1Q5sEo8ICx/XVc7OghUfzS0Xbxekp7iOPpfvT9IK4mD6If5Rrl7FCqaqk/VLrys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bNroOQ9K; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bNroOQ9K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=sCBuXnM3E3cnTsrInGAO3EjGbiGIeyujEqwceLqCLHU=; b=bNroOQ9Kl5ybnQXvNcoLiPK5Rj
	6mSTdlQcZ+i8QEk75A3WLNzOIJi+EiOlWhieoUOZD/SMWknRT848/t4/XW6D9XB4A7dhsXuIKtUkV
	+566mHpjNWdkrVeNXl3Zvgd/buLW1pAyp/wDwCSZRK5wrElOfOW27th1+2dRnmgPmd49I1bX404HL
	Lp62q7CKAzKuzTZ2sTaAJOrA/QdzEQVZbH/b9mg2lQ9GMvw1jy3vVGA6WNLA6ys45k6gsm/xY5cUs
	D0ZBSm8f1BuVYSveJf8SFSQWghbNbXbT617j5YCHLwebEOqpOlMMGY/tTzDLjWmz96rwNYb5qoxD9
	kKqlOQHz7MSYsmKyuRt09zGVDziPub7IeCYYN5WjzJjIBSoAUpbiAStS5HeCjm/3XfAlB4fFH/F+i
	WH3jZMmZkijwZUAqRsesWoDtsVgzuxj6IfXNkYbJB7AJ4KH7E5FhxqmvXl8t2vEg5hOOaLB+4G3tD
	4rRR4mYv8X2L5ANj98FeEWDO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uomU1-003t7s-12;
	Wed, 20 Aug 2025 17:20:21 +0000
Date: Wed, 20 Aug 2025 10:20:18 -0700
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org,
	linkinjeon@kernel.org
Subject: Re: [PATCH] ksmbd: allow a filename to contain colons on SMB3.1.1
 posix extensions
Message-ID: <aKYD0r1PLQFRWXyZ@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20250820142413.920482-1-pkerling@rx2.rx-server.de>
 <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mupCJs6K3Y9N=oUp6oEAMV2S5=_d0nxirk74ZQ24gH7Eg@mail.gmail.com>

On Wed, Aug 20, 2025 at 11:37:25AM -0500, Steve French wrote:
>Samba allows this with POSIX extensions negotiated (creating file with
>: in the name) but I am wondering if a better way to solve this (to
>avoid any confusion with alternate data streams) is to change the
>client to use SFM_COLON (ie the remap in Unicode where colon is
>remapped to 0xF022 instead of 0x003A)

No. Only do that mapping to Windows servers.

POSIX servers should properly store the real ':' character.
