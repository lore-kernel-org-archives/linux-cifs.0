Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8965103F
	for <linux-cifs@vger.kernel.org>; Wed,  9 Oct 2024 20:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728505140; cv=none; b=gOe8ObsMx3n6SRx2sgPjV+tV+MCJpTuK5PfZxam4gQ3Brnp6k4ZI5OD3/5fE7lmX/DI49HG4mSt7d/7gx5OQPjio56nCWwdUZblf88aD0lhhY/qSnEKrxh491teKuWlgCZLp4BiA4JZxBnizFeK5MT8ylayxISnYy7Hw05XwQCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728505140; c=relaxed/simple;
	bh=AKq453LQ+DnJDbxbWshsY3R/ywiYukeJDl8YDhXQ+ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQidexJiFlauogfu/3JAy3EzJxV2j2UCo0c3K6orSUvF+UootGzHt8vjWVll9oG/4DKewHajgAAyBo96jjh48o06IKRBx0KouLP46A1IHXDsHUZMsX7UTc2RTRKTbQ8vgps7KNf9Oig6iGNZyFsQkK9BlyzTRTyZ1xBBmrExTug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZhMS9/aw; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZhMS9/aw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=QaVLAkrJugxTzf6dmwDHu8zNovSnPaVTIcAZesgH8I8=; b=ZhMS9/aw5KNgf+QEPDJ+aqda+t
	nMbDevJ7sUGWNvsr2xaiqcONL3ENNgTMpcFDi7gX9szFeZ0cT1sfz6hAQ4n9DzD+i1KUV4DapQDVB
	CeyiLAP6uVB+DNnMWYlhUZKiNH2k8pcen33WwBXazsQq9eUOKNF3qcI+7GvF/rUY4tw0aB1TlC0Fo
	QygKVvzEklOXA2JZfPzdL6LvRAVh5oaQZk7VTHsBKqdMkh37S/oWDWmZ37ot1nmAER3o48Q/5sKpV
	vHEWjxshluRD0/TUK2NWA7vCIAG2pY2LGa74+zcI0k05fF0kbDEqw1+Z+ISoBgbbtu+LXrU+IXOEw
	BeUhZJcIUOL8LxOIFp1O5eS/q4M9PP7MgOqu3J7bdXMfLMqgqBje++IJf6h86VUNFUjBPTXIA02Rn
	YuVvV3r01RRKAbMINhj1Lq36hEQgdrtvDycU9zWLv6m1VXZ+l+3NjcVm64Ev7cM/4pQ/QsUX2d8VY
	hQJw4VAxK+07aSx/IzgnPqKI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1syd95-0046CH-2v;
	Wed, 09 Oct 2024 20:18:56 +0000
Date: Wed, 9 Oct 2024 13:18:53 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	samba-technical <samba-technical@lists.samba.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Current Samba master incorrectly returns STATUS_INVALID_HANDLE
 on copy_chunk
Message-ID: <ZwblLYrVQM92eFl8@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mt7cE8Cc2K5K8nRM2RL=R-rwuAR9h6SSyEqtApuochtuQ@mail.gmail.com>
 <e12d7594-02df-4cbb-80fc-276d907afd90@samba.org>
 <CAH2r5muqSmNy+3SViFKNJ=5Sm61u8r9ej9Wy8JLUDeC2XHwccA@mail.gmail.com>
 <77aff6ef-291d-4840-82e2-b02646949541@samba.org>
 <d84732db-dea1-4fbd-9fc9-105c115c9ca0@samba.org>
 <990b4f16-2f5a-49ab-8a14-8b1f3cee94dc@samba.org>
 <ZwVM1-C0kBfJzNfM@jeremy-HP-Z840-Workstation>
 <569625f6-e0d2-43db-88cf-eb0fff6eb70e@samba.org>
 <ZwbczZYBsTU03Ycv@jeremy-HP-Z840-Workstation>
 <b84b2bb0-0afe-4f9e-9553-1a0201ed92d3@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b84b2bb0-0afe-4f9e-9553-1a0201ed92d3@samba.org>

On Wed, Oct 09, 2024 at 10:00:01PM +0200, Ralph Boehme via samba-technical wrote:
>
>Hm, interesting find
>
>But I guess this won't help as with POSIX you can open() a file with 
>O_APPEND but then still call pread/pwrite on the resulting fd.

Is that true ?

The open(2) man page only says:

        O_APPEND
               The file is opened in append mode.  Before each write(2), the file offset is positioned at the end of
               the file, as if with lseek(2).  The modification of the file offset and the write operation are  per‐
               formed as a single atomic step.

Aha ! It's not true (at least on Linux :-).

The pwrite(2) man page says:

BUGS
        POSIX requires that opening a file with the O_APPEND flag should have no effect on  the  location  at  which
        pwrite()  writes  data.   However, on Linux, if a file is opened with O_APPEND, pwrite() appends data to the
        end of the file, regardless of the value of offset.

So FILE_APPEND_DATA|SYNCHRONIZE == O_APPEND, on Linux at least.

