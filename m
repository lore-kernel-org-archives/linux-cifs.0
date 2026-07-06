Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692CF42464E
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 12:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339727; cv=none; b=E6qS1vtlg5Y/PQtcsghBVZqZudLjSzyoBmUyqfs0vU95Z95IDnrROmhCsApFDEyB7dnGm0VuLRYX552DlmzBT6Jo4qxxFwtnBl9BhrFlgGRG18xeiIVAeFYZ+L4TmDA3GFydK1aoqU67fTB4Wd6Vx5dvmaafyVaZUcJph6pYq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339727; c=relaxed/simple;
	bh=n7uXPeNigbEMhdNwcw4rEe3Pr/v19jUi09pXtGh0e1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jhMMsGDcd8u9b0G+qNBHJG0fsEYfqPo/PaKeSPYIwH9184N9FWqrMX23DB1B/E6pa6cNXrO10rXk0i5DGs6aKwgMPbXL6X+onr2KLu4VhsAZXMlBsWDYEFbUEUHN0/nYg3NehlTUxS/Ex8YyCdlfOfdj3RvwNArU2cCmTFXW4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=h4kn+ZMU; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="h4kn+ZMU"
Message-ID: <b6525ea0-43e3-4175-b47c-4914c9785c95@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783339720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQTHli00YKJ1S/ZSZFWfqKsXVHM5+BIUTH3dsQeHC4c=;
	b=h4kn+ZMUo9fMfB04NP1afHyis/KcYPyN5fC7fYgOGcAJUA3pqGCDj7yAUoVt+oHjSNDouD
	RNUXkqcbh5kzcAImDl2fIj5svpiT/+XsJQeYGbOui5yq+bjzSgKHUJ4rWaPPEEuQzYYk0k
	DU++H4SKRxHSq9Cti4XJcMhQ5N/vcjFuTyjSglPwETKMA6mv+3ip6yhRlyGDfWnMVw+hKT
	S7BEcaNUoApefZPwiYHqFvbtRCXLQMsJ5wB+o3O/0F9SL6tvUepoK+tOX4PxMss80dyR21
	eLn35OVsCisKInerd9fgV4AiWkuYPHX44jUNP5d006YoHs1po51hjdMB7QkgBQ==
Date: Mon, 6 Jul 2026 20:07:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] smb/server: preserve compound prefix for async
 interim responses
To: Namjae Jeon <linkinjeon@kernel.org>, metze@samba.org
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org
References: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
 <20260702110522.911411-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

These three test cases also fail when using Samba as the server.
I will also debug why Samba fails.

smbd --version
Version 4.25.0pre1-GIT-bffb51f09ab

test: compound-padding
failure: compound-padding [
../../source4/torture/smb2/compound.c:1175: Incorrect status 
NT_STATUS_OBJECT_NAME_INVALID - should be NT_STATUS_OK
]

test: write_write
failure: write_write [
(../../source4/torture/smb2/compound.c:2549) Incorrect value 
req[1]->cancel.can_cancel=0 - should be 1
]

test: read_read
failure: read_read [
(../../source4/torture/smb2/compound.c:2653) Incorrect value 
req[1]->cancel.can_cancel=0 - should be 1
]

On 7/4/26 16:52, Namjae Jeon wrote:
> smb2.compound.compound-padding
> smb2.compound_async.write_write
> smb2.compound_async.read_read
-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

