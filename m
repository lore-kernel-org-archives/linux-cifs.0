From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Add =?UTF-8?Q?O=5FDENY*=20flags=20to=20fcntl=20an?=
 =?UTF-8?Q?d=20cifs?=
Date: Sat, 08 Dec 2012 00:43:14 +0400
Message-ID: <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
 <20121207161602.GA17710@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org>,
	<linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121207161602.GA17710-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Christoph Hellwig =D0=BF=D0=B8=D1=81=D0=B0=D0=BB 07.12.2012 20:16:
> On Thu, Dec 06, 2012 at 10:26:28PM +0400, Pavel Shilovsky wrote:
>> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags -=
=20
>> this change can benefit cifs and nfs modules. While this change is o=
k=20
>> for network filesystems, itsn't not targeted for local filesystems d=
ue=20
>> security problems (e.g. when a user process can deny root to delete =
a=20
>> file).
>>
>> Share flags are used by Windows applications and WINE have to deal=20
>> with them too. While WINE can process open share flags itself on loc=
al=20
>> filesystems, it can't do it if a file stored on a network share and =
is=20
>> used by several clients. This patchset makes it possible for=20
>> CIFS/SMB2.0/SMB3.0.
>
> I don't think introducing user visible flags that are only supported=20
> on
> a single network filesystem is a good idea.

It can bring benefits for both CIFS and NFS filesystems - so, at least=20
two ones.

>
> I'm not even sure adding these flags does make a lot of sense, but
> assuming we'd actually want this (and I'd like some more detailed
> explanation) I think we'd at least need to make sure that:
>
>  a) opening files with the new modes gives a proper error message if=20
> not
>     supported

It makes us add such checks for all other filesystems, if I understand=20
right, - not a problem, I think.

>  b) there needs to be local support for them as well
>  c) we need to think really hard when they should be supported, and=20
> need
>     a good rational for it.  I can't see how we could do it
>     unconditionally for all users as that would introduce easy denial
>     of services attacks the way I understand the semantics (correct=20
> me
>     if I'm wrong).  So a mount option like you currently do probably=20
> is
>     the least bad even if don't fell overly happy about that version.
>
> What is the reason your special wine use case can't simply use a
> userspace cifs client?  Given that wine uses windows filesystem
> semantics and cifs does as well tunnelling it through a Posix-like=20
> API
> inbetween is never going to be perfect.

Ideally we should not make any difference between underlying=20
filesystems in Wine: an application requests an open of the file and we=
=20
issue this open with flags it passed. Since Wineserver can process shar=
e=20
flags locally itself (for one linux user), we only need to add this=20
support for CIFS (that is actively used by Wine applications because of=
=20
it's Windows nature). Bringing these flags for local filesystems can=20
benefit Wine too: it will help in cases when Wine applications of=20
different users on the same machine use the same file and can make all=20
those things easier, of course.

The problem is the possibility of denial-of-service attacks here. We=20
can try to prevent them by:
1) specifying an extra security bit on the file that indicates that=20
share flags are accepted (like we have for mandatory locks now) and=20
setting it for neccessary files only, or
2) adding a special mount option (but it it probably makes sense if we=20
decided to add this support for CIFS and NFS only).

--
Best regards,
Pavel Shilovsky.


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
