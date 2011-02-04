From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Possible slab memory corruption while updating
 extended stats (repost)
Date: Fri, 4 Feb 2011 14:21:04 -0600
Message-ID: <AANLkTinSsV9wk3Sy_XOnxzkQJPPBaWL6FaWi1yQ9Nc=f@mail.gmail.com>
References: <1296765078-25531-1-git-send-email-shirishpargaonkar@gmail.com>
	<AANLkTi=_HAQfH2oGvBrd2gBLa05EFndnpFGOny0NGCgW@mail.gmail.com>
	<20110204073925.3a21a048@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110204073925.3a21a048-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 4, 2011 at 6:39 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 3 Feb 2011 21:18:18 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Good catch.
>>
>> But doesn't this belong in stable?
>>
>
> No, it's a recent regression from the call timeout patches.

Yes, you are right.  It shows up in rc1, but not 2.6.37


-- 
Thanks,

Steve
