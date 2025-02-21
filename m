Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159912512F6
	for <linux-cifs@vger.kernel.org>; Fri, 21 Feb 2025 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162291; cv=none; b=efNuO/qmjcrhJZ1GfiChz6aoit6hJKVtrP1aNAvl714xL9/xmDcsoCF1IIinDKGlfyhjzDJV5GnFqkcMqMSWOh7xknWew6eXuLBNpnq7ykv8430NliIeTRp/tfwTJiya3T+Ogt9YociTPofdzV7EFlatHJMuPKZ+o9Ql46EmMfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162291; c=relaxed/simple;
	bh=ydmGVURAeTjRhlYXuCLvdNQzmLGiLTBlaszgnc/fihs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPrQgCsdRDhSGHME4lNGlirmwxrr/rpNurMsO8ULFhhm4zshv+D5YAyzh9Kunut7fGQuAyHYx23J37/Bkgn4rAGrYqM70yPvewFN48JsngYbk13SzjBPAFCD9m1hYJSwiaSq/WPpoRu6TqYL6Ccrb3JJBaOL5AOzCWmGzfXEsQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-114-12.bstnma.fios.verizon.net [173.48.114.12])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 51LIOGib007540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 13:24:17 -0500
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 73B972E011A; Fri, 21 Feb 2025 13:24:16 -0500 (EST)
Date: Fri, 21 Feb 2025 13:24:16 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steve French <sfrench@samba.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] fs: Implement support for fsx_xflags_mask,
 fsx_xflags2 and fsx_xflags2_mask into vfs
Message-ID: <20250221182416.GA2252164@mit.edu>
References: <20250216164029.20673-1-pali@kernel.org>
 <20250216164029.20673-4-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250216164029.20673-4-pali@kernel.org>

On Sun, Feb 16, 2025 at 05:40:28PM +0100, Pali Rohár wrote:
> This change adds support for new struct fileattr fields fsx_xflags_mask,
> fsx_xflags2 and fsx_xflags2_mask into FS_IOC_FSGETXATTR and
> FS_IOC_FSSETXATTR ioctls.

I don't think I saw an answer to this question (but the discussions of
the mail thread have really sprawled a bit and so it's hard to review
all of the messages in the thread) --- so.... what's your reason for
creating this new fsx_xflags2 field as opposed to just defining new
flags bits for fsx_xflags field?  There are plenty of unused bits in
the FS_XFLAG_* space.

Cheers,

					- Ted
					
