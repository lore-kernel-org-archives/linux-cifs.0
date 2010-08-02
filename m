From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Mon, 02 Aug 2010 21:03:56 +0530
Message-ID: <4C56E564.3020508@suse.de>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>	<4C56DBDD.4070501@suse.de> <AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/02/2010 08:38 PM, Jon Bramley wrote:
> 
>> The samba version you are using seem to be quite old.. Does better POSIX
>> support/conformance sound like a good enough reason..?
> 
> I doubt it. The problem I have is that it is working fine for Ubuntu
> users (which is the vast majority) so they will not want to risk
> breaking things. Of course that means I cannot currently update my
> kernel (which they are less concerned about).

If upgrading is not feasible, could you try patching Samba server with
this patch (relatively very less risk):
    http://www.mail-archive.com/samba-cvs-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org/msg55843.html

I think that should help resolving the bug with posix opens against
older server.

>>> strange thing, is that some of my colleagues run Ubuntu 10.04, which
>>> uses the 2.6.32 kernel, and they can use the share without problem.
> 
>> What is the server version in this case?
> 
> Exactly the same server that I'm connecting to (3.0.28a).
> 

Strange.. Any idea whether the Ubuntu kernel is the released 2.6.32
kernel or any -rc version of 2.6.32?


Thanks,


-- 
Suresh Jayaraman
