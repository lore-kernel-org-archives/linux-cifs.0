From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Status of SMB3?
Date: Mon, 20 Oct 2014 12:33:56 -0500
Message-ID: <CAH2r5mvFN20Z_vRzcpFtJR5w3qwjZxfWSrpbRqoHsc9Lqr3NsQ@mail.gmail.com>
References: <54453BD8.6040504@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54453BD8.6040504-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a great question to explore now that significant SMB3
improvements have gone into 3.17.

SMB3 stability is much improved recently, in part due to the focus on
automated xfstesting over the past
months.   In addition, it is much more posix compatible now.

High level view:
- SMB3 generally stable
- SMB3 security is better than most alternatives (although finishing
up krb5 support would help, and SMB3.1 looks like it will be better
still when it is announced)
- SMB3 (thanks to Pavel's improvements this summer) is faster for
large file read/write than most alternatives.
- SMB3 is getting better at full posix compliance/emulation but not as
posix compliant as cifs dialect (with Unix extensions in the protocol)
was to Samba, but about as compliant as cifs was to Windows.
      - SMB3 can now do emulated symlinks (mfsymlinks) similar to
Apple (the "Minshall-French" style symlinks)
      - SMB3 now remaps the 7 reserved POSIX characters by default
(similar to Windows "SFM" and Apple, no need to do "mapchars" unless
you have legacy filenames created with this mount option which has :
or ? or < > )
      - SMB3 can do emulated fifo and device files (with "sfu" mount option)
- SMB3 can not retrieve posix mode bits from the ACL (yet) so would
love help finishing this off, Shirish was looking at it too) ala the
"cifsacl" mount option (which only works on cifs mounts)
- SMB3 can not do extended attributes (yet)


Known problems:
xfstests has about 10 failures (not counting a few server bugs we
found) shown when run with SMB3 mounts:
- 3 due to the wrong return code returned on rename of directory tree
onto an existing directory tree (was looking at adding an
"smb3_rename_pending_delete" helper function as cifs has to see if
that would help any of those)
- 2 or 3 relating to minor fix needed to fallocate support (to clear
local copy of pages on zero page fallocate)
- 2 due to timestamp caching
- 2 due to lack of posix mode emulation (posix permissions not
available until cifsacl mount option finished)

Performance:
- better than alternatives for large file i/o
- SMB2.1 and SMB3 leases are better than cifs oplocks which helps in
some long running i/o cases due to the improved caching
- chattier and slower than cifs for stat and readdir (SMB3 does
open/query/close instead of cifs's querypathinfo - 3 operations
instead of one).  This could be improved with better operation
compounding and some additional deferred close features.
- The copy offload and even the set compression (chflags/chattr +C)
can help - but the copy offload ioctl needs a little userspace copy
util to call it (for fast server side copy offload when source and
target are on the same server) as cifs.ko doesn't use the btrfs
refcopy ioctl number for copy offload.
- slower than cifs for most metadata heavy workloads - but could be
improved to be much better than cifs (implementing SMB3 directory
leases would be helpful)
- finishing SMB3 multichannel (and RDMA) would be a big help for
certain network constrained workloads
- SMB3 packet signing should be pretty fast compared to alternatives

SMB3 Unique Features
--------------------------------
Encrypted shares (would be useful to add and shouldn't be too hard)
Durable handles (implemented), Persistent Handles (not implemented yet)
Improved failover and Witness protocol would be very useful to add

Overall - SMB3 could become the optimal file transfer mechanism for
many more workloads with a few key improvements, but currently (3.17)
is quite good for large i/o and reasonably stable, and more secure for
some common use cases.

On Mon, Oct 20, 2014 at 11:44 AM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:
> I notice at least some support for SMB3 in the 3.17 kernel.
>
> Any idea how complete SMB3 support is?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
