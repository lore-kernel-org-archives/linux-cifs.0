From: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: "CIFS VFS: SMB response too short (9 bytes)" when copying data
 from CIFS mount
Date: Tue, 29 Sep 2015 11:04:15 -0500 (CDT)
Message-ID: <1744736878.52548.1443542655076.JavaMail.zimbra@xes-inc.com>
References: <1936200018.81178.1443479619664.JavaMail.zimbra@xes-inc.com> <1731839987.81462.1443479968995.JavaMail.zimbra@xes-inc.com> <CAH2r5mvsZJ3Nn45Fqjhc8nd-PZZ_KYJxsPg19v7DCpkuMb1OLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvsZJ3Nn45Fqjhc8nd-PZZ_KYJxsPg19v7DCpkuMb1OLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

----- Original Message -----
> From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: "Andrew Martin" <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Monday, September 28, 2015 6:32:51 PM
> Subject: Re: "CIFS VFS: SMB response too short (9 bytes)" when copying data from CIFS mount
> 
> It is possible that it is a cifs client bug or a server bug but hard
> to tell without seeing the trace.  Obviously the client message
> indicates that the SMB response from the server was invalid (malformed
> due to server bug) but hard to prove that without looking at a network
> trace.  See the mention of wireshark at
> 
> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
> 
> 
> Also it may be better for many use cases to mount with SMB3
> ("vers=3.0") rather than the ancient cifs dialect (unless the server
> is Samba where there are "posix extensions" that the client can take
> advantage of).
> 
> What is the server version?
> 
Steve,

The server is Ubuntu 12.04 with Samba 3.6.3, so I am limited to vers=1.0.
I attempted to pass vers=2.0 (since it looks like basic SMB2 support was
available in Samba 3.6.3), however it failed to mount with this error:
mount error(112): Host is down
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Looking at the Wireshark capture when the "SMB response too short" message
is being printed, I see the following queries sent before the malformed 
packet:

<client>	<server>	SMB	268	Trans2 Request, QUERY_PATH_INFO, Query File Unix Basic, Path: /path/to/file.txt
<server>	<client>	SMB	230	Trans2 Response, QUERY_PATH_INFO
<client>	<server>	SMB	129	Read AndX Request, FID: 0x3134, 131022 bytes at offset 262144
<server>	<client>	SMB	79	[Malformed Packet] - Expert Info (Error/Malformed): Malformed Packet (Exception occurred)

The server's samba log for the client during this period:
http://pastebin.com/Y0diqhGY

I also set /proc/fs/cifs/cifsFYI to 7 and captured the following output:
http://pastebin.com/CfPUtBQg

Note that the Samba share definition is as follows:
http://pastebin.com/0aVCaRJH

Thanks,

Andrew
