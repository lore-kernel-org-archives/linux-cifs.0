From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NTLMSSP unix query info problem
Date: Wed, 31 Jul 2013 09:41:15 +0400
Message-ID: <CAKywueRh9mZFqJ7Jf7N2ZjHRYWTD-RMuw1w9qguS_D6YKx-pTw@mail.gmail.com>
References: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ@mail.gmail.com>
	<20130730063236.406ade84@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130730063236.406ade84-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/7/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Mon, 29 Jul 2013 20:41:53 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> For sec=ntlmssp unix query path info call returns OK for a
>> non-existing uppercase filename if a lowercase one exists. E.g.: stat
>> ABC return info about 'abc' file.
>>
>> But for sec=ntlmv2 or sec=ntlm this call fails with
>> STATUS_OBJECT_NAME_NOT_FOUND error code.
>>
>> This difference was found on upgrade from v3.7 to v3.8 kernel due to
>> changing the default security mechanism to NTLMSSP.
>>
>> Any thoughts on this?
>>
>
> Is this a client or server problem?

Looks like a server side at the first glance but not sure.

-- 
Best regards,
Pavel Shilovsky.
