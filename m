From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Replace cifs md5 hashing functions with kernel
 crypto APIs
Date: Fri, 21 Jan 2011 12:13:41 -0600
Message-ID: <AANLkTi=tcnBinjoKf8St7jbbrnPTv__fZme4bwp408nL@mail.gmail.com>
References: <1295622245-10581-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110121104228.60262dd2@tlielax.poochiereds.net>
	<AANLkTim3b8TFYYV5dcpOi4DtoLBz1XqdOOt6fTYB88uU@mail.gmail.com>
	<4D39BD64.5080101@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D39BD64.5080101-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jan 21, 2011 at 11:07 AM, Stefan (metze) Metzmacher
<metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Shirish,
>
>>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>
>>>> Replace remaining use of md5 hash functions local to cifs module
>>>> with kernel crypto APIs.
>>>> Remove header and source file containing those local functions.
>>>>
>>>>
>>>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>> ---
>>>> =A0fs/cifs/Makefile =A0 =A0 =A0| =A0 =A02 +-
>>>> =A0fs/cifs/cifsencrypt.c | =A0 =A01 -
>>>> =A0fs/cifs/link.c =A0 =A0 =A0 =A0| =A0 59 +++++++--
>>>> =A0fs/cifs/md5.c =A0 =A0 =A0 =A0 | =A0366 ------------------------=
-------------------------
>>>> =A0fs/cifs/md5.h =A0 =A0 =A0 =A0 | =A0 38 -----
>>>> =A0fs/cifs/smbencrypt.c =A0| =A0 =A01 -
>>>> =A06 files changed, 51 insertions(+), 416 deletions(-)
>>>> =A0delete mode 100644 fs/cifs/md5.c
>>>> =A0delete mode 100644 fs/cifs/md5.h
>>>>
>>>
>>> Very nice. The CIFS parts look good to me, and I'm always fond of
>>> reducing the code we need to support as well as the cifs.ko footpri=
nt.
>>> Assuming that mfsymlink support still works after this patch...
>>
>> I did test briefly, e.g. creating symlinks and deleting them.
>> Hoping Stefan Metzmacher will comment.
>> I did verify that the (md5) hash value was different for different a=
ctualpaths
>
> Just test with and without your changes, create symlinks with both
> versions which point to
> the same target. And verify you can use them with both.
> Then you can mount without mfsymlink support and verify that the
> lowlevel file
> has the same md5sum.
>
> metze
>
>

metze, Thanks. I think the patch is working.

cifsa.nopatch and cifsa.patch were created as symlinks using mount
option mfsymlinks
without and with this patch respectively.

 # mount -t cifs //<server_name>/<share_name> /mnt/smb_c -o
user=3D<user>,pass=3D<password>

# md5sum /mnt/smb_c/cifsa.nopatch
d1077212b3a759439645e1fee8d6a268  /mnt/smb_c/cifsa.nopatch

# md5sum /mnt/smb_c/cifsa.patch
d1077212b3a759439645e1fee8d6a268  /mnt/smb_c/cifsa.patch

I tried this with another actualpath file and md5sum of both the
created symlinks (with
and without the patch) is same.
