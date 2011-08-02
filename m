From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs
Date: Tue, 2 Aug 2011 16:49:49 -0500
Message-ID: <CAH2r5mu9POJmnXPQSq9cnXJU05oW0bn71+Y3Oo0YPB_uhz1cKQ@mail.gmail.com>
References: <CAPwCz79UntBiAs4X+XSj62xvkpK0CW6cqQqhyCU97r4u5SmJ_g@mail.gmail.com>
	<20110802064455.0777c0fd@corrin.poochiereds.net>
	<20110802120008.3e19d193@tlielax.poochiereds.net>
	<CAH2r5mvTtsDVaYWYswo+CgFRRZJ-+hWTca-3V9vZP7wh0ezfyw@mail.gmail.com>
	<20110802174337.70a4ff15@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Seiffert <kaffeemonster-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110802174337.70a4ff15-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

your explanation makes sense.  will revert the commit unless anyone obj=
ects.

On Tue, Aug 2, 2011 at 4:43 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2 Aug 2011 11:03:28 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> your patch does look right.
>>
>
> Sigh...as is often the case, things are not quite so simple...
>
> I did some auditing of how server->maxBuf is used in the cifs code an=
d
> found it to be very confused. The reason it basically works, I think =
is
> because on NEGOTIATE, the client does this:
>
> =A0 =A0 =A0 server->maxBuf =3D min(le32_to_cpu(pSMBr->MaxBufferSize),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u32) CIFSMaxBufSize + =
MAX_CIFS_HDR_SIZE);
>
> So using maxBuf and CIFSMaxBufSize interchangeably like the code does
> is basically OK, even if it is confusing to limit how much the client
> can receive based on how much the server can.
>
> I think that we really need to approach this more comprehensively and
> have a clear delineation between server->maxBuf and CIFSMaxBufSize. I
> don't think it would be wise though to put that into 3.1 at this poin=
t.
>
> I think it would probably be best to just back out commit c4d3396b2 f=
or
> now, and I'll plan to do this as a larger (and hopefully better-teste=
d)
> patchset for 6.2.
>
> Sound ok? Do you need me to send a revert patch?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
