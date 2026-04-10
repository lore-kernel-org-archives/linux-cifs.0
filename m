Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122B43C13FD
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 13:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775829179; cv=none; b=KFukw0ovCWQAcEdPSQ0k25/7888pt8QxFptkdoveiQgMQhpGRhgRKiXd4Ol1Gom6nq73psWhI9fYHr7WJnjuALg1Gb71XurDcvWTZP7u8pDgVCTQ5U30E3Z8NSyUNt0OTfzdB5Wo3FYr3l/aCSCJMkaYKuQwku/k9C/Of1WEfys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775829179; c=relaxed/simple;
	bh=oIcu33xbmKvhiFYNilfZRp0jACDNxm9YN+Lu0D5+2tA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ebdrQzZkCamCRC1qtn4dPxJ5h10bImJ/G2rZvh0pqeON5/wBuRbGFGpd5daUYg6OyRGJphyOlfE76fVpsSpkbPdx/A1kUpb5aGqhmvKJ2Lb7RBHfPmItE1dCiHuIrZzdGFYEuYzKAQLSdTUuL0ONTJIBU0GFoOMMz4J9AuSlKE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vZa7bYXv; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vZa7bYXv"
Message-ID: <d7ed8f4a-dcc5-4654-abd6-53409685f161@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775829164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SO79Qfrrx7O/VRbSBy2Z0nQzfNB4pVgwqo7orV+0754=;
	b=vZa7bYXviBNpJ4g2EQtH1X7tVY2OvVoC4pDedmtwYyKlHQshQVRm0fJA1WoGU/UefRA7mT
	u+2QUnvz0FgzX8y9FFLlS8+jLm+vNzRNsRNmrBrD/LtpnvFT9MdAtP2Ko2tM4HlW7vxoes
	abJXN0iwa9H9xDRRqVvKPczSdW3e8YPNNFOOKjF4lEGYohNgVsvZiLAtK9NM/UrfAayNM9
	X2AptiuCFl0Gj3Q60PoL11frIEjCfGu6yiWOnaNN6QOpCbYIvZbIQoi5YBbXFZpttNgdUX
	HoXGLSXv5pvdOn1govh6zuMZ/2hCs+itJw9RHzZYv3C91kRTSxFe7bHRjYyvPg==
Date: Fri, 10 Apr 2026 21:52:27 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] smb: client: add missing MODULE_DESCRIPTION() to
 smb1maperror_test
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, sfrench@samba.org,
 pc@manguebit.org
Cc: skb99@linux.ibm.com, maddy@linux.ibm.com, linux-cifs@vger.kernel.org,
 linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260410064030.89137-1-venkat88@linux.ibm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260410064030.89137-1-venkat88@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Thanks for your patch. It is "KUnit test" rather than "selftest".

Perhaps the following description would be better: "KUnit tests of SMB1 
maperror".

On 2026/4/10 14:40, Venkat Rao Bagalkote wrote:
> +MODULE_DESCRIPTION("SMB1 error mapping selftest module");
