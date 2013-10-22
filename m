From: Steve French <smfrench@gmail.com>
Subject: Fwd: 3.11+ Problem with cifs links, bisected
Date: Tue, 22 Oct 2013 13:46:08 -0500
Message-ID: <CAH2r5mt4xj325suAy9=ToWJu0Obo2rj8AN5kBEE2W28CfhobCw@mail.gmail.com>
References: <CACG0VPU5zDrYgv99Uk9SEc-+_kh2nOOBBeC14kUf+KhCoy5VtA@mail.gmail.com>
	<CAH2r5msBqBiNqg=GGPnc8h1XxFjKPyAagrEFNWL70tUxYkM6PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: LKML <linux-kernel@vger.kernel.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5msBqBiNqg=GGPnc8h1XxFjKPyAagrEFNWL70tUxYkM6PQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

---------- Forwarded message ----------
From: Steve French <smfrench@gmail.com>
Date: Tue, Oct 22, 2013 at 1:45 PM
Subject: Re: 3.11+ Problem with cifs links, bisected
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Shilovsky
<pshilovsky@samba.org>, Jeff Layton <jlayton@redhat.com>


I wonder if this is a similar issue to what I fixed with
(Pavel's patch assumed that these reparse points
were NTFS symlinks but they could be other types
of reparse points such as the new "NFS symlink"
format)

commit c31f330719b7331b2112a5525fe5941a99ac223d
Author: Steve French <smfrench@us.ibm.com>
Date:   Sat Sep 28 18:24:12 2013 -0500

    do not treat non-symlink reparse points as valid symlinks

    Windows 8 and later can create NFS symlinks (within reparse points)
    which we were assuming were normal NTFS symlinks and thus reporting
    corrupt paths for.  Add check for reparse points to make sure that
    they really are normal symlinks before we try to parse the pathname.

    We also should not be parsing other types of reparse points (DFS
    junctions etc) as if they were a  symlink so return EOPNOTSUPP
    on those.  Also fix endian errors (we were not parsing symlink
    lengths as little endian).

    This fixes commit d244bf2dfbebfded05f494ffd53659fa7b1e32c1
    which implemented follow link for non-Unix CIFS mounts

    CC: Stable <stable@kernel.org>
    Reviewed-by: Andrew Bartlett <abartlet@samba.org>
    Signed-off-by: Steve French <smfrench@gmail.com>





On Tue, Oct 22, 2013 at 8:12 AM, Joao Correia
<joaomiguelcorreia@gmail.com> wrote:
>
> Hello list
>
> I've been having a problem mounting windows shares with deduplicated
> files (from windows 2012 deduplication), as they would show up either
> garbled or 'ls' would complain it couldn't follow them.
>
> Git bisect blames the following:
> commit b42bf88828cde60772dc08201d0a4f1a0663d7bc
> CIFS: Implement follow_link for SMB2
> Author: Pavel Shilovsky <pshilovsky@samba.org>
>
> dmesg doesn't complain at all.
>
> Reverting the commit fixes the problem and the deduplicated files can
> be opened perfectly, but more recent updates have been made on top of
> that one and i think it can't be cleanly reverted on current -next
> trees (or rcs)
>
> If i'm not mistaken, windows 2012 treats deduplicated files as links,
> but that's just what i can surmise from using it, i haven't read
> anything about it's internals yet.
>
> I've CC'ed the persons mentioned on the patch, please forward it to
> anyone else that might be interested and is not on the lkml.
>
> Thanks,
> Joao Correia




-- 
Thanks,

Steve



-- 
Thanks,

Steve
