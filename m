From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: 3.11+ Problem with cifs links, bisected
Date: Wed, 23 Oct 2013 17:25:23 +0400
Message-ID: <CAKywueRsvO7mpJ1B6wUJgEGceQ-7wWyk7wtLZQKbTnx3yWns=Q@mail.gmail.com>
References: <CACG0VPU5zDrYgv99Uk9SEc-+_kh2nOOBBeC14kUf+KhCoy5VtA@mail.gmail.com>
	<CAH2r5msBqBiNqg=GGPnc8h1XxFjKPyAagrEFNWL70tUxYkM6PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Joao Correia <joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msBqBiNqg=GGPnc8h1XxFjKPyAagrEFNWL70tUxYkM6PQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/10/22 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I wonder if this is a similar issue to what I fixed with
> (Pavel's patch assumed that these reparse points
> were NTFS symlinks but they could be other types
> of reparse points such as the new "NFS symlink"
> format)
>
> commit c31f330719b7331b2112a5525fe5941a99ac223d
> Author: Steve French <smfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> Date:   Sat Sep 28 18:24:12 2013 -0500
>
>     do not treat non-symlink reparse points as valid symlinks
>
>     Windows 8 and later can create NFS symlinks (within reparse points)
>     which we were assuming were normal NTFS symlinks and thus reporting
>     corrupt paths for.  Add check for reparse points to make sure that
>     they really are normal symlinks before we try to parse the pathname.
>
>     We also should not be parsing other types of reparse points (DFS
>     junctions etc) as if they were a  symlink so return EOPNOTSUPP
>     on those.  Also fix endian errors (we were not parsing symlink
>     lengths as little endian).
>
>     This fixes commit d244bf2dfbebfded05f494ffd53659fa7b1e32c1
>     which implemented follow link for non-Unix CIFS mounts
>
>     CC: Stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Reviewed-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
>
>
>
> On Tue, Oct 22, 2013 at 8:12 AM, Joao Correia <joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
>>
>> Hello list
>>
>> I've been having a problem mounting windows shares with deduplicated
>> files (from windows 2012 deduplication), as they would show up either
>> garbled or 'ls' would complain it couldn't follow them.
>>
>> Git bisect blames the following:
>> commit b42bf88828cde60772dc08201d0a4f1a0663d7bc
>> CIFS: Implement follow_link for SMB2
>> Author: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>> dmesg doesn't complain at all.
>>
>> Reverting the commit fixes the problem and the deduplicated files can
>> be opened perfectly, but more recent updates have been made on top of
>> that one and i think it can't be cleanly reverted on current -next
>> trees (or rcs)
>>
>> If i'm not mistaken, windows 2012 treats deduplicated files as links,
>> but that's just what i can surmise from using it, i haven't read
>> anything about it's internals yet.
>>
>> I've CC'ed the persons mentioned on the patch, please forward it to
>> anyone else that might be interested and is not on the lkml.
>>

Joao, thank you for reporting the problem!

Steve, I think you are right and it's almost the same issue as the NFS
one that you fixed recenty. Now I started to think that the initial
approach of marking everything with ATTR_REPARSE as a symlink is
wrong. We need to distinguish symlinks and other types like junction,
deduplicated files, NFS symlinks. The reason is that the latter can be
accessed through reparse points without any other activity from the
client side. On another hand the symlinks can not be accessed through
reparse points and have to be parsed manually.

So, we need to figure out whether it is a symbolic link or not when we
face with ATTR_REPARSE attribute. At first, I think we should mark
such dentries as NEED_REVAL in readdir to let us investigate them
further (as it is done for DFS shares and junctions for now). As the
second step we should move to "Open - QueryFidInfo - Close" mechanism
of querying file attributes rather than "QueryPath" for CIFS because
"QueryPath" succeeds for all types of reparse points but "Open" will
fail on a symbolic link with STATUS_STOPPED_ON_SYMLINK error code.
SMB2 and SMB3 protocol already use open-query-close mechanism too.

The possibility to determine whether is is symbolic link or not lets
us mark a dentry as a unix symbolic link or not.

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
