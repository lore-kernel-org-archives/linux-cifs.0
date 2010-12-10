From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] cifs and Netapp DFS-shares problems
Date: Fri, 10 Dec 2010 09:17:08 -0600
Message-ID: <AANLkTinvV_0t7n_Vc1sm5mh-JLha0_vKtR3pxUk892OC@mail.gmail.com>
References: <1291855039.11237.49.camel@kramer>
	<1291976746.8971.24.camel@kramer>
	<20101210063449.5ab06c5f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: lists-dLPT46B32WUjnolme5KbmQ@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101210063449.5ab06c5f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 5:34 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 10 Dec 2010 11:25:46 +0100
> Marcus <lists-dLPT46B32WUjnolme5KbmQ@public.gmane.org> wrote:
>> Any ideas? Seems to be an error of the NetApp Fileserver acting not RFC
>> conform.
>>
>> Is this the right list to discuss or should I post on linux-cifs-client
>> list?
>>
> (cc'ing linux-cifs mailing list)
>
> Probably because the ls is hung and is holding references to the mount...
>
> I've successfully tested against netapp's CIFS implementation in the
> past, but there are significant bugs in it. The errors you're seeing
> look like an alignment problem of some sort -- i.e. the server is
> sending packets that have incorrect length fields in them. This isn't
> the first such problem I've seen with OnTap.
>
> You're welcome to open a bug at bugzilla.samba.org, cc me, and I'll
> take a look when I have time. Gathering wire captures during one of
> these events and attaching them to the bug would help to track down the
> problem. It's likely to be Netapp's bug however...

We have worked around a few similar sounding server bugs in the past,
but have to be careful that we don't introduce potential
buffer overruns or security problems (the Linux cifs client parses
frames more carefully than some other clients to reduce
the chance of going beyond the end of frames).

-- 
Thanks,

Steve
