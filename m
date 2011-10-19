From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: allow cifs_max_pending to be readable under /sys/module/cifs/parameters
Date: Wed, 19 Oct 2011 16:31:56 -0500
Message-ID: <CAH2r5mtXD05+TkTzPiJ1GtJn8SaYgUWGorBWqBHWCiS+-9OAPw@mail.gmail.com>
References: <1319052676-11587-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mtAwXFETw8AR9Bw=ra0MZ04=SYgPvX_2NC9q0V+ZTyjnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtAwXFETw8AR9Bw=ra0MZ04=SYgPvX_2NC9q0V+ZTyjnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

typo - I meant:

With the proposed cifs.ko fix to honor maxmpx, cifs_max_pending
becomes a limit when the server ...

On Wed, Oct 19, 2011 at 4:31 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>  (as Windows often is) has more than 50
> maxmpxct in its registry. =A0 Does anyone mind if I update the maximu=
m
> to one or two hundred? (after the mpx fix is in)?
>
> On Wed, Oct 19, 2011 at 2:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index b0a2e16..fa67245 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -74,7 +74,7 @@ module_param(cifs_min_small, int, 0);
>> =A0MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. =
Default: 30 "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Ran=
ge: 2 to 256");
>> =A0unsigned int cifs_max_pending =3D CIFS_MAX_REQ;
>> -module_param(cifs_max_pending, int, 0);
>> +module_param(cifs_max_pending, int, 0444);
>> =A0MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to serv=
er. "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
"Default: 50 Range: 2 to 256");
>> =A0unsigned short echo_retries =3D 5;
>> --
>> 1.7.6.4
>>
>>
>
>
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve
