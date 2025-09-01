Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3362B9A4;
	Mon,  1 Sep 2025 08:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756714933; cv=none; b=q1Mrwkae9aGCgfKBp5rN1Pr2MYj0+mDiWzXQLiccTJ3l976LrxFP20YiMXb0aRcowsPle89y/lCwpS7Q3jpa5iDC+fWWrUeFqjFa2/ra4JCd9+EcOk0Ku8IrhxAlDm+ZgODhis6D85pBvG4OajC67qYbd21clZa4vpX2St6M0aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756714933; c=relaxed/simple;
	bh=qwpLHmSDSRBz3d+41Ly2TQl1GKN0VFAgGYUhbc9azPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FqYRejVddirh3n+YkN3BwrSOo6nSrrrPZqROn5Plmbyfr4o8yLoZRGVFKembczf2X+2//c6aEEeiml/+rPcmhzYaHkDO+7B0h6UD+8ZjW60A51VsuOWdEltKWwSMUG7bp3pLKboTOb/PbWwuptK8YEun8OxGA9VK7GBmdVG/hdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=y0DnCtgT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="y0DnCtgT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=2bH77HtHT7Beg9EeVABUioTwHj/sGnckukFuvimsMuE=; b=y0DnCtgTraEu/1KLDKeKP0SESH
	YciHEY22ikNYrUoBiPLPnkkPKOrpH1pWkV1KILScvCkxES/veXNW2Z0hopsIkLgFsALpAxNOxkASi
	ntkhY1Nqzj47SPUsNYwhoITS2CyK9q5tV4WVFNh2NPbRzz+cf4ZkF7+D9tVUq7sYoQRBLgPG7LM3f
	M0Lg1trOAk6pdmLziV7c+yahSuilVIo7ogRqLS81haE2wIL5kR7tAKhIyOcEEmetBLQLJWRCBPnrr
	1djHjlyrta6amuemlupQz+FjXcx+lO/cXPf/rjNY9x5kDIooavIVB/XWlaaEIEo0AG7tLpiOrH8Bd
	18ozObkJfjOuz5LKHHRSH1GAdy8gJ15Uf066nIbUKcIwOBRAtBfZMpT44KRI6NEpt2rR/r7TWvRLa
	+lMqhSiEGSC2+s3J+4vfI5waEmT8nPaldcTx9pl5YstdVc4ApxHoNqU0zZq4oDPvIaQj+oELhLHeI
	/RrWgg8TN+pI3oe4ZGwNoDES;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uszOE-001pw5-1P;
	Mon, 01 Sep 2025 07:55:46 +0000
Message-ID: <dfa557ed-eb34-4eaf-9e17-7cae221e74fd@samba.org>
Date: Mon, 1 Sep 2025 09:55:45 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/35] cifs: Fix SMB rmdir() and unlink() against Windows
 SMB servers
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 ronnie sahlberg <ronniesahlberg@gmail.com>, =?UTF-8?Q?Ralph_B=C3=B6hme?=
 <slow@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250831123602.14037-1-pali@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pali,

> This patch series improves Linux rmdir() and unlink() syscalls called on
> SMB mounts exported from Windows SMB servers which do not implement
> POSIX semantics of the file and directory removal.
> 
> This patch series should have no impact and no function change when
> communicating with the POSIX SMB servers, as they should implement
> proper rmdir and unlink logic.

Please note that even servers implementing posix/unix extensions,
may also have windows clients connected operating on the same files/directories.
And in that case even posix clients will see the windows behaviour
of DELETE_PENDING for set disposition or on rename
NT_STATUS_ACCESS_DENIED or NT_STATUS_DIRECTORY_NOT_EMPTY.

> When issuing remove path command against non-POSIX / Windows SMB server,
> it let the directory entry which is being removed in the directory until
> all users / clients close all handles / references to that path.
> 
> POSIX requires from rmdir() and unlink() syscalls that after successful
> call, the requested path / directory entry is released and allows to
> create a new file or directory with that name. This is currently not
> working against non-POSIX / Windows SMB servers.
> 
> To workaround this problem fix and improve existing cifs silly rename
> code and extend it also to SMB2 and SMB3 dialects when communicating
> with Windows SMB servers. Silly rename is applied only when it is
> necessary (when some other client has opened file or directory).
> If no other client has the file / dir open then silly rename is not
> used.

If I 'git grep -i silly fs/smb/client' there's no hit, can you
please explain what code do you mean with silly rename?

Thanks!
metze
