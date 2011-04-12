From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: shrinking set of cifs fixes to merge for 2.6.39 to small set
Date: Tue, 12 Apr 2011 07:30:14 -0500
Message-ID: <BANLkTin627FFHH_mt1Lu7TMVMAb5y-DKgg@mail.gmail.com>
References: <BANLkTi=72h+nv9BfB+1e69tW4Hb_u5U_TA@mail.gmail.com>
	<20110412075144.53180566@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110412075144.53180566-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 12, 2011 at 6:51 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 11 Apr 2011 20:33:42 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Since it is already past the merge window (was waiting to discuss so=
me
>> fixes with others at the fs summit last week before merge), =A0I shr=
unk
>> the list of cifs patches waiting for merge (in cifs-2.6.git) to a mu=
ch
>> smaller set of more critical ones. See below. (I moved the others
>> temporarily to a for-2.6.40 branch in cifs-2.6.git). =A0We (Jeff,
>> Shirish, I etc.) need to build/test more with this set before sendin=
g
>> though.
>>
>> Jeff Layton (8):
>> =A0 =A0 =A0 cifs: check for private_data before trying to put it
>> =A0 =A0 =A0 cifs: replace /proc/fs/cifs/Experimental with a module p=
arm
>
> =A0 =A0 =A0 =A0I think we should also put in the patch that adds the
> =A0 =A0 =A0 =A0page_mkwrite handler.

I agree but it had more merge conflicts.

>
> Other than that, this looks like a reasonable set. I'll plan to build
> it later today and give it some testing.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
