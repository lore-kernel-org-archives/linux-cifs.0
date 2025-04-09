Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2645210F53
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 22:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744238615; cv=none; b=l9P+iCS0dYkA56TV2NDMCVa9ZPn7ZlHpHRGMzGYEYXeGBX1TCXhPQYbBXUFX0wAMMrp0rUmH53rIo1OmO5H5nenEXkGUI5G/mqWF/6PBtywvwKmiV76/TBZ8NAKUWoW80o7DgoXvlCJ3GU/M6tLQsFhFOTKQ+xGWRziaDdPmdnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744238615; c=relaxed/simple;
	bh=mo/Fdrk2V/sFnORqRxXt7pqJxhKvZ3ifma+gpd4TJ8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fKVpmGxC4C2XaYH+UkFj3hWSH8FuOdSKuWxKigbr2LyFGtLUzSYAeNf/NCoutoRSc5fHcg2XDB0JOxztHTqSxGYzj6rS0w1j+WnKcyBMRLoUQPmd2vCVBq3dI1CIWMA+tT7skm5ZuY7ZOLg0mWry0oOqm1DpELQRhR2blUz/oPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NjO+r+FQ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NjO+r+FQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=K3tqpFwotlUoBuBNXzOmYbqoL5by+YgGBst/pSlaevw=; b=NjO+r+FQWxFBnBgGOfcc1VjSJ+
	/SLR7Umpai3G/2NUDqRlqaSiZoZWaq2anFL4jCt7axFqK2ia+Aaqo8gPLPWaC9RVmFGnGlpo4Igb1
	rZr896WAfWf70eRpeAMmdDKqmF01MTz49vE4+PZSMjrIWVsqa2R88FpUGcZGEbGobDaCgC74QoXdP
	s69WRT/hU6P1bIiQvVKb7eQ66ku0+TnnoR1oTR2J8DeqY1b8ijssNWRGwak28A261mE/ot5UuFW4G
	OuQL1b/0Vaca4SB6kiU26uQkdFz/9NdD5YaUGgMgIfkrjN8d6/4St59kKgbfW7R/fD4XSK+o2Fcdy
	YhMdu5DeRGWzMvegOAnUhVRvgwafHpEl738Tbgup+RAJmZ67MJNoqmkeHBIjx6lTcKVRAKHR6nZX6
	ZwlyKaSqrIIhPoNdz+OVo3qtiZWhbK1Vw2G4uTuQQ4zvrioVDd1D+P5lSBuYtSXS3G/efO2/vxf8e
	srV4atPZgG/15xskgBSTJnrs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1u2e8n-008z4R-1D;
	Wed, 09 Apr 2025 22:43:29 +0000
Date: Wed, 9 Apr 2025 15:43:25 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Tom Talpey <tom@talpey.com>,
	Steven French <Steven.French@microsoft.com>,
	"vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
Message-ID: <Z_b4DS3kOpbCI4pG@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>

On Wed, Apr 09, 2025 at 08:18:22PM +0200, Ralph Boehme wrote:
>Hi folks,
>
>what should be the behavior with SMB3 POSIX when a POSIX client tries 
>to delete a file that has FILE_ATTRIBUTE_READONLY set?
>
>The major question that we must answer is, if this we would want to 
>allow for POSIX clients to ignore this in some way: either completely 
>ignore it on POSIX handles or first check if the handle has requested 
>and been granted WRITE_ATTRIBUTES access.
>
>Checking WRITE_ATTRIBUTES first means we would correctly honor 
>permissions and the client could have removed FILE_ATTRIBUTE_READONLY 
>anyway to then remove the file.
>
>Windows has some new bits FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE 
>to handle this locally (!) and it seems to be doing it without 
>checking WRITE_ATTRIBUTES on the server.
>
><https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/2e860264-018a-47b3-8555-565a13b35a45>
>
>Thoughts?

Does Windows ever send FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE over
the wire ? What happens if smbclient does ?
