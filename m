From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Mon, 20 Jun 2011 11:13:22 -0500
Message-ID: <BANLkTinfETnDdcBFkQNq8pLZPQOGsVRuGA@mail.gmail.com>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
	<20110609124043.GA9621@infradead.org>
	<BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
	<20110611094314.GA6217@infradead.org>
	<20110611111253.GD11521@ZenIV.linux.org.uk>
	<BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
	<20110617035421.GO11521@ZenIV.linux.org.uk>
	<20110617140833.GA9563@ZenIV.linux.org.uk>
	<BANLkTi=mH-9F9N4Gz8JJqL==Hm5p8Y1_tQ@mail.gmail.com>
	<20110620085943.6371af1b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110620085943.6371af1b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Would the plan be for Al to merge these out of his tree?

On Mon, Jun 20, 2011 at 7:59 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 20 Jun 2011 16:54:48 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/6/17 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
>> > On Fri, Jun 17, 2011 at 04:54:21AM +0100, Al Viro wrote:
>> >
>> >> See #untested in vfs-2.6.git; I *hope* I've got all the leaks in =
current
>> >> mainline plugged and all sget() races ought to be taken care of. =
=A0And
>> >> yes, the branch name matches the reality - this sucker is complet=
ely
>> >> untested. =A0Have fun... =A0Commit message is atrocious, of cours=
e - I'm too
>> >> tired to even try writing a coherent patch description at the mom=
ent and
>> >> I'll probably need to split it into several patches anyway. =A0To=
morrow...
>> >
>> > Updated, split up, pushed into #untested. =A0Enjoy...
>> >
>>
>> Today I tried this branch and it was ok.
>>
>> Steve, Jeff, what do you think?
>>
>
> I did some light testing on it over the weekend and it looks good to =
me
> as well. Nice cleanup, Al.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
