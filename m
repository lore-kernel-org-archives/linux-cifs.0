Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB6942E411;
	Fri, 21 Aug 2026 16:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330437; cv=none; b=cz54FWM35akHDw3Y5GIuD8n7AOtg89rxIxwZaaugoMoHzY++NfuJXTpK8w1zCKl9gImxbRgHCe44qxfbMbhASZfT9Ym1SQYfGiRpONaO94XQkaaSa0QR4FELzVA9fK+BYFgOPPAHPwz/pOBJ6Jeccno7tz6Qxdd7zIhw4nLb18o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330437; c=relaxed/simple;
	bh=rrQ8zsAhO4o4LBZpMUQvrV2eWH59JPECEmCQQ0d9k5E=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SuScI5JDpy2gOE+RXzDFOCoY6ThU2ayo6kILn1QgxBfHcZMVeKWoWZdUOHidRGYM/eIYGA7TtN7qR/x3ZZzQCfyx6/K6rw7AqF4UnwacnOwJ0mwS7xbbvq/0mYF8NaoOrTIFz8Mw/r/XZhT3cl1UbV4XXfhnmWeHXkw26TacgjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=5wVgU9Wv; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="5wVgU9Wv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rrQ8zsAhO4o4LBZpMUQvrV2eWH59JPECEmCQQ0d9k5E=; b=5wVgU9WvglHehOz+gh2aOEKJEy
	NOSJrNDLMtV0dS9zFW5vOOfQUiT0eV/xSzEDDhGizhFh/DAspcVyZpF0nHIxGp63JeQQjJm8Wfm0y
	cSOi7MOs1mpIp3iTmrfwiHEy6KxxpQ3hdR+3pVI7TRsiiVTWWba8NHd7X07a6Fnhh8+IdtQrhxr6Q
	bRClIlzHD0nc/KCZnahijYqJXVLG0E8XUx4gqYVp8S4sGsKAK0r9epz9x4iKkHjoVBWdKwHMuothq
	ljQrpDOOnoYLiPGIBi8VW3Ykb1VGuiqjsXyiSN46PrOxTq4Li+5Pd1GL/pu/iRNUIe8RJnoaHwkjZ
	4oek5+Jg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxSIC-00000000PdA-15yE;
	Fri, 21 Aug 2026 13:40:32 -0300
Message-ID: <817d7032ea7ac21dff44604cc8377673@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: mdshahid03@gmail.com, Steve French <sfrench@samba.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Mohammad Shahid <mdshahid03@gmail.com>
Subject: Re: [PATCH] smb: client: remove redundant NULL check before kfree()
In-Reply-To: <20260703122104.69788-1-mdshahid03@gmail.com>
References: <20260703122104.69788-1-mdshahid03@gmail.com>
Date: Fri, 21 Aug 2026 13:40:31 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

mdshahid03@gmail.com writes:

> From: Mohammad Shahid <mdshahid03@gmail.com>
>
> kfree() safely handles NULL pointers, so the explicit NULL check
> before calling kfree() is unnecessary.
> ...

Applied.
