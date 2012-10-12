From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPv6 mount support
Date: Fri, 12 Oct 2012 13:23:41 -0500
Message-ID: <CAH2r5msSdL25ywGNt2-QYCzOOPvqa4n34f2zgne3izzPz=a9Vw@mail.gmail.com>
References: <CAFB9KM2GbrVzE+UEatrV5-QH_iT_Vu4Z0=o3GmezEJo_uKsyWw@mail.gmail.com>
	<CAFB9KM2kFUO39TCmh5rHh8Y8yCoU=8hpw=ahnM_teCLkfTXsRg@mail.gmail.com>
	<20121012132203.1c39533d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121012132203.1c39533d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I saw various people use the NFS syntax for cifs - it probably helps
with portability a little

On Fri, Oct 12, 2012 at 12:22 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 12 Oct 2012 07:41:33 -0400
> Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Oct 12, 2012 at 7:39 AM, Scott Lovenberg
>> <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > In mount.cifs.c's parse_unc(), there's a FIXME to support IPv6 path
>> > parsing.  Is there any reason that simply grabbing the last instance
>> > of the ':' character wouldn't work?  Something like this:
>> > @@ -1342,7 +1342,7 @@ static int parse_unc(const char *unc_name,
>> > struct parsed_mount_info *parsed_info
>> >                  * FIXME: IPv6 addresses?
>> >                  */
>> >                 host = unc_name;
>> > -               share = strchr(host, ':');
>> > +               share = strrchr(host, ':');
>> >                 if (!share) {
>> >                         fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
>> >                         return EX_USAGE;
>> >
>> >
>> > I'm reasonably sure that somebody smarter than myself has already
>> > thought of this, so there must be more to the problem that I'm seeing.
>> > --
>> > Peace and Blessings,
>> > -Scott.
>>
>> *... than I'm seeing.*  (/me needs to proofread _before_ hitting "send").
>>
>
> What if some component of the pathname has a ':' in it? For instance:
>
>     <ip6 address>:/share/foo:bar/baz/
>
> Personally, I'd rather see us deprecate the "nfs syntax". I don't see
> that that provides us any value. We've never documented that it was
> supported, so maybe a patch to warn for a couple of releases when
> someone uses it and then rip it out?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
