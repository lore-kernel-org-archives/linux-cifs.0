Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC80231845
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754502084; cv=none; b=YBB31yilvYvDd4PbZEkrcciVL0lPYWqadKuCAwWP3nf4yxemDK4DvHX8msakd5q1TGJCmseq/VeeDkE6QwUypPcPDiWSF6is8V306WCokj9BsVdRcPC6IAhTGyoeuB+hW7TsEIj4GKDd8IVyu+VU/5lzbNyxzwhixwiSZDRL/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754502084; c=relaxed/simple;
	bh=StEfAlbFjrs5HmmLzAH+wfjumKo0u7TTdnirAsyTKe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7WhHlqa9rt7NFD0SmAWpDge7OnVvy4Y8QxUJnyAVUiENFabiQ0TBr1c2+dGNQTzzHkuTEAuBvZL+rcKxMOEplzIUWh0UTG9kYDe3jJu+3ZqtMY6Eayhe7Zpa5fz7Un/RUbxN4B8SHXIpxfRDgOg5MgnuYfdOOp4PlQAzSH14bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XwBbOVV4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XwBbOVV4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=IDE666TOfSG+Sr5tn6AUZeUJhjCPlMz+FaSL9DeB+es=; b=XwBbOVV4VzYlba78gR1M5dcAeV
	tdKY34z6R9VmUACnouUj4vCP2nWNNrDJR/41epEOf9CNDSsMcXlJKJZoTLFjGmNlcswglyTj3CrIW
	2Z2Gr06wmvafcXeEAOtinPU7vjPjTqsD0SpB2xFkiYLPZd8rmlFlZT2B4KNQ0iwJ9gkOYz47hZkAq
	Ou2RX3izz9dJmjOccxFHElE7JnY4nsLRQLZtDamAaoTdIMYyWcyvkaFe3p+I2Fj6C8JHvWp4gJFSB
	HUr53FTsocuVajZC2qlvYNNR3SsGpSD4u4Um1/3ro9+fJNvX4WS2GGqlCo/BGzsXqVQ3KmABBXcCX
	GmUYzfrkeiRDtPpY3PmlgapHdD45cWVX8AeYNRIH3e7MXU2xmMFE97G4apUevnvEiruu11Bhi1Fsw
	Zu2+Ej0qanCxLe5HDZtov7k7rfyLxJ85JaXoOyVJo64ab9WdBIBIuJvXBvd+JlVMlTj5vOLrJpt/w
	+7R7YA7nbTJKM9nS/u2L4yOx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji8e-001PHv-1n;
	Wed, 06 Aug 2025 17:41:20 +0000
Message-ID: <ea27f558-ab35-4607-b8a3-480c9ca4c6c3@samba.org>
Date: Wed, 6 Aug 2025 19:41:20 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] smb: smbdirect: more use of common structures e.g.
 smbdirect_send_io
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1754501401.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1754501401.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 06.08.25 um 19:35 schrieb Stefan Metzmacher via samba-technical:
> Hi,
> 
> this is the next step towards a common smbdirect layer
> between cifs.ko and ksmbd.ko, with the aim to provide
> a socket layer for userspace usage at the end of the road.
> 
> This patchset focuses on the usage of a common
> smbdirect_send_io and related structures in smbdirect_socket.send_io.
> 
> Note only patches 01-08 are intended to be merged soon,

Sorry it's just 01-07.

metze
