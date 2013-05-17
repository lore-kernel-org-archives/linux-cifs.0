From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Setting up a testing environment like discussed on SambaXP
Date: Fri, 17 May 2013 08:41:52 -0500
Message-ID: <CAH2r5mvyKZAFfEq8Y1=BupO9MiDiWH3vg+aGPhULQ9oFboZRnw@mail.gmail.com>
References: <51962C30.8090201@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51962C30.8090201-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This would be a HUGE help.

Having a simple test script that executes 4 times (mount, small test
against mount, unmount), once for each of the four protocols is great.
 Whether it is run by etting up triggers so it automatically runs when
the cifs tree changes, or running it periodically (once a week or once
a day) - either way would be a invaluable.  Jeff and I are very
familiar with additional fs testcases that could be added over time,
but getting the basics of image rebuild and restart out of the way
would enable gradual improvement of the test coverage of the client
client (and samba server indirectly) and be VERY helpful

On Fri, May 17, 2013 at 8:10 AM, Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org> wrote:
> Hi
>
> To make sure there are no functionality regressions, we discussed
> setting up an automatic test setup. It could at first run all kind of
> functionality tests against against a Samba server for the 4 protocols
> we support: CIFS, SMB 2.0.2, SMB 2.1 and SMB 3.
>
> Once we have actual scripts to handle the automatic building, rebooting
> and testing of the client it can be hosted on samba.org hardware.
> Therefor I'll try to set up a testing environment soon.
>
> Cheers
>
> Luk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
