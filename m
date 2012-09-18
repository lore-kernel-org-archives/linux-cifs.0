From: Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs.mount: mapchars + utf8 = loop
Date: Tue, 18 Sep 2012 19:15:27 +0200
Message-ID: <CAJt13SW78BqYtkMnsG0WVFEioPbitsSmzTbyP6jp+YULAdW1Eg@mail.gmail.com>
References: <CAJt13SX0yMGEQtmw2KpCG3kwiOZPB9s1961Y1Lc6VT36=3pRCw@mail.gmail.com>
	<CAJt13SV_DS1XQL1dar5Xpy-r-BTuZ84FgDsAE_4ggXGZoWVUwA@mail.gmail.com>
	<20120917173919.54319010@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120917173919.54319010-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It works for me.
I could use both utf8 characters and special characters like
"interrogation marks", "colon" or "pipe" for example.
Do you think the patch could be integrated in new kernel.org kernel ?.

Nicolas Lefebvre

2012/9/18 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Mon, 17 Sep 2012 15:31:38 +0200
> Nicolas Lefebvre <nico.lefebvre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Hello,
>>
>> I'm trying to mount a smb share with both "mapchars" and
>> "iocharset=utf8" options and it seems to be bogus.
>> I must used mapchars option because some folder names contain
>> non-ascii characters and I must used iocharset=utf8 because some file
>> names contain question marks.
>>
>> I have searched on the internet and found a very simple patch for a
>> 2.6.32 kernel (https://bugzilla.samba.org/show_bug.cgi?id=6767)
>>
>> --- orig/linux-2.6.32/fs/cifs/misc.c 2009-12-03 04:51:21.000000000 +0100
>> +++ linux-2.6.32/fs/cifs/misc.c 2011-10-09 22:25:10.767951322 +0200
>> @@ -713,7 +713,7 @@
>>      }
>>
>>  ctoUCS_out:
>> - return i;
>> + return j;
>>  }
>>
>> But I'm on Ubuntu 12.04 with a 3.2.0-31 kernel and there is too much
>> differences for me between the two misc.c files and I'm not able to
>> report the patch in my kernel.
>>
>> Did someone have an idea ?
>>
>
> Looks like Baldvin never sent that patch to the list. This should be a
> forward port of it. Does it work for you?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
