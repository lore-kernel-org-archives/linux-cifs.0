From: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Subject: "CIFS VFS: SMB response too short (9 bytes)" when copying data from
 CIFS mount
Date: Mon, 28 Sep 2015 17:39:29 -0500 (CDT)
Message-ID: <1731839987.81462.1443479968995.JavaMail.zimbra@xes-inc.com>
References: <1936200018.81178.1443479619664.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1936200018.81178.1443479619664.JavaMail.zimbra-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I have tested this setup on Ubuntu 14.04 using 3.13.0-32-generic and
3.19.0-28-generic with the same results (cifs-utils 6.0 in both cases). I have a
CIFS mountpoint set up on the server with the following options:
ro,relatime,vers=1.0,cache=strict,username=myusername,domain=EXAMPLE,uid=0,noforceuid,gid=0,noforcegid,addr=192.168.1.4,unix,posixpaths,serverino,acl,rsize=1048576,wsize=65536,actimeo=1 0 0

I am then using rsync to sync data from the mountpoint to a local directory. 
Shortly after starting rsync, I see dmesg fill up with this message repeated 
hundreds of times:
CIFS VFS: SMB response too short (9 bytes)

At this point, if I watch the df output I see that no new data is being synced 
locally. If I strace the rsync process, this sometimes makes rsync continue 
syncing data for a minute or two, but eventually it stops again. Note that I 
encountered this same issue a few months ago using perl:
http://permalink.gmane.org/gmane.linux.kernel.cifs/10640

What can I do to debug this? Is there a bug in the CIFS kernel driver?

Thanks,

Andrew Martin
