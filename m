Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D481D17571;
	Mon, 15 Jan 2024 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1pBclLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18E9C43394;
	Mon, 15 Jan 2024 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705331816;
	bh=9G9fVLQVJlUlPX7Gqz/d91LfL/xPwJZSL5PoZQ78LnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z1pBclLIjoDhEvN2nIsb4OmjppPZSbzyMTQvs07nallPgzmgsYcE7NTPK3CVslTwI
	 fOyWsz0J/yly6i194BlZIkluoLWqYqiVDgYEO08Afn9HhIjLkf1pxCPAsUDi2vNKjN
	 AuzFZ7YyimPn4mXlRAaytmHvcDy9IQfiIbSOJBwY=
Date: Mon, 15 Jan 2024 16:16:53 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc: "pc@manguebit.com" <pc@manguebit.com>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <2024011521-feed-vanish-5626@gregkh>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>

On Mon, Jan 15, 2024 at 02:28:45PM +0000, Mohamed Abuelfotoh, Hazem wrote:
> To be clear here we have already tested 5.10.206 and 5.15.146 with the proposed fix 
> and we no longer see the reported CIFS mounting failure.

Please don't top-post :(

Anyway, please submit this in a form that it can be applied in, as-is,
there's nothing I can do with this...

thanks,

greg k-h
