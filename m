From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux CIFS corruption bug in kernel 3.0.4 and 3.1
Date: Tue, 1 Nov 2011 13:21:47 -0500
Message-ID: <CAH2r5mtwmCrNweqXZJ+pi3Ln5ikGHtnd7VbyfE8ZOTnbwBy1ng@mail.gmail.com>
References: <CAGc=Oh8GGXw6itfAo5-x6CpbwtK1TQeZrerx_zPrC4qABR2m6w@mail.gmail.com>
	<20111101133704.3c7335fb@tlielax.poochiereds.net>
	<CAGc=Oh8jEK6GzadojdhRJOTzYLyGRo43g1sMv6wRB3TNsBK7tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGc=Oh8jEK6GzadojdhRJOTzYLyGRo43g1sMv6wRB3TNsBK7tA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Also remember that, even without a test case, we can often debug
from a combination of wire trace (see
http://wiki.samba.org/index.php/Capture_Packets)
and dmesg output (from enabling cifs debugging e.g.

The dmesg or syslog (/var/log/messages) will show certain serious
errors, but enable additional cifs debugging flags to increase the
debug output. You can do this by doing:

   #dmesg -c /* this clears kernel ring buffer */
   #echo 3 > /proc/fs/cifs/cifsFYI /* Enables additional debugging */
   <do the operation>
   #dmesg > cifs-debug.txt
   Attach cifs-debug.txt


On Tue, Nov 1, 2011 at 1:04 PM, Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org> wrote:
> Thanks for the reply, Jeff. =A0I've filed a bug with the Samba tracke=
r
> as you suggested: =A0https://bugzilla.samba.org/show_bug.cgi?id=3D855=
9
>
> The program I'm using to write the output files is a bioinformatics
> tool that I've developed as part of my research. =A0Our research grou=
p
> plans to release it as an open source tool soon, but currently it's
> hosted in a private git repository. =A0So at the moment it may be
> difficult to release for testing.
>
> On Tue, Nov 1, 2011 at 12:37 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>> On Tue, 1 Nov 2011 10:09:26 -0500
>> Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org> wrote:
>>
>>> Hello,
>>>
>>> I've recently noticed a corruption bug in the Linux kernel CIFS cli=
ent
>>> that ships with Ubuntu 11.10 (kernel 3.0, based on upstream 3.0.4).
>>> I've filed a bug report with the details on Launchpad
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/879228
>>>
>>> As suggested in the Launchpad bug comments, I installed a custom
>>> kernel based on the upstream 3.1, but after testing the bug is stil=
l
>>> present. =A0It was then suggested that I file a bug report with the
>>> upstream subsystem maintainer.
>>>
>>> Let me know if I can provide any further information, or if I shoul=
d
>>> report this issue somewhere else.
>>>
>>
>> This is the right place to report it, but as we're not all ubuntu us=
ers
>> it would be helpful for you to outline the problem in your mail to t=
he
>> list.
>>
>> Looking over the launchpad report, it looks like this is something
>> you're able to reproduce at will. Is it possible to share that
>> reproducer? That would help us to be able to track down the problem =
and
>> verify that it's fixed once we understand it.
>>
>> What may be best is to open a bug at bugzilla.samba.org so we have a
>> place to track info relating to this. If you do that, please cc me o=
n
>> the bug and I'll plan to take a look.
>>
>> Thanks,
>> --
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
