From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: [PATCH] cifs: Support NTLM2 session security during NTLMSSP
 authentication
Date: Thu, 9 Dec 2010 13:56:51 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012091351180.9919@awakenings.cable.ziggo.nl>
References: <1291822865-26472-1-git-send-email-shirishpargaonkar@gmail.com> <20101208110608.607a23e2@tlielax.poochiereds.net> <AANLkTi=WVaCDRHf5=DgnZr7crJByhH5r6F6S+_PVGY0F@mail.gmail.com> <AANLkTinehfVNbrC2gNnDEi5OHDtgjYYimUqYO=+y4Dy6@mail.gmail.com>
 <4CFFCB61.4090807@exx.nl> <AANLkTikU1OhcT8FmyrOZfrLtgK-8NKnRnFNnczFvz2C_@mail.gmail.com> <4CFFF37D.5010004@exx.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFFF37D.5010004-C1IQQP51G3M@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Ahem,

>> Yes, it does not matter whether that flag bit exists or not in ntlmssp
>> auth packet (type 3).
>
> FWIW, I just verified this on my side. It still works without this hunk.

Not sure what I smoked yesterday, but yesterday's conclusion is NOT 
correct.

I actually do need the NTLM2 flag in the AUTH packet as well as the 
NEGOTIATE packet, so I do need the extra hunk of the patch that you left 
out when you submitted it to the list.

Regards,
Robbert
