Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2913126C3
	for <linux-cifs@vger.kernel.org>; Fri, 12 Dec 2025 10:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534814; cv=none; b=jfv6x/GBOZVJjCZdEUQN0PjLsBIUrCjB4j2xk/SJBHnfRblY6vCkzlU3y/XAbodaG+W5vdFLtwdI5uRJC4v/Rr4dAbinX42QPm5FnjehlOCOAEzOrh2Da9kT4nwfEP4kslsNYnlpaAftB0qBQkM0LRBwJUIM6q7BW3+1V+Jx4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534814; c=relaxed/simple;
	bh=pdEkipOlWIO5AoUrg7oAkPUuJ8iZwbpJUSD8P/EisK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oKxCBQfD+hRfV7rKgKtaoGMcjuPR7GCO3PZrHX540AMVwQoH8LgbYn0VIodG45by90NEY3eMAaHgwkOaJZyAXaF0A6CNetRZrnsmfwYaIsL0+Yifl/rpi9pgI49+Y2efvwqiVW4M4K4lGcJylXo+QjK1QJdrMwIZnKVhafoad2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xdecg7LF; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xdecg7LF"
Message-ID: <d8768340-fc1f-440c-a2ed-92fbce332e60@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765534808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PoObOd7w+JFjj3KTqG5P3Iy/n3JAr/Tu4DPWQjO6vcg=;
	b=xdecg7LF6JVjU+E4df1jLTOJB3AubGHfvD733Zf22p6jfVOsImXrSlVThtOrqdXlKWanuT
	cGdd8QMFgo74GwX84Z2qY6USwtuCLgeMQlBetjyVZUi7oCFjkf2ur2YxeMdJM8CjzUyH85
	27JY1OQ7FMjmylbP5zuCehHO/+4Lfjs=
Date: Fri, 12 Dec 2025 18:19:51 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@samba.org>
Cc: liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
 Paulo Alcantara <pc@manguebit.org>, CIFS <linux-cifs@vger.kernel.org>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev>
 <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev>
 <650896.1765407799@warthog.procyon.org.uk>
 <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev>
 <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com>
 <782578.1765465450@warthog.procyon.org.uk>
 <811840.1765532505@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <811840.1765532505@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Maybe we can merge the SMB1 and SMB2 error codes into a single header 
file, but SMB1 seems to use fewer error codes. We should ask for Steve’s 
and Namjae's opinions on this.

Thanks,
ChenXiaoSong.

On 12/12/25 5:41 PM, David Howells wrote:
> ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:
> 
>> Please see my minor suggestions and KUnit test results at this link:
>> https://chenxiaosong.com/en/smb-map-error.html
> 
> Okay.  Note it would be useful if you could reply to the email with minor
> suggestions so that they're archived along with the emails.
> 
> Also note that the format we end up going with for smb2status.h is up for
> discussion.  My preferred idea is something along the lines of:
> 
> 	enum nt_status_codes {
> 		STATUS_SUCCESS		= 0x00000000, // 0
> 		STATUS_WAIT_0		= STATUS_SUCCESS,
> 		STATUS_WAIT_1		= 0x00000001, // -EIO
> 		STATUS_WAIT_2		= 0x00000002, // -EIO
> 		STATUS_WAIT_3		= 0x00000003, // -EIO
> 		...
> 	};
> 
> and switching to using cpu-endian in the code.
> 
> David

