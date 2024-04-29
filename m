Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A48627A
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410708; cv=none; b=W7AT3ZEomHwVBwahtG6Go+Gh+czkHMQteN6nBktOCxpGinoWJlvh6Z7Yr3DaVo3UFzeFK4QqakAlJBV2OyL5pbFbkrW7/+NpBvKwho214XVLhD/mXpIhDDIV0WWtiu0gM49eTF50DseFc2PlHrhuj2zIGvB8eQKD8PMERTakobM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410708; c=relaxed/simple;
	bh=bncNqXgXCpJGC21nf13YlvWBd9X6qTFWkwmv5NuypZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCaVzGVGwvz0ojuWfjShFvyi4No6mUJXcHwtCYtsU5miGYB52/4MQBFezuP7iePz/yUzSJv7oRMNHwApwHMOnwGDpw2nd6Jjv39xGCLJBaOLQtwz95TNtqVtCqjH7NBWygtdATwpgtSE6JiGjg/rqXNOXcKJsCqWNI/B2443Csc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DxWBYpv8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DxWBYpv8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=bncNqXgXCpJGC21nf13YlvWBd9X6qTFWkwmv5NuypZA=; b=DxWBYpv8wsh9VNqp5VoB8DlCbs
	ANruOuS7EeHGrzTiDG05Babth+H8aTKSSrT4/1yzGnzPFdFRMMnbip11umiHNxyDStOUBDOKANYo1
	7ELKrPHdVX+U6DDRFa6GxrokeBlPbs6BGH3zTBE+aUVPT8k0VbftYanzX+Z/T4KTanhwcA+ocQleE
	68B1TAC62pPX865wJkKyh4UytS8/U3vtvyJnw6Sylc6Ob3dG1ckzH/gRBVrsr4q8YueXwqU1OqRal
	jElNQiEzJUlPE+7wXnd3/5Li6nqu2RgsKF6Lz6T1TlR/1JEyTEomViAroYuJw/WC2wQM5fzRpbg7Y
	y3tHJ1jezcSYLL2lSWRbNhi0kcggRCEM762Fjy+40E6AAsWN6VGCz35U8KyiqLGHZn3xtIHKbfBSg
	VmH7f+dfnJ0GxrcX0jl2MILQ41K97nazcMmmFJ1UG6ZJiZ1U/R8b7Q4EzYryGvExze6/db/mbvYy+
	POgxU8oGmv8d4Fvu0/3VDOOZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1UXX-008yIC-13;
	Mon, 29 Apr 2024 17:11:43 +0000
Date: Mon, 29 Apr 2024 10:11:40 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	samba-technical <samba-technical@lists.samba.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: query fs info level 0x100
Message-ID: <Zi/UzF/guANa02KO@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
 <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
 <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
 <83480311-74b1-4ee6-be85-5b21b0f55ee9@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <83480311-74b1-4ee6-be85-5b21b0f55ee9@samba.org>

On Mon, Apr 29, 2024 at 06:44:39PM +0200, Ralph Boehme wrote:
>On 4/29/24 6:13 PM, Steve French wrote:
>>But the (current Samba) server fails the level 100 (level 0x64 in hex)
>>FS_POSIX_INFO with "STATUS_INVALID_ERROR_CLASS"
>>which causes all xfstests to break since they can't verify the mount
>>(e.g. with "stat -f").
>>Nothing related to this on the client has changed, and ksmbd has
>>always supported this so works fine there.
>
>ah, I broke it. Fix attached. Really embarrassing...

Double embarrassing, I +1 reviewed it. So sorry for the bug :-(.
