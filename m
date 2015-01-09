From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: DFS referrals support ?
Date: Fri, 9 Jan 2015 13:51:48 -0600
Message-ID: <CAH2r5mtOtmhEMgGOq22fy-RQa58c+u=JWwfGOvXh83MyZwb4og@mail.gmail.com>
References: <548AD6D5.7080901@nospam.yrnm.net> <dda8f4838ed40871acc3092c5440d396.squirrel@mail.balsover.com>
 <548C086C.8050102@nospam.yrnm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Franck Eyraud <franck+linux-cifs-ici3nDnK79kZQKRGMNo+Zg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <548C086C.8050102-ici3nDnK79kZQKRGMNo+Zg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Dec 13, 2014 at 3:35 AM, Franck Eyraud
<franck+linux-cifs-ici3nDnK79kZQKRGMNo+Zg@public.gmane.org> wrote:
> Hi Bob,
>
> Thank you for your answer.
> Yes, upgrading the kernel can be an option for us, I just wanted to be sure
> it was worth trying.
>
> I could not find back the bug you mention, to understand how old it is and
> if it is supposed to be inserted in the kernels we use.
> However, I'm not sure this connection issue between two servers is our
> problem since :
> 1/ we get the problem even when a DFS links goes to the same IP as the
> mounted share
> 2/ we do not get problem when fetching a DFS link to the top level of a
> share which is on a different IP (i.e mounting another filer works well)
>
> I'll try anyway to upgrade the kernel and test, since you confirmed that
> this is supposed to work.

What did you find out about behavior of a more current kernel?

(given that your kernel was more than 5 years old, there is
a good chance that the behavior has improved in more
recent kernels)




-- 
Thanks,

Steve
