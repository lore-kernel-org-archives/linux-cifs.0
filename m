From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: file truncation on newer linux-cifs versions
Date: Fri, 13 Jan 2012 17:41:42 -0600
Message-ID: <CAH2r5mtPmN6FSEKfodYTZm7sKDSh+R1rEkVqUi_Q-D2qY=8ABg@mail.gmail.com>
References: <20120113230701.GA3100@gwdu05.gwdg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mscholz5-2/1ofaGcC4w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120113230701.GA3100-b2CffKLTPqzm5j4aBFDdOg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Generally would be useful to see a wireshark trace so we can compare
the log output with it - and the version of the cifs kernel client
(kernel version "cat /proc/version" and/or modinfo cifs.ko to show the
cifs version) and server version - on the client "cat
/proc/fs/cifs/DebugData should show the server version which it
reported on the session establishment).   May be useful to track this
info in samba bugzilla in cifsfs component if you verify the bug is
real.

On Fri, Jan 13, 2012 at 5:07 PM, Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org> wrote:
>
> Hello,
>
> with linux' cifs implementation I experience file truncation when
> talking to our institute's file server [1]
>
> % rm -f zero*
> % dd if=3D/dev/zero of=3Dtest-64 bs=3D64k count=3D1
> % dd if=3D/dev/zero of=3Dtest-65 bs=3D65k count=3D1
> dd: closing output file `test-65': No space left on device
> i.e. close(2) returns ENOSPC
> % ls -l test*
> -rw------- 1 =A0 65536 Jan 13 22:43 test-64
> -rw------- 1 =A0 65536 Jan 13 22:43 test-65
>
> The problem does not occur in Debian Squeeze (confirmed with vanilla
> v2.6.32). =A0Also checked with our IT guys that there is no real quot=
a
> applied. =A0The above error occurs in current Testing [2] (i.e. patch=
ed 3.1.0
> and current vanilla HEAD v3.2.0+).
>
> I haven't seen anything suspicious in a tcpdump (I mean the Close
> Response, which I guess should be responsible for the quota right?, l=
ooks
> similar). =A0The dmesg with echo 7 > /proc/fs/cifs/cifsFYI for both c=
ases
> you may find at http://www.gwdg.de/~mscholz5/cifs-problem/3.0.0+
> (from a run of git bisect I am currently in it is from a v3.0.0+)
>
> I'd appreciate any suggestions for additional information you might n=
eed
>
> Mirko
>
>
> [1] OS=3D[BlueArc Mercury 8.1.2350.22] Server=3D[BlueArc Mercury 8.1.=
2350.22]
> mounted via mount.cifs
> [2] mount.cifs version: 5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
