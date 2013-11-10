From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Re: Hung CIFS driver
Date: Sun, 10 Nov 2013 21:29:58 +0900
Message-ID: <527F7C46.4040105@yk.rim.or.jp>
References: <527BAFC6.5010600@yk.rim.or.jp> <20131107110353.6d203196@tlielax.poochiereds.net> <CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA@mail.gmail.com> <527BC9C9.5080502@yk.rim.or.jp> <527D1ABD.3080404@yk.rim.or.jp> <527D2255.1070709@yk.rim.or.jp> <20131109065826.481ff52c@tlielax.poochiereds.net> <527F0E21.603@yk.rim.or.jp> <20131110070412.0c685682@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131110070412.0c685682-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(2013/11/10 21:04), Jeff Layton wrote:
> On Sun, 10 Nov 2013 13:40:01 +0900
> "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org> wrote:
>
>> (2013/11/09 20:58), Jeff Layton wrote:
>>> On Sat, 09 Nov 2013 02:41:41 +0900
>>> "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org> wrote:

> cifsd is a kernel thread, which means that it acts like a process but
> always runs in kernel mode. It'll have a name like "[cifsd]" in ps. You
> can get its stack in exactly the same way as any other process
> (/proc/<pid>/stack).

Thank you.
I found it in my ps output.
I will investigate more.
My previous post was before I read you latest info.

Thank again for your tips.

>>> What kernel version is this too, btw?
>>
>> uname -r
>> 3.10-3-amd64
>>
>> It is 3.10.3 64bit.
>>
>
> Thanks. It might be worth testing something v3.12-ish, but I sort of
> doubt it'll make much difference.
>

I will try to gather as much data as possible from my hung CIFS state so 
that we can have a better idea of where the problems may lie
before I try upgrading my kernel and test similar operations.
(Also, I am not sure if I can replace the kernel as easily as we could 
do before. It seems some userland daemeon may be tied to kernel versions 
rather in complicated manner these days.)

Thank you again for your attention.
