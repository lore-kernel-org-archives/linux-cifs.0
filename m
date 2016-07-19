From: Markus Greger <Markus.Greger-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: CIFS hang
Date: Tue, 19 Jul 2016 11:57:41 +0200
Message-ID: <cfc82cdf-fd22-4e03-d7eb-c1412da843c5@gmx.net>
References: <56C9EF36.7010301@gmx.net> <56CA0ADB.5070303@gmx.net>
 <CADT32eLCELt9gO_6jW5iB+uTZZdCjULa=5BPsOx3OVZTZjDz9g@mail.gmail.com>
 <CAH2r5mu1Gaap826QGg+b-La6Nzz9We_Gb4rKJ3XqNQ4yHrEXUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu1Gaap826QGg+b-La6Nzz9We_Gb4rKJ3XqNQ4yHrEXUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I had to reboot the machine and ever since it has not reoccured although
it had happend a number of times before. Wonder if it might be related
to powerlan for I had to reboot these as well.

Anyway just for completeness sake here are the answers:

Am 22.02.2016 um 05:54 schrieb Steve French:
>
> Also would be useful to know if this fails on more recent kernel
>
I'm using 3.18.25 as this was (at that time) a longterm kernel version.
I've recently upgraded to 3.18.36  (currently one of the longterm
kernels)? A newer kernel (4.6.3) had some graphics issues so it's not
usable for me.

> On Feb 21, 2016 22:37, "Shirish Pargaonkar"
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org <mailto:shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>> wrote:
>
>     There may be some kind of deadlock, that is why soft mount option is
>     not responding,
>     otherwise you would seen something like "host is down"
>     All of the shares show DISCONNECTED in file DebugData.
>     Can you use crash utility and see the stack trace of the ls
>     command that hangs?
>     What if you mounted from just one share/server (1.1.1.22 e.g.), do you
>     see the same problem?
>
I don't have crash installed and am somewhat reluctant as it has quite a
footprint. I assumed the call trace in messages to be a stack trace. Can
I get more useful information by attaching with gdb? What should I be
looking for?

I usually work with both of them. As the hang only occurs after some
time I can try to only mount the second nas when needing it and
unmounting it later. Why do you think it might have an impact?

Thanks a lot for your answers and I'm happy it has vanished at least for
quite some time now.

Regards,

Markus
