From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Any interest in inotify messages via netlink.
Date: Sat, 24 Dec 2011 22:17:06 +0100
Message-ID: <CANXojcw0i_pRBZmc_y1wDtXqdRK5TnQHKoroxqhQxPiuLwwjHA@mail.gmail.com>
References: <CANXojcycznnzbzrM8eX19b6hEDwzQ29MMTOedAGDCXX=HRqPFQ@mail.gmail.com>
	<CAH2r5muSWtexaKuEj+Aa9B1nYyq9AXnoTNNVpY+Ek9PbjrU8bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muSWtexaKuEj+Aa9B1nYyq9AXnoTNNVpY+Ek9PbjrU8bA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm afraid we're not speaking about the same.

I know SMB supports already inotify like calls (SMB Change request)
but my question is whether netlink messages, about a inotify being set
(or removed) on the cifs filesystem, is of any use to you.

=46or FUSE fs's I'm experminting with this, in the way I described in m=
y
previous post.

Stef

2011/12/24 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Cifs (the protocol) supports inotify-like messages (the original conc=
ept was
> invented for os2 and windows desktop guis to use smb/cifs to refresh =
remote
> directory listings). With directory oplock added in Smb2.2 so
>
> On Dec 24, 2011 4:22 AM, "Stef Bon" <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Hi,
>>
>> earlier I mentioned here I'm working on the ability for filesystems
>> like FUSE based, cifs and nfs.
>>
>> Recently I've created a patch for the kernel, which makes the calls
>> inotify_add_watch and inotify_remove_watch
>> send a message to userspace, containing (pid, fd, wd, [mask], [path]=
).
>>
>> (in case of add watch the values between [] are sent also, when remo=
ve
>> not)
>>
>> My idea for a FUSE based fs is to listen to this messages (familiy
>> GENERIC, group VFS_INOTIFY),
>> filter messages out which do not apply (only those messages for the
>> used mountpoint for fs) and then let the FUSE fs take proper action,
>> which suits the backend.
>>
>> In case of a simple overlay fs, this means that it sets watch on the
>> underlying fs, and send change events (which fits the mask) to the
>> kernel. Recent FUSE versions have calls added which can notify the
>> kernel about a change, without the need of a related request, like
>> getattr, open, lookup etc.
>> The fs has to remove this/stop this when a remove watch message is
>> received. A proper adiminstration of current watches set is required=
=2E
>>
>>
>> Can this also work for cifs?? I always thought that cifs is just lik=
e
>> FUSE in userspace, but that isn't the case is it?
>>
>> Stef
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
