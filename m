From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: extend the buffer length enought for sprintf() using
Date: Wed, 17 Jul 2013 14:27:23 -0400
Message-ID: <CAFB9KM0rEDyE6hb8t-gDLTDKq9kaRr4Bhs7SLBEZTnyH5u5U-A@mail.gmail.com>
References: <51E5E9DA.8020603@asianux.com>
	<CAFB9KM2nJEt-O+o=4bkxNMJ2Fr0TfjkpRF=7B98=Lp9zFu8_og@mail.gmail.com>
	<CAH2r5msQEbQWpE+wqEoLY_++=ywDVoAg_vmWB3kJG8=ECHC3Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msQEbQWpE+wqEoLY_++=ywDVoAg_vmWB3kJG8=ECHC3Pg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jul 16, 2013 at 10:06 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> If this is correct for the domain size, MAX_DOMAIN_SIZE in the
>> cifs-utils mount helper (mount.cifs.c) has to be changed.  It is
>> currently 64 + null terminator.  I can open a bug and patch it if this
>> is correct.
>>
>> CC'ing Jeff Layton since he maintains the cifs-utils package.
>>
>> --
>> Peace and Blessings,
>> -Scott.
>
> http://support.microsoft.com/kb/909264 indicates that (at least for
> Microsoft) domain names can be considerably longer than 64 bytes, so
> this patch seems reasonable.  Merged into cifs-2.6.git - if anyone
> objects or wants to add ack/reviewed let me know.
>
>
> "The maximum length of ... the fully qualified domain name (FQDN) is
> 63 octets per label and 255 bytes per FQDN. This maximum includes 254
> bytes for the FQDN and one byte for the ending dot."
>
>
> --
> Thanks,
>
> Steve

Thanks, Steve.  I'll patch this tonight.


--
Peace and Blessings,
-Scott.
