Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6400948AE32;
	Thu,  2 Jul 2026 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782996803; cv=none; b=kKhgdSDLClYljloHUgSjx9zBOBDZn24erJVKnSHjA7t5KP4jLr7ZwoZIF2S2JVhesneLxC5VLx1QZYInG88Cg5xxZiEVb5ISvq1Mx9+ld0cXTryhPVMnFqoqkp+XRu99x5XRVRF6zZ86AakbLGMgGwCRTMWQB5v/u/YtLm5339g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782996803; c=relaxed/simple;
	bh=0uZBVMgQh6gHpmyDZZViUHEzR/wUaCj6WKFrEkYZDck=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YWe6Tn3yqEE4rpMSfw9yKh6c2De0r02FaFQmlWuNpg8SZjzoZrZQQChnO5yJ2OEQk4KAj5dZuQIs0zsRayV+lC2vXqzw/6fQIzlRuq4hDM23ka6jDq8QwnAgSS0E2YOYBwmXr5pZQcaKqq8f1nDIv7G/o5HHgV8E7sefrEQ2Yl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=nWOgm/Ah; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="nWOgm/Ah"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wMP9LvoVkQyinpAE6ybVbenCMfvP4LaFOSzXmru6z3U=; b=nWOgm/AhASE6AuwFmLcWffF41+
	nekd5M1fv4QEiUMD4Q4nZAlOs/YjrZQWL/SNpbsF1X3ndZwv5ge8Mx/9FOj9GxPRGWwZ/wOC9+O8u
	JpyiDft+pXWRoDhknTfPN8F2OSViOi0Vkyvo86zJz5a7QIu3dR3VUWuwGO14ew9tMDfrf2X8g9uik
	0IfX0nRrMLOE7izMPPdpDkJVa+MywDzmeWkvAyaMWHBh26sKe+WOP2T99DWp0P/L8O0rfwms425IY
	wA5LpU660Y51Tko2r61ULMfcebDQYedcdRfUmPY/65LZYfy2/5mTIPdbxamxdUriiUoEHoyP7JLTI
	rHKUJc1A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.2)
	id 1wfGul-00000002Z6m-1Tbz;
	Thu, 02 Jul 2026 09:53:11 -0300
Message-ID: <cfbb3e301d90d034922b945c522813df@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>
Cc: dhowells@redhat.com, Christian Brauner <brauner@kernel.org>,
 linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix missing credit release on failure in
 cifs_issue_read()
In-Reply-To: <138902.1782980700@warthog.procyon.org.uk>
References: <138902.1782980700@warthog.procyon.org.uk>
Date: Thu, 02 Jul 2026 09:53:11 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

> Fix missing release of credits in the failure path in cifs_issue_read()
> lest retrying the subreq just overwrites the credits value.
>
> Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
> Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: linux-cifs@vger.kernel.org
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/smb/client/file.c |    1 +
>  1 file changed, 1 insertion(+)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
