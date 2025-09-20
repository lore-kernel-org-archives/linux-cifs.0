Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F0433A6;
	Sat, 20 Sep 2025 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758375196; cv=none; b=jmO73qWDqY+oCEhZgmpk/3mYcfIxcptMTanMbfQaNsOvPKb0RLqOv0KadqvFAbv4RUhrU21kYHeFP73r98N06Siw3eTuO94AfrjWPtEdGqfiirPIdw5j1EPVDqCGKaCVFxUJU+i98wLCWb7vBLhTdxVEUam7mNzDJfOsfvfWsEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758375196; c=relaxed/simple;
	bh=VRSb89zkXHwlp7QOlg9btXbEdqeq5g9VOvPVphfveiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pr5x35JWqvdjOs5PNHfieXHF/xZS6SgFwuTjwn4+lc0AvxyS2hVfU/fS1E48fi+BHtn6hNk73LzcQGG/sdT/J+cu5Kg59UqecQClJD0L1bsMHhLWRnMg7iaqjw2McNOv6LtcMrypqh+TyePplS3wjMATcu++uPWPJ9CxlS79rjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TvYxEQz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TvYxEQz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDF0C4CEEB;
	Sat, 20 Sep 2025 13:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758375196;
	bh=VRSb89zkXHwlp7QOlg9btXbEdqeq5g9VOvPVphfveiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TvYxEQz0FjeXNg90HTWMiWPzayBECz49BXqSd2oSdxVHhzHpyKsmcXPOPaCy8imim
	 VS/DIbt//YbuNZiCFfsWp0OeAwKR+bQP3H/9sbsrXgTQ+vikWJ3Rqx2ICnM/21YUE0
	 BhQmyyfpm4MD2JDl9InHPUw+VbB5V0KQCdnE+61A/DLufG0SaHJdy9BIMCT1SeFYJf
	 T6tVPqY9EOCDYT8KLN0YyzXpezU94+2kvr0LqWC8ATesgPI9LVxi4lYIZ9uvkVcAN/
	 wbe8XyUfBo3K4Bysh9OkoTdkhjsFvMoM5yX6RZ6cvFjIucEv0v9RUUMFdN8n68ZkvN
	 kDCjLloFgTqkQ==
Received: by pali.im (Postfix)
	id 918017C5; Sat, 20 Sep 2025 15:33:12 +0200 (CEST)
Date: Sat, 20 Sep 2025 15:33:12 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	Ralph =?utf-8?B?QsO2aG1l?= <slow@samba.org>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cifs: Fix SMB rmdir() and unlink() against Windows
 SMB servers
Message-ID: <20250920133312.myidua5tqzxzs5z2@pali>
References: <20250831123602.14037-1-pali@kernel.org>
 <dfa557ed-eb34-4eaf-9e17-7cae221e74fd@samba.org>
 <20250901170253.mv63jewqkdo5yqj7@pali>
 <6660f6bd-ea74-4b25-b7dd-280833b5568c@samba.org>
 <20250902163053.zzgd5ee4qguciajj@pali>
 <20250907110506.czjh3td4qf5ieb4m@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250907110506.czjh3td4qf5ieb4m@pali>
User-Agent: NeoMutt/20180716

On Sunday 07 September 2025 13:05:06 Pali Rohár wrote:
> On Tuesday 02 September 2025 18:30:53 Pali Rohár wrote:
> > On Tuesday 02 September 2025 17:17:14 Stefan Metzmacher wrote:
> > > Do you have network captures showing the old and new behavior
> > > that's often easier to understand than looking at patches alone.
> > > 
> > > metze
> > 
> > I do not have them right now, but I can run test scenario and capture
> > them, this is not problem. Test case is pretty straightforward.
> 
> In attachments are network traces of both the old and new behaviors.
> In the old behavior is visible that after calling "rm object", the
> object is still in the followup "ls" output and calling "mkdir object"
> is failing, also "stat object" is failing.
> In the new behavior is visible that "rm object" is using exclusive
> removal, which fails, and then fallback to rename+deletepending which
> success. After that in the followup "ls" output the object entry is not
> there, there is only renamed ".smb<num>", and "mkdir object" pass and
> creates new directory "object".

Hello, is it enough or do you need some more data?
