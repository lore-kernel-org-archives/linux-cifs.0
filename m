From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Consolidate error handling for cifs_invalidate_mapping
 (try #2)
Date: Mon, 28 Mar 2011 16:22:36 +0400
Message-ID: <AANLkTimWWuxYPHd7-heAdq_iMnN=eiVO8uuz4wT1d9kQ@mail.gmail.com>
References: <1301127285-3573-1-git-send-email-piastry@etersoft.ru>
	<20110327064857.6fc346f0@tlielax.poochiereds.net>
	<AANLkTimOx-P95k-Jvg_ESiYii7bd7RzWYpjxQnkvAf7k@mail.gmail.com>
	<AANLkTi=b7k8eCRK0eT9DwDMkGFDkX0hJjPFVjx4se5=x@mail.gmail.com>
	<AANLkTikX82d36rS99JHyuG6yH0d_qki-Ak0dxuwQ6-x5@mail.gmail.com>
	<4D901AB6.4090504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D901AB6.4090504-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/28 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 03/28/2011 02:12 AM, Steve French wrote:
>>
>> On Sun, Mar 27, 2011 at 2:10 PM, Pavel Shilovsky<piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org=
>
>> =A0wrote:
>>>
>>> 2011/3/27 Steve French<smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>> As for fsycn logic - as I understand this call - it ought to
>>> synchronize data between a cache and storage device. But if we can'=
t
>>> free pages, we don't successfully complete this synchronization - s=
o,
>>> reporting -EBUSY error here doesn't seem wrong to me (may be we sho=
uld
>>> set -EIO error code - according to the man page). If I am mistaken,
>>> please, explain your points.
>>
>> To me synchronizing means that all data was written to the
>> server that was dirty at the time of the call.
>
> Yes, I too think that fsync should make sure that pages that were dir=
ty
> (when fsync started) should be synched to stable storage and need not=
 worry
> about the pages that were redirtied after the fsync call.
>
>
> --
> Suresh Jayaraman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Ok, I will respin this patch.

--=20
Best regards,
Pavel Shilovsky.
