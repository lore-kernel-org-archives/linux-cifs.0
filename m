Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F213D565D
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271982; cv=none; b=S5Yncq2ZDzTAw5q/AfgVCXbnyvyIyB2E5HUsp3Rbgnn3e1auRqFKYo2Hxk+5nJDpbXjuwjQ5cEM3wJtuitiiT99yoADtetLbiga+gevh9E90oXm8Dr0o5QrGx+t2qCs3UWA3NEgoc5Wo5jS6iP5i+0Pe67vuyqFuwCSxlkP130Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271982; c=relaxed/simple;
	bh=ig76eUXoixDPnZRteKV5toYfSj0FbparhhCMwI24Dow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGShoDxEpxqFtpviCfx9J2E1Lv8SO6MsIsBeLGxh/6IuzxSOl04o/XzKhhaFmIbJV7iRh+bIy3Vczw8k1Bq2L7yomApn5xstu1/fgeTIb7AEUMqjNYdwCyr6rcVjqZULkz4qQEbvIG5AiP0cerJM0olyj9pMYzdJRp0CrvgGmv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=M0nerQpq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="M0nerQpq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ig76eUXoixDPnZRteKV5toYfSj0FbparhhCMwI24Dow=; b=M0nerQpqLDDlVlR3Wv/1X39Qp2
	Oa7P6T8GZ6cbzgdTf0zWecbHnI2anHjWZIVbH51ZNH6dUxL/4YLZdnSDHWS8jDkneKfdjMoUSYMVo
	guGwXfBYUKuUm2ar8AHPH4WO1sUfciUkQUHkWZ88lEHYZbrFTUT3mCScBVZVN8HsNwVwzkfUl+5Sn
	PqhvbpVMO90DiJGikgRYU3qtK+ldzoAdqLldqNyBhWpDV3IDYwnGwVdquWxoHe+4AMRTlOgfsh/K/
	d9TBpEsHtV2KSAfQWtZRZKA4zbuZr3XC6kGgLVnH3AwlkcLsjspiTTczixzH/KpDtLXMMC3aGNKq5
	Hq9oH4yk3O5QXV/2K5I500HEWlH8rvRX0ejibC0RoA56kG5ho7zqIqtfUOMoPyk8wP6p30mSTD0hg
	NwRq2WJ7SUOEN7Bs5EKnmohgDt5Lr8llKK7OWByR0piWISVGHQ066QBf4kGfU6MycM5CmH+iz165h
	f0aX+gCg1Cjr/pXzGStNAbCm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wPdv7-0000000AMsO-44me;
	Wed, 20 May 2026 10:12:58 +0000
Message-ID: <f5d913ed-6e36-433e-9549-66b8a76eab62@samba.org>
Date: Wed, 20 May 2026 12:12:57 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH samba] smbclient: cancel pending notify on SIGINT
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
 Samba Technical <samba-technical@lists.samba.org>
References: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
 <9ecddf93-3599-4e0e-8aa9-93890fd54d96@chenxiaosong.com>
 <83ba770d-1a75-4231-843a-3e51ce3f85e5@samba.org>
 <60328fa3-1370-46a7-9114-0267ef0551ce@chenxiaosong.com>
 <9b73c105-03af-4e71-93b5-a94e13b8c7dd@samba.org>
 <3a43f239-f35c-4d69-9c21-b410f0e38081@chenxiaosong.com>
 <d23c9f3c-4c0b-44d3-ac0e-6f054b955c85@chenxiaosong.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <d23c9f3c-4c0b-44d3-ac0e-6f054b955c85@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 20.05.26 um 12:07 schrieb ChenXiaoSong:
> But this patch is helpful for improving smbclient. When we press Ctrl+C, it should exit notify instead of terminating smbclient.

See https://wiki.samba.org/index.php/Contribute and https://wiki.samba.org/index.php/Samba_on_GitLab
and create a merged request :-)

metze
