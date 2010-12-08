From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP authentication
Date: Wed, 08 Dec 2010 22:07:09 +0100
Message-ID: <4CFFF37D.5010004@exx.nl>
References: <1291822865-26472-1-git-send-email-shirishpargaonkar@gmail.com>	<20101208110608.607a23e2@tlielax.poochiereds.net>	<AANLkTi=WVaCDRHf5=DgnZr7crJByhH5r6F6S+_PVGY0F@mail.gmail.com>	<AANLkTinehfVNbrC2gNnDEi5OHDtgjYYimUqYO=+y4Dy6@mail.gmail.com>	<4CFFCB61.4090807@exx.nl> <AANLkTikU1OhcT8FmyrOZfrLtgK-8NKnRnFNnczFvz2C_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikU1OhcT8FmyrOZfrLtgK-8NKnRnFNnczFvz2C_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Op 8-12-2010 19:53, Shirish Pargaonkar schreef:
>> Is it your intent to leave out this hunk?
> 
> Yes, it does not matter whether that flag bit exists or not in ntlmssp
> auth packet (type 3).

FWIW, I just verified this on my side. It still works without this hunk.

Regards,
Robbert
