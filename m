From: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: "CIFS VFS: SMB response too short (9 bytes)" when copying data
 from CIFS mount
Date: Wed, 30 Sep 2015 17:03:31 -0500 (CDT)
Message-ID: <944083651.87203.1443650611671.JavaMail.zimbra@xes-inc.com>
References: <1936200018.81178.1443479619664.JavaMail.zimbra@xes-inc.com> <1731839987.81462.1443479968995.JavaMail.zimbra@xes-inc.com> <CAH2r5mvsZJ3Nn45Fqjhc8nd-PZZ_KYJxsPg19v7DCpkuMb1OLg@mail.gmail.com> <1744736878.52548.1443542655076.JavaMail.zimbra@xes-inc.com> <CAH2r5ms0bbkhy_D4tRXqwN2nH5vyBH9Q0OrCTV7cm93=P3fgRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms0bbkhy_D4tRXqwN2nH5vyBH9Q0OrCTV7cm93=P3fgRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



----- Original Message -----
> From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: "Andrew Martin" <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "samba-technical" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
> Sent: Tuesday, September 29, 2015 11:21:25 AM
> Subject: Re: "CIFS VFS: SMB response too short (9 bytes)" when copying data from CIFS mount
> 
> It sounds pretty straightforward if both wireshark and the Linux
> kernel client agree and say that this old Samba server sent a
> malformed response (presumably a CIFS ReadX response).  Note that this
> is an old version of Samba server - Samba 3.6 was released more than 4
> years ago.
> 
> Try turning off unix extensions on the mount and/or setting rsize
> smaller (which might change the behavior of the Samba server read
> response).  So try
> 1) adding something like "rsize=60000" to the options you pass to the
> mount command
> 2) and as a different experiment try mounting with "nounix" to disable
> CIFS unix extensions which would also have the affect of reducing the
> maximum read size
> 3) another option to try is to set max protocols in the server's
> smb.conf to enable SMB2.0 support and try "vers=2.0" on mount
> 
> My guess is that the bug is related to large CIFS read processing in
> this old version of Samba.
> 
> I also want to --- strongly --- encourage upgrade from Samba 3.6.3 to
> at least Samba 4.1 (I use Samba 4.3).  The additional security
> features and capabilities which SMB2.1 and SMB3 bring (not just the
> new protocol features and improved performance) are VERY helpful and
> very important for security.
> 
Steve,

It looks like using either "nounix" or "rsize=60000" fixes the read error!
I will also look into upgrading to Samba 4.1 ASAP - I would like to take
advantage of the security and performance improvement of a more modern
SMB protocol. Thanks again!

Andrew
