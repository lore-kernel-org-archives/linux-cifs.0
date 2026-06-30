Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C8E2609FD
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 14:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782830335; cv=none; b=rb6cmoF4xFJdBxTHWCBYtVjeH+u65BhAQk5Am0Q88EYw82x5v6EkwC9hdmTOMZpATzfOY7vcx6wZ6Q3pEs2vm9E6JqNjQ7NihQFDAq0iAIUI2Q2orJbjhD0VkxTyiErE9dbw+DuCIXiEHlssO6f/sAFCvbj37omdoTBytzopDg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782830335; c=relaxed/simple;
	bh=6wSBVYznNnTLOSGi3IppcRqmWCvMNeseEIlmwwzwIGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1GSWpRmop2w9GHk0ZMvLg10+yoF2kaXnkUh0GT/3IMU8uMzozYXLPi0cipfmmk4/3DIFfaWfs4joLri4IcEv5k1ssQoQq0DkR+cdT+sd2y7aulZxlG1ZK0aw8sXDv5fYU+qVPt269ZbxWZMm0BL3cTTXXJPNEBRLBD0UBkScu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=e3YD4kqf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="e3YD4kqf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=6wSBVYznNnTLOSGi3IppcRqmWCvMNeseEIlmwwzwIGo=; b=e3YD4kqfNhCU8WjoWy3bGIOuh5
	TXUoPFNIBTlIIX1aDCZDsHU2vP19iCt9s/s9dUONVw8r2LGp+c27Kv/tIUS5zr1MHrwW+bPVHKqpd
	8T40RR7iZhyXoBHpB7JEUl2LpSwskL5ertiwRP+C5I52FT1lx44u/dxsuQXDkIx9uXukwqoC8YAS2
	K1LeuUAckBVaOuoo79MB2wsuOcyHidUC3aVi7qOTUPZexdk1K7DoRcEgLn6/SzRIMItIfOPwPvTE4
	knTKYZVTP68atE2EiZlWcCjbaUPVOiV5jVtDzsO0HA4XaT69GE3yHG4S2RNXBsl6hWtPNmyZhEvw2
	omG84vErfl4m0eZ6hjtD5dnxxlVrQtSwox8R0jHhSWyv9z1Ilr4IU2sZB+v7tL4eJ9AFjPbsv/lDp
	sUxU/tsQQLaBY8XtTgjTIey7b4blHBfnf+80YeSdFZB+YDoxJjqXSyPSXOkvy9800Ki8GnNe3Lakf
	kiP2fO154z0uFrwfe7xYG9Nr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1weZbv-000000013tZ-1HwR;
	Tue, 30 Jun 2026 14:38:51 +0000
Date: Tue, 30 Jun 2026 07:38:47 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	"samba@lists.samba.org" <samba@lists.samba.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: [Samba] SMB3 POSIX Specification (was: Latest posix extensions
 spec)
Message-ID: <akPU9wqKzcWUZo5h@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mseJs38GECUG6dv6M+AL7Z1ZDp4k73-C2Wda3Krs2hOEg@mail.gmail.com>
 <CANT5p=quqzYD6YxCoGSb51W=AYeypWrTnZXRC03egqjXjjmeTg@mail.gmail.com>
 <c3eced4c-0360-470d-9add-7a249708f4dc@samba.org>
 <CAH2r5muK1ee-fyGiYKGmxGmo5ovvxem1+=YK0e1fyB3-dWaONQ@mail.gmail.com>
 <ab95aabc-8b7d-4022-bf74-1d4f451681d2@samba.org>
 <694ff16b-9f48-4837-aec7-ba965679dd8f@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <694ff16b-9f48-4837-aec7-ba965679dd8f@samba.org>

On Tue, Jun 30, 2026 at 11:09:59AM +0200, Ralph Boehme via samba wrote:
>+mailing lists
>
>All tasks completed.
>
>We now have a 1.0.0 release of the spec, yay!
>
>https://smb3posix.org/

Congratulations Ralph, Steve and everyone involved.

A milestone !
