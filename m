From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: password visible in 'mount' output?
Date: Tue, 31 Aug 2010 12:26:45 -0700
Message-ID: <4C7D5775.40206@candelatech.com>
References: <4C7D3620.8070204@candelatech.com> <AANLkTi=ehgG3kxv1oBpvjzmLX0TLp-W8h=h7VJDWoBOb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=ehgG3kxv1oBpvjzmLX0TLp-W8h=h7VJDWoBOb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/31/2010 11:48 AM, Steve French wrote:
>
>
> On Tue, Aug 31, 2010 at 12:04 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org
> <mailto:greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>> wrote:
>
>
>     Is password supposed to be visible in the output of 'mount' ?
>
>
> No, neither the output of mount nor /proc/mounts should display this.
> What version of mount.cifs (type "mount.cifs -V" to get the version) are
> you running?

Standard Fedora 13, as far as I can tell, and I have no mount.cifs in $PATH

[root@ct503-10G-09 lanforge]# mount -V
mount from util-linux-ng 2.17.2 (with libblkid and selinux support)
[root@ct503-10G-09 lanforge]# more /etc/issue
Fedora release 13 (Goddard)
Kernel \r on an \m (\l)

[root@ct503-10G-09 lanforge]# which mount.cifs
/usr/bin/which: no mount.cifs in 
(/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/lib64/ccache:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/xorp/sbin:/root/bin)


Password is not shown in /proc/mounts, so that part seems fine.

Thanks,
Ben

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
