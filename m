From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: GSOC 2015 Aspirant for Improving SMB3 protocol improvements
Date: Fri, 27 Mar 2015 13:00:51 -0500
Message-ID: <CAH2r5mtHxLQjUBMMiUSRO88jSTx5fzvY+-z3gWO_yRYKPcrEdg@mail.gmail.com>
References: <CAK25hWMTkzSun5jD_8fLzBiROoD4h8oejZQPai9rwB8WqAENOA@mail.gmail.com>
 <CAH2r5mtCp_0wYfDtksmRJvU+iWLeoXc3fLdTwNnH14aa6cF8VA@mail.gmail.com>
 <CAK25hWNaPiSMcf01t0xuedGGJK+N3qh6WcDxZx38=TQa=MRDjw@mail.gmail.com> <CAH2r5mufx2yah9GkqpogA7fM=oMKrjDh0piMD3Ym3pz2RUE-Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Saket Sinha <saket.sinha89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mufx2yah9GkqpogA7fM=oMKrjDh0piMD3Ym3pz2RUE-Wg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Note that even the small changes to implement directory leases
(oplocks) on the client should make a pretty big improvement in
performance which you could measure easily.

- updating cifs_inode_needs_reval in fs/cifs/inode.c to check for
directory leases
- and adding oplock break handling for directory leases see
fs/cifs/smb2ops.c smb2_oplock_response and cifs_oplock_break in
fs/cifs/file.c
- adding the code to request directory leases (see fs/cifs/smb2pdu.c SMB2_open)
- and maybe add a simple mount option to test it (turning on or off
directory lease support for testing)

This sounds like a pretty easily doable project for GSoC and could
make a big difference in performance

On Wed, Mar 25, 2015 at 1:16 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Mar 23, 2015 at 5:53 AM, Saket Sinha <saket.sinha89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Steve,
>>
>> This is regarding the project implementing Directory oplocks in linux
>> samba client.
>>
>> In mainline linux kernel, we have oplocks already implemented for file
>> operations. Following oplocks are present for files -
>>
>> OPLOCK_LEVEL_NONE
>> OPLOCK_LEVEL_II
>> OPLOCK_LEVEL_EXCLUSIVE
>> OPLOCK_LEVEL_BATCH
>> OPLOCK_LEVEL_LEASE
>>
>>
>>>
>>> 2) Directory oplocks:
>>> Advantage: will reduce network load a lot in some workloads, and improve performance as well.  Works with recent Windows servers (Windows 2012 and later e.g.)
>>> Disadvantage: Samba does not support it yet (although this might help drive changes to the Server and Linux VFS eventually, if we have client support).
>>>
>>
>>  Locking scheme used for directory operations is based on two kinds of
>> locks - per-inode (->i_mutex) and per-filesystem
>> (->s_vfs_rename_mutex).
>>
>>  When taking the i_mutex on multiple non-directory objects, we always
>> acquire the locks in order by increasing address.  We'll call  that
>> "inode pointer" order in the following.
>>
>>   For our purposes all operations fall in 5 classes:
>>
>>
>> 1) read access.  Locking rules: caller locks directory we are accessing.
>>
>> 2) object creation.  Locking rules: same as above.
>>
>> 3) object removal.  Locking rules: caller locks parent -> finds victim
>> ->  locks victim and calls the method.
>>
>> 4) rename() that is _not_ cross-directory.
>> Locking rules: caller locks the parent and finds source and target.
>> If target already exists, lock it.  If source is a non-directory, lock
>> it.  If that means we need to
>> lock both, lock them in inode pointer order.
>>
>> 5) link creation.
>> Locking rules: lock parent -> check that source is not a directory ->
>> lock source -> call the method.
>>
>> 6) cross-directory rename.  The trickiest in the whole bunch.
>>  Locking  rules:  lock the filesystem -> lock parents in "ancestors
>> first" order -> find source and target ->  if old parent is equal to
>> or is a descendent of target fail with -ENOTEMPTY -> if new parent is
>> equal to or is a descendent of source fail with -ELOOP -> If target
>> exists, lock it.  If source is a non-directory, lock it.  In case that
>> means we need to lock both source and target, do so in inode pointer
>> order -> call the method.
>>
>>
>> So here  we  would be attempting to implement all of these directory
>> operations, by the same oplocks that we use for file operations.
>>
>> I would request you to let me know whether my understanding is correct
>> and which task to choose to get started.
>
> Directory oplocks are likely to be an extension of the actimeo
> metadata caching on the client.
>
> Note that the kernel does not have an exact equivalent for directory
> oplocks but that does not prevent cifs.ko from returning cached inode
> data (or even cached directory leases) on directories for which we
> have been granted a read-only directory oplock.  Some of the places
> that we cache inode data are controlled by actimeo (we cache for about
> a second, a little stricter than most network file systems but this
> would allow us to cache safely for longer periods).  We will also need
> a mount option to disable directory leases (to work around a buggy
> server e.g.).
>
> Probably easiest thing to do is take two Windows machines (at least
> Windows 8 or later) and trace network traffic accessing files, listing
> directory contents in a directory (and repeating a couple of times),
> and then do the same thing to a Samba server from the same client.
> You should see differences in the number of query info calls (due to
> Windows supporting directory leases).
>
> Also FYI - I have created a status wiki page for the SMB3
> implementation in the kernel client  (although needs various
> corrections and additions)
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
