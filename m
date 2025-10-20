Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1882C3745;
	Mon, 20 Oct 2025 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760996926; cv=none; b=N0LeCINe6vpNSNAWPuvRFsmXDC/LYbRXslfOcee0WGeRzClEzz8/15xEiSnYbj//p+F/I7WQ/PG2XlAr/scWWUWdMwlkgisnUFJtFjrQaL6zqtVlGiVmxXKh/SNZfGzq78tT2UDz5wY1zZSVmJq9S7bStz14li/r2zzkijBedOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760996926; c=relaxed/simple;
	bh=PU8xqrPL32OwU9RzN8BAAKYLRXi9k7fryulkxnuUfo8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=THgpuR5zyOO3DfoordYSkDwoF0gEKR50tnieusC07QLl5DYGFXVApeQt36uNaW24GWcbo91G9crNd2QLIbPxGxSldZKCDN9eietH8YmvyA2UKP4M9dFFZfo6EjFQCt4fJUMcu/au2we4QOVq4GFYsIsPS8dYozXRUZ/Semoh9HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de; spf=pass smtp.mailfrom=hauke-m.de; dkim=pass (2048-bit key) header.d=hauke-m.de header.i=@hauke-m.de header.b=iHSwimkG; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hauke-m.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hauke-m.de header.i=@hauke-m.de header.b="iHSwimkG"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4cr8FH49Drz9skk;
	Mon, 20 Oct 2025 23:48:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
	t=1760996915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DO+lqegYdHRq0Vs0fvqr06SqaYi7NrVimVmbeBoYBZ4=;
	b=iHSwimkG8Cg6LDHMfAQCuITLd776z1s7MSVHnClgP9mBZgwRhFthfhSwQn1a/hOcepPlF5
	FalSH9P3lLckA39HbeKf5kmB9LI20qiDK6sloRKbtjh5fB1LwmUt+Oo5j+fS5uqmmkKwcD
	K7QZGPEg1TQVjr3ld52YuowK9FPEmbHRS6Juu0oZVRG80Z3Ec/+w4KdzFsz8v5pIMfL9u/
	4P1UuylTAHXoddo9K1H7xdV7Gn44PHz3Sv8uL626nEgbejW+4rDmZRDdDzMSc5tVP3lG53
	Ld4vmQVZATwDfufOX0Orzd4qWnB08lgtXin7F20paU4WoR/SPERa68azU/4kaQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of hauke@hauke-m.de designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=hauke@hauke-m.de
Message-ID: <172c928c-8f55-410b-a5f9-1e13c57e7908@hauke-m.de>
Date: Mon, 20 Oct 2025 23:48:32 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <stfrench@microsoft.com>
Cc: stable@vger.kernel.org, linux-cifs@vger.kernel.org
From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: ksmbd: add max ip connections parameter: backport problem 6.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4cr8FH49Drz9skk

Hi,

I think the backport of "ksmbd: add max ip connections parameter" to 
kernel 6.6 breaks the ksmbd ABI.

See here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.6.y&id=bc718d0bd87e372f7786c0239e340f3577ac94fa

The "struct ksmbd_startup_request" is part of the ABI.
The user space tool expects there the additional attribute:
	__s8	bind_interfaces_only;
See: 
https://github.com/cifsd-team/ksmbd-tools/commit/3b7d4b4c02ddeb81ed3e68b623ac1b62bfe57a43

Which was added in b2d99376c5d6 "ksmbd: browse interfaces list on 
FSCTL_QUERY_INTERFACE_INFO IOCTL".

Hauke
