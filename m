From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cifs: update README about the kernel module parameters
Date: Wed, 12 Oct 2011 20:20:54 -0500
Message-ID: <CAH2r5mvmRitrj3QJnZq15QYZ2JwCB3Y48sRnyXQxdk9e4sDSig@mail.gmail.com>
References: <4E953209.2020602@suse.com>
	<20111012202801.63519ad9@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111012202801.63519ad9-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 12, 2011 at 7:28 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 12 Oct 2011 11:52:01 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
>
>> +CIFS kernel module parameters
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>> +These module parameters can be specified or modified either during =
the time of
>> +module loading or during the runtime by using the interface
>> + =A0 =A0 /proc/module/cifs/parameters/<param>
>> +
>> +i.e. echo "value" > /proc/module/cifs/parameters/<param>
>> +
>
> Doh! As Steve pointed out -- the above path is wrong. That should
> be /sys/module/cifs/parameters/...
>
> I think Steve said he'd just do a simple patch to fix that though...

Yes - fixed now.

--=20
Thanks,

Steve
