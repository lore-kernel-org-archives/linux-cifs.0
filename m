From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: "CIFS VFS: SMB response too short (9 bytes)" when copying data
 from CIFS mount
Date: Tue, 29 Sep 2015 11:21:25 -0500
Message-ID: <CAH2r5ms0bbkhy_D4tRXqwN2nH5vyBH9Q0OrCTV7cm93=P3fgRw@mail.gmail.com>
References: <1936200018.81178.1443479619664.JavaMail.zimbra@xes-inc.com>
 <1731839987.81462.1443479968995.JavaMail.zimbra@xes-inc.com>
 <CAH2r5mvsZJ3Nn45Fqjhc8nd-PZZ_KYJxsPg19v7DCpkuMb1OLg@mail.gmail.com> <1744736878.52548.1443542655076.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1744736878.52548.1443542655076.JavaMail.zimbra-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It sounds pretty straightforward if both wireshark and the Linux
kernel client agree and say that this old Samba server sent a
malformed response (presumably a CIFS ReadX response).  Note that this
is an old version of Samba server - Samba 3.6 was released more than 4
years ago.

Try turning off unix extensions on the mount and/or setting rsize
smaller (which might change the behavior of the Samba server read
response).  So try
1) adding something like "rsize=60000" to the options you pass to the
mount command
2) and as a different experiment try mounting with "nounix" to disable
CIFS unix extensions which would also have the affect of reducing the
maximum read size
3) another option to try is to set max protocols in the server's
smb.conf to enable SMB2.0 support and try "vers=2.0" on mount

My guess is that the bug is related to large CIFS read processing in
this old version of Samba.

I also want to --- strongly --- encourage upgrade from Samba 3.6.3 to
at least Samba 4.1 (I use Samba 4.3).  The additional security
features and capabilities which SMB2.1 and SMB3 bring (not just the
new protocol features and improved performance) are VERY helpful and
very important for security.

On Tue, Sep 29, 2015 at 11:04 AM, Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org> wrote:
> ----- Original Message -----
>> From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> To: "Andrew Martin" <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Sent: Monday, September 28, 2015 6:32:51 PM
>> Subject: Re: "CIFS VFS: SMB response too short (9 bytes)" when copying data from CIFS mount
>>
>> It is possible that it is a cifs client bug or a server bug but hard
>> to tell without seeing the trace.  Obviously the client message
>> indicates that the SMB response from the server was invalid (malformed
>> due to server bug) but hard to prove that without looking at a network
>> trace.  See the mention of wireshark at
>>
>> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>>
>>
>> Also it may be better for many use cases to mount with SMB3
>> ("vers=3.0") rather than the ancient cifs dialect (unless the server
>> is Samba where there are "posix extensions" that the client can take
>> advantage of).
>>
>> What is the server version?
>>
> Steve,
>
> The server is Ubuntu 12.04 with Samba 3.6.3, so I am limited to vers=1.0.
> I attempted to pass vers=2.0 (since it looks like basic SMB2 support was
> available in Samba 3.6.3), however it failed to mount with this error:
> mount error(112): Host is down
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> Looking at the Wireshark capture when the "SMB response too short" message
> is being printed, I see the following queries sent before the malformed
> packet:
>
> <client>        <server>        SMB     268     Trans2 Request, QUERY_PATH_INFO, Query File Unix Basic, Path: /path/to/file.txt
> <server>        <client>        SMB     230     Trans2 Response, QUERY_PATH_INFO
> <client>        <server>        SMB     129     Read AndX Request, FID: 0x3134, 131022 bytes at offset 262144
> <server>        <client>        SMB     79      [Malformed Packet] - Expert Info (Error/Malformed): Malformed Packet (Exception occurred)
>
> The server's samba log for the client during this period:
> http://pastebin.com/Y0diqhGY
>
> I also set /proc/fs/cifs/cifsFYI to 7 and captured the following output:
> http://pastebin.com/CfPUtBQg
>
> Note that the Samba share definition is as follows:
> http://pastebin.com/0aVCaRJH
>
> Thanks,
>
> Andrew



-- 
Thanks,

Steve
