From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] common: enable tests that require scratch device on CIFS
Date: Wed, 12 Nov 2014 17:26:13 -0600
Message-ID: <CAH2r5mtCPVt7+fyCjvDrLtOSzX1-+YQ_ZPhyU5gjFP7c1DJFKw@mail.gmail.com>
References: <1415617191-17246-1-git-send-email-eguan@redhat.com>
 <CAH2r5muXH7HSoM0TQUsPXq1RM-dLdZSfzuOKK1zZdKe0OANAhg@mail.gmail.com> <20141110160309.GI2863@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141110160309.GI2863-Y5OA6DF/u0kMsqdw6vYspB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I get newly enabled test 294 passing on cifs mounts to Samba.

What is best way to get the mount options passed to the mount of
scratch dev so it doesn't prompt for it?

(seems to ignore the mount options in TEST_FS_MOUNT_OPTS so prompts
multiple times for password of scratch mount)

On Mon, Nov 10, 2014 at 10:03 AM, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Nov 10, 2014 at 09:32:34AM -0600, Steve French wrote:
>> Failures: generic/035 generic/074 generic/120 generic/184 generic/192
>> generic/193 generic/215 generic/237 generic/258 generic/294
>> generic/306 generic/307 generic/313 generic/317 generic/319
>>
>> Test 258 is a Samba server bug (and does work to Windows server).  074
>> and 215 are passing for me for both CIFS and SMB3, 035 was only
>> failing for SMB2/SMB3 (and NFS) for me, not CIFS
>
> generic/074 is passing for me too now.
>
> generic/215 fails like:
> --- tests/generic/215.out       2013-10-19 01:23:10.352848003 +0800
> +++ /root/xfstests/results//generic/215.out.bad 2014-11-10 23:59:41.619045914 +0800
> @@ -5,4 +5,6 @@
>  4096+0 records out
>
>  writing via mmap
> +FAIL: mtime not update after mapped write
> +FAIL: ctime not update after mapped write
>  *** done
>
>> Test 184 passes to Samba, but requires "sfu" (mount.cifs mount option)
>> if mounting with SMB2/SMB3 or mounting to Windows (in order to emulate
>> FIFO and device files)
>>
>> 192 and 193 and 313 are time stamp related problems.
>>
>> Are you using at least 3.17 kernel?  We put various fixes in 3.17 to
>> address problems fsx pointed out.
>
> Yes, I'm using 3.18-rc2+ kernel.
>
> Thanks,
> Eryu



-- 
Thanks,

Steve
