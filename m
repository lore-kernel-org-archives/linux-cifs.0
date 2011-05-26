From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v4 PATCH 4/4] CIFS: Migrate to shared superblock model
Date: Thu, 26 May 2011 20:21:46 +0400
Message-ID: <BANLkTi==1neTE9=Y1Zm+ngQ978anSM6ExA@mail.gmail.com>
References: <1306389721-28550-1-git-send-email-piastry@etersoft.ru>
	<1306389721-28550-4-git-send-email-piastry@etersoft.ru>
	<20110526112001.6602ce52@corrin.poochiereds.net>
	<BANLkTim+a8swvWytQwUQqE+1s+wVnX3gRg@mail.gmail.com>
	<BANLkTi==YrNa1quPtEFW0T3_yxCrCq_+sA@mail.gmail.com>
	<BANLkTikkbBO6iZsf7ckUFFiMdUbuLi7HNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikkbBO6iZsf7ckUFFiMdUbuLi7HNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> 2011/5/26 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
>> If I understand right, Jeff suggested to change wsize logic to: "less
>> or equal that specified one". In this case we can share any sb that
>> match this criteria. So, in this case it should be "if (new->wsize &&
>> new->wsize <= old->wsize) return 0;"
>
> Sorry - new->wsize >= old->wsize

Sorry again - I confused myself :)

The code should be:
if (new->wsize && new->wsize < old->wsize)
  return 0; /* don't match */

-- 
Best regards,
Pavel Shilovsky.
