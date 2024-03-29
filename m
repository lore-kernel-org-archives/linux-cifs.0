Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556DA79DF
	for <linux-cifs@vger.kernel.org>; Fri, 29 Mar 2024 22:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711750053; cv=none; b=LrPrSJCLUfkctCR6te0TDGNgICG0jRhY3ca13qxCXaEWJPKTheOtTDPXbY8MWOpWqCxAZCmAmmlVmhlLLSMK0dUzzJD557OXWz2m2PFm/dgMIm04cLxYQ6GeUr8fmSQBQchAO68wRA4YKymOBqT2XRR/jlcvSCF7ps302Xf37a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711750053; c=relaxed/simple;
	bh=E3/tKJy3r6kKo8k173sVO7xZz+nhLO0iYu9rgDX6s/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTq3ioa1NC/nLdZJR4hTk3gNMZjxjXU1yYJIqm2d/MwXkzBe810s2KwhUQ19dOSEsKHz09+PhP7tAIC2sOOa6sEGbIW9Zhj2ULm+g/z21j2802uEF73t+cnStrH1ZE2EgqPmjrr/yrZks+eVKnmR9csSx1bLOAiFo960alaLVZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iQvHwVxX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iQvHwVxX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=BjxHKwcmF8JyqoizniMV56RBl5SZztO956z5LgVrR4A=; b=iQvHwVxXzKhN9TrgF+4ClS7USF
	TFbOaDCMYklqGbxIWPDKkTIsdvL+T0QlYfoSwKmZ7Ye8aTPFpUue+ro/UEhCTo8pRFWYlI6r5aqqE
	Lonx5ElHBpVZmmV66NmKDxLlFtKmOmQbiUGMe57LBdiTINdAX5PJXhlZcibgW9HMmM+TtK8+JlXpa
	rCrUWaR34AHnZVyLIuFq5jSBFWXzoPcYYUGeAS1m80oVMSSO3aPcf4h/Im0eV7Nm6OSxa5m7Gw6gL
	GwiAXCfyO30JHpCHPH4iZIxbaps5Vx0HH7DBqNiOtzcE6vcKGZyNT6ByvpgGsn5csU14Bh9TZUdFR
	1GWvzWlOb2BTSII+WfmvSmRhU0vNeJZzzFYBUnhGt9juez6xxriFElmuj5Mjwg9GOIWpDd2XMXdES
	hImlXxjnbEXR5W8NW6FU/FhJey3wfd+FbSo5+XxjuYk7QnjlODPoekfNyaao803JiThZ2ALmq14Ma
	h2lFNFYEN7UJgnXAMWCqH/m5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rqKNd-003efJ-2F;
	Fri, 29 Mar 2024 22:07:22 +0000
Date: Fri, 29 Mar 2024 15:07:18 -0700
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH][WIP] populate superblock uuid at mount time
Message-ID: <Zgc7lrgBSmNPIUSY@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5muYgYr=kxSkzCmNQLaF0br_QZ2s=BLPd_TnOnPmTUz_WQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muYgYr=kxSkzCmNQLaF0br_QZ2s=BLPd_TnOnPmTUz_WQ@mail.gmail.com>

On Fri, Mar 29, 2024 at 01:30:42AM -0500, Steve French wrote:
>In order to get the unique id for the volume (the 8 byte
>VolumeSerialNumber) we need to issue a QUERY_INFO level 59
>(FILE_ID_INFORMATION).  Today we only query the older 4 byte (not
>guaranteed to be unique serial number).   See section 2.4.21 of
>MS-FSCC.  Looks like Samba and ksmbd do not support this info level
>though - although Windows does support it.
>
>Any thoughts on ksmbd or Samba support for FILE_ID_INFORMATION query?
>
>See attached work in progress patch

2.4.21 wants a 64-bit volume ID, and a 128-bit file id.

How do you want this synthesized from a 64-bit inode ?

Can we get a standard mapping for this ?
