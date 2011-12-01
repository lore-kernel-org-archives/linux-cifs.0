From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Wed, 30 Nov 2011 20:07:17 -0600
Message-ID: <CADT32e+JgM82m5fOsxxj5RGa75d-3Sbv+6kU50UDYcvBL7ZDTg@mail.gmail.com>
References: <4ED3017A.9030502@gmail.com>
	<20111128153207.163adbfe@tlielax.poochiereds.net>
	<CADT32eJ2oa--ER7NFf3wCbmRng7e_KL+D1PV8Lf+sk=_RH97bQ@mail.gmail.com>
	<20111129092339.1ae61788@tlielax.poochiereds.net>
	<jb6mp6$8kf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <jb6mp6$8kf$1@dough.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 30, 2011 at 7:54 PM, jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 29/11/11 14:23, Jeff Layton wrote:
>>
>> and 22 is -EINVAL. This machine is running 3.0? What may be best is =
to
>> open a bug at bugzilla.samba.org so we can track this. We may need t=
o
>> see a capture of the traffic between the client and server.
>
> what do I need to do to supply the traffic info?
>
> meanwhile (sorry, not v knowledgable) what can I do by way of using o=
ptions
> to get the mount.cifs to work?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Would be useful if you can capture wireshark traces during
successful attempt with smbclient and failing attempt with cifs client.
