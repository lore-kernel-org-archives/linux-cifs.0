From: Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org>
Subject: Re: Linux CIFS corruption bug in kernel 3.0.4 and 3.1
Date: Tue, 1 Nov 2011 13:04:26 -0500
Message-ID: <CAGc=Oh8jEK6GzadojdhRJOTzYLyGRo43g1sMv6wRB3TNsBK7tA@mail.gmail.com>
References: <CAGc=Oh8GGXw6itfAo5-x6CpbwtK1TQeZrerx_zPrC4qABR2m6w@mail.gmail.com>
 <20111101133704.3c7335fb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111101133704.3c7335fb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks for the reply, Jeff.  I've filed a bug with the Samba tracker
as you suggested:  https://bugzilla.samba.org/show_bug.cgi?id=3D8559

The program I'm using to write the output files is a bioinformatics
tool that I've developed as part of my research.  Our research group
plans to release it as an open source tool soon, but currently it's
hosted in a private git repository.  So at the moment it may be
difficult to release for testing.

On Tue, Nov 1, 2011 at 12:37 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 1 Nov 2011 10:09:26 -0500
> Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org> wrote:
>
>> Hello,
>>
>> I've recently noticed a corruption bug in the Linux kernel CIFS clie=
nt
>> that ships with Ubuntu 11.10 (kernel 3.0, based on upstream 3.0.4).
>> I've filed a bug report with the details on Launchpad
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/879228
>>
>> As suggested in the Launchpad bug comments, I installed a custom
>> kernel based on the upstream 3.1, but after testing the bug is still
>> present. =C2=A0It was then suggested that I file a bug report with t=
he
>> upstream subsystem maintainer.
>>
>> Let me know if I can provide any further information, or if I should
>> report this issue somewhere else.
>>
>
> This is the right place to report it, but as we're not all ubuntu use=
rs
> it would be helpful for you to outline the problem in your mail to th=
e
> list.
>
> Looking over the launchpad report, it looks like this is something
> you're able to reproduce at will. Is it possible to share that
> reproducer? That would help us to be able to track down the problem a=
nd
> verify that it's fixed once we understand it.
>
> What may be best is to open a bug at bugzilla.samba.org so we have a
> place to track info relating to this. If you do that, please cc me on
> the bug and I'll plan to take a look.
>
> Thanks,
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
