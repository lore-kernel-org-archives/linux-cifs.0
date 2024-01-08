Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7063251C34;
	Mon,  8 Jan 2024 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zW8o0y5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3325C433AB;
	Mon,  8 Jan 2024 15:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704727073;
	bh=QBBvzPy3PIfE0zsc4vMISvmpZvyovM+ooqBsR697utQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zW8o0y5Op5fYvE37RukX5xGNZ9ZrN/GvmE4MWLcI7Wfg1nRJ6r/JObycldPriqwy0
	 U+6j2Ru+ihWteO/kCXv1XGzpTpseDMNmWuPL73+lQWvS+kj8/Keun3q8gSNq/PzAa6
	 p/z5ARvEav/yfH2PAbOXcrmxld+oguaEcB1N6Ia0=
Date: Mon, 8 Jan 2024 16:11:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Jan =?utf-8?B?xIxlcm3DoWs=?= <sairon@sairon.cz>,
	Leonardo Brondani Schenkel <leonardo@schenkel.net>,
	stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Mathias =?iso-8859-1?Q?Wei=DFbach?= <m.weissbach@info-gate.de>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Message-ID: <2024010846-hefty-program-09c0@gregkh>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <446860c571d0699ed664175262a9e84b@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <446860c571d0699ed664175262a9e84b@manguebit.com>

On Mon, Jan 08, 2024 at 11:52:45AM -0300, Paulo Alcantara wrote:
> Hi Jan,
> 
> Thanks for the report.
> 
> So this bug is related to an off-by-one in smb2_set_next_command() when
> the client attempts to pad SMB2_QUERY_INFO request -- since it isn't 8 byte
> aligned -- even though smb2_query_info_compound() doesn't provide an extra
> iov for such padding.
> 
> v6.1.y doesn't have
> 
>         eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
> 
> and the commit does
> 
> 	+	if (unlikely(check_add_overflow(input_len, sizeof(*req), &len) ||
> 	+		     len > CIFSMaxBufSize))
> 	+		return -EINVAL;
> 	+
> 
> so sizeof(*req) will wrongly include the extra byte from
> smb2_query_info_req::Buffer making @len unaligned and therefore causing
> OOB in smb2_set_next_command().
> 
> A simple fix for that would be
> 
> 	diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> 	index 05ff8a457a3d..aed5067661de 100644
> 	--- a/fs/smb/client/smb2pdu.c
> 	+++ b/fs/smb/client/smb2pdu.c
> 	@@ -3556,7 +3556,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
> 	 
> 	 	iov[0].iov_base = (char *)req;
> 	 	/* 1 for Buffer */
> 	-	iov[0].iov_len = len;
> 	+	iov[0].iov_len = len - 1;
> 	 	return 0;
> 	 }
> 

Why can't we just include eb3e28c1e89b ("smb3: Replace smb2pdu 1-element
arrays with flex-arrays") to resolve this?

I've queued it up now.

thanks,

greg k-h
