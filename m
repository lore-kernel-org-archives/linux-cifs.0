Received: from smtp.smtpout.orange.fr (smtp-19.smtpout.orange.fr [80.12.242.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9983132494;
	Mon, 15 Jul 2024 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721020575; cv=none; b=GhYtVmQYXZBbsmdnThp7WAY+BXb0eSgZ/3BUD+ibpg2OtchRLmhg+5PSkNOZ9LCYTwsvGeGobFJKoogMcZj+pdFeeE7wUxHcWNi1ecQcs96ebSQwHXnBvbc/iKIIlfhTo1qTapo32aTxrf40tBAmmED5/44OZ92B9FBa8Bj1CLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721020575; c=relaxed/simple;
	bh=H7td3Dce0rAX95cXB5akm7kbg0HhCqLJzc2P/PJx7+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ST6WihG/5CSdFdTW/H195LaBaDY3LXh1pBAZsVdVz2jL7gHYsbMMFJ5FHcOA2TXfBl07jmueyDsi6CzRufOmszuBYVW7edW6XOeH5Lkof58K6RlH3ZbuT4K4A88vUyetxmc8a8nht36nLx/85688vwRhrosdWeuTLNPbf089AKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Jc6qTn8B; arc=none smtp.client-ip=80.12.242.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Jc6qTn8B"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id TE4GsSV2FfWRDTE4GsBrgL; Mon, 15 Jul 2024 07:16:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1721020569;
	bh=gSwMxZeFjDC2ILoXLC8sLrbsj9KggkWq4IEEp6f4Z9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Jc6qTn8BEBthins0EW/NsGgud48BUZe5oCEoDyLJuUY0iCVUeB+dp3+UWSCkuyPTJ
	 VlWsJ95tQ39dqWTg2Y2wSR7D+FqHuLfcpcjchox7SohNz7N9YHm2vUoKquXbnPqVEt
	 MgKmqWUPpL3r/YKdrq3rbVJ9XPOiEUQt+W6X4wygWShaoQStsU/BQXXh72/AxUHmFX
	 +4bPc8hYfdB1kvU+R3nxLDGbiqiRXyVu1uW+YvegLmU+jEKKaJX0UdPqnswM24a7Df
	 LuZwDRfOGj/kP7BOt8pg5H9PSYExGt8iKMnfwPEoBhxFSHgueS6QNCZeTMxzl+zIcg
	 7C3A+xHyWWF1w==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Mon, 15 Jul 2024 07:16:09 +0200
X-ME-IP: 90.11.132.44
Message-ID: <1ce85d09-4d44-4bd4-96b5-fbe86d23a386@wanadoo.fr>
Date: Mon, 15 Jul 2024 07:16:07 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Use seq_putc() in two functions
To: Steve French <smfrench@gmail.com>
Cc: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>, LKML <linux-kernel@vger.kernel.org>,
 Markus Elfring <Markus.Elfring@web.de>
References: <18310e20-826f-45ab-b69e-dbfe47a1f83f@web.de>
 <CAH2r5mvbk6OrX59dybJvS=ANdzzidsj=rDzRUFrBrjff-upSkg@mail.gmail.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <CAH2r5mvbk6OrX59dybJvS=ANdzzidsj=rDzRUFrBrjff-upSkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 14/07/2024 à 23:31, Steve French a écrit :
> are there other examples of modules where similar changes have been made?
> 

Hi Steve,

Most of the time, this kind of modification is useless because it is 
already done by the compiler, see [1].

CJ

[1]: 
https://elixir.bootlin.com/linux/v6.10-rc7/source/include/linux/seq_file.h#L123

> On Sun, Jul 14, 2024 at 3:35 AM Markus Elfring <Markus.Elfring@web.de> wrote:
>>
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Sun, 14 Jul 2024 10:23:49 +0200
>>
>> Single characters should be put into a sequence.
>> Thus use the corresponding function “seq_putc”.
>>
>> This issue was transformed by using the Coccinelle software.
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>   fs/smb/client/cifs_swn.c | 2 +-
>>   fs/smb/client/cifsfs.c   | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
>> index 7233c6a7e6d7..68998c6ba7a2 100644
>> --- a/fs/smb/client/cifs_swn.c
>> +++ b/fs/smb/client/cifs_swn.c
>> @@ -655,7 +655,7 @@ void cifs_swn_dump(struct seq_file *m)
>>                  seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
>>          }
>>          mutex_unlock(&cifs_swnreg_idr_mutex);
>> -       seq_puts(m, "\n");
>> +       seq_putc(m, '\n');
>>   }
>>
>>   void cifs_swn_check(void)
>> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
>> index 6397fdefd876..ce5cb72bb81f 100644
>> --- a/fs/smb/client/cifsfs.c
>> +++ b/fs/smb/client/cifsfs.c
>> @@ -491,7 +491,7 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
>>          }
>>
>>          if (ses->sign)
>> -               seq_puts(s, "i");
>> +               seq_putc(s, 'i');
>>
>>          if (ses->sectype == Kerberos)
>>                  seq_printf(s, ",cruid=%u",
>> --
>> 2.45.2
>>
>>
> 
> 

