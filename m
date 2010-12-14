From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/13] cifs: handle cancelled requests better
Date: Tue, 14 Dec 2010 16:22:01 -0600
Message-ID: <AANLkTimFQSeMk8ZCbAud+RdU5WQcGrDnKz+dAC_UFzNM@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-9-git-send-email-jlayton@redhat.com>
	<AANLkTinU19tUL-6uwYN64dfE1Rsa+uSiC2fkeBHV+XOS@mail.gmail.com>
	<20101214065935.50a0bdf0@tlielax.poochiereds.net>
	<AANLkTi=mFXsJd55CzebrKO24ALnwmduBnFLyYZCRVdP4@mail.gmail.com>
	<AANLkTinSC4WKa4ZBeEOWkSQmy6wBhU8=cO09EKy2Qda2@mail.gmail.com>
	<20101214164407.377304e0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214164407.377304e0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 14, 2010 at 3:44 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 14 Dec 2010 15:33:48 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Why wouldn't we issue SMB NTCancel on these? =A0That way we only hav=
e to
>> wait until the timeout for the NTCancel (at worst) and can't leak mi=
dq
>> entries.
>>
>
> I suppose we could, but...
>
> a) windows doesn't do it

Windows does issue cancel requests ... even if not for exactly the same=
 case

--=20
Thanks,

Steve
