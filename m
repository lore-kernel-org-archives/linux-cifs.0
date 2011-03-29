From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 and shared superblock model
Date: Tue, 29 Mar 2011 10:49:35 +0400
Message-ID: <AANLkTik1KuNLQYXn32ZzCC7jOyCXtMxF5dMHz903EFW9@mail.gmail.com>
References: <AANLkTikvUqYG5GnOkYnrb67B1PJa7yrhzHiWT8+KxEPO@mail.gmail.com>
	<20110326140638.77580be3@corrin.poochiereds.net>
	<AANLkTinO885tqF2No3gb4mZA9j3n6+L_yKhNf9UNZdg0@mail.gmail.com>
	<AANLkTi=nX4ZwgLY4tGgtmdxQv9s82u-PT_7GHU48fD26@mail.gmail.com>
	<AANLkTine8fE2JXS4NEnNhNy1OeeYi+dhVKx3sOUevAaK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTine8fE2JXS4NEnNhNy1OeeYi+dhVKx3sOUevAaK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/3/29 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2011/3/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> On Mon, Mar 28, 2011 at 1:50 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>> 2011/3/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>>> On Sat, 26 Mar 2011 16:12:03 +0300
>>>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>>> Hi!
>>>>>
>>>>> Today I investigated a bit about how to insert sharedblock model =
into
>>>>> cifs and get it work correctly with smb2.1 leases. Now we have th=
e
>>>>> following archtecture:
>>>>> inode -> superblock -> tlink -> tcon -> sess -> srv - so we can
>>>>> definitely say what ses id and tree id we should use for a reques=
ted
>>>>> inode. It's from the one hand.
>>>>>
>>>>> From another hand, we should share cached data between several
>>>>> sessions from the same client (according to SMB2 spec we should h=
ave
>>>>> one global file table). And everything is good if we will share
>>>>> superblock between several mounts that uses the same sess id and =
tcon
>>>>> id. But if these are different sessions that's brings a problem. =
A
>>>>> superblock is linked to only one tcon id and sess id but we need =
to
>>>>> share it between completely different sessions. So, it seems to m=
e
>>>>> that according to nowadays situation we can't share the same data
>>>>> between different sessions.
>>>>>
>>>>> So, now I suggest to share a superblock only between different mo=
unts
>>>>> of the same sess id and tcon id. And every time we negotiate a
>>>>> different session (e.x. from another username) we should change
>>>>> ClientGUID. It causes the server to think that these are differen=
t
>>>>> clients and it won't grant leases on parallel opens from these
>>>>> sessions. So, in this case we solve data coherency problem but, o=
f
>>>>> course, miss some advantages of SMB2 protocol.
>>>>>
>>>>> Your comments/thoughts?
>>>>>
>>>>
>>>> That's not quite correct...
>>>>
>>>> A superblock can point to more than one tcon in the multiuser moun=
t
>>>> case. That's the whole reason for the tlink structure in the first
>>>> place.
>>>>
>>>> The reason for a shared superblock is that you intend to mount the
>>>> exact same data in multiple places and don't intend to bind mount.=
 With
>>>> NFS for instance, consider the case where you do something like th=
is:
>>>>
>>>> =A0 =A0# mount server:/export /mount1
>>>> =A0 =A0# mount server:/export/subdir /mount2
>>>>
>>>> Suppose then that you access these files:
>>>>
>>>> =A0 =A0/mount1/subdir/file1
>>>> =A0 =A0/mount2/file1
>>>>
>>>> Traditionally, that would give you two different inodes connected =
to
>>>> two different superblocks. Cache consistency can easily be off, yo=
u end
>>>> up with duplicate data in cache, and dealing with fscache is
>>>> problematic since you can end up with collisions in the cache.
>>>>
>>>> To fix that (mostly for the fscache problem), David Howells conver=
ted
>>>> NFS so that it would share superblocks in this situation. The two
>>>> vfsmounts point to the same superblock, but the root dentry is dif=
ferent
>>>> for each.
>>>>
>>>> So...what does this mean for CIFS? We already look for an existing
>>>> server, session and tcon when we mount. To do this for CIFS you wo=
uld
>>>> simply need to go a step farther and look for an existing superblo=
ck
>>>> that matches your needs and deal with setting up the root dentry
>>>> correctly.
>>>>
>>>> I urge you to have a look at what NFS does in this case. It's
>>>> non-trivial but that is probably the best model for doing this in =
CIFS.
>>>>
>>>> Here's the catch though...you now have to deal with all of the CIF=
S
>>>> mount options and decide which settings mean that you need to crea=
te a
>>>> new superblock instead of using an existing one on a new mount.
>>>>
>>>> --
>>>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>
>>>
>>> So, I suggest to do the following - before we get a superblock we
>>> should figure out what structures we can share:
>>> 1) try to share tcp_sesion;
>>> 2) if succeed - try to share smb_session;
>>> 3) if succeed - try to share tcon;
>>> 4) if succeed - share a sb which tcon points to.
>>>
>>> So, in this case there is no need to use sget call with 'compare' a=
nd
>>> 'set' callbacks like NFS does it, I think.
>>>
>>> As for multiuser mode - It won't bring complexity because in this c=
ase
>>> we don't touch its code.
>>
>> At a high level, your description above makes sense, but the
>> details can get tricky. =A0In practice some differences
>> in mount options etc. are not "disqualifying" when trying to
>> share a superblock or tcon but it we have to consider
>> the options one by one.
>>
>>
>
> I agree with this. I also want to say that every time when we can't
> share superblock we should change ClientGUID to let the server think
> that these are different clients and the server shouldn't grant RWH
> lease for both of them (because they have different caches due to
> different superblocks).
>

I looked at the spec ([MS-SMB2].pdf, page 125) and found out that we
should use different LeaseKey for the same files in these cases and
don't change ClientGUID. I think we can simply generate new LeaseKey
value for every inode in alloc_inode or, like the spec suggests, when
we open it first time in cifs_open/cifs_create.

--=20
Best regards,
Pavel Shilovsky.
