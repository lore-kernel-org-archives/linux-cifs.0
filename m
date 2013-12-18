From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounting error after upgrading to wheezy - Changes in mount.cifs
 from 4.5 to 5.5?
Date: Wed, 18 Dec 2013 10:51:07 -0600
Message-ID: <CAH2r5mv3yChbfKm0QBBZ=LymBx7Ssw6J_RmVMZQ1LJ8uDjLBuA@mail.gmail.com>
References: <8f517d28f1398f0410e66e30d0aadd5a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8f517d28f1398f0410e66e30d0aadd5a@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I doubt that the sec=3Dntlm would make much of a difference but would b=
e
interesting to see what the access denied is coming back on - since
from what you describe listing the contents of the root directory of
the share should be permitted to both users so this is not an access
denied on top of prefixpath issue as we had seen a few years ago.

On Wed, Dec 18, 2013 at 7:10 AM, Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org> w=
rote:
> Hi from Munich,
> we have some special issues with the current cifs-utils (5.5) in Debi=
an
> Wheezy.
>
> A lot of our (raw) logfiles are stored on a Windows 2008 R2 fileserve=
r,
> while we use Debian to generate the reports.
>
> The share is available as
> \\fs01\Share
>
> while the logfiles can be found in special subdirs
> DepartmentA\Stats
>
> We use a seperate user "stats_user" to access the files. This user ha=
s no
> "listing-rights=93 above the final "\Stats" directory.
>
> Using Windows 7, everything works fine...
> \\fs01\Share\DepartmentA\Stats can be directly mounted to an local dr=
ive...
>
> Using cifs-utils (4.5) in Squeeze everything works fine, too!
> mount -t cifs //fs01/Share/DepartmentA/stats /mnt/DepartmentA_stats -=
o
> user=3Dstats_user,domain=3Dxy,password=3D'xyz'
> makes all files accessible from Debian.
>
> Using the same mount-command with the same user, we got a "permission
> denied".
> Retrying with a default-user (with listing-rights) the subdirectory i=
s
> mounted without any errors...
>
> Are there any big changes between 4.5 and 5.5 which can cause this er=
ror? Is
> there a solution, to avoid the issue?
>
> Thank you very much
>
> Philipp
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
