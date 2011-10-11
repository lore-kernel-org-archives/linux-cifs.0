From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs ignores sysct setting
Date: Tue, 11 Oct 2011 09:47:59 -0500
Message-ID: <CAH2r5mvqk6vjbPObEfqm+UtdLudNCfRnvLxqDmf6i4Y+syX24w@mail.gmail.com>
References: <CAH2r5mtRASfeMGJj+Bq596QmkasroatfhFxxGNsYbh_8kNEj0Q@mail.gmail.com>
	<ff55fbe8-5fca-4bd0-a91c-c63d3082509a@absint.swen.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
To: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ff55fbe8-5fca-4bd0-a91c-c63d3082509a-VJN6hnAnNNsoZRmjwiK4Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 11, 2011 at 9:22 AM, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org> wrote:
>
>
> Met vriendelijke groet,
> Alexander Swen
> ________________________________
>
> From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: "Alexander Swen" <alex-UE4+9DRHXtc@public.gmane.org>
> Cc: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "S=
uresh
> Jayaraman" <sjayaraman-IBi9RG/b67k@public.gmane.org>
> Sent: Tuesday, 11 October, 2011 4:20:17 PM
> Subject: Re: cifs ignores sysct setting
>
> On Tue, Oct 11, 2011 at 9:14 AM, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org> wrote:
>> Hi Steve,
>>
>> thanks for your response.
>>
>> no, we do permanently turn off oplocks due to some performance issue=
s
>> (with
>> some NAS device where our colleagues can't (don't want) configure nf=
s
>> apparently ;-(.
>> we do this on several (>20) servers and across reboots...
>
> Isn't it easier just to turn this (oplocks) off on the server? =A0At
> least with Linux cifs.ko
> you can turn off oplocks at runtime, with some clients it is much har=
der.
>
>
> ahhh. no, we are not the only users on the nas, our clientservers sho=
uld
> just turn off oplocks. it is, we make backups to the nas device and t=
hose
> files grow quite big.

If you are trying to save RAM on the client, and don't want to cache,
and are just using the linux cifs client for backup, you could mount
with "forcedirectio" (which turns off caching a little more easily).


--=20
Thanks,

Steve
