From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPv6 mount support
Date: Sun, 14 Oct 2012 20:51:02 -0500
Message-ID: <CAH2r5msgsUbfd2wv6-C7kS7O=Ak0RDQqD=JHvMWMoOcjFy2uJA@mail.gmail.com>
References: <CAFB9KM2GbrVzE+UEatrV5-QH_iT_Vu4Z0=o3GmezEJo_uKsyWw@mail.gmail.com>
	<CAFB9KM2kFUO39TCmh5rHh8Y8yCoU=8hpw=ahnM_teCLkfTXsRg@mail.gmail.com>
	<20121012132203.1c39533d@corrin.poochiereds.net>
	<CAFB9KM0K-L_E+zppOawzib88NfxryH75VBzg74Wtge8euGHFmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0K-L_E+zppOawzib88NfxryH75VBzg74Wtge8euGHFmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes - we have to deal with colons in path names but presumably not (or
very rarely) in server or share name.  Alternate Data Streams on the
other hand will always have a colon in them - and distinguishing them
is an interesting issue.

On Sun, Oct 14, 2012 at 8:47 PM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Oct 12, 2012 at 1:22 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>> What if some component of the pathname has a ':' in it? For instance:
>>
>>     <ip6 address>:/share/foo:bar/baz/
>>
>> Personally, I'd rather see us deprecate the "nfs syntax". I don't see
>> that that provides us any value. We've never documented that it was
>> supported, so maybe a patch to warn for a couple of releases when
>> someone uses it and then rip it out?
>>
>> --
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
> If the pathname has a ':' in it, I'd want to yell at someone.  What
> kind of sick person does that? :)
> Honestly, I can think of a scenario where this kind of pathname is
> somewhat likely; an iSCSI initiator exporting a target using its iSCSI
> pathname which usually contain a few ':'s.  I'm sure that's not
> common, but surely not unused.
>
> I'll spin a patch Tuesday (I'm traveling Monday) and if anyone
> disagrees with this behavior they can NAK it.
>
> --
> Peace and Blessings,
> -Scott.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
