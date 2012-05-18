From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list (try #2)
Date: Fri, 18 May 2012 11:14:38 -0500
Message-ID: <CADT32eLFpHkerpiW_WGv_DqetOn5SuFBDo+WVe0dhziXf-3r1g@mail.gmail.com>
References: <1337188413-28947-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120516135548.2acb454a@tlielax.poochiereds.net>
	<CADT32eJ1VuL52DLnc=SuNjiSEzwMHXOtM4VJXfYZrmTSUoDQYA@mail.gmail.com>
	<20120518082956.44ec8785@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120518082956.44ec8785-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 18, 2012 at 7:29 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 16 May 2012 15:41:24 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> [...]
>
>> >
>> > Hmm...now that I think about this, do we really want to move this =
to
>> > the end of the list here? If this turns out to be reclaimable we w=
ill
>> > have moved it to the end of the list, and then it will be the *las=
t*
>> > one found on the next pass into this function.
>>
>> yes, but we need to keep this element on the list while reclaimation
>> is going on. =A0If we keep where it is and reclaim fails, we may oop=
s
>> for we are not sure if the next element is still intact (that is the=
 reason
>> of the oops in the first place) since we will continue down the list
>> looking for another file handle.
>>
>
> No, because once you drop the spinlock to do the reclaim you have to
> start walking the list from the head again.
>
>> >
>> >> =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>> >> +
>> >> + =A0 =A0 if (inv_file) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_reopen_file(inv_file, false=
);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return inv_file;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_li=
st_lock);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(inv_fi=
le);
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Here's where I have to rescind my A=
ck -- sorry :(
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This is going to deadlock -- the fi=
rst thing
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that cifsFileInfo_put() does is loc=
k the
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file_list_lock.
>>
>> Agree. =A0Thanks. I think reversing the order of the calls
>> spin_lock() and cifsFileInfo_put(), should take care of that.
>>
>
> Yes, that should be fine.
>
>> >
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0It seems to me that moving the file=
 to the end of the
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list here would make more sense. IO=
W, we should only do
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that if it turned out not to be rec=
laimable. Right?
>>
>> But the problem would remain. =A0We are reclaiming without lock
>> so we have to consider the possibility that reclaim could fail, so
>> list move could fail if the next element has become stale/invalid.
>>
>
> No -- if the reclaim fails, you go to refind_writable and start
> walking the list all over again from the head. Once you drop the
> spinlock you *must* do that regardless of whether you moved this entr=
y
> or not. You don't know if other threads have modified it while you no
> longer hold the lock.
>
> The idea with moving this to the end is that you want to avoid pickin=
g
> the same FID over and over again in the event that it's unreclaimable=
,
> while there are others that could be reclaimed. There's no need to do
> that however if the file is able to be reclaimed.

Jeff, not clear yet.  What I am trying to say is, if the reclaim fails,
then, we can't reliably move the element to the end of the list
since its links are not reliable after dropping the lock.
So we do not know if the reclaim will succeedor fail, if it fails,
we can't be sure that move will not oops and so we do not take
a chance and move it before attempting reclaim.

>
>> >
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++refind;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto refind_writable;
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> >> + =A0 =A0 }
>> >> +
>> >> =A0 =A0 =A0 return NULL;
>> >> =A0}
>> >>
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
