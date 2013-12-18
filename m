From: Philipp Flesch <philipp-3cc/OM5pcIkb1SvskN2V4Q@public.gmane.org>
Subject: Mounting error after upgrading to wheezy - Changes in mount.cifs
 from 4.5 to =?UTF-8?Q?=35=2E=35=3F?=
Date: Wed, 18 Dec 2013 14:10:17 +0100
Message-ID: <8f517d28f1398f0410e66e30d0aadd5a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi from Munich,
we have some special issues with the current cifs-utils (5.5) in=20
Debian Wheezy.

A lot of our (raw) logfiles are stored on a Windows 2008 R2=20
fileserver, while we use Debian to generate the reports.

The share is available as
\\fs01\Share

while the logfiles can be found in special subdirs
DepartmentA\Stats

We use a seperate user "stats_user" to access the files. This user has=20
no "listing-rights=E2=80=9C above the final "\Stats" directory.

Using Windows 7, everything works fine...
\\fs01\Share\DepartmentA\Stats can be directly mounted to an local=20
drive...

Using cifs-utils (4.5) in Squeeze everything works fine, too!
mount -t cifs //fs01/Share/DepartmentA/stats /mnt/DepartmentA_stats -o=20
user=3Dstats_user,domain=3Dxy,password=3D'xyz'
makes all files accessible from Debian.

Using the same mount-command with the same user, we got a "permission=20
denied".
Retrying with a default-user (with listing-rights) the subdirectory is=20
mounted without any errors...

Are there any big changes between 4.5 and 5.5 which can cause this=20
error? Is there a solution, to avoid the issue?

Thank you very much

Philipp
