Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6EA4C3C8;
	Mon,  8 Jan 2024 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=schenkel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schenkel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schenkel.net header.i=@schenkel.net header.b="YtiLh9tL";
	dkim=pass (2048-bit key) header.d=schenkel.net header.i=@schenkel.net header.b="UH9Qr1Vk"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4T7xR13Jt5z9sb4;
	Mon,  8 Jan 2024 15:34:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=schenkel.net;
	s=MBO0001; t=1704724477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UOl6ByWBJ/gZDfQoMzTkCP7SAswXsTnB6KMowssrUXs=;
	b=YtiLh9tLhXjS/c+5c96sfhcqrZDVjFxecV701uXlIV0fIQoYGLLmM+9FZYCfRDN1E31djz
	X7rL1K6ZIuZfTkd2GHpVCwSsYaPceFv6DJ42UC0tNUpUOpEBx5H1jtCW2GQV2r4U3wwbYs
	+ybCaX6nccnJdfVp9kw23dfKoP0OK5hZOhJUBmZZ8uuNKgfvQqi49tlhWLh79BEk7L8ORR
	GJqeFrQQpCwyk2dolkqEFBbGWoOAWyNS5bgHfJ6lg0mXqiJFCFCwJDNkHVdFq1fzD7icaV
	JZmHAnGZ/tC+i44Rvk7BjnkqKUY19gzYAAY8UNW66p2ii7GDJUQFYIV7a23b8g==
Message-ID: <e8aed716-68ba-458c-bcde-f7ea39d6774d@schenkel.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=schenkel.net;
	s=mail; t=1704724475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UOl6ByWBJ/gZDfQoMzTkCP7SAswXsTnB6KMowssrUXs=;
	b=UH9Qr1VkBpTZysz2uvQ9TFdA9cik8wmg8O/2hrjKgjbsWNRS2dvZRoE51ERiGxjy41s9Ep
	XnHdCN+mUdHBWTRBfYeMKgboZrrpLx8QC98To+u14t5jw1hunTt9xszyvUS2YAmOcxvR6l
	OEDtLI+E5oPYnFqjsV5QDdQOn9TbGFLriZ9M5CxYsRkrbxE5YDpo/vxxJtOD8m9+MAYFtO
	cx9MNNYia8bBIHZiPkR1USV01B/a0xBYK7l41NHLn0zo1SUyoFvAcQe3vsG0E0mvrNEtzx
	CCYtIV58dIPZHoopsqyUA6hLR619k/cQQ//qvB/dTHU/hJyE6xLeRcuDxQ8MMg==
Date: Mon, 8 Jan 2024 15:34:34 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Content-Language: en-US, pt-BR, sv-SE
To: Greg KH <gregkh@linuxfoundation.org>, =?UTF-8?B?SmFuIMSMZXJtw6Fr?=
 <sairon@sairon.cz>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
References: <8ad7c20e-0645-40f3-96e6-75257b4bd31a@schenkel.net>
 <7425b05a-d9a1-4c06-89a2-575504e132c3@sairon.cz>
 <2024010838-saddlebag-overspend-e027@gregkh>
From: Leonardo Brondani Schenkel <leonardo@schenkel.net>
In-Reply-To: <2024010838-saddlebag-overspend-e027@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-01-08 15:13, Greg KH wrote:
> That's interesting, there's a different cifs report that says a
> different commit was the issue:
> 	https://lore.kernel.org/r/ZZhrpNJ3zxMR8wcU@eldamar.lan
> 
> is that the same as this one?

It looks like a different issue. The linked report claims that the 
problem was introduced in 6.1.69 by a different commit, but both
Jan Čermák and I don't experience anything wrong with 6.1.69. Jan Čermák 
found commit bef4315f19ba6f434054f58b958c0cf058c7a43f via bisection and 
compiled a kernel that reverts it, and the problem stopped manifesting.


