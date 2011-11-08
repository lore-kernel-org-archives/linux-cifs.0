From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: Simplify setlk error handling for mandatory locking
Date: Tue, 8 Nov 2011 23:07:19 +0400
Message-ID: <CAKywueSrY-u+db-F=ZaaMWiHiZaVhk8QpYjh3YEcLAiPTF0Sxw@mail.gmail.com>
References: <1319894279-7723-1-git-send-email-piastry@etersoft.ru>
	<1319894279-7723-2-git-send-email-piastry@etersoft.ru>
	<1320777775.1690.41.camel@sprabhu.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320777775.1690.41.camel-yuq4rhG59MBosH8Q1Ye95IGKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/11/8 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Pavel,
>
> I may have found a bug in this patch. I've commented inline.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add_if(cinode, lock, wait=
_flag);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (!rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc <=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>
> The return values for cifs_lock_add_if could be
> 0 - If no locks exist and we can cache byte range locks
> 1 - If lock doesn't exist and we do not cache byte range locks.
> < 0 in case of an error
>
> In case of an error, ie. return value < 0, shouldn't we just return r=
c
> and skip the call to posix_lock_file_wait below?
>
> This should be
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>

You may be right - I was thinking about it and decided not to bring
any new behavior with my lock patchset. So, this
patch revert this change (that was previously made by my lock patchset)=
=2E

>
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBLock(xid, tcon, netfid, cu=
rrent->tgid, length,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock=
->fl_start, 0, 1, type, wait_flag, 0);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* For Windows locks we mu=
st store them. */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_lock_add(cinod=
e, length, flock->fl_start,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0type, netfid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

I do the similar thing here. I agree with you that this may be not what=
 we want.

>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_lock_add(cinode, lock);
>> =A0 =A0 =A0 } else if (unlock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_unlock_range(cfile, flock, x=
id);
>>
>
>
>

--=20
Best regards,
Pavel Shilovsky.
